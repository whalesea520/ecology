<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%
BaseBean baseBean = new BaseBean();
String checkdata = baseBean.getPropValue("upgradesetting","checkdata");//是否检查data目录
String questionrepair  = baseBean.getPropValue("upgradesetting","questionrepair");//是否自动执行修复问题的方法
%>
<html>
<head>
<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function(){
	wuiform.init();
});
</script>
<style type="text/css">、
*{		
	font-family:"微软雅黑"!important; 
}
a{
	text-decoration: none!important;
	color:#929393; 
}

table.ListStyle td a:link{
	color:#929393; 
}

a:hover{
	color:red!important;
}

body{
	height:100%;
	width:100%;
}
#projectpath {
	width:650px;
}


/*For Button*/
BUTTON.btn { 	
	border:none;BACKGROUND: url(button/btn_wev8.png) no-repeat;color:#333;WIDTH: 116px;height:23px;text-align:left;cursor:pointer;padding-left:10px;padding-top:2px;margin-right:5px;
}

BUTTON.Browser {
	BACKGROUND-IMAGE: url(/wui/theme/ecology7/skins/default/general/browser_wev8.png)!important;width:16px;
}
BUTTON.Clock {
	BACKGROUND-IMAGE: url(general/calendar_wev8.png)!important;WIDTH:16px!important;
}
BUTTON.Calendar {
	BACKGROUND-IMAGE: url(general/calendar_wev8.png)!important;WIDTH:16px!important;
}
BUTTON.btnFavorite {
	BACKGROUND-IMAGE: url(general/fav_wev8.png)!important;
	background-position:center center;
}
BUTTON.btnHelp {
	BACKGROUND-IMAGE: url(general/help_wev8.png)!important;
	background-position:center center;
}


/*For Toptitle*/
.TopTitle{ 
	/*BORDER-bottom: #e7e7e7 1px solid;*/
	/*BACKGROUND:url(general/title-bg_wev8.png) repeat-x;*/
	height:28px; 
	
	border:#8CC7CF 1px solid;
	background:#B1D4D9 url(general/title-bg_wev8.jpg) repeat-x;;
	
}
DIV.TopTitle TD {
	COLOR: #000000;
}
#divshowreceivied{
	display:none;
}



/*for table shadow*/
TABLE.Shadow {
	/*border: 1px solid  #d4dae3;*/
	border-collapse:collapse;
	width:100% ;
	height:100% ;
}

TABLE.Shadow  td{
	padding:0px;
}



/**************************************/
/*           斑马线表格              */
/**************************************/
TABLE.ListStyle {/*表体*/
	width:"100%" ;
	margin:10px 0pt 15px;
	width: 100%;
	text-align: left;
}

/*表链接*/
TABLE.ListStyle tr{
	height:40px;
}

TABLE.ListStyle td{
	height:40px !important;
}

TABLE.ListStyle th{
	height:40px;
}
/*表头 TH*/
TABLE.ListStyle TR.HeaderForXtalbe TH,TABLE.ListStyle TR.header TH,TABLE.ListStyle TR.header TD  {
	height:40px !important;
	padding: 5px 5px 5px 12px;
	cursor: pointer;
	/*color: #4f6b72;
    background-color:#E3E1E2;*/
    color:#000;
    background-color:#fff;
    font-weight:bold;
    border-bottom:3px solid #B7E0FE;
}


/* add by bpf 2013-10-30 start*/
.operHoverSpan{
	height:100%;display:-moz-inline-box;display:inline-block;color:white !important;padding-left:5px;padding-right:5px;
}
.operHover_hand{
	cursor:pointer;
}
.operHoverSpan_hover{
	background-color:#5978A4;
}

.operHoverSpan a{
	text-decoration: none!important;
	color:white!important;
}

.operHoverSpan a:hover{
	color:white!important;
}
/* add by bpf 2013-10-30 end*/


/*表体*/
TABLE.ListStyle tbody tr td {
	color: #929393;
	padding: 5px 5px 5px 12px;
	vertical-align: top;
	border-bottom:1px solid #DADADA;
}

/**/
TABLE.ListStyle TR.DataDark TD {
	BACKGROUND-COLOR:#F5FAFA;
	color:#4f6b72;
}
TABLE.ListStyle TR.DataLight TD {
	BACKGROUND-COLOR: #FFFFFF ;
	color: #4f6b72;
}


/*先中后的情况*/
.TABLE .ListStyle TR.Selected TD {
	background-color:#DEF0FF;
	color:#000;
	height:38px;
}

.TABLE .ListStyle TR.Selected TD a {
	color:#000;
}

