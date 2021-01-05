<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	int formid = Util.getIntValue(request.getParameter("formid"));
	int isbill = Util.getIntValue(request.getParameter("isbill"));
	String selfieldid = Util.null2String(request.getParameter("selfieldid"));
	String search_fieldname = Util.null2String(request.getParameter("search_fieldname"));
%>
<HTML>
<HEAD>
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel="stylesheet" />
	<link type="text/css" href="/css/Weaver_wev8.css" rel="stylesheet" />
	<style type="text/css">
		.e8_box_middle{height: 370px !important;}
		.e8_box_slice{height: 370px !important;}
		.contentTitle{color:#aeaeae !important;}
		.fieldname{color:#242424 !important;}
	</style>
</HEAD>
<BODY style="overflow:hidden">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doConfirm(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:doClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(82104, user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" id="btnsearch" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" />
	      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form method="post" name="SearchForm" id="SearchForm" style="margin-bottom:0" action="" onsubmit="return false;">
<input type="hidden" name="formid" value="<%=formid %>" />
<input type="hidden" name="isbill" value="<%=isbill %>" />
<input type="hidden" name="selfieldid" value="<%=selfieldid %>" />
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></wea:item>
		<wea:item>
			<input class="InputStyle" name="search_fieldname" value="<%=search_fieldname %>" onkeypress="if(event.keyCode==13){doSearch();}"/>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="dialog">
	<div id='colShow'></div>
</div>
</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="button" class="zd_btn_submit" id="btnok" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" />
			<input type="button" class="zd_btn_submit" id="btnclear" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" />
	        <input type="button" class="zd_btn_cancle" id="btncancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" />
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
</div>
<script type="text/javascript">
var dialog = null;	
jQuery(document).ready(function(){
	try{
		dialog = window.top.getDialog(window);
	}catch(e){}
	showMultiMouldDialog("<%=selfieldid %>");
});

function showMultiMouldDialog(selectids){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["字段名称"];
    config.container =jQuery("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    //config.saveurl= "/formmode/exceldesign/chooseTextFieldAjax.jsp?src=save";
    config.srcurl = "/formmode/exceldesign/chooseTextFieldAjax.jsp?src=src";
    config.desturl = "/formmode/exceldesign/chooseTextFieldAjax.jsp?src=dest";
    //config.delteurl="/formmode/exceldesign/chooseTextFieldAjax.jsp?src=save";
    config.pagesize = 10;
    config.formId = "SearchForm";
    config.selectids = selectids;
	try{
		config.dialog = dialog;
	}catch(e){}
   	jQuery("#colShow").html("");
   	
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
    	rightsplugingForBrowser.system_btnok_onclick(config);
    });
    jQuery("#btnclear").bind("click",function(){
    	rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel").bind("click",function(){
    	rightsplugingForBrowser.system_btncancel_onclick(config);
    });
    jQuery("#btnsearch").bind("click",function(){
    	rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}

function doSearch(){
	jQuery("#btnsearch").trigger("click");
}
function doReset(){
	SearchForm.reset();
}
function doConfirm(){
	jQuery("#btnok").trigger("click");
}
function doClear(){
	jQuery("#btnclear").trigger("click");
}
function doClose(){
	jQuery("#btncancel").trigger("click");
}
</script>
</BODY>
</HTML>
