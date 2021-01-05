
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String pic_type = Util.null2String(request.getParameter("pic_type"));
if(pic_type.equals("")){
	pic_type = "0";
}
String pic_path = Util.null2String(request.getParameter("pic_path"));
%>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" language="javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" language="javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
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
#slide-type{
	box-sizing: border-box;
	color: rgb(51, 51, 51);
	display: block;
	font-size: 12px;
	height: 17px;
	line-height: 17px;
	margin-bottom: 18px;
	margin-left: 5px;
	margin-right: 5px;
	margin-top: 18px;
}
#slide-type span{
	color: rgb(164, 169, 174);
	cursor: pointer;
	display: inline-block;
	font-size: 12px;
	height: 17px;
	line-height: 17px;
}
#slide-type span.local{
	border-right: 1px solid rgb(164, 169, 174);
	padding-right: 13px;
}
#slide-type span.net{
	border-right: 1px solid rgb(164, 169, 174);
	padding-left: 13px;
	padding-right: 13px;
}
#slide-type span.server{
	padding-left: 13px;
	padding-right: 13px;
}
#slide-type span.chosed{
	color: rgb(93, 156, 236);
	font-weight: bold;
}
#slide-typeset{
	line-height: 20px;
	margin-bottom: 0px;
	margin-left: 5px;
	margin-right: 5px;
	margin-top: 0px;
	position: relative;
}
.slide-local, .slide-net{
	height: 30px;
	line-height: 20px;
	min-height: 30px;
	position: relative;
}
.slide-upload{
	height: 30px;
	position: relative;
}

#uploadfile{
	position: absolute;
	margin-left:-115px;
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
	height: 30px;
	line-height: 30px;
	padding-bottom: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-top: 0px;
}

.slide-upload-tip{
	color: rgb(164, 169, 174);
	display: inline-block;
	font-size: 12px;
	height: 17px;
	line-height: 17px;
}

.slide-netlabel{
	color: rgb(164, 169, 174);
	font-size: 12px;
	height: 26px;
	line-height: 26px;
	min-width: 100px;
	position: absolute;
	width: 100px;
}
.slide-netinput{
	box-sizing: border-box;
	color: rgb(51, 51, 51);
	font-size: 12px;
	height: 28px;
	line-height: 17px;
	padding-left: 55px;
	padding-right: 4px;
	position: relative;
}
#net-address {
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
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 12px;
	height: 28px;
	letter-spacing: normal;
	line-height: 17px;
	margin-bottom: 0px;
	margin-left: 5px;
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
	width: 312px;
	word-spacing: 0px;
	writing-mode: lr-tb;
	zoom: 1;
}

.slide-preview{
	background: url("/mobilemode/images/mec/pic-icon2_wev8.png?3") no-repeat;
	border: 1px solid rgb(255, 255, 255);
	color: rgb(51, 51, 51);
	/*height: 149.5px;*/
	height: 185px;
	line-height: 20px;
	margin-bottom: 20px;
	margin-top: 20px;
	overflow-x: hidden;
	overflow-y: hidden;
	position: relative;
	background-size: 100%;
}

.slide-op{
	height: 30px;
	line-height: 20px;
	margin-top: 20px;
	text-align: center;
}

.slide-opsave, .slide-opcanel{
	background-color: rgb(93, 156, 236);
	border: none;
	color: rgb(255, 255, 255);
	cursor: pointer;
	display: inline-block;
	font-size: 14px;
	font-weight: bold;
	height: 30px;
	line-height: 20px;
	margin-bottom: 0px;
	margin-left: 11px;
	margin-right: 11px;
	margin-top: 0px;
	padding-bottom: 0px;
	padding-top: 0px;
	text-align: center;
	width: 70px;
}
.slide-opsave{
	background-color: rgb(93, 156, 236);
}
.slide-opcanel{
	background-color: rgb(208, 212, 217);
}
#slide-process{
	background-color: rgb(2, 2, 2);
	background-image: url("/mobilemode/images/mec/loading_bar_wev8.gif");
	background-position: 50% 45%;
	background-size: auto;
	background-repeat: no-repeat;
	color: rgb(255, 255, 255);
	display: block;
	font-size: 12px;
	height: 100%;
	line-height: 185px;
	margin-bottom: 0px;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	opacity: 0.4000000059604645;
	position: absolute;
	text-align: center;
	top: 0px;
	left: 0px;
	width: 100%;
	z-index: 9999;
}
#previewImg{
	width: 100%;
	height: 100%;
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
	width: 302px;
	z-index: 1000;
	zoom: 1;	
	display: none;
}
#slide-unserver{
	height: 237px;
}
.slide-server{
	border: 1px solid rgb(208, 212, 217);
	height: 235px;
	position: relative;
}
.slide-server .slide-server-up{
	height: 30px;
	background: url("/mobilemode/images/mec/appicns_dock_arrow_wev8.png") no-repeat;
	background-position: calc(50% - 35px) 5px;
	background-color: rgb(208, 212, 217);
	color: #fff;
	line-height: 30px;
	text-align: center;
	font-size: 13px;
	cursor: pointer;
	
}
.slide-server-canup{
	border: 1px solid rgb(93, 156, 236);
}
.slide-server-canup .slide-server-up{
	background-color: rgb(93, 156, 236);
}

