<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.JSONObject"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-05-21[流程表单] -->
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String sqlwhere = xssUtil.put(strUtil.vString(request.getParameter("sqlwhere")));
	String selectids = strUtil.vString(request.getParameter("selectedids"));
	String resourceids = strUtil.vString(request.getParameter("resourceids"));
	if(selectids.length()==0) selectids = resourceids;
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<link rel="stylesheet" type="text/css" href="/js/tabs/css/e8tabs1_wev8.css">
		<script type="text/javascript" src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	</head>
	<body scroll="no">
		<div class="e8_box demo2">
			<div class="e8_boxhead">
				<div class="div_e8_xtree" id="div_e8_xtree"></div>
				<div class="e8_tablogo" id="e8_tablogo"></div>
				<div class="e8_ultab">
					<div class="e8_navtab" id="e8_navtab">
						<span id="objName"></span>
					</div>
					<div>
						<div id="rightBox" class="e8_rightBox"></div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<iframe id="frame1" name="frame1" width="100%" height="160px" frameborder="no" src="/hrm/attendance/workflowBill/multiSearch.jsp?sqlwhere=<%=sqlwhere%>" scrolling="yes"></iframe>
					<iframe id="frame2" name="frame2" width="100%" height="375px" frameborder="0" src="/hrm/attendance/workflowBill/multiSelect.jsp?selectids=<%=selectids%>&sqlwhere=<%=sqlwhere%>" class="flowFrame" onload="update();"></iframe>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			function onCancel() {
				try{parent.getDialog(window).close();}catch(e){}
				doClose();
			}

			function doClose() {
				try{parent.parent.getParentWindow(window).closeDialog();}catch(e){}
			}

			jQuery('.e8_box').Tabs({
				getLine:1,
				iframe:"frame1",
				needNotCalHeight:true,
				mouldID:"<%=MouldIDConst.getID("workflow")%>",
				objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(34130,user.getLanguage())) %>,
				staticOnLoad:true
			});
		</script>
	</body>
</html>
