<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char flag = Util.getSeparator() ;

String colorid11=Util.fromScreen(request.getParameter("colorid11"),user.getLanguage());
String colorid21=Util.fromScreen(request.getParameter("colorid21"),user.getLanguage());
String colorid31=Util.fromScreen(request.getParameter("colorid31"),user.getLanguage());
String colorid41=Util.fromScreen(request.getParameter("colorid41"),user.getLanguage());
String colorid12=Util.fromScreen(request.getParameter("colorid12"),user.getLanguage());
String colorid22=Util.fromScreen(request.getParameter("colorid22"),user.getLanguage());
String colorid32=Util.fromScreen(request.getParameter("colorid32"),user.getLanguage());
String colorid42=Util.fromScreen(request.getParameter("colorid42"),user.getLanguage());

String resourceid=user.getUID()+"";
RecordSet.executeProc("HrmPlanColor_Update",resourceid+flag+"1"+flag+colorid11+flag+colorid12);
RecordSet.executeProc("HrmPlanColor_Update",resourceid+flag+"2"+flag+colorid21+flag+colorid22);
RecordSet.executeProc("HrmPlanColor_Update",resourceid+flag+"3"+flag+colorid31+flag+colorid32);
RecordSet.executeProc("HrmPlanColor_Update",resourceid+flag+"4"+flag+colorid41+flag+colorid42);

response.sendRedirect("HrmResourcePlanColor.jsp");
%>