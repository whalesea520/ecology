<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//是否为流程模板
//判断是否分权设置
String rightStr = "WorkflowCustomManage:All";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"),"");
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
			jQuery("#leftcontentframe,#middleframe,#wfmainFrame").height(jQuery("#leftcontentframe").parent().height());
			window.onresize = function () {
				jQuery("#leftcontentframe,#middleframe,#wfmainFrame").height(jQuery("#leftcontentframe").parent().height());
			};
		});
	}
</script>
</head>

<body style="overflow:hidden;">
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 style="padding:0px;width:247px;">
<IFRAME name=leftcontentframe id=leftcontentframe src="/workflow/workflow/CustomQueryType_left.jsp?subcompanyid=<%=subcompanyid %>" width="100%" height="100%" frameborder=no scrolling=no >
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 style="padding:0px;width:*;">
<IFRAME name=wfmainFrame id=wfmainFrame src="/workflow/workflow/CustomQuerySetTab.jsp?subcompanyid=<%=subcompanyid %>" width="100%" height="100%" frameborder=no scrolling=auto>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
</body>
</html>