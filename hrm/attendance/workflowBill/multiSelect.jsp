<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-05-21[流程表单] -->
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String sqlwhere = xssUtil.put(strUtil.vString(request.getParameter("sqlwhere")));
	String selectids = strUtil.vString(request.getParameter("selectids"));
	String resourceids = strUtil.vString(request.getParameter("resourceids"));
	if(selectids.length()==0) selectids = resourceids;
	String namelabel = strUtil.vString(request.getParameter("namelabel"));
	String isBill = strUtil.vString(request.getParameter("isBill"));
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<link rel="stylesheet" type="text/css" href="/js/dragBox/e8browser_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
		<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
		<script type="text/javascript">
			var dialog = null;
			try{dialog = parent.parent.parent.getDialog(parent.parent);}catch(e){}
			function showMultiDocDialog(selectids) {
				var config = null;
				config = rightsplugingForBrowser.createConfig();
				config.srchead = ["<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>"];
				config.container = $("#colShow");
				config.searchLabel = "";
				config.hiddenfield = "id";
				config.saveLazy = true;
				config.srcurl = "/hrm/attendance/workflowBill/multiData.jsp?src=src";
				config.desturl = "/hrm/attendance/workflowBill/multiData.jsp?src=dest";
				config.pagesize = 10;
				config.formId = "SearchForm";
				config.target = "frame1";
				config.parentWin = window.parent.parent;
				config.selectids = selectids;
				config.dialog = dialog;
				jQuery("#colShow").html("");
				rightsplugingForBrowser.createRightsPluing(config);
				jQuery("#btnok").bind("click",function(){rightsplugingForBrowser.system_btnok_onclick(config);});
				jQuery("#btnclear").bind("click",function(){rightsplugingForBrowser.system_btnclear_onclick(config);});
				jQuery("#btncancel").bind("click",function(){rightsplugingForBrowser.system_btncancel_onclick(config);});
				jQuery("#btnsearch").bind("click",function(){rightsplugingForBrowser.system_btnsearch_onclick(config);});
			}
		</script>
	</head>
	<body scroll="no">
		<div class="zDialog_div_content">
			<form id="SearchForm" name="SearchForm" style="margin-bottom:0" action="" onsubmit="return false;" method="post">
				<input type="hidden" name="sqlwhere" value="<%=sqlwhere%>">
				<input type="hidden" name="selectids" value="<%=selectids%>">
				<input type="hidden" name="namelabel" value="<%=namelabel%>">
				<input type="hidden" name="isBill" value="<%=isBill%>">
				<div id="dialog" style="height:250px;"><div id="colShow"></div></div>
			</form>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" class="zd_btn_submit" accessKey="O" id="btnok" value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
						<input type="button" class="zd_btn_submit" accessKey="2" id="btnclear" value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
						<input type="button" class="zd_btn_cancle" accessKey="T" id="btncancel" value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
					</wea:item>
				</wea:group>
			</wea:layout>
			<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
		</div>
		<script type="text/javascript">jQuery(document).ready(function(){showMultiDocDialog("<%=selectids%>");});</script>
	</body>
</html>
