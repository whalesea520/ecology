<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<html>
<head>
<script type="text/javascript">
	if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function() {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function() {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
</script>
</head>
<body scroll="no" style="margin: 0; padding: 0; overflow: hidden;">
	<table class="viewform" width="100%" id="oTable1" height="100%" cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td height="100%" id="oTd1" name="oTd1" width="220px" style="padding: 0px; padding-left: 0px;">
					<iframe name="leftframe" id="leftframe" src="SysRemindInfoTree.jsp" width="100%" height="100%" frameborder="no" scrolling="no">
						<%=SystemEnv.getHtmlLabelName(83722, user.getLanguage())%>
					</iframe>
				</td>
				<td height="100%" id="oTd2" name="oTd2" width="*" id="tdcontent" style="padding: 0px; padding-left: 0px;">
					<iframe name="contentframe" id="contentframe" src="SysRemindInfoDefault.jsp" width="100%" height="100%" frameborder="no" scrolling="auto">
						<%=SystemEnv.getHtmlLabelName(83722, user.getLanguage())%>
					</iframe>
				</td>
			</tr>
		</tbody>
	</table>
</body>
</html>