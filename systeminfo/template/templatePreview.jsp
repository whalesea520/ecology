
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.hrm.*,
                 weaver.rtx.RTXExtCom,
                 weaver.hrm.settings.BirthdayReminder,
                 weaver.hrm.settings.RemindSettings,
                 weaver.systeminfo.setting.HrmUserSettingHandler,
                 weaver.systeminfo.setting.HrmUserSetting,
					  weaver.systeminfo.*,
                 weaver.general.TimeUtil,
					  weaver.general.StaticObj" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String uploadPath = "/TemplateFile/";


String logo="",logoBottom="",topBgImage="",toolbarBgImage="",leftbarBgImage="",leftbarBgImageH="",templatetitle="";
int templateId = Util.getIntValue(request.getParameter("id"));
String topBgColor = Util.null2String(request.getParameter("topBgColor"));
String toolbarBgColor = Util.null2String(request.getParameter("toolbarBgColor"));
String leftbarBgColor = Util.null2String(request.getParameter("leftbarBgColor"));
String leftbarFontColor = Util.null2String(request.getParameter("leftbarFontColor"));
String isShowMainMenu = Util.null2String(request.getParameter("isShowMainMenu"));
String menubarBgColor = Util.null2String(request.getParameter("menubarBgColor"));
String menubtnBgColor = Util.null2String(request.getParameter("menubtnBgColor"));
String menubtnBgColorActive = Util.null2String(request.getParameter("menubtnBgColorActive"));
String menubtnBgColorHover = Util.null2String(request.getParameter("menubtnBgColorHover"));
String menubtnBorderColorActive = Util.null2String(request.getParameter("menubtnBorderColorActive"));
String menubtnBorderColorHover = Util.null2String(request.getParameter("menubtnBorderColorHover"));
String menubtnFontColor = Util.null2String(request.getParameter("menubtnFontColor"));

String menuborderbg = Util.null2String(request.getParameter("menuborderbg"));
String menuInBoldBorderbg = Util.null2String(request.getParameter("menuInBoldBorderbg"));
String menuBottomCusbg = Util.null2String(request.getParameter("menuBottomCusbg"));

String from = Util.null2String(request.getParameter("from"));
String subCompanyId = Util.null2String(request.getParameter("subcompanyId"));
String tempdata = "";
if("edit".equals(from)){
	tempdata = "Temp";
}

String templateType="";
int extendtempletid=0;
String sql = "SELECT * FROM SystemTemplate"+tempdata+" WHERE id="+templateId;
rs.executeSql(sql);
if(rs.next()){
	templateType = rs.getString("templateType");
	extendtempletid = rs.getInt("extendtempletid");

	logo = rs.getString("logo");
	logoBottom = rs.getString("logoBottom");
	if(topBgColor.equals("")) topBgColor = rs.getString("topBgColor");
	topBgImage = rs.getString("topBgImage");
	if(toolbarBgColor.equals("")) toolbarBgColor = rs.getString("toolbarBgColor");
	toolbarBgImage = rs.getString("toolbarBgImage");
	if(leftbarBgColor.equals("")) leftbarBgColor = rs.getString("leftbarBgColor");
	leftbarBgImage = rs.getString("leftbarBgImage");
	leftbarBgImageH = rs.getString("leftbarBgImageH");
	if(leftbarFontColor.equals("")) leftbarFontColor = rs.getString("leftbarFontColor");
	if(isShowMainMenu.equals("")) isShowMainMenu = rs.getString("isShowMainMenu");
	if(menubarBgColor.equals("")) menubarBgColor = rs.getString("menubarBgColor");
	if(menubtnBgColor.equals("")) menubtnBgColor = rs.getString("menubtnBgColor");
	if(menubtnBgColorActive.equals("")) menubtnBgColorActive = rs.getString("menubtnBgColorActive");
	if(menubtnBgColorHover.equals("")) menubtnBgColorHover = rs.getString("menubtnBgColorHover");
	if(menubtnBorderColorActive.equals("")) menubtnBorderColorActive = rs.getString("menubtnBorderColorActive");
	if(menubtnBorderColorHover.equals("")) menubtnBorderColorHover = rs.getString("menubtnBorderColorHover");
	if(menubtnFontColor.equals("")) menubtnFontColor = rs.getString("menubtnFontColor");
	if(templatetitle.equals("")) templatetitle = rs.getString("templatetitle");

	if(menuborderbg.equals("")) menuborderbg = rs.getString("menuborderbg");
	if(menuInBoldBorderbg.equals("")) menuInBoldBorderbg = rs.getString("menuInBoldBorderbg");
	if(menuBottomCusbg.equals("")) menuBottomCusbg = rs.getString("menuBottomCusbg");

	
}

