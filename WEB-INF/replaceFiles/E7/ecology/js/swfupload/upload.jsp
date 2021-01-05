<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>


<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	FileUpload fu = new FileUpload(request);
	int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));

	//System.out.println("imagefileid:"+imagefileid);


	String imagefileids=(String) session.getValue("imagefileids");
	session.putValue("imagefileids",imagefileids+"+"+imagefileid);


%>





