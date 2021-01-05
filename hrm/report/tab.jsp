<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wangcd 2015-08-26[人事报表] Generated from 长东设计 www.mfstyle.cn -->
<%
	String url = "";
	String title = SystemEnv.getHtmlLabelName(16530, user.getLanguage());
	boolean hasTree = false;
	String mouldid = "resource";
	ShowTab tab = new ShowTab(rs, user);
	String topage = strUtil.vString(request.getParameter("topage"));
	if(topage.equals("abnormalAtt")) {
		title = SystemEnv.getHtmlLabelName(30560, user.getLanguage());
		url = "/hrm/report/schedulediff/HrmScheduleAbnormalAttendanceDetail.jsp";
	} else if(topage.equals("abnormalAttCustom")) {
		title = SystemEnv.getHtmlLabelNames("362,15880,32104,15148", user.getLanguage());
		url = "/hrm/report/customPage/AbnormalAttendanceDetail.jsp?wPage=more";
	} else if(topage.equals("hrmReport")) {
		String fromDate = strUtil.vString(request.getParameter("fromDate"));
		String toDate = strUtil.vString(request.getParameter("toDate"));
		String validDate = strUtil.vString(request.getParameter("validDate"));
		String subCompanyId = strUtil.vString(request.getParameter("subCompanyId"));
		String departmentId = strUtil.vString(request.getParameter("departmentId"));
		String resourceId = strUtil.vString(request.getParameter("resourceId"));
		
		String name = strUtil.vString(request.getParameter("name"));
		if(name.equals("HrmScheduleOvertimeWorkDetail")) {
			title = SystemEnv.getHtmlLabelName(33501, user.getLanguage());
		}
		url = "/hrm/report/schedulediff/"+name+".jsp?isdialog=1&fromDate="+fromDate+"&toDate="+toDate+"&validDate="+validDate+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&resourceId="+resourceId;	
	}
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
