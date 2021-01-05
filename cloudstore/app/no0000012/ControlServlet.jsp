<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.cloudstore.app.no0000012.controller.ActionFactory"%>
<%
ActionFactory af = ActionFactory.getInstance();
af.setBaseActionName(request.getParameter("action"));
out.print(af.getBaseAction().execute(request,response));
%>