.TABLE.ListStyle TR.Selected td{
	/*color:white;background: #B1D4D9;*/
	
}
/*
.TABLE.ListStyle TR.Selected A{
	color:white!important;
}

.TABLE.ListStyle TR.Selected a:hover{
	text-decoration:underline!important;
}
*/
/*排序上下箭头*/
.xTable_order{
	font-family:Webdings!important;
	overflow:hidden;
	padding-left:5px;
}

.xTable_order_desc{
	color:#2877A2;
}


.xTable_order_asc{
	color:#D79D57;
}


/*=============for Browser style====================*/
TABLE.BroswerStyle {
	width:"100%" ;
	BACKGROUND-COLOR: #FFFFFF ;
	BORDER-Spacing:1pt ; 
}

TABLE.BroswerStyle TR {
	
}
TABLE.BroswerStyle TR.Title {
	
}
TABLE.BroswerStyle TR.Title TH {
	TEXT-ALIGN: left
}
TABLE.BroswerStyle TR.Spacing {
	HEIGHT: 1px
}
TABLE.BroswerStyle TR.DataHeader {
	height:28px;
	
	cursor: pointer;
	color: #4f6b72;
	background: #CAE8EA url(table/head-bg_wev8.png);
}
TABLE.BroswerStyle TR.DataHeader TD {
	COLOR: #000000 ;
	padding: 4px;
}
TABLE.BroswerStyle TR.DataHeader TH {
	padding: 4px;
	COLOR: #000000 ;
	TEXT-ALIGN: left
}
TABLE.BroswerStyle TR.DataDark {
	BACKGROUND-COLOR: #F5FAFA ; HEIGHT: 28px ; BORDER-Spacing:1pt
}
TABLE.BroswerStyle TR.DataDark TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
TABLE.BroswerStyle TR.DataLight {
	BACKGROUND-COLOR: #ffffff ; HEIGHT: 28px ; BORDER-Spacing:1pt 
}
TABLE.BroswerStyle TR.DataLight TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
TABLE.BroswerStyle TR.Line {
	 BACKGROUND-COLOR: #F5FAFA ; BACKGROUND-REPEAT: repeat-x; HEIGHT: 3px
}

TABLE.BroswerStyle TR.Selected
{
    CURSOR: pointer;
	background: #B1D4D9;
	height:28px;
}
TABLE.BroswerStyle TR.Selected TD
{
PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}

/*View Form样式*/
TABLE.ViewForm {
	WIDTH: 100%;
	border:0;margin:0;
	border-collapse:collapse;
	border-left:1px solid #E6E6E6;
	border-top:1px solid #E6E6E6;
	border-right:1px solid #E6E6E6;
}

TABLE.ViewForm A {
	COLOR: blue; TEXT-DECORATION: none
}
TABLE.ViewForm A:hover {
	COLOR: red; TEXT-DECORATION: none
}

TABLE.ViewForm A:link {
	COLOR: blue; TEXT-DECORATION: none
}
TABLE.ViewForm A:visited {
	TEXT-DECORATION: none}


TABLE.ViewForm TR {
	height:35px;
}

TABLE.ViewForm TR.Title TH {
	TEXT-INDENT: -1pt; TEXT-ALIGN: left;
}
TABLE.ViewForm TR.Spacing {
	HEIGHT: 4px
}
TABLE.ViewForm TD {
	padding:0 0 0 5;
	BACKGROUND-COLOR:#F7F7F7;
}
TABLE.ViewForm[valign='top'] TD {
	BACKGROUND-COLOR:#ffffff!important;
}

TABLE.ViewForm TD.Field {
	PADDING-RIGHT: 3px; PADDING-LEFT: 2px; BACKGROUND-COLOR:#ffffff;
}



/*
TABLE.ViewForm TD.Field {
	PADDING-RIGHT: 3px; PADDING-LEFT: 2px; BACKGROUND-COLOR:#fafafa!important;
	
}
*/
TABLE.ViewForm TR.Spacing TD.Line {
	BACKGROUND-COLOR: #E6E6E6!important; BACKGROUND-REPEAT: repeat-x; HEIGHT: 1px
}

TABLE.ViewForm TD.Line {
	BACKGROUND-COLOR: #E6E6E6; BACKGROUND-REPEAT: repeat-x; HEIGHT: 1px
}
TABLE.ViewForm TD.Line1 {
	BACKGROUND-COLOR: #E6E6E6; BACKGROUND-REPEAT: repeat-x; HEIGHT: 2px
}
TABLE.ViewForm TD.Line2 {
	BACKGROUND-COLOR: #D8ECEF; BACKGROUND-REPEAT: repeat-x; HEIGHT: 1px
}
TABLE.ViewForm TR.Line {
	HEIGHT:1px;
}
TABLE.ViewForm TR.Line1 {
	HEIGHT:1px;
}
TABLE.ViewForm TR.Line2 {
	HEIGHT:1px;
}
/*For lisbox*/

