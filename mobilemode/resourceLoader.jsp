<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.mobile.plugin.Resource"%>
<%@page import="com.weaver.formmodel.mobile.mz.ResourcePool"%>
<%@ page import="weaver.general.Util"%>
<%
String url = Util.null2String(request.getParameter("url"));
int index = url.indexOf("?");
if(index != -1){
	url = url.substring(0, index);
}
index = url.lastIndexOf(".");
if(index == -1){
	return;
}
String type = url.substring(index + 1).toLowerCase();
if(type.equals("js")){
	response.setContentType("application/x-javascript");
}else if(type.equals("css")){
	response.setContentType("text/css");
}else{
	return;
}
String content = "";
try{
	ResourcePool resourcePool = ResourcePool.getInstance();
	Resource resource = resourcePool.getResource(type, url);
	content = resource.getContent();
}catch(Exception ex){
	content = ":Error:" + ex.getMessage();
}finally{
	out.print(content);
	out.flush();
}

%>
