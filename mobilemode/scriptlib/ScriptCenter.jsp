<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/mobilemode/init.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>脚本库</title>
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
		height: 500px;
		border-bottom: 1px solid #eee;
	}
</style>
<script type="text/javascript">
	var editor;
	$(document).ready(function ($) {
		$("#scriptCode").val(top.scriptCodeFun());
		editor = CodeMirror.fromTextArea(document.getElementById("scriptCode"), {
			lineNumbers: true,
			indentUnit: 4,
			mode: "javascript"
		});
		
	});
	function getScriptCode(){
		return editor.getValue();
	}
	
	function returnResult(){
		if(top && top.callTopDlgHookFn){
			var result = {
				"scriptCode" : getScriptCode()
			};
			top.callTopDlgHookFn(result);
		}
		onClose();
	}
	
	function onOK(){
		returnResult();
	}
	
	function onClose(){
		top.closeTopDialog();
	}
</script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83446,user.getLanguage())+",javascript:onOK(),_top} " ;  //确定
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32694,user.getLanguage())+",javascript:onClose(),_top} " ;  //取消
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<textarea id="scriptCode" name="scriptCode"></textarea>
</body>
</html>
