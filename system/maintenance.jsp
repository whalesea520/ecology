
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />


<%
	String toPage="/hrm/HrmMaintenance.jsp?mainttype=H";
	if(software.equals("CRM")) toPage="/CRM/CRMMaintenance.jsp?mainttype=C";
	else if(software.equals("KM")) toPage="/docs/DocMaintenance.jsp?mainttype=D";
	response.sendRedirect(toPage);
%>