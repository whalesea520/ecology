<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int id = Util.getIntValue(request.getParameter("id"));

rs.executeSql("select * from fnaFeeWfInfo where id = "+id);
if(rs.next()){
	int workflowid = Util.getIntValue(rs.getString("workflowid"));

	out.println("{\"flag\":true,\"workflowid\":"+workflowid+"}");//保存成功
	out.flush();
	return;
}else{
	out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(126993,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
}
%>