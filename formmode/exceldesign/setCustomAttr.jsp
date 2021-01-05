<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String isDetail = Util.null2String(request.getParameter("isDetail"));
	String locatetarget = Util.null2String(request.getParameter("locatetarget"));
	boolean setDetailColAttr = "on".equals(isDetail)&&"col".equals(locatetarget);
	String hideitemname = "";
	if("row".equals(locatetarget)){
		hideitemname = "隐藏行";
	}else if("col".equals(locatetarget)){
		hideitemname = "隐藏列";
	}else{
		hideitemname = "隐藏内容";
	}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
	.blueborder{border-bottom:2px solid #B7E0FE;}
	.custable{border:0px; margin:0px; padding:0px; border-collapse:collapse}
	.inputwidth{width:80% !important}
</style>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:saveWin(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:clearSet(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage()) + ",javascript:closeWin(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="自定义属性"/>
</jsp:include> 
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" onclick="saveWin()" class="e8_btn_top" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" onclick="clearSet()" class="e8_btn_top" />
	      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="zDialog_div_content" style="height:400px">
<wea:layout type="2col" attributes="{'cw1':'35%','cw2':'65%'}">
	<%if(!"on".equals(isDetail) || setDetailColAttr){ %>
	<wea:group context="是否隐藏">
		<wea:item><%=hideitemname %></wea:item>
		<wea:item>
			<input type="checkbox" id="attr_hide" />
			<%if(setDetailColAttr){ %>
			<span class="e8tips" title="隐藏列的列宽尽量设置偏小，降低对其他列的宽度影响.">
				<img src="/images/tooltip_wev8.png" align="absMiddle" style="position:relative; top:-2px;">
			</span>
			<%} %>
		</wea:item>
	</wea:group>
	<%} %>
	<wea:group context="常用属性">
		<wea:item attributes="{'colspan':'2'}">
			<div class="blueborder" style="background:rgb(248,248,248);height:30px;line-height:30px;">
				<span style="margin-right:80px;">属性名称</span>
				<span>属性值</span>
			</div>
		</wea:item>
		<%if(!setDetailColAttr){ %>
		<wea:item>ID</wea:item>
		<wea:item><input type="text" id="attr_id" class="InputStyle inputwidth" /></wea:item>
		<wea:item>name</wea:item>
		<wea:item><input type="text" id="attr_name" class="InputStyle inputwidth" /></wea:item>
		<%} %>
		<wea:item>class</wea:item>
		<wea:item><input type="text" id="attr_class" class="InputStyle inputwidth" /></wea:item>
		<%if(!setDetailColAttr){ %>
		<wea:item>style</wea:item>
		<wea:item><input type="text" id="attr_style" class="InputStyle inputwidth" /></wea:item>
		<%} %>
	</wea:group>
	<%if(!"on".equals(isDetail)){ %>
	<wea:group context="自定义属性">
		<wea:item type="groupHead">
			<input type=button class=addbtn onclick="addCusAttr(false)" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
			<input type=button class=delbtn onclick="delCusAttr()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
		</wea:item>
		<wea:item attributes="{'colspan':'2'}">
			<div id="cusdiv">
				<table id="custable" class="custable" style="width:100%">
					<colgroup>
						<col width="10%"></col>
						<col width="35%"></col>
						<col width="55%"></col>
					</colgroup>
					<tr style="background:rgb(248,248,248)">
						<td class="blueborder"><input type="checkbox" id="checknode_all" /></td>
						<td class="blueborder">属性名称</td>
						<td class="blueborder">属性值</td>
					</tr>
				</table>
			</div>
		</wea:item>
	</wea:group>
	<%} %>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" class="zd_btn_cancle" onclick="closeWin();">
			</wea:item>
		</wea:group>
	</wea:layout>      
</div>
</body>
<script>
var cusIndex = 0;
var dialog;
var parentWin;

jQuery(document).ready(function(){
	dialog = window.top.getDialog(window);
	parentWin = window.top.getParentWindow(window);
	var attrs = parentWin.baseOperate.getCurrentAttrsFace();
	for(var key in attrs){
		if(key == "id")
			$("#attr_id").val(attrs[key]);
		else if(key == "name")
			$("#attr_name").val(attrs[key]);
		else if(key == "class")
			$("#attr_class").val(attrs[key]);
		else if(key == "style")
			$("#attr_style").val(attrs[key]);
		else if(key == "hide"){
			if(attrs[key] == "y")
				$("#attr_hide").attr("checked", true).next().addClass("jNiceChecked");
		}else{
			addCusAttr(true);
			jQuery("#custable tbody").find("#cusname_"+cusIndex).val(key);
			jQuery("#custable tbody").find("#cusval_"+cusIndex).val(attrs[key]);
		}
	}
	jQuery("#checknode_all").click(function(){
		var state = jQuery("#checknode_all").attr("checked");
		jQuery("#custable").find("input[name='checknode']").each(function(){
			if(state){
				$(this).attr("checked",true).next().addClass("jNiceChecked");
			}else{
				$(this).attr("checked",false).next().removeClass("jNiceChecked");
			}
		});
	});
});

function addCusAttr(isready){
	cusIndex++;
	var tdHtml = '<tr class="cusrecord">';
	tdHtml += '<td><input type="checkbox" id="node_'+cusIndex+'" name="checknode" /></td>';
	tdHtml += '<td><input type="text" id="cusname_'+cusIndex+'" name="cusname" class="InputStyle inputwidth" onChange="checkinpute8(this,\'cusname_'+cusIndex+'_span\')" />';
	tdHtml += '<span id="cusname_'+cusIndex+'_span">';
	if(!isready)
		tdHtml += '<img src="/images/BacoError_wev8.gif" align=absmiddle />';
	tdHtml += '</span></td>';
	tdHtml += '<td><input type="text" id="cusval_'+cusIndex+'" name="cusval" class="InputStyle inputwidth" onChange="checkinpute8(this,\'cusval_'+cusIndex+'_span\')" />';
	tdHtml += '<span id="cusval_'+cusIndex+'_span">';
	if(!isready)
		tdHtml += '<img src="/images/BacoError_wev8.gif" align=absmiddle />';
	tdHtml += '</span></td>';
	tdHtml += '</tr>';
	jQuery("#custable tbody").append(tdHtml);
	jQuery("body").jNice();
}

function delCusAttr(){
	jQuery("#custable").find("input[name='checknode']:checked").each(function(){
		$(this).closest("tr").remove();
	});
}

function verifySave(){
	var verifyResult = true;
	jQuery("table#custable").find("tr.cusrecord").each(function(){
		var _cusname = jQuery.trim($(this).find("input[name='cusname']").val());
		var _cusval = jQuery.trim($(this).find("input[name='cusval']").val());
		if(_cusname == "" || _cusval == ""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage()) %>");
			verifyResult = false;
			return false;
		}else{
			if(_cusname.toLowerCase() === "id" || _cusname.toLowerCase() === "name"
				||_cusname.toLowerCase() === "class" || _cusname.toLowerCase() === "style"
				||_cusname.toLowerCase() === "_format" || _cusname.toLowerCase() === "_financial"
				||_cusname.toLowerCase() === "_formula" || _cusname.toLowerCase() === "_cellattr"
				||_cusname.toLowerCase() === "_fieldid"){
				window.top.Dialog.alert("自定义属性名称不能为id/name/class/style/</br>_format/_financial/_formula/_cellattr/_fieldid</br>中任一项！");
				verifyResult = false;
				return false;
			}
		}
	});
	return verifyResult;
}

function saveWin(){
	if(!verifySave())
		return;
	var retJson = {};
	if($("#attr_hide").attr("checked"))
		retJson.hide = "y";
	var attr_id = jQuery.trim($("#attr_id").val());
	if(attr_id !== "")
		retJson.id = attr_id;
	var attr_name = jQuery.trim($("#attr_name").val());
	if(attr_name !== "")
		retJson.name = attr_name;
	var attr_class = jQuery.trim($("#attr_class").val());
	if(attr_class !== "")
		retJson.class = attr_class;
	var attr_style = jQuery.trim($("#attr_style").val());
	if(attr_style !== "")
		retJson.style = attr_style;
	
	jQuery("table#custable").find("tr.cusrecord").each(function(){
		var _cusname = jQuery.trim($(this).find("input[name='cusname']").val());
		var _cusval = jQuery.trim($(this).find("input[name='cusval']").val());
		retJson[_cusname] = _cusval;
	});
	try{
		dialog.close(retJson);
	}catch(e){}
}

function clearSet(){
	if($("#attr_hide").attr("checked"))
		$("#attr_hide").attr("checked", false).next().removeClass("jNiceChecked");
	$("#attr_id,#attr_name,#attr_class,#attr_style").val("");
	jQuery("table#custable").find("tr.cusrecord").remove();
}

function closeWin(){
	try{
		dialog.close();
	}catch(e){}
}
</script>
</html>