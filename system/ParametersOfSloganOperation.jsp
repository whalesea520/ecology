<%@ page import="weaver.general.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
String content = Util.null2String(request.getParameter("content"));
String speed = Util.null2String(request.getParameter("speed"));
String colorid1 = Util.null2String(request.getParameter("colorid1"));
String colorid2 = Util.null2String(request.getParameter("colorid2"));

char flag = 2;
String ProcPara = content + flag + speed + flag + colorid1 + flag + colorid2;
RecordSet.executeProc("Sys_Slogan_Update",ProcPara);

response.sendRedirect("/system/SystemMaintenance.jsp");
%>