.slide-server-content{
	height: 205px;
	overflow: auto;
	line-height: normal;
}
.slide-server-content ul{
	list-style: none;
	padding: 7px 5px 5px 7px;
	overflow: hidden;
}
.slide-server-content ul li{
	float: left;
	margin: 5px;
	cursor: pointer;
}

.slide-server-content ul li .slide-server-img{
	border: 2px solid #ccc;
	border-radius:3px;
	padding: 2px;
	width: 54px;
	height: 54px;
}

.slide-server-content ul li:HOVER .slide-server-img{
	border: 2px solid rgb(93, 156, 236);
}

.slide-server-content ul li .slide-server-img img{
	width: 100%;
	height: 100%;
	border-radius:3px;
}

.slide-server-content ul li.selected .slide-server-img{
	border: 2px solid rgb(93, 156, 236);
}
.slide-server-content ul li .slide-server-label{
	padding: 2px;
	width: 56px;
	text-align: center;
	color: rgb(164, 169, 174);
	font-size: 11px;
	text-overflow: ellipsis;
	overflow: hidden;
	white-space:nowrap;
}
#serverLoading{
	background: url("/images/loading2_wev8.gif") no-repeat;
	background-position: 6px center;
	position: absolute;
	left:73px;
	top:113px;
    background-color:#ffffff;
    padding:8px 8px 8px 28px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display: none;
}
</style>

<script type="text/javascript">
var currServerPath = "";

function getParentServerPath(path){
	if(!path || path == ""){
		return "";
	}
	
	path = path.substring(0, path.lastIndexOf("/"));
	if(path.indexOf("/mobilemode/piclibrary") != 0){
		return "";
	}
	
	return path;	
}

function isRootServerPath(path){
	return path == "" || (path == "/mobilemode/piclibrary" && path.indexOf("/mobilemode/piclibrary") == 0);
}

$(function() {
	/*
	var previewImg = document.getElementById("previewImg");
	previewImg.onload = function(){
		$("#slide-process").hide();
	};*/
	
	if("<%=pic_type%>" == "2"){
		currServerPath = getParentServerPath("<%=pic_path%>");
	}
	loadServerPic(currServerPath);
	
	$("#slide-server .slide-server-up").bind("click", function(){
		if(!isRootServerPath(currServerPath)){
			var path = getParentServerPath(currServerPath);
			loadServerPic(path);
		}
	});
	
});

function fiexdUndefinedVal(v, defV){
	if(typeof(v) == "undefined" || v == null){
		if(defV){
			return defV;
		}else{
			return "";
		}
	}
	return v;
}

