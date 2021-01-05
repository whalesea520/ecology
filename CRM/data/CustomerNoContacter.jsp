
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	String sql="delete CRM_CustomerInfo WHERE (id NOT IN (SELECT customerid FROM CRM_CustomerContacter))";
	RecordSet.executeSql(sql);

	response.sendRedirect("/CRM/CRMMaintenance.jsp");

%>
