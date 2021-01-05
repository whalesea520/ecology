<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
	<link REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSumbit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(124958, user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" onclick="doSumbit()" class="e8_btn_top" id="btnok">
	      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="weaverform" method="post">
<wea:layout type="2col" attributes="{'cw1':'30%','cw2':'70%'}">
<wea:group context='<%=SystemEnv.getHtmlLabelName(124954, user.getLanguage()) %>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(21790, user.getLanguage()) %></wea:item>
	<wea:item>
		<select id="relationship">
			<option value="0"><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage()) %></option>
			<option value="1"><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage()) %></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage()) %></option>
		</select>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(124955, user.getLanguage()) %></wea:item>
	<wea:item>
		<brow:browser name="operators" viewType="0" hasBrowser="true" hasAdd="false" 
        		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
                isMustInput="2" isSingle="false" hasInput="true"
                completeUrl="/data.jsp"  width="300px" browserValue="" browserSpanValue="" /> 
	</wea:item>
</wea:group>
</wea:layout>
</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="doClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
<script>
var dialog = window.top.getDialog(window);
function doSumbit(){
	if(check_form(weaverform,"operators")){
		var retJson = {};
		retJson.relationship = jQuery("#relationship").val();
		retJson.operators = jQuery("[name='operators']").val();
		if(dialog){
			dialog.close(retJson);
		}else{
			window.returnValue = JSON.stringify(retJson);
			window.close();
		}
	}
}

function doClose(){
	if(dialog){
		dialog.close();
	}else{
		window.close();
	}
}
</script>
</html>
