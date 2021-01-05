<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-13[班次设置] Generated from 长东设计 www.mfstyle.cn -->
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(125800, user.getLanguage());

	if(!HrmUserVarify.checkUserRight("HrmSchedulingShifts:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	if(!strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
		response.sendRedirect("/hrm/schedule/hrmScheduleShiftsSet/tab.jsp?topage=list");
		return;
	}
%>
<html>
	<head>
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

			function jsReloadTree() {
				document.getElementById('leftframe').contentWindow.initTree();
			}
		</script>
	</head>
	<body scroll="no">
		<table width="100%" id="oTable1" height="100%" cellpadding="0px" cellspacing="0px">
			<tbody>
				<tr>
					<td height="100%" id="oTd1" name="oTd1" width="220px">
						<iframe name="leftframe" id="leftframe" src="/hrm/schedule/hrmScheduleShiftsSet/left.jsp?rightStr=HrmSchedulingShifts:set" width="100%" height="100%" frameborder="no" scrolling="no"></iframe>
					</td>
					<td height="100%" id="oTd2" name="oTd2" width="*">
						<iframe name="contentframe" id="contentframe" src="/hrm/schedule/hrmScheduleShiftsSet/tab.jsp?topage=list" width="100%" height="100%" frameborder="no" scrolling="yes"></iframe>
					</td>
				</tr>
			</tbody>
		</table>
	</body>
</html>
