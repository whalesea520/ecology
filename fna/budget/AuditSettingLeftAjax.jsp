<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" /><%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	BaseBean bb = new BaseBean();
	int userId = user.getUID();
	
	boolean hasPriv = HrmUserVarify.checkUserRight("FnaBudget:All", user);//预算审批设置

	if(hasPriv){
		String id = Util.null2String(request.getParameter("id"));
		String name = Util.null2String(request.getParameter("name"));
		//String level = Util.null2String(request.getParameter("level"));
		String otherParam = Util.null2String(request.getParameter("otherParam"));
		//System.out.println("id="+id+";name="+name+";otherParam="+otherParam);
		String guid1 = Util.null2String(request.getParameter("guid1"));
		String nameQuery = "";
		if(!"".equals(guid1)){
			nameQuery = Util.null2String(session.getAttribute("AuditSettingLeft.jsp_nameQuery_"+guid1));
		}
		
		if(!"".equals(nameQuery)){//如果是来自于快速查询
		
			int idx = 0;
			String sql1 = "select a.id, a.subcompanyname as name, a.showorder, 's' as type, a.canceled \n" +
					"	from HrmSubCompany a \n" +
					"	where a.subcompanyname like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' \n" +
					" ORDER BY a.showorder, a.subcompanyname ";
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				String _name = rs1.getString("name");
				String _type = rs1.getString("type");
				int canceled = Util.getIntValue(rs1.getString("canceled"), 0);
				//System.out.println("_id="+_id+";_name="+_name+";_type="+_type+";canceled="+canceled);
				
				if(idx>0){
					result.append(",");
				}
				
				String workflowid = "";
				String workflowname = "";
				String sql2 = "select a.workflowid, b.workflowname\n" +
						" from BudgetAuditMapping a \n" +
						" join workflow_base b on a.workflowid = b.id \n" +
						" where a.subcompanyid = "+_id;
				rs2.executeSql(sql2);
				if(rs2.next()){
					workflowid = Util.null2String(rs2.getString("workflowid")).trim();
					workflowname = Util.null2String(rs2.getString("workflowname")).trim();
				}
				
				result.append("{"+
					"id:"+JSONObject.quote(_type+"_"+_id)+","+
					"name:"+JSONObject.quote(_name));
				result.append(",isParent:false");
				result.append(",icon:"+JSONObject.quote("/images/treeimages/Home_wev8.gif"));
				result.append(",workflowid:"+JSONObject.quote(workflowid));
				result.append(",workflowname:"+JSONObject.quote(workflowname));
				
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
				
				if(idx>0){
					result.append(",");
				}

				
				String workflowid = "";
				String workflowname = "";
				String sql2 = "select a.workflowid, b.workflowname\n" +
						" from BudgetAuditMapping a \n" +
						" join workflow_base b on a.workflowid = b.id \n" +
						" where a.subcompanyid = "+_id;
				rs2.executeSql(sql2);
				if(rs2.next()){
					workflowid = Util.null2String(rs2.getString("workflowid")).trim();
					workflowname = Util.null2String(rs2.getString("workflowname")).trim();
				}
				
				result.append("{"+
					"id:"+JSONObject.quote(_type+"_"+_id)+","+
					"name:"+JSONObject.quote(_name));
				result.append(",isParent:true");
				result.append(",icon:"+JSONObject.quote("/images/treeimages/global_wev8.gif"));
				result.append(",workflowid:"+JSONObject.quote(workflowid));
				result.append(",workflowname:"+JSONObject.quote(workflowname));
				
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
					
					if(idx>0){
						result.append(",");
					}
					
					String isParent = "false";
					String sql2 = "select count(*) cnt from HrmSubCompany a where a.supsubcomid = "+_id;
					rs2.executeSql(sql2);
					if(rs2.next() && rs2.getInt("cnt") > 0){
						isParent = "true";
					}
					
					String workflowid = "";
					String workflowname = "";
					sql2 = "select a.workflowid, b.workflowname\n" +
							" from BudgetAuditMapping a \n" +
							" join workflow_base b on a.workflowid = b.id \n" +
							" where a.subcompanyid = "+_id;
					rs2.executeSql(sql2);
					if(rs2.next()){
						workflowid = Util.null2String(rs2.getString("workflowid")).trim();
						workflowname = Util.null2String(rs2.getString("workflowname")).trim();
					}
					
					result.append("{"+
						"id:"+JSONObject.quote(_type+"_"+_id)+","+
						"name:"+JSONObject.quote(_name));
					result.append(",isParent:"+isParent);
					result.append(",icon:"+JSONObject.quote("/images/treeimages/Home_wev8.gif"));
					result.append(",workflowid:"+JSONObject.quote(workflowid));
					result.append(",workflowname:"+JSONObject.quote(workflowname));
					
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
						" ) t \n" +
						" ORDER BY case when (type='s') then 0 else 1 end, t.showorder, t.name ";
				//System.out.println(sql1);
				rs1.executeSql(sql1);
				while(rs1.next()){
					String _id = rs1.getString("id");
					String _name = rs1.getString("name");
					String _type = rs1.getString("type");
					int canceled = Util.getIntValue(rs1.getString("canceled"), 0);
					
					if(idx>0){
						result.append(",");
					}
					result.append("{"+
						"id:"+JSONObject.quote(_type+"_"+_id)+","+
						"name:"+JSONObject.quote(_name));
						
					String isParent = "false";
					String sql2 = "select count(*) cnt from HrmSubCompany a where a.supsubcomid = "+_id;
					rs2.executeSql(sql2);
					if(rs2.next() && rs2.getInt("cnt") > 0){
						isParent = "true";
					}
					
					String workflowid = "";
					String workflowname = "";
					sql2 = "select a.workflowid, b.workflowname\n" +
							" from BudgetAuditMapping a \n" +
							" join workflow_base b on a.workflowid = b.id \n" +
							" where a.subcompanyid = "+_id;
					rs2.executeSql(sql2);
					if(rs2.next()){
						workflowid = Util.null2String(rs2.getString("workflowid")).trim();
						workflowname = Util.null2String(rs2.getString("workflowname")).trim();
					}
					
					result.append(",isParent:"+isParent);
					result.append(",icon:"+JSONObject.quote("/images/treeimages/Home_wev8.gif"));
					result.append(",workflowid:"+JSONObject.quote(workflowid));
					result.append(",workflowname:"+JSONObject.quote(workflowname));
					
					result.append("}");
					idx++;
				}
				
			}
		}
	}

}
//System.out.println("result="+result.toString());
%><%="["+result.toString()+"]" %>