
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
String height = Util.null2String(request.getParameter("height"));
%>
<html>
<head>
	<title>代码编辑</title>
	<script src="/formmode/js/codemirror/lib/codemirror_wev8.js"></script>
	<link rel="stylesheet" href="/formmode/js/codemirror/lib/codemirror_wev8.css"/>
	<script src="/formmode/js/codemirror/mode/javascript/javascript_wev8.js"></script>
	<script src="/formmode/js/codemirror/mode/xml/xml_wev8.js"></script>
	<script src="/formmode/js/codemirror/mode/css/css_wev8.js"></script>
	<script src="/formmode/js/codemirror/mode/htmlmixed/htmlmixed_wev8.js"></script>
	<script src="/formmode/js/jquery/form/jquery.form_wev8.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" language="javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" language="javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
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
		height: <%=height%>px;
		border-top: 1px solid #ddd;
		border-bottom: 1px solid #eee;
	}
	</style>
<script type="text/javascript">
var editor;
$(document).ready(function ($) {
	document.getElementById("code").value = parent.getSource();
	editor = CodeMirror.fromTextArea(document.getElementById("code"), {
		lineNumbers: true,
		indentUnit: 4,
		mode: "htmlmixed"
	});
	
});
function getCode(){
	return editor.getValue();
}
</script>
</head>
<body>
	<textarea id="code" name="code"></textarea>
</body>
</html>
