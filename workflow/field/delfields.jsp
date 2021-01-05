<%@ page import="weaver.general.Util" %>
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />

<%
	FieldMainManager.DeleteField(request.getParameterValues("fieldid"));
	FieldComInfo.removeFieldCache();
	response.sendRedirect("managefield.jsp");
%>
