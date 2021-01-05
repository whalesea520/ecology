<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@page import="weaver.general.BaseBean"%><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%><%
String result = "";
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	result = "";
}else{
	String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
	String _index = Util.null2String((String)request.getSession().getAttribute("index:"+_guid1)).trim();
	boolean _isDone = "true".equals(Util.null2String((String)request.getSession().getAttribute("isDone:"+_guid1)).trim());
	if(_isDone){
		request.getSession().removeAttribute("index:"+_guid1);
		request.getSession().removeAttribute("isDone:"+_guid1);
		result = "isDone";
	}else if(!"".equals(_index)){
		result = _index;
	}else{
		result = "";
	}
}
%><%=result %>