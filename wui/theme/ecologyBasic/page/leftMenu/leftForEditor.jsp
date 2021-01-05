
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig" %>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/template/templateCss.jsp" %>


<%

Map pageConfigKv = getPageConfigInfo(session, user);

String menuborderColor = Util.null2String((String)pageConfigKv.get("menuborderColor"));
String leftbarBgImage = Util.null2String((String)pageConfigKv.get("leftbarBgImage"));
String leftbarBgImageH = Util.null2String((String)pageConfigKv.get("leftbarBgImageH"));
String leftbarborderColor = Util.null2String((String)pageConfigKv.get("leftbarborderColor"));
String leftbarFontColor = Util.null2String((String)pageConfigKv.get("leftbarFontColor"));
String topleftbarBgImage_left = Util.null2String((String)pageConfigKv.get("topleftbarBgImage_left"));
String topleftbarBgImage_center = Util.null2String((String)pageConfigKv.get("topleftbarBgImage_center"));
String topleftbarBgImage_right = Util.null2String((String)pageConfigKv.get("topleftbarBgImage_right"));
String bottomleftbarBgImage_left = Util.null2String((String)pageConfigKv.get("bottomleftbarBgImage_left"));
String bottomleftbarBgImage_center = Util.null2String((String)pageConfigKv.get("bottomleftbarBgImage_center"));
String bottomleftbarBgImage_right = Util.null2String((String)pageConfigKv.get("bottomleftbarBgImage_right"));

//左菜单外边框背景色
if (menuborderColor.equals("")) {
	menuborderColor = "#b1d4d9";
}

//左菜单当前显示分类背景图
if (topleftbarBgImage_left.equals("")) {
	topleftbarBgImage_left = "/wui/theme/ecologyBasic/page/images/left/topFolde_leftr_wev8.png";
}
if (topleftbarBgImage_center.equals("")) {
	topleftbarBgImage_center = "/wui/theme/ecologyBasic/page/images/left/topFolde_center_wev8.png";
}
if (topleftbarBgImage_right.equals("")) {
	topleftbarBgImage_right = "/wui/theme/ecologyBasic/page/images/left/topFolde_right_wev8.png";
}

//左菜单分类背景图(1*26)
if (leftbarBgImage.equals("")){
	leftbarBgImage = "/wui/theme/ecologyBasic/page/images/left/leftbarBgImage_wev8.png";
}

if (leftbarBgImageH.equals("")){
	leftbarBgImageH = "/wui/theme/ecologyBasic/page/images/left/leftbarBgImageH_wev8.png";
}

//左菜单分类字体颜色
if (leftbarFontColor.equals("")){
	leftbarFontColor = "#000";
}
//左侧菜单分类边框色
if (leftbarborderColor.equals("")){
	leftbarborderColor = "#85b9c0";
}
//左菜单底部分类背景图
if (bottomleftbarBgImage_left.equals("")){
	bottomleftbarBgImage_left = "/wui/theme/ecologyBasic/page/images/left/thumbBoxBg_left_wev8.png";
}
if (bottomleftbarBgImage_center.equals("")){
	bottomleftbarBgImage_center = "/wui/theme/ecologyBasic/page/images/left/thumbBoxBg_center_wev8.png";
}
if (bottomleftbarBgImage_right.equals("")){
	bottomleftbarBgImage_right = "/wui/theme/ecologyBasic/page/images/left/thumbBoxBg_right_wev8.png";
}
%>

<HTML>
<HEAD>
<script language="javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<script language="javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>

<style type="text/css">
TABLE  {
}

#divMenuBox {
	border-right:1px solid <%=leftbarborderColor%>!important;
}
#divMenuBox tr td {
	color:<%=leftbarFontColor %>!important;
}

.folderNew{
	padding:0 0 0 10px;
	cursor: pointer!important;
	height:26px!important;
	border-top:1px solid <%=leftbarborderColor%>!important;
	border-left:1px solid <%=leftbarborderColor%>!important;
	border-right:1px solid <%=leftbarborderColor%>!important;
	background-image:url(<%=leftbarBgImage%>)!important;
}
.folderNew img{margin:0 10px 0 10px;vertical-align:middle}
.folderMouseOver {
	height:26px!important;
	cursor: pointer!important;
	height:26px!important;
	border-top:1px solid <%=leftbarborderColor%>!important;
	border-left:1px solid <%=leftbarborderColor%>!important;
	border-right:1px solid <%=leftbarborderColor%>!important;
	background-image:url(<%=leftbarBgImageH %>)!important;
}

