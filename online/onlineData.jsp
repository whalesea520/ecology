
<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.online.HrmUserOnlineMap" %>

<%
	//out.clearBuffer();
	String jsonStr = HrmUserOnlineMap.getInstance().getCluterMapJSON();
		out.println(jsonStr);

%>
