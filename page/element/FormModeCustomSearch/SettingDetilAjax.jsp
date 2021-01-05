<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String id = Util.null2String(request.getParameter("id"));
String action = Util.null2String(request.getParameter("action"));
if(action.equals("delete")){
	RecordSet rs = new RecordSet();
	rs.executeSql("delete from formmodeelement where id="+id);
	out.println("ok");
}
%>