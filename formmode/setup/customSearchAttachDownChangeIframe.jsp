<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="com.weaver.formmodel.util.*"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@ include file="/formmode/pub.jsp"%>

<%
	int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
	int customid = Util.getIntValue(request.getParameter("id"), 0);
	String value = Util.null2String(request.getParameter("value"),"");
	//初始化数据
	RecordSet rs = new RecordSet();
	//查询customfieldshowchange中数据
	int singleValue=0;
	int moreValue=0;
	if(!StringHelper.isEmpty(value)){
		rs.execute("select singlevalue,morevalue from customfieldshowchange where customid="+customid+" and fieldid="+fieldid +"order by id");
		while(rs.next()){
			singleValue = rs.getInt("singlevalue");
			moreValue = rs.getInt("morevalue");
		}
	}

%>

<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/miframe_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/selectitemeditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/attachpiceditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/specialeditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/columnLock_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/ux/css/columnLock_wev8.css"/>
	
	<link type="text/css" rel="stylesheet" href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery.ui.all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
	<!-- 
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> -->
	
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET> <!-- 为选择项编辑表格移植的css -->
	
	<style type="text/css">
		* {font:12px Microsoft YaHei}
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0px;
		}
		.e8_formfield_tabs{
			height: 100%;
			margin: 0px;
			padding: 0px;
			border: none;
			position: relative;
		}
		.e8_formfield_tabs .ui-tabs-nav {
			background:none;
			border:none;
			padding-left: 0px;
		}
		.e8_formfield_tabs .ui-tabs-nav li{
			margin-right: 0px;
			border:0;
		}
		.e8_formfield_tabs .ui-tabs-nav li.ui-state-default{
			background: none;
		}
		.e8_formfield_tabs .ui-tabs-nav li a{
			font-size: 12px;
			padding-left: 0px;
			padding-right: 10px;
			color: #a3a3a3;
			
		}
		.e8_formfield_tabs .ui-tabs-nav li a:hover{

		}
		.e8_formfield_tabs .ui-tabs-nav li a:active{
			background: none;
		}
		.e8_formfield_tabs .ui-tabs-nav li.ui-state-active a{
			color: #0072C6;
			font-weight: bold;
		}
		.e8_formfield_tabs .ui-tabs-nav li a span.ui-icon-close{
			position: absolute;
			top:0px;
			right: 0px;
			display: none;
			cursor: pointer;
		}
		.e8_formfield_tabs .ui-tabs-nav li a:hover span.ui-icon-close{
			display: block;
		}
		
		.e8_formfield_tabs .ui-tabs-panel{
			padding: 0px;
			overflow: hidden;
		}
		/*Ext 表格对应的样式(框架)*/
		.e8_formfield_tabs .ui-tabs-panel .x-border-layout-ct{
			background-color: #fff;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-body-noheader{
			border: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-tl{
			border-bottom-width: 0px;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-ml{
			padding-left: 0px;
			background-image: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-mc{
			padding-top: 0px;
			background-color: #fff;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-mr{
			padding-right: 0px;
			background-image: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-nofooter .x-panel-bc{
			height: 0px;
			overflow:hidden;
		}
		
		.x-combo-list-small .x-combo-list-item, .x-combo-list-item{
			font-size: 11px;
			font-family: Microsoft YaHei;
		}
		.x-small-editor .x-form-field{
			font-size: 11px;
			font-family: Microsoft YaHei;
		}
		
		/*Ext 表格对应的样式(表格)*/
		.e8_formfield_tabs .ui-tabs-panel .x-grid-panel .x-panel-mc .x-panel-body{
			border: none; 
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-header{
			background: none;
			padding-left: 3px;
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-row td{
			background-color: #E5E5E5;
			border-left: none;
			border-right-color: #d0d0d0;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-row td .x-grid3-hd-inner{
			color: #333;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-row-table td{
			
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-header-inner{
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel td.x-grid3-hd-over .x-grid3-hd-inner{
			background-image: none;
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-over .x-grid3-hd-btn{
			display: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-scroller{
		
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-locked .x-grid3-scroller{
			border-right-color: #d0d0d0;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-body .x-grid3-td-checker{
			padding-left: 3px;
			background: none;
		}
		.e8_formfield_tabs .x-grid3-cell-inner{
			padding: 1px 3px 1px 5px;
		}
		.e8_formfield_tabs .x-grid3-row{
			border-left-width: 0px;
		}
		
		.e8_formfield_addTab{
			position: absolute;
			width: 10px;
			height: 10px;
			top: 11px;
			left: -10px;
			cursor: pointer;
			background: url("/formmode/images/add_wev8.png") no-repeat;
			z-index: 1000;
			margin-left: 2px;
		}
		
		table.liststyle td{
			color: #929393;
			border-bottom: 1px solid #DADADA;
			padding: 5px 0px;
		}
		
		.x-form-editor-trigger{
		/*
			background:transparent url("/formmode/js/ext/resources/images/default/editor/tb-sprite_wev8.gif") no-repeat !important;
			background-position:-192px 0px !important;*/
			background:transparent url("/formmode/images/list_edit_wev8.png") no-repeat !important;
			background-position:1px 1px !important;
			border-bottom: none !important;
		}
		.x-form-textarea{
			margin-bottom: 0px !important;
		}
		button.calendar {
			BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url("/wui/theme/ecology8/skins/default/general/calendar_wev8.png"); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 16px; CURSOR: pointer; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 16px; BACKGROUND-COLOR: transparent
		}
	</style>
	
	
</head>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;//确定
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;//清除
		RCMenuHeight += RCMenuHeightStep ;
	%>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none;">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(83446, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave()">
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
    </table>
<table class='liststyle' id='choiceTable' cols='3' border=0 style="width: 100%;" cellspacing="collapse">
<COL width="5%">
<COL width="10%">
<COL width="30%">
<tr>
<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td><!-- 选中 -->
<td><%=SystemEnv.getHtmlLabelName(82042,user.getLanguage())%></td><!-- 显示格式 -->
<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td><!-- 说明 -->
</tr>
<tr>
<td><div><input type="checkbox" name="singledown"  value="0" <%=singleValue==1?"checked='checked'":"" %>></div>
<td><%=SystemEnv.getHtmlLabelName(31156,user.getLanguage())%></td><!-- 下载 -->
<td><font color=red><%=SystemEnv.getHtmlLabelName(82043,user.getLanguage())%></font></td><!-- 数据中每个附件单独下载按钮 -->
</tr>
<tr>
<td><div><input type="checkbox" name="moredown"  value="0" <%=moreValue==1?"checked='checked'":"" %>></div>
<td><%=SystemEnv.getHtmlLabelName(32407,user.getLanguage())%></td><!-- 批量下载 -->
<td><font color=red><%=SystemEnv.getHtmlLabelName(82044,user.getLanguage())%></font></td><!-- 数据中附件字段的附件打包批量下载按钮 -->
</tr>
</table>
</body>
<script>
function onSave(){
enableAllmenu();
var sel_detaildata = [];
var singledown = $("#choiceTable").find("input[name=singledown]");
var moredown = $("#choiceTable").find("input[name=moredown]");
var sel_d_data = {};
sel_d_data["singlevalue"] = $(singledown.get(0)).attr('checked')=='checked'?"1":"0";
sel_d_data["morevalue"] = $(moredown.get(0)).attr('checked')=='checked'?"1":"0";
sel_detaildata.push(sel_d_data);
var jsonstr = Ext.util.JSON.encode(sel_detaildata);	
//alert(jsonstr);		
var paramData = {"data": encodeURI(jsonstr), "customid": "<%=customid%>", "fieldid": "<%=fieldid%>"}
var url = "/formmode/setup/attachDownChangeAction.jsp?action=saveForm";
	    	FormmodeUtil.doAjaxDataSave(url, paramData, function(res){
	    		if(res == "1"){
	    			top.closeTopDialog(res);
	    		}else if(res == "0"){
	    			alert("error");
	    		}
	    	});
}
function onClear(){
			enableAllmenu();
			var paramData = {"customid": "<%=customid%>", "fieldid": "<%=fieldid%>"};
	    	var url = "/formmode/setup/attachDownChangeAction.jsp?action=clearForm";
	    	FormmodeUtil.doAjaxDataSave(url, paramData, function(res){
	    		if(res == "1"){
	    			top.closeTopDialog("0");
	    		}else if(res == "0"){
	    			alert("error");
	    		}
	    	});
		}
</script>
</html>