<%@ page language="java" contentType="application/json" pageEncoding="utf-8"%>
<%@ page import="weaver.docs.networkdisk.server.NetworkDiskSetting" %>
<%
String id = request.getParameter("id");
String nds = NetworkDiskSetting.getSettings(id);
out.println(nds);
%>