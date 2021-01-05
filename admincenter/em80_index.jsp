<!DOCTYPE HTML>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String sessionKey = request.getSession().getId();
String type = Util.null2String(request.getParameter("type"));
String emServer = new BaseBean().getPropValue("emserver","server");
session.setAttribute(sessionKey,user.getLoginid());
if(emServer==null||emServer.equals("")){
	response.sendRedirect("/jsp/index.jsp");
	return;
}
if(type.equals("")||type.equals("0")){//系统状态
	response.sendRedirect(emServer+"/component/manageplat/service?from=ecology&JSESSIONID="+sessionKey);
	return;
}else if(type.equals("3")){//升级向导
	response.sendRedirect(emServer+"/component/manageplat/upgrade?JSESSIONID="+sessionKey);
	return;
}else if(type.equals("2")){//配置向导
	response.sendRedirect(emServer+"/component/manageplat/settting?JSESSIONID="+sessionKey);
	return;
}else if(type.equals("4")){//升级日志
	response.sendRedirect(emServer+"/component/manageplat/upgradelog?sessionKey="+sessionKey);
	return;
}else if(type.equals("1")){//密码设置
	response.sendRedirect(emServer+"/usercenter/modifypsw?sessionKey="+sessionKey);
	return;
}
%>
