
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<html>
<head>
<%
// 增加参数判断缓存
int isIncludeToptitle = 0;
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
//
User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;

if(user == null) {
	response.sendRedirect("/login/Login.jsp");
	return;
}
String keypath =Util.null2String(request.getParameter("keypath"));
String message =Util.null2String(request.getParameter("message"));
if("-1".equals(message)){
	message = "解析备案环境文件信息失败,请重试!";
}else if("-2".equals(message)){
	message = "上传的备案环境文件信息过大，请重新上传!";
}else if("-3".equals(message)){
	message = "未检测到备案环境文件，请重新上传!（注：强制刷新会导致该问题）";
}else {
	message = "";
}
 %>
<html>
<head>
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
<style type="text/css">
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
#projectpath {
	width:550px;
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
	.e8_btn_disabled{
		border:0px;cursor:pointer;
		padding-left:0;
		padding-left:10px;
		padding-right:10px;
		height:30px;
		line-height:30px;
	
		background-color:#959595;
		color:white;
		width:75px;
	}
	.e8_btn_submit_hover{
		background-color:#0170C1 !important;
		color:white;
	}
</style>

<script language="javascript" type="text/javascript">
function doSubmit(){
	var filepath = weaver.filepath.value;
	if(filepath.lastIndexOf(".key")<1)
	{
		alert("备案环境文件信息格式不正确!");
		return;
	}
	$("#submittips").show();
	$("#dosubmit").attr('disabled',"true");
	 $("#dosubmit").removeClass("e8_btn_submit");
	 $("#dosubmit").addClass("e8_btn_disabled");
	document.weaver.submit();
}
<%if(!"".equals(message)){%>
	alert('<%=message%>');
<%}%>
</script>
</head>
<body>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="15">
<col width="">
<col width="15">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td width="15">&nbsp;</td>
	<td valign="top">
		<table class=Shadow>
			<tr>
				<td valign="top">
					<form name="weaver" method="post" enctype="multipart/form-data" target="_self" action="/keygenerator/KeyCompareFileList.jsp">
					<table class=ViewForm>
					<tbody>
						
						<tr>
							<td colspan=2 style="background-color:#558ed5;font-size:16px;color:white;">
								<DIV>ecology备案环境文件信息对比</DIV>
							</td>
						</tr>
						<tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
						<tr>
							<td width=15%>客户备案环境文件信息</td>
							<td width=85% class=field>
							<input type="file" class=InputStyle size=40 id=filepath name=filepath onchange="checkinput1(filepath,filepathspan)">(最大能上传20M)
							<span id="filepathspan" name="filepathspan">
								<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
							</span>
							</td>
						</tr>
						<tr>
							<td width=15%>对比环境文件路径</td>
							<td>
								<input id=projectpath name=projectpath value="" width="80%"></input>
								<span id="projectpathspan" name="projectpathspan">如果不填写，则对比当前系统</span>
							</td>
						</tr>
						<tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
						<tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
						<tr>
							<td width=15%>&nbsp;</td>
							<td align=left><button id="dosubmit" type="button" name="upload" onclick="doSubmit()" class="e8_btn_submit">对比系统</button>
							<span>&nbsp;&nbsp;&nbsp;<font id="submittips"  style=" display:none; font-weight:bold;font-size:larger;color:red">正在对比文件，请勿刷新或关闭页面，请耐心等待 ...</font></span>
							</td>
						</tr>
						<tr class=Spacing style="height: 1px"><td class=Line colspan=2></td></tr>
						
						<TR>
						    <TD colspan="2">
						        <br><b>操作步骤：</b><br>
								1）上传泛微提供的客户备案环境文件信息，点击对比系统。<br>
								2）对比成功后，会列出所有与泛微备案环境文不一致的文件。<br>
								3）将不一致文件打包后,下载allzipecology.zip文件,解压后ecology_all.zip为全部文件,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ecology_filtrate.zip为过滤客户环境比总部备案环境时间老的文件后的包<br>
								4)上传至泛微官方系统，进行文件对比和分析。<br>
						    </TD>
						</TR>
						<TR>
						    <TD colspan="2">
						        <br><b>版本信息</b><br>
								V3.1
						    </TD>
						</TR>
					</tbody>
					</form>
				</td>
			</tr>
		</table>
	</td>
	<td width="15">&nbsp;</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>