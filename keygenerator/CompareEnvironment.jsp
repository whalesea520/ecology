<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*,java.io.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.*"%>
<%@ page import="weaver.general.*"%>
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
	User user = (User) request.getSession(true).getAttribute("weaver_user@bean");
	boolean canupload = false;//是否可以下载对比结果excel
	if (user == null) {
		response.sendRedirect("/login/Login.jsp");
		return;
	}
	
	String username_sour = Util.null2String(request.getParameter("username_sour")).trim();
	String password_sour = Util.null2String(request.getParameter("password_sour")).trim();
	String username_targ = Util.null2String(request.getParameter("username_targ")).trim();
	String password_targ = Util.null2String(request.getParameter("password_targ")).trim();
	
	
	Map<String,String> fileMap = null;
	String message = "";
	String currentpath = Util.null2String(request.getParameter("currentpath")).trim();
	if(currentpath.equals("")){
		currentpath = GCONST.getRootPath();
	}
	String projectpath = Util.null2String(request.getParameter("projectpath")).trim();
	if(!currentpath.endsWith(File.separator)){
		currentpath = currentpath+File.separator;
	}
	if(!projectpath.equals("")&&!projectpath.endsWith(File.separator)){
		projectpath= projectpath+File.separator;
	}
	String isSearch = Util.null2String(request.getParameter("isSearch"));
	wscheck.CheckEnvironment checkUtil = new wscheck.CheckEnvironment();

int cpath=1;
int ppath=1;
if(isSearch.equals("1")){
	session.removeAttribute("CompareEnvironmentMap");
	//检查路径
	cpath = checkUtil.checkPath(currentpath,username_sour,password_sour);
	ppath = checkUtil.checkPath(projectpath,username_targ,password_targ);
	if (cpath != 1) {
		message = cpath == 0 ? "源环境文件路径不正确" : cpath == 2 ? "源环境用户名密码认证不通过，请重新输入源环境的认证信息" : "";
	} else if (ppath != 1) {
		message = ppath == 0 ? "目标环境文件路径不正确" : ppath == 2 ? "目标环境用户名密码认证不通过，请重新输入目标环境的认证信息" : "";
	} else {
		fileMap = checkUtil.getCheckResult(currentpath, projectpath);
		if(fileMap == null){
			message = "源环境与目标环境文件相同";
		} else{
			canupload = true;
			session.setAttribute("CompareEnvironmentMap",fileMap);
		}
	}
}
%>

<html>
<head>
<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<script type="text/javascript"
	src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript"
	src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script type="text/javascript"
	src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function(){
// 	$('#maintable tbody').empty();
$("#projectpathspan font").hide();
	wuiform.init();
});

</script>
<style type="text/css">

* {
	font-family: "微软雅黑" !important;
}

a {
	text-decoration: none !important;
	color: #929393;
}

table.ListStyle td a:link {
	color: #929393;
}

a:hover {
	color: red !important;
}

body {
	height: 100%;
	width: 100%;
}

/

/*For Button*/
BUTTON.btn {
	border: none;
	BACKGROUND: url(button/btn_wev8.png) no-repeat;
	color: #333;
	WIDTH: 116px;
	height: 23px;
	text-align: left;
	cursor: pointer;
	padding-left: 10px;
	padding-top: 2px;
	margin-right: 5px;
}

BUTTON.Browser {
	BACKGROUND-IMAGE:
		url(/wui/theme/ecology7/skins/default/general/browser_wev8.png)
		!important;
	width: 16px;
}

BUTTON.Clock {
	BACKGROUND-IMAGE: url(general/calendar_wev8.png) !important;
	WIDTH: 16px !important;
}

BUTTON.Calendar {
	BACKGROUND-IMAGE: url(general/calendar_wev8.png) !important;
	WIDTH: 16px !important;
}

BUTTON.btnFavorite {
	BACKGROUND-IMAGE: url(general/fav_wev8.png) !important;
	background-position: center center;
}

BUTTON.btnHelp {
	BACKGROUND-IMAGE: url(general/help_wev8.png) !important;
	background-position: center center;
}

#projectpath {
	width: 550px;
}
#currentpath {
	width: 550px;
}