if("".equals(templateType)&&extendtempletid==0){
	templateType = "ecologyBasic";
	//isSoft = true;
}else if("".equals(templateType)&&extendtempletid==1){
	templateType = "ecologyBasic";
}else if("".equals(templateType)&&extendtempletid==2){
	templateType = "custom";
}else if("".equals(templateType)&&(extendtempletid==3||extendtempletid==-1)){
	templateType = "ecologyBasic";
}

String url="";
if(templateType.equals("ecology8")){
	url="/systeminfo/template/PortalTemplateE8Preview.jsp?from="+from+"&subCompanyId="+subCompanyId+"&templateid="+templateId;	
}else if(templateType.equals("ecology7")){
	url="/systeminfo/template/PortalTemplatePreview.jsp?from="+from+"&subCompanyId="+subCompanyId+"&templateid="+templateId;	
}else if(templateType.equals("ecologyBasic")){
	url= "/systeminfo/template/PortalTemplateBasicPreview.jsp?from="+from+"subCompanyId="+subCompanyId+"&templateid="+templateId;
}else if(templateType.equals("custom")){
	url= "/portal/plugin/homepage/webcustom/index.jsp?from="+from+"subCompanyId="+subCompanyId+"&templateid="+templateId;
}

if(!url.equals("")){
	response.sendRedirect(url);
	return;
}
%>



<html>
<head>
<title><%=templatetitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css">
<style>
.OTtable{
	border:0px solid #AAA;
	width:100%;
	height:100%;
	background-color:#7B7B7B;
}
.OTtd{
	line-height:18px;
	padding-left:2px
}
.OTspan{display:none;}
.folder{
	height:22px;
	padding:0 0 0 10px;
	color:<%=leftbarFontColor%>;
	cursor:hand;
	<%if(leftbarBgImage.equals("")){%>
		background-image:url(/images/StyleGray/leftbarBgImage_wev8.jpg);
	<%}else if(!leftbarBgImage.equals("0")){%>
		background-image:url(<%=uploadPath+leftbarBgImage%>);
	<%}%>
	background-color:<%=leftbarBgColor%>;
}
.folder img{margin:0 10px 0 10px;vertical-align:middle}
.folderMouseOver{
	height:22px;
	padding:0 0 0 10px;
	color:<%=leftbarFontColor%>;
	cursor:hand;
	<%if(leftbarBgImageH.equals("")){%>
		background-image:url(/images/StyleGray/leftbarBgImageH_wev8.gif);
	<%}else if(!leftbarBgImageH.equals("0")){%>
		background-image:url(<%=uploadPath+leftbarBgImageH%>);
	<%}%>
	background-color:<%=leftbarBgColor%>;
}
.folderMouseOver img{margin:0 10px 0 10px;vertical-align:middle}
.file{
	vertical-align:top;
	padding:0px;
}
.file a{
	/*color:<%//=leftMenuFontColor%>;*/
	text-decoration:none;
}
.handle{
	height:3px;
	background-color:#333;
	<%if(menuInBoldBorderbg.equals("")||menuInBoldBorderbg.equals("0")){%>
		background-image:url(/images/StyleGray/leftmenuToggleHBg_wev8.jpg);
	<%}else if(!menuInBoldBorderbg.equals("0")){%>
		background-image:url(<%=uploadPath+menuInBoldBorderbg%>);
	<%}%>
	
	cursor:row-resize;
	text-align:center;
}
#thumbBox{
	height:22px;
	text-align:right;
	<%if(menuBottomCusbg.equals("")||menuBottomCusbg.equals("0")){%>
		background-image:url(/images/StyleGray/thumbBoxBg_wev8.jpg);
	<%}else if(!menuBottomCusbg.equals("0")){%>
		background-image:url(<%=uploadPath+menuBottomCusbg%>);
	<%}%>
	
	background-repeat:no-repeat;
}
#thumbBox img{margin-right:5px}
#rightArrow{cursor:hand}

