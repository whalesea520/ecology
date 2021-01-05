
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

<HTML>
<HEAD>
<script language="javascript" src="/js/Cookies_wev8.js"></script>
<TITLE><%=SystemEnv.getHtmlLabelName(16641,user.getLanguage())%></TITLE>
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
#divFavContent{display:none;}
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
	for (var i = 0; i < prefixes.length; i++) {
		try{
			dom = new ActiveXObject(prefixes[i]);
			if(dom){
				return dom;
			}
		}catch(e){
			//TODO;
		}
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
		if(window.document.body.offsetWidth<134 && window.document.body.offsetWidth>0) parent.document.getElementById("mainFrameSet").cols = "134,*";
		getHandleOffsetHeight();
	}
	
	 
};



function getXML(){
	dom.async = false;
	dom.loadXML('<%=xmlMenuStr.append("</menu>").toString()%>');	
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
	var nodeMenubar = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");
	if(nodeMenubar.getAttribute("extra")!=null){
		return false;
	}
	with(document.getElementById("ifrm2")){
		style.width = "0";
		style.height = "0";
	}
	with(document.getElementById("ifrm")){
		style.width = "100%";
		style.height = "100%";
		contentWindow.document.body.style.margin = "0";
		contentWindow.document.body.style.padding = "2px 0 5px 2px";
		if(nodeMenubar.getAttribute("extra")==null){
			contentWindow.document.body.innerHTML = "<div ID='myMenuID_DIV' style='width:100%;'></div>";
			try{
				contentWindow.ctDraw("myMenuID_DIV", eval("myMenu_"+nodeMenubar.getAttribute("id")),ctThemeXP1,'ThemeXP',0,0);
				contentWindow.ctExpandTree('myMenuID_DIV',1);
			}catch(e){
				//TODO
			}
			detachEvent("onload",loadHTML);
		}
	}
}

function loadJSP(){
	var nodeMenubar = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");
	if(nodeMenubar.getAttribute("extra")==null){
		return false;
	}
	with(document.getElementById("ifrm")){
		style.width = "0";
		style.height = "0";
	}
	with(document.getElementById("ifrm2")){
		style.width = "100%";
		style.height = "100%";
		//alert(nodeMenubar.attr("extra"))
		contentWindow.document.body.innerHTML = "";
		if(nodeMenubar.getAttribute("extra")=="systemSetting"){
			detachEvent("onload",loadJSP);
			var srcStr = "/LeftMenu/SysSettingTreeFactory.jsp";
			contentWindow.location.replace(srcStr);
		}else if(nodeMenubar.getAttribute("extra")=="myReport"){
			detachEvent("onload",loadJSP);
			var srcStr = "/LeftMenu/SysSettingTreeFactory.jsp?extra=myReport";
			contentWindow.location.replace(srcStr);
		}else if(nodeMenubar.getAttribute("extra")=="infoCenter"){
			detachEvent("onload",loadJSP);
			var srcStr = "/LeftMenu/InfoCenterTreeFactory.jsp";
			contentWindow.location.replace(srcStr);
		}else if(nodeMenubar.getAttribute("extra")=="myEmail"){
			detachEvent("onload",loadJSP);
			var srcStr = "/email/new/leftmenu.jsp";
			contentWindow.location.replace(srcStr);
		}
	}
}
function createMenu(){
	var oTbl,oTR,oTD,oCurrentNode;
	if(dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']")==null){
		currentMenuId=0;
	}
	oCurrentNode = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");



	oTbl = document.createElement("table");
	oTbl.id = "tbl";
	oTbl.cellSpacing = "1";
	oTbl.className = "OTTable";	

	oTR = oTbl.insertRow();

	oTD = oTR.insertCell();

	//oTD.onclick=function(){	
		//var url=oCurrentNode.getAttribute("url");
		//var target=oCurrentNode.getAttribute("target");		
	//}
	
	if(oCurrentNode==null) return false;
	oTD.setAttribute("menuid",oCurrentNode.getAttribute("id"));
	oTD.className = "folder";
	oTD.innerHTML = "<img width='16' heigh='16' src='"+oCurrentNode.getAttribute("icon")+"'/>" + oCurrentNode.getAttribute("name")+"";

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.id = "fileTD";
	oTD.className = "file";
	var oIframe = document.createElement("iframe");
	oIframe.id = "ifrm";
	oIframe.style.width = "0";
	oIframe.style.height = "0";
	oIframe.frameBorder = "0";
	oIframe.src = "/LeftMenu/leftTree.htm";
	oIframe.attachEvent("onload",loadHTML);
	oTD.appendChild(oIframe);
 
	var oIframe2 = document.createElement("iframe");
	oIframe2.id = "ifrm2";
	oIframe2.style.width = "0";
	oIframe2.style.height = "0";
	oIframe2.frameBorder = "0";
	oIframe2.src = "/LeftMenu/leftTree.htm";
	oIframe2.attachEvent("onload",loadJSP);
	oTD.appendChild(oIframe2);

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.className = "handle";
	oTD.innerHTML = "<img src=\"/images/StyleGray/handleH_wev8.gif\" style=\"margin-top:1px\"/>";
	oTD.onmousedown = function(){mousedown();};
	oTD.onmouseup = function(){mouseup();};
	oTD.onmousemove = function(){mousemove();};

	var oNodes = dom.selectNodes("//menubar");
	for(i=0;i<oNodes.length;i++){
		oTR = oTbl.insertRow();
		

		oTD = oTR.insertCell();
		oTD.setAttribute("menuid",dom.selectSingleNode("//menubar["+i+"]").getAttribute("id"));
		if(dom.selectSingleNode("//menubar["+i+"]").getAttribute("id")==currentMenuId){
			oTD.className = "folderMouseOver";
		}else{
			oTD.className = "folder";
			oTD.attachEvent("onmouseover",folderMouseOver);
			oTD.attachEvent("onmouseout",folderMouseOut);
		}
		oTD.onclick = function(){	
			slideFolder(this);
			tempNode = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");
			var url=tempNode.getAttribute("url");
			var target=tempNode.getAttribute("target");		
			if(!(url==null || url=="" || url=="null")) window.open(url,target);			
		};	
	
		oTD.innerHTML = "<img width='16' heigh='16' src='"+dom.selectSingleNode("//menubar["+i+"]").getAttribute("icon")+"'/>" + dom.selectSingleNode("//menubar["+i+"]").getAttribute("name") ;
	}

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.id = "thumbBox";
	oTD.innerHTML = "<img id='rightArrow' src='/images/StyleGray/rArrow_wev8.gif' onclick='showFav()'/>";

	document.getElementById("divMenuBox").rows[0].cells[0].appendChild(oTbl);
	return true;
}

