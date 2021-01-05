<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.*"%>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant"%>
<%@ page import="weaver.formmode.FormModeConfig"%>
<%@ include file="/formmode/pub.jsp"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%

int zzCount = 5;//柱状显示数量
int bzCount = 3;//饼状显示数量
int appId = Util.getIntValue(request.getParameter("modelId"), 0);
AppInfoService appInfoService = new AppInfoService();
Map<String, Object> appInfo = appInfoService.getAppInfoById(appId);

String userRightStr = "FORMMODEAPP:ALL";
int subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subCompanyId")),-1);
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,subCompanyId,"",request,response,session);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
String subCompanyId2 = ""+subCompanyId;
int currentSubCompanyId = Util.getIntValue(Util.null2String(rightMap.get("currentSubCompanyId")),-1);

List<Map<String, Object>> appCountInfoList = appInfoService.getAppCountInfo(appId, zzCount);
String appCountInfoSumArray = appInfoService.getAppCountInfoSum(appId, bzCount);
String treeFieldName = Util.null2String(appInfo.get("treefieldname"));
String treeFieldDesc = Util.null2String(appInfo.get("treefielddesc"));
float showOrder = Util.getFloatValue(Util.null2String(appInfo.get("showorder")), 0.0f);
String superFieldId = Util.null2String(appInfo.get("superfieldid"));
int level = Util.getIntValue(Util.null2String(appInfo.get("treelevel")), 0);
int childappcount = Util.getIntValue(Util.null2String(appInfo.get("childappcount")), 0);
boolean isAllDeleteForChildApp = false;
if(childappcount > 0) {
	isAllDeleteForChildApp = appInfoService.checkChildAppIsAllDelete(appId);
}
FormModeConfig formModeConfig = new FormModeConfig();
String titlename=SystemEnv.getHtmlLabelName(25432,user.getLanguage())+" / " + treeFieldName +" / "+SystemEnv.getHtmlLabelName(81990,user.getLanguage());//应用    基础
if(appId==1){//根不控制
	operatelevel = 2;
}
%>
<html>
<head>
	<title></title>
	<!-- 
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> -->
	<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>
	<script src="/formmode/js/amcharts/amcharts_wev8.js" type="text/javascript"></script>
    <script src="/formmode/js/amcharts/pie_wev8.js" type="text/javascript"></script>
	<style>
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
	}
	*{
		font: 12px Microsoft YaHei;
	}
	ul{
		list-style: none;
		margin: 0px;
		padding: 0px;
	}
	.e8_tblForm{
		width: 511px;
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
		vertical-align: top;
	}
	.e8_label_desc{
		color: #aaa;
	}
	
	#appTable{
		width: 100%;
		height: 100%;
	}
	#appTable td{
		vertical-align: top;
	}
	#appPart2TD{
		background: url("/formmode/images/border_e9e9e9_wev8.png") no-repeat;
		background-position: right 15px;
	}
	
	.appPart{
		height: 100%;
		padding-top: 15px;
	}
	#appPart1{
		width: 530px;
	}
	#appPart2{
		width: 280px;
	}
	#appPart3{
		padding-left: 15px;
	}
	
	.appPart .elementPart{
		padding-left: 0;
	}
	.appPart .elementPart .title{
		font-weight: bold;
		padding-bottom: 2px;
	} 
	.appPart .elementPart .content{
		padding-top: 0px;
		padding-bottom: 15px;
	}
	.content .divProgress{
		width: 280px;
		background-color: #e9e9e9;
	}
	.appPart .elementPart .content .component{
		height: 80px;
	}
	.appPart .elementPart .content .component li{
		float: left;
		height: 80px;
		width: 80px;
		margin-right: 6px;
		background-position: center;
		background-repeat: no-repeat;
		position: relative;
		cursor: pointer;
	}
	.appPart .elementPart .content .component li.color1{
		background-color: #99B332;
	}
	.appPart .elementPart .content .component li.color2{
		background-color: #0172C5;
	}
	.appPart .elementPart .content .component li .bottomInfo{
		position: absolute;
		left: 0px;
		bottom: 0px;
		width: 100%;
		padding: 0px; 
		height: 26px;
		background: url('/formmode/images/appbar/appbar_bottom_bg_wev8.png');
		overflow: hidden;
	}
	.appPart .elementPart .content .component li .bottomInfo span{
		
	}
	.appPart .elementPart .content .component li .bottomInfo .label{
		padding-top: 6px;
		padding-left: 8px;
		color: #f1f1f1;
		font-size: 11px;
	}
	.appPart .elementPart .content .component li .bottomInfo .count{
		margin-left: 4px;
		color: #f1f1f1;
		font-size: 11px;
	}
	
	.appPart .elementPart .content .complete{
		background-color: #E9E9E9;
		height: 80px;
		width: 280px;
		color: #FAFAFA;
		padding: 3px 0px 0px 8px;
		position: relative;
	}
	#progressTitle{
		height:30px;position:absolute;top:42px;left:845px;z-index:999;font-size:12px;color:#f8f8f8;
	}
	#progressVal{
		position: absolute;
		top:75px;
		left:845px;
		height:30px;
		color:#fff;
		font-size:28px;
		font-weight: bold;
		z-index:999;
	}
	#progressGif{
		width:280px;height:80px;opacity:0.08;filter:alpha(opacity=8);
	}
	.appPart .elementPart .content .filecontent{
		padding-top: 6px;
		width: 280px;
	}
	.appPart .elementPart .content .desc{
		padding-top: 8px;
	}
	.appPart .elementPart .content .desc ul{
		list-style: none;
		margin: 0px;
		padding: 0px;
	}
	.appPart .elementPart .content .desc ul li{
		padding-left: 2px;
		line-height: 18px;
		color: #666;
		font-size: 11px;
	}
	#appStatistics{
		margin-top: 8px;
		vertical-align:bottom;
	}
	#appStatistics li{
		height: 19px;
		overflow: hidden;
	}
	#appStatistics span{
		display: block;
		height: 15px;
		float: left;
		line-height: 15px;
	}
	#appStatistics .label{
		color: #909090;
		font-size: 11px;
		width: 48px;
		font-style: italic;
	}
	#appStatistics .bar{
		background-color: #E5E5E5;
	}
	#appStatistics .maxValBar{
		background-color: #FF6600;
	}
	#appStatistics .nodata{
		color: #909090;
		font-size: 11px;
		font-style: italic;
	}
	.divBtn{
	width: 100px;
	padding: 5px 0;
	margin: 8px 0;
	/*background-color: #2d89ef;*/
	background-color: #2d89ef;
	color: #fff;
	font-family: Microsoft YaHei;
	font-size: 12px;
	line-height: 18px;
}
	.divBtnDisabled{
		background-color: #E9E9E9 !important;
	}
	</style>
