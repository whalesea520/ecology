
<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="settingCheck" class="weaver.manageplat.monitor.SettingCheck" scope="page" />
<%
String jsonStr = "";
String checkOpt = request.getParameter("");
if(checkOpt == null || "".equals(checkOpt)) {
	jsonStr = settingCheck.getSysSetting();
} else {
	jsonStr = settingCheck.check(checkOpt);
}

String callback = request.getParameter("callback");
out.println(callback + "(" + jsonStr + ")");
%>