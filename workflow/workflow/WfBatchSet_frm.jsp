<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
	boolean hasPermission = wfrm.hasPermission2(0, user, WfRightManager.OPERATION_CREATEDIR);
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !hasPermission){
		response.sendRedirect("/notice/noright.jsp");    	
		return;
	}
%>
<html>
<head>
</head>
<body scroll="no">
	<table class="viewform" id="oTable" cellpadding="0px" cellspacing="0px" height="100%" width="100%">
	  <tbody>
		<tr>
			<td  height="100%" id="oTd1" name="oTd1" width="247px" style="padding:0px;">
				<iframe name="leftframe" id="leftframe" src="/workflow/workflow/WfBatchSet_left.jsp" width="100%" height="100%" frameborder=no scrolling=no >
					<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
				</iframe>
			</td>
			<td height="100%" id="oTd2" name="oTd2" width="*" style="padding:0px" >
				<iframe name="contentframe" id="contentframe" src="/workflow/workflow/WfBatchSet_mainTab.jsp" width="100%" height="100%" frameborder=no scrolling=no >
					<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
				</iframe>
			</td>
		</tr>
	  </tbody>
	</table>
 </body>
</html>