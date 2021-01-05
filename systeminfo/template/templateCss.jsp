
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.systeminfo.template.UserTemplate"%>
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page"/>
<%
String uploadPath = "/TemplateFile/";

UsrTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
//TD4477
//modified by hubo,2006-06-05
String logo = UsrTemplate.getLogo();
String logoBottom = UsrTemplate.getLogoBottom();
String templateTitle = UsrTemplate.getTemplateTitle();
String isShowMainMenu = UsrTemplate.getIsShowMainMenu();
%>
<style>
#divFavContent{display:none;}
.toolbarMenu{border-collapse:collapse}
.toolbarMenu td{width:21px;height:20px;text-align:center;cursor:pointer;}
.toolbarMenuOver{
	background-color:#B6BDD2;border:1px solid #0A246A;
	/*background-color:#ccc;border:1px solid #666;
	background-color:#ACACAC;border:1px solid #7A797F;*/
}
.toolbarMenuOut{background-color:;border:0}
.topBg{
	<%if(!UsrTemplate.getTopBgImage().equals("") && !UsrTemplate.getTopBgImage().equals("0")){%>
	background-image:url(<%=uploadPath+UsrTemplate.getTopBgImage()%>);
	<%}%>
	background-color:<%=UsrTemplate.getTopBgColor()%>;
}


/* 快捷按钮背景色(图) */
.templateToolbarBg{
	<%if(UsrTemplate.getToolbarBgImage().equals("")){%>
		background-image:url(/images/StyleGray/toolbarBg_wev8.jpg);
	<%}else if(!UsrTemplate.getToolbarBgImage().equals("0")){%>
		background-image:url(<%=uploadPath+UsrTemplate.getToolbarBgImage()%>);
	<%}%>
	background-color:<%=UsrTemplate.getToolbarBgColor()%>;
}

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

/* 左菜单分类背景色(图) */
.folder{
	height:22px;
	padding:0 0 0 10px;
	color:<%=UsrTemplate.getLeftbarFontColor()%>;
	cursor:hand;
	<%if(UsrTemplate.getLeftbarBgImage().equals("")){%>
		background-image:url(/images/StyleGray/leftbarBgImage_wev8.jpg);
	<%}else if(!UsrTemplate.getLeftbarBgImage().equals("0")){%>
		background-image:url(<%=uploadPath+UsrTemplate.getLeftbarBgImage()%>);
	<%}%>
	background-color:<%=UsrTemplate.getLeftbarBgColor()%>;
}
.folder img{margin:0 10px 0 10px;vertical-align:middle}

.folderMouseOver{
	height:22px;
	padding:0 0 0 10px;
	color:<%=UsrTemplate.getLeftbarFontColor()%>;
	cursor:hand;
	<%if(UsrTemplate.getLeftbarBgImageH().equals("")){%>
		background-image:url(/images/StyleGray/leftbarBgImageH_wev8.gif);
	<%}else if(!UsrTemplate.getLeftbarBgImageH().equals("0")){%>
		background-image:url(<%=uploadPath+UsrTemplate.getLeftbarBgImageH()%>);
	<%}%>
	background-color:<%=UsrTemplate.getLeftbarBgColor()%>;
}
.folderMouseOver img{margin:0 10px 0 10px;vertical-align:middle}


.file{
	vertical-align:top;
	padding:0px;
}
.file a{
	color:<%=UsrTemplate.getLeftMenuFontColor()%>;
	text-decoration:none;
}
.handle{
	height:3px;
	<%if(UsrTemplate.getMenuInBoldBorderbg().equals("")||UsrTemplate.getMenuInBoldBorderbg().equals("0")){%>
		background-image:url(/images/StyleGray/leftmenuToggleHBg_wev8.jpg);
	<%}else if(!UsrTemplate.getMenuInBoldBorderbg().equals("0")){%>
		background-image:url(<%=uploadPath+UsrTemplate.getMenuInBoldBorderbg()%>);
	<%}%>	
	cursor:row-resize;
	text-align:center;
}


#thumbBox{
	height:22px;
	text-align:right;
	background-image:url('/images/StyleGray/thumbBoxBg_wev8.jpg');
	<%if(UsrTemplate.getMenuBottomCusbg().equals("")||UsrTemplate.getMenuBottomCusbg().equals("0")){%>
		background-image:url('/images/StyleGray/thumbBoxBg_wev8.jpg');
	<%}else if(!UsrTemplate.getMenuBottomCusbg().equals("0")){%>
		background-image:url('<%=uploadPath+UsrTemplate.getMenuBottomCusbg()%>');
	<%}%>
	background-repeat:no-repeat;
}

#thumbBox img{margin-right:5px}

#rightArrow{cursor:hand}
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
	background:		<%=UsrTemplate.getMenubarBgColor()%>;
	cursor:			default;
	padding:		0px;
}

.menu-bar .menu-button {
	background:	<%=UsrTemplate.getMenubtnBgColor()%>;
	color:		<%=UsrTemplate.getMenubtnFontColor()%>;
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
	background:		<%=UsrTemplate.getMenubtnBgColorActive()%>;
	padding:		2px 6px 3px 6px;
	border:			1px solid <%=UsrTemplate.getMenubtnBorderColorActive()%>;
	border-bottom:	0;
}

.menu-bar .menu-button.hover {
	background:		<%=UsrTemplate.getMenubtnBgColorHover()%>;
	padding:		2px 6px 2px 6px;
	border-width:	1px;
	border-style:	solid;
	border-color:	<%=UsrTemplate.getMenubtnBorderColorHover()%>;
}

/* End Menu Bar */
</style>