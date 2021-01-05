<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.mobile.template.TemplateManager"%>
<%@page import="com.weaver.formmodel.mobile.template.Template"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String appHomepageId = Util.null2String(request.getParameter("appHomepageId"));

TemplateManager templateManager = new TemplateManager();
List<Template> tmpList = templateManager.getAllTemplate();
List<String> cList = templateManager.getCategory(tmpList);
List<String> c2List = templateManager.getCategory2(tmpList);

%>
<!DOCTYPE HTML>
<head>
<title><%=SystemEnv.getHtmlLabelName(127365,user.getLanguage())%><!-- 存为模板 --></title>
<style type="text/css">
*{
	font: 12px Microsoft YaHei;
}
.title{
	border-bottom: 1px solid #e6e6e6;
	overflow: hidden;
	padding: 0px 10px;
	font-family: 'Microsoft YaHei';
	height: 60px;
	overflow: hidden;
}
.text{
	float: left;
	background: url("/formmode/images/appIconRounded_wev8.png") no-repeat;
	padding-left: 48px;
	margin-top: 10px;
	height: 42px;
}
.text .big{
	font-size: 16px;
	color: #333;
}
.text .small{
	font-size: 12px;
	color: #AFAFAF;
	margin-top: 2px;
}
.button{
	float: right;
	margin-top: 29px;
}
.button div{
	background-color: #30b5ff;
	color: #fff;
	padding: 0px 10px;
	height: 23px;
	line-height: 23px;
	cursor: pointer;
}
.button div.disabled{
	background-color: #eee;
	color: #444;	
}
.angle{
	background-image: url(/images/ecology8/angle_wev8.png);
	background-position: 50% 50%;
	background-repeat: no-repeat;
	color: rgb(184, 184, 184);
	cursor: pointer;
	height: 19px;
	left: 33px;
	position: absolute;
	top: 48px;
	width: 84px;
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
.e8_label_desc{
	color: #aaa;
	margin-top: 2px;
}
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
#addPicDiv{
	background-color: rgb(93, 156, 236);
	color: rgb(255, 255, 255);
	cursor: pointer;
	display: inline-block;
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 12px;
	font-weight: bold;
	height: 30px;
	line-height: 30px;
	padding-bottom: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-top: 0px;
}
#previewDiv{
	background: url("/mobilemode/images/mec/img-space2_wev8.png") no-repeat;
	width: 36px;
	height: 36px;
	border: 1px solid rgb(204,204,204);
	background-color: #fff;
	border-radius: 4px;
	margin-top: 1px;
	background-size: 36px 36px;
	cursor: pointer;
	position: relative;
}
#previewDiv img{
	width: 100%;
	height: 100%;
	border-radius: 4px;
}
.textStyle, .textareaStyle{
	border: 1px solid #bcbcbc;
	padding: 3px 0px 3px 5px;
	box-sizing: border-box;
}
.jNiceCheckbox{
	margin-bottom: -2px;	
}
.cbboxEntry{
	display: inline-block;position: relative;
}
.cbboxLabel{
	color: #333;font-size: 12px;position: absolute;top:2px;left:20px;
}
.div_bottom{
	position: absolute;
	left:0px;
	bottom: 0px;
	height: 45px;
	width: 100%;
	background-color: #FAFAFA;
	border-top: 1px solid #e6e6e6;
	text-align: center;
	line-height: 45px;
}
.div_bottom button{
	color: #007aff;
	height: 30px;
	line-height: 30px;
	padding-left: 18px;
	padding-right: 18px;
	font-size: 12px;
	background-color: transparent;
}
.div_bottom button:HOVER {
	background-color: #2690e3;
	color: #fff;
}
.upLoadFile{
	position: absolute;
	font-size: 20px;
	width: 38px;
	height: 38px;
	bottom: 0px;
	left: 0px;
	filter: alpha(opacity=0);
	opacity: 0;
	cursor: pointer;
}
.textArowWrap{position: relative;width:80%;}
.textArow{
	width: 20px;
	height: 20px;
	position: absolute;
	top: 2px;
	right: 1px;
	background: url("/mobilemode/images/homepage/homepage_bottom_wev8.jpg");
	cursor: pointer;
}
.categoryChoose{
	position: absolute;width: 466px;max-height:200px;background-color: red;left:155px;
	background-color: #fff;
	overflow-x: hidden;
	overflow-y: auto; 
	border: 1px solid #bcbcbc;
	box-sizing: border-box;
	display: none;
}
#categoryChoose1{
	top: 126px;
}
#categoryChoose2{
	top: 161px;
}
.categoryChoose ul{
	list-style: none;
	margin: 0px;
	padding: 0px;
}
.categoryChoose ul li{
	padding: 3px 3px;
}
.categoryChoose ul li:HOVER {
	background-color: #cdcdcd;
}
.categoryChoose div.t{
	padding: 3px;
	color: #cbcbcb;
}
#nameSpan{
	color: red;
}
.spinner {
  margin: 22px auto 0px;
  text-align: center;
}
 