function folderMouseOver(){
	var o = window.event.srcElement;
	if(o.tagName!="IMG") o.className = "folderMouseOver";
}

function folderMouseOut(){
	var o = window.event.srcElement;
	if(o.tagName!="IMG") o.className = "folder";
}

function slideFolder(o){
	o.detachEvent("onmouseover",folderMouseOver);
	o.detachEvent("onmouseout",folderMouseOut);
	
	if(currentMenuId!=null && currentMenuId!=o.getAttribute("menuid")){
		if(tbl.rows[3+parseInt(currentMenuId)]!=null && (tbl.rows.length-1)!=(3+parseInt(currentMenuId))){
			tbl.rows[3+parseInt(currentMenuId)].cells[0].className = "folder";
			tbl.rows[3+parseInt(currentMenuId)].cells[0].attachEvent("onmouseover",folderMouseOver);
			tbl.rows[3+parseInt(currentMenuId)].cells[0].attachEvent("onmouseout",folderMouseOut);
		}
	}
	currentMenuId = o.getAttribute("menuid");

	var nodeMenubar = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");
	tbl.rows[0].firstChild.innerHTML = "<img src='"+nodeMenubar.getAttribute("icon")+"' width='16' heigh='16'/>" + nodeMenubar.getAttribute("name");

	var oIframe = document.getElementById("ifrm");
	var oIframe2 = document.getElementById("ifrm2");
	if(nodeMenubar.getAttribute("extra")==null){
		loadHTML();
	}else if(nodeMenubar.getAttribute("extra")=="systemSetting"){
		loadJSP();
	}else if(nodeMenubar.getAttribute("extra")=="myReport"){
		loadJSP();
	}else if(nodeMenubar.getAttribute("extra")=="infoCenter"){
		loadJSP();
	}else if(nodeMenubar.getAttribute("extra")=="myEmail"){
		loadJSP();
	}
	//setCookie(currentThumbCount,currentMenuId);
}

