<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String fbutton_data = Util.null2String(request.getParameter("fbuttonEntry"));
JSONObject fbuttonJsonObject = new JSONObject();
if(!"".equals(fbutton_data)){
	fbuttonJsonObject = JSONObject.fromObject(fbutton_data);
}

String buttonname = "";
String buttonreminder = "";
String action = "";
String actionvalue = "";
String callbackfunction = "";
if(!fbuttonJsonObject.isEmpty()){
	buttonname = StringHelper.null2String(fbuttonJsonObject.get("buttonname")).trim();
	buttonreminder = StringHelper.null2String(fbuttonJsonObject.get("buttonreminder")).trim();
	action = StringHelper.null2String(fbuttonJsonObject.get("action"));
	actionvalue = StringHelper.null2String(fbuttonJsonObject.get("actionvalue"));
	callbackfunction = StringHelper.null2String(fbuttonJsonObject.get("callbackfunction"));
}
%>
<html>
<head>
	<title></title>
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
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_tblForm_field input{
	padding-left: 2px;
	width:94%;
}
.e8_label_desc{
	color: #aaa;
}
textarea{
	width:94%;
	height:100px;
}
#buttonnameTip{
	color:red;
	font-size: 12px;
	font-family: 'Microsoft YaHei', Arial;
	display: none;
}
.e8_zDialog_bottom{
	position: absolute;
	left: 0px;
	bottom: 0px;
	width:100%;
}
</style>
<script type="text/javascript">

$(function() {
	$("#buttonname").change(function(){
		checkInput("buttonname");
	});
	$("#action").change(function(){
		selectChange($(this).val());
	});
	var action = $("#actionhtml").html();
	if(action != ""){
		$("#action").val(action);
		selectChange(action);
	}
	
	
	MLanguage({
		container: $("tr")
    });
});

function onClose(){
	top.closeTopDialog();
}

function selectChange(action){
	if(action=="1"){// 提交
		$("#callbackfunctionTr").show();
		$("#actionvalueTr").hide();
		$("#buttonreminderTr").show();
	}else if(action=="2" || action == "5" || action == "6"){// 重置, 编辑, 删除
		$("#callbackfunctionTr").hide();
		$("#actionvalueTr").hide();
		$("#buttonreminderTr").hide();
	}else if(action=="3"){// 手动输入
		$("#callbackfunctionTr").hide();
		$("#actionvalueTr").show();
		$("#buttonreminderTr").hide();
	}else if(action=="4"){// 提交并返回
		$("#callbackfunctionTr").show();
		$("#actionvalueTr").hide();
		$("#buttonreminderTr").show();
	}
}

function returnResult(){
	if(top && top.callTopDlgHookFn){
		var action = $("#action").val();
		var actionvalue = $("#actionvalue").val();
		var callbackfunction = $("#callbackfunction").val();
		
		if(action == "1"){
			actionvalue = "";
		}else if(action == "2" || action == "5" || action == "6"){
			actionvalue = "";
			callbackfunction = "";
		}else if(action == "3"){
			callbackfunction = "";
		}else if(action == "4"){
			actionvalue = "";
		}
		
		var result = {
			"buttonname" : MLanguage.getValue($("#buttonname"))|| $("#buttonname").val(),
			"action" : action,
			"buttonreminder" : MLanguage.getValue($("#buttonreminder"))|| $("#buttonreminder").val().trim(),
			"_action" : $("#action").find("option:selected").text(),
			"actionvalue" : actionvalue,
			"callbackfunction" : callbackfunction
		};
		top.callTopDlgHookFn(result);
	}
	
	onClose();
}

function onOK(){
	var buttonnameObj = document.getElementById("buttonname");
	var buttonnameV = buttonnameObj.value;
	if($.trim(buttonnameV) == ""){
		$("#buttonnameTip").show();
		buttonnameObj.focus();
		return;
	}
	returnResult();
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
<body>
	<div id="actionhtml" style="display:none;"><%=action %></div>
	<table class="e8_tblForm">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<tr>
			<td class="e8_tblForm_label" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(21557,user.getLanguage())%><!-- 按钮名称 --></td>
			<td class="e8_tblForm_field">
				<input type="text" id="buttonname" name="buttonname" value="<%=buttonname%>"  data-multi=false/>
				<span id="buttonnameSpan">
				<% if("".equals(buttonname)){ %>
				<img align="absMiddle" src="/images/BacoError_wev8.gif" />
				<% } %>
			</span>
			<span id="buttonnameTip"><%=SystemEnv.getHtmlLabelName(125393,user.getLanguage())%><!-- 请填写名称 --></span>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127588,user.getLanguage())%><!-- 按钮类型 --></td>
			<td class="e8_tblForm_field">
				<div>
					<select id="action" style="width: 90px;">
						<option value="1" selected><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><!-- 提交 --></option>
						<option value="4" ><%=SystemEnv.getHtmlLabelName(127679,user.getLanguage())%><!-- 提交并返回 --></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%><!-- 重置 --></option>
						<option value="5"><%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%><!-- 编辑 --></option>
						<option value="6"><%=SystemEnv.getHtmlLabelName(126371,user.getLanguage())%><!-- 删除 --></option>
						<option value="3" ><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%><!-- 手动输入 --></option>
					</select>
				</div>
			</td>
		</tr>
		<tr id="buttonreminderTr" style="display: none;">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127229,user.getLanguage())%><!-- 提示信息 --></td>
			<td class="e8_tblForm_field">
				<input type="text" id="buttonreminder" name="buttonreminder" value="<%=buttonreminder%>"  data-multi=false/>
			</td>
		</tr>
		<tr id="callbackfunctionTr">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127680,user.getLanguage())%><!-- 回调脚本 --></td>
			<td class="e8_tblForm_field">
				<textarea id="callbackfunction" ><%=callbackfunction %></textarea>
			</td>
		</tr>
		<tr id="actionvalueTr" style="display: none;">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127681,user.getLanguage())%><!-- 输入脚本 --></td>
			<td class="e8_tblForm_field">
				<textarea id="actionvalue" ><%=actionvalue %></textarea>
			</td>
		</tr>
	</table>
	
	<div class="e8_zDialog_bottom">
		<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
		<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
	</div>
</body>
</html>
