<%@ page import="weaver.general.Util" %>
<%
String charttype = Util.null2String(request.getParameter("charttype"));
if(charttype.equals("C"))	response.sendRedirect("OrgChartCRM.jsp");
else if(charttype.equals("F"))	response.sendRedirect("OrgChartFna.jsp");
else if(charttype.equals("P"))	response.sendRedirect("OrgChartCpt.jsp");
else if(charttype.equals("I"))	response.sendRedirect("OrgChartLgc.jsp");
else if(charttype.equals("H"))	response.sendRedirect("OrgChartHRM.jsp");
else if(charttype.equals("D"))	response.sendRedirect("OrgChartDoc.jsp");
else if(charttype.equals("R"))	response.sendRedirect("OrgChartProj.jsp");
else response.sendRedirect("OrgChartHRM.jsp");
%>
	