<script type="text/javascript">
var chart;
var legend;
var chartData = <%=appCountInfoSumArray%>;
var formEnginFrame;

$(document).ready(function () {
	$(".component li").hoverIntent({
		over: function(){
			$(this).children(".bottomInfo").animate({height: '0px'}, 80, function(){
			});
		},
		out: function(){
			$(this).children(".bottomInfo").animate({height: '26px'}, 80, function(){
			});
		},
		interval: 0
	});

	
	var barSpeed = 800;
	var maxBarWidth = 170;
	
	var $statisticsBar = $("#appStatistics .bar");
	
	var maxBarVal = 0;
	$statisticsBar.each(function(){
		var barValue = parseInt($(this).attr("barValue"));
		if(barValue > maxBarVal && barValue != "0"){
			maxBarVal = barValue;
		}
	});
	
	var hasMaxBarVal = false;
	$statisticsBar.each(function(){
		var barValue = parseInt($(this).attr("barValue"));
		if (barValue == "0") {
			$(this).removeClass("bar");
			$(this).addClass("nodata");
		}
		if(maxBarVal != 0 && barValue == maxBarVal && !hasMaxBarVal){
			$(this).addClass("maxValBar");
			hasMaxBarVal = true;
		}
		var barWidth = barValue == "0" ? maxBarWidth : parseInt((barValue/maxBarVal) * maxBarWidth);
		$(this).animate({width: barWidth + 'px'}, barSpeed);
	});
	
	
	//========================================================================================
	chart = new AmCharts.AmPieChart();
	chart.outlineAlpha = 1;
	//chart.colors = ["#E3A21A", "#2d89ef"],
    chart.dataProvider = chartData;
    chart.titleField = "country";
    chart.valueField = "visits";
    chart.sequencedAnimation = true;
    chart.startEffect = "easeOutSine";
    chart.innerRadius = "75%";
    chart.startDuration = 0.3;
    chart.startAngle = 90;
    chart.startRadius = 100;
    chart.labelText = "[[title]]<br>[[percents]]%";
    chart.labelRadius = 2;
    chart.labelsEnabled = true;
    chart.balloonText = "[[title]]<br><span style='font-familiy:Microsoft YaHei;font-size:11px'><b>[[value]]</b> ([[percents]]%)</span>";
    chart.depth3D = 0;
    chart.angle = 0;
    chart.fontFamily = "Microsoft YaHei";
    chart.fontSize = 11;
    chart.marginTop = -30;
    chart.marginLeft = -30;
    chart.marginRight = -50;
    chart.marginBottom = -10;
    chart.gradientRatio = 5;
    chart.write("chartdiv");
    
    //获取应用下各组件记录数
    setComponentCount();
    
	formEnginFrame=getFormEnginFrame();
});

