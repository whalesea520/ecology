
<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="settingCheck" class="weaver.manageplat.monitor.SettingCheck" scope="page" />
<%
String jsonStr = "";
String mobile_ecip = request.getParameter("mobile_ecip");
String rtx_svrip = request.getParameter("rtx_svrip");
String mail_smtpip = request.getParameter("mail_smtpip");
String mail_smtpport = request.getParameter("mail_smtpport");

if(mobile_ecip != null) {
	jsonStr = settingCheck.setMobile(mobile_ecip);
} else if(rtx_svrip != null) {
	jsonStr = settingCheck.setRtx(rtx_svrip);
} else if(mail_smtpip != null) {
	if(mail_smtpport == null || "".equals(mail_smtpport)) {
		mail_smtpport = "25";
	}
	jsonStr = settingCheck.setMail(mail_smtpip, mail_smtpport);
}

String callback = request.getParameter("callback");
out.println(callback + "(" + jsonStr.toString() + ")");
%>