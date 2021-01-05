<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.*"%>
<jsp:useBean id="mode" class="weaver.formmode.view.ModeShareManager" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<% 
    
     String router = Util.null2String(request.getParameter("router"));
	response.sendRedirect("./index.html#/"+router);
%>