.toolbarMenu{border-collapse:collapse}
.toolbarMenu td{width:21;height:20;text-align:center;cursor:hand}
.toolbarMenuOver{
	background-color:#B6BDD2;border:1px solid #0A246A;
}
.toolbarMenuOut{background-color:;border:0}

.topBg{
	<%if(!topBgImage.equals("") && !topBgImage.equals("0")){%>
	background-image:url(<%=uploadPath+topBgImage%>);
	<%}%>
	background-color:<%=topBgColor%>;
}


/* 快捷按钮背景色(图) */
.templateToolbarBg{
	<%if(toolbarBgImage.equals("")){%>
		background-image:url(/images/StyleGray/toolbarBg_wev8.jpg);
	<%}else if(!toolbarBgImage.equals("0")){%>
		background-image:url(<%=uploadPath+toolbarBgImage%>);
	<%}%>
	background-color:<%=toolbarBgColor%>;
}


/* menu body */
*{font-family:	MS Shell Dlg;font-size:12px;}
.menu-body {
	color:		Black;
	margin:		0;
	padding:	0;
	overflow:	hidden;
	border:		0;
	cursor:		default;
}

.menu-body .outer-border {
	border:		1px solid #666666;
	margin:		0;
	padding:	0;
	
}

.menu-body .inner-border {
	width:			100%;
	
	border:			1px solid #f9f8f7;
	border-width:	1px 0 1px 0;
	padding:		0 1px 0 1px;
	margin:			0;
	background:		#f9f8f7 url("/images/popup/bg_menu_wev8.gif") repeat-y;
}

/* menu body */

/*****************************************************************************/

/* menu items */

.menu-body td {
	font-family:	MS Shell Dlg;
	font-size:12px;
	color:			Black;
}

.menu-body .hover td {
	background-color:	#b6bdd2;
}

.menu-body .disabled-hover td {
	background-color:	white;
}

.menu-body td.empty-icon-cell {
	padding:		2px;
	border:		0;
}

.menu-body td.empty-icon-cell span {
	width:	16px;
}

.menu-body td.icon-cell {
	padding:	2px;
	border:		0;
}


.menu-body td.icon-cell img {
	width:	16px;
	height:	16px;
	margin:	0;
	filter:	Alpha(Opacity=70);
}

.menu-body .hover td.icon-cell img {
	filter:	none;
	position:	relative;
	left:		-1px;
	top:		-1px;
}


.menu-body .disabled-hover td.icon-cell img,
.menu-body .disabled td.icon-cell img {
	display:	static;
	filter:		Gray() Alpha(Opacity=40);
}


.menu-body .disabled-hover td.empty-icon-cell,
.menu-body .hover td.empty-icon-cell,
.menu-body .disabled-hover td.icon-cell,
.menu-body .hover td.icon-cell {
	border:			1px solid #0A246A;
	border-right:	0;
	padding:		1px 2px 1px 1px;
}

.menu-body td.label-cell {
	width:		100%;
	padding:	2px 5px 2px 5px;
	border:		0;
}

.menu-body .disabled-hover td.label-cell,
.menu-body .hover td.label-cell,
.menu-body .disabled-hover td.shortcut-cell,
.menu-body .hover td.shortcut-cell {
	padding:		1px 5px 1px 5px;
	border:			1px solid #0A246A;
	border-left:	0;
	border-right:	0;
}

.menu-body td.shortcut-cell {
	padding:	2px 5px 2px 5px;
}

.menu-body td.arrow-cell {
	width:			20px;
	padding:		2px 2px 2px 0px;
	font-family:	Webdings;
}

/* end menu items */

/*****************************************************************************/

/* disabled items */

.menu-body .disabled-hover td.arrow-cell,
.menu-body .hover td.arrow-cell {
	padding:		1px 1px 1px 0px;
	border:			1px solid #0A246A;
	border-left:	0;
}

