<%@page import="com.weaver.formmodel.ui.types.FormUIType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager" %>
<%@ page import="com.weaver.formmodel.mobile.ui.manager.MobileAppFieldManager" %>
<%@ page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager" %>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo" %>
<%@ page import="com.weaver.formmodel.data.manager.FormInfoManager" %>
<%@ page import="com.weaver.formmodel.data.model.Forminfo" %>
<%@ page import="com.weaver.formmodel.mobile.ui.model.AppFieldUI" %>
<%@ page import="com.weaver.formmodel.mobile.ui.model.AppFormUI" %>
<%@ page import="com.weaver.formmodel.mobile.ui.model.AppField" %>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobiledeviceManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.Mobiledevice"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.weaver.formmodel.mobile.dao.MobileAppModelInfoDao"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager"%>
<%@page import="com.weaver.formmodel.mobile.mpc.MPCManager"%>
<%@page import="com.weaver.formmodel.mobile.mpc.model.MPCConfig"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
int subCompanyId=-1;
if(mmdetachable.equals("1")){
	subCompanyId=Util.getIntValue(Util.null2String(session.getAttribute("mobilemode_defaultSubCompanyId")),-1);
    if(subCompanyId == -1){
        subCompanyId = user.getUserSubCompany1();
    }
}
int operatelevel = getCheckRightSubCompanyParam("MobileModeSet:All",user,mmdetachable ,subCompanyId);//权限等级-> 2完全控制 1 编辑 0 只读

MobiledeviceManager mobiledeviceManager = MobiledeviceManager.getInstance();
//手机应用id
int appid=Util.getIntValue(Util.null2String(request.getParameter("appid")),0);
//布局id
int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
String refresh = Util.null2o(request.getParameter("refresh"));
//是否为首页
String ishomepage=Util.null2String(request.getParameter("ishomepage"));
if(ishomepage.equals("1")){
	request.getRequestDispatcher("/mobilemode/appuidesign2.jsp").forward(request, response);
	return;
}
//移动设备id
int mobiledeviceid=Util.getIntValue(Util.null2String(request.getParameter("mobiledeviceid")),0);
//父布局id
int parentid=Util.getIntValue(Util.null2String(request.getParameter("parentid")),id);
//手机模块id
int entityid = 0;
//布局类型
int uiType = 2;
//表单id
int formid=0;

AppFormUI formui = new AppFormUI();
List<AppField> fieldlist=new ArrayList<AppField>();
String content="";
String actionUrl="com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction";
//移动设备html
String devicesHtml="";

MobileAppUIManager mobileAppUIManager = MobileAppUIManager.getInstance();

if(id!=0){
	formui = (AppFormUI)mobileAppUIManager.getById(id);
	appid=formui.getAppid();
	entityid=formui.getEntityId();
	uiType=formui.getUiType();
	formid=formui.getFormId();
	mobiledeviceid=formui.getMobiledeviceid()==null?0:formui.getMobiledeviceid();
	parentid=formui.getParentid()==null?formui.getId():formui.getParentid();
}else if(parentid!=0){
	formui = (AppFormUI)mobileAppUIManager.getById(parentid);
	formui.setId(null);
	appid=formui.getAppid();
	entityid=formui.getEntityId();
	uiType=formui.getUiType();
	formid=formui.getFormId();
}

//如果id和parentid都为空则直接返回（此页面只支持修改和创建其它设备布局）
if(appid==0||entityid==0)return;
MobileAppModelInfo mobileAppModelInfo=MobileAppModelManager.getInstance().getAppModelInfo(entityid);
if(formui.getId() == null ||formui.getId() == 0) {
    String uiContent = mobileAppUIManager.getDefaultTemplate(mobileAppModelInfo.getId(),formid,uiType);
    formui.setUiContent(uiContent);
}
Forminfo forminfo = FormInfoManager.getInstance().getForminfo(formid);
int formlabelId = Util.getIntValue(String.valueOf(forminfo.getNamelabel()),0);
String formlabelName = SystemEnv.getHtmlLabelName(formlabelId,user.getLanguage());
fieldlist = MobileAppFieldManager.getInstance().getAppFieldList(formid,user.getLanguage());
List<AppField> detailfieldlist=new ArrayList<AppField>();
if(uiType!=3){
	detailfieldlist = MobileAppFieldManager.getInstance().getAppDetailFieldList(formid,user.getLanguage());
}
content=formui.getUiContent();
devicesHtml=mobiledeviceManager.getFormUIMobiledevicesHtml(appid,mobiledeviceid,parentid);

Mobiledevice mobiledevice=mobiledeviceManager.getMobiledevice(mobiledeviceid);
int width=mobiledevice.getWidth()==null?345:mobiledevice.getWidth();
int height=mobiledevice.getHeight()==null?460:mobiledevice.getHeight();

List<MPCConfig> mpcConfigList = MPCManager.readMPCConfigs();
JSONArray mpcConfigArr = JSONArray.fromObject(mpcConfigList);

