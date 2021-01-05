<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");    	
		return;
	}
	//是否分权系统，如不是，则不显示框架，直接转向到列表页面
	boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
	if(isUseWfManageDetach){
		session.setAttribute("detachable","1");
	}else{
	    session.setAttribute("detachable","0");
	    response.sendRedirect("/workflow/report/ReportType_frm.jsp");
	    return;
	}
%>
<html>
<head>
	<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script language="JavaScript">
	function getParentHeight() {
		if(parent.parent.window.document.getElementById('leftFrame') == null) {
		  	return "100%";
		}else {
			return parent.parent.window.document.getElementById('leftFrame').scrollHeight;
		}
	}
	if (window.jQuery.client.browser == "Firefox") {
			jQuery(document).ready(function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
				window.onresize = function () {
					jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
				};
			});
	}
	</script>
</head>
<body style="overflow:hidden;">
	<table class="viewform" id=oTable1 style="height:100%;width:100%;" cellpadding="0px" cellspacing="0px">
	  <tbody>
		<tr>
			<td height=100% id="oTd1" name="oTd1" style="padding:0px;width:247px;">
				<iframe name="leftframe" id="leftframe" src="Report_left.jsp?rightStr=WorkflowReportManage:All" width="100%" height="100%" frameborder=no scrolling=no >
					<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
				</iframe>
			</td>
			<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px">
				<iframe name="contentframe" id="contentframe" src="/workflow/report/ReportType_frm.jsp"  height="100%" width="100%" frameborder=no scrolling=no>
					<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
				</iframe>
			</td>
		</tr>
	  </tbody>
	</table>
 </body>
</html>
