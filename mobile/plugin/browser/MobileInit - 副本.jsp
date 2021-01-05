<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="weaver.mobile.plugin.ecology.service.AuthService"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%
request.setCharacterEncoding("GBK");
  String sessionKey=Util.null2String(request.getParameter("sessionkey"));
  AuthService authService=new AuthService();
  
  if(!authService.verify(sessionKey)){
	  out.println("没有权限！");
	  return ;
  }
  User user=authService.getCurrUser(sessionKey);
  if(user==null){
	  out.println("没有登陆!");
	  return ;
  }
%>