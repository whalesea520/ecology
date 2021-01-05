<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.hrm.*" %>
<% 
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	JSONObject obj = new JSONObject();
	obj.put("code",1);
	out.println(obj.toString());
	
%>