<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
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
	padding: 0px 10px 20px 10px;
	overflow: hidden;
	
}
#slide-typeset{
	line-height: 20px;
	margin-bottom: 15px;
	margin-left: 5px;
	margin-right: 5px;
	margin-top: 30px;
	position: relative;
}
.slide-local{
	height: 28px;
	line-height: 20px;
	min-height: 28px;
	position: relative;
}
.slide-upload{
	height: 28px;
	position: relative;
}
#file_path{
	-webkit-appearance: none;
	-webkit-box-shadow: rgba(0, 0, 0, 0.0745098) 0px 1px 1px 0px inset;
	-webkit-rtl-ordering: logical;
	-webkit-user-select: text;
	-webkit-writing-mode: horizontal-tb;
	background-color: rgb(255, 255, 255);
	border: 1px solid rgb(223, 223, 223);
	border-image-outset: 0px;
	border-image-repeat: stretch;
	border-image-slice: 100%;
	border-image-source: none;
	border-image-width: 1;
	box-shadow: rgba(0, 0, 0, 0.0745098) 0px 1px 1px 0px inset;
	box-sizing: border-box;
	color: rgb(0, 0, 0);
	cursor: auto;
	display: inline-block;
	font-family: 'Microsoft Yahei',Arial,Helvetica,sans-serif;
	font-size: 12px;
	height: 28px;
	letter-spacing: normal;
	line-height: 20px;
	margin-bottom: 0px;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	outline-color: rgb(0, 0, 0);
	outline-style: none;
	outline-width: 0px;
	padding-bottom: 1px;
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 1px;
	text-align: start;
	text-indent: 10px;
	text-shadow: none;
	text-transform: none;
	width: 254px;
	word-spacing: 0px;
	writing-mode: lr-tb;
	zoom: 1;
}
#uploadfile{
	position: absolute;
	margin-left: 140px;
	font-size: 20px;
	width: 200px;
	top: 0px;
	left: 0px;
	filter:alpha(opacity=0);
    opacity:0;
    cursor: pointer;
}
.slide-upload-div{
	background-color: rgb(93, 156, 236);
	color: rgb(255, 255, 255);
	cursor: pointer;
	display: inline-block;
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 12px;
	font-weight: bold;
	height: 28px;
	line-height: 28px;
	padding-bottom: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-top: 0px;
	margin-left: 4px;
	position: absolute;
	right: 0px;
}
.slide-op{
	height: 30px;
	line-height: 20px;
	margin-top: 30px;
	text-align: center;
}
.slide-opsave, .slide-oploading{
	background-color: rgb(93, 156, 236);
	border: none;
	color: rgb(255, 255, 255);
	display: inline-block;
	font-size: 14px;
	font-weight: bold;
	height: 30px;
	margin-bottom: 0px;
	margin-top: 0px;
	padding-bottom: 0px;
	padding-top: 0px;
	text-align: center;
	width: 325px;
}
.slide-opsave{
	line-height: 20px;
	cursor: pointer;
	background-color: rgb(93, 156, 236);
}
.slide-oploading{
	line-height: 30px;
	background-color: rgb(208, 212, 217);
}
#slide-warn{
	background-color: #F699B4;	
	border-bottom-color: rgba(0, 0, 0, 0);
	border-bottom-left-radius: 4px;
	border-bottom-right-radius: 4px;
	border-bottom-style: solid;
	border-bottom-width: 1px;
	border-image-outset: 0px;
	border-image-repeat: stretch;
	border-image-slice: 100%;
	border-image-source: none;
	border-image-width: 1;
	border-left-color: rgba(0, 0, 0, 0);
	border-left-style: solid;
	border-left-width: 1px;
	border-right-color: rgba(0, 0, 0, 0);
	border-right-style: solid;
	border-right-width: 1px;
	border-top-color: rgba(0, 0, 0, 0);
	border-top-left-radius: 4px;
	border-top-right-radius: 4px;
	border-top-style: solid;
	border-top-width: 1px;
	box-sizing: border-box;
	color: rgb(255, 255, 255);
	font-family: 'Microsoft Yahei', Arial, sans-serif;
	font-size: 12px;
	height: 30px;
	left: 22px;
	line-height: 30px;
	margin-bottom: 0px;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 0px;
	position: absolute;
	text-align: center;
	top: 3px;
	vertical-align: middle;
	width: 325px;
	z-index: 1000;
	zoom: 1;	
	display: none;
}
</style>

<script type="text/javascript">
function returnResult(){
	if(top && top.callTopDlgHookFn){
		var result = {
			"file_path" : $("#file_path").val()
		};
		top.callTopDlgHookFn(result);
	}
	
	onClose();
}

function onClose(){
	if(top && top.closeTopDialog){
		top.closeTopDialog();
	}else{
		window.close();
	}
}

function preview(){
	var uploadfile = document.getElementById("uploadfile");
	if(uploadfile.files && uploadfile.files[0]){ 
		var reader = new FileReader();  
    	reader.onload = function(evt){
    		var filefullname = uploadfile.files[0].name;
    		$("#file_path").val(filefullname);
    		$("#file_path").attr("value", filefullname);
    	}  
    	reader.readAsDataURL(uploadfile.files[0]);
    }
}

function doUpload(){
	var errorMsg = "";
	
	var uploadfile = document.getElementById("uploadfile");
	if(uploadfile.value == ""){
		errorMsg = "<%=SystemEnv.getHtmlLabelName(127672,user.getLanguage())%>";  //请先选择文件
	}
	
	if(errorMsg == ""){
		if(uploadfile.value != ""){
			$("#slide-opsave").hide();
			$("#slide-oploading").show();
			setTimeout(function(){	//iframe 准备
				$("#slide-form").attr("action", jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUploadAction", "action=file"));
				$("#slide-form").submit();
			}, 500);
		}
	}
	
	if(errorMsg != ""){
		var $slideWarn = $("#slide-warn");
		$slideWarn.html(errorMsg);
		$slideWarn.fadeIn(1000, function(){
			$(this).fadeOut(3000);
		});
	}
}

function fileUploaded(filepath){
	$("#slide-opsave").show();
	$("#slide-oploading").hide();
	$("#file_path").val(filepath);
	returnResult();
}
</script>

</head>
<body>
	<div id="slide-warn"></div>
	
	<iframe name="slide-iframe" style="display: none"></iframe>
	
	<form id="slide-form" target="slide-iframe" enctype="multipart/form-data" method="POST" action="" style="margin: 0px; padding: 0px;">
	<div id="slide-typeset">
		<div id="slide-unserver">
			<div class="slide-local">
				<div class="slide-upload">
					<input type="text" id="file_path" readonly="readonly"/>
					<div class="slide-upload-div"><%=SystemEnv.getHtmlLabelName(22822,user.getLanguage())%></div>   <!-- 浏览 -->
					<input type="file" id="uploadfile" name="up-file" value="" onchange="preview();">
				</div>
			</div>
		</div>
		
		<div class="slide-op">
			<input type="button" id="slide-opsave" class="slide-opsave" value="<%=SystemEnv.getHtmlLabelName(127673,user.getLanguage())%>" onclick="doUpload();"> <!-- 文件上传 -->
			<span id="slide-oploading" class="slide-oploading" style="display: none;"><%=SystemEnv.getHtmlLabelName(127674,user.getLanguage())%><!-- 上传中... --><span>
		</div>
	</div>
	</form>
</body>
</html>
