<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,org.dom4j.*,java.io.*,org.json.JSONObject" %>
<%@ page import="weaver.templetecheck.PropertiesUtil" %>
<%@ page import="weaver.templetecheck.FileUtil" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String fpath = request.getParameter("path");
JSONObject object = new JSONObject();
FileUtil fileUtil = new FileUtil();
String content = request.getParameter("contentarea");
//判断path是存已存在，路径是否正确 
File file = new File(fileUtil.getPath(fpath));
if(file.exists()) {
	//response.sendRedirect("AddXml.jsp?message=1");//文件已存在
	object.put("message","1");//文件已存在
	out.print(object.toString());
	return;
}

try {
	PropertiesUtil prop = new PropertiesUtil();
	//System.out.println("content:"+content);
	String res = prop.saveFile(fpath,content);
	object.put("message",res);//文件已存在
	out.print(object.toString());
} catch(Exception e) {
	e.printStackTrace();
	//response.sendRedirect("AddXml.jsp?message=2");//文件创建失败
	object.put("message","2");//文件创建失败
	out.print(object.toString());
	return;
}
%>