Object[] unPutMPCObj = MPCManager.getUnPutMPC(id, appid, entityid);
int maxMPCNo = (Integer)unPutMPCObj[0];
List<Map<String, String>> unPutMPCList = (List)unPutMPCObj[1];
JSONArray unPutMPCArr = JSONArray.fromObject(unPutMPCList);

String appname = Util.null2String(mobileAppModelInfo.getEntityName());
String pgname = Util.null2String(formui.getUiName());
String titlename = SystemEnv.getHtmlLabelName(81788,user.getLanguage()) + "/" + appname + "/" + pgname;//移动建模 收藏页名称
%>

<!DOCTYPE HTML>
<HEAD>
<script type="text/javascript">
 window.UEDITOR_HOME_URL = "/mobilemode/js/ueditor/";
 $.fn.selectbox = function(){}; //禁用插件美化
</script>
<script type="text/javascript" src="/mobilemode/js/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/ueditor/ueditor.all_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>

<link type="text/css" rel="stylesheet" href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery.ui.all_wev8.css" />
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>

<script type="text/javascript" src="/mobilemode/js/UUID_wev8.js"></script>

<style>
*{
	font-family: 'Microsoft Yahei', Arial;
}
.metro {
  border: 0px #ccc solid;
  margin: 0 0 0 0;
  padding-top: 3px;
  height: 107px;
  position: fixed;
  background-color: #eee;
  width:100%;
  z-index:100;
}
.mobiledevice{
	width:40px;text-align:center;float:left;background-color:#fff;padding: 3px;line-height:14px;cursor:pointer;
	opacity: 0.3;
}
.mobiledeviceActive{
	background-color:#efefef !important;
}
.mobiledeviceImg{
	width:32px;
}
.mobiledeviceDesigned{
	opacity: 1;
}
#div_htmlresource{
	position:absolute;
	width:100%;
	top:110px;
}
#content{
	position:relative;
	top: 110px;
}
.td_ruler_x{
	height:18px;
	
}
.ruler_x{
	border-top: 0px solid #aaa;
	display:block;
	height:19px;
	width:2000px;
	background:url(images/ruler_x_wev8.png) no-repeat;
	position:fixed;
	top:103px;
	z-index:100;
}
.ruler_y{
	width:18px;
	height: 883px;
	background:url(images/ruler_y_wev8.png) no-repeat;
}
.main_content{
	background:url(images/dot_wev8.png);
	height:1000px;
}
<%
if(2==mobiledeviceid){
%>
.content_left{
	height:100%;
	margin-top:50px;
	margin-left:50px;
	background:url('/mobilemode/images/ipad_wev8.png') no-repeat;
}
.content_editor{
	float:left;margin-bottom:0px;margin-left:58px;margin-top:33px;border:0px solid #F00;
}
<%}else{%>
.content_left{
	height:100%;
	margin-top:50px;
	margin-left:50px;
	background:url('/mobilemode/images/iphone5_wev8.png') no-repeat;
}
.content_editor{
	float:left;margin-bottom:0px;margin-left:38px;margin-top:133px;border:0px solid #F00;
}
<%}%>

#edui1{
	z-index:99 !important;
}
</style>
<style>
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
.label {
border:0;
border-bottom:1 solid black;
background:;
}
#main {
 float: left;
 height: auto;
 width: auto;
 border: 1px solid #FF0000;
}
#right {
 float: left;
 height: 400px;
 width: 300px;
 border: 1px solid #0000FF;
}

.ui-corner-all, .ui-corner-bottom, .ui-corner-right, .ui-corner-br {
	border-bottom-right-radius: 0px/*{cornerRadius}*/;
}
.ui-corner-all, .ui-corner-bottom, .ui-corner-left, .ui-corner-bl {
	border-bottom-left-radius: 0px/*{cornerRadius}*/;
}
.ui-corner-all, .ui-corner-top, .ui-corner-left, .ui-corner-tl {
	border-top-left-radius: 0px/*{cornerRadius}*/;
}
.ui-corner-all, .ui-corner-top, .ui-corner-right, .ui-corner-tr {
	border-top-right-radius: 0px/*{cornerRadius}*/;
}
.ui-widget-header{
	background: none;
	border-top: none;
	border-left: none;
	border-right: none;
}
.ui-widget-content{
	border-top: none;
	border-left: none;
	border-right: none;
	border-bottom: none;
	background-color: #fff;
}
.ui-widget-content .ui-state-default{
	background-image: none;
	background-color: #eee;
}
.ui-widget-content .ui-state-active{
	background-image: none;
	background-color: #fff;
}
.ui-widget-content .ui-state-active A{
	color: #0072c6;
}
.ui-tabs{
	padding-top: 0;
	padding-left: 0;
	padding-right: 0;
	height: 97px;
}
.ui-tabs .ui-tabs-nav{
	padding: 2px 5px 0 2px;
	background-color: #eee;
}
.ui-tabs .ui-tabs-nav LI A{
	padding: 3px 10px;
	font-family: 'Microsoft Yahei', Arial;
	font-weight: bold;
}
</style>
<style type="text/css">
#draggable{
	margin-bottom:0px;
	margin-left: 445px;
	font-size:9pt;
	width:350px;
	height:310px;
	vertical-align:top;
	position: fixed;
	top: 150px;
	z-index: 999;
}
#draggable_title{
	background-color:#738fa3;
	font-size: 14px;
	color: #fff;
	padding: 0;
}
#draggable_center{
	background-color:#fff;
	border:1px solid #ddd;
	border-top: none;
	padding: 8px;
}

