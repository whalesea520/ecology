<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String set_id = Util.null2String(request.getParameter("set_id"));
	String set_name = Util.null2String(request.getParameter("set_name"));
	String set_src = Util.null2String(request.getParameter("set_src"));
	String set_style = Util.null2String(request.getParameter("set_style"));
	
	int chooseheight = 1;
	String set_height = Util.null2String(request.getParameter("set_height"));
	if("auto".equals(set_height) || "".equals(set_height)){
		chooseheight = 0;
		set_height = "";
	}
%>
<html>
<head>
	<link rel=stylesheet type=text/css href=/css/Weaver_wev8.css />
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<style>
		.width1{width:60px !important;}
		.width2{width:120px !important;}
		.width3{width:80% !important;}
		.paramnotice{height:26px; line-height:26px}
		.paramlist{display:inline-block; height:26px; line-height:26px; cursor:pointer; color:#30b5ff;}
		.setsrc{word-break:break-all; word-wrap:break-word;}
		#set_heightspan{display:inline-block; width:12px;}
	</style>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="Iframe区域设置"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" onclick="onSave();" class="e8_btn_top" id="btnok">
	      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'cw1':'20%','cw2':'80%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %>'>
		<wea:item>ID</wea:item>
		<wea:item>
			<input type="text" class="InputStyle width2" id="set_id" value="<%=set_id %>"/>
		</wea:item>
		<wea:item>name</wea:item>
		<wea:item>
			<input type="text" class="InputStyle width2" id="set_name" value="<%=set_name %>"/>
		</wea:item>
		<wea:item>src</wea:item>
		<wea:item>
			<textarea id="set_src" class="setsrc width3" rows="3" onchange="checkinpute8(this,'set_srcspan');"><%=set_src %></textarea>
			<span id="set_srcspan"><img style="<%="".equals(set_src)?"":"display:none" %>" src="/images/BacoError_wev8.gif" align="absMiddle"></span>
			<span style="cursor:pointer;" id=remind>
			<img id=ext-gen124  title="<%=SystemEnv.getHtmlLabelName(82358,user.getLanguage())%>&#10;1：$billid$数据id，$modeid$模块id，$formid$表单id&#10;<%=SystemEnv.getHtmlLabelName(82360,user.getLanguage())%>#10;<%=SystemEnv.getHtmlLabelName(82361,user.getLanguage())%>" align=absMiddle src="/images/remind_wev8.png">
			</span>
			<div class="paramnotice">
				<span>模块常用参数</span>
				<span style="color:#b7b7b7;">(点击可自动生成参数插入到src结尾)</span>
			</div>
			<span class="paramlist" target="billid">数据ID(billid)</span></br>
			<span class="paramlist" target="modeid">模块ID(modeid)</span></br>
			<span class="paramlist" target="formid">表单ID(formid)</span></br>
		</wea:item>
		<wea:item>height</wea:item>
		<wea:item>
			<select id="chooseheight">
				<option value="0" <%=chooseheight==0?"selected":"" %> >自适应</option>
				<option value="1" <%=chooseheight==1?"selected":"" %> >固定高度</option>
			</select>
			<span id="fixedheight" style="<%=chooseheight==0?"display:none":"" %>">
				<input type="text" class="InputStyle width1" id="set_height" value="<%=set_height %>"/>
				<span id="set_heightspan"><img style="<%="".equals(set_height)?"":"display:none" %>" src="/images/BacoError_wev8.gif" align="absMiddle"></span>px
			</span>
			<span id="autoheighttips" style="<%=chooseheight==1?"display:none":"" %>" class="e8tips" title="跨域内嵌网络页面时，自适应高度可能无效！">
				&nbsp;<img src="/images/tooltip_wev8.png" align="absMiddle">
			</span>
		</wea:item>
		<wea:item>style</wea:item>
		<wea:item>
			<input type="text" class="InputStyle width3" id="set_style" value="<%=set_style %>"/>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
<script type="text/javascript">
var dialog;
jQuery(document).ready(function(){
	dialog = window.top.getDialog(window);
	jQuery("#set_height").blur(function(){
		var set_height = jQuery(this).val().trim();
		var reg = /^\d+(\.\d+)?$/;
		if(set_height == "" || set_height == "0" || !reg.test(set_height))
			jQuery(this).val("");
		checkinpute8(this,'set_heightspan');
	});
	jQuery("#chooseheight").change(function(){
		var fixedheight = jQuery("#fixedheight");
		var autoheighttips = jQuery("#autoheighttips");
		if(jQuery(this).val() == "0"){
			fixedheight.hide();
			autoheighttips.show();
		}else{
			fixedheight.show();
			autoheighttips.hide();
		}
	});
	jQuery(".paramlist").click(function(){
		var curSrc = jQuery("#set_src").val().trim();
		var addParam = jQuery(this).attr("target")+"=$"+jQuery(this).attr("target")+"$";
		if(curSrc.indexOf(addParam) > -1)
			return;
		var addSymbol = "";
		if(curSrc.indexOf("?") == -1)
			addSymbol = "?";
		else if(curSrc.length>0 && curSrc.substring(curSrc.length-1)!="&" && curSrc.substring(curSrc.length-1)!="?")
			addSymbol = "&";
		var setSrc = curSrc+addSymbol+addParam;
		jQuery("#set_src").val(setSrc).text(setSrc).trigger("onchange");
	});
});

function onSave(){
	var chooseheight = jQuery("#chooseheight").val();
	if((chooseheight == "1" && jQuery("#set_heightspan").find("img:visible").size() > 0 )
		|| jQuery("#set_srcspan").find("img:visible").size() > 0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
		return;
	}
	var set_src = jQuery("#set_src").val().trim();
	if(isChineseStr(set_src)){
		window.top.Dialog.alert("src不能包含中文");
		return;
	}
	var retJson = {};
	jQuery("#set_id,#set_name,#set_src,#set_style").each(function(){
		var key = jQuery(this).attr("id");
		var value = jQuery(this).val().trim();
		if(value != "")
			retJson[key] = value;
	});
	if(chooseheight == "0")
		retJson["set_height"] = "auto";
	else if(chooseheight == "1")
		retJson["set_height"] = jQuery("#set_height").val().trim();
	dialog.close(retJson);	
}

function onClose(){
	dialog.close();
}

function isChineseStr(str){
	var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
	return reg.test(str);
}
</script>
</html>