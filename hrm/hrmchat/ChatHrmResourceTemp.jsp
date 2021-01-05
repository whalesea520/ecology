
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.general.Util" %>
<%
String id = Util.null2String(request.getParameter("userid"));
RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();
String lastname = RecordSet.getString("lastname") ;/*姓名*/
String loginid = RecordSet.getString("loginid"); ;/*登录名*/
out.print(lastname+","+loginid);
%>