function clickTopSubMenu(menuIndex){
	var tDoc = top.document;
	var $submenusUL = $("#submenu", tDoc);
	$(".menuitem:eq("+menuIndex+")", $submenusUL).click();
}

function onSave(){
	enableAllmenu();
	hideRightClickMenu();
	document.getElementById("appForm").submit();
}
function onEdit(appId){
	rightMenu.style.visibility='hidden';
	formEnginFrame.editApp(appId);
}
function createApp(flag){
	hideRightClickMenu();
	var s_id;
	if(flag == 0){
		s_id = "<%=superFieldId%>";
	}else if(flag == 1){
		s_id = "<%=appId%>";
	}else{
		alert("unknow type of create app");
		return;
	}
	
	formEnginFrame.createApp(s_id);
}

function onDelete(){
	hideRightClickMenu();
	formEnginFrame.deleteApp(<%=appId%>, "<%=superFieldId%>", "<%=treeFieldName%>");
}

function setComponentCount(){
	var url = "/weaver/weaver.formmode.servelt.AppInfoAction?action=getAppComponentCount&id=<%=appId%>&fmdetachable=<%=fmdetachable%>&subCompanyId=<%=currentSubCompanyId%>";
	FormmodeUtil.doAjaxDataLoad(url, function(d){
		$("#component1").append("("+(d.modelCount<0?0:d.modelCount)+")");
		$("#component2").append("("+(d.formCount<0?0:d.formCount)+")");
		$("#component3").append("("+(d.searchCount<0?0:d.searchCount)+")");
		$("#component4").append("("+(d.reportCount<0?0:d.reportCount)+")");
		$("#component5").append("("+(d.browserCount<0?0:d.browserCount)+")");
		$("#component6").append("("+(d.treeCount<0?0:d.treeCount)+")");
	});
}

function importwf()
{
	var parastr="filename";
	var filename = document.frmMain.filename.value;
	var pos = filename.length-4;
	if(filename==null||filename==''){
		alert("<%=SystemEnv.getHtmlLabelName(81991,user.getLanguage())%>");//选择文件！
	}else{
		if(filename.lastIndexOf(".zip")==pos)
		{
			jQuery("#upload_faceico").load(showUploadMessage);
			document.frmMain.submit();
			jQuery("#uploadBtn").attr("disabled","disabled").addClass("divBtnDisabled");
			jQuery("#progressGif").css("background-image", "url(/formmode/images/animated-overlay_wev8.gif)");
			jQuery("#progressVal").css("color", "#FD6500");
			doStatus();
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(81992,user.getLanguage())%>");//选择文件格式不正确,请选择zip文件
			return;
		}
	}
}

