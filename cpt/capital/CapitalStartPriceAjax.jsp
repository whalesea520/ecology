
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.*,weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
%>
<%
	String id = Util.null2String(request.getParameter("id"));
	String resultStr = "";
	RecordSet.executeSql("select startprice from CptCapital where id = " + id);
	if(RecordSet.next()){
		//System.out.println("aaaaaaaa");
	    resultStr = RecordSet.getString(1);
	}
%>
<%=resultStr%>