
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%
	
   User user = HrmUserVarify.getUser (request , response) ;
   if(user == null)  return ;

   FileUpload fu = new FileUpload(request,"utf-8",false,"1");
  
   String docid=fu.uploadFilesToEmail("Filedata");
   String docname = fu.getFileName();
   JSONObject obj = new JSONObject();
   obj.put("error", new Integer(0));
   obj.put("id", docid);
   obj.put("name", docname);
   
   response.setContentType("text/html;charset=UTF-8");
   PrintWriter outer = response.getWriter();
   outer.println(docid);
%>