function doStatus(){
	var url = "/formmode/import/ProcessOperation.jsp?action=doStatus";
	FormmodeUtil.doAjaxDataLoad(url, function(res){
		if(jQuery.isEmptyObject(res)){
			setTimeout("doStatus()",200);//定时调用
		}else{
			var isfinish=res.isfinish;
			var total=res.total;
			var successNum=res.successNum;
			var percentComplete=parseInt(successNum*100/total);
			$("#progressVal").html(percentComplete+"%");
			if(isfinish!=1){
				setTimeout("doStatus()",200);//定时调用
			}else{
				jQuery("#uploadBtn").removeAttr("disabled").removeClass("divBtnDisabled");
				jQuery("#progressGif").css("background-image", "");
				jQuery("#progressVal").css("color", "#fff");
			}
		}
	});
}

var uploadMessageDlg;
function showUploadMessage(){
	var uploadFrame = document.getElementById("upload_faceico");
	var uploadFrameDoc = uploadFrame.contentWindow.document;
	var msg=uploadFrameDoc.body.innerHTML;
	
	uploadMessageDlg = top.createTopDialog();//定义Dialog对象
	uploadMessageDlg.Model = true;
	uploadMessageDlg.Width = 960;//定义长度
	uploadMessageDlg.Height = 650;
	uploadMessageDlg.URL = "/formmode/setup/upload_faceico.jsp?importType=mode";
	uploadMessageDlg.Title = "<%=SystemEnv.getHtmlLabelName(81993,user.getLanguage())%>";//模块导入信息
	uploadMessageDlg.appImportMsg = msg;
	uploadMessageDlg.show();
}

//获取左侧树frame
function getFormEnginFrame(){
	return parent.parent.document.getElementById("formEngine").contentWindow;
}

function exportApp(appid){
	var xmlHttp = ajaxinit();
	xmlHttp.open("post","/formmode/setup/appoperationxml.jsp", true);
	var timestamp = (new Date()).valueOf();
	var postStr = "src=export&appid="+appid+"&ti="+timestamp;
	xmlHttp.onreadystatechange = function () 
	{
		switch (xmlHttp.readyState) 
		{
		   case 4 : 
		   		if (xmlHttp.status==200)
		   		{
		   			var downxml = xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
		   			window.open(downxml,"_self");
		   		}
			    break;
		} 
	}
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;");
	xmlHttp.send(postStr);
}

function preImportApp(appid){
	var appDlg = top.createTopDialog();//定义Dialog对象
	appDlg.Model = true;
	appDlg.Width = 400;//定义长度
	appDlg.Height = 300;
	appDlg.URL = "/formmode/setup/preimportapp.jsp?importchecksametable=<%=formModeConfig.isImportchecksametable()%>&appid="+appid;
	appDlg.Title = "<%=SystemEnv.getHtmlLabelName(81994,user.getLanguage())%>";//导入应用
	appDlg.onCloseCallbackFn = function(result){
		if(result){
			refreshApp(result);
		}
	};
	appDlg.show();
}

function preImportModel(appid){
	appDlg = top.createTopDialog();//定义Dialog对象
	appDlg.currentWindow = window;
	appDlg.Model = true;
	appDlg.Width = 400;//定义长度
	appDlg.Height = 300;
	appDlg.URL = "/formmode/setup/preimportapp.jsp?importmodel=1&appid="+appid;
	appDlg.Title = "<%=SystemEnv.getHtmlLabelName(81995,user.getLanguage())%>";//导入模块
	appDlg.onCloseCallbackFn = function(result){
		if(result){
			refreshApp(result);
		}
	};
	appDlg.show();
}
</script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;

if(operatelevel>0){
	if(level < DocTreeDocFieldConstant.TREE_DOC_FIELD_MAX_LEVEL){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(81996,user.getLanguage())+",javascript:createApp(1),_self} " ;//新建下级应用
	    RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(level > 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(81997,user.getLanguage())+",javascript:createApp(0),_self} " ;//新建同级应用
		RCMenuHeight += RCMenuHeightStep ;
		
	}
	
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit("+appId+"),_self} " ;//编辑
	RCMenuHeight += RCMenuHeightStep;
}

