<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser (request , response) ;
	
	if (null == user) {
	    return;
	}
	FileUpload fu = new FileUpload(request,"utf-8");
	int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));
	
	String comefrom = Util.null2String(fu.getParameter("comefrom"));
	if(!comefrom.isEmpty() && imagefileid > 0){
	    RecordSet rs = new RecordSet();
	    rs.executeSql("update ImageFile set comefrom='" + comefrom + "' where imagefileid=" + imagefileid);
	}
	
	
	out.println(imagefileid);
%>