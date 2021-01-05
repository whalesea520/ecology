
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>

<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />

<%
FileUpload fu = new FileUpload(request);

String tips = "<span style='color:red'>保存失败</span>";

String hrmorder = Util.null2String(fu.getParameter("hrmorder"));
String isShowTerminal = Util.null2String(fu.getParameter("isShowTerminal"));
String wfscope = Util.null2String(fu.getParameter("wfscope"));
String wfids = Util.null2String(fu.getParameter("wfids"));
String hrmbtnshow = Util.null2String(fu.getParameter("hrmbtnshow"));
String hrmorgbtnshow = Util.null2String(fu.getParameter("hrmorgbtnshow"));
String allPeopleshow = Util.null2String(fu.getParameter("allPeopleshow"));
String sameDepartment = Util.null2String(fu.getParameter("sameDepartment"));
String commonGroup = Util.null2String(fu.getParameter("commonGroup"));
String groupChat = Util.null2String(fu.getParameter("groupChat"));
String mysubordinateshow = Util.null2String(fu.getParameter("mysubordinateshow"));
String UntreatedFirst = Util.null2String(fu.getParameter("UntreatedFirst"));
String isUsingCA = Util.null2String(fu.getParameter("isUsingCA"));
String caServerAddress = Util.null2String(fu.getParameter("caServerAddress"));
String caUsageMode = Util.null2String(fu.getParameter("caUsageMode"));
String androidsign = Util.null2String(fu.getParameter("androidsign"));
String iossign = Util.null2String(fu.getParameter("iossign"));
String ioskey = Util.null2String(fu.getParameter("ioskey"));
String androidkey = Util.null2String(fu.getParameter("androidkey"));
String iosWpskey = Util.null2String(fu.getParameter("iosWpskey"));
String encryptpassword = Util.null2String(fu.getParameter("encryptpassword"));

boolean result = ps.saveMobileProp("hrmorder", hrmorder);
if(result) result = ps.saveMobileProp("isShowTerminal", isShowTerminal);
if(result) result = ps.saveMobileProp("wfscope", wfscope);
if(result) {
	ArrayList wflist = null;
	if("1".equals(wfscope) || "2".equals(wfscope)) wflist = Util.TokenizerString(wfids, ",");
	ps.saveMobileProp("wfid", wflist);
}
application.removeAttribute("emobile_config_isShowTerminal");
if(result) result = ps.saveMobileProp("hrmbtnshow", hrmbtnshow);
if(result) result = ps.saveMobileProp("hrmorgbtnshow", hrmorgbtnshow);
if(result) result = ps.saveMobileProp("allPeopleshow", allPeopleshow);
if(result) result = ps.saveMobileProp("sameDepartment", sameDepartment);
if(result) result = ps.saveMobileProp("commonGroup", commonGroup);
if(result) result = ps.saveMobileProp("groupChat", groupChat);
if(result) result = ps.saveMobileProp("mysubordinateshow", mysubordinateshow);
if(result) result = ps.saveMobileProp("UntreatedFirst", UntreatedFirst);
if(result) result = ps.saveMobileProp("isUsingCA", isUsingCA);
if(result) result = ps.saveMobileProp("caServerAddress", caServerAddress);
if(result) result = ps.saveMobileProp("caUsageMode", caUsageMode);
if(result) result = ps.saveMobileProp("androidsign", androidsign);
if(result) result = ps.saveMobileProp("iossign", iossign);
if(result) result = ps.saveMobileProp("ioskey", ioskey);
if(result) result = ps.saveMobileProp("androidkey", androidkey);
if(result) result = ps.saveMobileProp("iosWpskey", iosWpskey);
if(result) result = ps.saveMobileProp("encryptpassword", encryptpassword);
if(result) tips = "<span style='color:green'>保存成功</span>";
%>
<!DOCTYPE html>
<html>
	<head>
		<style>
			*{
				font-size:15px;
				font-family:"微软雅黑";
			}
		</style>
	</head>
	<body>
		<div style='text-align: center;'><%=tips %></div>
	</body>
</html>