if(operatelevel>1){
	if(childappcount == 0 || isAllDeleteForChildApp){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(81999,user.getLanguage())+",javascript:onDelete(),_self} " ;//废弃
		RCMenuHeight += RCMenuHeightStep ;
	}
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="appTable">
<colgroup>
<col width="530px"/>
<col width="280px"/>
<col width="*"/>
</colgroup>
<tr>
<td>
<div id="appPart1" class="appPart">
	<div class="elementPart">
		<div class="title"><%=SystemEnv.getHtmlLabelName(82000,user.getLanguage())%><!-- 应用组件 --></div>
		<div class="content">
			<ul class="component">
				<li class="color2" style="background-image: url('/formmode/images/appbar/appbar.box_wev8.png');" onclick="javascript:clickTopSubMenu(1);">
					<div class="bottomInfo">
						<div class="label"><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><!-- 模块 --><span id="component1" class="count"></span></div>
					</div>
				</li>
				<li class="color2" style="background-image: url('/formmode/images/appbar/appbar.page.copy_wev8.png');" onclick="javascript:clickTopSubMenu(2);">
					<div class="bottomInfo">
						<div class="label"><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%><!-- 表单 --><span id="component2" class="count"></span></div>
					</div>
				</li>
				<li class="color2" style="background-image: url('/formmode/images/appbar/appbar.page.search_wev8.png');" onclick="javascript:clickTopSubMenu(3);">
					<div class="bottomInfo">
						<div class="label"><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><!-- 查询 --><span id="component3" class="count"></span></div>
					</div>
				</li>
				<li class="color2" style="background-image: url('/formmode/images/appbar/appbar.list.create_wev8.png');" onclick="javascript:clickTopSubMenu(4);">
					<div class="bottomInfo">
						<div class="label"><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%><!-- 报表 --><span id="component4" class="count"></span></div>
					</div>
				</li>
				<li class="color2" style="background-image: url('/formmode/images/appbar/appbar.table.select_wev8.png');" onclick="javascript:clickTopSubMenu(6);">
					<div class="bottomInfo">
						<div class="label"><%=SystemEnv.getHtmlLabelName(32306,user.getLanguage())%><!-- 浏览框 --><span id="component5" class="count"></span></div>
					</div>
				</li>
				<li class="color2" style="background-image: url('/formmode/images/appbar/appbar.diagram_wev8.png');" onclick="javascript:clickTopSubMenu(7);">
					<div class="bottomInfo">
						<div class="label"><%=SystemEnv.getHtmlLabelName(33713,user.getLanguage())%><!-- 树 --><span id="component6" class="count"></span></div>
					</div>
				</li>
			</ul>
		</div>
	</div>
	
	<div class="elementPart" >
		<div class="title"><%=SystemEnv.getHtmlLabelName(82001,user.getLanguage())%><!-- 应用属性 --></div>
		<div class="content">
			<form action="/formmode/setup/appSettingsAction.jsp?action=editAppinfo" method="post" id="appForm" name="appForm">
			<input type="hidden" name="appId" value="<%=appId %>"/>
			<input type="hidden" name="superFieldId" value="<%=superFieldId%>"/> 
			<input type="hidden" name="treelevel" value="<%=level%>"/> 
			<table class="e8_tblForm">
				<colgroup>
					<col width="86px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<td class="e8_tblForm_label" style="border-top: 1px solid #e6e6e6;"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><!-- 名称 --></td>
					<td class="e8_tblForm_field" style="border-top: 1px solid #e6e6e6;">
						<input type="text" id="treeFieldName" name="treeFieldName" style="width:80%;border: none;display: none;" value="<%=treeFieldName %>" onclick="setLookEdit('treeFieldName');" onblur="setLookRead('treeFieldName');"/> 
						<span><%=treeFieldName %></span> 
					</td>
				</tr>
				<tr>
					<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><!-- 显示顺序 --></td>
					<td class="e8_tblForm_field">
						<input type="text" id="showOrder" name="showOrder" style="width:80%;border: none;display: none;" value="<%=showOrder %>" onclick="setLookEdit('showOrder');" onblur="setLookRead('showOrder');"/>
						<span><%=showOrder %></span> 
					</td>
				</tr>
				<%if(fmdetachable.equals("1")){%>
				<tr <%if(appId==1){%>style="display: none;"<%} %> >
					<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%><!-- 所属分部 --></td>
					<td class="e8_tblForm_field">
					<%=SubCompanyComInfo.getSubCompanyname(subCompanyId2)%>
					</td>
				</tr>
				<%}%>
				<tr style="height: 100px;">
					<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82002,user.getLanguage())%><!-- 应用描述 --></td>
					<td class="e8_tblForm_field">
						<textarea id="treeFieldDesc" name="treeFieldDesc" style="width:80%;height:80px;border: none;overflow:hidden;font: 12px Microsoft YaHei;display: none;" onclick="setLookEdit('treeFieldDesc');" onblur="setLookRead('treeFieldDesc');"><%=treeFieldDesc %></textarea>
						<%
							String treeFieldDescStr = treeFieldDesc.replace("\n","<br />");
						%>
						<div><%=treeFieldDescStr %></div>
					</td>
				</tr>
				
				
				
				<script type="text/javascript">
					function setLookEdit(eleId){
						var $ele = $("#"+eleId);
						$ele.css("background-color","#fff");
						$ele.removeAttr("readonly");
						setFocus.call($ele[0]);
					}
					
					function setLookRead(eleId){
						var $ele = $("#"+eleId);
						$ele.css("background-color","#f8f8f8");
						$ele.attr("readonly","readonly");
					}
					
					function setFocus() { 
						var range = this.createTextRange(); //建立文本选区   
						range.moveStart('character', this.value.length); //选区的起点移到最后去  
						range.collapse(true);  
						range.select(); 
					} 
					
					setLookRead("treeFieldName");
					setLookRead("showOrder");
					setLookRead("treeFieldDesc");
				</script>
			</table>
			</form>
		</div>
	</div>