.menu-body #scroll-up-item td,
.menu-body #scroll-down-item td {
	font-family:	Webdings !important;
	text-align:		center;
	padding:		10px;
}

.menu-body .disabled td {
	color:				#cccccc;
}

.menu-body .disabled-hover td {
	background-color:	white;
	color:				#cccccc;
}

/* end disabled items */

/*****************************************************************************/

/* separator */

.menu-body .separator td {
	font-size:	0.001mm;
	padding:	1px 0px 1px 27px;
}

.menu-body .separator-line {
	overflow:		hidden;
	border-top:		1px solid #dbd8d1;
	height:			1px;
}

/* end separator */

/*****************************************************************************/

/* Scroll buttons */

.menu-body #scroll-up-item,
.menu-body #scroll-down-item {
	width:		100%;
}

.menu-body #scroll-up-item td,
.menu-body #scroll-down-item td {
	font-family:	Webdings;
	text-align:		center;
	padding:		1px 5px 1px 5px;
}

.menu-body #scroll-up-item .disabled-hover td,
.menu-body #scroll-up-item .hover td,
.menu-body #scroll-down-item .disabled-hover td,
.menu-body #scroll-down-item .hover td {
	border:		1px solid #0A246A;
	padding:	0px 4px 0px 4px;
}

/* End scroll buttons */

/*****************************************************************************/

/* radio and check box items */

.menu-body .checked {
	padding:	0px;
}

.menu-body .checked.hover {
	padding:	0px;
}

.menu-body .checked .check-box,
.menu-body .checked .radio-button {
	display:		inline-block;
	font-family:	Webdings;
	overflow:		hidden;
	color:			MenuText;
	text-align:		center;
	vertical-align:	center;
	background-color:	#b6bdd2;
	border:				1px solid #0A246A;
}

.menu-body .check-box {
	width:			19px;
	height:			19px;
	font-size:		133%;
	padding-bottom:	5px;
	padding-left:	1px;
}

.menu-body .radio-button {
	width:			19px;
	height:			19px;
	font-size:		50%;
	padding:		5px;
}

/* end radio and check box items */

/*****************************************************************************/

/* Menu Bar */

.menu-bar {
	background:		<%=menubarBgColor%>;
	cursor:			default;
	padding:		0px;
}

.menu-bar .menu-button {
	background:	<%=menubtnBgColor%>;
	color:		<%=menubtnFontColor%>;
	font-family:	MS Shell Dlg;
	font-size:12px;
	padding:	3px 7px 3px 7px;
	border:		0;
	margin:		0;
	display:	inline-block;
	white-space:	nowrap;
	cursor:			default;
}

.menu-bar .menu-button.active {
	background:		<%=menubtnBgColorActive%>;
	padding:		2px 6px 3px 6px;
	border:			1px solid <%=menubtnBorderColorActive%>;
	border-bottom:	0;
}

.menu-bar .menu-button.hover {
	background:		<%=menubtnBgColorHover%>;
	padding:		2px 6px 2px 6px;
	border-width:	1px;
	border-style:	solid;
	border-color:	<%=menubtnBorderColorActive%>;
}

