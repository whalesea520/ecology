<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"), 0);

String oTd1Display = "";
if(fnaVoucherXmlId <= 0){
	oTd1Display = "display:none;";
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript src="/js/ecology8/fna/FnaSearchInit_wev8.js?r=5"></script>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"/hrm/search/HrmResourceSearchTmp.jsp";
//alert(contentUrl);
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
<body style="overflow:hidden;">
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
<TBODY>
<tr>
<td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px;<%=oTd1Display %>’>
	<IFRAME name=leftframe id=leftframe src="/fna/fnaVoucher/fnaVoucherXmlLeft.jsp?fnaVoucherXmlId=<%=fnaVoucherXmlId %>" width="100%" height="100%" frameborder=no scrolling=no>
	//浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
	<IFRAME name=optFrame id=optFrame src="/fna/fnaVoucher/fnaVoucherXmlView.jsp?fnaVoucherXmlId=<%=fnaVoucherXmlId %>" width="100%" height="100%" frameborder=no scrolling=yes>
	//浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
</TBODY>
</TABLE>
</body>

</html>