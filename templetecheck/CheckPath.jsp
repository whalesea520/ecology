<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.templetecheck.FileUtil" %>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
FileUtil fileUtil = new FileUtil();
String path  = request.getParameter("path");
File file = new File(fileUtil.getPath(path));
if(file.exists()) {
	out.print("{\"status\":\"ok\"}");
} else {
	out.print("{\"status\":\"no\"}");
}


%>