.listbox {
	
}

button {margin:0;padding:0;border:none;background-color:transparent;cursor:pointer;overflow:visible;outline:none;moz-outline:none;}
*:first-child+html button[type]{width:1;} /* IE7 */

button span {
	background: transparent url(elements/btn_right_wev8.gif) no-repeat scroll right top;
	display: block;
	float: left;
	padding: 0px 4px 0px 0px; /* sliding doors padding */
	margin: 0px;
}

button span span {
	background: transparent url(elements/btn_left_wev8.gif) no-repeat;
	color: #FFFFFF;
	padding: 1px 4px 0px 8px;
	font-weight: normal;
	font-size: 10px;
	line-height: 13px;
	text-transform: lowercase;
	display: block;
	text-decoration: none;
}

	/*
	 * 
	 */
	.btn{
		border:0px;cursor:pointer;
		background-color:#F9F9F9;
		padding-left:0;
		padding-left:10px;
		padding-right:10px;
		height:30px;
		line-height:30px;
		color:#000;
		width:75px;
	}

	.btnHover{
		background-color:#0178d1 !important;
	}
	
	.btnHoverAdvance{
		background-color: #fff !important;
	}
	
	.e8_btn_submit{
		border:0px;cursor:pointer;
		padding-left:0;
		padding-left:10px;
		padding-right:10px;
		height:30px;
		line-height:30px;
	
		background-color:#558ED5;
		color:white;
		width:75px;
	}
	.e8_btn_submit_hover{
		background-color:#0170C1 !important;
		color:white;
	}
</style>
</head>
<script language="javascript" type="text/javascript">
function doSubmit(){
	var checkdatachecked = $("#checkdatacheck").attr("checked");
	if(checkdatachecked) {
		$("#checkdata").val("1");
	} else {
		$("#checkdata").val("0");
	}
	var questionrepairchecked = $("#questionrepaircheck").attr("checked");
	if(questionrepairchecked) {
		$("#questionrepair").val("1");
	} else {
		$("#questionrepair").val("0");
	}
	
	weaver.submit();
}
</script>
<body>
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td width="10">&nbsp;</td>
	<td valign="top">
		<form name="weaver" method="post" action="UpgradeSettingOperation.jsp">
			<table class=ViewForm>
				<tr>
					<td colspan=2 style="background-color:#558ed5;font-size:16px;color:white;">
						<DIV>升级设置</DIV>
					</td>
				</tr>
				<tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
				<tr>
					<td width=15%><span style="font-size:15px;font-weight:bold">校验data目录</span>
					</td>
					<td>
					<div style="float:left;margin-top:15px">
					<input id="checkdatacheck" name ="checkdatacheck" value="<%=checkdata %>" type="checkbox" <%if("1".equals(checkdata)){ %>checked<%} %>></input>
					<input id="checkdata" name ="checkdata" value="<%=checkdata %>" type="hidden"</input>
					</div>
					<div style="margin-left:100px;">
					<span style="color:red;">
					（升级执行脚本时，是否判断data目录下文件。<br>
					开关开启，校验data目录下的文件；如果执行的脚本已存在data目录下，该脚本不执行；<br>
					开关关闭，不校验data目录下的文件；不管data目录下是否存在这个脚本，都执行这个脚本。）
					</span>
					</div>
					</td>
				</tr>
				<tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
				<tr>
					<td width=15%><span style="font-size:15px;font-weight:bold">自动修复问题</span>
					<td>
					<div style="float:left;">
					<input id="questionrepaircheck" name ="questionrepaircheck" value="<%=questionrepair %>" type="checkbox" <%if("1".equals(questionrepair)){ %>checked<%} %>></input>
					<input id="questionrepair" name ="questionrepair" value="<%=questionrepair %>" type="hidden"</input>
					</div>
					<div style="margin-left:100px;">
					<span style="color:red;">
					（自动执行KB包问题修复方法）
					</span>
					</div>
					</td>
					</td>
				</tr>
				<tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
				<tr>
				<td width=15%></td>
				<td>
					<button type="button" name="save" onclick="doSubmit()" class="e8_btn_submit">保存</button>
				</td>
				</tr>
				<tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
			</table>
		</form>
	</td>
	<td width="15"></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>