.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 0;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #999;
	font-size: 10px;
}
#draggable td{
	font-family: 'Microsoft Yahei', Arial;
	font-size: 12px;
}
#draggable td input, #draggable td select{
	font-family: 'Microsoft Yahei', Arial;
	font-size: 12px;
	width: 100%;
}
#draggable td select{
	font-size: 11px;
	width: 100%;
}
</style>
<style>
	.homepage_head{
		height:200px;
		width:100%;
	}
	
	.homepage_content{
		width:100%;
		border-collapse:collapse;
		background-color:#F3F3F3;
	}
	
	.homepage_content tr{
		height:55px;
		line-height:55px;
		cursor:pointer;
		border-bottom:1px solid #AAAAAA;
	}
	
	.homepage_content img{
		width:55px;
		height:55px;
		border:0;
	}
	</style>
<script type="text/javascript">
if('<%=refresh%>'=='1'){
	window.parent.leftFrame.MobileUI.refreshData();
}
</script>
<script>
var MPCConfigArr = <%=mpcConfigArr%>;
var unPutMPCArr = <%=unPutMPCArr%>;
var operatelevel = <%=operatelevel%>;

var _uiType = <%=uiType%>;
var mpcNo = <%=maxMPCNo%>;

$(document).ready(function () {
	for(var i = 0; i < unPutMPCArr.length; i++){
		var unPutMPC = unPutMPCArr[i];
		var id = unPutMPC["mpc_id"];
		var type = unPutMPC["mpc_type"];
		var mpcNo = unPutMPC["mpc_no"];
		var htm = createMPCDesignHtml(id, type, mpcNo);
		
		var $unPutMPCEntry = $("<span class=\"unPutMPCEntry\"></span>");
		$unPutMPCEntry.append(htm);
		
		$("#unPutMPCContainer").append($unPutMPCEntry);
		
		$unPutMPCEntry.click(function(){
			ue.execCommand("inserthtml", $(this).html());
			$(this).remove();
		});
	}
	var $unPutMPCTR = $("#unPutMPCTR");
	unPutMPCArr.length > 0 ? $unPutMPCTR.show() : $unPutMPCTR.hide();
});

function writeMobilePrimaryComponent(type){
	if(_uiType == 3){return;}
	if(_uiType == 1){
		//显示布局无法添加原生控件，请在页面右侧的窗体中选择新建或编辑布局中已添加的原生控件。
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127822,user.getLanguage())%><br/><%=SystemEnv.getHtmlLabelName(127823,user.getLanguage())%>",null,400);   
		return;
	}
	var id = new UUID().toString();
	++mpcNo;
	var htm = createMPCDesignHtml(id, type, mpcNo);
	ue.execCommand("inserthtml", htm);
}

function createMPCDesignHtml(mpc_id, mpc_type, mpc_no){
	var mpcConfig = getMPCConfigByType(mpc_type);
	var htm = "<abbr id=\""+mpc_id+"\" mpc=\"true\" mpc_type=\""+mpc_type+"\" mpc_no=\""+mpc_no+"\" style=\"position: relative;display: inline-block;padding: 0px 5px 0px 3px;\">"
			+ "<img src=\""+mpcConfig["icon"]+"\" align=\"middle\" style=\"width:24px;\"></img>"
			+ "<span style=\"position: absolute;top:0px;right:0px;display: inline-block;background-color:red;width:14px;height:14px;text-align: center;font-family: arial;font-size: 11px;color: #FFFFFF;border-radius: 15px;line-height: 14px;overflow: hidden;font-weight: bold;\">"+mpc_no+"</span>"
			+ "</abbr>";
	return htm;
}

function getMPCConfigByType(type){
	for(var i = 0; i < MPCConfigArr.length; i++){
		var mpcConfig = MPCConfigArr[i];
		if(mpcConfig["type"] == type){
			return mpcConfig;
		}
	}
	return null;
}

function onSave(){
	//if(check_form(frmMain,"uiname,uiType")){
		if(operatelevel < 1) return;
		enableAllmenu();
		$(".loading").show();
		var content = ue.getContent();
		document.getElementById("uicontent").value = content;
		document.frmMain.action = jionActionUrl("<%=actionUrl%>", "action=save");
		document.frmMain.submit();
	//}
}

function onInitContent(){
	if(_uiType == "3"){// 模块列表
		formUIListInit();
	}else{
		formUIInit();
	}
}

// 模块页面初始化
function formUIInit(){
	enableAllmenu();
	$(".loading").show();
	var content = ue.getContent();
	document.frmMain.action = jionActionUrl("<%=actionUrl%>", "action=initContent");
	document.frmMain.submit();
}

