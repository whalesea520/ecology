<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-10[排班人员范围] Generated from 长东设计 www.mfstyle.cn -->
<%
	String url = "";
	String title = SystemEnv.getHtmlLabelName(32766, user.getLanguage());
	boolean hasTree = false;
	String mouldid = "resource";
	ShowTab tab = new ShowTab(rs, user);
	String topage = strUtil.vString(request.getParameter("topage"));
	if(topage.equals("list")) {
		url = "/hrm/schedule/hrmSchedulePersonnel/list.jsp";
	} else if(topage.equals("content")) {
		title = SystemEnv.getHtmlLabelName(124810, user.getLanguage());
		url = "/hrm/schedule/hrmSchedulePersonnel/content.jsp";
	}
	url += strUtil.isNull(request.getQueryString()) ? "" : "?" + strUtil.vString(request.getQueryString());
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/js/tabs/css/e8tabs1_wev8.css">
		<link rel="stylesheet" type="text/css" href="/css/ecology8/request/searchInput_wev8.css">
		<link rel="stylesheet" type="text/css" href="/css/ecology8/request/seachBody_wev8.css">
		<link rel="stylesheet" type="text/css" href="/css/ecology8/request/hoverBtn_wev8.css">
		<script type="text/javascript" src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
		<script type="text/javascript">
			$(function(){
				$('.e8_box').Tabs({
					getLine:1,
					iframe:"tabcontentframe",
					mouldID:"<%=MouldIDConst.getID(mouldid)%>",
					staticOnLoad:true,
					objName:"<%=title%>"
				});
			});
			function refreshTab() {
				jQuery('.flowMenusTd',parent.document).toggle();
				jQuery('.leftTypeSearch',parent.document).toggle();
			}
		</script>
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
						<ul class="tab_menu"><%out.println(hasTree ? "<li class=\"e8_tree\"><a onClick=\"javascript:refreshTab();\"></a></li>" : "");out.println(tab.show());%></ul>
						<div id="rightBox" class="e8_rightBox"></div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
	</body>
</html>