function returnResult(){
	if(top && top.callTopDlgHookFn){
		var result = {
			"pic_type" : getSlideTypeV(),
			"pic_path" : $("#pic_path").val()
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
	var previewImg = document.getElementById("previewImg");
	var slidePreview = document.getElementById("slide-preview");
	var typeV = getSlideTypeV();
	if(typeV == "0"){	//本地图片
		var uploadfile = document.getElementById("uploadfile");
		if(uploadfile.files && uploadfile.files[0]){ 
			$(previewImg).show();
			var reader = new FileReader();  
	    	reader.onload = function(evt){previewImg.src = evt.target.result;}  
	    	reader.readAsDataURL(uploadfile.files[0]);
	    }else{
	    	$(previewImg).hide();
	    	uploadfile.select();
	    	slidePreview.focus();	//ie9 hack
	    	var src = document.selection && document.selection.createRange().text || ''; 
			slidePreview.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+src+"')";
			//previewImg.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src = src;  
	    }
	}else if(typeV == "1"){	//网址获取
		var netAddress = document.getElementById("net-address");
		if(netAddress.value != ""){
			slidePreview.style.filter = "";
			$(previewImg).show();
			previewImg.src = netAddress.value;  
		}
	}
}

function doUpload(){
	var errorMsg = "";
	var typeV = getSlideTypeV();
	
	var $pic_path = $("#pic_path");
	if(typeV == "0"){	//本地图片
		var uploadfile = document.getElementById("uploadfile");
		if(uploadfile.value == ""){
			if($pic_path.val() == ""){
				errorMsg = "<%=SystemEnv.getHtmlLabelName(24502,user.getLanguage())%>";//请选择图片
			}
		}else if(!uploadfile.value.match(/.jpg|.gif|.png|.bmp/i)){
			errorMsg = "<%=SystemEnv.getHtmlLabelName(127426,user.getLanguage())%>";//文件格式错误，请选择一张图片
		}
		
		if(errorMsg == ""){
			if(uploadfile.value != ""){
				$("#slide-process").show();
				$("#slide-opsave").attr("disabled", "disabled");
				setTimeout(function(){	//iframe 准备
					$("#slide-form").attr("action", jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUploadAction", "action=image2"));
					$("#slide-form").submit();
				}, 500);
			}else{
				returnResult();
			}
		}
	}else if(typeV == "1"){	//网址获取
		var netAddress = document.getElementById("net-address");
		if(netAddress.value == ""){
			errorMsg = "<%=SystemEnv.getHtmlLabelName(127427,user.getLanguage())%>";//请填写图片地址
		}
		if(errorMsg == ""){
			$pic_path.val(netAddress.value);
			returnResult();
		}
	}else if(typeV == "2"){	//图片库
		var $selLi = $(".slide-server-content > ul > li.selected");
		if($selLi.length == 0 && $pic_path.val() == ""){
			errorMsg = "<%=SystemEnv.getHtmlLabelName(127428,user.getLanguage())%>";//请选择一张图片
		}
		if(errorMsg == ""){
			if($selLi.length > 0){
				$pic_path.val($selLi.attr("fileServerPath"));
			}
			returnResult();
		}
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(127429,user.getLanguage())%>");//未知的图片来源
	}
	
	if(errorMsg != ""){
		var $slideWarn = $("#slide-warn");
		$slideWarn.html(errorMsg);
		$slideWarn.fadeIn(1000, function(){
			$(this).fadeOut(3000);
		});
	}
}

function uploaded(picpath){
	$("#slide-opsave").removeAttr("disabled");
	$("#slide-process").hide();
	$("#pic_path").val(picpath);
	returnResult();
}

var pathArr = new Array();
function loadServerPic(path){
	$("#serverLoading").show();
	var url = "/mobilemode/picsetAction.jsp?action=getServerPicDatas&path=" + encodeURIComponent(path);
	FormmodeUtil.doAjaxDataLoad(url, function(data){
		$("#serverLoading").hide();
		var status = data["status"];
		if(status != "1"){
			alert("<%=SystemEnv.getHtmlLabelName(127430,user.getLanguage())%>");//加载图片库时出现错误!
			return;	
		}
		
		currServerPath = data["path"];
		
		var files = data["files"];
		
		var $ul = $(".slide-server-content > ul");
		$ul.children("li").remove();
		
		for(var i = 0; i < files.length; i++){
			var file = files[i];
			
			var fileServerPath = file["fileServerPath"];
			var isFolder = file["isFolder"];
			var filename = file["filename"];
			
			var $li = $("<li></li>");
			
			var imgPath = isFolder ? "/mobilemode/images/mec/folderopened_yellow_wev8.png" : fileServerPath;
			var innerHtml = "<div class=\"slide-server-img\">"
							+ "<img src=\""+imgPath+"\" />"
						  + "</div>"
						  + "<div class=\"slide-server-label\">"+filename+"</div>";
			
			$li.html(innerHtml);
			$li.attr("fileServerPath", fileServerPath);
			
			$ul.append($li);
			
			$li.click(isFolder ? function(){
				loadServerPic($(this).attr("fileServerPath"));
			} : function(){
				if(!$(this).hasClass("selected")){
					$(this).siblings().removeClass("selected");
					$(this).addClass("selected");
				}
			});
		}
		
		if(!isRootServerPath(currServerPath)){
			$("#slide-server").addClass("slide-server-canup");
		}else{
			$("#slide-server").removeClass("slide-server-canup");
		}
		
		if("<%=pic_type%>" == "2"){
			$ul.children("li[fileServerPath='<%=pic_path%>']").addClass("selected");
		}
		
		initOrResetScroll();
	});
}

// 服务端验证：图片格式
function unload(){
	$("#slide-process").hide();
	$("#slide-opsave").removeAttr("disabled");
	
	var errorMsg = "<%=SystemEnv.getHtmlLabelName(127426,user.getLanguage())%>";//文件格式错误，请选择一张图片
	var $slideWarn = $("#slide-warn");
	$slideWarn.html(errorMsg);
	$slideWarn.fadeIn(1000, function(){
		$(this).fadeOut(3000);
	});
}

</script>

</head>
<body>
	<input type="hidden" id="pic_path" value="<%=pic_path %>"/>
	
	<div id="slide-warn"></div>
	<div id="slide-type">
		<span class="local" typeV="0"><%=SystemEnv.getHtmlLabelName(125077,user.getLanguage())%><!-- 本地图片 --></span>
		<span class="net" typeV="1"><%=SystemEnv.getHtmlLabelName(125078,user.getLanguage())%><!-- 网址获取 --></span>
		<span class="server" typeV="2"><%=SystemEnv.getHtmlLabelName(127442,user.getLanguage())%><!-- 图片库 --></span>
	</div>
	
	<iframe name="slide-iframe" style="display: none"></iframe>
	
	<form id="slide-form" target="slide-iframe" enctype="multipart/form-data" method="POST" action="" style="margin: 0px; padding: 0px;">
	<div id="slide-typeset">
		<div id="slide-unserver" style="display: none;">
			<div class="slide-local" style="display: none;">
				<div class="slide-upload">
					<input type="file" id="uploadfile" name="up-file" accept="image/jpeg,image/png,image/jpg" value="上传图片" onchange="preview();">
					<div class="slide-upload-div"><%=SystemEnv.getHtmlLabelName(125080,user.getLanguage())%><!-- 选择图片 --></div>
					<div class="slide-upload-tip"><%=SystemEnv.getHtmlLabelName(125081,user.getLanguage())%><!-- 建议大小尽量小于1M，尺寸640x320 --></div>
				</div>
			</div>
			
			<div class="slide-net" style="display: none;">
				<div class="slide-netlabel"><%=SystemEnv.getHtmlLabelName(125079,user.getLanguage())%><!-- 图片地址 --></div>
				<div class="slide-netinput"><input type="text" id="net-address" name="net-address" onchange="preview();" value="<%=pic_path %>"></div>
			</div>
			
			<div class="slide-preview" id="slide-preview">
				<img id="previewImg" <%if(pic_path.trim().equals("")){%> style="display: none;" <%}else{%> src="<%=pic_path %>" <%}%>/>
				<div class="slide-process" id="slide-process" style="display: none;"><%=SystemEnv.getHtmlLabelName(127443,user.getLanguage())%><!-- 上传中 --></div>
			</div>
		</div>
		
		<div id="slide-server" class="slide-server" style="display: none;">
			<div class="slide-server-up"><%=SystemEnv.getHtmlLabelName(15317,user.getLanguage())%><!-- 上一级 --></div>
			<div class="slide-server-content">
				<ul>
					<!-- 
					<li>
						<div class="slide-server-img">
							<img src="/mobilemode/images/mec/folderopened_yellow_wev8.png" />
						</div>
						<div class="slide-server-label">小图标122222222222222222</div>
					</li>
					 -->
				</ul>
			</div>
			<div id="serverLoading"><%=SystemEnv.getHtmlLabelName(82275,user.getLanguage())%><!-- 数据加载中，请稍候... --></div>
		</div>
		
		<div class="slide-op">
			<input type="button" id="slide-opsave" class="slide-opsave" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" onclick="doUpload();"><!-- 确定 -->
			<input type="button" id="slide-opcanel" class="slide-opcanel" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" onclick="onClose();"><!-- 取消 -->
		</div>
	</div>
	</form>
	
	<script type="text/javascript">
		
		function getSlideTypeV(){
			return $("#slide-type span.chosed").attr("typeV");	
		}
		
		var $serverContentScroll = null;
		function initOrResetScroll(){
			if($serverContentScroll == null){
				$serverContentScroll = $(".slide-server-content").niceScroll({cursorcolor:"#aaa"});
			}else{
				$serverContentScroll.resize();
			}
		}
		
		function slideTypeShowOrHide(){
			var typeV = getSlideTypeV();
			var $slideUnserver = $("#slide-unserver");
			var $slideServer = $("#slide-server");
			if(typeV == "2"){
				$slideUnserver.hide();
				$slideServer.show();
				initOrResetScroll();
			}else{
				$slideServer.hide();
				$slideUnserver.show();
				var $slideLocal = $("#slide-typeset .slide-local");
				var $slideNet = $("#slide-typeset .slide-net");
				$slideLocal.hide();
				$slideNet.hide();
				typeV == "0" ? $slideLocal.show() : $slideNet.show();
			}
		}

		$("#slide-type span[typeV='<%=pic_type%>']").addClass("chosed");
		slideTypeShowOrHide();
		
		$("#slide-type span").click(function(){
			if(!$(this).hasClass("chosed")){
				$("#slide-type span").removeClass("chosed");
				$(this).addClass("chosed");
				slideTypeShowOrHide();
			}
		});
	</script>
</body>
</html>