</div>
</td>
<td id="appPart2TD">
<div id="appPart2" class="appPart">
	<div class="elementPart">
		<div class="title" title="<%=SystemEnv.getHtmlLabelName(82003,user.getLanguage())%><%=zzCount%><%=SystemEnv.getHtmlLabelName(82004,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82005,user.getLanguage())%><!-- 数据统计 --></div><!-- 本应用下前xx个月表单数据统计 -->
		<div class="content" style="border-top:1px solid #e9e9e9;">
			<!--  
			<img alt="" src="/formmode/images/demo_wev8.png" style="margin-left: -2px;margin-top: -3px;">-->
			
			<ul id="appStatistics">
				<% for (int i = 0 ; appCountInfoList != null && i < appCountInfoList.size() ; i++) {
					  Map<String, Object> appCountInfoMap = appCountInfoList.get(i);
					  String month = Util.object2String(appCountInfoMap.get("month")).replace("-",".");
					  String sumval = Util.object2String(appCountInfoMap.get("sumval"));
				%>
				    <li>
					    <span class="label"><%=month%></span><!-- 本月应用下有xx条表单数据 -->
					    <span class="bar" barValue="<%=sumval%>" title="<%if (!sumval.equals("0")) out.print(SystemEnv.getHtmlLabelName(82006,user.getLanguage())+sumval+SystemEnv.getHtmlLabelName(82007,user.getLanguage()));%>"><%if (sumval.equals("0")) out.print(SystemEnv.getHtmlLabelName(82008,user.getLanguage()));%></span><!-- 本月暂时没有数据！ -->
				    </li>
				<% } %>
			</ul>
		</div>
	</div>
	
	
	<div class="elementPart"><!-- 同级应用中表单数据量最多的前xx个应用及当前应用数据量统计占比 -->
		<div class="title" style="border-bottom:1px solid #e9e9e9;" title="<%=SystemEnv.getHtmlLabelName(82009,user.getLanguage())%><%=bzCount-1%><%=SystemEnv.getHtmlLabelName(82010,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82011,user.getLanguage())%></div><!-- 数据量对比 -->
		<div id="chartdiv" style="width: 100%; height: 200px;"></div>
	</div>
</div>
</td>
</tr>
</table>
</body>
</html>