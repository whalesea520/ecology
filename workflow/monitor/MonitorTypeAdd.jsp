<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	if (!HrmUserVarify.checkUserRight("WorkflowMonitor:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdHRMCard_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(2239, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
		
		String dialog = Util.null2String(request.getParameter("dialog"));
		String isclose = Util.null2String(request.getParameter("isclose"));
	%>
	<BODY style="overflow:hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		//if(!"1".equals(dialog)){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:btn_cancle(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		//} 
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id=weaver name=frmMain action="MonitorTypeOperation.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>	  
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694 ,user.getLanguage())%>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">				
			<span title="<%=SystemEnv.getHtmlLabelName(83721 ,user.getLanguage())%>" class="cornerMenu"></span>
		</td>												  
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(81711 ,user.getLanguage())%>'>	 
    	<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
	    <wea:item>
	    	<wea:required id="typenameimage" required="true">
	    		<input type=text size=30 class=Inputstyle name="typename" onchange='checkinput("typename","typenameimage")'>
	    	</wea:required>
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
    	<wea:item><input type=text size=60 name="typedesc" class=Inputstyle></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
    	<wea:item>
    		<input type=text size=10 class=inputstyle id="typeorder" name="typeorder" maxlength=3 onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);">
    	</wea:item>
    </wea:group>
</wea:layout>

<input type="hidden" name=operation value=add>
<input type="hidden" name="dialog" value="<%=dialog%>">
</form>
<%if("1".equals(dialog)){ %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
<script language="javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

function btn_cancle(){
	parentWin.closeDialog();
}

if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/monitor/CustomMonitorTypeTab.jsp";
	parentWin.closeDialog();	
}
function submitData()
{
	if (check_form(weaver,'typename'))
		weaver.submit();
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
</BODY>
</HTML>
