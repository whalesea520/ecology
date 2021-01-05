<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String detachable = Util.null2String(request.getParameter("detachable"));
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
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
<body scroll="no">
<%
if(!detachable.equals("") && detachable.equalsIgnoreCase("1") && detachable!=null){  //分权设置
%>
<TABLE class="" width=100% id=oTable1 height=100%>
<%}else{%>
<TABLE class="" width=100% id=oTable1 style="height: 100%;" cellpadding="0px" cellspacing="0px">
<%}%>
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="245px" style="padding:0px;display:none;">
<IFRAME name=wfleftFrame id=wfleftFrame src="leftTree.jsp" width="100%" height="100%" frameborder=no scrolling=no  style="padding:0px;background:#ffffff!important;">
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px;background:#ffffff!important;">
<IFRAME name=wfmainFrame id=wfmainFrame src="managewfTab.jsp?1=1" width="100%" height="100%" frameborder=no scrolling=no >
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
</body>
</noframes></html>