function doInitContent(){
	var initDlg = top.createTopDialog();//定义Dialog对象
	initDlg.Model = true;
	initDlg.Width = 720;//定义长度
	initDlg.Height = 350;
	initDlg.URL = "/mobilemode/appHomepageInit.jsp?templateType=formuilist&id="+<%=id%>;
	initDlg.Title = "<%=SystemEnv.getHtmlLabelName(127503,user.getLanguage())%>";  //初始化页面
	initDlg.show();
	initDlg.onCloseCallbackFn=function(result){
		enableAllmenu();
		refresh();
	};
}

// 模块列表初始化
function formUIListInit(){
	rightMenu.style.visibility = "hidden";
	var $MEC_Design_Container = $("#MEC_Design_Container");
	if($MEC_Design_Container.children().length == 0){
		doInitContent();
	}else{
		//初始化会使用选择的模板内容覆盖当前页面的内容。<br/>确定继续吗？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(127824,user.getLanguage())%><br/><%=SystemEnv.getHtmlLabelName(127825,user.getLanguage())%>",function(){
			doInitContent();
		},function(){});
	}
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(127519,user.getLanguage())%>")) {   //你确定要删除此布局吗?
		enableAllmenu();
		$(".loading").show();
		document.frmMain.action = jionActionUrl("<%=actionUrl%>", "action=delete");
		document.frmMain.submit();
	}
}
function onPreview(){
	rightMenu.style.visibility = "hidden";
	var url="/mobilemode/preview.jsp?appid=<%=appid%>&uiid=<%=id%>";
	<%if(mobiledeviceid == 2){%>
		url += "&clienttype=ipad";
	<%}%>
	window.open(url);
}

$(document).ready(function () {
	$("#tabs").tabs({heightStyle:"fill",active:0});
	$( "#draggable" ).draggable({ containment: "#content",cursor:"move",handle:"#draggable_title"});
	
	//最小化
	$( "#button" ).click(function() {
		runEffect();
	});
	
	$("#div_htmlresource").height($(window).height()-110);
	
	$("#mobiledevices").html("<%=devicesHtml%>");
	$(".metro").show();
	$(".loading").hide();
});

function runEffect() {
	var selectedEffect = "blind";
	var options = {};
	if($("#draggable_center").is(":hidden")){
		$( "#draggable_center").show( selectedEffect, options, 100);
		$( "#button").attr("src","images/arrowdown_wev8.png");
	}else{
		$( "#draggable_center").hide( selectedEffect, options, 100);
		$( "#button").attr("src","images/arrowright_wev8.png");
	}
}
</script>
<style type="text/css">
#unPutMPCContainer{
	padding: 4px 10px 4px 10px;
	height: 32px;
	overflow-y: auto; 
}
#unPutMPCContainer .unPutMPCEntry{
	display: inline-block;
	padding: 3px 1px 3px 3px;
	margin: 0px;
	cursor: pointer;
}
#unPutMPCContainer .unPutMPCEntry:HOVER {
	background-color: #eee;
}
</style>
</HEAD>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(operatelevel > 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
    
    if(id > 0) {
    	if(operatelevel > 0){
	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+SystemEnv.getHtmlLabelName(33368,user.getLanguage())+",javascript:onInitContent(),_self} ";  //内容
	    	RCMenuHeight += RCMenuHeightStep ;
    	}
    	if(FormUIType.getLayoutType(uiType)==FormUIType.UI_TYPE_ADD||FormUIType.getLayoutType(uiType)==FormUIType.UI_TYPE_LIST){
    		RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javaScript:onPreview(),_self} " ;
        	RCMenuHeight += RCMenuHeightStep;
    	}
    	if(operatelevel > 0){
	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage())+",javascript:onDelete(),_self} ";  //布局
	    	RCMenuHeight += RCMenuHeightStep ;
    	}
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<div class="loading">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(23278, user.getLanguage())%></span>
</div>
<div class="metro" style="display:none;">
	<div id="tabs">
		<ul>
			<li><a href="#tabs-2"><%=SystemEnv.getHtmlLabelName(127520, user.getLanguage())%><!-- 布局设计器 --></a></li>
		</ul>
		<div id="tabs-2" style="font-family:'Microsoft Yahei', Arial;font-size:11px;padding:8px 8px 0 8px;">
			<div style="border-right: 1px solid #ccc;">
				<div onclick="javascript:onSave();" style="<%if(operatelevel < 1){%>color:#999;cursor:not-allowed !important;<%}%>width: 40px;text-align:center;float:left;background-color:#fff;padding: 3px;line-height:14px;cursor:pointer;">
				<img src="images/toolbar/t04_wev8.png" style="width:32px;"/>
				<br/>
				<span><%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%><!-- 保存 --></span>
				</div>
				<div onclick="javascript:refresh();" style="width: 40px;text-align:center;float:left;background-color:#fff;padding: 3px;line-height:14px;cursor:pointer;">
				<img src="images/toolbar/t05_wev8.png" style="width:32px;"/>
				<br/>
				<span><%=SystemEnv.getHtmlLabelName(354, user.getLanguage())%><!-- 刷新 --></span>
				</div>
				<div onclick="javascript:toggleDesignerSize();" style="width: 40px;text-align:center;float:left;background-color:#fff;padding: 3px;line-height:14px;cursor:pointer;">
				<img id="imgToggle" src="images/toolbar/t09_wev8.png" style="width:32px;"/>
				<br/>
				<span><%=SystemEnv.getHtmlLabelName(127728, user.getLanguage())%><!-- 最大化 --></span>
				</div>
			</div>
			<div style="background-color:#ccc;height:55px;width:1px;float:left;margin:0 5px;"></div>
			<div style="float:left;width:440px;" class="edui-editor-toolbarbox edui-default" id="toolbarbox">
			</div>
			<div style="background-color:#ccc;height:55px;width:1px;float:left;margin:0 5px;"></div>
			<div style="float:left;">
				<div onclick="javascript:source();" style="width: 40px;text-align:center;float:left;background-color:;padding: 3px;line-height:14px;cursor:pointer;">
				<img src="images/toolbar/t06_wev8.png" style="width:32px;"/>
				<br/>
				<span><%=SystemEnv.getHtmlLabelName(127521, user.getLanguage())%><!-- 源码 --></span>
				</div>
			</div>
			
			<div style="background-color:#ccc;height:55px;width:1px;float:left;margin:0 5px;"></div>
			<div id="mobiledevices">
				
			</div>
		</div>
	</div>