#thumbBox{
	background-image:none!important;
	background-repeat:repeat-x!important;
	height:26px!important;
	border-top:1px solid <%=leftbarborderColor%>!important;
}

.handle{
	height:8px!important;
	background:<%=menuborderColor%>!important;
}

/* 左菜单分类背景色(图) */
.topFolder{
	height:26px;
	padding:0 0 0 10px;
	cursor: pointer!important;
	background-image:red!important;
	background-color:<%=UsrTemplate.getLeftbarBgColor()%>;
	border:none;
}

.topFolder img{margin:5 10px 5 10px;vertical-align:middle}


.folderMouseOver{
	
}

.tdFile {
	border-left:1px solid <%=leftbarborderColor%>!important;
	border-right:1px solid <%=leftbarborderColor%>!important;
	border-bottom:1px solid <%=leftbarborderColor%>!important;
}

.bottomThumbBox_bg_left {
	background:url(<%=bottomleftbarBgImage_left %>) no-repeat;
}
.bottomThumbBox_bg_center {
	background:url(<%=bottomleftbarBgImage_center %>) repeat-x;
}
.bottomThumbBox_bg_right {
	background:url(<%=bottomleftbarBgImage_right %>) no-repeat;
}

.topleftbarBgImage_left {
	background-image:url(<%=topleftbarBgImage_left%>);background-repeat:no-repeat;
}

.topleftbarBgImage_center {
	padding-left:5px; background-image:url(<%=topleftbarBgImage_center%>);background-repeat:repeat-x;
}

.topleftbarBgImage_right {
	background-image:url(<%=topleftbarBgImage_right%>);background-repeat:no-repeat;
}
</style>

<script language="javascript" src="/js/Cookies_wev8.js"></script>
<TITLE><%=SystemEnv.getHtmlLabelName(16641,user.getLanguage()) %></TITLE>
<META http-equiv=Content-Language content=zh-cn>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<META content="MSHTML 6.00.2600.0" name=GENERATOR>
<style id="popupmanager"> 
.popupMenu{
	width: 100px;
	border: 1px solid #666666;
	background-color: #F9F8F7;
	padding: 1px;
}
.popupMenuTable{
	background-image: url(/images/popup/bg_menu_wev8.gif);
	background-repeat: repeat-y;
}
.popupMenuTable TD{
	font-family:MS Shell Dlg;
	font-size: 12px;
	cursor: default;
}
.popupMenuRow{
	height: 21px;
	padding: 1px;
}
.popupMenuRowHover{
	height: 21px;
	border: 1px solid #0A246A;
	background-color: #B6BDD2;
}
.popupMenuSep{
	background-color: #A6A6A6;
	height:1px;
	width: expression(parentElement.offsetWidth-27);
	position: relative;
	left: 28;
}
</style>
<style>
body{margin:0;padding:0;}
#divMenuBox td{padding:0}
#divFavContent{display:block;z-index: 1000}
*{font-family:MS Shell Dlg;font-size:12px}
</style>
<base target="mainFrame"/>
</head>

<body> 
<%
//取得左侧菜单信息
int userId = 0;
userId = user.getUID();
MenuMaint  mm=new MenuMaint("left",3,userId,user.getLanguage());

StringBuffer treeStr = new StringBuffer("");
StringBuffer xmlMenuStr = new StringBuffer("<menu>");
int i=0;
String browser_isie=(String)session.getAttribute("browser_isie"); //当前浏览器是否为IE浏览器
i = mm.getMenuXMLString(treeStr,xmlMenuStr,user,i,browser_isie);
%>

<script language="javascript">
var prefixes = ["MSXML2.DomDocument", "Microsoft.XMLDOM", "MSXML.DomDocument", "MSXML3.DomDocument"];
var dom;

var FolderCount = <%=i+4%>;
var thumbCount = 4;
var FolderLeavings = 4;
var menuMargin = 14;

