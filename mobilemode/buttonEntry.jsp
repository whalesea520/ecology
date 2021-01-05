<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String button_data = Util.null2String(request.getParameter("buttonEntry"));
JSONObject buttonJsonObject = new JSONObject();
if(!"".equals(button_data)){
	buttonJsonObject = JSONObject.fromObject(button_data);
}
String mecStyle = Util.null2String(request.getParameter("mecStyle"));
String buttonName = "";
String className = "";
String script = "";
String style = "";
String borderColor = "";
String fontColor = "";
String bgColor = "";
if(!buttonJsonObject.isEmpty()){
	buttonName = StringHelper.null2String(buttonJsonObject.get("buttonName")).trim();
	className = StringHelper.null2String(buttonJsonObject.get("className"));
	script = StringHelper.null2String(buttonJsonObject.get("script"));
	style = StringHelper.null2String(buttonJsonObject.get("style"));
	borderColor = StringHelper.null2String(buttonJsonObject.get("borderColor"));
	fontColor = StringHelper.null2String(buttonJsonObject.get("fontColor"));
	bgColor = StringHelper.null2String(buttonJsonObject.get("bgColor"));
}
%>
<html>
<head>
	<title></title>
	<link type="text/css" rel="stylesheet" href="/mobilemode/js/colorpick/css/colpick_wev8.css"/>
	<script type="text/javascript" src="/mobilemode/js/colorpick/colpick_wev8.js"></script>
<style>
*{
	font-family: 'Microsoft YaHei', Arial;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
	
}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: middle;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 5px 5px 10px;
}
.e8_tblForm_field2{position:relative;}
.e8_tblForm .e8_tblForm_field, .e8_tblForm .e8_tblForm_field2{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_tblForm_field input{
	padding-left: 2px;
	width:94%;
	height:23px;
	box-sizing:border-box;
}
.e8_tblForm_field2 input{
	margin-right:12px;
	padding-left: 2px;
	width:14%;
}
.e8_label_desc{
	color: #aaa;
}
textarea{
	width:94%;
	height:100px;
}
#buttonNameTip{
	color:red;
	font-size: 12px;
	font-family: 'Microsoft YaHei', Arial;
	display: none;
}
#preview{
	margin: 0px auto;
	width: 60px;
}

/*引入button样式*/
.button{
	font-size: 15px;
	font-weight: 400;
	font-family: 'Microsoft Yahei',Arial, Helvetica, sans-serif;
	cursor: pointer !important;
	border: 1px solid #017afd;
	border-radius: 3px;
	color: #017afd;
	filter:alpha(opacity=100);/*ie8及以前版本*/
    opacity: 1;
	padding: 5px 10px 5px 10px;
}
.link_active:active{
	box-shadow: 0 0 3px #017afd;
}

.colorBox{
	position: absolute;
	display: inline-block;
	background-color: #544cba;
	width: 12px;
	height: 21px;
	border: 1px solid white;
}

#borderColorBox{left: 123px;}
#fontColorBox{right: 142px;}
#bgColorBox{right: 11px;}
.cbboxLabel{vertical-align: middle;}
.style_language_8 #borderColorBox{left:114px;}
.style_language_8 #fontColorBox{right:174px;}
.style_language_8 #bgColorBox{right:21px;}
.style_language_8 #preview{width:109px;}
</style>
<script type="text/javascript">
$(function() {
	$("#buttonName").change(function(){
		checkInput("buttonName");
	});
	$("#borderColor").keyup(function(){
		$("#preview").css("border-color", $(this).val());
		$("#borderColorBox").css("background-color", $(this).val());
	});
	$("#fontColor").keyup(function(){
		$("#preview").css("color", $(this).val());
		$("#fontColorBox").css("background-color", $(this).val());
	});
	$("#bgColor").keyup(function(){
		$("#preview").css("background-color", $(this).val());
		$("#bgColorBox").css("background-color", $(this).val());
	});
	$("#className").blur(function(){
		$("#preview").removeClass("<%=className%>");
		$("#preview").addClass($(this).val());
	});
	$(".colorBox").colpick({
		colorScheme:'dark',
		layout:'rgbhex',
		color:'007aff',
		onSubmit:function(hsb,hex,rgb,el) {
			var eleId = $(el).attr("id");
			var colorValue = "#" + hex;
			if(eleId == "borderColorBox"){
				$("#borderColor").val(colorValue);
				$("#preview").css("border-color", colorValue);
			}
			if(eleId == "fontColorBox"){
				$("#fontColor").val(colorValue);
				$("#preview").css("color", colorValue);
			}
			if(eleId == "bgColorBox"){
				$("#bgColor").val(colorValue);
				$("#preview").css("background-color", colorValue);
			}
			$(el).css('background-color', colorValue);
			$(el).colpickHide();
		}
	});
	MLanguage({
		container: $("tr")
    });
});

function onClose(){
	top.closeTopDialog();
}

