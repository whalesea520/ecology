<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.api.workflow.service.DocNoticeService"%>

   <%
   DocNoticeService docNoticeService = new DocNoticeService();
   String docid = request.getParameter("docid");
   String data = docNoticeService.getContent(docid);
   
   out.println(data);
   %>
