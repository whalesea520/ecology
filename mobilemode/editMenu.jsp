<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.menu.MenuManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String v = MenuManager.getMenuXmlContent();	
%>
<!DOCTYPE HTML>
<html>
<head>
<title>移动建模-菜单编辑</title>
<script src="/formmode/js/codemirror/lib/codemirror_wev8.js"></script>
<link rel="stylesheet" href="/formmode/js/codemirror/lib/codemirror_wev8.css"/>
<script src="/formmode/js/codemirror/mode/javascript/javascript_wev8.js"></script>
<script src="/formmode/js/codemirror/mode/xml/xml_wev8.js"></script>
<script src="/formmode/js/codemirror/mode/css/css_wev8.js"></script>
<script src="/formmode/js/codemirror/mode/htmlmixed/htmlmixed_wev8.js"></script>
<style>
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
		overflow: hidden;
	}
	.CodeMirror{
		font-size: 12px;
		line-height: 1.5em;
		border-bottom: 1px solid #DADADA;
		opacity: 0;
	}
	#message{
		height: 35px;
		position: absolute;
		top: 0px;
		left: 250px;
		right: 250px;
		text-align: center;
		line-height: 35px;
		color: #fff;
		font-family: 'Microsoft YaHei';
		font-size: 13px;
		border-bottom-right-radius:8px;
		border-bottom-left-radius:8px;
		-webkit-transition: -webkit-transform 0.3s;
		transition: transform 0.3s;
		-webkit-transform: translate3d(0, -100%, 0);
		transform: translate3d(0, -100%, 0);
	}
	#message.show{
		visibility: visible;
		-webkit-transform: translate3d(0, 0, 0);
		transform: translate3d(0, 0, 0);
	}
	#message.success{
		background-color: #56a845;
	}
	#message.error{
		background-color: #F699B4;	
	}
	.title{
		border-bottom: 1px solid #DADADA;
		overflow: hidden;
		padding: 0px 10px;
		font-family: 'Microsoft YaHei';
		height: 60px;
		overflow: hidden;
	}
	.text{
		float: left;
		background: url("/formmode/images/appIconRounded_wev8.png") no-repeat;
		padding-left: 46px;
		margin-top: 10px;
	}
	.text .big{
		font-size: 18px;
		color: #333;
	}
	.text .small{
		font-size: 12px;
		color: #AFAFAF;
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
</style>
<script type="text/javascript">
	var editor;
	$(document).ready(function ($) {
		editor = CodeMirror.fromTextArea(document.getElementById("content"), {
			lineNumbers: true,
			indentUnit: 4,
			mode: "xml"
		});
		
		var h = $(document.body).height() - $("#menu-title").outerHeight(true) - 1;
		$(".CodeMirror").css({
			"height": h + "px",
			"opacity": "1"
		});
		
		$("#okBtn").click(onOK);
	});
	function getContent(){
		return editor.getValue();
	}
	
	var isSubmiting = false;
	function onOK(){
		if(!isSubmiting){
			document.getElementById("_content").value = getContent();
			$("#contentForm").attr("action", jionActionUrl("com.weaver.formmodel.mobile.menu.servlet.MenuAction", "action=saveMenuXmlContent"));
			$("#contentForm").submit();
			$("#okBtn").addClass("disabled");
			isSubmiting = true;
		}
	}
	
	function serverCallback(result){
		isSubmiting = false;
		$("#okBtn").removeClass("disabled");
		var $message = $("#message");
		$message[0].className = "";
		
		var status = result["status"];
		if(status == "1"){
			$message.addClass("success");
			$message.html("保存成功");	
		}else{
			$message.addClass("error");
			$message.html("保存失败");
		}
		
		$message.addClass("show");
		setTimeout(function(){
			$message.removeClass("show");
		}, 2000);
	}
</script>
</head>
<body>
<div id="message">
	保存成功
</div>
<div id="menu-title" class="title">
	<div class="text">
		<div class="big">移动建模-菜单编辑</div>
		<div class="small">Edit Menu</div>
	</div>
	
	<div class="button">
		<div id="okBtn">保存</div>
	</div>
</div>
<div class="angle"></div>
<iframe name="contentFrame" style="display: none;"></iframe>
<form id="contentForm" action="" method="post" target="contentFrame" style="display: none;">
	<input type="hidden" name="_content" id="_content"/>
</form>
<textarea id="content" name="content"><%=v %></textarea>
</body>
</html>