var arrayFolder;
var tbl;
var fileTD;
var rightArrow;
var handleOffsetHeight;

var currentThumbCount,currentMenuId;
var isSuccessful;
var dragging = false;

function getDomObject(){

	if($.browser.msie){
		for (var i = 0; i < prefixes.length; i++) {
			try{
				dom = new ActiveXObject(prefixes[i]);
				if(dom){
					return dom;
				}
			}catch(e){
				//TODO;
				alert(e)
			}
		}
	}else{
		 dom = document.implementation.createDocument("", "", null); 
		 return dom;
	}
}

window.onload = function(){
	//window.resizeBy(0,0);
	/*initialize*/
	getDomObject();
	getXML();
	getCookie();
	isSuccessful = createMenu();
	if(isSuccessful){
		arrayFolder = new Array();
		tbl = document.getElementById("tbl");
		fileTD = document.getElementById("fileTD");
		rightArrow = document.getElementById("rightArrow");
		if(tbl.rows.length-4>=currentThumbCount){
			//alert(currentThumbCount)
			for(var i=0;i<currentThumbCount;i++){delRow();}
		}
		
		getHandleOffsetHeight();
	}
};

window.onbeforeunload = function(){
	setCookie(currentThumbCount,currentMenuId);
};

window.onresize = function(){	
	if(isSuccessful){
		//TD4861
		//if(window.document.body.offsetWidth<134 && window.document.body.offsetWidth>0) parent.document.getElementById("mainFrameSet").cols = "134,*";
		getHandleOffsetHeight();
	}
	
	 
};


var $xml;
function getXML(){
	
    $xml = $('<xml><%=xmlMenuStr.append("</menu>").toString()%></xml>');
	if($xml.find("menubar").length==0){
		$xml = $('<%=xmlMenuStr.toString()%>');
	}
		
}

function getHandleOffsetHeight(){
	var tblTop = 0;
	obj = tbl.rows[3];
	while(obj.tagName!="BODY"){

		tblTop += obj.offsetTop;
		obj = obj.offsetParent;
	}
	handleOffsetHeight = tblTop;
}

/*
function memorizeThumb(){
	var remainRows = Math.ceil((document.body.clientHeight-menuMargin-102)/23)-1;
	if(tbl.rows.length-4>remainRows){
		for(var i=1;i<=tbl.rows.length-4-remainRows;i++){
			if(tbl.rows.length>4){
				delRow();
			}
		}
	}else if(tbl.rows.length-4<remainRows){
		for(var i=1;i<=remainRows-(tbl.rows.length-4);i++){
			if(arrayFolder.length>currentThumbCount){
				addRow();
			}
		}
	}
}
*/

<%=treeStr.toString()%>

