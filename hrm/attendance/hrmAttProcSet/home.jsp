<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<!-- Added by wcd 2015-04-21[考勤流程设置] -->
<%
	if(!HrmUserVarify.checkUserRight("HrmAttendanceProcess:setting", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif", needfav ="1", needhelp ="";
	String titlename = SystemEnv.getHtmlLabelName(82797,user.getLanguage());
	
	if(!Util.null2String(ManageDetachComInfo.getDetachable()).equals("1")) {
		response.sendRedirect("/hrm/attendance/hrmAttProcSet/tab.jsp?topage=list");
		return;
	}
%>
<HTML>
	<HEAD>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<script type="text/javascript">
			if (window.jQuery.client.browser == "Firefox") {
				jQuery(document).ready(function () {
					jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
					window.onresize = function () {
						jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
					};
				});
			}
	
			function jsReloadTree(){
				document.getElementById('leftframe').contentWindow.initTree(); 
			}
		</script>
	</HEAD>
	<body scroll="no">
		<TABLE width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
			<TBODY>
				<tr>
					<td height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
						<IFRAME name=leftframe id=leftframe src="/hrm/attendance/hrmAttProcSet/left.jsp?rightStr=HrmAttendanceProcess:setting" width="100%" height="100%" frameborder=no scrolling=no></IFRAME>
					</td>
					<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent">
						<IFRAME name=contentframe id=contentframe src="/hrm/attendance/hrmAttProcSet/tab.jsp?topage=list" width="100%" height="100%" frameborder=no scrolling=yes></IFRAME>
					</td>
				</tr>
			</TBODY>
		</TABLE>
	</body>
</html>