.spinner > div {
  width: 10px;
  height: 10px;
  background-color: rgb(0, 122, 251);
 
  border-radius: 100%;
  display: inline-block;
  -webkit-animation: bouncedelay 1.4s infinite ease-in-out;
  animation: bouncedelay 1.4s infinite ease-in-out;
  /* Prevent first frame from flickering when animation starts */
  -webkit-animation-fill-mode: both;
  animation-fill-mode: both;
}
 
.spinner .bounce1 {
  -webkit-animation-delay: -0.32s;
  animation-delay: -0.32s;
}
 
.spinner .bounce2 {
  -webkit-animation-delay: -0.16s;
  animation-delay: -0.16s;
}
 
@-webkit-keyframes bouncedelay {
  0%, 80%, 100% { -webkit-transform: scale(0.0) }
  40% { -webkit-transform: scale(1.0) }
}
 
@keyframes bouncedelay {
  0%, 80%, 100% {
    transform: scale(0.0);
    -webkit-transform: scale(0.0);
  } 40% {
    transform: scale(1.0);
    -webkit-transform: scale(1.0);
  }
}
#s_loading{
	position: absolute;
	top: 0px;
	left: 250px;
	right: 250px;
	text-align: center;
	font-family: 'Microsoft YaHei';
	font-size: 13px;
	z-index: 999;
	height: 60px;
	line-height: 60px;
	overflow: hidden;
	display: none;
}

#overrideTmpName{
	border: 1px solid #ddd;
	width: 80px;
	height: 20px;
	padding: 1px 20px 1px 5px;
}
#overrideTmpBtn{
	position: absolute;
	top: 1px;
	left: 84px;
	width: 22px;
	height: 22px;
	background: url("/mobilemode/images/mec/search-input_wev8.png") no-repeat;
	background-position: center 2px;
	cursor: pointer;
}
#overrideTmpSpan{
	color: red;
	margin-left: 5px;
	display: none;
}
#message {
	position: absolute;
	top: 0px;
	left: 250px;
	right: 250px;
	text-align: center;
	font-family: 'Microsoft YaHei';
	font-size: 13px;
	z-index: 999;
	height: 60px;
	padding-top: 20px;
	box-sizing: border-box;
	overflow: hidden;
	display: none;
}
#message.success{
	color: #007AFB;
}
#message.error{
	color: #F699B4;	
}
#message.fff{
	color: #fff;
}
.cbboxEntry1{
	width: 80px;
}
.cbboxEntry2{
	width: 100px;
}
.cbboxEntry1_8{
	width: 110px;
}
.cbboxEntry2_8{
	width: 200px;
}
.overrideTmpWrap{
	display:inline-block;
	position: absolute;
	top: -1px;
	left: 183px;
	display: none;
}
.overrideTmpWrap_8{
	left:310px;
}
</style>
<script type="text/javascript">
function preview(file){
	if(file.files && file.files[0]){
		var reader = new FileReader();
	   	reader.onload = function(evt){
			var result = evt.target.result;
			$("#previewDiv img").attr("src", result).show();
			$("#previewImg")[0].value = result;
	   	}
	   	reader.readAsDataURL(file.files[0]);
	}
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

function showLoading(){
	$("#s_loading").show();
}

function hideLoading(){
	$("#s_loading").hide();
}

function showMsg(msg, cn, t){
	var $msg = $("#message");
	$msg.html(msg);
	$msg.show();
	
	if(cn){
		$msg[0].className = "";
		$msg.addClass(cn);
	}
	
	if(t){
		setTimeout(function(){
			$msg.hide();
		}, t);
	}
}

function hideMsg(){
	var $msg = $("#message");
	$msg.hide();
}

function chooseTmp(){
	var $overrideTmp = $("#overrideTmp");
	var dlg = top.createTopDialog();//定义Dialog对象
	dlg.Model = true;
	dlg.Width = 900;//定义长度
	dlg.Height = 600;
	dlg.URL = "/mobilemode/setup/templateChoose.jsp?type=2&id=" + $overrideTmp.val();
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(127551,user.getLanguage())%>"; //选择现有模板
	dlg.show();
	dlg.onCloseCallbackFn=function(result){
		var id = result["id"];
		var name = result["name"];
		$overrideTmp.val(id);
		$("#overrideTmpName").val(name);
		$("#overrideTmpName").change();
		$("#overrideTmpSpan").hide();
	};
}

function onClose(){
	top.closeTopDialog();
}

function changeSaveType(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='saveType']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		if(objV == "2"){
			$("#overrideTmpWrap").show();
		}else{
			$("#overrideTmpWrap").hide();
		}
		
	},100);
}

