
<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="svrstatus" class="weaver.manageplat.monitor.ServerStatus" scope="page" />
<%
ServletContext sctx = getServletConfig().getServletContext();
String jsonStr = svrstatus.getServerStatus(sctx);

String callback = request.getParameter("callback");
out.println(callback + "(" + jsonStr + ")");
%>