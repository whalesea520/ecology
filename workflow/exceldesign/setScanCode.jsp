<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ExcelLayoutManager" class="weaver.workflow.exceldesign.ExcelLayoutManager" scope="page"/>
<%
	int codetype = Util.getIntValue(request.getParameter("codetype"), 1);
	String qrCode = "{'samePair':'qrCode'}";
	String barCode = "{'samePair':'barCode'}";
	
	int formid = Util.getIntValue(request.getParameter("formid"));
	int isbill = Util.getIntValue(request.getParameter("isbill"));
	String relatefield = Util.null2String(request.getParameter("relatefield"));
	String hidetext = Util.null2String(request.getParameter("hidetext"));
	
	String relatefieldname = "";
	if(!"".equals(relatefield)){
		ArrayList<Map<String,String>> textfield = ExcelLayoutManager.getTextFieldList(formid, isbill, user.getLanguage(), "");
		String[] fieldidArr = relatefield.split(",");
		for(String fieldid: fieldidArr){
			for(Map<String,String> map: textfield){
				if(fieldid.equals(map.get("fieldid"))){
					relatefieldname += map.get("fieldname")+",";
					break;
				}
			}
		}
		if(relatefieldname.endsWith(","))
			relatefieldname = relatefieldname.substring(0, relatefieldname.length()-1);
	}
%>
<html>
<head>
	<link rel=stylesheet type=text/css href=/css/Weaver_wev8.css />
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<style>
		.codediv{margin-top:4px; margin-bottom:2px;}
		.noteinfo{color:#aeaeae !important; margin-bottom:4px;}
		.qrcodeimg{height:80px; width:80px; vertical-align:middle;}
		.barcodeimg{height:80px; width:260px; vertical-align:middle;}
	</style>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:doClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(128074, user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" onclick="doSave();" class="e8_btn_top" id="btnok">
	      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'cw1':'20%','cw2':'80%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(63, user.getLanguage()) %></wea:item>
		<wea:item>
			<input type="radio" name="codetype" value="1" <%=codetype==1 ? "checked" : "" %> />
			<span style="display:inline-block; margin-right:22px;"><%=SystemEnv.getHtmlLabelName(30184, user.getLanguage()) %></span>
			<input type="radio" name="codetype" value="2" <%=codetype==2 ? "checked" : "" %> />
			<span><%=SystemEnv.getHtmlLabelName(1362, user.getLanguage()) %></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(221, user.getLanguage()) %></wea:item>
		<wea:item>
			<div id="qrCodeDiv" class="codediv" style="display:<%=codetype==1 ? "" : "hidden" %>">
				<img class="qrcodeimg" src="/createQRCode?msg=泛微二维码" />
			</div>
			<div id="barCodeDiv" class="codediv" style="display:<%=codetype==2 ? "" : "hidden" %>">
				<img class="barcodeimg" src="/createWfBarCode?msg=Weaver-20150808&type=code128" />
			</div>
			<div class="noteinfo">
				<%=SystemEnv.getHtmlLabelName(128076, user.getLanguage())%></br>
				<%=SystemEnv.getHtmlLabelName(128077, user.getLanguage())%>
			</div>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("30754,563",user.getLanguage()) %></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="relatefield" 
				browserValue="<%=relatefield %>" getBrowserUrlFn="getChooseFieldUrl" 
				hasInput="false" isSingle="false" hasBrowser="true" isMustInput="2"
				completeUrl="" browserSpanValue="<%=relatefieldname %>">
			</brow:browser>
		</wea:item>
		<wea:item attributes="<%=barCode %>"><%=SystemEnv.getHtmlLabelNames("23857,563,608",user.getLanguage()) %></wea:item>
		<wea:item attributes="<%=barCode %>">
			<input type="checkbox" tzCheckbox="true" name="hidetext" <%="true".equals(hidetext)?"checked":"" %> onclick="switchHideText();"/>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="zd_btn_cancle" onclick="doClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
<script type="text/javascript">
var dialog;
jQuery(document).ready(function(){
	dialog = window.top.getDialog(window);
	jQuery("[name='codetype']").click(controlShowArea);
	controlShowArea();
	switchHideText();
});

function controlShowArea(){
	var codetype = jQuery("[name='codetype']:checked").val();
	if(codetype == "1"){
		jQuery("#qrCodeDiv").show();
		jQuery("#barCodeDiv").hide();
		showEle("qrCode");
		hideEle("barCode", true);
	}else if(codetype == "2"){
		jQuery("#qrCodeDiv").hide();
		jQuery("#barCodeDiv").show();
		showEle("barCode");
		hideEle("qrCode", true);
	}
}

function switchHideText(){
	var imgobj = jQuery("#barCodeDiv").find("img");
	var imgsrc = imgobj.attr("src");
	imgsrc = imgsrc.replace(/&hrp=none/gi,"");
	if(jQuery("[name='hidetext']").attr("checked")){
		imgsrc = imgsrc+"&hrp=none";
	}
	imgobj.attr("src", imgsrc);
}

function getChooseFieldUrl(){
	var url = "/workflow/exceldesign/chooseTextField.jsp?formid=<%=formid %>&isbill=<%=isbill %>&selfieldid="+jQuery("input#relatefield").val();
	return url;
}

function doSave(){
	var codetype = jQuery("[name='codetype']:checked").val();
	var relatefield = jQuery("input#relatefield").val();
	if(relatefield == ""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage()) %>");
		return;
	}
	var retjson = {};
	retjson.codetype = codetype;
	retjson.relatefield = relatefield;
	if(codetype == "2")
		retjson.hidetext = jQuery("[name='hidetext']").attr("checked");
	dialog.close(retjson);
}

function doClose(){
	dialog.close();
}
</script>
</html>