function submitTmpToServer(){
	var $saveBtn = $("#okBtn");
	if(!$saveBtn.hasClass("disabled")){
		var flag = true;
		
		var $name = $("#name");
		if($name.val() == ""){
			$("#nameSpan").html("<%=SystemEnv.getHtmlLabelName(127552,user.getLanguage())%>");//请填写模板名称
			$name[0].focus();
			flag = false;
		}
		var saveType = $("input[name='saveType']:checked").val();
		if(saveType == "2"){
			var overrideTmp = $("#overrideTmp").val();
			if(overrideTmp == ""){
				$("#overrideTmpSpan").show();
				flag = false;
			}
		}
		if(flag){
			$saveBtn.addClass("disabled");
			var $form = $("#tmpForm");
			$form[0].action = jionActionUrl("com.weaver.formmodel.mobile.template.TemplateAction", "action=saveAsTmp");
			showLoading();
			$form.submit();
		}
	}
}

function submitTmpCallback(result){
	hideLoading();
	var status = result["status"];
	if(status == "1"){
		alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>"); //保存成功
		top.closeTopDialog();
	}else{
		var message = result["message"];
		showMsg("<%=SystemEnv.getHtmlLabelName(127553,user.getLanguage())%>" + message, "error", 10000); //存为模板时出现错误：
	}
}

$(document).ready(function(){
	$("#textArow1").click(function(e){
		$("#categoryChoose2").hide();
		$("#categoryChoose1").toggle();
		e.stopPropagation();
	});
	
	$("#textArow2").click(function(e){
		$("#categoryChoose1").hide();
		$("#categoryChoose2").toggle();
		e.stopPropagation();
	});
	
	$(".categoryChoose li").click(function(){
		var cid = $(this).closest(".categoryChoose").attr("value-for");
		$("#" + cid).val($(this).text());
	});
	
	$(document.body).click(function(){
		$(".categoryChoose").hide();
	});
	
	$("#okBtn").click(function(){
		submitTmpToServer();
	});
});
</script>
</head>
  
