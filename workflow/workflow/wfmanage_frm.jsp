<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//是否为流程模板
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
//判断是否分权设置
String rightSha=Util.null2String(request.getParameter("rightSha"));
String subCompanyId=Util.null2String(request.getParameter("subCompanyId"));
session.setAttribute("queryParam_subcompanyId",subCompanyId);
//公文流程
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
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
<!--
<frameset cols="250,*" frameborder="no" border="1" framespacing="1">
  <frame src="wfmanage_left2.jsp?isTemplate=<%=isTemplate%>" scrolling="auto" name="wfleftFrame"  id="leftFrame" />
  <frame src="" scrolling="auto" name="wfmainFrame" id="mainFrame" />
</frameset>
<noframes>
-->
<body scroll="no">
<%
if(!rightSha.equals("") && rightSha.equalsIgnoreCase("share") && rightSha!=null){  //分权设置
%>
<TABLE class="flowsTable" width=100% id=oTable1 height=100%>
<%}else{%>
<TABLE class="flowsTable" id=oTable1 style="height: 99%;width:100%;cellpadding:0px;cellspacing:0px;">
<%}%>
  <TBODY>
<tr>
<%if(!isWorkflowDoc.equals("1")){%>
<td  height=100% id=oTd1 name=oTd1 width="247px">
<IFRAME name=wfleftFrame id=wfleftFrame src="wfmanage_left2.jsp?isWorkflowDoc=<%=isWorkflowDoc %>&isTemplate=<%=isTemplate%>&subCompanyId=<%=subCompanyId%>" width="100%" height="100%" frameborder=no scrolling=no  style="padding:0px;background:#ffffff!important;">
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<%}%>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px;background:#ffffff!important;">
<IFRAME name=wfmainFrame id=wfmainFrame src="managewfTab.jsp?isWorkflowDoc=<%=isWorkflowDoc %>&isTemplate=<%=isTemplate %>&subCompanyId=<%=subCompanyId%>" width="100%" height="100%" frameborder=no scrolling=no >
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
</body>
</html>
