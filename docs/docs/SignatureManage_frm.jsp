
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";


String hrmdetachable="0";
boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
if(isUseHrmManageDetach){
   hrmdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("hrmdetachable",hrmdetachable);
}else{
   hrmdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("hrmdetachable",hrmdetachable);
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
if (window.jQuery.client.browser == "Firefox"||window.jQuery.client.browser == "Chrome") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
</script>
</HEAD>
<body  scroll="no">
<TABLE width="100%" id=oTable1 height="100%" cellpadding="0px" cellspacing="0px" style="border: 0">
  <TBODY> 
	<tr>
		<td height=100% id=oTd1 name=oTd1 width="220px" style="border-right:0px;">
			<IFRAME name=leftframe id=leftframe width="100%" src="SignatureManage_left.jsp?rightStr=SignatureAdd:Add" height="100%" frameborder=no scrolling=no style="border: 0px">
			浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent">
			<IFRAME name=contentframe id=contentframe src="/hrm/HrmTab.jsp?_fromURL=SignatureList" width="100%" height="100%" frameborder=no scrolling=no>
			浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
		</td>
	</tr>
  </TBODY>
</TABLE>
 </body>
</html>