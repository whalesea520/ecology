
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*" %>
<%User user = HrmUserVarify.getUser(request,response);%>
<html>
<head>
<title></title>
<META http-equiv="Content-Language" content="zh-cn">
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="generator" content="editplus">
<meta name="author" content="">
<meta name="keywords" content="">
<meta name="description" content="">
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<style>
.colorButtonShort{
	display:inline-block;
	border: 1px solid #ACA899;
	height: 10px;
	width: 23px;
	margin: 2px, 2px, 2px, 2px;
	overflow: hidden;
}
</style>
<script language="javascript">
var wpCurrentItem = null ;
var currentColor = null;

function initWebPalette() {
	var colorElements = new Array("00", "33", "66", "99", "cc", "ff") ;
	var colorRed = "ff" ;
	var colorGreen = "ff" ;
	var colorBlue = "ff" ;
	for (var r = 0; r < 18; r++) {
		if (r >= 0 && r <= 5) { colorRed = colorElements[5 - r] ; }
		if (r >= 6 && r <= 11) { colorRed = colorElements[r - 6] ; }
		if (r >= 12 && r <= 17) { colorRed = colorElements[17 - r] ; }
		for (var c = 0; c < 12; c++) {
			if (c >= 0 && c <= 5) { colorGreen = colorElements[c] ; }
			if (c >= 6 && c <= 11) { colorGreen = colorElements[5 - (c - 6)] ; }
			if (r >= 0 && r <= 5 && c >= 0 && c <= 5) { colorBlue = "ff" ; }
			if (r >= 0 && r <= 5 && c >= 6 && c <= 11) { colorBlue = "66" ; }
			if (r >= 6 && r <= 11 && c >= 0 && c <= 5) { colorBlue = "cc" ; }
			if (r >= 6 && r <= 11 && c >= 6 && c <= 11) { colorBlue = "33" ; }
			if (r >= 12 && r <= 17 && c >= 0 && c <= 5) { colorBlue = "99" ; }
			if (r >= 12 && r <= 17 && c >= 6 && c <= 11) { colorBlue = "00" ; }
			$($($($(webPaletteTable).children("tbody").children("tr")[r]).children("td")[c]).children()[0]).css("background-color", "#" + colorRed + colorGreen + colorBlue);
		}
	}
}

function wpOnMouseDown(el) {
	if (wpCurrentItem != null) {
		wpCurrentItem.style.backgroundColor = "transparent" ;
		wpCurrentItem.children[0].style.border = "1px solid #ACA899" ;
	}
	el.style.backgroundColor = "black" ;
	$(el).children()[0].style.border = "1px solid white" ;
	currentColor = $(el).children()[0].style.backgroundColor ;
	//colorValueText[0].innerText = el.children[0].style.backgroundColor ;

	//element.colorValue = el.children[0].style.backgroundColor ;
	//onchange.fire() ;
	wpCurrentItem = el ;
	
}

function okOnClick(){
	window.returnValue = (currentColor!=null) ? currentColor : "";
	window.close();
}

window.onunload = function(){
	okOnClick();
}
window.onload = function(){
	initWebPalette();
}
</script>
</head>

<body>
<table id="webPaletteTable" cellspacing="0" cellpadding="0" border="0" style="margin: 0px;" width="100%">
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
<tr>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
	<td onMouseDown="jscript: wpOnMouseDown(this);"><span class="colorButtonShort"></span></td>
</tr>
</table>
<div style="text-align:right"><button class="btn" onclick="javascript:okOnClick();" accesskey="O"><u>O</u>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></div>
</body>
</html>
