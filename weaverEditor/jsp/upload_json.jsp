
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.file.FileUpload"%>

<%
   FileUpload fu = new FileUpload(request,"utf-8");
   String docid=fu.uploadFiles("imgFile");
   JSONObject obj = new JSONObject();
   obj.put("error", new Integer(0));
   obj.put("url", "/weaver/weaver.file.FileDownload?fileid="+docid);
   out.println(obj.toString());
%>
