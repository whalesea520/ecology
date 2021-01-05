<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),-1);
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function getParentHeight() {
		if(parent.parent.window.document.getElementById('leftFrame') == null) {
		  	return "100%";
		}else {
			return parent.parent.window.document.getElementById('leftFrame').scrollHeight;
		}
	}
	if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#wfleftFrame,#middleframe,#wfmainFrame").height(jQuery("#wfleftFrame").parent().height());
			window.onresize = function () {
				jQuery("#wfleftFrame,#middleframe,#wfmainFrame").height(jQuery("#wfleftFrame").parent().height());
			};
		});
	}
</script>
</head>
<body style="overflow:hidden;">
	<table class=viewform width="100%" id=oTable1 height="100%" cellpadding="0px" cellspacing="0px">
		<tr>
			<td id="oTd1" name="oTd1" style="padding:0px;width:247px;" height=100%>
				<iframe name="wfleftFrame" id="wfleftFrame" src="/workflow/report/ReportType_left.jsp?subcompanyid=<%=subcompanyid %>" width="100%" height="100%" frameborder=no scrolling=no >
					<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
				</iframe>
			</td>
			<td id="oTd2" name="oTd2" style='padding:0px;width:*;' height=100%>
				<iframe name="wfmainFrame" id="wfmainFrame" src="/workflow/report/ReportManageTab.jsp?subcompanyid=<%=subcompanyid %>" width="100%" height="100%" frameborder=no scrolling=no>
				<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
				</iframe>
			</td>
		</tr>
	</table>
</body>
</html>
