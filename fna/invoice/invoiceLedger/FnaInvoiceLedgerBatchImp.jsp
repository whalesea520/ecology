<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//new LabelComInfo().removeLabelCache();
boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
String needfav = "1";
String needhelp = "";

%>
<html><head>
	<link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET" />
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" src="/fna/js/e8Common_wev8.js?r=7"></script>
	<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25649,user.getLanguage())+",javascript:doImp(),_TOP} ";//开始导入
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="weaver" name="frmmain" method="post" action="" enctype="multipart/form-data" target="ajaxUpload">
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(131529,user.getLanguage()) %>"/>
</jsp:include>

<iframe name="ajaxUpload" style="display:none"></iframe>
<input id="actionName" name="actionName" value="doImp" type="hidden" />
<input id="operation" name="operation" value="import" type="hidden" />
<input id="_guid1" name="_guid1" value="" type="hidden" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doImp();" 
    			value="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>"/><!-- 开始导入 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(131529, user.getLanguage())%>' ><!-- 发票导入 -->
		
		<wea:item><%=SystemEnv.getHtmlLabelName(131532, user.getLanguage())%></wea:item><!-- 导入方式 -->
		<wea:item>
            <select class="inputstyle" id="impType" name="impType" style="width: 80px;">
              <option value="1"><%=SystemEnv.getHtmlLabelName(131531,user.getLanguage())%></option><!-- 更新/追加 -->
              <option value="0"><%=SystemEnv.getHtmlLabelName(131530,user.getLanguage())%></option><!-- 追加 -->
            </select>
		</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelName(18577, user.getLanguage())%></wea:item><!-- Excel文件导入 -->
		<wea:item>
        	<input class="InputStyle" type="file" size="50" name="filename" id="filename" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19971, user.getLanguage())%></wea:item><!-- 模板文件 -->
		<wea:item>
			<span onclick="downExcel();" style="color: blue;cursor: pointer;"><%=SystemEnv.getHtmlLabelName(28576,user.getLanguage())%></span><!-- 下载模板 -->
			<%=SystemEnv.getHtmlLabelName(20211,user.getLanguage())%><!-- 请下载模板文件，填入数据后导入! -->
		</wea:item>
		<wea:item>
			<span style="display: block;margin-left: 12px;color: red;">
				<%=SystemEnv.getHtmlLabelName(128883,user.getLanguage())%>
				<!-- 
				//请按【下载模板】中的【导入说明】填入科目数据后进行批量导入
				 -->
			</span>
		</wea:item>
	</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 关闭 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</form>

<script language=javascript>
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

var _guid1 = $System.Math.IntUtil.genGUIDV4();
jQuery(document).ready(function(){
	jQuery("#_guid1").val(_guid1);
});

function getErrorInfoAjax(resultJson){
	_guid1 = $System.Math.IntUtil.genGUIDV4();
	if(resultJson.flag){
		alert("<%=SystemEnv.getHtmlLabelName(25750,user.getLanguage())%>");//导入成功
		try{
			parentWin._table.reLoad();
			doClose();
		}catch(ex1){}
	}else{
		alert(resultJson.msg._fnaReplaceAll("<br>","\r")._fnaReplaceAll("<br />","\r"));
	}
}

//读取数据更新进度标志符
var _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
//读取数据更新进度函数
function loadFnaBudgetEditSaveFnaLoadingAjax(_guid1){
	jQuery.ajax({
		url : "/fna/FnaLoadingAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "guid="+_guid1,
		dataType : "json",
		success: function do4Success(_jsonObj){
		    try{
	    		if(_jsonObj.flag){
			    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					getErrorInfoAjax(_jsonObj.resultJson);
	    		}else{
		    		if(top!=null&&top.document!=null&&top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv")!=null){
			    		top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv").innerHTML=null2String(_jsonObj.infoStr);
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
			    			setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
			    		}
		    		}else{
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
			    			setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
			    		}
		    		}
	    		}
		    }catch(e1){
		    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				alert(e1.message);
		    }
		}
	});	
}

function doImp(){
	var _filename = jQuery("#filename").val();
	if(_filename==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30213,user.getLanguage())%>");
		return;
	}
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>?",
		function(){
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);
			
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
				
			document.getElementById("weaver").action="/fna/invoice/invoiceLedger/FnaInvoiceLedgerAction.jsp?r="+GetRandomNum(8,100000000);
			document.getElementById("weaver").submit();
		},function(){}
	);
}

function downExcel(){
	var elemIF = document.createElement("iframe");
	elemIF.style.display = "none";
	var url = "/fna/invoice/invoiceLedger/FnaInvoiceLedgerBatchImp.xls";
	elemIF.src = url;
	document.body.appendChild(elemIF);
}



//关闭
function doClose(){
	parentWin.closeDialog();
}

function onBtnSearchClick(){}

</script>

</body>
</html>