function returnResult(flag){
	if(top && top.callTopDlgHookFn){
		var result = {
			"buttonName" :  MLanguage.getValue($("#buttonName"))||$("#buttonName").val(),
			"className"  : $("#className").val(),
			"script"     : $("#script").val(),
			"style"      : getStyle(),
			"borderColor": $("#borderColor").val().trim(),
			"fontColor"  : $("#fontColor").val().trim(),
			"bgColor"    : $("#bgColor").val().trim()
		};
		top.callTopDlgHookFn(result);
	}
	if(flag){
		onClose();
	}else{
		$("input[type='text']", ".e8_tblForm").val("");
		$("textarea", ".e8_tblForm").val("");
	}
}
function getStyle(){
	var result = "";
	var borderColor = $("#borderColor").val().trim();
	var fontColor = $("#fontColor").val().trim();
	var bgColor = $("#bgColor").val().trim();
	if(borderColor.length > 0){
		result += "border-color:" + borderColor + ";";
	}
	if(fontColor.length > 0){
		result += "color:" + fontColor + ";";
	}
	if(bgColor.length > 0){
		result += "background-color:" + bgColor + ";";
	}
	return result;
}

function onOK(flag){
	var buttonNameObj = document.getElementById("buttonName");
	var buttonNameV = buttonNameObj.value;
	if($.trim(buttonNameV) == ""){
		$("#buttonNameTip").show();
		buttonNameObj.focus();
		return;
	}
	returnResult(flag);
}

function checkInput(eleId){
	var v = $("#" + eleId).val();
	if($.trim(v) != ""){
		$("#" + eleId + "Span").html("");
		$("#" + eleId + "Tip").hide();
	}else{
		$("#" + eleId + "Span").html("<img align='absMiddle' src='/images/BacoError_wev8.gif'/>");
	}
}
</script>

</head>
<body class="style_language_<%=user.getLanguage() %>">
	<div id="actionhtml" style="display:none;"></div>
	<table class="e8_tblForm">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<tr>
			<td class="e8_tblForm_label" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(21557,user.getLanguage())%><!-- 按钮名称 --></td>
			<td class="e8_tblForm_field">
				<input type="text" id="buttonName" name="buttonName" value="<%=buttonName%>"  data-multi=false/>
				<span id="buttonNameSpan">
				<% if("".equals(buttonName)){ %>
				<img align="absMiddle" src="/images/BacoError_wev8.gif" />
				<% } %>
			</span>
			<span id="buttonNameTip"><%=SystemEnv.getHtmlLabelName(125393,user.getLanguage())%><!-- 请填写名称 --></span>
			</td>
		</tr>
		<tr id="buttonActionScriptTr">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127662,user.getLanguage())%><!-- 单击脚本 --></td>
			<td class="e8_tblForm_field">
				<textarea id="script" placeholder="<%=SystemEnv.getHtmlLabelName(127663,user.getLanguage())%>"><%=script %></textarea>  <!-- 输入单击按钮可执行脚本 -->
			</td>
		</tr>
		<tr id="buttonClassNameTr">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(83734,user.getLanguage())%><!-- 样式名称 --></td>
			<td class="e8_tblForm_field">
				<input type="text" id="className" value="<%=className %>" placeholder="<%=SystemEnv.getHtmlLabelName(127687,user.getLanguage())%>"/><!-- 样式名称:如saveBtn, 多个样式用空格隔开 -->
			</td>
		</tr>
		<tr id="buttonStyleTr">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(128221,user.getLanguage())%><!-- 自定义样式 --></td>
			<td class="e8_tblForm_field2">
				<span><%=SystemEnv.getHtmlLabelName(128222,user.getLanguage())%><!-- 边框颜色: --></span>
				<input type="text" id="borderColor" value="<%=borderColor %>" maxlength="16"/><div id="borderColorBox" class="colorBox" style="background-color:<%=borderColor%>;"></div>
				<span><%=SystemEnv.getHtmlLabelName(128223,user.getLanguage())%><!-- 字体颜色: --></span>
				<input type="text" id="fontColor" value="<%=fontColor%>"  maxlength="16"/><div id="fontColorBox" class="colorBox" style="background-color:<%=fontColor%>;"></div>
				<span><%=SystemEnv.getHtmlLabelName(128224,user.getLanguage())%><!-- 背景颜色: --></span>
				<input type="text" id="bgColor" value="<%=bgColor%>" maxlength="16"/><div id="bgColorBox" class="colorBox" style="background-color:<%=bgColor%>;"></div>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81814,user.getLanguage())%><!-- 预览效果 --></td>
			<td class="e8_tblForm_field">
				<style><%=mecStyle%></style>
				<div id="preview" class="button fixedButton link_active <%=className %>" style="<%=style%>"><%=SystemEnv.getHtmlLabelName(127671,user.getLanguage())%><!-- 预览按钮 --></div>
			</td>
		</tr>
	</table>
	
	<div class="e8_zDialog_bottom">
		<button type="button" class="e8_btn_submit" onclick="onOK(true)"><%=SystemEnv.getHtmlLabelName(82036,user.getLanguage())%><!-- 保存并关闭 --></button>
		<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
		<button type="button" class="e8_btn_submit" onclick="onOK(false)"><%=SystemEnv.getHtmlLabelName(32720,user.getLanguage())%><!-- 保存并新建 --></button>
	</div>
</body>
</html>
