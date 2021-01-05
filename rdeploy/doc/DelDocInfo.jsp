<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page"/>
<% 
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	int docId= Integer.parseInt(Util.getIntValues(request.getParameter("docId")));
    DocManager.setId(docId);
	DocManager.DeleteDocInfo();
	
%>