function mousedown(){
	el = window.event.srcElement;
	while(el.tagName!="TD"){
		el = el.parentElement;
	}
	el.setCapture();
	dragging = true;
}

function mouseup(){
	el.releaseCapture();
	dragging = false;
}

function mousemove(){
	//TD3973
	//modified by hubo,2006-03-16
	if(!dragging){	
		return false;
	}else{
		getHandleOffsetHeight();
	}

	window.event.cancelBubble = false;
	cliX = window.event.clientX;
	cliY = window.event.clientY;

	if(cliY<100) return false;
	//window.status = "handleOffsetHeight="+handleOffsetHeight;
	if(cliY>handleOffsetHeight+22 && tbl.rows.length<=FolderCount && tbl.rows.length>FolderLeavings){
		delRow();
		currentThumbCount++;
		handleOffsetHeight+=22;
	}
	if(cliY<handleOffsetHeight-22 && tbl.rows.length<FolderCount && tbl.rows.length>=FolderLeavings){
		addRow();
		currentThumbCount--;
		handleOffsetHeight-=22;
	}
	//setCookie(currentThumbCount,currentMenuId);
}

function delRow(){
	if(tbl.rows[tbl.rows.length-2].firstChild.className=="handle") return false;
	arrayFolder.push(tbl.rows[tbl.rows.length-2].firstChild.getAttribute("menuid")+"|"+tbl.rows[tbl.rows.length-2].firstChild.innerHTML);
	
	var oImg = document.createElement("img");
	oImg.setAttribute("menuid",tbl.rows[tbl.rows.length-2].firstChild.getAttribute("menuid"));
	oImg.setAttribute("menuname",tbl.rows[tbl.rows.length-2].firstChild.children[0].nextSibling.nodeValue);
	oImg.alt = tbl.rows[tbl.rows.length-2].firstChild.children[0].nextSibling.nodeValue;
	oImg.style.cursor = "hand";
	oImg.src = tbl.rows[tbl.rows.length-2].firstChild.firstChild.src;
	oImg.width = "16";
	oImg.height = "16";
	oImg.onclick = function(){slideFolder(this)};

	if(arrayFolder.length<=thumbCount){
		tbl.rows[tbl.rows.length-1].firstChild.insertBefore(oImg,rightArrow);
	}else{
		insertToPopupMenu(oImg);
	}

	tbl.deleteRow(tbl.rows.length-2);
}

function insertToPopupMenu(o){
	var tbl,tbl2,tr,td;
	tbl = document.createElement("table");
	tbl.cellspacing = 0;
	tbl.cellpadding = 0;
	tbl.width = "100%";
	tbl.height = "100%";
	tr = tbl.insertRow();
	td = tr.insertCell();
	td.width = 28;
	td.innerHTML = "<img src='"+o.src+"' width='16' heigh='16'/>";
	td = tr.insertCell();
	td.innerHTML = o.getAttribute("menuname");

	tbl2 = document.getElementById("divFavContent").firstChild.firstChild;
	tr = tbl2.insertRow();
	td = tr.insertCell();
	tr.height = 22;
	td.className = "popupMenuRow";
	td.setAttribute("menuid",o.getAttribute("menuid"));
	td.appendChild(tbl);
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
		oTD.className = "folder";
		oTD.attachEvent("onmouseover",folderMouseOver);
		oTD.attachEvent("onmouseout",folderMouseOut);
	}
	oTD.onclick = function(){slideFolder(this)};
	oTR.appendChild(oTD);

	if(document.getElementById("divFavContent").firstChild.firstChild.rows.length>2){
		document.getElementById("divFavContent").firstChild.firstChild.deleteRow();
	}else{
		var tmp = tbl.rows[tbl.rows.length-1].firstChild;
		tmp.removeChild(tmp.children[tmp.children.length-2]);
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
			currentThumbCount = cookieData.substring(cookieStart, cookieEnd).split(",")[0];
			currentMenuId = cookieData.substring(cookieStart, cookieEnd).split(",")[1];
		}else{
			currentThumbCount = 0;
			currentMenuId = dom.selectSingleNode("//menubar[0]").getAttribute("id");
		}
	}catch(e){}
}


/*
==============================================
PopupMenu
==============================================
*/
var oPopup;
try{
    oPopup = window.createPopup();
}catch(e){}
function GetPopupCssText(){
	var styles = document.styleSheets;
	var csstext = "";
	for(var i=0; i<styles.length; i++){
		if (styles[i].id == "popupmanager")
			csstext += styles[i].cssText;
	}
	return csstext;
}

