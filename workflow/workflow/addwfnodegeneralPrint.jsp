<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
</HEAD>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:confirmchoose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closeCurDialog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow"/>
	<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage()) %>"/>
</jsp:include>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("33251,82,33234",user.getLanguage()) %>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %></wea:item>
			<wea:item>
				<select class=inputstyle  name="choosetype" onChange="change(this)" style="width:120px;">
					<option value="1"></option>
					<option value="2"><%=SystemEnv.getHtmlLabelNames("82,18017",user.getLanguage()) %></option>
					<option value="3"><%=SystemEnv.getHtmlLabelNames("82,23682",user.getLanguage()) %></option>
				</select>
			</wea:item>
			
		</wea:group>
	</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="zd_btn_cancle" onclick="confirmchoose();" />
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" class="zd_btn_cancle" onclick="closeCurDialog();" />
	    	</wea:item>
		</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
<script type="text/javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

function confirmchoose(){
	var choosetype=$("[name='choosetype']").val();
	if(choosetype=='2'){
		$("[name='createPrintButton_tx']",parentWin.document).click();
	}else if(choosetype=='3'){
		$("[name='createPrintButton_html']",parentWin.document).click();
	}
	dialog.close();
}

function closeCurDialog(){
	dialog.close();
}
</script>
</HTML>
