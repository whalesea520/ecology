
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="wfShareAuthorization" class="weaver.workflow.request.WFShareAuthorization" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int userid = user.getUID();
boolean isoracle = (rs.getDBType()).equals("oracle") ;
if(userid != 1) {
	out.print("此功能只有系统管理员才能执行，请联系系统管理员!");
	return;
}

wfShareAuthorization.setCurrentoperatorID();
out.print("执行完成!");
%>