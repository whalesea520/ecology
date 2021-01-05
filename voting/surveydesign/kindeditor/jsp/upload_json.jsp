
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.general.Util"%>
<%
   FileUpload fu = new FileUpload(request,"UTF-8",false);
   String ename = Util.null2String(request.getParameter("ename"));
   if("".equals(ename)){
	   ename="imgFile";
   }else{
	   ename="imgFile_"+ename;
   }
   String docid=fu.uploadFiles(ename);
   String docname = fu.getFileName();
   JSONObject obj = new JSONObject();
   obj.put("error", new Integer(0));
   obj.put("url", "/weaver/weaver.file.FileDownload?fileid="+docid);
   obj.put("name", docname);
   
   response.setContentType("text/html;charset=UTF-8");
   PrintWriter outer = response.getWriter();
   outer.println(obj.toString());
%>
