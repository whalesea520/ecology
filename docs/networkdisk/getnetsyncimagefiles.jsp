<%@ page language="java" contentType="application/json" pageEncoding="utf-8"%>
<%@ page import="weaver.docs.networkdisk.server.NetworkDiskSetting" %>
<%
// 用户登录ID
String loginId = request.getHeader("loginId");
// 客户端GUID
String clientguid = request.getHeader("clientguid");
String sif = NetworkDiskSetting.getSyncFiles(clientguid);
response.setHeader("sifs", sif);
%>