<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.general.BaseBean"%><%@page import="org.apache.commons.lang.StringEscapeUtils"%><%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@ page import="weaver.general.GCONST" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%><jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" /><jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" /><jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" /><%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	BaseBean bb = new BaseBean();
	int userId = user.getUID();
	
	boolean canView = HrmUserVarify.checkUserRight("BudgetAuthorityRule:readOnly", user);//预算编制只读权限
	boolean canEdit = (HrmUserVarify.checkUserRight("FnaBudget:View", user) || 
			HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) || 
			HrmUserVarify.checkUserRight("BudgetAuthorityRule:edit", user));//财务预算维护、预算编制权限

	boolean isAllowCmpEdit = FnaBudgetLeftRuleSet.isAllowCmp(user.getUID());

	List<String> allowSubCmpIdEdit_list = new ArrayList<String>();
	boolean allowSubCmpIdEdit = FnaBudgetLeftRuleSet.getAllowSubCmpId(user.getUID(), allowSubCmpIdEdit_list);
	
	List<String> allowDepIdEdit_list = new ArrayList<String>();
	boolean allowDepIdEdit = FnaBudgetLeftRuleSet.getAllowDepId(user.getUID(), allowDepIdEdit_list);
	
	List<String> allowSubCmpIdTreeView_list_1 = new ArrayList<String>();
	if(!allowSubCmpIdEdit && allowSubCmpIdEdit_list.size() > 0){
		allowSubCmpIdTreeView_list_1 = FnaBudgetLeftRuleSet.recursiveSuperiorSubCmp(allowSubCmpIdEdit_list);
	}
	
	List<String> allowSubCmpIdTreeView_list_2 = new ArrayList<String>();
	if(!allowDepIdEdit && allowDepIdEdit_list.size() > 0){
		allowSubCmpIdTreeView_list_2 = FnaBudgetLeftRuleSet.recursiveSuperiorSubCmp_by_depIds(allowDepIdEdit_list);
	}
	
	List<String> allowDepIdTreeView_list_1 = new ArrayList<String>();
	if(!allowDepIdEdit && allowDepIdEdit_list.size() > 0){
		allowDepIdTreeView_list_1 = FnaBudgetLeftRuleSet.recursiveSuperiorDep(allowDepIdEdit_list);
	}
	
	if(canView || canEdit){
		String id = Util.null2String(request.getParameter("id2"));
		String name = Util.null2String(request.getParameter("name"));
		//String level = Util.null2String(request.getParameter("level"));
		String otherParam = Util.null2String(request.getParameter("otherParam"));
		//System.out.println("id="+id+";name="+name+";otherParam="+otherParam);
		String _searchStr_lowerCase = Util.null2String(request.getParameter("_searchStr_lowerCase"));
		
		if(!"".equals(_searchStr_lowerCase)){
			
			List depIdList = new ArrayList();
			List subCmpIdByDepList = new ArrayList();
			
			int idx = 0;
			String sql1 = "WITH allsub(id,departmentname,supdepid,canceled,subcompanyid1) \n" +
					" as ( \n" +
					" SELECT id,departmentname,supdepid,canceled,subcompanyid1 FROM HrmDepartment dep "+
					" where 1=1 \n" +
					" and departmentname like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%' \n" +
					" UNION ALL SELECT a.id,a.departmentname,a.supdepid,a.canceled,a.subcompanyid1 FROM HrmDepartment a,allsub b where a.id = b.supdepid \n" +
					" ) select distinct * from allsub tb";
			if("oracle".equals(rs2.getDBType())){
				sql1 = "select distinct dep.id, dep.departmentname, dep.supdepid, dep.canceled, dep.subcompanyid1 \n" +
					" from HrmDepartment dep\n" + 
					" start with 1=1 \n" +
					" and dep.departmentname like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%'\n" + 
					" connect by prior dep.supdepid = dep.id";
			}
			//new BaseBean().writeLog(sql1);
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				String _name = rs1.getString("departmentname");
				String _type = "d";
				int canceled = Util.getIntValue(rs1.getString("canceled"), 0);
				int supdepid = Util.getIntValue(rs1.getString("supdepid"), 0);
				int subcompanyid1 = Util.getIntValue(rs1.getString("subcompanyid1"), 0);
				
				if(!allowDepIdEdit && !allowDepIdEdit_list.contains(_id)){
					continue;
				}
				
				if(canceled == 1){
					String sql2 = "select count(*) cnt from FnaBudgetInfo a where a.organizationtype = 2 and a.budgetorganizationid = "+_id;
					rs2.executeSql(sql2);
					if(!(rs2.next() && rs2.getInt("cnt") > 0)){
						continue;
					}
					_name += "("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")";//封存
				}
				
				if(depIdList.contains(_id+"")){
					continue;
				}else{
					depIdList.add(_id+"");
				}
				
				if(subCmpIdByDepList.contains(subcompanyid1+"")){
				}else{
					subCmpIdByDepList.add(subcompanyid1+"");
				}
				
				if(idx>0){
					result.append(",");
				}
				
				String pId = "d_"+supdepid;
				if(supdepid <= 0){
					pId = "s_"+subcompanyid1;
				}
				
				result.append("{"+
					"id:"+JSONObject.quote(_type+"_"+_id)+","+
					"id2:"+JSONObject.quote(_type+"_"+_id)+","+
					"name:"+JSONObject.quote(_name)+","+
					"pId:"+JSONObject.quote(pId)+","+
					"icon:"+JSONObject.quote("")+
					"}");
				idx++;
			}

			
			//**********************************************************************************************
			List subCmpIdList = new ArrayList();

			sql1 = "WITH allsub(id,subcompanyname,supsubcomid,canceled) \n" +
				" as ( \n" +
				" SELECT id,subcompanyname,supsubcomid,canceled FROM HrmSubCompany \n" +
				" where 1=1 \n" +
				" and subcompanyname like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%' "+
				" UNION ALL SELECT a.id,a.subcompanyname,a.supsubcomid,a.canceled FROM HrmSubCompany a,allsub b where a.id = b.supsubcomid \n" +
				" ) select distinct * from allsub tb";
			if("oracle".equals(rs2.getDBType())){
				sql1 = "select distinct a.id, a.subcompanyname, a.supsubcomid, a.canceled\n" +
					" from hrmsubcompany a\n" + 
					" start with 1=1 \n" +
					" and a.subcompanyname like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%'\n" + 
					" connect by prior a.supsubcomid = a.id";
			}
			//new BaseBean().writeLog(sql1);
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				String _name = rs1.getString("subcompanyname");
				String _type = "s";
				int canceled = Util.getIntValue(rs1.getString("canceled"), 0);
				int supsubcomid = Util.getIntValue(rs1.getString("supsubcomid"), 0);
				
				if(!allowSubCmpIdEdit && !allowSubCmpIdEdit_list.contains(_id)){
					continue;
				}
				
				if(canceled == 1){
					String sql2 = "select count(*) cnt from FnaBudgetInfo a where a.organizationtype = 1 and a.budgetorganizationid = "+_id;
					rs2.executeSql(sql2);
					if(!(rs2.next() && rs2.getInt("cnt") > 0)){
						//System.out.println("continue1");
						continue;
					}
					_name += "("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")";//封存
				}
				
				if(subCmpIdList.contains(_id+"")){
					continue;
				}else{
					subCmpIdList.add(_id+"");
				}

				if(idx>0){
					result.append(",");
				}
				
				String pId = "s_"+supsubcomid;
				if(supsubcomid <= 0){
					pId = "c_0";
				}
				
				result.append("{"+
					"id:"+JSONObject.quote(_type+"_"+_id)+","+
					"id2:"+JSONObject.quote(_type+"_"+_id)+","+
					"name:"+JSONObject.quote(_name)+","+
					"pId:"+JSONObject.quote(pId)+","+
					"icon:"+JSONObject.quote("/images/treeimages/Home_wev8.gif")+
					"}");
				idx++;
			}

			//new BaseBean().writeLog("");
			//new BaseBean().writeLog("");
			//new BaseBean().writeLog("");
			int subCmpIdByDepListLen = subCmpIdByDepList.size();
			for(int i=0;i<subCmpIdByDepListLen;i++){
				String _id = (String)subCmpIdByDepList.get(i);

				sql1 = "WITH allsub(id,subcompanyname,supsubcomid,canceled) \n" +
					" as ( \n" +
					" SELECT id,subcompanyname,supsubcomid,canceled FROM HrmSubCompany \n" +
					" where id = "+_id+" "+
					" UNION ALL SELECT a.id,a.subcompanyname,a.supsubcomid,a.canceled FROM HrmSubCompany a,allsub b where a.id = b.supsubcomid \n" +
					" ) select distinct * from allsub tb";
				if("oracle".equals(rs2.getDBType())){
					sql1 = "select distinct a.id, a.subcompanyname, a.supsubcomid, a.canceled\n" +
						" from hrmsubcompany a\n" + 
						" start with a.id = "+_id+"\n" + 
						" connect by prior a.supsubcomid = a.id";
				}
				//new BaseBean().writeLog(sql1);
				rs1.executeSql(sql1);
				while(rs1.next()){
					String _id1 = rs1.getString("id");
					String _name = rs1.getString("subcompanyname");
					String _type = "s";
					int canceled = Util.getIntValue(rs1.getString("canceled"), 0);
					int supsubcomid = Util.getIntValue(rs1.getString("supsubcomid"), 0);
					
					if(canceled == 1){
						_name += "("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")";//封存
					}
					
					if(subCmpIdList.contains(_id1+"")){
						continue;
					}else{
						subCmpIdList.add(_id1+"");
					}

					if(idx>0){
						result.append(",");
					}
					
					String pId = "s_"+supsubcomid;
					if(supsubcomid <= 0){
						pId = "c_0";
					}
					
					result.append("{"+
						"id:"+JSONObject.quote(_type+"_"+_id1)+","+
						"id2:"+JSONObject.quote(_type+"_"+_id1)+","+
						"name:"+JSONObject.quote(_name)+","+
						"pId:"+JSONObject.quote(pId)+","+
						"icon:"+JSONObject.quote("/images/treeimages/Home_wev8.gif")+
						"}");
					idx++;
				}
			}

			
			//**********************************************************************************************

			sql1 = "select '0' as id, companyname as name, 'c' as type from hrmcompany";
			//new BaseBean().writeLog(sql1);
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				String _name = rs1.getString("name");
				String _type = rs1.getString("type");
				
				if(result.length() == 0){
					String sql2 = "select count(*) cnt from hrmcompany where companyname like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%' ";
					rs2.execute(sql2);
					if(rs2.next() && rs2.getInt("cnt") > 0){
					}else{
						continue;
					}
				}
				
				if(idx>0){
					result.append(",");
				}
				result.append("{"+
					"id:"+JSONObject.quote(_type+"_"+_id)+","+
					"id2:"+JSONObject.quote(_type+"_"+_id)+","+
					"name:"+JSONObject.quote(_name));
				result.append(",pId:"+JSONObject.quote(""));
				result.append(",icon:"+JSONObject.quote("/images/treeimages/global_wev8.gif"));
				result.append("}");
				idx++;
			}
			
			
			
		}else if("".equals(id)){//初始化组织架构树
			int idx = 0;
			String sql1 = "select '0' as id, companyname as name, 'c' as type from hrmcompany";
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				String _name = rs1.getString("name");
				String _type = rs1.getString("type");
				
				if(!isAllowCmpEdit 
						&& !allowSubCmpIdEdit && allowSubCmpIdEdit_list.size()==0
						&& !allowDepIdEdit && allowDepIdEdit_list.size()==0){
					continue;
				}
				
				if(idx>0){
					result.append(",");
				}
				result.append("{"+
					"id:"+JSONObject.quote(_type+"_"+_id)+","+
					"id2:"+JSONObject.quote(_type+"_"+_id)+","+
					"name:"+JSONObject.quote(_name));
				result.append(",isParent:true");
				result.append(",icon:"+JSONObject.quote("/images/treeimages/global_wev8.gif"));
				result.append("}");
				idx++;
			}
			
		}else{
			String idType = id.split("_")[0];
			id = id.split("_")[1];
			//System.out.println("idType="+idType+";id="+id);
			
			if("c".equalsIgnoreCase(idType)){//展开分部后，显示该目录下的下级组织架构
				int idx = 0;
				String sql1 = "select a.id, a.subcompanyname as name, a.showorder, 's' as type, a.canceled \n" +
						"	from HrmSubCompany a \n" +
						"	where (a.supsubcomid = 0 or a.supsubcomid = '' or a.supsubcomid is null) \n" +
						//"	and (a.canceled = 'N' or a.canceled = '' or a.canceled is null) \n" +
						" ORDER BY a.showorder, a.subcompanyname ";
				//System.out.println(sql1);
				rs1.executeSql(sql1);
				while(rs1.next()){
					String _id = rs1.getString("id");
					String _name = rs1.getString("name");
					String _type = rs1.getString("type");
					int canceled = Util.getIntValue(rs1.getString("canceled"), 0);
					//System.out.println("_id="+_id+";_name="+_name+";_type="+_type+";canceled="+canceled);
					
					if(canceled == 1){
						String sql2 = "select count(*) cnt from FnaBudgetInfo a where a.organizationtype = 1 and a.budgetorganizationid = "+_id;
						rs2.executeSql(sql2);
						if(!(rs2.next() && rs2.getInt("cnt") > 0)){
							//System.out.println("continue1");
							continue;
						}
						_name += "("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")";//封存
					}

					if(!allowSubCmpIdEdit && !allowSubCmpIdTreeView_list_1.contains(_id) 
							&& !allowDepIdEdit && !allowSubCmpIdTreeView_list_2.contains(_id)){
						//System.out.println("continue2");
						continue;
					}
					
					if(idx>0){
						result.append(",");
					}
					
					String isParent = "false";
					String sql2 = "select count(*) cnt from HrmSubCompany a where a.supsubcomid = "+_id;
					rs2.executeSql(sql2);
					if(rs2.next() && rs2.getInt("cnt") > 0){
						isParent = "true";
					}
					if("false".equals(isParent)){
						sql2 = "select count(*) cnt from HrmDepartment a where a.subcompanyid1 = "+_id;
						rs2.executeSql(sql2);
						if(rs2.next() && rs2.getInt("cnt") > 0){
							isParent = "true";
						}
					}
					
					result.append("{"+
						"id:"+JSONObject.quote(_type+"_"+_id)+","+
						"id2:"+JSONObject.quote(_type+"_"+_id)+","+
						"name:"+JSONObject.quote(_name));
					if("s".equalsIgnoreCase(_type)){
						result.append(",isParent:"+isParent);
						result.append(",icon:"+JSONObject.quote("/images/treeimages/Home_wev8.gif"));
					}
					result.append("}");
					idx++;
				}
				
			}else if("s".equalsIgnoreCase(idType) && Util.getIntValue(id) > 0){//展开分部后，显示该目录下的下级组织架构
				int idx = 0;
				String sql1 = "select * from (\n" +
						"	select a.id, a.subcompanyname as name, a.showorder, 's' as type, a.canceled \n" +
						"	from HrmSubCompany a \n" +
						"	where a.supsubcomid = "+Util.getIntValue(id)+"  \n" +
						//"	and (a.canceled = 'N' or a.canceled = '' or a.canceled is null) \n" +
						"	UNION \n" +
						"	SELECT a.id, a.departmentname as name, a.showorder, 'd' as type, a.canceled \n" +
						"	from HrmDepartment a \n" +
						"	where a.subcompanyid1 = "+Util.getIntValue(id)+" \n" +
						"	and (a.supdepid = 0 or a.supdepid = '' or a.supdepid is null) \n" +
						//"	and (a.canceled = 'N' or a.canceled = '' or a.canceled is null) \n" +
						" ) t \n" +
						" ORDER BY case when (type='s') then 0 else 1 end, t.showorder, t.name ";
				//System.out.println(sql1);
				//rs1.writeLog(sql1);
				rs1.executeSql(sql1);
				while(rs1.next()){
					String _id = rs1.getString("id");
					String _name = rs1.getString("name");
					String _type = rs1.getString("type");
					int canceled = Util.getIntValue(rs1.getString("canceled"), 0);
					
					if(canceled == 1){
						String _organizationtype = "1";
						if("d".equals(_type)){
							_organizationtype = "2";
						}
						String sql2 = "select count(*) cnt from FnaBudgetInfo a where a.organizationtype = "+_organizationtype+" and a.budgetorganizationid = "+_id;
						rs2.executeSql(sql2);
						if(!(rs2.next() && rs2.getInt("cnt") > 0)){
							continue;
						}
						_name += "("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")";//封存
					}

					if("s".equals(_type)){
						if(!allowSubCmpIdEdit && !allowSubCmpIdTreeView_list_1.contains(_id) 
								&& !allowDepIdEdit && !allowSubCmpIdTreeView_list_2.contains(_id)){
							//System.out.println("continue2");
							continue;
						}
					}else if("d".equals(_type)){
						if(!allowDepIdEdit && !allowDepIdTreeView_list_1.contains(_id)){
							//System.out.println("continue2");
							continue;
						}
					}

					if(idx>0){
						result.append(",");
					}
					result.append("{"+
						"id:"+JSONObject.quote(_type+"_"+_id)+","+
						"id2:"+JSONObject.quote(_type+"_"+_id)+","+
						"name:"+JSONObject.quote(_name));
					if("s".equalsIgnoreCase(_type)){
						
						String isParent = "false";
						String sql2 = "select count(*) cnt from HrmSubCompany a where a.supsubcomid = "+_id;
						rs2.executeSql(sql2);
						if(rs2.next() && rs2.getInt("cnt") > 0){
							isParent = "true";
						}
						if("false".equals(isParent)){
							sql2 = "select count(*) cnt from HrmDepartment a where a.subcompanyid1 = "+_id;
							rs2.executeSql(sql2);
							if(rs2.next() && rs2.getInt("cnt") > 0){
								isParent = "true";
							}
						}
						
						result.append(",isParent:"+isParent);
						result.append(",icon:"+JSONObject.quote("/images/treeimages/Home_wev8.gif"));
					}else{
						
						String isParent = "false";
						String sql2 = "select count(*) cnt from HrmDepartment a where a.supdepid = "+_id;
						rs2.executeSql(sql2);
						if(rs2.next() && rs2.getInt("cnt") > 0){
							isParent = "true";
						}
						
						result.append(",isParent:"+isParent);
						result.append(",icon:"+JSONObject.quote(""));
					}
					result.append("}");
					idx++;
				}
				
			}else if("d".equalsIgnoreCase(idType) && Util.getIntValue(id) > 0){//展开部门后，显示该目录下的下级组织架构
				int idx = 0;
				String sql1 = "SELECT a.id, a.departmentname as name, a.showorder, 'd' as type, a.canceled \n" +
						" from HrmDepartment a \n" +
						" where a.supdepid = "+Util.getIntValue(id)+" \n" +
						//" and (a.canceled = 'N' or a.canceled = '' or a.canceled is null) \n" +
						" ORDER BY a.showorder, a.departmentname ";
				//System.out.println(sql1);
				rs1.executeSql(sql1);
				while(rs1.next()){
					String _id = rs1.getString("id");
					String _name = rs1.getString("name");
					String _type = rs1.getString("type");
					int canceled = Util.getIntValue(rs1.getString("canceled"), 0);
					
					if(canceled == 1){
						String sql2 = "select count(*) cnt from FnaBudgetInfo a where a.organizationtype = 2 and a.budgetorganizationid = "+_id;
						rs2.executeSql(sql2);
						if(!(rs2.next() && rs2.getInt("cnt") > 0)){
							continue;
						}
						_name += "("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")";//封存
					}

					if(!allowDepIdEdit && !allowDepIdTreeView_list_1.contains(_id)){
						//System.out.println("continue2");
						continue;
					}

					if(idx>0){
						result.append(",");
					}
					
					String isParent = "false";
					String sql2 = "select count(*) cnt from HrmDepartment a where a.supdepid = "+_id;
					rs2.executeSql(sql2);
					if(rs2.next() && rs2.getInt("cnt") > 0){
						isParent = "true";
					}
					
					result.append("{"+
						"id:"+JSONObject.quote(_type+"_"+_id)+","+
						"id2:"+JSONObject.quote(_type+"_"+_id)+","+
						"name:"+JSONObject.quote(_name)+","+
						"isParent:"+isParent+","+
						"icon:"+JSONObject.quote("")+
						"}");
					idx++;
				}
				
			}
		}
	}

}
//System.out.println("result="+result.toString());
%><%="["+result.toString()+"]" %>