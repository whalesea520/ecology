<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="_pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="_pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="_hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page" />
<jsp:useBean id="_hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="_ebc" class="weaver.page.element.ElementBaseCominfo" scope="page" />
<jsp:useBean id="_esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />

<%
	User _user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	String _hpid = Util.null2String(request.getParameter("hpid"));
	int _subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), -1);
	String _eid = Util.null2String(request.getParameter("eid"));
	String _ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String _styleid = Util.null2String(request.getParameter("styleid"));
	
	int _language = 7;
	if (_user != null) {
		_language = _user.getLanguage();
	}
	//元素独立显示时，是否需要显示头部标题
	String _needHead = Util.null2String(request.getParameter("needHead"), "false");
%>

<link rel="stylesheet" type="text/css" href="/css/init_wev8.css" />
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/homepage/tabs/css/e8tabs_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" />
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/skins/default/wui_wev8.css" />
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/templates/default/css/default2_wev8.css" />
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/templates/default/js/default_wev8.js"></script>
<script type="text/javascript" src="/js/init_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/jquery.table_wev8.js"></script>
<script type="text/javascript" src="/js/wbusb_wev8.js"></script>
<script type="text/javascript" src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script type="text/javascript" src="/js/jscolor/jscolor_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=_language%>_wev8.js"></script>

<!-- 引入JavaScript -->  
<%=_pu.getPageJsImportStr(_hpid) %>
<%=_pu.getPageCssImportStr(_hpid) %>

<style type="text/css">
body {
	background: <%= _pc.getBgColor(_hpid) %>;
}

#Container {
	width: 99%;
	margin-left: 10px;
}

.item {
	margin-top: 10px;
}

.group {
	margin-right: 10px;
}

#__content__ table {
	margin-bottom: 10px;
	border-collapse: collapse;
	display: table;
}

#__content__ .selectTdClass {
	background-color: #edf5fa !important
}

#__content__ table.noBorderTable td,#__content__ table.noBorderTable th,#__content__ table.noBorderTable caption
	{
	border: 1px dashed #ddd !important
}

#__content__ td,#__content__ th {
	padding: 5px 10px;
	border: 0px;
}

#__content__ caption {
	border: 1px dashed #DDD;
	border-bottom: 0;
	padding: 3px;
	text-align: center;
}

#__content__ th {
	border-top: 1px solid #BBB;
	background-color: #F7F7F7;
}

#__content__ table tr.firstRow th {
	border-top-width: 2px;
}

#__content__ .ue-table-interlace-color-single {
	background-color: #fcfcfc;
}

#__content__ .ue-table-interlace-color-double {
	background-color: #f7faff;
}

#__content__ td p {
	margin: 0;
	padding: 0;
}

#__content__ .loadingclass {
	display: inline-block;
	cursor: default;
	background: url(/ueditor/themes/default/images/loading_wev8.gif)
		no-repeat center center transparent;
	border: 1px solid #cccccc;
	margin-left: 1px;
	height: 22px;
	width: 22px;
}

#__content__ .loaderrorclass {
	display: inline-block;
	cursor: default;
	background: url(/ueditor/themes/default/images/loaderror_wev8.png)
		no-repeat center center transparent;
	border: 1px solid #cccccc;
	margin-right: 1px;
	height: 22px;
	width: 22px;
}

#__content__ pre {
	margin: .5em 0;
	padding: .4em .6em;
	border-radius: 8px;
	background: #f8f8f8;
}

#__content__ .anchorclass {
	background: url(/ueditor/themes/default/images/anchor_wev8.gif)
		no-repeat scroll left center transparent;
	cursor: auto;
	display: inline-block;
	height: 16px;
	width: 15px;
}

#__content__ .pagebreak {
	display: block;
	clear: both !important;
	cursor: default !important;
	width: 100% !important;
	margin: 0;
}

#__content__ .edui-editor-imagescale {
	display: none;
	position: absolute;
	border: 1px solid #38B2CE;
	cursor: hand;
	-webkit-box-sizing: content-box;
	-moz-box-sizing: content-box;
	box-sizing: content-box;
}

#__content__ .edui-editor-imagescale span {
	position: absolute;
	width: 6px;
	height: 6px;
	overflow: hidden;
	font-size: 0px;
	display: block;
	background-color: #3C9DD0;
}

#__content__ .edui-editor-imagescale .edui-editor-imagescale-hand0 {
	cursor: nw-resize;
	top: 0;
	margin-top: -4px;
	left: 0;
	margin-left: -4px;
}

