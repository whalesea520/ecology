
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="esp" class="weaver.page.style.ElementStylePriview" scope="page" />
<%
String styleid =Util.null2String(request.getParameter("styleid"));
out.print(esp.getContainerForStyle(("".equals(styleid))?"template":styleid));
%>