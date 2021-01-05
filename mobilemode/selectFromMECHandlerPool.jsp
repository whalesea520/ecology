<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
String id = StringHelper.null2String(request.getParameter("id"),"");
%>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
#mecHandlerContainer {
	overflow: hidden;
	width: 460px;
}
.mec_item {
	cursor: auto;
	display: block;
	float: left;
	font-family: 'Microsoft Yahei', Arial, sans-serif;
	font-size: 12px;
	font-style: normal;
	font-variant: normal;
	font-weight: normal;
	height: 54px;
	line-height: 14px;
	margin-bottom: 10px;
	width: 45px;
	margin-left: 4px;
	cursor: pointer;
	border: 1px solid #eee;
}
.item_sel {
	border: 1px solid rgb(114,173,9);
	background-color: #f5f5f5;
}
.mec_node {
	background-attachment: scroll;
	background-clip: border-box;
	background-color: rgba(0, 0, 0, 0);
	background-image: url(/mobilemode/images/mec/toolbarbg_wev8.png);
	background-origin: padding-box;
	background-position: 0px 0px;
	background-size: auto;
	display: block;
	font-family: 'Microsoft Yahei', Arial, sans-serif;
	font-size: 12px;
	font-style: normal;
	font-variant: normal;
	font-weight: normal;
	height: 54px;
	line-height: 14px;
	margin-bottom: 0px;
	margin-top: 0px;
	text-align: center;
	width: 40px;
}
.mec_node span {
	display: block;
	font-family: 'Microsoft Yahei', Arial, sans-serif;
	font-size: 11px;
	font-style: normal;
	font-variant: normal;
	font-weight: normal;
	margin-top: 2px;
	text-align: center;
	width: 45px;
	word-break:break-all;
}
</style>
<script>
$(document).ready(function () {
	var htm = top.MEC_Tab_BeChoose_Html_<%=id%>;
	var $mecHandlerContainer = $("#mecHandlerContainer");
	$mecHandlerContainer.append(htm);
	
	$(".mec_item").click(function(){
		if(!$(this).hasClass("item_sel")){
			$(this).addClass("item_sel");
		}else{
			$(this).removeClass("item_sel");
		}
	});
});

function returnResult(){
	var id = '<%=id%>';
	
	var mecHandlerids = [];
	$(".item_sel", $("#mecHandlerContainer")).each(function(i){
		var mecHandlerid = {};
		mecHandlerid["mecHandlerid"] = $(".mec_node",$(this)).attr("id");
		mecHandlerids.push(mecHandlerid);
	});
	
	if(top && top.callTopDlgHookFn){
		var result = {
			"mecHandlerIDs" : $.isEmptyObject(mecHandlerids) ? "" : JSON.stringify(mecHandlerids),
			"tabID" : id
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
<body>
<div style="padding: 10px 12px;overflow-y: auto;overflow-x: hidden;height: 160px;">
	<div id="mecHandlerContainer"></div>
</div>

<div class="e8_zDialog_bottom" style="position: absolute;right: 0px;bottom:0px;margin-right: 16px;">
	<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
	<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%><!-- 取消 --></button>
</div>
</body>
</html>