/* End Menu Bar */
</style>
<script type="text/javascript" src="/js/poslib_wev8.js"></script>
<script type="text/javascript" src="/js/scrollbutton_wev8.js"></script>
<script type="text/javascript" src="/js/menu4_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000" oncontextmenu="">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    //ShowOnload="false";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
<tr height="60" id="topMenu" name="topMenu" style="DISPLAY:''">
<td >
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr id="topMenuLogo" height="32">
		<td>
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="topBg">
				<td width ="198">
				<%
				String templateLogo = "/images/StyleGray/ecologyLogoA_wev8.jpg";
				if(!logo.equals("")&&!logo.equals("0"))
					templateLogo = uploadPath+logo;
				%><img src="<%=templateLogo%>"/></td>
				<td width="*" valign="bottom" align="center">
				<%if(isShowMainMenu.equals("1")){%>
					<script type="text/javascript">
					//<![CDATA[
					Menu.prototype.cssFile = "/skins/officexp/officexp_wev8.css";
					Menu.prototype.mouseHoverDisabled = false;
					var tmp;
					var mb = new MenuBar;
					<%  
					MainMenuUtil mainMenuUtil = new MainMenuUtil(user);
					String menuStr = mainMenuUtil.getMenuString();
					out.println(menuStr);
					%>
					mb.write();
					//]]>
					</script>
				<%}else{%>
					&nbsp;
				<%}%>
				</td>
			</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td height="28" class="templateToolbarBg">
		<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td width="185">
		<%String templateLogoBottom = "/images/StyleGray/ecologyLogoB_wev8.jpg";
		if(!logoBottom.equals("")&&!logoBottom.equals("0"))
			templateLogoBottom = uploadPath+logoBottom;
		%>
		<%
		if(logo.equals("0")||logo.equals("")){
			%>
			<img src="<%=templateLogoBottom%>" id="logoBottom"/>
			<%
		}else{
			if(!logoBottom.equals("")&&!logoBottom.equals("0")){
				%>
				<img src="<%=templateLogoBottom%>" id="logoBottom"/>
			<%
			}
		}	
		%>
		</td>
			<td width=23 align="center">
				<IMG id=LeftHideShow  title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="CURSOR: hand" src="/images_face/ecologyFace_1/BP_Hide_wev8.gif" >
			</td>
			<td width=23 align="center">
				<IMG id=TopHideShow  title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="CURSOR: hand" src="/images_face/ecologyFace_1/BP2_Hide_wev8.gif">
			</td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/LogOut_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>"></td></tr></table><!--退出-->
			</td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Back_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>"></td></tr></table><!--后退-->
			</td>
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Pre_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>"></td></tr></table><!---->
			</td>
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Refur_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>"></td></tr></table><!--刷新-->
			</td>
		<!--<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Favourite_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>"></td></tr></table>收藏夹
			</td> -->
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Print_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>"></td></tr></table><!--打印-->
			</td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			<td width="50px"><span onclick="" style="cursor:hand;width:50px;color:#172971"><%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>▼</span></td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			<td>
				<table border="0" cellspacing="0" cellpadding="0">
				<form name="search" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
				<tr>
					<td nowrap>
						<select name="searchtype" style="width:60px">
						<option value=1><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
						</select>
					</td>
					<td nowrap style="padding:0 3px 0 5px"><input name="searchvalue" size="14" class="InputStyle_1" onMouseOver="this.select()"></td>
					<td nowrap>
					<img alt="<%=SystemEnv.getHtmlLabelName(16646,user.getLanguage())%>" src="/images_face/ecologyFace_1/search_dot_wev8.gif" border="0" style="CURSOR:HAND">
					</td>
				</tr>
				</table>
		</td>
		<td align="right" style="">
		<table height=100% border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Home_wev8.gif"  title="<%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%>"></td></tr></table><!--首页-->
			</td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plan_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(2101,user.getLanguage())%>"></td></tr></table><!--我的计划-->
			</td>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Mail_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(2029,user.getLanguage())%>"></td></tr></table><!--新建邮件-->
			</td>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Doc_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>"></td></tr></table><!--新建文档-->
			</td>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/WorkFlow_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>"></td></tr></table><!--新建流程-->
			</td>
            <%//if(software.equals("ALL") || software.equals("CRM")){%>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/CRM_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%>"></td></tr></table><!---->
			</td>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/PRJ_wev8.gif"  title="<%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%>"></td></tr></table><!---->
			</td>
            <%//}%>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Meeting_wev8.gif"  title="<%=SystemEnv.getHtmlLabelName(15008,user.getLanguage())%>"></td></tr></table><!---->
			</td>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Org_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%>"></td></tr></table><!--组织结构-->
			</td>		
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Version_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>"></td></tr></table><!--版本-->
			</td>
			</tr>
		</table>
		</td>
		<td width="10"></td>
		</tr>
		</table>
		</td>
	</tr>
	</table>
</td>
</tr>