</div>
<div id="div_htmlresource"></div>
<FORM id=weaver name=frmMain method=post target="_self" >
<div class="ruler_x"></div>
<div id="content">
	<table width="100%" height="100%">
		<tr>
			<td class="ruler_y"><div style="display:block;width:18px;"></div></td>
			<td class="main_content">
		    	<div class="content_left">
			    	<div class="content_editor" style="width:<%=width%>px; height:<%=height%>px;">
		             	<script id="editor" type="text/plain" style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;"></script>
		            </div>
		            <div id="draggable">
			        	
			        	<div id="draggable_title"><img id="button" src="images/arrowdown_wev8.png" style="width:16px;margin:5px 0px 5px 8px;vertical-align:middle;"/> <%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%><!-- 属性 --></div>
			        	
			        	<div id="draggable_center">
			        		<table  class="e8_tblForm">
			        			<tr>
			        				<td class="e8_tblForm_label" width="30"><%=SystemEnv.getHtmlLabelName(84276,user.getLanguage())%><!-- 名称 --></td>
			        				<td class="e8_tblForm_field"><input id="uiname" name="uiname" value="<%=Util.null2String(formui.getUiName()) %>"/></td>
			        			</tr>
			        			<tr>
			        				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%><!-- 类型 --></td>
			        				<td class="e8_tblForm_field">
			        					<%
				        				switch(uiType){
					        				case 0:
					        					%><%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%><!-- 新建 --><%
					        					break;
					        				case 1:
					        					%><%=SystemEnv.getHtmlLabelName(127791,user.getLanguage())%><!-- 显示 --><%
					        					break;
					        				case 2:
					        					%><%=SystemEnv.getHtmlLabelName(126036,user.getLanguage())%><!-- 编辑 --><%
					        					break;
					        				case 3:
					        					%><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%><!-- 列表 --><%
					        					break;
				        				}
				        				%>
			        				</td>
			        			</tr>
			        			<tr>
			        				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(83842,user.getLanguage())%><!-- 字段 --><br/><span class="e8_label_desc"></span></td>
			        				<td class="e8_tblForm_field">
			        					<select size="10" ondblclick="javascript:addFieldlabel(this)" id="fieldlist" style="height:210px;">
								            <%for(AppField appfield : fieldlist){
								            	%>
								            	<option value="<%=appfield.getNamespace() %>" 
								            	formid="<%=appfield.getFormid() %>" 
								            	htmltype="<%=appfield.getHtmlType()%>"
								            	fieldtype="<%=appfield.getFieldtype() %>"
								            	fieldid="<%=appfield.getFieldid() %>"
								            	fielddesc="<%=appfield.getFieldDesc()%>">
								            	<%=appfield.getFieldDesc() %> (<%=appfield.getFieldName() %>)
								            	</option>
								            	<%
								            }
								            for(AppField appfield : detailfieldlist){
								            %>
								            	<option value="<%=appfield.getNamespace() %>" 
								            	formid="<%=appfield.getFormid() %>" 
								            	htmltype="<%=appfield.getHtmlType()%>"
								            	fieldtype="<%=appfield.getFieldtype() %>"
								            	fieldid="<%=appfield.getFieldid() %>"
								            	fielddesc="<%=appfield.getFieldDesc()%>">
								            	<%=appfield.getFieldDesc() %> (<%=appfield.getFieldName() %>)
								            	</option>
								            	<%
								            }
								            %>
								       </select>
						            	<div style="padding:2px;display:none;">
						            		<%=SystemEnv.getHtmlLabelName(127818,user.getLanguage())%><!-- 字段样式: -->
								            <select id="showtype" name="showtype">
								            <option value="2"><%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%></option> <!-- 可编辑 -->
								            <option value="1"><%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></option> <!-- 只读 -->
								            <option value="0"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%></option> <!-- 隐藏 -->
								            <option value="3"><%=SystemEnv.getHtmlLabelName(30036,user.getLanguage())%></option> <!-- 必填 -->
								            <option value="4"><%=SystemEnv.getHtmlLabelName(127819,user.getLanguage())%></option> <!-- 可查询 -->
								            </select>
						            	</div>
			        				</td>
			        			</tr>
			        			<tr id="unPutMPCTR">
			        				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127820,user.getLanguage())%><!-- 原生控件 --></td>
			        				<td class="e8_tblForm_field">
			        					<div style="background-color: #fff">
			        						<div style="color:#ccc;font-size: 11px;padding: 2px 0px 2px 10px;border-bottom: 1px dotted #ccc;"><%=SystemEnv.getHtmlLabelName(127821,user.getLanguage())%><!-- 以下为其它布局已添加但当前布局不存在的控件 --></div>
			        						<div id="unPutMPCContainer">
			        						</div>
			        					</div>
			        				</td>
			        		</table>
			            </div>
			        </div>
		    	</div>
			</td>
		</tr>
	</table>
