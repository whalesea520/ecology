
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="sm" class="weaver.synergy.SynergyManage" scope="page"/>
<%
out.print(sm.getElementSetting(request));
%>

	