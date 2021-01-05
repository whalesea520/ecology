<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="weaver.file.Prop" %>
<%
String flvServerIP=Prop.getPropValue("weaver","FLVSERVERIP");
String url="";
if(!flvServerIP.equalsIgnoreCase("")){
	url="/uploadflv/UploadFlv.jsp";
}
String s="var flvBrowserUrl='"+url+"';";
out.println(s);
%>