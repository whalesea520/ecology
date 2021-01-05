<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.mobile.plugin.PluginCenter"%>
<%@page import="com.weaver.formmodel.mobile.plugin.Plugin"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
PluginCenter pluginCenter = PluginCenter.getInstance();
List<Plugin> plugins = pluginCenter.loadPlugin();
%>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link type="text/css" rel="stylesheet" href="/mobilemode/css/mec/mec_design_wev8.css" />
<style>
*{
	font: 12px Microsoft YaHei;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
}
#mec_item_container {
	width: 470px;
	background-color: #fff;
	padding: 0px 5px 8px 5px;
	color: #222222;
}
.mec_item {
	border: 1px solid #fff;
}
.item_sel {
	border: 1px solid rgb(114,173,9);
	background-color: #f5f5f5;
}
.mec_node em{
	margin-left: 5px;
}
.mec_node span{
	width: 50px;
}
</style>
<script>
$(document).ready(function () {
	$(".mec_item").click(function(){
		if(!$(this).hasClass("item_sel")){
			$(this).addClass("item_sel");
		}else{
			$(this).removeClass("item_sel");
		}
	});
});

function returnResult(){
	var mecTypes = [];
	$(".item_sel", $("#mec_item_container")).each(function(i){
		var mt = {};
		mt["mec_type"] = $(".mec_node",$(this)).attr("mec_type");
		mecTypes.push(mt);
	});
	
	if(top && top.callTopDlgHookFn){
		var result = {
			"mecTypes" : $.isEmptyObject(mecTypes) ? "" : JSON.stringify(mecTypes)
		};
		top.callTopDlgHookFn(result);
	}
	onClose();
}

function onOK(){
	returnResult();
}

function onClose(){
	top.closeTopDialog();
}
</script>
</HEAD>
<body class="style_language_<%=user.getLanguage() %>">
<div style="padding: 10px 12px;overflow-x:hidden;overflow-y: auto;height:240px">
	<div id="mec_item_container">
		<% for(int i = 0; i < plugins.size(); i++){
			Plugin plugin = plugins.get(i);
			if(!plugin.isEnabled()){
				continue;
			}
		%>
			<div class="mec_item">
				<div class="mec_node" id="<%=plugin.getId() %>" mec="true" mec_init="false" mec_type="<%=plugin.getId() %>">
					<em class="<%=plugin.getId() %>"></em>
					<span><%=SystemEnv.getHtmlLabelName(Util.getIntValue(plugin.getText()), user.getLanguage()) %></span>
				</div>
			</div>
		<% } %>
	</div>
</div>
<div class="e8_zDialog_bottom" style="position: absolute;right: 5px;bottom:-5px;margin-right: 16px;">
	<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
	<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%><!-- 取消 --></button>
</div>
</body>
</html>