function showFav(){
  try{
	var popupX = 0;
	var popupY = 0;
	contentBox = document.getElementById("divFavContent");
	var o = event.srcElement;
	while(o.tagName!="BODY"){
		popupX += o.offsetLeft;
		popupY += o.offsetTop;
		o = o.offsetParent;
	}
	var oPopBody = oPopup.document.body;
	var s = oPopup.document.createStyleSheet();
	s.cssText = GetPopupCssText();
    oPopBody.innerHTML = contentBox.innerHTML;
	oPopBody.attachEvent("onmouseout",mouseout);

	//
	for(var i=0;i<oPopup.document.getElementsByTagName("TD").length;i++){
		if(oPopup.document.getElementsByTagName("TD")[i].getAttribute("menuid")!=null){
			oPopup.document.getElementsByTagName("TD")[i].onclick = function(){slideFolder(this);};
			oPopup.document.getElementsByTagName("TD")[i].onmouseover = function(){this.className='popupMenuRowHover';};
			oPopup.document.getElementsByTagName("TD")[i].onmouseout = function(){this.className='popupMenuRow';};
		}
	}

	oPopup.show(0, 0, 100, 0);
	var realHeight = oPopBody.scrollHeight;
	oPopup.hide();

	oPopup.show(popupX+20, popupY, 100, realHeight, document.body);
  }catch(e){}	
}

function mouseout(){
  try{
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) oPopup.hide();
  }catch(e){}	
}
function onDivMenuBoxResize(obj){
	var expires = new Date();
	expires.setTime(expires.getTime() + 6 * 30 * 24 * 60 * 60 * 1000);
		
	Cookies.set('iLeftMenuFrameWidth',obj.offsetWidth,expires);
}
</script>

<table id="divMenuBox" onresize="onDivMenuBoxResize(this)" style="width:100%;height:100%;border-top:2px solid #6F6F6F;border-bottom:2px solid #6F6F6F;" cellpadding="0" cellspacing="0">
<TR>

<%
String leftmenuBoxBg="";
String leftmenuToggleBg="";
if(UsrTemplate.getMenuborderbg().equals("")||UsrTemplate.getMenuborderbg().equals("0")){
	leftmenuBoxBg="/images/StyleGray/leftmenuBoxBg_wev8.jpg";
	leftmenuToggleBg="/images/StyleGray/leftmenuToggleBg_wev8.jpg";
%>
	<TD style="height:100%;padding:4px 0 4px 4px;background-image:url(<%=leftmenuBoxBg%>);background-position:right;background-repeat:repeat-y"></TD>
	<td style="height:100%;width:5px;padding:0px 0 0px 0px;background-image:url(<%=leftmenuToggleBg%>);text-align:center"><img src="/images/StyleGray/handleV_wev8.gif"/></td>

<%}else if(!UsrTemplate.getMenuborderbg().equals("0")){
	leftmenuBoxBg=uploadPath+UsrTemplate.getMenuborderbg();
	leftmenuToggleBg=uploadPath+UsrTemplate.getMenuborderbg();
	%>
	<TD style="height:100%;padding:4px 0 4px 4px;background-image:url(<%=leftmenuBoxBg%>)"></TD>
	<td style="height:100%;width:5px;padding:0px 0 0px 0px;background-image:url(<%=leftmenuToggleBg%>);text-align:center"><img src="/images/StyleGray/handleV_wev8.gif"/></td>
<%}

%>

	
</TR>
</table>

<div id="divFavContent">
	<div class="popupMenu">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="popupMenuTable">
		<tr height="22">
			<td class="popupMenuRow" onmouseover="this.className='popupMenuRowHover';" onmouseout="this.className='popupMenuRow';" id="popupWin_Menu_Setting">
				<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
					<tr>
						<td width="28">&nbsp;</td>
						<td onclick="parent.parent.mainFrame.location.href='/systeminfo/menuconfig/CustomSetting.jsp';"><%=SystemEnv.getHtmlLabelName(18166,user.getLanguage())%></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="3">
			<td>
				<div class="popupMenuSep"><img height="1px"></div>
			</td>
		</tr>
	</table>
	</div>
</div>

</BODY>
</HTML>


