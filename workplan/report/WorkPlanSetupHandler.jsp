
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String reportType = Util.null2String(request.getParameter("reporttype"));
String recCount = Util.null2String(request.getParameter("reccount"));
String para = "";
char sep = Util.getSeparator();
para = String.valueOf(user.getUID()) + sep + reportType + sep + recCount;
rs.executeProc("WorkPlanSetup_SetRecCount", para);

response.sendRedirect("WorkPlanReport.jsp?type=" + reportType);
%>