</div>
	<input type=hidden name=appid id="appid" value="<%=appid%>">
	<input type=hidden name=id id="id" value="<%=id%>">
	<input type=hidden name=entityId id="entityId" value="<%=entityid%>">
	<input type=hidden name=formid id="formid" value="<%=formid%>">
	<input type=hidden name=uicontent id="uicontent">
	<input type="hidden" name="mobiledeviceid" id="mobiledeviceid" value="<%=mobiledeviceid%>"/>
	<input type="hidden" name="parentid" id="parentid" value="<%=parentid%>"/>
	<input type="hidden" name="uiType" id="uiType" value="<%=uiType%>"/>
</form>
	<div style="display:none" id="editorcontent"><%=Util.null2String(content)%></div>
 </body>
<script type="text/javascript">
	var lang = UE.I18N['zh-cn'].contextMenu;
	
	var ue = UE.getEditor('editor',{
            	toolbars:[[
            	//'fullscreen', 'source', '|', 
            	'undo', 'redo', '|',
                'bold', 'italic', 'underline', 'fontborder', 'strikethrough', 'superscript', 'subscript', 'removeformat', 'formatmatch', 'autotypeset', 'blockquote', 'pasteplain', '|', 'forecolor', 'backcolor',  
                //'insertorderedlist', 'insertunorderedlist',// 'selectall', 'cleardoc', '|',
                //'rowspacingtop', 'rowspacingbottom', 'lineheight', '|',
                'customstyle', 'paragraph', 
                'fontfamily', 'fontsize', '|',
                //'directionalityltr', 'directionalityrtl', 'indent',// '|'
                //'justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|', 'touppercase', 'tolowercase', '|',
                //'link', 'unlink', 'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',
                'insertimage'//, 'emotion', 'scrawl', 'insertvideo', 'music', 'attachment', 'map', 'gmap', 'insertframe','insertcode', 'webapp', 'pagebreak', 'template', 'background', '|',
                //'horizontal', 'date', 'time', 'spechars', 'snapscreen', 'wordimage', '|',
                //'inserttable', 'deletetable', 'insertparagraphbeforetable', 'insertrow', 'deleterow', 'insertcol', 'deletecol', 'mergecells', 'mergeright', 
                //'mergedown', 'splittocells', 'splittorows', 'splittocols', '|',
                //'print', 'preview', 'searchreplace', 'help'
              ]],
              imageUrl:jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUploadAction", "action=image"),
              imagePath:"",
              savePath: ['upload1'],
              allowDivTransToP: false,
              contextMenu:[
                {
                    group:lang.table,
                    icon:'table',
                    subMenu:[
                        {
                            label:lang.inserttable,
                            cmdName:'inserttable'
                        },
                        {
                            label:lang.deletetable,
                            cmdName:'deletetable'
                        },
                        '-',
                        {
                            label:lang.deleterow,
                            cmdName:'deleterow'
                        },
                        {
                            label:lang.deletecol,
                            cmdName:'deletecol'
                        },
                        {
                            label:lang.insertcol,
                            cmdName:'insertcol'
                        },
                        {
                            label:lang.insertcolnext,
                            cmdName:'insertcolnext'
                        },
                        {
                            label:lang.insertrow,
                            cmdName:'insertrow'
                        },
                        {
                            label:lang.insertrownext,
                            cmdName:'insertrownext'
                        },
                        '-',
                        {
                            label:lang.insertcaption,
                            cmdName:'insertcaption'
                        },
                        {
                            label:lang.deletecaption,
                            cmdName:'deletecaption'
                        },
                        {
                            label:lang.inserttitle,
                            cmdName:'inserttitle'
                        },
                        {
                            label:lang.deletetitle,
                            cmdName:'deletetitle'
                        },
                        {
                            label:lang.inserttitlecol,
                            cmdName:'inserttitlecol'
                        },
                        {
                            label:lang.deletetitlecol,
                            cmdName:'deletetitlecol'
                        },
                        '-',
                        {
                            label:lang.mergecells,
                            cmdName:'mergecells'
                        },
                        {
                            label:lang.mergeright,
                            cmdName:'mergeright'
                        },
                        {
                            label:lang.mergedown,
                            cmdName:'mergedown'
                        },
                        '-',
                        {
                            label:lang.splittorows,
                            cmdName:'splittorows'
                        },
                        {
                            label:lang.splittocols,
                            cmdName:'splittocols'
                        },
                        {
                            label:lang.splittocells,
                            cmdName:'splittocells'
                        },
                        '-',
                        {
                            label:lang.averageDiseRow,
                            cmdName:'averagedistributerow'
                        },
                        {
                            label:lang.averageDisCol,
                            cmdName:'averagedistributecol'
                        },
                        '-',
                        {
                            label:lang.edittd,
                            cmdName:'edittd',
                            exec:function () {
                                if ( UE.ui['edittd'] ) {
                                    new UE.ui['edittd']( this );
                                }
                                this.getDialog('edittd').open();
                            }
                        },
                        {
                            label:lang.edittable,
                            cmdName:'edittable',
                            exec:function () {
                                if ( UE.ui['edittable'] ) {
                                    new UE.ui['edittable']( this );
                                }
                                this.getDialog('edittable').open();
                            }
                        },
                        {
                            label:lang.setbordervisible,
                            cmdName:'setbordervisible'
                        }
                    ]
                },
                '-'
                <%if(uiType!=3){%>
                ,
                {
                	group:'<%=SystemEnv.getHtmlLabelName(82113,user.getLanguage())%>',  //字段属性
                    subMenu:[
                    <%if(uiType!=1){%>
                        {
			                label:'<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>',       // 可编辑   显示的名称 
			                cmdName:'selectall',//执行的command命令，当点击这个右键菜单时
			                exec:function () {
			            		setFieldAttr(2);
			                }
			            },
			            <%}%>
			            {
			                label:'<%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>',       // 只读    显示的名称
			                cmdName:'selectall',//执行的command命令，当点击这个右键菜单时
			                exec:function () {
			            		setFieldAttr(1);
			                }
			            },
			            {
			                label:'<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>',       //  隐藏    显示的名称   
			                cmdName:'selectall',//执行的command命令，当点击这个右键菜单时
			                exec:function () {
			            		setFieldAttr(0);
			                }
			            }
			            <%if(uiType!=1){%>
			            ,
			            {
			                label:'<%=SystemEnv.getHtmlLabelName(30036,user.getLanguage())%>',       //  必填    显示的名称
			                cmdName:'selectall',//执行的command命令，当点击这个右键菜单时
			                exec:function () {
			            		setFieldAttr(3);
			                }
			            }
			            <%}%>
			            ]
                   	}
                   	<%}%>
		        ]
            });
            ue.addListener( 'ready', function( editor ) {
     			document.getElementById("toolbarbox").innerHTML = document.getElementById("edui1_toolbarbox").innerHTML;
				document.getElementById("edui1_toolbarbox").innerHTML = '';
				
				var editorcontent = document.getElementById("editorcontent").innerHTML;
				ue.setContent(editorcontent);
				$("#editor").height(<%=height+27%>);
 			} );
            
    function isControlSelected(tag){
		if (tag){
			if (ue.document.selection.type == "Control") {
				var oControlRange = ue.document.selection.createRange();
				if (oControlRange(0).tagName.toUpperCase() == tag) {
					return true;
				}	
			} else {
				
			}
		}
		return false;
	}
    function selectit() {
    	document.getElementById("showtype").style.display = 'none';
    	var selectedRange	= ue.document.selection.createRange();
		for (var i=0; i<selectedRange.length; i++){
			var objReference = selectedRange.item(i);
			var fieldid = objReference.id;
			var formid = objReference.name;
			var showtype = objReference.showtype;
			document.getElementById("fieldlist").value = formid;
			document.getElementById("showtype").value = showtype;
		}
    }
    function onInitLayout() {
        var uiType = document.getElementById("uiType").value;
        this.location.replace('/mobilemode/appuidesign.jsp?appid=<%=appid%>&entityid=<%=entityid%>&uitype='+uiType);
    }
