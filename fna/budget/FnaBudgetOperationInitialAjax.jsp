<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
if(true){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}else{
	HrmUserVarify.checkUserRight("FnaBudget:All", null);
}
%>