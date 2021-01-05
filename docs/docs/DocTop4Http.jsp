<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.api.workflow.service.DocNoticeService"%>

   <%
   DocNoticeService docNoticeService = new DocNoticeService();
   String docid = request.getParameter("docid");
   
   String doOrCancel = request.getParameter("doOrCancel");
   
   String data = docNoticeService.topServices(docid,doOrCancel);
   
   out.println(data);
   %>
