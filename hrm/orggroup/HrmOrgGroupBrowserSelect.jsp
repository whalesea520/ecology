
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Added by wcd 2014-11-13 [E7 to E8] -->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	String selectids = Util.null2String(request.getParameter("selectids"));
	if(selectids.length()==0)selectids = Util.null2String(request.getParameter("resourceids"));
	String orgGroupName = Util.null2String(request.getParameter("orgGroupName"));
	String orgGroupDesc = Util.null2String(request.getParameter("orgGroupDesc"));
%>
<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
	<script type="text/javascript">
		function showMultiDialog(selectids){
			var config = null;
			config= rightsplugingForBrowser.createConfig();
			config.srchead=["<%=SystemEnv.getHtmlLabelName(82755,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(81710,user.getLanguage())%>"];
			config.container =$("#colShow");
			config.searchLabel="";
			config.hiddenfield="id";
			config.saveLazy = true;//取消实时保存
			config.srcurl = encodeURI(encodeURI("/hrm/orggroup/HrmOrgGroupBrowserResult.jsp?src=src"));
			config.desturl = "/hrm/orggroup/HrmOrgGroupBrowserResult.jsp?src=dest";
			config.pagesize = 10;
			config.formId = "SearchForm";
			config.target = "frame1";
			config.parentWin = window.parent.parent;
			config.targetDocument = parent.document;
			config.selectids = selectids;
			config.dialog = dialog;
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

		function btnOnSearch(){
			jQuery("#btnsearch").trigger("click");
		}
	</script>

</head>
<body scroll="no">
<div class="zDialog_div_content">
	<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
		<input type="hidden" name="selectids" id="selectids" value='<%=selectids%>'>
		<input type="hidden" name="orgGroupName" id="orgGroupName" value='<%=orgGroupName%>'>
		<input type="hidden" name="orgGroupDesc" id="orgGroupDesc" value='<%=orgGroupDesc%>'>
		<div id="dialog" style="height: 250px;">
			<div id='colShow'></div>
		</div>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
</div>

</body>
<SCRIPT language="javascript">
var parentWin = null;
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}
function reBindCornerEvent(){
	var corner = jQuery("span.cornerMenu",parent.document);
	if(corner.length==0){
		window.setTimeout(function(){reBindCornerEvent();},500);
	}else{
		window.setTimeout(function(){
			var e8_head = jQuery(".e8_box",parent.document).find("div.e8_boxhead");
			if(e8_head.length==0){
				e8_head = jQuery(".e8_box",parent.document).find("div#rightBox");
			}
			var contentWindow = jQuery("#frame1",parent.document).get(0).contentWindow;
			corner.unbind("click",parent.initBindEvent).bind("click",function(){
				parent.bindCornerMenuEvent(e8_head,contentWindow,null);
			});
		},1000);
	}
	jQuery("#btnsearch").hide();
}
jQuery(document).ready(function(){
	showMultiDialog("<%=selectids%>");
});
</script>
</html>