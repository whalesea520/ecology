<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*,org.json.*" %>
<%@ page import="weaver.hrm.*" %>


<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
		
	FileUpload fu = new FileUpload(request,"utf-8");
	int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));
	JSONObject obj = new JSONObject();
	obj.put("imageid",imagefileid);
	out.println(obj.toString());
	
%>