<tr><td style="height:1px;background-color:white"></td></tr>
<tr>
	<td>
		<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0" id="mainTable" name="mainTable">
		<tr>
		<td style="padding-top:3px;width:150px">
		<table id="divMenuBox" style="width:100%;height:100%;border-top:2px solid #6F6F6F;border-bottom:2px solid #6F6F6F;" cellpadding="0" cellspacing="0">
		<TR>
			
			<%
			String leftmenuBoxBg="";
			String leftmenuToggleBg="";

			if(menuborderbg.equals("")||menuborderbg.equals("0")){
				leftmenuBoxBg="/images/StyleGray/leftmenuBoxBg_wev8.jpg";
				leftmenuToggleBg="/images/StyleGray/leftmenuToggleBg_wev8.jpg";
			%>
				<TD style="height:100%;padding:4px 0 4px 4px;background-image:url(<%=leftmenuBoxBg%>);background-position:right;background-repeat:repeat-y"></TD>
				<td style="height:100%;width:5px;padding:0px 0 0px 0px;background-image:url(<%=leftmenuToggleBg%>);text-align:center"><img src="/images/StyleGray/handleV_wev8.gif"/></td>

			<%}else if(!menuborderbg.equals("0")){
				leftmenuBoxBg=uploadPath+menuborderbg;
				leftmenuToggleBg=uploadPath+menuborderbg;
				%>
				<TD style="height:100%;padding:4px 0 4px 4px;background-image:url(<%=leftmenuBoxBg%>)"></TD>
				<td style="height:100%;width:5px;padding:0px 0 0px 0px;background-image:url(<%=leftmenuToggleBg%>);text-align:center"><img src="/images/StyleGray/handleV_wev8.gif"/></td>
			<%}

			%>
		</TR>
		</table>
		</td>
		</tr>
		</table>
	</td>
</tr>
</table>

</body>
</html>



<script language="javascript">
var prefixes = ["MSXML2.DomDocument", "Microsoft.XMLDOM", "MSXML.DomDocument", "MSXML3.DomDocument"];
var dom;

var FolderCount = 15;
var thumbCount = 5;
var FolderLeavings = 4;
var menuMargin = 14;

var arrayFolder;
var tbl;
var fileTD;
var rightArrow;
var handleOffsetHeight;

var currentThumbCount,currentMenuId,currentTD;

function getDomObject(){
	for (var i = 0; i < prefixes.length; i++) {
		try{dom = new ActiveXObject(prefixes[i]);}catch(ex){};
	}
}

window.onload = function(){
	/*initialize*/
	getDomObject();
	getXML();
	//getCookie();
	//currentMenuId = 0;
	createMenu();
	//document.getElementById("ifrm").contentWindow.attachEvent("onresize",loadHTML2);

	arrayFolder = new Array();
	tbl = document.getElementById("tbl");
	fileTD = document.getElementById("fileTD");
	rightArrow = document.getElementById("rightArrow");

	getHandleOffsetHeight();
};

window.onbeforeunload = function(){
	//setCookie(currentThumbCount,currentMenuId);
};

window.onresize = function(){
	if(window.document.body.offsetWidth<150) parent.document.getElementById("mainFrameSet").cols = "150,*";

	//memorizeThumb();
	getHandleOffsetHeight();
};

function getXML(){
	dom.async = true;
	dom.loadXML('<menu><menubar id="0" levelid="94" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(18027,user.getLanguage())%>"></menubar><menubar id="1" levelid="111" icon="/images_face/ecologyFace_2/LeftMenuIcon/InformationCenter_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(18051,user.getLanguage())%>" extra="infoCenter"></menubar><menubar id="2" levelid="80" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(18032,user.getLanguage())%>"></menubar><menubar id="3" levelid="1" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(16391,user.getLanguage())%>"></menubar><menubar id="5" levelid="2" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(16394,user.getLanguage())%>"></menubar><menubar id="6" levelid="5" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(16414,user.getLanguage())%>"></menubar><menubar id="7" levelid="3" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(6059,user.getLanguage())%>"></menubar><menubar id="8" levelid="4" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(1211,user.getLanguage())%>"></menubar><menubar id="9" levelid="6" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(2102,user.getLanguage())%>"></menubar><menubar id="10" levelid="107" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(18033,user.getLanguage())%>"></menubar><menubar id="11" levelid="7" icon="/images_face/ecologyFace_2/LeftMenuIcon/MyMail_wev8.gif" name="<%=SystemEnv.getHtmlLabelName(1209,user.getLanguage())%>"></menubar></menu>');	
}

