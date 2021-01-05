
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/address_wev8.gif";
String titlename = "通讯录" + " - " + "列表页面";
String needfav ="1";
String needhelp ="1";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
   if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
   
</script>

</HEAD>
<body>
<TABLE class=viewform width=100% id=oTable1 height=100%>
<TBODY>
<tr>
<td colspan="3"><%@ include file="/systeminfo/TopTitle_wev8.jsp" %></td>
</tr>
<tr>
<td width="20%" height=100% id=oTd1 name=oTd1>
<IFRAME name=leftframe id=leftframe src="/addressbook/AddressBookLeft.jsp" width="100%" height="100%" frameborder=no scrolling=auto>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td width="1%" height=100% id=oTd0 name=oTd0 align=center>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td width="79%" height=100% id=oTd2 name=oTd2>
<IFRAME name=contentframe id=contentframe src="/addressbook/AddressBookView.jsp" width="100%" height="100%" frameborder=no scrolling=auto>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
</TBODY>
</TABLE>
</body>

</html>