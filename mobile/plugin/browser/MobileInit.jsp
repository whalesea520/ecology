
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.hrm.*"%>
<%@page import="weaver.file.FileUpload"%>
<%
FileUpload fu = new FileUpload(request);
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
  
  User user = HrmUserVarify.getUser(request , response);
  if(user==null){
	  out.println("登陆超时,请重新登陆!");
	  return ;
  }
%>