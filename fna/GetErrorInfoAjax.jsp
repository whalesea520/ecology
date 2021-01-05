<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.general.BaseBean"%><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%><%
String _errorInfo = "";
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	_errorInfo = SystemEnv.getHtmlLabelName(83328, user.getLanguage());
}else{
	String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
	_errorInfo = Util.null2String((String)request.getSession().getAttribute("errorInfo:"+_guid1)).trim();
	request.getSession().removeAttribute("errorInfo:"+_guid1);
}
%><%=_errorInfo %>