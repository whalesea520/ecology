<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	boolean allowInit = "true".equals(Util.null2String(request.getParameter("allowInit")));
%>
<html>
<head>
	<link rel=stylesheet type=text/css href=/css/Weaver_wev8.css />
	<style>
		p{height:20px; line-height:20px;}
	</style>
</head>
<body style="overflow:hidden;">
<div style="margin:30px 10px 10px 10px; height:40px;">
	<div style="float:left; width:36px; padding-top:6px;">
		<img src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" />
	</div>
	<div style="float:left;">
		<p><%=SystemEnv.getHtmlLabelName(128066, user.getLanguage())%></p>
		<p><%=SystemEnv.getHtmlLabelName(128067, user.getLanguage())%></p>
	</div>
</div>
<div style="margin:30px 10px 10px 46px; height:40px;">
	<p><%=SystemEnv.getHtmlLabelName(128068, user.getLanguage())%></p>
</div>
<div style="margin:40px 10px 10px 46px;">
	<input type="checkbox" id="autoInit" <%=allowInit?"":"disabled" %> />
	<span style="color:red;"><%=SystemEnv.getHtmlLabelName(128069, user.getLanguage())%></span>
	<span style="position:relative; top:-2px;" class="e8tips" title="<%=SystemEnv.getHtmlLabelName(129023, user.getLanguage())%>">
		<img src="/images/tooltip_wev8.png" align="absMiddle">
	</span>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" class="zd_btn_submit" onclick="onConfirm();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="onCancel();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
<script type="text/javascript">
	jQuery(document).unbind("contextmenu").bind("contextmenu", function(e){
		return false;
	});
	    
	var dialog = window.top.getDialog(window);
	function onConfirm(){
		dialog.close(jQuery("#autoInit").attr("checked")+"");
	}
	
	function onCancel(){
		dialog.close();
	}
</script>
</html>