
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<HTML>
<HEAD>
<%@ include file="/jsp/systeminfo/init_wev8.jsp" %>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</HEAD>

<%
String imagefilename = "/images/hdNoAccess_wev8.gif";
String titlename = "";
String needfav ="";
String needhelp ="";
String message = "";
String errortype = request.getParameter("errortype");
if("1".equals(errortype)) {
	message="网络无法连接 ,无法获取升级包信息。";
} else if("2".equals(errortype)){
	message="客户编号未设置，请联系泛微工作人员，提供编号。";
} else if("3".equals(errortype)){
	message="web.xml未配置，请参照《升级工具使用手册》进行配置。";
}else {
	message="定时扫描开关未打开,无法获取升级包信息。";
}
%>
<script language="JavaScript">

</script>
<BODY>

<div style="width:100%;position:absolute;top:20%;text-align:center;vertical-align:middle;">
	<img src="/images/ecology8/noright_wev8.png" width="162px" height="162px"/>
	<div id="message" style="color:rgb(255,187,14);"><%=message %></div>
</div>

</BODY>
</HTML>