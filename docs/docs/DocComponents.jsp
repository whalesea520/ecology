
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String mode = Util.null2String(request.getParameter("mode"));
String docid = Util.null2String(request.getParameter("docid"));
String secid = Util.null2String(request.getParameter("secid"));
String pagename = Util.null2String(request.getParameter("pagename"));
String operation = Util.null2String(request.getParameter("operation"));
int maxUploadImageSize = Util.getIntValue(Util.null2String(request.getParameter("maxUploadImageSize")),0);
int bacthDownloadFlag = Util.getIntValue(Util.null2String(request.getParameter("bacthDownloadFlag")),0);
String canShare = Util.null2String(request.getParameter("canShare"));
int language = user.getLanguage();
String isEnableExtranetHelp = KtreeHelp.getInstance().isEnableExtranetHelp;
%>
<%
if(operation.equals("getBase")){
%>
<style>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
</style>
<div id="loading">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, language)%></span>
</div>

<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext_wev8.css" />	
<script type="text/javascript">
	document.getElementById('loading-msg').innerHTML = "<%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%>"
	try{
		if(parent.jQuery("#loading")[0].style.display != "none"){
			document.getElementById('loading').style.display = "none";
		}
	}catch(e){}
	try{
		if(parent.parent.jQuery("#loading")[0].style.display != "none"){
			document.getElementById('loading').style.display = "none";
		}
	}catch(e){}
</script>
<SCRIPT LANGUAGE="vbscript">
	dim id
</SCRIPT>

<link rel="stylesheet" type="text/css" href="/css/column-tree_wev8.css" />


<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/build/ux/miframe_wev8.js"></script>
<SCRIPT LANGUAGE="javascript">	
function ExtonReady(){
	Ext.Ajax.timeout=300000;
	Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';
	Ext.useShims = true;
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

	Ext.override(Ext.grid.GridView, {
		templates: {
			cell: new Ext.Template(
						'<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} {css}" style="{style}" tabIndex="0" {cellAttr}>',
						'<div class="x-grid3-cell-inner x-grid3-col-{id}" {attr}>{value}</div>',
						"</td>"
				)
		}
	});
}

var isLoadExt = false;
function loadExt() {
	if(!isLoadExt){
		try {

		//loadFile("/js/extjs/adapter/ext/ext-base_wev8.js","js");

		//loadFile("/js/extjs/ext-all_wev8.js","js");

		loadFile("/js/TabCloseMenu_wev8.js","js");
		
		<%if(language==7) {%>
		loadFile("/js/extjs/build/locale/ext-lang-zh_CN_gbk_wev8.js","js");
		<%} else if(language==8) {%>
		loadFile("/js/extjs/build/locale/ext-lang-en_wev8.js","js");
		<%} else if(language==9) {%>
		loadFile("/js/extjs/build/locale/ext-lang-zh_TW_wev8.js","js");
		<%}%>

		loadFile("/js/ColumnNodeUI_wev8.js","js");

		//loadFile("/js/extjs/build/ux/miframe_wev8.js","js");

		loadFile("/js/Cookies_wev8.js","js");
		
		ExtonReady();
		
		loadFile("/js/doc/DocCommonExt_wev8.js","js");

		isLoadExt = true;

		} catch(e){}
	}
}

function finalDo(mode){
	//需要加上收藏与帮助按钮
	var divContentTabObj=document.getElementById('divContentTab');
	var divFavorite = document.createElement("DIV");
	divFavorite.id="divFavorite";
	//alert("params : "+params);
	divFavorite.innerHTML="<img src='/images/btnFavorite_wev8.gif' style='cursor:hand' onclick=\"openFavouriteBrowser();\" title="+wmsg.base.addToFavorite+">" +
			"&nbsp;<img src='/images/help2_wev8.gif'  style='cursor:hand' onclick='showHelp()' title="+wmsg.base.help+">"; 
	divFavorite.style.position="absolute";
	divFavorite.style.top="8";
	divFavorite.style.right="15";
	jQuery("#divDocTile").append(divFavorite)
	//divContentTabObj.firstChild.appendChild(divFavorite);
	//alert(divContentTabObj.className)
    document.getElementById('loading').style.display="none";
	try{
		parent.jQuery("#loading").hide();
		parent.parent.jQuery("#loading").hide();
	}catch(e){}
}

