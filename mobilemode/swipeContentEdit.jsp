<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.mobile.mec.model.MobileExtendComponent"%>
<%@page import="com.weaver.formmodel.mobile.mec.service.MECService"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ include file="/mobilemode/init.jsp"%>

<%@page import="com.weaver.formmodel.mobile.ui.model.AppField"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppFieldManager"%>
<%
String mecid = Util.null2String(request.getParameter("mecid"));
String mectype = Util.null2String(request.getParameter("mectype"));
int sourceV = Util.getIntValue(Util.null2String(request.getParameter("sourceV")));
String swipeType = Util.null2String(request.getParameter("swipeType"));
int swipeStyle = Util.getIntValue(Util.null2String(request.getParameter("swipeStyle")));
String swipeContent = "";
String swipeParamList = "";
JSONArray swipeParams = new JSONArray();
MECService mecService = new MECService();
MobileExtendComponent mobileExtendComponent = mecService.getMecById(mecid);
if(mobileExtendComponent != null){
	String mecParam = Util.null2String(mobileExtendComponent.getMecparam());
	JSONObject mecJson = JSONObject.fromObject(mecParam);
	swipeContent = Util.null2String(mecJson.getString("swipeContent"));
	swipeParamList = Util.null2String(mecJson.getString("swipeParams"));
	swipeParams = JSONArray.fromObject(swipeParamList);
}

MobileAppUIManager mobileAppUIManager = MobileAppUIManager.getInstance();
AppFormUI formui = (AppFormUI)mobileAppUIManager.getById(sourceV);
int formid = formui.getFormId();
List<AppField> fieldlist = MobileAppFieldManager.getInstance().getAppFieldList(formid, 7);
%>
<html>
<head>
	<title></title>
	<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
	<script type="text/javascript" src="/mobilemode/js/UUID_wev8.js"></script>
	<script type="text/javascript" src="/mobilemode/scriptlib/js/ScriptLib.js?v=2018011701"></script>
<style>
*{
	font-family: 'Microsoft Yahei', Arial;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
	
}
.e8_tblForm{
	width: 100%;
	margin: 0 0 15px 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: middle;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 5px 5px 10px;
	color: #666;
}
.e8_tblForm .e8_tblForm_label2{
	border-top: 1px solid #e6e6e6;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.imageWrap{
	float: left;
	width: 90px;
	height: 60px;
	margin-right: 20px;
}
.circleStyle{
	border: 1px solid #eee;
}
.squareStyle{
	border: 1px solid #eee;
}
.img_sel {
	border: 1px solid #007aff;
}
.jNiceCheckbox{
	margin-bottom: -2px;	
}
.checkboxWrap{
	margin-right: 15px; 
	color: #333;
}
#previewDiv {
	/* background: url("/mobilemode/images/mec/img-space2_wev8.png") no-repeat; */
	width: 32px;
	height: 32px;
	border: 1px solid rgb(204,204,204);
	background-color: #C7C4C4;
	border-radius: 4px;
	float: left;
	margin-top: 3px;
}
#previewImg {
	width: 100%;
	height: 100%;
	border-radius: 4px;
}
#addPicDiv {
	background-color: rgb(93, 156, 236);
	color: rgb(255, 255, 255);
	cursor: pointer;
	display: inline-block;
	float: left;
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 12px;
	font-weight: bold;
	height: 30px;
	line-height: 30px;
	margin-top: 5px;
	margin-left: 5px;
	padding-bottom: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-top: 0px;
}
#bgcolor{
	width: 60px;
}
.clickEvent{
	background: url("/mobilemode/images/treeNodeEdit_wev8.png") no-repeat;
	width:16px;
	height:16px;
	cursor: pointer;
}
#btnBar{
	margin: 5px 15px;
	height: 30px;
}
.e8_btn_add{
	background-color: rgb(93, 156, 236);
	height: 25px;
	color: #fff;
	padding: 0 10px;
	float: right;
}
.e8_btn_edit{
	background-color: rgb(93, 156, 236);
	height: 25px;
	color: #fff;
	padding: 0 10px;
	float: right;
	display: none;
}
.linktableContainer{
	max-height: 116px;
	margin-bottom: 15px;
	overflow-x:hidden;
}
table.linktable{
	width: 100%;
	border-collapse: collapse;
	margin: 0px 0px 0px 0px;
	table-layout: fixed;
}
table.linktable tr{

}
table.linktable tr td{
	color: rgb(166,167,171);
	text-align: center;
	padding: 3px 0px;
	border-bottom: 1px solid #e6e6e6;
	border-right: 1px solid #e6e6e6;
}
table.linktable tr.title td{
	border-top: 1px solid #e6e6e6;
}
#paramContent{
	overflow:hidden;
	text-overflow:ellipsis;
	white-space:nowrap;
}
.deploy_btn_edit {
	width: 11px;
	height: 12px;
	display: inline-block;
	background: url("/mobilemode/images/mec/lego_icon_d5b6388_wev8.png") no-repeat;
	background-position: -15px -26px;
	cursor: pointer;
}
.deploy_btn_del {
	width: 12px;
	height: 12px;
	margin-left: 3px;
	display: inline-block;
	background: url("/mobilemode/images/mec/lego_icon_d5b6388_wev8.png") no-repeat;
	background-position: -10px -12px;
	cursor: pointer;
}
.textareaStyle{
	border: 1px solid #ccc;
	width: 618px;
	height: 100px;
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 14px;
	overflow: auto;
}
.textStyle{
	border: rgb(191, 204, 220) 1px solid;
}
.e8_zDialog_bottom{
	position: absolute;
	left: 0px;
	bottom: 0px;
	width: 100%;
}
</style>