#__content__ .edui-editor-imagescale .edui-editor-imagescale-hand1 {
	cursor: n-resize;
	top: 0;
	margin-top: -4px;
	left: 50%;
	margin-left: -4px;
}

#__content__ .edui-editor-imagescale .edui-editor-imagescale-hand2 {
	cursor: ne-resize;
	top: 0;
	margin-top: -4px;
	left: 100%;
	margin-left: -3px;
}

#__content__ .edui-editor-imagescale .edui-editor-imagescale-hand3 {
	cursor: w-resize;
	top: 50%;
	margin-top: -4px;
	left: 0;
	margin-left: -4px;
}

'
#__content__ .edui-editor-imagescale .edui-editor-imagescale-hand4 {
	cursor: e-resize;
	top: 50%;
	margin-top: -4px;
	left: 100%;
	margin-left: -3px;
}

#__content__ .edui-editor-imagescale .edui-editor-imagescale-hand5 {
	cursor: sw-resize;
	top: 100%;
	margin-top: -3px;
	left: 0;
	margin-left: -4px;
}

#__content__ .edui-editor-imagescale .edui-editor-imagescale-hand6 {
	cursor: s-resize;
	top: 100%;
	margin-top: -3px;
	left: 50%;
	margin-left: -4px;
}

#__content__ .edui-editor-imagescale .edui-editor-imagescale-hand7 {
	cursor: se-resize;
	top: 100%;
	margin-top: -3px;
	left: 100%;
	margin-left: -3px;
}

#__content__ .view {
	padding: 0;
	word-wrap: break-word;
	cursor: text;
	height: 90%;
}

body {
	width: auto;
	margin: 8px;
	font-family: sans-serif;
	font-size: 12px;
	overflow: hidden;
}

p {
	margin: 5px 0;
}

.addwf .tab_menu {
	height: 30px !important;
	line-height: 30px !important;
	margin-top：10px;
}

.addwf .tab_menu li {
	height: 30px !important;
	line-height: 30px !important;
}

.addwf .addwfDrop {
	position: absolute;
	background-color: #f5f5f5;
	border: 1px solid #e0e0e0;
	z-index: 100;
	min-width: 50px;
	list-style: none;
	padding: 5px;
	display: none;
}

.addwf .addwfDrop li {
	margin-left: 10px;
	margin-right: 10px;
	border-bottom: 1px solid rgb(226, 227, 228);
}

.addwf .addwfDrop li {
	margin-left: 10px;
	margin-right: 10px;
	border-bottom: 1px solid rgb(226, 227, 228);
	cursor: pointer;
	white-space: nowrap;
}

.addwf .addwfDrop .itemdropOver {
	padding-left: 15px;
	padding-right: 15px;
	color: red !important;
	border-bottom: 1px solid rgb(153, 205, 218) !important;
}

.addwf .addwfDrop .itemdrop {
	padding-left: 15px;
	padding-right: 15px;
	color: #5b5b5b;
}

.addwf .magic-line {
	display: none;
}

.addwf {
	height: 185px !important;
}

.oneCol {
	width: 100%
}

.twoCol {
	width: 50%;
	float: left;
}

.fontItem {
	height: 30px;
	line-height: 30px;
	border-bottom: 1px dashed #f0f0f0;
}

.signPreview {
	display: none;
	position: absolute;
	width: 510px;
	z-index: 100;
}

.signPreview .arrowsblock {
	height: 22px !important;
	width: 100% !important;
	position: absolute;
	top: 10px;
	text-align: left;
	padding-left: 100px;
	z-index: 1;
}

.signPreview .arrowsblockup {
	height: 22px !important;
	width: 100% !important;
	position: absolute;
	bottom: 6px;
	text-align: left;
	padding-left: 100px;
	z-index: 1;
}

.signContainer {
	margin-top: 22px;
	border: 1px solid #cccccc;
	padding-top: 10px;
	background: #fff;
	height: 350xp;
}

.signMoreup {
	border-bottom-width: 0px !important;
	border-left-width: 0px !important;
	border-right-width: 0px !important;
}

.signContainerup {
	margin-top: 0px !important;
	margin-bottom: 22px !important;
}

.signPreview .signMore {
	background: #f4f7f7;
	height: 40px;
	line-height: 40px;
	text-align: center;
	cursor: pointer;
	border: 1px solid #cccccc;
	border-top: 0px;
}