function showHelp(){
 	var pathKey = window.location.pathname;
    //alert(pathKey);
    if(pathKey!=""){
        pathKey = pathKey.substr(1);
    }
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
    //var operationPage = "http://localhost/help/RemoteHelp.jsp";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
	var isEnableExtranetHelp = <%=isEnableExtranetHelp%>;
    if(isEnableExtranetHelp==1){
    	operationPage = "http://e-cology.com.cn/formmode/apps/ktree/ktreeHelp.jsp";
    }
    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}

jQuery(window).bind('resize', function() {
	adjustContentHeight("resize");
});

function openFavouriteBrowser(){
	var favpagename = setFavPageName();
	var favuri = setFavUri();
	var favquerystring = setFavQueryString();
    jQuery.post("/systeminfo/FavouriteSession.jsp",{pagename:favpagename},function (data) {
        var sessionKey = data.sessionKey;
        window.showModalDialog('/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename='+sessionKey+'&fav_uri='+favuri+'&fav_querystring='+favquerystring+'&mouldID=doc');
    });
}

function loadFile(filePath, type){
	var element=null;
	if (type=="js"){
		element=document.createElement('script')
		element.setAttribute("type","text/javascript")
		element.setAttribute("src", filePath)
	}else if (type=="css"){
		element=document.createElement("link") 
		element.setAttribute("rel", "stylesheet") 
		element.setAttribute("type", "text/css")  
		element.setAttribute("href", filePath) 
	}else{
		return ;
	}
	var eHead=document.getElementsByTagName("head");
	if(eHead!=null)
		eHead[0].appendChild(element) 
}

function getX(element){
	var x=0;
	while(element){
		x=x+element.offsetLeft;
		element=element.offsetParent;
	}
	return x;
}

function getY(element){
	var y=0;
	while(element){
		y=y+element.offsetTop;
		element=element.offsetParent;
	}
	return y;
}

function showPrompt(content){
	 Ext.get('loading').fadeIn();
	 document.getElementById('loading-msg').innerHTML = content;
}

