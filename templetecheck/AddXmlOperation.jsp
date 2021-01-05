<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,org.dom4j.*,java.io.*,org.json.JSONObject" %>
<%@ page import="weaver.templetecheck.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String fpath = request.getParameter("path");
JSONObject object = new JSONObject();
String content = request.getParameter("contentarea");
CheckConfigFile checkConfigFile = new CheckConfigFile();
FileUtil fileUtil = new FileUtil();
//判断path是存已存在，路径是否正确
File file = new File(fileUtil.getPath(fpath));
if(file.exists()) {
	//response.sendRedirect("AddXml.jsp?message=1");//文件已存在
	object.put("message","1");//文件已存在
	out.print(object.toString());
	return;
}
try {
	//System.out.println("==content:"+content);
	Document doc = checkConfigFile.Str2Document(content);
	XMLUtil xmlUtil = new XMLUtil();
	String res = xmlUtil.addXml(file,doc);
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