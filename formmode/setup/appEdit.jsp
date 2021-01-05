<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@ page import="weaver.conn.RecordSetTrans"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ include file="/formmode/pub.jsp"%>
<%
AppInfoService appInfoService = new AppInfoService();
int appId =Util.getIntValue(request.getParameter("appId"), 0);
Map<String, Object> appInfo = appInfoService.getAppInfoById(appId);
String treeFieldName = Util.null2String(appInfo.get("treefieldname"));
String treeFieldDesc = Util.null2String(appInfo.get("treefielddesc"));
float showOrder = Util.getFloatValue(Util.null2String(appInfo.get("showorder")), 0.0f);
String superFieldId = Util.null2String(appInfo.get("superfieldid"));
int level = Util.getIntValue(Util.null2String(appInfo.get("treelevel")), 0);

int subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subCompanyId")),-1);
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
String subCompanyId2 = ""+subCompanyId;
if(appId==1){//根不控制
	operatelevel = 2;
}
RecordSet rs = new RecordSet();
rs.executeSql("select fmdetachable from SystemSet");
if(rs.next()){
	fmdetachable = rs.getString(1);
}
%>
<html>
<head>
<title></title>
<script language=javascript src="/js/weaver_wev8.js"></script>

<script language=javascript src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<LINK href="/wui/theme/ecology8/templates/default/css/default2_wev8.css" rel="stylesheet"  type="text/css"> 	  
<SCRIPT src="/wui/theme/ecology8/templates/default/js/default_wev8.js" type="text/javascript"></SCRIPT>
	
<style>
*{
	font: 12px Microsoft YaHei;
}
html,body{
	overflow: hidden;
}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 5px 5px 10px;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
a{
	text-decoration: none !important;
}
</style>
<script type="text/javascript">
jQuery(document).ready(function ($) {
	try{
		document.getElementById("treeFieldName").focus();
		if($("#treeFieldName").val() != "") {
			$("#treeFieldNameImage").hide();
		}
		$("#treeFieldName").bind("change", function() {
			if($(this).val() == ""){
				$("#treeFieldNameImage").show();
			}
		});
	}catch(e){}
});
function onSave() {
	hideRightClickMenu();
	
	var $ = jQuery;
	var newTreeFieldName = $("#treeFieldName").val();
	if(newTreeFieldName == ""){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>", function(){//请填写名称
			$("#treeFieldName")[0].focus();
		}, null, null, false);
		return;
	}
	var showOrder = $("#showOrder").val();
	if(showOrder == ""){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>", function(){//请填写顺序
			$("#showOrder")[0].focus();
		}, null, null, false);
		return;
	}
	<%if(fmdetachable.equals("1")){%>
		var subCompanyId = $("#subCompanyId").val();
		if(subCompanyId == ""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%>", function(){//请选择所属分部
				
			}, null, null, false);
			return;
		}
	<%}%>
		
	enableAllmenu();
	document.formApp.submit();	
}
function onClose(){
	top.closeTopDialog();
}
</script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;//保存
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onClose(),_top} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="formApp" name="formApp" method="post" action="/formmode/setup/appSettingsAction.jsp?action=editAppinfo">
<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none;">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel>0){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave()">
				<%}%>
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<input type="hidden" name="appId" value="<%=appId %>"/>
<input type="hidden" name="treelevel" value="<%=level%>"/>
<input type="hidden" name="editFromRightMenu" value="1"/>  
<table class="e8_tblForm">
<colgroup>
<col width="160px"/>
<col width="*"/>
</colgroup>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><!-- 名称 --></td>
	<td class="e8_tblForm_field"><input type="text" id="treeFieldName" name="treeFieldName" style="width:80%;" value="<%=treeFieldName %>" onchange="checkinput('treeFieldName','treeFieldNameImage')"/> 
	<span id="treeFieldNameImage">
		<img src="/images/BacoError_wev8.gif"/></td>
	</span>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81987,user.getLanguage())%><!-- 描述应用的基本功能。 --></div></td>
	<td class="e8_tblForm_field"><textarea name="treeFieldDesc" style="width:80%;height:80px;"><%=treeFieldDesc %></textarea></td>
</tr>
<%if(fmdetachable.equals("1")){%>
<tr <%if(appId==1){%>style="display: none;"<%} %> >
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%><!-- 所属分部 --></td>
	<td class="e8_tblForm_field">
	<brow:browser name="subCompanyId" viewType="0" hasBrowser="true" hasAdd="false" 
        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=FORMMODEAPP:ALL" isMustInput="2" isSingle="true" hasInput="true"
        completeUrl="/data.jsp?type=164_1&rightStr=FORMMODEAPP:ALL"  width="260px" browserValue="<%=subCompanyId2%>" browserSpanValue="<%=SubCompanyComInfo.getSubCompanyname(subCompanyId2)%>" />
	</td>
</tr>
<%}else{%>
	<input type="hidden" name="subCompanyId" id="subCompanyId" value="<%=subCompanyId2 %>" />
<%} %>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81988,user.getLanguage())%><!-- 上级应用 --></td>
	<td class="e8_tblForm_field"><span><%=appInfoService.getAllSuperiorFieldName(Util.getIntValue(superFieldId)) %></span>
	<input type="hidden" id="superFieldId" name="superFieldId" value="<%=superFieldId %>"/>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%><!-- 顺序 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81989,user.getLanguage())%><!-- 定义应用的显示顺序。 --></div></td>
	<td class="e8_tblForm_field"><input type="text" id="showOrder" name="showOrder" value="<%=showOrder %>" onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)' onBlur='checknumber("showOrder");checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' />
	<span id="showOrderImage"></span>
	</td>
</tr>
</table>
</form>

<div class="e8_zDialog_bottom">
	<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%><!-- 取消 --></button>
</div>
</body>
</html>
