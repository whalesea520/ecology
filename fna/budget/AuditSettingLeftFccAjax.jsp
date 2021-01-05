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
		
		if("".equals(id)){
			id = "fcc_0";
		}
		
		if(!"".equals(nameQuery)){//如果是来自于快速查询
		
			int idx = 0;
			String sql1 = "select a.id, a.name, a.code, a.type, a.archive \n" +
					"	from FnaCostCenter a \n" +
					"	where (a.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' \n" +
					"	or a.code like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n" +
					" ORDER BY a.code, a.name ";
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				String _name = rs1.getString("name");
				String _code = rs1.getString("code");
				int type = Util.getIntValue(rs1.getString("type"), 0);
				int canceled = Util.getIntValue(rs1.getString("archive"), 0);
				
				if(!"".equals(_code)){
					_name += "（"+_code+"）";
				}
				
				if(idx>0){
					result.append(",");
				}
				
				String workflowid = "";
				String workflowname = "";
				String sql2 = "select a.workflowid, b.workflowname\n" +
						" from BudgetAuditMapping a \n" +
						" join workflow_base b on a.workflowid = b.id \n" +
						" where a.fccId = "+_id;
				rs2.executeSql(sql2);
				if(rs2.next()){
					workflowid = Util.null2String(rs2.getString("workflowid")).trim();
					workflowname = Util.null2String(rs2.getString("workflowname")).trim();
				}
				
				result.append("{"+
					"id:"+JSONObject.quote("fcc"+"_"+_id)+","+
					"name:"+JSONObject.quote(_name));
				result.append(",isParent:false");
				result.append(",icon:"+JSONObject.quote("/images/treeimages/Home_wev8.gif"));
				result.append(",workflowid:"+JSONObject.quote(workflowid));
				result.append(",workflowname:"+JSONObject.quote(workflowname));
				
				result.append("}");
				idx++;
			}
			
		}else{
			id = Util.getIntValue(id.split("_")[1], -1)+"";
			
			int idx = 0;
			String sql1 = "select a.id, a.name, a.code, a.type, a.archive \n" +
					"	from FnaCostCenter a \n" +
					"	where a.supFccId = "+id+" \n" +
					" ORDER BY a.code, a.name ";
			//System.out.println(sql1);
			rs1.executeSql(sql1);
			while(rs1.next()){
				String _id = rs1.getString("id");
				String _name = rs1.getString("name");
				String _code = rs1.getString("code");
				int type = Util.getIntValue(rs1.getString("type"), 0);
				int canceled = Util.getIntValue(rs1.getString("archive"), 0);
				
				if(!"".equals(_code)){
					_name += "（"+_code+"）";
				}
				
				if(idx>0){
					result.append(",");
				}
				
				String isParent = "false";
				String sql2 = "select count(*) cnt from FnaCostCenter a where a.supFccId = "+_id;
				rs2.executeSql(sql2);
				if(rs2.next() && rs2.getInt("cnt") > 0){
					isParent = "true";
				}
				
				String workflowid = "";
				String workflowname = "";
				sql2 = "select a.workflowid, b.workflowname\n" +
						" from BudgetAuditMapping a \n" +
						" join workflow_base b on a.workflowid = b.id \n" +
						" where a.fccId = "+_id;
				rs2.executeSql(sql2);
				if(rs2.next()){
					workflowid = Util.null2String(rs2.getString("workflowid")).trim();
					workflowname = Util.null2String(rs2.getString("workflowname")).trim();
				}
				
				result.append("{"+
					"id:"+JSONObject.quote("fcc"+"_"+_id)+","+
					"name:"+JSONObject.quote(_name));
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
//System.out.println("result="+result.toString());
%><%="["+result.toString()+"]" %>