function getHandleOffsetHeight(){
	var tblTop = 0;
	obj = tbl.rows[3];
	while(obj.tagName!="BODY"){
		tblTop += obj.offsetTop;
		obj = obj.offsetParent;
	}
	handleOffsetHeight = tblTop;
}

function loadHTML(){
	document.getElementById("ifrm").contentWindow.document.body.attachEvent("oncontextmenu",function(){return false;});
	return false;
	with(document.getElementById("ifrm")){
		try{
			contentWindow.document.body.style.margin = "0";
			contentWindow.document.body.style.padding = "0";
			var nodeMenubar = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");

			if(nodeMenubar.getAttribute("extra")==null){
				//contentWindow.document.body.innerHTML = "<div style='padding:10px;font-size:12px'>"+nodeMenubar.firstChild.text+"</div>";
				contentWindow.document.body.innerHTML = "";
				detachEvent("onload",loadHTML);
				src = "/LeftMenu/LeftMenuTree.jsp?id="+dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']").getAttribute("levelid");
			}else if(nodeMenubar.getAttribute("extra")=="systemSetting"){
				detachEvent("onload",loadHTML);
				src = "/LeftMenu/sysSettingTreeFactory.jsp";
			}else if(nodeMenubar.getAttribute("extra")=="myReport"){
				detachEvent("onload",loadHTML);
				src = "/LeftMenu/sysSettingTreeFactory.jsp?extra=myReport";
			}else if(nodeMenubar.getAttribute("extra")=="infoCenter"){
				detachEvent("onload",loadHTML);
				src = "/LeftMenu/infoCenterTreeFactory.jsp";
			}
		}catch(e){}
	}
}

function createMenu(){
	var oTbl,oTR,oTD;

	oTbl = document.createElement("table");
	oTbl.id = "tbl";
	oTbl.cellSpacing = "1";
	oTbl.className = "OTTable";

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	if(dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']")==null){
		currentMenuId=1;
	}
	oTD.setAttribute("menuid",dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']").getAttribute("id"));
	oTD.className = "folder";
	oTD.innerHTML = "<img src='"+dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']").getAttribute("icon")+"'/>" + dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']").getAttribute("name");

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.id = "fileTD";
	oTD.className = "file";
	var oIframe = document.createElement("iframe");
	oIframe.id = "ifrm";
	oIframe.style.width = "100%";
	oIframe.style.height = "100%";
	oIframe.frameBorder = "0";
	oIframe.attachEvent("onload",loadHTML);
	oTD.appendChild(oIframe);

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.className = "handle";
	oTD.innerHTML = "<img src=\"/images/StyleGray/handleH_wev8.gif\" style=\"\"/>";

	var oNodes = dom.selectNodes("//menubar");
	for(i=0;i<oNodes.length;i++){
		oTR = oTbl.insertRow();
		oTD = oTR.insertCell();
		oTD.setAttribute("menuid",dom.selectSingleNode("//menubar["+i+"]").getAttribute("id"));
		oTD.className = i==1 ? "folderMouseOver" : "folder";
		//oTD.attachEvent("onmouseover",folderMouseOver);
		//oTD.attachEvent("onmouseout",folderMouseOut);
		//oTD.onclick = function(){slideFolder(this);};
		oTD.innerHTML = "<img src='"+dom.selectSingleNode("//menubar["+i+"]").getAttribute("icon")+"'/>" + dom.selectSingleNode("//menubar["+i+"]").getAttribute("name");;
	}

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.id = "thumbBox";
	oTD.innerHTML = "<img id='rightArrow' src='/images/StyleGray/rArrow_wev8.gif'/>";

	document.getElementById("divMenuBox").rows[0].cells[0].appendChild(oTbl);
}

function folderMouseOver(){
	var o = window.event.srcElement;
	if(o.tagName!="IMG") o.className = "folderMouseOver";
}

function folderMouseOut(){
	var o = window.event.srcElement;
	if(o.tagName!="IMG") o.className = "folder";
}
</script>
