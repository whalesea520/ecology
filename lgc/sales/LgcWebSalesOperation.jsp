<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%

String operation = Util.null2String(request.getParameter("operation"));
String id = Util.null2String(request.getParameter("id"));
String purchasestatus = Util.null2String(request.getParameter("purchasestatus"));


if(operation.equals("changewebsales")) {
	char separator = Util.getSeparator() ;
	String para = id + separator + purchasestatus ;

	RecordSet.executeProc("LgcWebShop_Update",para);
	response.sendRedirect("LgcWebSales.jsp");
}

if(operation.equals("deletewebsales")) {
	RecordSet.executeProc("LgcWebShop_Delete",id);
	response.sendRedirect("LgcWebSales.jsp");
}

%>