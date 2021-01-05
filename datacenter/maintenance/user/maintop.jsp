<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<head>
<title>泛微协同商务系统(Weaver ecology)</title>
<link rel="stylesheet" href="/css/frame.css" type="text/css">
</head>

<SCRIPT language=javascript>
function mnToggleleft(){
	var f = window.top.MainBottom;
	if (f != null) {
		var c = f.cols;
		if (c == "0,*") 
			{f.cols = "146,*"; LeftHideShow.src = "/images_frame/dh/BP_Hide.gif"; LeftHideShow.title = "隐藏"}	
		else 
			{ f.cols = "0,*"; LeftHideShow.src = "/images_frame/dh/BP_Show.gif"; LeftHideShow.title = "显示"}
	}
}
function mnToggletop(){
	var f = window.top.Main;
	if (f != null) {
		var c = f.rows;
		if (c == "0,*") 
			{f.rows = "125,*"; TopHideShow.src = "/images_frame/dh/BP2_Hide.gif"; TopHideShow.title = "隐藏"}	
		else 
			{ f.rows = "0,*"; TopHideShow.src = "/images_frame/dh/BP2_Show.gif"; TopHideShow.title = "显示"}
	}
}
</SCRIPT>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="23" height="32"><img src="/images_frame/middle_round1.gif"></td>
    <td background="/images_frame/middle_bg2.gif" style="PADDING-TOP: 3px" vAlign=top>
    <IMG id=TopHideShow  title=隐藏 style="CURSOR: hand" onclick=mnToggletop() src="/images_frame/dh/BP2_Hide.gif"></td>
     <td background="/images_frame/middle_bg2.gif"  width=232 style="PADDING-TOP: -3px" vAlign=top> 
       &nbsp;
	</td>
    <td width="29"><img src="/images_frame/middle_round2.gif"></td>
  </tr>
</table>
</body>


</html>