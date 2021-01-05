<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%

String checkdata = request.getParameter("checkdata");
String questionrepair = request.getParameter("questionrepair");
//System.out.println("====checkdata:"+checkdata);
Properties prop = new Properties();
String filePath = GCONST.getPropertyPath() +"upgradesetting.properties";
File file = new File(filePath);
if(file.exists()) {
	file.setWritable(true);
	OutputStream outstream = new FileOutputStream(filePath);
	prop.setProperty("checkdata", checkdata);
	prop.setProperty("questionrepair", questionrepair);
	//以适合使用 load 方法加载到 Properties 表中的格式，  
	//将此 Properties 表中的属性列表（键和元素对）写入输出流  
	prop.store(outstream, "Update checkdata to " + checkdata + "");
	response.sendRedirect("/login/UpgradeSetting.jsp");
	return;
} else {
	response.sendRedirect("/login/UpgradeSetting.jsp?error=1");
	return;
}


%>