</script>
<script type="text/javascript">
function addFieldlabel(obj){
	var item = obj.options.item(obj.selectedIndex);
	var fieldtext = item.text;
	var labelid = obj.value;
	var formid = item.getAttribute("formid");
	var fieldid = item.getAttribute("fieldid");
	var htmltype = item.getAttribute("htmltype");
	var fieldtype = item.getAttribute("fieldtype");
	var showtypeObj = document.getElementById("showtype");
	var uiTypeObj = document.getElementById("uiType");
	var showtypeitem = showtypeObj.options.item(showtypeObj.selectedIndex);
	var uiType = uiTypeObj.value;
	var showtypetext = showtypeitem.text;
	var showtype = showtypeObj.value;
	var labelhtml = "<input fieldid=\""+fieldid+"\" spacename=\""+labelid+"\" htmltype =\""+htmltype+"\" fieldtype=\""+fieldtype+"\" formid=\""+formid+"\" class=\"label\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" showtype=\""+showtype+"\" value=\"["+showtypetext+"]"+fieldtext+"\">";
	
	var content = ue.getContent();
	if(uiType ==3 || content.indexOf("fieldid=\""+fieldid+"\"") == -1) {
		ue.execCommand("inserthtml",labelhtml);
	} else {
		alert('<%=SystemEnv.getHtmlLabelName(83842,user.getLanguage())%> ' + fieldtext + ' <%=SystemEnv.getHtmlLabelName(127826,user.getLanguage())%>');   //字段    已存在!
	}
}

