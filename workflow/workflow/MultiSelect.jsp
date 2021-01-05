
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

int tabid = Util.getIntValue(request.getParameter("tabid"), 0);
String selectedids = Util.null2String(request.getParameter("selectedids"));
String workflowids = Util.null2String(request.getParameter("workflowids"));
if (selectedids.isEmpty()) {
	selectedids = workflowids;
}
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String typeid = Util.null2String(request.getParameter("typeid"));
String workflowname = Util.null2String(request.getParameter("workflowname"));
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
String hasRightSub = "";
//如果开启分权，且不是管理员
if(isUseWfManageDetach && !user.getLoginid().equalsIgnoreCase("sysadmin")){
    hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",0);    
}

%>
<HTML>
	<HEAD>
		<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
		<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
		<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>
	</head>
<body scroll="no">
	<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
		<input type="hidden" name="selectedids" id="selectedids" value='<%=selectedids%>'>
		<input type="hidden" name="tabid" id="tabid" value='<%=tabid%>'>
		<input type="hidden" name="typeid" id="typeid" value='<%=typeid%>'>		
		<input type="hidden" name="nodeid" id="nodeid" value='<%=nodeid%>'>
		<input type="hidden" name="workflowname" id="workflowname" value='<%=workflowname%>'>
		<input type="hidden" name="hasRightSub" id="hasRightSub" value="<%=hasRightSub %>">
		<div id="dialog" style="height: 225px;">
			<div id='colShow'></div>
		</div>
	</form>
	
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
</body>
<SCRIPT language="javascript">
	var dialog = null;
	try {
		dialog = parent.parent.parent.getDialog(parent.parent);
	} catch(ex1) {}

	function showMultiWorkflowDialog(selectids) {
		var config = null;
		config= rightsplugingForBrowser.createConfig();
		config.srchead=["<%=SystemEnv.getHtmlLabelName(81651, user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%>"];
		config.container =$("#colShow");
		config.searchLabel="";
		config.hiddenfield="id";
		config.saveLazy = true;//取消实时保存
		config.srcurl = "/workflow/workflow/MutiWorkflowBrowserAjax.jsp?src=src";
		config.desturl = "/workflow/workflow/MutiWorkflowBrowserAjax.jsp?src=dest";
		config.pagesize = 10;
		config.formId = "SearchForm";
		config.target = "frame1";
		config.parentWin = window.parent.parent;
		config.selectids = selectids;
		try{
			config.dialog = dialog;
		} catch(e) {
			
		}
		jQuery("#colShow").html("");
  		rightsplugingForBrowser.createRightsPluing(config);
		jQuery("#btnok").bind("click",function(){
			rightsplugingForBrowser.system_btnok_onclick(config);
		});
		jQuery("#btnclear").bind("click",function(){
			rightsplugingForBrowser.system_btnclear_onclick(config);
		});
		jQuery("#btncancel").bind("click",function(){
			rightsplugingForBrowser.system_btncancel_onclick(config);
		});
		jQuery("#btnsearch").bind("click",function(){
			rightsplugingForBrowser.system_btnsearch_onclick(config);
		});
	}

	jQuery(document).ready(function() {
		showMultiWorkflowDialog("<%=selectedids%>");
	});
</script>
</html>