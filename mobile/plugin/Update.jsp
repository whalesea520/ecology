
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

Map result=new HashMap();

result=ps.mobileUpdate();

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>