/*For Toptitle*/
.TopTitle {
	/*BORDER-bottom: #e7e7e7 1px solid;*/
	/*BACKGROUND:url(general/title-bg_wev8.png) repeat-x;*/
	height: 28px;
	border: #8CC7CF 1px solid;
	background: #B1D4D9 url(general/title-bg_wev8.jpg) repeat-x;;
}

DIV.TopTitle TD {
	COLOR: #000000;
}

#divshowreceivied {
	display: none;
}

/*for table shadow*/
TABLE.Shadow {
	/*border: 1px solid  #d4dae3;*/
	border-collapse: collapse;
	width: 100%;
	height: 100%;
}

TABLE.Shadow  td {
	padding: 0px;
}

/**************************************/
/*           斑马线表格              */
/**************************************/
TABLE.ListStyle { /*表体*/
	width: "100%";
	margin: 10px 0pt 15px;
	width: 100%;
	text-align: left;
}

/*表链接*/
TABLE.ListStyle tr {
	height: 40px;
}

TABLE.ListStyle td {
	height: 40px !important;
}

TABLE.ListStyle th {
	height: 40px;
}
/*表头 TH*/
TABLE.ListStyle TR.HeaderForXtalbe TH, TABLE.ListStyle TR.header TH,
	TABLE.ListStyle TR.header TD {
	height: 40px !important;
	padding: 5px 5px 5px 12px;
	cursor: pointer;
	/*color: #4f6b72;
    background-color:#E3E1E2;*/
	color: #000;
	background-color: #fff;
	font-weight: bold;
	border-bottom: 3px solid #B7E0FE;
}

/* add by bpf 2013-10-30 start*/
.operHoverSpan {
	height: 100%;
	display: -moz-inline-box;
	display: inline-block;
	color: white !important;
	padding-left: 5px;
	padding-right: 5px;
}

.operHover_hand {
	cursor: pointer;
}

.operHoverSpan_hover {
	background-color: #5978A4;
}

.operHoverSpan a {
	text-decoration: none !important;
	color: white !important;
}

.operHoverSpan a:hover {
	color: white !important;
}
/* add by bpf 2013-10-30 end*/

/*表体*/
TABLE.ListStyle tbody tr td {
	color: #929393;
	padding: 5px 5px 5px 12px;
	vertical-align: top;
	border-bottom: 1px solid #DADADA;
}

/**/
TABLE.ListStyle TR.DataDark TD {
	BACKGROUND-COLOR: #F5FAFA;
	color: #4f6b72;
}

TABLE.ListStyle TR.DataLight TD {
	BACKGROUND-COLOR: #FFFFFF;
	color: #4f6b72;
}

/*先中后的情况*/
.TABLE .ListStyle TR.Selected TD {
	background-color: #DEF0FF;
	color: #000;
	height: 38px;
}

.TABLE .ListStyle TR.Selected TD a {
	color: #000;
}

