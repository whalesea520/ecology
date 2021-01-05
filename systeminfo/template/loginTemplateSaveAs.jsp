
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<script src="/js/weaver_wev8.js" type="text/javascript"></script>
<script src="/js/jquery/jquery_wev8.js" type="text/javascript"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<body>

<% 
	String templateid = Util.null2String(request.getParameter("templateid"));
	//处理状态
	String closeDialog = Util.null2String(request.getParameter("closeDialog"));
	String from = Util.null2String(request.getParameter("from"));
	String navName=SystemEnv.getHtmlLabelName(32459,user.getLanguage());
	String titlename="";
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=navName %>"/> 
		</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form id="frmMain" name="frmMain" action="loginTemplateOperation.jsp" method="post">
	<input type="hidden" name="operationType" id="operationType" value="saveAs"/>
	<input type ="hidden" name="templateid" id="templateid" value="<%=templateid %>"/>
	<input type ="hidden" name="from" id="from" value="<%=from %>"/>
	
<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"none\"}">
    <wea:item><%=SystemEnv.getHtmlLabelName(32533,user.getLanguage()) %>:</wea:item>
	<wea:item>
		<input type="text" class="inputstyle" name="saveAsName" id ="saveAsName" style="width:90% !important" onchange="checkinput('saveAsName','saveAsNameSpan')">
			
        <span id="saveAsNameSpan"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
	</wea:item>
	</wea:group>
</wea:layout>

	</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="dosubmit();">
		    	<span class="e8_sep_line">|</span>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	
</body>
<script type="text/javascript">
	
function dosubmit(){
	if(check_form(frmMain,"saveAsName")){
		$("#operationType").val("saveAs")
		
		document.frmMain.submit();
	}
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

jQuery(document).ready(function (){
	var closeDialog = "<%=closeDialog%>";
	var from = "<%=from%>";
	if(closeDialog=="close"){
		if(from=="dialog"){
			var parentWin = parent.getParentWindow(window);
		}else{
			var parentWin = parent.getParentWindow(window);
			parentWin.location.reload();
		}
		
		onCancel();
	}
})
</script>
</HTML>
