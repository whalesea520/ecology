
<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="serverStatus" class="weaver.manageplat.monitor.ServerStatus" scope="page" />
<%
String jsonStr = serverStatus.getJvmMemSnapshot();

String callback = request.getParameter("callback");
out.println(callback + "(" + jsonStr + ")");
%>