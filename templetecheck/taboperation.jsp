<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.templetecheck.ConfigUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD></HEAD><body></body></HTML>
<%
ConfigUtil configUtil  =  new ConfigUtil();
String[] ids = request.getParameterValues("id");
String[] names = request.getParameterValues("tabname");

String ishtmlval = request.getParameter("ishtmlval");

ishtmlval = ishtmlval.substring(1,ishtmlval.length());
String[] ishtmls = ishtmlval.split(",");


configUtil.save(ids,names,ishtmls);

response.sendRedirect("tabconfig.jsp");
%>