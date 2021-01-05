
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.rdeploy.workflow.WFNodeBean"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>

<%

/////////////35内部留言、36通知公告
int workflowid = Util.getIntValue(request.getParameter("wfid"),0);
String modeurl = "/workflow/workflow/addwf.jsp?src=editwf&wfid="+workflowid+"&isTemplate=0&versionid_toXtree=1";

//权限校验
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(workflowid, 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String initUrl = "/rdeploy/wf/request/wfEditInterface.jsp?wfid="+workflowid;
%>
<html>
	<head>	
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

	<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
    <script type="text/javascript">
	    var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.getParentWindow(window);
			dialog =parent.getDialog(window);
		}catch(e){}
		
	</script>
</head>
<body>
	<div style="width:100%;height: 93%;">
		<iframe src="<%=initUrl %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	</div>

	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
		<tr><td style="text-align:center;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="javascript:onSaveNode()">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
		</td></tr>
	</table>
	</div>
</body>
<script type="text/javascript">
function onSaveNode() {
	//var checkfields = jQuery("#tabcontentframe").contents().find("#checkfield").val();
	//if (check_form(document.getElementById("tabcontentframe").contextWindow.document.wfEditForm,checkfields){
	//	alert(1);
	//	wfEditForm.submit();
	//}
	
	tabcontentframe.window.doSave();
}
</script>
</html>