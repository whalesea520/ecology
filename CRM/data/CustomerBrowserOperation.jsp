<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
	String customerId = request.getParameter("customerId");
	out.println(CustomerInfoComInfo.getCustomerInfoname(customerId));
%>