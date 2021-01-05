<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
//校验名称是否存在
String name= Util.null2String(request.getParameter("nameStr"));
String mobile=Util.null2String(request.getParameter("mobile"));
//String method=Util.null2String(request.getParameter("method"));
out.clearBuffer();
//String sqlWhere = "";

String success = "0";
String mobileExist = "0";
if(!"".equals(name)){
	String tempSql = "select lastname from HrmResource where lastname='"+name+"'";
	RecordSet.executeSql(tempSql);
	if(RecordSet.next()){
	    success = "1";
	}
}
if(!"".equals(mobile)){
    String tempSql = "select mobile from HrmResource where mobile='"+mobile+"' or loginid = '"+mobile+"'";
	RecordSet.executeSql(tempSql);
	if(RecordSet.next()){
	    mobileExist = "1";
	}
}
out.println("{\"success\":\""+success+"\",\"mobileExist\":\""+mobileExist+"\"}");
%>