
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<%
String requestid = request.getParameter("requestid");
String cids = request.getParameter("cids");
DocChangeManager.doSendDoc(user.getUID(), user.getUID(), requestid, cids);
out.println("1");
%>