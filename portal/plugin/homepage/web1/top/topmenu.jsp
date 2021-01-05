<style>


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
	/*background:		#f9f8f7 url("/images/popup/bg_menu_wev8.gif") repeat-y;*/
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
	cursor:			default;
	padding:		0px;
}

.menu-bar .menu-button {
	color:#676767;
	font-weight: bold;
	font-size:12px;
	padding:	3px 7px 3px 7px;
	border:		0;
	margin:		0;
	display:	inline-block;
	white-space:	nowrap;
	cursor:			default;
}

.menu-bar .menu-button.active {
	padding:		2px 6px 3px 6px;
	/*border:			1px solid #172971;*/
	border-bottom:	0;
}

.menu-bar .menu-button.hover {
	
	padding:		2px 6px 2px 6px;
	border-width:	1px;
	border-style:	solid;
	border-color:	#172971;
}

/* End Menu Bar */
</style>
<script type="text/javascript" src="/js/poslib_wev8.js"></script>
<script type="text/javascript" src="/js/scrollbutton_wev8.js"></script>
<script type="text/javascript" src="/js/menu4_wev8.js"></script>
</HEAD>




<script language="javascript">
		Menu.prototype.cssFile = "/skins/officexp/officexp_wev8.css";
		Menu.prototype.mouseHoverDisabled = false;
		var mb = new MenuBar;

		<%

			MenuUtil mu=null;
			if(resourcetype==0)  {
				 mu=new MenuUtil("top", 3, user.getUID(),user.getLanguage());
			} else {
				 mu=new MenuUtil("top", resourcetype,resourceid,user.getLanguage());
			}
			
			Document menuDoc=mu.getMenuXmlObj(0,"hidden");	
			Element root=menuDoc.getRootElement();
			
			List childList=root.getChildren();
			for(int i=0;i<childList.size();i++){
				String returnStr="";
				Element e=(Element)childList.get(i);

				int menuid=10000-Util.getIntValue(e.getAttributeValue("id"));
				
				returnStr="menu_"+menuid+" = new Menu();\n";
				returnStr+="mb.add(new MenuButton(\""+e.getAttributeValue("text")+"\",menu_"+menuid+",\""+e.getAttributeValue("linkAddress")+"\",\""+e.getAttributeValue("baseTarget")+"\"));\n";

				out.println(returnStr);

				returnStr=mu.getChildStrForMenu4(e,"");


				out.println(returnStr);
			}

			
			
		%>

		mb.write();

</script>