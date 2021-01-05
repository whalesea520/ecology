<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.*"%>
<%@page import="java.io.*"%>
<%@ page import="net.sf.json.JSONObject" %>
<%
JSONObject object = new JSONObject();
String classname = request.getParameter("classname");
classname = classname.replace(".", ""+File.separator);
String classpath = GCONST.getRootPath()+"classbean"+File.separator+classname+".class";
//System.out.println("classpath:"+classpath);
File file = new File(classpath);
if(file.exists()) {
	object.put("status","ok");
	out.print(object.toString());
	return;
} else {
	classpath = GCONST.getRootPath()+"WEB-INF"+File.separator+"classes"+File.separator+classname;
	file = new File(classpath);
	if(file.exists()) {
		object.put("status","ok");
		out.print(object.toString());
		return;
	} else {
		object.put("status","no");
		out.print(object.toString());
		return;
	}
}
%>