var ctThemeXPBase = '/LeftMenu/ThemeXP/';
var canMove=false;
var ctThemeXP1 = {
	folderLeft: [['<img alt="" src="' + ctThemeXPBase + 'folder1_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'folderopen1_wev8.gif" />']],
  	folderRight: [['', '']],
	folderConnect: [[['<img alt="" src="' + ctThemeXPBase + 'plus_wev8.gif" />','<img alt="" src="' + ctThemeXPBase + 'minus_wev8.gif" />'],
					 ['<img alt="" src="' + ctThemeXPBase + 'plusbottom_wev8.gif" />','<img alt="" src="' + ctThemeXPBase + 'minusbottom_wev8.gif" />']]],
	itemLeft: ['<img alt="" src="' + ctThemeXPBase + 'page_wev8.gif" />'],
	itemRight: [''],
	itemConnect: [['<img alt="" src="' + ctThemeXPBase + 'join_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'joinbottom_wev8.gif" />']],
	spacer: [['<img alt="" src="' + ctThemeXPBase + 'line_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'spacer_wev8.gif" />']],
	themeLevel: 1
};

function loadHTML(){
	var nodeMenubar = $xml.find("menubar[id='"+currentMenuId+"']");
	if(nodeMenubar.attr("extra")!=null){
		return false;
	}
	with(document.getElementById("ifrm2")){
		style.display="none";
	}
	with(document.getElementById("ifrm")){
		style.display="";
		style.width = "100%";
		style.height = "100%";
		contentWindow.document.body.style.margin = "0";
		//contentWindow.document.body.style.padding = "2px 0 5px 2px";
		if(nodeMenubar.attr("extra")==null){
			contentWindow.document.body.innerHTML = "<div ID='myMenuID_DIV' style='width:100%;height:100%;'></div>";
			try{
				contentWindow.ctDraw("myMenuID_DIV", eval("myMenu_"+nodeMenubar.attr("id")),ctThemeXP1,'ThemeXP',0,0);
				contentWindow.ctExpandTree('myMenuID_DIV',1);
			}catch(e){
				//TODO
			}
			$(this).unbind("load",loadHTML)
			//detachEvent("onload",loadHTML);
		}
	}
}

function loadJSP(){
	var nodeMenubar = $xml.find("menubar[id='"+currentMenuId+"']");
	if(nodeMenubar.attr("extra")==null){
		return false;
	}
	with(document.getElementById("ifrm")){
		style.display="none";
	}
	
	
	with(document.getElementById("ifrm2")){
		style.display="";
		style.width = "100%";
		style.height = "100%";
		contentWindow.document.body.innerHTML = "";
		if(nodeMenubar.attr("extra")=="systemSetting"){
			$(this).unbind("load",loadJSP);
			//detachEvent("onload",loadJSP);
			var srcStr = "/LeftMenu/SysSettingTreeFactory.jsp";
			contentWindow.location.href=srcStr;
			//src= srcStr;
		}else if(nodeMenubar.attr("extra")=="myReport"){
			//detachEvent("onload",loadJSP);
			//$(this).bind("load",loadJSP);
			$(this).unbind("load",loadJSP);
			var srcStr = "/LeftMenu/SysSettingTreeFactory.jsp?extra=myReport";
			contentWindow.location.href=srcStr;
			//src= srcStr;
		}else if(nodeMenubar.attr("extra")=="infoCenter"){
			//detachEvent("onload",loadJSP);
			//$(this).bind("load",loadJSP);
			$(this).unbind("load",loadJSP);
			var srcStr = "/LeftMenu/InfoCenterTreeFactory.jsp";
			contentWindow.location.href=srcStr;
			//src= srcStr;
		}else if(nodeMenubar.attr("extra")=="myEmail"){
			$(this).unbind("load",loadJSP);
			var srcStr = "/email/new/leftmenuForMailFrame.jsp";
			contentWindow.location.href=srcStr;
		}
	}
	
}
function createMenu(){
	var oTbl,oTR,oTD,oCurrentNode;
	if($xml.find("menubar[id='"+currentMenuId+"']")==null){
		currentMenuId=0;
	}
	oCurrentNode = $xml.find("menubar[id='"+currentMenuId+"']");



	oTbl = document.createElement("table");
	oTbl.id = "tbl";
	oTbl.cellSpacing = "0";
	oTbl.className = "OTTable";	
	oTbl.style.background = "<%=leftbarborderColor%>";
	oTbl.style.tableLayout = "fixed";
	
	oTR = oTbl.insertRow(-1);
	oTR.style.height="24px";
	oTD = oTR.insertCell(-1);

	//oTD.onclick=function(){	
		//var url=oCurrentNode.getAttribute("url");
		//var target=oCurrentNode.getAttribute("target");		
	//}
	
	if(oCurrentNode==null) return false;
	oTD.setAttribute("menuid",oCurrentNode.attr("id"));
	oTD.setAttribute("extra",oCurrentNode.attr("extra"));
	oTD.className = "topFolder";
	oTD.style.position = "relative";
	oTD.style.background = "<%=menuborderColor%>";
	oTD.innerHTML = "<table id=\"topFolderBgTbl\" cellspacing=\"0\" cellpadding=\"0\" height=\"28px\" width=\"100%\" style=\"top:-1;left:0;z-index:-1;\"><tr height=\"100%\" width=\"100%\"><td height=\"100%\" width=\"5px\" class=\"topleftbarBgImage_left\"></td><td height=\"100%\" width=\"*\" class=\"topleftbarBgImage_center\"><img style=\"position:relative;z-index:2;margin-right:5px\" width='16' heigh='16' src='"+oCurrentNode.attr("icon")+"'/>&nbsp;" + oCurrentNode.attr("name")+"</td><td height=\"100%\" width=\"5px\" class=\"topleftbarBgImage_right\"></td></tr></table>";

	oTR = oTbl.insertRow(-1);
	oTD = oTR.insertCell(-1);
	oTD.id = "fileTD";
	oTD.className = "tdFile";
	var oIframe = document.createElement("iframe");
	oIframe.id = "ifrm";
	oIframe.style.width = "0";
	oIframe.style.height = "0";
	oIframe.frameBorder = "0";
	oIframe.src = "/wui/theme/ecologyBasic/page/leftMenu/leftTree.htm";
	$(oIframe).bind("load",loadHTML);
	//oIframe.attachEvent("onload",loadHTML);
	oTD.appendChild(oIframe);
	var oIframe2 = document.createElement("iframe");
	oIframe2.id = "ifrm2";
	oIframe2.style.width = "0";
	oIframe2.style.height = "0";
	oIframe2.frameBorder = "0";
	//oIframe2.src = "/wui/theme/ecologyBasic/page/leftTree.htm";
	//oIframe2.attachEvent("onload",loadJSP);
	$(oIframe2).bind("load",loadJSP);
	oTD.appendChild(oIframe2);

	oTR = oTbl.insertRow(-1);
	oTD = oTR.insertCell(-1);
	oTD.className = "handle";
	oTD.innerHTML = "<img src=\"/images/StyleGray/handleH_wev8.gif\" style=\"margin-top:1px\"/>";
	//oTD.onmousedown = mousedown;
	//oTD.onmouseup = mouseup;
	//oTD.onmousemove = mousemove;
	$(oTD).bind("mousedown",mousedown)
	$(oTD).bind("mouseup",mouseup)
	$(oTD).bind("mousemove",mousemove)
	var oNodes = $xml.find("menubar");
	for(i=0;i<oNodes.length;i++){
		oTR = oTbl.insertRow(-1);
		oTR.style.height="26px";

		oTD = oTR.insertCell(-1);
		oTD.setAttribute("menuid",$(oNodes[i]).attr("id"));
		oTD.setAttribute("extra",$(oNodes[i]).attr("extra"));
		if($(oNodes[i]).attr("id")==currentMenuId){
			oTD.className = "folderMouseOver";
		}else{
			oTD.className = "folderNew";
			$(oTD).bind("mouseover",folderMouseOver);
			$(oTD).bind("mouseout",folderMouseOut);
			//oTD.attachEvent("onmouseover",folderMouseOver);
			//oTD.attachEvent("onmouseout",folderMouseOut);
		}
		oTD.onclick = function(){	
			slideFolder(this);
			tempNode = $xml.find("menubar[id='"+currentMenuId+"']");
			var url=tempNode.attr("url");
			var target=tempNode.attr("target");		
			if(!(url==null || url=="" || url=="null")) window.open(url,target);			
		};	
	
		oTD.innerHTML = "<img width='16' heigh='16' src='"+$(oNodes[i]).attr("icon")+"'/>" + $(oNodes[i]).attr("name") ;
	}

	oTR = oTbl.insertRow(-1);
	oTD = oTR.insertCell(-1);
	oTD.id = "thumbBox";
	oTD.style.position = "relative";
	oTD.innerHTML = "<table cellspacing=\"0\" cellpadding=\"0\" height=\"28px\" width=\"100%\" style=\"top:0;left:0;z-index:-1;\"><tr height=\"100%\" width=\"100%\"><td height=\"100%\" width=\"65px\" class=\"bottomThumbBox_bg_left\">&nbsp;</td><td height=\"100%\" width=\"*\" align='right' class=\"bottomThumbBox_bg_center\">&nbsp;<img id='rightArrow' style='cursor:pointer;' src='/images/StyleGray/rArrow_wev8.gif' onclick='showFav(this)'/></td><td height=\"100%\" width=\"5px\" class=\"bottomThumbBox_bg_right\"></td></tr></table>";
	document.getElementById("divMenuBox").rows[0].cells[0].appendChild(oTbl);
	return true;
}

function folderMouseOver(event){
	//var event = window.event;
	var o = event.srcElement ? event.srcElement : event.target;
	//alert(o.innerHTML);
	if(o.tagName!="IMG") o.className = "folderMouseOver";
}

function folderMouseOut(event){
	//var event = window.event;
	var o = event.srcElement ? event.srcElement : event.target;
	if(o.tagName!="IMG") o.className = "folderNew";
}

function slideFolder(o){
	
	$(o).unbind("mouseover",folderMouseOver)
	$(o).unbind("mouseout",folderMouseOut)
	//o.detachEvent("onmouseover",folderMouseOver);
	//o.detachEvent("onmouseout",folderMouseOut);
	
	if(currentMenuId!=null && currentMenuId!=o.getAttribute("menuid")){
		if(tbl.rows[3+parseInt(currentMenuId)]!=null && (tbl.rows.length-1)!=(3+parseInt(currentMenuId))){
			tbl.rows[3+parseInt(currentMenuId)].cells[0].className = "folderNew";
			$(tbl.rows[3+parseInt(currentMenuId)].cells[0]).bind("mouseover",folderMouseOver);
			$(tbl.rows[3+parseInt(currentMenuId)].cells[0]).bind("mouseout",folderMouseOut);
			//tbl.rows[3+parseInt(currentMenuId)].cells[0].attachEvent("onmouseover",folderMouseOver);
			//tbl.rows[3+parseInt(currentMenuId)].cells[0].attachEvent("onmouseout",folderMouseOut);
		}
	}
	currentMenuId = o.getAttribute("menuid");
	
	var nodeMenubar = $xml.find("menubar[id='"+currentMenuId+"']");
	tbl.rows[0].firstChild.innerHTML ="<table id=\"topFolderBgTbl\" cellspacing=\"0\" cellpadding=\"0\" height=\"28px\" width=\"100%\" style=\"top:-1;left:0;z-index:-1;\"><tr height=\"100%\" width=\"100%\"><td height=\"100%\" width=\"5px\" class=\"topleftbarBgImage_left\"></td><td height=\"100%\" width=\"*\" class=\"topleftbarBgImage_center\"><img style=\"position:relative;z-index:2;margin-right:5px\" width='16' heigh='16' src='"+nodeMenubar.attr("icon")+"'/>&nbsp;" + nodeMenubar.attr("name")+"</td><td height=\"100%\" width=\"5px\" class=\"topleftbarBgImage_right\"></td></tr></table>";

	//todo
	var oIframe = document.getElementById("ifrm");
	var oIframe2 = document.getElementById("ifrm2");
	if(nodeMenubar.attr("extra")==null){
		loadHTML();
	}else{
		loadJSP();
	}
	//setCookie(currentThumbCount,currentMenuId);
}

function mousedown(event){
	
	//el = window.event.srcElement;
	el = event.srcElement ? event.srcElement : event.target;
	//alert(el.tagName)
	while(el.tagName!="TD"){
		el = el.parentElement;
	}
	//alert(el.setCapture)
	if(el.setCapture) {
		el.setCapture();
	}else {
		//alert(Event.MOUSEMOVE)
	    window.captureEvents(Event.MOUSEMOVE|Event.MOUSEUP);
	    document.getElementById("ifrm").contentWindow.document.addEventListener('mousemove', mousemove, false);
	    document.getElementById("ifrm").contentWindow.document.addEventListener('mouseup', mouseup, false);
	    document.getElementById("ifrm2").contentWindow.document.addEventListener('mousemove', mousemove, false);
	    document.getElementById("ifrm2").contentWindow.document.addEventListener('mouseup', mouseup, false);
	    
	    document.addEventListener('mousemove', mousemove, false);
        document.addEventListener('mouseup', mouseup, false)
	}
	//el.setCapture();
	dragging = true;
}

function mouseup(){
	if(el.releaseCapture) {
		el.releaseCapture();
	}else {
	    window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP);
	    document.removeEventListener('mousemove', mousemove, false);
        document.removeEventListener('mouseup', mouseup, false)

        document.getElementById("ifrm").contentWindow.document.removeEventListener('mousemove', mousemove, false);
	    document.getElementById("ifrm").contentWindow.document.removeEventListener('mouseup', mouseup, false);
	    document.getElementById("ifrm2").contentWindow.document.removeEventListener('mousemove', mousemove, false);
	    document.getElementById("ifrm2").contentWindow.document.removeEventListener('mouseup', mouseup, false);
	    
	} 
	
	dragging = false;
}

function mousemove(event){
	//TD3973
	//modified by hubo,2006-03-16
	if(!dragging){	
		return false;
	}else{
		getHandleOffsetHeight();
	}
	event = jQuery.event.fix(event);
	event.cancelBubble = false;
	cliX = event.clientX;
	cliY = event.clientY;

	if(cliY<180) return false;
	//window.status = "handleOffsetHeight="+handleOffsetHeight;
	if(cliY>handleOffsetHeight+26 && tbl.rows.length<=FolderCount && tbl.rows.length>FolderLeavings){
		delRow();
		currentThumbCount++;
		handleOffsetHeight+=26;
	}
	if(canMove){
		if(cliY<handleOffsetHeight-26 && tbl.rows.length<FolderCount && tbl.rows.length>=FolderLeavings){
			addRow();
			currentThumbCount--;
			handleOffsetHeight-=26;
		}
	}
	setCookie(currentThumbCount,currentMenuId);
}

function delRow(){
	
	if(tbl.rows[tbl.rows.length-2].firstChild.className=="handle") return false;
	arrayFolder.push(tbl.rows[tbl.rows.length-2].firstChild.getAttribute("menuid")+"|"+tbl.rows[tbl.rows.length-2].firstChild.innerHTML);
	
	var oImg = document.createElement("img");
	oImg.setAttribute("menuid",tbl.rows[tbl.rows.length-2].firstChild.getAttribute("menuid"));
	oImg.setAttribute("menuname",tbl.rows[tbl.rows.length-2].firstChild.children[0].nextSibling.nodeValue);
	oImg.alt = tbl.rows[tbl.rows.length-2].firstChild.children[0].nextSibling.nodeValue;
	oImg.style.cursor = "pointer";
	oImg.src = tbl.rows[tbl.rows.length-2].firstChild.firstChild.src;
	oImg.width = "16";
	oImg.height = "16";
	oImg.onclick = function(){slideFolder(this)};

	if(arrayFolder.length<=thumbCount){
		var tb1B = tbl.rows[tbl.rows.length-1].firstChild.firstChild;
		tb1B.style.tableLayout="";
		//alert(tb1B.rows[0].children[1].innerHTML)
		tb1B.rows[0].children[1].insertBefore(oImg,rightArrow);
	}else{
		insertToPopupMenu(oImg);
	}
	canMove=true;
	tbl.deleteRow(tbl.rows.length-2);
}

function insertToPopupMenu(o){
	//parent.parent.insertToPopupMenu(o);
}

function addRow(){
	var oTR = tbl.insertRow(tbl.rows.length-1);
	var oTD = document.createElement("td");
	var arrayTmp = arrayFolder.pop().split("|");
	oTD.setAttribute("menuid",arrayTmp[0]);
	oTD.innerHTML = arrayTmp[1];
	if(arrayTmp[0]==currentMenuId){
		oTD.className = "folderMouseOver";
	}else{
		oTD.className = "folderNew";
		$(oTD).bind("mouseover",folderMouseOver);
		$(oTD).bind("mouseout",folderMouseOut);
		//oTD.attachEvent("onmouseover",folderMouseOver);
		//oTD.attachEvent("onmouseout",folderMouseOut);
	}
	oTD.onclick = function(){slideFolder(this)};
	oTR.appendChild(oTD);
	//tbl2 = $(".popupMenuTable").get(0);
	tbl2 = $(".popupMenuTable",parent.parent.document).get(0);
	//alert(tbl2.rows.length)
	if(tbl2.rows.length>2){
		tbl2.deleteRow(-1);
	}else{
		var tmp = tbl.rows[tbl.rows.length-1].firstChild.firstChild;
		//alert(tmp.innerHTML)
		//srty
		tmp = tmp.rows[0].cells[1]
	
		//alert(tmp.innerHTML)
		//alert(jQuery(tmp).find("img:last").html())
		jQuery(tmp).find("img:last").prev().remove();
		//tmp.removeChild(tmp.children[0]);
		if(jQuery(tmp).find("img").length==1){
			canMove=false;
		}
		
	}
}

function setCookie(cThumbCount,cMenuId){ 
	var cookieDate = new Date();
	cookieDate.setTime(cookieDate.getTime() + 10*365*24*60*60*1000);
	document.cookie = "cookieLeftMenu<%=userId%>="+cThumbCount+","+cMenuId+";expires="+cookieDate.toGMTString();
}

function getCookie(){ 
	try{
		var cookieData = new String(document.cookie); 
		var cookieHeader = "cookieLeftMenu<%=userId%>=" 
		var cookieStart = cookieData.indexOf(cookieHeader) + cookieHeader.length; 
		var cookieEnd = cookieData.indexOf(";", cookieStart); 
		if(cookieEnd==-1){ 
			cookieEnd = cookieData.length;
		}
		if(cookieData.indexOf(cookieHeader)!=-1){ 
			//currentThumbCount = cookieData.substring(cookieStart, cookieEnd).split(",")[0];
			currentMenuId = cookieData.substring(cookieStart, cookieEnd).split(",")[1];
			currentThumbCount=8;
		}else{
			currentThumbCount = 8;
			currentMenuId = $($xml.find("menubar")[0]).attr("id");
		}
	}catch(e){}
}



function GetPopupCssText(){
	var styles = document.styleSheets;
	var csstext = "";
	for(var i=0; i<styles.length; i++){
		if (styles[i].id == "popupmanager")
			csstext += styles[i].cssText;
	}
	return csstext;
}

function showFav(obj){
	var popupX = 0;
	var popupY = 0;
	//alert($("#divFavContent").html())
	//$("#divFavContent",parent.parent.document).css("position","absolute");
	var offset = $(obj).offset();
	//alert(offset.left)
	$("#divFavContent",parent.parent.document).css({left:offset.left+26,bottom:offset.bottom});
	
	$("#divFavContent",parent.parent.document).show();
}

function mouseout(){
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) oPopup.hide();
}

function onDivMenuBoxResize(obj){
	var expires = new Date();
	expires.setTime(expires.getTime() + 6 * 30 * 24 * 60 * 60 * 1000);
		
	Cookies.set('iLeftMenuFrameWidth',obj.offsetWidth,expires);
}
</script>

<table id="divMenuBox" onresize="onDivMenuBoxResize(this)" style="width:100%;height:100%;" cellpadding="0" cellspacing="0">
<TR>

<%
String leftmenuBoxBg="";
String leftmenuToggleBg="";
if(UsrTemplate.getMenuborderbg().equals("")||UsrTemplate.getMenuborderbg().equals("0")){
	leftmenuBoxBg="/images/StyleGray/leftmenuBoxBg_wev8.jpg";
	leftmenuToggleBg="/images/StyleGray/leftmenuToggleBg_wev8.jpg";
%>
	<TD style="height:100%;padding:8px 0 8px 8px;background:<%=menuborderColor%>;background-position:right;background-repeat:repeat-y;" style="border-left:1px solid #6ba5ae;"></TD>
	<td id="tdDrag" style="height:100%;width:8px;padding:0px 0 0px 0px;background:<%=menuborderColor%>;text-align:center;"><img src="/images/StyleGray/handleV_wev8.gif"/></td>

<%}else if(!UsrTemplate.getMenuborderbg().equals("0")){
	leftmenuBoxBg=uploadPath+UsrTemplate.getMenuborderbg();
	leftmenuToggleBg=uploadPath+UsrTemplate.getMenuborderbg();
	%>
	<TD style="height:100%;padding:8px 0 8px 8px;background-image:url(<%=leftmenuBoxBg%>)"></TD>
	<td id="tdDrag" style="height:100%;width:8px;padding:0px 0 0px 0px;background-image:url(<%=leftmenuToggleBg%>);text-align:center"><img src="/images/StyleGray/handleV_wev8.gif"/></td>
<%}

%>

	
</TR>
</table>

</BODY>
</HTML>
<script type="text/javascript">
$(document).ready(function () {
	//alert($.client.browser=="Chrome")
	if($.client.browser=="Chrome") {
		parent.mainFrameSet.cols="180,*";
	}
});
</script>

