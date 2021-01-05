<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.formmode.search.FormModeTransMethod"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	User user = HrmUserVarify.getUser (request , response);
	response.reset();
	FormModeTransMethod method = new FormModeTransMethod();

	JSONObject obj = method.getCustomBrowserUrl(request, user);
	response.getWriter().print(obj.toString());
 %>
 