.TABLE.ListStyle TR.Selected td {
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
.xTable_order {
	font-family: Webdings !important;
	overflow: hidden;
	padding-left: 5px;
}

.xTable_order_desc {
	color: #2877A2;
}

.xTable_order_asc {
	color: #D79D57;
}

/*=============for Browser style====================*/
TABLE.BroswerStyle {
	width: "100%";
	BACKGROUND-COLOR: #FFFFFF;
	BORDER-Spacing: 1pt;
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
	height: 28px;
	cursor: pointer;
	color: #4f6b72;
	background: #CAE8EA url(table/head-bg_wev8.png);
}

TABLE.BroswerStyle TR.DataHeader TD {
	COLOR: #000000;
	padding: 4px;
}

TABLE.BroswerStyle TR.DataHeader TH {
	padding: 4px;
	COLOR: #000000;
	TEXT-ALIGN: left
}

TABLE.BroswerStyle TR.DataDark {
	BACKGROUND-COLOR: #F5FAFA;
	HEIGHT: 28px;
	BORDER-Spacing: 1pt
}

TABLE.BroswerStyle TR.DataDark TD {
	PADDING-RIGHT: 0pt;
	PADDING-LEFT: 0pt;
	LINE: 100%
}

TABLE.BroswerStyle TR.DataLight {
	BACKGROUND-COLOR: #ffffff;
	HEIGHT: 28px;
	BORDER-Spacing: 1pt
}

TABLE.BroswerStyle TR.DataLight TD {
	PADDING-RIGHT: 0pt;
	PADDING-LEFT: 0pt;
	LINE: 100%
}

TABLE.BroswerStyle TR.Line {
	BACKGROUND-COLOR: #F5FAFA;
	BACKGROUND-REPEAT: repeat-x;
	HEIGHT: 3px
}

TABLE.BroswerStyle TR.Selected {
	CURSOR: pointer;
	background: #B1D4D9;
	height: 28px;
}

TABLE.BroswerStyle TR.Selected TD {
	PADDING-RIGHT: 0pt;
	PADDING-LEFT: 0pt;
	LINE: 100%
}

/*View Form样式*/
TABLE.ViewForm {
	WIDTH: 100%;
	border: 0;
	margin: 0;
	border-collapse: collapse;
	border-left: 1px solid #E6E6E6;
	border-top: 1px solid #E6E6E6;
	border-right: 1px solid #E6E6E6;
}

TABLE.ViewForm A {
	COLOR: blue;
	TEXT-DECORATION: none
}

TABLE.ViewForm A:hover {
	COLOR: red;
	TEXT-DECORATION: none
}

TABLE.ViewForm A:link {
	COLOR: blue;
	TEXT-DECORATION: none
}

TABLE.ViewForm A:visited {
	TEXT-DECORATION: none
}

TABLE.ViewForm TR {
	height: 35px;
}

TABLE.ViewForm TR.Title TH {
	TEXT-INDENT: -1pt;
	TEXT-ALIGN: left;
}

TABLE.ViewForm TR.Spacing {
	HEIGHT: 4px
}

TABLE.ViewForm TD {
	padding: 0 0 0 5;
	BACKGROUND-COLOR: #F7F7F7;
}

TABLE.ViewForm[valign='top'] TD {
	BACKGROUND-COLOR: #ffffff !important;
}

TABLE.ViewForm TD.Field {
	PADDING-RIGHT: 3px;
	PADDING-LEFT: 2px;
	BACKGROUND-COLOR: #ffffff;
}

/*
TABLE.ViewForm TD.Field {
	PADDING-RIGHT: 3px; PADDING-LEFT: 2px; BACKGROUND-COLOR:#fafafa!important;
	
}
*/
TABLE.ViewForm TR.Spacing TD.Line {
	BACKGROUND-COLOR: #E6E6E6 !important;
	BACKGROUND-REPEAT: repeat-x;
	HEIGHT: 1px
}

TABLE.ViewForm TD.Line {
	BACKGROUND-COLOR: #E6E6E6;
	BACKGROUND-REPEAT: repeat-x;
	HEIGHT: 1px
}

TABLE.ViewForm TD.Line1 {
	BACKGROUND-COLOR: #E6E6E6;
	BACKGROUND-REPEAT: repeat-x;
	HEIGHT: 2px
}

TABLE.ViewForm TD.Line2 {
	BACKGROUND-COLOR: #D8ECEF;
	BACKGROUND-REPEAT: repeat-x;
	HEIGHT: 1px
}

TABLE.ViewForm TR.Line {
	HEIGHT: 1px;
}

TABLE.ViewForm TR.Line1 {
	HEIGHT: 1px;
}

TABLE.ViewForm TR.Line2 {
	HEIGHT: 1px;
}
/*For lisbox*/
.listbox {
	
}

button {
	margin: 0;
	padding: 0;
	border: none;
	background-color: transparent;
	cursor: pointer;
	overflow: visible;
	outline: none;
	moz-outline: none;
}

*:first-child+html button[type] {
	width: 1;
} /* IE7 */
button span {
	background: transparent url(elements/btn_right_wev8.gif) no-repeat
		scroll right top;
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
.btn {
	border: 0px;
	cursor: pointer;
	background-color: #F9F9F9;
	padding-left: 0;
	padding-left: 10px;
	padding-right: 10px;
	height: 30px;
	line-height: 30px;
	color: #000;
	width: 75px;
}

.btnHover {
	background-color: #0178d1 !important;
}

.btnHoverAdvance {
	background-color: #fff !important;
}

.e8_btn_submit {
	border: 0px;
	cursor: pointer;
	padding-left: 0;
	padding-left: 10px;
	padding-right: 10px;
	height: 30px;
	line-height: 30px;
	background-color: #558ED5;
	color: white;
	width: 100px;
}

.e8_btn_submit_hover {
	background-color: #0170C1 !important;
	color: white;
}
</style>

<script language="javascript" type="text/javascript">
function doSubmit(){
// 	var filepath = weaver.filepath.value;
// 	if(filepath.lastIndexOf(".key")<1)
// 	{
// 		alert("备案环境文件信息格式不正确!");
// 		return;
// 	}
// 
$("#projectpathspan font").show();
$("#upload").hide();
$("#maintable  tr:not(:first)").html(""); 
	document.weaver.submit();
}
function exportExcel(){
	document.getElementById("excels").src="/keygenerator/CompareEnvironmentExcel.jsp?sourcePath=<%=currentpath.replace("\\","\\\\")%>&targetPath=<%=projectpath.replace("\\","\\\\")%>";
}

	
</script>
</head>
<body >
	<table width=100% height=100% border="0" cellspacing="0"
		cellpadding="0">
<!-- 		<table Style = " width:100%; height:100%; border:0; cellspacing:0; -->
<!-- 		cellpadding:0 "> -->
		<colgroup>
			<col width="15">
			<col width="">
			<col width="15">
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td width="15" height="90">&nbsp;</td>
			<td valign="top">
				<form name="weaver" method="post" target="_self" action="/keygenerator/CompareEnvironment.jsp">
				<input type ="hidden" id="isSearch" name="isSearch" value="1">
					<table class=Shadow>
						<tr>
							<td valign="top">
								<table class=ViewForm>
									<tbody>
										<tr>
											<td colspan=3 style="background-color: #558ed5; font-size: 16px; color: white;"><DIV>ecology环境文件信息对比</DIV></td>
										</tr>
										<tr class=Spacing style="height: 1px">
											<td class=Line colspan=3></td>
										</tr>
										<tr>
											<td width=15%>源环境文件路径</td>
											<td  width=60%> <input id=currentpath name=currentpath  value="<%=currentpath %>"  width="80%"></input>&nbsp;&nbsp; 
											<span id=currentpathsqpn ><font color="red">*</font>默认当前环境文件路径</span>
											</td>
											<td align=left>
											</td>
										</tr>
										<tr>
											<td width=15%>目标环境文件路径</td>
											<td  width=60%><input id=projectpath name=projectpath  value="<%=projectpath %>"  width="80%"></input>&nbsp;&nbsp; 
											<span id="projectpathspan" >
											<font size = "4" color="red">环境差异对比中,请等待······</font></span>
											</td>
											<td align=left>
												<button type="button" id="submitBtn"  onclick="doSubmit()" class="e8_btn_submit">对比系统</button>
												<%if(canupload){ %>
												<button type="button"  onclick="exportExcel()" class="e8_btn_submit" id="upload" name ="upload" >导出Excel</button>
												<%} %>
											</td>
										</tr>
										<tr id="source_auth" style="display: none">
												<td width=15%>源环境用户名密码</td>
												<td width=60%>
												用户名：<input type="text" id="username_sour"  name="username_sour">
												密码：<input type="password" id="password_sour"  name="password_sour">
												</td>
												<td align=left>
												</td>
										</tr>
										<tr id="target_auth" style="display: none">
												<td width=15%>目标环境用户名密码</td>
												<td width=60%>
												用户名：<input type="text" id="username_targ" name="username_targ">
												密码：<input type="password" id="password_targ" name="password_targ">
												</td>
												<td align=left>
												</td>
										</tr>
										<tr class=Spacing style="height: 1px">
											<td class=Line colspan=3></td>
										</tr>

									</tbody>
								</table>
							</td>
						</tr>
					</table>
		</form>
			</td>
			<td width="15">&nbsp;</td>

		</tr>
		<tr >
			<td width="15px">&nbsp;</td>
			<td  valign="top" width="*">
				<TABLE id="maintable" class=ListStyle  style="margin: 0px;cellspacing=1">
					<colgroup>
						<col width="3%">
						<col width="45%">
						<col width="10%">
						<col width="12%">
						<col width="12%">
					<tr class=header>
						<td>序号
<!-- 						<input type='checkbox' id=checkAllList name=checkAllList onclick="checkAllList1(this);"> -->
						</td>
						<td>文件路径</td>
						<td>对比结果说明</td>
						<td>源环境最后修改日期</td>
						<td>目标环境最后修改日期</td>
					</tr>
 <%
		        int colorcount = 0;
		        if(null!=fileMap&&fileMap.size()>0)
		        {
			        Set keyset = fileMap.keySet();
			        int i = 1;
					for(Iterator it = keyset.iterator();it.hasNext();)
					{
						String realfilepath = "";
						String filename = Util.null2String((String)it.next()).trim();
						String[] values = Util.null2String((String)fileMap.get(filename)).trim().split("[+]");
						String lastModifieddate_source="";
						String lastModifieddate_target="";
						String operatetype="";
						if(values.length==3){
							operatetype=values[0];
							lastModifieddate_source = values[1];
							lastModifieddate_target = values[2];
						}else{continue;}
					
						if(filename.startsWith("/")) {
							filename = filename.substring(1,filename.length());
						}
						if(operatetype.equals("1")||operatetype.equals("2")){
							realfilepath = ("\\".equals(""+File.separatorChar))?currentpath+(filename.replaceAll("/","\\\\")):currentpath+filename;
						}else if(operatetype.equals("0")){
							realfilepath =("\\".equals(""+File.separatorChar))? projectpath+(filename.replaceAll("/","\\\\")):projectpath+filename;
						}
						
						String datacolor = operatetype.equals("2")?"red":operatetype.equals("1")?"green":"blue";
						
// 						if(!lastModifieddate_target.equals("-")&&!lastModifieddate_source.equals("-")) {
// 							lastModifieddate_target =  TimeUtil.getDateString(TimeUtil.getString2Date(lastModifieddate_target, "yyyy'-'MM'-'dd"));
// 							lastModifieddate_source =  TimeUtil.getDateString(TimeUtil.getString2Date(lastModifieddate_source, "yyyy'-'MM'-'dd"));
// 							if(lastModifieddate_target.compareTo(lastModifieddate_source)>0){
// 								datacolor = "green";
// 							}else if(lastModifieddate_target.compareTo(lastModifieddate_source)<0) {
// 								datacolor = "red";
// 							}
// 						}
						
						
						if(colorcount==0) {
							colorcount=1;
					%>
					<TR class=DataLight>
					<% } else {
							colorcount=0;
					%>
					<TR class=DataDark>
					<%
						}
					%>
						<td height="23" >
<%-- 							<input type='checkbox' id=checkbh name=checkbh value=<%=realfilepath%>>  --%>
							<span><%=i++ %></span>
						</td>
						<td  height="23" style="color:<%=datacolor%>">
							<%=realfilepath %>
						</td>
						<td  height="23">
							<%
							if(operatetype.equals("0")) {
								out.print("源环境不存在该文件");
							}
							else if(operatetype.equals("1")) {
								out.print("目标环境不存在该文件");
							}
							else if(operatetype.equals("2")) {
								out.print("目标与源环境文件不一致");
							}
							%>
						</td>
						<td  height="23">
							<font ><%=lastModifieddate_source %></font>
						</td>
						<td  height="23">
							<font><%=lastModifieddate_target %></font>
						</td>
					</tr>
				<%
					}
		        }
				%>
				</TABLE>
			</TD>
			<td width="15px">&nbsp;</td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
<iframe name="excels" id="excels" src="" style="display:none" ></iframe> 
</body>
<script type="text/javascript">
// 由于控件不支持textarea添加iseditable属性，在加载完成后遍历添加readonly属性
window.onload = function (){
	if(<%=cpath%>==2){
		$("#source_auth").show();
	}else if(<%=ppath%>==2){
		$("#target_auth").show();
	}
	showMessage();
	$("#upload").show();
}

function showMessage(){
	<%if (isSearch.equals("1")&&!"".equals(message)) {%>
	alert('<%=message%>');
<%}%>
}
function checkAllList1(obj)
{
	var checked = obj.checked;
	var checkbhs = document.getElementsByName("checkbh");
	if(checkbhs)
	{
		if(checkbhs.length>0)
		{
			for(var i = 0;i<checkbhs.length;i++)
			{
				var checkbh = checkbhs[i];
				if(checked)
					checkbh.checked = true;
				else
					checkbh.checked = false;
			}
		}
	}
}




</script>
</html>