<script type="text/javascript">
var mectype = '<%=mectype%>';
var swipeParams = <%=swipeParams%>;
var swipeType = <%=swipeType%>;
var swipeStyle = <%=swipeStyle%>;
$(document).ready(function(){
		$(".circleStyle").click(function(){
			if(!$(this).hasClass("img_sel")){
				$(this).addClass("img_sel");
				$(".squareStyle").removeClass("img_sel");
			}
		});
		
		$(".squareStyle").click(function(){
			if(!$(this).hasClass("img_sel")){
				$(this).addClass("img_sel");
				$(".circleStyle").removeClass("img_sel");
			}
		});
		
		if(swipeStyle==1){
			$(".circleStyle").click();
		}else if(swipeStyle==2){
			$(".squareStyle").click();
		}
		
		if(mectype == 'List'){
			$("#listfield").show();
			$("#urllistfield").hide();
			$("#fieldTip").hide();
		}else{
			$("#urllistfield").show();
			$("#fieldTip").show();
			$("#listfield").hide();
		}
		
		for(var i = 0; i < swipeParams.length; i++){
			var swipeParam = swipeParams[i];
			addDeployRow(mectype,swipeParam);
		}
		
})

function functionChange(){
	var function_select = $("#function_select").val();
	var $bgcolor = $("#bgcolor");
	if(function_select=='拨打电话'){
		$("input[type='checkbox'][name='contentType'][value='1']").attr("checked", true);
		$("input[type='checkbox'][name='contentType'][value='1']").siblings("span.jNiceCheckbox").addClass("jNiceChecked");
		$("input[type='checkbox'][name='contentType'][value='2']").attr("checked", false);
		$("input[type='checkbox'][name='contentType'][value='2']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		$(".actionContent").hide();
		$("#actionContent_1").show();
		$("#previewImg").show().attr("src", "/mobilemode/piclibrary/icon4/swipetel_wev8.png");
		$("#picpath").val("/mobilemode/piclibrary/icon4/swipetel_wev8.png");
		$bgcolor.val("#da532c");
		$("#fieldTR").show();
		$("#clickEventTR").hide();
	}else if(function_select=='发送短信'){
		$("input[type='checkbox'][name='contentType'][value='1']").attr("checked", true);
		$("input[type='checkbox'][name='contentType'][value='1']").siblings("span.jNiceCheckbox").addClass("jNiceChecked");
		$("input[type='checkbox'][name='contentType'][value='2']").attr("checked", false);
		$("input[type='checkbox'][name='contentType'][value='2']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		$(".actionContent").hide();
		$("#actionContent_1").show();
		$("#previewImg").show().attr("src", "/mobilemode/piclibrary/icon4/swipesms_wev8.png");
		$("#picpath").val("/mobilemode/piclibrary/icon4/swipesms_wev8.png");
		$bgcolor.val("#e3a21a");
		$("#fieldTR").show();
		$("#clickEventTR").hide();
	}else if(function_select=='发送邮件'){
		$("input[type='checkbox'][name='contentType'][value='1']").attr("checked", true);
		$("input[type='checkbox'][name='contentType'][value='1']").siblings("span.jNiceCheckbox").addClass("jNiceChecked");
		$("input[type='checkbox'][name='contentType'][value='2']").attr("checked", false);
		$("input[type='checkbox'][name='contentType'][value='2']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		$(".actionContent").hide();
		$("#actionContent_1").show();
		$("#previewImg").show().attr("src", "/mobilemode/piclibrary/icon4/swipemailto_wev8.png");
		$("#picpath").val("/mobilemode/piclibrary/icon4/swipemailto_wev8.png");
		$bgcolor.val("#9f00a7");
		$("#fieldTR").show();
		$("#clickEventTR").hide();
	}else if(function_select=='普通按钮'){
		$("input[type='checkbox'][name='contentType'][value='2']").attr("checked", true);
		$("input[type='checkbox'][name='contentType'][value='2']").siblings("span.jNiceCheckbox").addClass("jNiceChecked");
		$("input[type='checkbox'][name='contentType'][value='1']").attr("checked", false);
		$("input[type='checkbox'][name='contentType'][value='1']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		$(".actionContent").hide();
		$("#actionContent_2").show();
		$bgcolor.val("#99b433");
		$("#fieldTR").hide();
		$("#clickEventTR").show();
	}else {
		$("input[type='checkbox'][name='contentType'][value='2']").attr("checked", false);
		$("input[type='checkbox'][name='contentType'][value='2']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		$("input[type='checkbox'][name='contentType'][value='1']").attr("checked", false);
		$("input[type='checkbox'][name='contentType'][value='1']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		$(".actionContent").hide();
		$bgcolor.val("");
		$("#fieldTR").show();
		$("#clickEventTR").hide();
	}
}

function changeContentType(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='contentType']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		$(".actionContent").hide();
		$("#actionContent_" + objV).show();
	},100);
}

function addPic(){
	var pic_pathV = $("#picpath").val();
	var url = "/mobilemode/picset.jsp?pic_path="+pic_pathV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(124841,user.getLanguage())%>";  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		$("#picpath").val(picPath);
		$("#previewImg").show().attr("src", picPath);
	};
}

function AddClickEventScript(){
	var $clickEvent = $("#clickEvent");
	SL_AddScriptToField($clickEvent);
}

function addDeployRow(mectype,swipeParam){
	var paramFunction;
	var paramField;
	var paramContentType;
	var paramContent;
	var paramBgcolor;
	$("#rowID").val("");
	var id = new UUID().toString();
	if(swipeParam != null){
		paramFunction = swipeParam["paramFunction"];
		paramField = swipeParam["paramField"];
		paramContentType = swipeParam["paramContentType"];
		paramContent = swipeParam["paramContent"];
		paramBgcolor = swipeParam["paramBgcolor"];
	}else {
		paramFunction = $("#function_select").val();
		if(paramFunction==""){
			alert("<%=SystemEnv.getHtmlLabelName(127581,user.getLanguage())%>");  //需选择按钮类型！
			return;
		}
		
		if(paramFunction=='普通按钮'){
			paramField = $("#clickEvent").val();
		}else {
			if(mectype == 'List'){
				paramField = $("#listfield").find("option:selected").attr("fieldName");
				if(paramField==""){
					alert("<%=SystemEnv.getHtmlLabelName(127582,user.getLanguage())%>");  //需选择对应字段！
					return;
				}
			}else{
				paramField = $("#urllistfield").val();
				if(paramField==""){
					alert("<%=SystemEnv.getHtmlLabelName(127583,user.getLanguage())%>");  //需填写对应字段！
					return;
				}
			}
		}
		
		var contentType = $("input[type='checkbox'][name='contentType']:checked").val();
		paramContentType = contentType;
		var picpath = $("#picpath").val();
		var contentText = $("#contentText").val();
		if(contentType==1){
			paramContent = picpath;
			if(paramContent==""){
				alert("<%=SystemEnv.getHtmlLabelName(127584,user.getLanguage())%>");  //需选择图片！
				return;
			}
		}else if(contentType==2){
			paramContent = contentText;
			if(paramContent==""){
				alert("<%=SystemEnv.getHtmlLabelName(127585,user.getLanguage())%>");  //需填写按钮内容！
				return;
			}
		}
		paramBgcolor = $("#bgcolor").val();
		if(paramBgcolor==""){
			alert("<%=SystemEnv.getHtmlLabelName(127586,user.getLanguage())%>");  //需填写背景颜色！
			return;
		}
	}

	var $listEntry = $("<tr id=\"entry_"+id+"\"></tr>");
	var listEntryHtm = 	"<td id=\"paramFunction\">" + paramFunction + "</td>"
						+"<td id=\"paramField\" style=\"display: none;\">" + paramField + "</td>"
						+"<td id=\"paramContentType\" style=\"display: none;\">" + paramContentType + "</td>"
						+"<td id=\"paramContent\">" + paramContent + "</td>"
						+"<td id=\"paramBgcolor\">" + paramBgcolor + "</td>"
						+"<td>"
							+"<span class=\"deploy_btn_edit\" onclick=\"editDeployRow('" + id + "')\"></span>"
							+"<span class=\"deploy_btn_del\" onclick=\"deleteDeployRow('" + id + "')\"></span>"
						+"</td>";
	$listEntry.html(listEntryHtm);			
	var $ParentListEntry;
	$ParentListEntry = $(".linktable");
	$ParentListEntry.append($listEntry);
}

function editToRow(mectype){
	var paramFunction;
	var paramField;
	var paramContentType;
	var paramContent;
	var paramBgcolor;
	var id = $("#rowID").val();
	
	paramFunction = $("#function_select").val();
	if(paramFunction==""){
		alert("<%=SystemEnv.getHtmlLabelName(127581,user.getLanguage())%>");  //需选择按钮类型！
		return;
	}
		
	if(paramFunction=='普通按钮'){
		paramField = $("#clickEvent").val();
	}else {
		if(mectype == 'List'){
			paramField = $("#listfield").find("option:selected").attr("fieldName");
			if(paramField==""){
				alert("<%=SystemEnv.getHtmlLabelName(127582,user.getLanguage())%>");  //需选择对应字段！
				return;
			}
		}else{
			paramField = $("#urllistfield").val();
			if(paramField==""){
				alert("<%=SystemEnv.getHtmlLabelName(127583,user.getLanguage())%>");  //需填写对应字段！
				return;
			}
		}
	}
		
	var contentType = $("input[type='checkbox'][name='contentType']:checked").val();
	paramContentType = contentType;
	var picpath = $("#picpath").val();
	var contentText = $("#contentText").val();
	if(contentType==1){
		paramContent = picpath;
		if(paramContent==""){
			alert("<%=SystemEnv.getHtmlLabelName(127584,user.getLanguage())%>");  //需选择图片！
			return;
		}
	}else if(contentType==2){
		paramContent = contentText;
		if(paramContent==""){
			alert("<%=SystemEnv.getHtmlLabelName(127585,user.getLanguage())%>");  //需填写按钮内容！
			return;
		}
	}
	paramBgcolor = $("#bgcolor").val();
	if(paramBgcolor==""){
		alert("<%=SystemEnv.getHtmlLabelName(127586,user.getLanguage())%>");  //需填写背景颜色！
		return;
	}
	
	var listEntryHtm = 	"<td id=\"paramFunction\">" + paramFunction + "</td>"
						+"<td id=\"paramField\" style=\"display: none;\">" + paramField + "</td>"
						+"<td id=\"paramContentType\" style=\"display: none;\">" + paramContentType + "</td>"
						+"<td id=\"paramContent\">" + paramContent + "</td>"
						+"<td id=\"paramBgcolor\">" + paramBgcolor + "</td>"
						+"<td>"
							+"<span class=\"deploy_btn_edit\" onclick=\"editDeployRow('" + id + "')\"></span>"
							+"<span class=\"deploy_btn_del\" onclick=\"deleteDeployRow('" + id + "')\"></span>"
						+"</td>";
	var $listEntry = $("#entry_"+id);
	$listEntry.children("td").remove();	
	$listEntry.html(listEntryHtm);
	
	$(".e8_btn_edit").hide();
	$(".e8_btn_add","#btnBar").show();
}

function editDeployRow(rowId){
	$(".e8_btn_add","#btnBar").hide();
	$(".e8_btn_edit").show();
	$("#rowID").val(rowId);
	var $row = $("#entry_" + rowId);
	var paramFunction = $("#paramFunction",$row).text();
	var paramField = $("#paramField",$row).text();
	var paramContentType = $("#paramContentType",$row).text();
	var paramContent = $("#paramContent",$row).text();
	var paramBgcolor = $("#paramBgcolor",$row).text();
	
	$("#function_select").val(paramFunction);
	if(paramFunction=='普通按钮'){
		$("#clickEvent").val(paramField);
		$("#fieldTR").hide();
		$("#clickEventTR").show();
	}else {
		if(mectype == 'List'){
			$("#listfield").find("option[fieldname='"+ paramField +"']").attr("selected",true);
		}else{
			$("#urllistfield").val(paramField)
		}
		$("#fieldTR").show();
		$("#clickEventTR").hide();
	}
	
	if(paramContentType==1){
		$("input[type='checkbox'][name='contentType'][value='1']").attr("checked", true);
		$("input[type='checkbox'][name='contentType'][value='1']").siblings("span.jNiceCheckbox").addClass("jNiceChecked");
		$("input[type='checkbox'][name='contentType'][value='2']").attr("checked", false);
		$("input[type='checkbox'][name='contentType'][value='2']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		$(".actionContent").hide();
		$("#actionContent_1").show();
		$("#previewImg").show().attr("src", paramContent);
		$("#picpath").val(paramContent);
	}else if(paramContentType==2){
		$("input[type='checkbox'][name='contentType'][value='2']").attr("checked", true);
		$("input[type='checkbox'][name='contentType'][value='2']").siblings("span.jNiceCheckbox").addClass("jNiceChecked");
		$("input[type='checkbox'][name='contentType'][value='1']").attr("checked", false);
		$("input[type='checkbox'][name='contentType'][value='1']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		$(".actionContent").hide();
		$("#actionContent_2").show();
		$("#contentText").val(paramContent);
	}
	
	$("#bgcolor").val(paramBgcolor);
}

function deleteDeployRow(rowId){
	var msg = "<%=SystemEnv.getHtmlLabelName(127574,user.getLanguage())%>";  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	var $attrContainer = $(".linktable");
	$("#entry_" + rowId, $attrContainer).remove();
}

function MADL_ChangeSwipeType(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='swipeType']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
	},100);
}

function generateCode(){
	var swipeContent = $.trim($("#swipeContent").val());
	if(swipeContent!=""){
		if (confirm("<%=SystemEnv.getHtmlLabelName(127587,user.getLanguage())%>")==false){  //是否需要覆盖已生成的配置代码？
			return;
		}
	}
	
	var swipeStyle;
	var listEntryHtm = "";
	if($(".img_sel").hasClass("circleStyle")){
		swipeStyle = 1;
		listEntryHtm = 	"<div class=\"btnContainer\"><div class=\"btnContainerInner\">";
	}else if($(".img_sel").hasClass("squareStyle")){
		swipeStyle = 2;
		listEntryHtm = 	"<div class=\"btnContainer2\">";
	}

	var $paramTR = $("tr", $(".linktable")).not(".title");
	
	$paramTR.each(function(){
		var content;
		if($("#paramContentType",$(this)).text()==1){
			content = "<img src=\""+ $("#paramContent",$(this)).text() +"\"/>";
		}else if($("#paramContentType",$(this)).text()==2){
			content = $("#paramContent",$(this)).text();
		}
		
		
		if($("#paramFunction",$(this)).text()=='拨打电话'){
			listEntryHtm += "<a class=\"btnBox\" style=\"background-color:"+ $("#paramBgcolor",$(this)).text() +"\" href=\"tel:{"+ $("#paramField",$(this)).text() +"}\">" + content + "</a>";
		}else if($("#paramFunction",$(this)).text()=='发送短信'){
			listEntryHtm += "<a class=\"btnBox\" style=\"background-color:"+ $("#paramBgcolor",$(this)).text() +"\" href=\"sms:{"+ $("#paramField",$(this)).text() +"}\">" + content + "</a>";
		}else if($("#paramFunction",$(this)).text()=='发送邮件'){
			listEntryHtm += "<a class=\"btnBox\" style=\"background-color:"+ $("#paramBgcolor",$(this)).text() +"\" href=\"mailto:{"+ $("#paramField",$(this)).text() +"}\">" + content + "</a>";
		}else if($("#paramFunction",$(this)).text()=='普通按钮'){
			listEntryHtm += "<div class=\"btnBox\" style=\"background-color:"+ $("#paramBgcolor",$(this)).text() +"\" script=\""+ $("#paramField",$(this)).text() +"\">"+ content +"</div>";
		}
	});
	
	if($(".img_sel").hasClass("circleStyle")){
		listEntryHtm += "</div></div>";
	}else if($(".img_sel").hasClass("squareStyle")){
		listEntryHtm += "</div>";
	}
	
	var $ParentListEntry;
	$ParentListEntry = $("#swipeContent");
	$ParentListEntry.html(listEntryHtm);
}

function onClose(){
	top.closeTopDialog();
}

function returnResult(){
	
	var swipeParams = [];
	$("tr", $(".linktable")).not(".title").each(function(i){
		var swipeParam = {};
		swipeParam["paramFunction"] = $("#paramFunction",$(this)).text();
		swipeParam["paramField"] = $("#paramField",$(this)).text();
		swipeParam["paramContentType"] = $("#paramContentType",$(this)).text();
		swipeParam["paramContent"] = $("#paramContent",$(this)).text();
		swipeParam["paramBgcolor"] = $("#paramBgcolor",$(this)).text();
		swipeParams.push(swipeParam);
	});
	var swipeStyle;
	if($(".img_sel").hasClass("circleStyle")){
		swipeStyle = 1;
	}else if($(".img_sel").hasClass("squareStyle")){
		swipeStyle = 2;
	}
	var swipeType = $("input[type='checkbox'][name='swipeType']:checked").val();
	var swipeContent = $.trim($("#swipeContent").val());
	
	/* var errorMsg = "";//判断空
	if(paramName == ""){
		errorMsg = "参数名称不能为空";
	}else if(paramValue == ""){
		errorMsg = "参数值不能为空";
	}
	
	if(errorMsg != ""){
		var $warn = $("#warn-info");
		$warn.html(errorMsg);
		$warn.fadeIn(1000, function(){
			$(this).fadeOut(3000);
		});
		return;
	} */
	
	if(top && top.callTopDlgHookFn){
		var result = {
			"swipeParams" : $.isEmptyObject(swipeParams) ? "" : JSON.stringify(swipeParams),
			"swipeStyle" : swipeStyle,
			"swipeType" : swipeType,
			"swipeContent" : swipeContent
		};
		top.callTopDlgHookFn(result);
	}
	
	onClose();
}

function onOK(){
	returnResult();
}
</script>

</head>
<body>
	<div id="warn-info"></div>
	<table class="e8_tblForm">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<input id="rowID" type="hidden"/>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127588,user.getLanguage())%><!-- 按钮类型 --></td>
			<td class="e8_tblForm_field">
				<select id="function_select" class="function_select" onchange="functionChange()">
					<option value=""></option>
					<option value="拨打电话"><%=SystemEnv.getHtmlLabelName(127589,user.getLanguage())%><!-- 拨打电话 --></option>
					<option value="发送短信"><%=SystemEnv.getHtmlLabelName(125977,user.getLanguage())%><!-- 发送短信 --></option>
					<option value="发送邮件"><%=SystemEnv.getHtmlLabelName(125978,user.getLanguage())%><!-- 发送邮件 --></option>
					<option value="普通按钮"><%=SystemEnv.getHtmlLabelName(127590,user.getLanguage())%><!-- 普通按钮 --></option>
				</select>
			</td>
		</tr>
		<tr id="fieldTR">
			<td class="e8_tblForm_label"><%if("List".equals(mectype)){ %><%=SystemEnv.getHtmlLabelName(127591,user.getLanguage())%><!-- 对应字段 --><%}else{%><%=SystemEnv.getHtmlLabelName(127592,user.getLanguage())%><!-- 对应字段名称 --><%}%></td>
			<td class="e8_tblForm_field">
				<select id="listfield" class="listfield">
					<option value="" fieldname=""></option>
					<% for(AppField appField : fieldlist) {%>
						<option value="<%=appField.getFieldid() %>" fieldname="<%=appField.getFieldName() %>"><%=appField.getFieldDesc() %></option>
					<%}%>
				</select>
				<input id="urllistfield" class="urllistfield" style="border: rgb(191, 204, 220) 1px solid;"/>
				<span id="fieldTip"><%=SystemEnv.getHtmlLabelName(127593,user.getLanguage())%><!-- 如: name --></span>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127594,user.getLanguage())%><!-- 按钮内容 --></td>
			<td class="e8_tblForm_field">
				<span class="checkboxWrap">
					<input type="checkbox" name="contentType" value="1" onclick="changeContentType(this)"/><%=SystemEnv.getHtmlLabelName(83737,user.getLanguage())%><!-- 图片 -->
				</span>
				<span class="checkboxWrap">
					<input type="checkbox" name="contentType" value="2" onclick="changeContentType(this)"/><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%><!-- 文本 -->
				</span>
				<div class="actionContent" id="actionContent_1" style="display: none;">
					<div id="previewDiv">
						<img id="previewImg" style="display: none;">
					</div>
					<div id="addPicDiv" onclick="addPic()"><%=SystemEnv.getHtmlLabelName(125080,user.getLanguage())%><!-- 选择图片 --></div>
					<input type="hidden" name="picpath" id="picpath"/>
				</div>
				<div class="actionContent" id="actionContent_2" style="display: none;margin-top: 16px;"><input type="text" class="textStyle" id="contentText" name="contentText"/></div>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(2077,user.getLanguage())%><!-- 背景颜色 --></td>
			<td class="e8_tblForm_field">
				<input type="text" class="textStyle" id="bgcolor" name="bgcolor"/>
			</td>
		</tr>
		<tr id="clickEventTR" style="display: none;">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127595,user.getLanguage())%><!-- 单击事件 --></td>
			<td class="e8_tblForm_field">
				<div class="clickEvent" onclick="AddClickEventScript()"></div>
				<input type="hidden" id="clickEvent"/>
			</td>
		</tr>
		<tr id="btnBar">
			<td class="e8_tblForm_label"></td>
			<td class="e8_tblForm_field">
				<button type="button" class="e8_btn_add" onclick="addDeployRow('<%=mectype %>')"><%=SystemEnv.getHtmlLabelName(83476,user.getLanguage())%><!-- 添加 --></button>
				<button type="button" class="e8_btn_edit" onclick="editToRow('<%=mectype %>')"><%=SystemEnv.getHtmlLabelName(33797,user.getLanguage())%><!-- 修改 --></button>
			</td>
		</tr>
	</table>
	<div class="linktableContainer">
		<table class="linktable">
			<tr class="title">
				<td style="width:70px;"><%=SystemEnv.getHtmlLabelName(127588,user.getLanguage())%><!-- 按钮类型 --></td>
				<td style="display: none;"><%=SystemEnv.getHtmlLabelName(127591,user.getLanguage())%><!-- 对应字段 --></td>
				<td style="width:410px;"><%=SystemEnv.getHtmlLabelName(127594,user.getLanguage())%><!-- 按钮内容 --></td>
				<td style="width:70px;"><%=SystemEnv.getHtmlLabelName(2077,user.getLanguage())%><!-- 背景颜色 --></td>
				<td style="width:70px;"><%=SystemEnv.getHtmlLabelName(126032,user.getLanguage())%><!-- 操作 --></td>
			</tr>
		</table>
	</div>
	<table class="e8_tblForm">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<tr>
			<td class="e8_tblForm_label e8_tblForm_label2"><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%><!-- 样式 --></td>
			<td class="e8_tblForm_field e8_tblForm_label2">
				<div class="imageWrap">
					<div style="color: rgb(166,167,171);text-align: center;height: 20px;"><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%><!-- 样式 -->1</div>
					<img class="circleStyle" src="/mobilemode/images/circleswipe_wev8.png" style="width: 100%;height: 40px;"/>
				</div>
				<div class="imageWrap">
					<div style="color: rgb(166,167,171);text-align: center;height: 20px;"><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%><!-- 样式 -->2</div>
					<img class="squareStyle"  src="/mobilemode/images/squareswipe_wev8.png" style="width: 100%;height: 40px;"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label e8_tblForm_label2"><%=SystemEnv.getHtmlLabelName(127596,user.getLanguage())%><!-- 滑出方式 --></td>
			<td class="e8_tblForm_field e8_tblForm_label2">
				<div><%=SystemEnv.getHtmlLabelName(127603,user.getLanguage())%><!-- 从右 -->&nbsp;
					<input type="checkbox" name="swipeType" value="1" onclick="MADL_ChangeSwipeType(this)"/><%=SystemEnv.getHtmlLabelName(127597,user.getLanguage())%><!-- 推出 -->&nbsp;
					<input type="checkbox" name="swipeType" value="2" onclick="MADL_ChangeSwipeType(this)"/><%=SystemEnv.getHtmlLabelName(127598,user.getLanguage())%><!-- 浮出 -->
				</div>
				<script type="text/javascript">
					$("input[type='checkbox'][name='swipeType'][value='"+swipeType+"']").attr("checked", "checked");
				</script>
			</td>
		</tr>
	</table>
	<div style="position: relative;">
		<div style="position: absolute;right:95px;color:red;top: 5px">
			<%=SystemEnv.getHtmlLabelName(127599,user.getLanguage())%><!-- 以上配置完成后，需要点击右方的生成代码按钮方可生效 -->
		</div>
		<div style="position: absolute;right:15px;">
			<button type="button" class="e8_btn_add" onclick="generateCode()"><%=SystemEnv.getHtmlLabelName(127600,user.getLanguage())%><!-- 生成代码 --></button>
		</div>
		<div style="position: absolute;width:100%;margin-top:35px;">
			<textarea id="swipeContent" name="swipeContent" class="textareaStyle"><%=swipeContent%></textarea>
		</div>
	</div>
	<div class="e8_zDialog_bottom">
		<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
		<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%><!-- 取消 --></button>
	</div>
</body>
</html>