/**
 * 设置字段属性
 */
function setFieldAttr(showtype){
	var selection=ue.selection;
	var element=$(selection.getStart());
	if(element.is("input")){
		var elementShowtype=element.attr("showtype");
		if(elementShowtype!=showtype){
			element.attr("showtype",showtype);
			var showtypeText=$("#showtype option[value="+showtype+"]").text();
			var fieldId=element.attr("fieldid");
			var fieldText=$("#fieldlist option[fieldid="+fieldId+"]").attr("fielddesc");
			element.attr("value","["+showtypeText+"]"+fieldText);
		}
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(127827,user.getLanguage())%>");  //请选中字段!
	}
}

/**
 * 获取编辑器内容
 */
function getContent(){
	var content=ue.getContent();
	$("#content").hide();
	$("#div_htmlresource").show();
	$("#htmlresource").val(content);
}

/**
 * 加粗
 */
function bold(){
	ue.execCommand("bold");
}

/**
 * 撤销
 */
function undo(){
	ue.execCommand("undo");
}

/**
 * 重做
 */
function redo(){
	ue.execCommand("redo");
}

/**
 * 刷新
 */
function refresh(){
	window.location.reload();
}

var sourceEditor="textarea";
/**
 * 源码
 */
function source(){
	var sourceState=ue.queryCommandState("source");
	if(sourceState==0){
		ue.execCommand("source");
		var area=null;
		var len=$("#edui1_iframeholder div.CodeMirror").length;
		if(len==0){
			area=$("#edui1_iframeholder textarea:first");
		}else{
			area=$("#edui1_iframeholder div.CodeMirror");
			sourceEditor="codemirror";
		}
		area.appendTo($("#div_htmlresource"));
		$("#content").hide();
		$(".ruler_x").hide();
	}else if(sourceState==1){
		var area=null;
		if(sourceEditor=="textarea"){
			area=$("#div_htmlresource textarea:first");
		}else{
			area=$("#div_htmlresource div.CodeMirror");
		}
		area.appendTo($("#edui1_iframeholder"));
		$("#content").show();
		$(".ruler_x").show();
		ue.execCommand("source");
	}
}

var mobiledeviceDlg;
function createMobiledevice(id){
	mobiledeviceDlg = top.createTopDialog();//定义Dialog对象
	mobiledeviceDlg.Model = true;
	mobiledeviceDlg.Width = 500;//定义长度
	mobiledeviceDlg.Height = 350;
	if(typeof(id)=='undefined'){
		id="";
	}
	mobiledeviceDlg.URL = "/mobilemode/mobiledevice.jsp?id="+id;
	mobiledeviceDlg.Title = "<%=SystemEnv.getHtmlLabelName(127542,user.getLanguage())%>";  //移动设备
	mobiledeviceDlg.onCloseCallbackFn=function(result){
		refreshMobiledevices();
	}
	mobiledeviceDlg.show();
}

//刷新移动设备html
function refreshMobiledevices(){
	var mobiledeviceid=$("#mobiledeviceid").val();
	var parentid=$("#parentid").val();
	var appid=$("#appid").val();
	var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobiledeviceAction", "action=getDevicesHtml");
	FormmodeUtil.doAjaxDataSave(url,{"appid":appid,"mobiledeviceid":mobiledeviceid,"parentid":parentid}, function(devicesHtml){
		$("#mobiledevices").html(devicesHtml);
	});
}

//打开具体移动设备设计页面
function openUIDesign(id,parentid,mobiledeviceid){
	var url = 'appuidesign.jsp?id='+id+"&parentid="+parentid+"&mobiledeviceid="+mobiledeviceid+"&ishomepage=<%=ishomepage%>";
	location.href=url;
}
//最大化编辑器
function toggleDesignerSize(){
	var $topDoc=$(getTopDoc());
	if($("#imgToggle").attr("src").indexOf("t09_wev8.png")>=0){
		$topDoc.find("#headTable").height(0);
		$topDoc.find("#headTable").closest("tr").hide();
		$topDoc.find("#leftmenuTD").hide();
		$topDoc.find(".e8_leftToggle").hide();
		top.setFrameHeight();
		window.parent.Ext.getCmp("leftPanelModelTree").collapse(false);
		$("#imgToggle").attr("src", "images/toolbar/t10_wev8.png");
	}else{
		$topDoc.find("#headTable").height(90);
		$topDoc.find("#headTable").closest("tr").show();
		$topDoc.find("#leftmenuTD").show();
		$topDoc.find(".e8_leftToggle").show();
		top.setFrameHeight();
		window.parent.Ext.getCmp("leftPanelModelTree").expand(false);
		$("#imgToggle").attr("src", "images/toolbar/t09_wev8.png");
	}
}

function getTopDoc(){
	return top.window.document;
}
</script>
</html>