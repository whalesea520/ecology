
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import='java.util.ArrayList'%>
<%@ page import="java.util.Enumeration " %>
<%@ page import="weaver.general.Util" %>
<%@ page import='weaver.hrm.User'%>
<%@ page import='weaver.hrm.HrmUserVarify'%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%

String isclose = Util.null2String(request.getParameter("isclose"));
String qname = Util.null2String(request.getParameter("flowTitle"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" ;
String needfav ="1";
String needhelp ="";
%>
<style id="popupmanager"> 
.lgsm {width:70px;height:22px;background:url(/album/flash/upload_wev8.png) 0px 0px no-repeat; border:none;}
</style>
<html>
<title></title>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
if("<%=isclose%>"=="1"){
	var dialog = parent.getDialog(window); 
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/docs/tools/DocPicUpload.jsp";
	parentWin.closeDialog();	
}
</script>
</head>
<%


    int parentId = Util.getIntValue(request.getParameter("id"));

%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">

			<input type="button" id="BUTTONid" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("83513",user.getLanguage())%>" onclick="javascript:uploadok()"/>
		
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>

<%--	
		<table cellpadding="0" cellspacing="0" style="width:100%;">
			<tr><td bgcolor=menu>
			<BUTTON id="BUTTONid" class="lgsm" type="button"  onclick="uploadok()"></BUTTON>
			</td></tr>
		</table>
 --%>			

	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="860px" height="550px">
	     <param name="movie" value="YUploadImg.swf">
	     <param name="quality" value="high">
	     <param name="wmode" value="transparent">
	     <param name="FlashVars" value="parentId=<%=parentId%>">
	     <embed src="YUploadImg.swf" type="application/x-shockwave-flash" width="860" height="550" quality="high" FlashVars="parentId=<%=parentId%>" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed>
	</object> 
	
</body>
</html>

<script type="text/javascript">
function uploadok(){
	location.href = "/album/AlbumListTab.jsp?needrefreshtree=1&paraid=<%=parentId%>";
}
</script>