function hiddenPrompt(){
    var showTableDiv  = document.getElementById('loading');
    if(showTableDiv!=null)
    	showTableDiv.style.display="none";
}
</script>
<%
} else if(operation.equals("getDivAcc")){
%>
<div id="DocDivAcc" style="width:100%;height:100%;"></div>
<script type="text/javascript">
var getDivAcc;
function doGetdivAcc(){
	if(!getDivAcc){
		getDivAcc = new Ext.Panel({
			id:'DocDivAccPanel',
			layout:'fit',
            applyTo: 'DocDivAcc',
            monitorResize: true,
			items:[
				DocCommonExt.getDocImgPanel("<%=maxUploadImageSize%>","<%=mode%>","<%=docid%>",true,"<%=bacthDownloadFlag%>")
			]
		});
	}
	getDivAcc.doLayout();
}

function resizedivAcc(){
	Ext.getCmp("DocImgs").setWidth(document.body.clientWidth-1);
	Ext.getCmp("DocImgs").setHeight(156);
	Ext.getCmp("DocDivAccPanel").setWidth(document.body.clientWidth-1);
	Ext.getCmp("DocImgs").syncSize();
	Ext.getCmp("DocDivAccPanel").syncSize();
}
</script>
<% 
} else if(operation.equals("getDivShare")){
%>
	<script type="text/javascript" src="/js/doc/DocShareSnip_wev8.js"></script>
	<div id="DocDivShare" style="width:100%;height:100%;"></div>
	<script type="text/javascript">
	var getDivShare;
	function doGetdivShare(){
		if(!getDivShare){
			getDivShare = new Ext.Panel({
				id:'DocDivSharePanel',
				layout:'fit',
	            applyTo: 'DocDivShare',
	            monitorResize: true,
				items:[
					new DocShareSnip("<%=docid%>","<%=canShare%>").getGrid()
				]
			});
		}
		getDivShare.doLayout();
	}
	function resizedivShare(){
		Ext.getCmp("DocShare").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocShare").setHeight(195);
		Ext.getCmp("DocDivSharePanel").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocShare").syncSize();
		Ext.getCmp("DocDivSharePanel").syncSize();
	}
	</script>
<% 
} else if(operation.equals("getDivMark")){
%>
	<div id="DocDivMark" style="width:100%;height:100%;"></div>
	<script type="text/javascript">
	var getDivMark;
	function doGetdivMark(){
		if(!getDivMark){
			getDivMark = new Ext.Panel({
				id:'DocDivMarkPanel',
				layout:'fit',
	            applyTo: 'DocDivMark',
	            monitorResize: true,
				items:[
					DocCommonExt.getDocMarkPanel()
				]
			});
		}
		getDivMark.doLayout();
	}
	function resizedivMark(){
		Ext.getCmp("docMark").setWidth(document.body.clientWidth-1);
		Ext.getCmp("docMark").setHeight(195);
		Ext.getCmp("DocDivMarkPanel").setWidth(document.body.clientWidth-1);
		Ext.getCmp("docMark").syncSize();
		Ext.getCmp("DocDivMarkPanel").syncSize();
	}
	</script>
<% 
} else if(operation.equals("getDivReplay")){
%>
	<div id="DocDivReplay" style="width:100%;height:100%;"></div>
	<script type="text/javascript">
	var getDivReplay;
	function doGetdivReplay(){
		if(!getDivReplay){
			getDivReplay = new Ext.Panel({
				id:'DocDivReplayPanel',
				layout:'fit',
	            applyTo: 'DocDivReplay',
	            monitorResize: true,
				items:[
					DocCommonExt.getDocReplyPanel()
				]
			});
		}
		getDivReplay.doLayout();
	}
	function resizedivReplay(){
		Ext.getCmp("DocReply").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocReply").setHeight(195);
		Ext.getCmp("DocDivReplayPanel").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocReply").syncSize();
		Ext.getCmp("DocDivReplayPanel").syncSize();
	}
	</script>
<% 
} else if(operation.equals("getDivVer")){
%>
	<div id="DocDivVer" style="width:100%;height:100%;"></div>
	<script type="text/javascript">
	var getDivVer;
	function doGetdivVer(){
		if(!getDivVer){
			getDivVer = new Ext.Panel({
				id:'DocDivVerPanel',
				layout:'fit',
	            applyTo: 'DocDivVer',
	            monitorResize: true,
				items:[
					DocCommonExt.getDocVerPanel()
				]
			});
		}
		getDivVer.doLayout();
	}
	function resizedivVer(){
		Ext.getCmp("DocVersion").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocVersion").setHeight(195);
		Ext.getCmp("DocDivVerPanel").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocVersion").syncSize();
		Ext.getCmp("DocDivVerPanel").syncSize();
	}
	</script>
<% 
} else if(operation.equals("getDivViewLog")){
%>
	<%@ include file="/docs/DocDetailLog.jsp"%>
	<div id="DocDivViewLog" style="width:100%;height:100%;"></div>
	<script type="text/javascript">
	var getDivViewLog;
	function doGetdivViewLog(){
		if(!getDivViewLog){
			getDivViewLog = new Ext.Panel({
				id:'DocDivViewLogPanel',
				layout:'fit',
	            applyTo: 'DocDivViewLog',
	            monitorResize: true,
				items:[
					getDocDetailLogPane(docid,500,300,true)
				]
			});
		}
		getDivViewLog.doLayout();
	}
	function resizedivViewLog(){
		Ext.getCmp("DocDetailLog").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocDetailLog").setHeight(195);
		Ext.getCmp("DocDivViewLogPanel").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocDetailLog").syncSize();
		Ext.getCmp("DocDivViewLogPanel").syncSize();
	}
	</script>
<% 
} else if(operation.equals("getDivRelationResource")){
%>
	<script type="text/javascript" src="/js/doc/DocRelationable_wev8.js"></script>
	<div id="DocDivRelationResource" style="width:100%;height:100%;"></div>
	<script type="text/javascript">
	var getDivRelationResource;
	function doGetdivRelationResource(){
		if(!getDivRelationResource){
			getDivRelationResource = new Ext.Panel({
				id:'DocDivRelationResourcePanel',
				layout:'fit',
	            applyTo: 'DocDivRelationResource',
	            monitorResize: true,
				items:[
					new DocRelationable(docid).getGrid()
				]
			});
		}
		getDivRelationResource.doLayout();
	}
	function resizedivRelationResource(){
		Ext.getCmp("DocRelation").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocRelation").setHeight(195);
		Ext.getCmp("DocDivRelationResourcePanel").setWidth(document.body.clientWidth-1);
		Ext.getCmp("DocRelation").syncSize();
		Ext.getCmp("DocDivRelationResourcePanel").syncSize();
	}
	</script>
<% 
}
%>