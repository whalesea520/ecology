<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.attendance.domain.HrmAttProcSet"%>
<!-- Added by wcd 2015-05-19[考勤流程设置] -->
<%@ include file="/hrm/header.jsp"%>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<%
	String url = "";
	String title = "";
	boolean hasTree = false;
	String mouldid = "resource";
	ShowTab tab = new ShowTab(rs, user);
	String id = strUtil.vString(request.getParameter("id"));
	String topage = strUtil.vString(request.getParameter("topage"));
	if(topage.equals("list")) {
		title = SystemEnv.getHtmlLabelName(82797,user.getLanguage());
		url = "/hrm/attendance/hrmAttProcSet/list.jsp?subcompanyid="+strUtil.vString(request.getParameter("subcompanyid"));
		if(strUtil.vString(ManageDetachComInfo.getDetachable()).equals("1")) hasTree = true;
	} else if(topage.equals("content")) {
		HrmAttProcSet bean = attProcSetManager.get(id);
		bean = bean == null ? new HrmAttProcSet() : bean;
		
		title = SystemEnv.getHtmlLabelNames("15880,18015",user.getLanguage());
		String subcompanyid = strUtil.vString(request.getParameter("subcompanyid"));
		url = "/hrm/attendance/hrmAttProcSet/content.jsp?id="+id+"&subcompanyid="+subcompanyid;
		tab.add(new TabLi(url,SystemEnv.getHtmlLabelName(82826,user.getLanguage()),true));
		if(strUtil.isNotNull(id)) tab.add(new TabLi("/hrm/attendance/hrmAttProcSet/wfFields.jsp?id="+id,SystemEnv.getHtmlLabelNames("15880,82827",user.getLanguage())));
		int field006 = strUtil.parseToInt(request.getParameter("field006"));
		if((field006 == 0 && bean.getField002() != 180) || field006 == 3 || field006 == 5) tab.add(new TabLi("/hrm/attendance/hrmAttProcSet/wfSet.jsp?id="+id,SystemEnv.getHtmlLabelName(33085,user.getLanguage())));
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