.overlabel {
	position: absolute;
	z-index: 1;
	font-size: 12px;
	font-weight: normal;
	color: #dadedb !important;
	line-height: 22px !important;
}

.searchInputSpan {
	top: 0px !important;
}

.settingtabcurrent {
	color: #1264B5 !important;
}

.weavertabs-content DIV {
	display: inline;
}

.cntactbox {
	height: auto !important;
}

.cntactbox .tab_menu {
	height: 30px !important;
	line-height: 30px !important;
	margin-top：10px;
}

.cntactbox .tab_menu li {
	height: 30px !important;
	line-height: 30px !important;
}

.cntactbox .magic-line {
	display: none;
}

.magic-line {
	display: none;
}

.settingtabcurrent {
	color: #1264B5 !important;
}

.setting_button_row {
	padding-top: 5px !important;
	padding-bottom: 5px !important;
	background-color: #F6F6F6;
	padding-left: 0px !important;
	padding-right: 0px !important;
	width: 100%;
	border: none;
	border-top: 1px solid #dadedb;
}

.LayoutTable {
	border: none;
}

a {
	text-decoration: none !important;
}

.header {
	background-position: left center;
}

.ehoverBg {
	background: #E2F1FC;
}

.ehover {
	height: 25px;
}

#reldiv #Container {
	margin-left: 5px;
}

#container_Table {
	border-collapse: collapse;
	height: 100%;
}

#container_Table td {
	vertical-align: top;
}

.layouttable {
	width: 100%;
	table-layout: fixed;
	border-collapse: collapse;
}

.title {
	padding-bottom: 5px;
}

#spanELib {
	border: none !important;
	width: 120px !important;
}

#spanELib>div {
	border: none !important;
}

.dragitemholder {
	background: #f9f9f9;
	position: absolute;
	z-index: 1;
	cursor: move;
	height: 35px;
	border: 1px solid rgb(230, 230, 230);
	padding: 0 2px;
	width: 150px;
	line-height: 35px;
}

.toolbar ul li a {
	overflow: inherit !important;
}

.wfremindimg {
	vertical-align: middle;
	margin-top: -3px;
	padding-left: 6px;
	cursor: pointer;
}

.picturenexthp {
	cursor: pointer;
}

.picturebackhp {
	cursor: pointer;
}

.elementdatatable {
	margin-top: 3px;
	border-collapse: collapse;
}

.elementdatatable tr {
	height: 20px;
}

.elementdatatable td img {
	vertical-align: middle;
}

.elementdatatable td {
	vertical-align: middle;
	padding-top: 2px;
	padding-bottom: 2px;
	line-height: 20px;
	font-size: 12px;
}

.colorspan {
	display: inline-block;
	*display: inline;
	width: 15px !important;
	height: 15px !important;
	overflow: hidden;
	cursor: pointer;
	margin-top: 5px;
}

.colorul {
	width: 110px;
	height: 55px;
	list-style-type: none !important;
	margin: 0px;
	padding: 5px;
	overflow: hidden;
}

.colorul li {
	width: 25px;
	height: 25px;
	white-space: nowrap;
	margin-top: 2px;
	margin-left: 2px;
	padding: 0px;
	float: left;
	cursor: pointer;
}

.picturebackhp {
	width: 18px;
	height: 32px;
	float: left;
	background: transparent
		url(/page/element/Picture/resource/image/scroll_left_wev8.gif)
		no-repeat 0 0;
}

.picturenexthp {
	width: 18px;
	height: 32px;
	float: left;
	background: transparent
		url(/page/element/Picture/resource/image/scroll_right_wev8.gif)
		no-repeat 0 0;
}

#PortalCenter {
	width: 100%;
	height: 240px;
	table-layout: fixed;
}

.module {
	width: 100%;
	height: 100%;
	position: relative;
	cursor: pointer;
}

