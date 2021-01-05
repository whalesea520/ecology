<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	//if (!HrmUserVarify.checkUserRight("WorkflowMonitor:All", user))
	//{
		//response.sendRedirect("/notice/noright.jsp");
		//return;
	//}
%>
<%
		String imagefilename = "/images/hdHRMCard_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(2239, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
		
		String isclose = Util.null2String(request.getParameter("isclose"));
	%>
<HTML>
	<HEAD>
<style type="text/css">
div{
      text-align: center;
      padding-top: 28px;
}
table{
       margin: auto;
       valign：middle;
}
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>

<script type="text/javascript">
var dialog;
var parentWin;
try {
dialog = parent.getDialog(window);
parentWin = parent.getParentWindow(window);
} catch (e) {}
function btn_cancle(){
	parentWin.closeDialog();
}
function checknamenew(){
	var templatename = jQuery("input[name='templatename']").val();
	if(templatename != null && templatename != ""){
		jQuery("#templatename").css("display","none");
	}else{
		jQuery("#templatename").css("display","");
	}
}

if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/monitor/CustomMonitorTypeTab.jsp";
	parentWin.closeDialog();	
}
function submitData()
{
	if (check_form(weaver,'templatename')){
		var str1 = $("input[name='templatename']").val();
		parentWin.setTemplatename(str1);
		parentWin.onSaveAsTemplate();
		dialog.close();
	}
}		
$("#zd_btn_submit").hover(function(){
	$(this).addClass("zd_btn_submit_hover");
},function(){
	$(this).removeClass("zd_btn_submit_hover");
});

$("#zd_btn_cancle").hover(function(){
	$(this).addClass("zd_btn_cancleHover");
},function(){
	$(this).removeClass("zd_btn_cancleHover");
});

</script>


</head>
	
<BODY style="overflow:hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<input type="hidden" name=operation value=add>
<div class="zDialog_div_content">

<FORM id=weaver name=frmMain action="MonitorTypeOperation.jsp" method=post>
<div>
<table >
	<tr align="center">
		<td align="center"><%=SystemEnv.getHtmlLabelName(28050,user.getLanguage())%></td>
		<td align="center"><input type=text size=30 class=Inputstyle name="templatename" onchange="checknamenew()"><span style="display:inline-block;" id="templatename"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span></td>
		<td><input type=text style="display:none;"></td>
	</tr>
</table>
</div>
</form>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitData()">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>


</BODY>
</HTML>
