<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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

	List<String> allowFccIdEdit_list = new ArrayList<String>();
	boolean allowFccIdEdit = FnaBudgetLeftRuleSet.getAllowFccId(user.getUID(), allowFccIdEdit_list);
	
	List<String> allowFccIdTreeView_list_1 = new ArrayList<String>();
	if(!allowFccIdEdit && allowFccIdEdit_list.size() > 0){
		allowFccIdTreeView_list_1 = FnaBudgetLeftRuleSet.recursiveSuperiorFcc(allowFccIdEdit_list);
	}

	if(canView || canEdit){
		String id = Util.null2String(request.getParameter("id2"));
		String name = Util.null2String(request.getParameter("name"));
		//String level = Util.null2String(request.getParameter("level"));
		String otherParam = Util.null2String(request.getParameter("otherParam"));
		//System.out.println("id="+id+";name="+name+";otherParam="+otherParam);
		String _searchStr_lowerCase = Util.null2String(request.getParameter("_searchStr_lowerCase"));
		
		if(!"".equals(_searchStr_lowerCase)){
			
			List _idList = new ArrayList();
			int idx = 0;
			String sql1 = "select a.id, a.type, a.name, a.code, a.Archive, a.supFccId from FnaCostCenter a "+
				" where "+FnaCostCenter.getDbUserName()+"getFccArchive1(a.id) = 0 "+
				" and (a.name like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%' or a.code like '%"+StringEscapeUtils.escapeSql(_searchStr_lowerCase)+"%') "+
				" ORDER BY a.type, a.code, a.name, a.id ";
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				int _type = Util.getIntValue(rs1.getString("type"));
				String _name = rs1.getString("name");
				String _code = rs1.getString("code");
				String _supFccId = rs1.getString("supFccId");
				int _canceled = Util.getIntValue(rs1.getString("Archive"), 0);
				
				if(!allowFccIdEdit && !allowFccIdTreeView_list_1.contains(_id)){
					continue;
				}
				
				String _typeName = "fccType";
				if(_type == 1){
					_typeName = "fcc";
				}
				
				String _name1 = _name;
				if(_canceled == 1){
					_name1 += "("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")";//已封存
				}
				
				if(idx>0){
					result.append(",");
				}
				
				String icon = "/images/treeimages/home16_wev8.gif";
				if(_type == 1){
					icon = "/images/treeimages/dept16_wev8.gif";
				}
				
				String isParent = "true";
				if(_type == 1){
					isParent = "false";
				}else{
					String sql2 = "select count(*) cnt from FnaCostCenter a where a.supFccId = "+Util.getIntValue(_id);
					rs2.executeSql(sql2);
					if(rs2.next() && rs2.getInt("cnt") > 0){
						isParent = "true";
					}else{
						isParent = "false";
					}
				}
				
				result.append("{"+
					"id:"+JSONObject.quote(_typeName+"_"+_id)+","+
					"id2:"+JSONObject.quote(_typeName+"_"+_id)+","+
					"name:"+JSONObject.quote(_name1)+","+
					"pId:"+JSONObject.quote("fccType"+"_"+_supFccId)+","+
					"isParent:"+isParent+""+
					//"icon:"+JSONObject.quote(icon)+
					"}");
				idx++;
				
				_idList.add(_id);
			}
			
			for(int i=0;i<_idList.size();i++){
				String _subId = (String)_idList.get(i);
				
				sql1 = "WITH allsub(id,name,code,supFccId,type,Archive)\n" +
					" as (\n" +
					" SELECT id,name,code,supFccId,type,Archive FROM FnaCostCenter where id="+_subId+" \n" +
					"   UNION ALL SELECT a.id,a.name,a.code,a.supFccId,a.type,a.Archive FROM FnaCostCenter a,allsub b where a.id = b.supFccId \n" +
					" ) select * from allsub tb ";
				if("oracle".equals(rs1.getDBType())){
					sql1 = "select id,name,code,supFccId,type,Archive \n" +
						" from FnaCostCenter\n" +
						" start with id="+_subId+" \n" +
						" connect by prior supFccId = id";
				}
				rs1.executeSql(sql1);
				while(rs1.next()){
					String _id = rs1.getString("id");
					int _type = Util.getIntValue(rs1.getString("type"));
					String _name = rs1.getString("name");
					String _code = rs1.getString("code");
					String _supFccId = rs1.getString("supFccId");
					int _canceled = Util.getIntValue(rs1.getString("Archive"), 0);
					
					if(_idList.contains(_id)){
						continue;
					}
					
					String _typeName = "fccType";
					if(_type == 1){
						_typeName = "fcc";
					}
					
					String _name1 = _name;
					if(_canceled == 1){
						_name1 += "("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")";//已封存
					}
					
					if(idx>0){
						result.append(",");
					}
					
					String icon = "/images/treeimages/home16_wev8.gif";
					if(_type == 1){
						icon = "/images/treeimages/dept16_wev8.gif";
					}
					
					String isParent = "true";
					if(_type == 1){
						isParent = "false";
					}else{
						String sql2 = "select count(*) cnt from FnaCostCenter a where a.supFccId = "+Util.getIntValue(_id);
						rs2.executeSql(sql2);
						if(rs2.next() && rs2.getInt("cnt") > 0){
							isParent = "true";
						}else{
							isParent = "false";
						}
					}
					
					result.append("{"+
						"id:"+JSONObject.quote(_typeName+"_"+_id)+","+
						"id2:"+JSONObject.quote(_typeName+"_"+_id)+","+
						"name:"+JSONObject.quote(_name1)+","+
						"pId:"+JSONObject.quote("fccType"+"_"+_supFccId)+","+
						"isParent:"+isParent+""+
						//"icon:"+JSONObject.quote(icon)+
						"}");
					idx++;
					
					_idList.add(_id);
				}
			}
			
		}else{//初始化组织架构树
			if("".equals(id)){
				id = "0_0";
			}
			
			String[] idArray = id.split("_");
			int feelevel = Util.getIntValue(idArray[0], -10)+1;
			id = idArray[1];
			
			int idx = 0;
			String sql1 = "select a.id, a.type, a.name, a.code, a.Archive from FnaCostCenter a "+
				" where a.supFccId = "+Util.getIntValue(id)+" "+
				" ORDER BY a.type, a.code, a.name, a.id ";
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				int _type = Util.getIntValue(rs1.getString("type"));
				String _name = rs1.getString("name");
				String _code = rs1.getString("code");
				int _canceled = Util.getIntValue(rs1.getString("Archive"), 0);
				
				if(!allowFccIdEdit && !allowFccIdTreeView_list_1.contains(_id)){ 
					//System.out.println("continue2");
					continue;
				}
				
				String _typeName = "fccType";
				if(_type == 1){
					_typeName = "fcc";
				}
				
				String _name1 = _name;
				if(_canceled == 1){
					_name1 += "("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")";//已封存
				}
				
				if(idx>0){
					result.append(",");
				}
				
				String icon = "/images/treeimages/home16_wev8.gif";
				if(_type == 1){
					icon = "/images/treeimages/dept16_wev8.gif";
				}
				
				String isParent = "true";
				if(_type == 1){
					isParent = "false";
				}else{
					String sql2 = "select count(*) cnt from FnaCostCenter a where a.supFccId = "+Util.getIntValue(_id);
					rs2.executeSql(sql2);
					if(rs2.next() && rs2.getInt("cnt") > 0){
						isParent = "true";
					}else{
						isParent = "false";
					}
				}
				
				result.append("{"+
					"id:"+JSONObject.quote(_typeName+"_"+_id)+","+
					"id2:"+JSONObject.quote(_typeName+"_"+_id)+","+
					"name:"+JSONObject.quote(_name1)+","+
					"isParent:"+isParent+""+
					//"icon:"+JSONObject.quote(icon)+
					"}");
				idx++;
			}
			
		}
	}

}
//System.out.println("result="+result.toString());
%><%="["+result.toString()+"]" %>