.workflow {
	background-color: #33a3ff;
	background-image: url("/images/homepage/portalcenter/workflow_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.project {
	background-color: #cb61fe;
	background-image: url("/images/homepage/portalcenter/project_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.capital {
	background-color: #ffd200;
	background-image: url("/images/homepage/portalcenter/capital_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.cowork {
	background-color: #fd9000;
	background-image: url("/images/homepage/portalcenter/cowork_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.crm {
	background-color: #6871e3;
	background-image: url("/images/homepage/portalcenter/crm_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.blog {
	background-color: #56de37;
	background-image: url("/images/homepage/portalcenter/blog_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.doc {
	background-color: #fd2677;
	background-image: url("/images/homepage/portalcenter/doc_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.meetting {
	background-color: #fd2677;
	background-image: url("/images/homepage/portalcenter/meetting_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.workplan {
	background-color: #fd2677;
	background-image: url("/images/homepage/portalcenter/workplan_wev8.png");
	background-position: center center;
	background-repeat: no-repeat;
}

.num {
	position: absolute;
	left: 0px;
	bottom: 0px;
	color: #ffffff;
	padding-left: 15px;
	padding-bottom: 10px;
	font-size: 24px;
	font-family: 微软雅黑;
}

.mtitle {
	height: 80px;
	margin: auto;
	bottom: 0px;
	color: #ffffff;
	width: 80px;
	font-size: 20px;
	vertical-align: middle;
	text-align: center;
	line-height: 80px;
	font-family: 微软雅黑;
	display: none;
}

.jCarouselLite li{
		margin-left:2px;
		margin-right:2px;
	}
	.clear {clear:both;display:block;}
	.jCarouselLite{
		margin:auto;
	}
.ellipsis {
    display: inline-block;
    word-break: keep-all;
    text-overflow: ellipsis;
    white-space: nowrap;
    overflow: hidden;
    max-width: 95%;
    vertical-align: bottom;
}
.elementdatatable{
	table-layout: fixed;
}
<%=_pu.getHpElementCss(_hpid,_eid)%>
</style>

<% if("true".equals(_needHead)){ %>
<div class="header" style="width:auto;_width:100%;margin-bottom: 3px;position:relative;display:block!important;" id="header_<%=_eid%>">
	<span class="title" style="position:absolute;" id="title_<%=_eid%>"><%=_hpec.getTitle(_eid) %></span>
	<span class="toolbar" style="position:absolute;" id="toolbar_<%=_eid%>">
		<ul>
			<li><a style="display:block;float:left;" href="javascript:onRefresh('<%=_eid%>','<%=_ebaseid%>')" title="<%=SystemEnv.getHtmlLabelName(354,_language)%>"><img src="<%=_esc.getIconRefresh(_hpec.getStyleid(_eid)) %>" border="0" /></a></li>
			<li><a style="display:block;float:left;" href="javascript:openFullWindowForXtable('<%=_ebc.getMoreUrl(_ebaseid)+"?ebaseid="+_ebaseid+"&eid="+_eid %>')" title="<%=SystemEnv.getHtmlLabelName(17499,_language)%>"><img src="<%=_esc.getIconMore(_hpec.getStyleid(_eid)) %>" border="0" /></a></li>
		</ul>
	</span>
</div>
<% }%>

<script type="text/javascript">
function onNewRequest(obj,wfid,agent,beagenter,selfwf){
	if(!selfwf){
		$(obj).parent().find(".addwfDrop").find(".itemdrop:first").trigger("click");
		return;
	}
	jQuery.post('/workflow/request/AddWorkflowUseCount.jsp',{wfid:wfid});
	    var redirectUrl = "/workflow/request/AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&beagenter="+beagenter+"&f_weaver_belongto_userid=";
		var hiddenNames = "prjid,docid,crmid,hrmid,topage".split(",");
		for (var i = 0; i < hiddenNames.length; i++) {
			var hiddenName = hiddenNames[i];
			var hiddenVal = jQuery("input:hidden[name='"+hiddenName+"']").val();
			if (!!hiddenVal) {
				redirectUrl += "&" + hiddenName + "=" + hiddenVal;
			}
		}
	    var width = screen.availWidth-10 ;
	    var height = screen.availHeight-50 ;
	    var szFeatures = "top=0," ;
 	    szFeatures +="left=0," ;
	    szFeatures +="width="+width+"," ;
	    szFeatures +="height="+height+"," ;
	    szFeatures +="directories=no," ;
	    szFeatures +="status=yes,toolbar=no,location=no," ;
	    szFeatures +="menubar=no," ;
	    szFeatures +="scrollbars=yes," ;
	    szFeatures +="resizable=yes" ; //channelmode
	    window.open(redirectUrl,"",szFeatures) ;
}

function onNewRequest2(wfid,agent,belongtouserid){
	jQuery.post('/workflow/request/AddWorkflowUseCount.jsp',{wfid:wfid});
	    var redirectUrl = "/workflow/request/AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&f_weaver_belongto_userid="+belongtouserid;
		var hiddenNames = "prjid,docid,crmid,hrmid,topage".split(",");
		for (var i = 0; i < hiddenNames.length; i++) {
			var hiddenName = hiddenNames[i];
			var hiddenVal = jQuery("input:hidden[name='"+hiddenName+"']").val();
			if (!!hiddenVal) {
				redirectUrl += "&" + hiddenName + "=" + hiddenVal;
			}
		}
	    var width = screen.availWidth-10 ;
	    var height = screen.availHeight-50 ;
	    var szFeatures = "top=0," ;
 	    szFeatures +="left=0," ;
	    szFeatures +="width="+width+"," ;
	    szFeatures +="height="+height+"," ;
	    szFeatures +="directories=no," ;
	    szFeatures +="status=yes,toolbar=no,location=no," ;
	    szFeatures +="menubar=no," ;
	    szFeatures +="scrollbars=yes," ;
	    szFeatures +="resizable=yes" ; //channelmode
	    window.open(redirectUrl,"",szFeatures) ;
}

function saveScratchpad(eid,userid){
	var scratchpadareatext = document.getElementById("scratchpadarea_"+eid);
	scratchpadareatext.disabled = true;
	
	var padcontent = jQuery(scratchpadareatext).val();
	
	var len = getBytesLength(padcontent);
	//alert("len : "+len);
	if(len>4000)
	{
		var reply=confirm("<%=SystemEnv.getHtmlLabelName(22934, _language)%>?");
		if(reply)
		{
			padcontent = subStringByBytes(padcontent,4000);
			$.post("/page/element/scratchpad/ScratchpadOperation.jsp", { eid:eid, userid:userid, operation: "save",padcontent:padcontent },function(data){
			    	data = data.replace(/(^\s*)|(\s*$)/g, "");
			    	var scratchpadareatext = document.getElementById("scratchpadarea_"+eid);
			    	jQuery(scratchpadareatext).val(data);
	    			scratchpadareatext.disabled = false;
			});
		}
		else
		{
			scratchpadareatext.focus();
			scratchpadareatext.disabled = false;
		}
	}
	else
	{
		$.post("/page/element/scratchpad/ScratchpadOperation.jsp", { eid:eid,userid:userid, operation: "save",padcontent:padcontent },function(data){
			scratchpadareatext.disabled = false;
		});
	}
}

function getBytesLength(str) {
	// 在GBK编码里，除了ASCII字符，其它都占两个字符宽
	return str.replace(/[^\x00-\xff]/g, 'xx').length;
}

/**
 * 根据字符长来截取字符串
 */
function subStringByBytes(val, maxBytesLen) {
	var len = maxBytesLen;
	var result = val.slice(0, len);
	while(getBytesLength(result) > maxBytesLen) 
	{
		result = result.slice(0, --len);
	}
	return result;
}

function loadContentForChart(eid,url,queryString,tabId){
	var ebaseid = $("#item_"+eid).attr("ebaseid");
	url = url + "?tabId="+tabId+"&"+queryString;
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var objTd=$("#tabContainer_"+eid).find("td[tabId='"+tabId+"']");
	
	$(objTd).siblings().removeClass("tab2selected").removeClass("tab2unselected").addClass("tab2unselected");
	$(objTd).removeClass("tab2unselected").addClass("tab2selected");
	
	$("#tabContant_"+eid).html("<img src=/images/loading2_wev8.gif><%=SystemEnv.getHtmlLabelName(19611,_language)%>...")
	try{
		if(ebaseid==1||ebaseid==29){
			$.get(url, { name: "John", time: "2pm" },function(data){
				$("#tabContant_"+eid).html($.trim(data));
				//fixedPosition(eid);
				//$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
		  	} ); 
		}else{
			$("#tabContant_"+eid).load(url,{},function(){
				//fixedPosition(eid);
				//$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
			});
		}
	} catch(e){}
}

function openFullWindowHaveBar(url){    
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var redirectUrl = url ;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	//if (height == 768 ) height -= 75 ;
	//if (height == 600 ) height -= 60 ;
	 var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures);
}

function openFullWindowForXtable(url){
	//添加协同参数传递
	var reqid='<%=Util.null2String(request.getParameter("requestid"))%>';
	var hpid='<%=Util.null2String(request.getParameter("hpid"))%>';
	var pagetype='<%=Util.null2String(request.getParameter("pagetype"))%>';
	var fieldids='<%=Util.null2String(request.getParameter("fieldids"))%>';
	var fieldvalues='<%=Util.null2String(request.getParameter("fieldvalues"))%>';
	if(url.indexOf("/")==0){
		if (url.indexOf("?") != -1) {
			url += "&";
		} else {
			url += "?";
		}
		url += "e7" + new Date().getTime() + "=";	
		if(reqid!=='')
			url+="&requestid="+reqid;
		if(hpid!=='')
            url+="&hpid="+hpid;
		if(pagetype!=='')
            url+="&pagetype="+pagetype;
		if(fieldids!=='')
            url+="&fieldids="+fieldids;
		if(fieldvalues!=='')
            url+="&fieldvalues="+fieldvalues;
	}
	var redirectUrl = url ;
	var width = screen.availWidth ;
	var height = screen.availHeight ;
	var szFeatures = "top=0," ; 
	szFeatures +="left=0," ;
	if(url.indexOf("ebaseid=15")!=-1){
		//td61285
		//szFeatures +="width=800," ;
		szFeatures +="width="+(width-10)+"," ;
	}else{
		szFeatures +="width="+(width-10)+"," ;
	}
	szFeatures +="height="+(jQuery.browser.msie?height:(height-60))+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ;
	window.open(redirectUrl,"",szFeatures);
}

function openMaginze(obj,url,linkmode){
  	url=url+obj.value;
  	if(linkmode=="1") window.location=url; 
  	if(linkmode=="2") openFullWindowForXtable(url);
}

function showUnreadNumber(accountId){
	var oSpan = document.getElementById("span"+accountId);
	var oIframe = document.getElementById("iframe"+accountId);
	var unreadMailNumber;
	if(oIframe.contentWindow.document.body.innerText){
		unreadMailNumber=jQuery.trim(oIframe.contentWindow.document.body.innerText);
	}else{
		unreadMailNumber=jQuery.trim(oIframe.contentWindow.document.body.lastChild.textContent);
	}
	oSpan.innerHTML = unreadMailNumber==-1 ? "<img src='/images/BacoError_wev8.gif' align='absmiddle' alt='<%=SystemEnv.getHtmlLabelName(20266,_language)%>'>" : "(<b>"+unreadMailNumber+"</b>)";
}

function checkall(eid,userparamname,userparampass,needvalidate,usbType){
	var errMessage="";
	var frmLogin = document.getElementById("frmLogin_"+eid);	
	var loginid = document.getElementById(userparamname);
	var userpassword = document.getElementById(userparampass);
	
	if (loginid&&loginid.value=="") 
	{
		errMessage="<%=SystemEnv.getHtmlLabelName(16647,7)%>";
		alert(errMessage);
		loginid.focus();
		return false ;
	}
	if (userpassword&&userpassword.value=="") 
	{
		errMessage="<%=SystemEnv.getHtmlLabelName(16648,7)%>";
		alert(errMessage);
		userpassword.focus();
		return false ;
	}
	if(needvalidate=="1"){
		var validatecode = frmLogin.validatecode;
		if (validatecode&&(validatecode.value==""||validatecode.value=='<%=SystemEnv.getHtmlLabelName(22909,7)%>')) 
		{
			errMessage="<%=SystemEnv.getHtmlLabelName(22909,7)%>";
			alert(errMessage);
			validatecode.focus();
			return false ;
		}
	}
	frmLogin.submit(); 
	loginid.value="";
   	userpassword.value="";
  	$("#message_"+eid).html("");
}

function loadRssElementContent(eid,rssUrl,imgSymbol,hasTitle,hasDate,hasTime,titleWidth,dateWidth,timeWidth,rssTitleLength,linkmode,size,perpage,languageid){
 	var returnStr="";
 		
	var objDiv = document.getElementById("rssContent_"+eid);
	try{
		var rssRequest = XmlHttp.create();
		rssRequest.open("GET",rssUrl, true);	
		rssRequest.onreadystatechange = function () {
			switch (rssRequest.readyState) {
			   case 3 : 					
					break;
			   case 4 : 
				   if (rssRequest.status==200)  {
                     returnStr+="<TABLE id=\"_contenttable_"+eid+"\" style=\"width:100%\" class=\"Econtent\">"+
						  " <TR>"+
						  " <TD width=\"1px\"></TD>"+
						  " <TD width=\"*\" valign=\"center\">"+
						  "	    <TABLE  width=\"100%\">";
				   
						var items=rssRequest.responseXML;
						var titles=new Array(),pubDates=new Array(); dates=new Array(), times=new Array(), linkUrls=new Array(), descriptions=new Array()	
							
						var items_count=items.getElementsByTagName('item').length;

						if(items_count>perpage) items_count=perpage;
				
						for(var i=0; i<items_count; i++) {
							titles[i]="";
							pubDates[i]="";
							linkUrls[i]="";
							descriptions[i]="";
							dates[i]="";
							times[i]="";

							if(items.getElementsByTagName('item')[i].getElementsByTagName('title').length==1)
								titles[i]=items.getElementsByTagName('item')[i].getElementsByTagName('title')[0].firstChild.nodeValue;

							if(items.getElementsByTagName('item')[i].getElementsByTagName('pubDate').length==1)
								pubDates[i]=items.getElementsByTagName('item')[i].getElementsByTagName('pubDate')[0].firstChild.nodeValue;

							if(items.getElementsByTagName('item')[i].getElementsByTagName('link').length==1)
								linkUrls[i]=items.getElementsByTagName('item')[i].getElementsByTagName('link')[0].firstChild.nodeValue;

							returnStr+="<TR height=18px>"+
									   "  <TD width=\"8\">"+imgSymbol+"</TD>";

							if(hasTitle=="true"){
								 returnStr+="<TD width="+titleWidth+">";
								 var tempTitle = "";
								 if(titles[i].length>rssTitleLength){
								 	tempTitle = titles[i].substring(0,rssTitleLength)+"...";
								 }else{
								 	tempTitle = titles[i];
								 }
								
								 if(linkmode=="1"){
									returnStr+="<a href=\""+linkUrls[i]+"\" target=\"_self\" title=\""+titles[i]+"\"><FONT class=\" font\" >"+tempTitle+"</FONT></a>";
								 } else {
									returnStr+="<a href=\"javascript:openFullWindowForXtable('"+linkUrls[i]+"')\" title=\""+titles[i]+"\"><FONT class=\" font\"  >"+tempTitle+"</FONT></a>";
								 } 
								 returnStr+="</TD>";
							} 
							
							if(pubDates[i]!=""){
								var d = new Date(pubDates[i]);
							
								if(d!='NaN'){
									dates[i]=d.getFullYear()+"-"+(d.getMonth() + 1) + "-"+d.getDate() ;
	
									if(d.getHours()<=9)	times[i]+="0"+d.getHours() + ":";
									else times[i]+= d.getHours() + ":";
	
									if(d.getMinutes()<=9)	times[i]+="0"+d.getMinutes() + ":";
									else times[i]+= d.getMinutes() + ":";
	
									if(d.getSeconds()<=9)	times[i]+="0"+d.getSeconds();
									else times[i]+= d.getSeconds() ;
								}else{
									dates[i]="";
									times[i]="";
								}
							} else {
								dates[i]="";
								times[i]="";
							}
							if(hasDate=="true"){
								returnStr+="<TD width="+dateWidth+">"+"<font class=font>"+dates[i]+"</font>"+"</TD>";
							}
							if(hasTime=="true"){
								returnStr+="<TD width="+timeWidth+">"+"<font class=font>"+times[i]+"</font>"+"</TD>";
							}
							returnStr+="</TR>";

							if(i<items_count-1){
								returnStr+="<TR class=\"sparator\" style='height:1px'><TD style='padding:0px' colspan="+(size+1)+"></TD></TR>";	
							}
					
						}
						
						returnStr+="		</TABLE>"+
								  "	</TD>"+
								  " <TD width=\"1px\"></TD>"+
								  " </TR>"+
								  "</TABLE>";
						
						objDiv.innerHTML=returnStr;
				   } else {
					   objDiv.innerHTML=rssRequest.responseText;
				   }
				   break;
			} 
		}	
		rssRequest.setRequestHeader("Content-Type","text/xml")	
		rssRequest.send(null);	
	} catch(e){      
        if(e.number==-2147024891){
        	objDiv.innerHTML="<%=SystemEnv.getHtmlLabelName(127877,_language)%>&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(<%=SystemEnv.getHtmlLabelName(127878,_language)%>?)</a>";
                
        }   else {
            objDiv.innerHTML=e.number+":"+e.description;
        }
    }
	
}

//设置提示信息
function setRemindInfo(eid,isremind,tdclass,nameclass){
    var tempremind="";
	if(isremind.indexOf("#")>-1){
	   tempremind=isremind.substring(0,isremind.indexOf("#")-1);
	}else{
	   tempremind=isremind;
	}
    //无new标签
	if(tempremind.indexOf("0")===-1){
		 $("#item_"+eid).find("."+tdclass).find("img").hide();
	} 
	
	var obj = [];
	 var reminditems=$("#item_"+eid).find("."+tdclass).find("img").parents("."+tdclass);
	 var reminditem,color,reqname;
	 for(var i=0,len=reminditems.length;i<len;i++){
		 reminditem=$(reminditems[i]);
		 reqname=reminditem.find("."+nameclass);
		 var str = "";
		 //粗体
		 if(tempremind.indexOf("1")!==-1){
			  reqname.css("font-weight","bold"); 
		      obj.push("font-weight:bold");
		 }
		 //斜体
		 if(tempremind.indexOf("2")!==-1){
			  reqname.css("font-style","italic");
			  obj.push("font-style:italic");
		 }
		 //颜色
		 if(tempremind.indexOf("3")!==-1){
			color=isremind.substr(isremind.indexOf("#"));
			//reqname.css("color",color +" !important");
			//reqname[0].style.setProperty('color', color, 'important');
			reqname.removeClass("font");
			reqname.attr('style', '');
		    obj.push("color:"+color+"");
		 }
		 $(reqname).attr('style', obj.join(";"));
	 }
}

function loadContent(eid,url,queryString,e){
	var event = $.event.fix(e);
	var tabId = jQuery(event.target).attr("tabId");
	if(tabId==undefined) tabId = jQuery(event.target).parents("td:first").attr("tabId");

	var ebaseid = $("#item_"+eid).attr("ebaseid");
	url = url + "?tabId="+tabId+"&"+queryString;
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var objTd=event.target;
	if(event.target.tagName!='TD') objTd=jQuery(event.target).parents("td:first");
	
	$(objTd).siblings().removeClass("tab2selected").removeClass("tab2unselected").addClass("tab2unselected");
	$(objTd).removeClass("tab2unselected").addClass("tab2selected");
	
	$("#tabContant_"+eid).html("<img src=/images/loading2_wev8.gif><%=SystemEnv.getHtmlLabelName(19611,_language)%>...")
	try{
		if(ebaseid==1||ebaseid==29){
			$.get(url, { name: "John", time: "2pm" },function(data){
				$("#tabContant_"+eid).html($.trim(data));
				//fixedPosition(eid);
				//$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
		  	} ); 
		}else{
			$("#tabContant_"+eid).load(url,{},function(){
				//fixedPosition(eid);
				//$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('"+$("#more_"+eid).attr("morehref")+"&tabid="+tabId+"')")
			});
		}
	} catch(e){}
}

function openFullWindowHaveBarForWF(url,requestid){
    try{
		$("#wflist_"+requestid+"img").hide();
		$("#wflist_"+requestid+"img").parent('.reqdetail').find('.reqname').removeAttr("style");
	}catch(e){}
     
	if (url.indexOf("?") != -1) {
		url += "&";
	} else {
		url += "?";
	}
	
	url += "e7" + new Date().getTime() + "=";
	var redirectUrl = url ;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	//if (height == 768 ) height -= 75 ;
	//if (height == 600 ) height -= 60 ;
	 var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowForDoc(url,docid){
    try{
		$("#doclist_"+docid+"img").hide();
		$("#doclist_"+docid+"img").parent('.docdetail').find('.docnamedetail').removeAttr("style");
		$("#doclist_"+docid+"img").parent('.docdetail').find('.docnamedetail').css("color","#242424");
	}catch(e){}
    
	if(url.indexOf("/")==0){
		if (url.indexOf("?") != -1) {
			url += "&";
		} else {
			url += "?";
		}
		url += "e7" + new Date().getTime() + "=";	
	}
	var redirectUrl = url ;
	var width = screen.availWidth ;
	var height = screen.availHeight ;
	var szFeatures = "top=0," ; 
	szFeatures +="left=0," ;
	szFeatures +="width="+(width-10)+"," ;
	szFeatures +="height="+(jQuery.browser.msie?height:(height-60))+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ;
	window.open(redirectUrl,"",szFeatures) ;
}

function onRefresh(eid,ebaseid){
	window.location.reload();
}
</script>