<body>
	<div id="s_loading">
		<div class="spinner">
		  <div class="bounce1"></div>
		  <div class="bounce2"></div>
		  <div class="bounce3"></div>
		</div>
	</div>
	<div id="message"></div>
	<div class="title">
		<div class="text">
			<div class="big"><%=SystemEnv.getHtmlLabelName(81788,user.getLanguage())%><!-- 移动建模 -->-<%=SystemEnv.getHtmlLabelName(127365,user.getLanguage())%><!-- 存为模板 --></div>
			<div class="small">Template</div>
		</div>
		
		<div class="button">
			<div id="okBtn"><%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%><!-- 保存 --></div>
		</div>
	</div>
	<div class="angle"></div>

	<iframe name="tmpFormFrame" style="display: none;"></iframe>
	<form target="tmpFormFrame" id="tmpForm" method="post">
	<input type="hidden" name="appHomepageId" value="<%=appHomepageId %>" />
	<table class="e8_tblForm">
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(28050,user.getLanguage())%><!-- 模板名称 --></td>
			<td class="e8_tblForm_field">
				<input type="text" class="textStyle" style="width:80%;" id="name" name="name" value="" onchange="checkInput('name');"/>
				<span id="nameSpan">
					<img align="absMiddle" src="/images/BacoError_wev8.gif" />
				</span>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(127554,user.getLanguage())%><!-- 行业分类 --></td>
			<td class="e8_tblForm_field">
				<div class="textArowWrap">
					<input type="text" class="textStyle" style="width:100%;" id="category" name="category" value="" placeholder="<%=SystemEnv.getHtmlLabelName(127555,user.getLanguage())%>"/> <!-- 如.医疗，教育，巡店，工程...等，你可以选择键入一个新的 或者 在已有中选择 -->
					<div class="textArow" id="textArow1"></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(127556,user.getLanguage())%><!-- 页面分类 --></td>
			<td class="e8_tblForm_field">
				<div class="textArowWrap">
					<input type="text" class="textStyle" style="width:100%;" id="category2" name="category2" value="" placeholder="<%=SystemEnv.getHtmlLabelName(127557,user.getLanguage())%>"/> <!-- 如.首页，列表，明细页面...等，你可以选择键入一个新的 或者 在已有中选择 -->
					<div class="textArow" id="textArow2"></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(19426,user.getLanguage())%><!-- 效果图 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(127558,user.getLanguage())%><!-- 用于展示模板效果 --></div></td><!-- 图标 -->
			<td class="e8_tblForm_field">
				<div id="previewDiv">
	            	<img style="display:none;"/>
	            	<input type="file" name="file" class="upLoadFile" accept="image/jpg,image/jpeg,image/png,image/gif" single="single" onchange="preview(this);">
	            </div>
	            <input type="hidden" name="previewImg" id="previewImg" value="">
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(127559,user.getLanguage())%><!-- 保存方式 --></td>
			<td class="e8_tblForm_field">
				<div style="position: relative;padding: 1px 0px;">
					<span class="cbboxEntry cbboxEntry1 cbboxEntry1_<%=user.getLanguage() %>">
						<input type="checkbox" name="saveType" value="1" onclick="changeSaveType(this);" checked="checked"/><span class="cbboxLabel"><%=SystemEnv.getHtmlLabelName(127560,user.getLanguage())%><!-- 新的模板 --></span>
					</span>
					<span class="cbboxEntry cbboxEntry2 cbboxEntry2_<%=user.getLanguage() %>">
						<input type="checkbox" name="saveType" value="2" onclick="changeSaveType(this);"/><span class="cbboxLabel"><%=SystemEnv.getHtmlLabelName(127561,user.getLanguage())%><!-- 覆盖现有模板 --></span>
					</span>
					<span id="overrideTmpWrap" class="overrideTmpWrap overrideTmpWrap_<%=user.getLanguage()%>">
						<input type="text" id="overrideTmpName" name="overrideTmpName" placeholder="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>" readonly="readonly" onchange="checkInput('overrideTmpName');"/><!-- 选择模板 -->
						<input type="hidden" id="overrideTmp" name="overrideTmp"/>
						<div id="overrideTmpBtn" onclick="chooseTmp();"></div>
						<span id="overrideTmpSpan">
							<%=SystemEnv.getHtmlLabelName(127508,user.getLanguage())%><!-- 请选择一个模板 -->
						</span>
						<span id="overrideTmpNameSpan">
							<img align="absMiddle" src="/images/BacoError_wev8.gif" />
						</span>
					</span>
				</div>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%><!-- 模板描述 --></td><!-- 描述 -->
			<td class="e8_tblForm_field">
				<textarea name="desc" id="desc" class="textareaStyle" style="font-family: 'Microsoft YaHei', Arial;width: 80%;height:50px;overflow:auto;"></textarea>
			</td>
		</tr>
	</table>
	</form>
	
	<div class="categoryChoose" id="categoryChoose1" value-for="category">
		<% if(cList.isEmpty()){%>
			<div class="t"><%=SystemEnv.getHtmlLabelName(127562,user.getLanguage())%><!-- 暂无分类选择，请在上方的文本框中输入 --></div>
		<% }else{ %>
			<ul>
			<% for(String c : cList){ %>
				<li><%=c %></li>
			<% } %>
			</ul>
		<% } %>
	</div>
	
	<div class="categoryChoose" id="categoryChoose2" value-for="category2">
		<% if(c2List.isEmpty()){%>
			<div class="t"><%=SystemEnv.getHtmlLabelName(127562,user.getLanguage())%><!-- 暂无分类选择，请在上方的文本框中输入 --></div>
		<% }else{ %>
			<ul>
			<% for(String c : c2List){ %>
				<li><%=c %></li>
			<% } %>
			</ul>
		<% } %>
	</div>
	
	<div class="div_bottom">
		<button type="button" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%><!-- 关闭 --></button>
	</div>
</body>
</html>
