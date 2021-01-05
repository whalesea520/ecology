<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<%
String whereclause=Util.null2String(request.getParameter("whereclause"));
String orderclause=Util.null2String(request.getParameter("orderclause"));
SearchClause.setOrderClause(orderclause);
SearchClause.setWhereClause(whereclause);
response.sendRedirect("/docs/search/DocSearchView.jsp");
%>