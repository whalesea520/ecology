<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<%
int id = Util.getIntValue(request.getParameter("id"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}

if("<%=isclose%>"=="1"){
	try{
		parentWin = parent.getParentWindow(window);
		parentWin.refreshLeftTree();
		parentWin.closeDialog();	
		//parentWin._table.reLoad();
		
		
	}catch(e){}
}
</script>
<script type="text/javascript">
function doSubmit(){
	if(check_form(weaver,'folderName')){
		weaver.submit();
	}
}
</script>
</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="photo"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18473,user.getLanguage()) %>"/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
//RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form method="post" action="AlbumFolderOperation.jsp" id="weaver" name="weaver">
<input type="hidden" name="operation" value="add" />
<input type="hidden" name="parentId" value="<%=id%>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSubmit();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1361",user.getLanguage())%>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="folderName" class="inputstyle" maxlength="20" onchange="checkinput('folderName','folderNameSpan')" />
		<SPAN id="folderNameSpan"><IMG src='/images/BacoError_wev8.gif' align="absMiddle"></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input type="text" name="photoDescription" class="inputstyle" maxlength="20" /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></wea:item>
		<wea:item><input type="text" name="orderNum" class="inputstyle" maxlength="3" /></wea:item>
	</wea:group>
</wea:layout>
</form>

<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %> 
</body>
</html>
