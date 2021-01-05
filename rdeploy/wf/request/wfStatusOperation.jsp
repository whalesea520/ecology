
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

String actionkey = Util.null2String(request.getParameter("actionkey"));
RecordSet rs = new RecordSet();
//System.out.println("actionkey = "+actionkey);
int wfid = Util.getIntValue(request.getParameter("wfid"));
if(actionkey.equals("statuschange")){
	int isvalid = Util.getIntValue(request.getParameter("isvalid"));
	//System.out.println("isvalid1 = "+isvalid);
	if(isvalid == 1){
		isvalid = 0;
	}else{
		isvalid = 1;
	}
	//System.out.println("isvalid2 = "+isvalid);
	String condsql = "UPDATE workflow_base SET isvalid="+isvalid+" WHERE id = "+wfid;
	rs.executeSql(condsql);
	String data="{\"wfid\":\""+wfid+"\",\"isvalid\":\""+isvalid+"\"}";
	response.getWriter().write(data);
}else{
	int savenodeid = Util.getIntValue(request.getParameter("savenodeid"));
	String savenodename = Util.null2String(request.getParameter("savenodename"));
	//更新新节点内容
	String sql = "update workflow_nodebase set nodename= '"+savenodename+"'  where id=" + savenodeid;
	//System.out.println("创建新节点sql"+sql);
	rs.executeSql(sql);
	String data="{\"wfid\":\""+wfid+"\",\"success\":\"success\"}";
	response.getWriter().write(data);
}
%>

