<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.file.ExcelRow"%>
<%@page import="weaver.file.ExcelStyle"%>
<%@page import="weaver.file.ExcelSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ page import="weaver.file.AESCoder"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="BudgetApproveWFHandler" class="weaver.fna.budget.BudgetApproveWFHandler" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
//new LabelComInfo().removeLabelCache();
boolean imp = HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user);
if(!imp){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

boolean iframe = "true".equals(Util.null2String(request.getParameter("iframe")));
%>
<HTML><HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" src="/fna/js/e8Common_wev8.js?r=7"></script>
	<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(128489,user.getLanguage())+",javascript:doExp(),_TOP} ";//打包导出配置
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(128490,user.getLanguage())+",javascript:doImp(),_TOP} ";//打包导入配置
	RCMenuHeight += RCMenuHeightStep ;
	if(false){
		RCMenu += "{initExp,javascript:doInitExp(),_TOP} ";
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{initImp,javascript:doInitImp(),_TOP} ";
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(!iframe){
%>
<div class="zDialog_div_content" style="">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelName(128491,user.getLanguage()) %>'/>
</jsp:include>
<%
}
%>

<form id=weaver name=frmmain method=post action="" enctype="multipart/form-data" target="ajaxUpload">
<iframe name="ajaxUpload" style="display:none"></iframe>
<input type="hidden" id="operation" name="operation" value="">
<input id="_guid1" name="_guid1" value="" type="hidden" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input class="e8_btn_top" type="button" id="btnDoExp" onclick="doExp();" 
    			value="<%=SystemEnv.getHtmlLabelName(128489,user.getLanguage()) %>"/><!-- 打包导出配置 -->
    		<input class="e8_btn_top" type="button" id="btnDoImp" onclick="doImp();" 
    			value="<%=SystemEnv.getHtmlLabelName(128490,user.getLanguage()) %>"/><!-- 打包导入配置 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>


<%
String innerSql = "select a.id workflowid, a.workflowname, a.workflowdesc, b.typename, b.dsporder bDsporder, a.id wfTypeId, a.dsporder aDsporder, "+
	" case when (a.version is null) then 1 else a.version end versionName "+
	" from workflow_base a \n" +
	" join workflow_type b on a.workflowtype = b.id "+
	" where EXISTS (select 1 from fnaFeeWfInfo fna where fna.workflowid = a.id) "+
	" and a.isvalid = 1 ";

String backFields = "*";
String fromSql = " ("+innerSql+") t1 ";
String sqlWhere = "";
String orderBy = "t1.bDsporder, t1.typename, t1.aDsporder, t1.workflowname";
String sqlprimarykey = "workflowid";
	
String tableString=""+
   "<table instanceid=\"FNA_BUDGET_FEETYPE_GRIDVIEW_INNER_LIST\" pageId=\""+PageIdConst.FNA_BUDGET_FEETYPE_GRIDVIEW_INNER_LIST+"\" "+
		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_BUDGET_FEETYPE_GRIDVIEW_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\" >"+
   "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
   " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" />"+
   "<head>"+
		"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(81651,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" />"+//路径名称
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"\" column=\"versionName\" />"+//版本
		"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(33806,user.getLanguage())+"\" column=\"typename\" orderkey=\"typename\" />"+//路径类型
		"<col width=\"45%\"  text=\""+SystemEnv.getHtmlLabelNames("18499,433",user.getLanguage())+"\" column=\"workflowdesc\" />"+//路径描述
   "</head>"+
   "</table>";
%>
<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(128490, user.getLanguage()) %>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(128497,user.getLanguage())%></wea:item><!-- 选择导入文件 -->
	    <wea:item>
			<input id="showSrcFilename" type="text" readonly="readonly" _noMultiLang="true" /><input type="button" value="<%=SystemEnv.getHtmlLabelName(125333, user.getLanguage())%>" onclick="jQuery('#filename').click();"/><!-- 选择文件 -->
        	<input class="InputStyle" type="file" size="50" name="filename" id="filename" style="display: none;" onchange="jQuery('#showSrcFilename').val(this.value);"/>
	    </wea:item>
    </wea:group>
    <wea:group context='<%=SystemEnv.getHtmlLabelName(128489, user.getLanguage()) %>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(128495,user.getLanguage())%></wea:item><!-- 导出科目 -->
	    <wea:item>
    		<input id="expSubject" name="expSubject" value="1" type="checkbox" tzCheckbox="true" checked />
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(128496,user.getLanguage())%></wea:item><!-- 导出成本中心 -->
	    <wea:item>
    		<input id="expFcc" name="expFcc" value="1" type="checkbox" tzCheckbox="true" checked />
	    </wea:item>
    </wea:group>
</wea:layout>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_BUDGET_FEETYPE_GRIDVIEW_INNER_LIST %>" />
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
<%
if(!iframe){
%>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</form>
<iframe id="ajaxExp" style="display:none"></iframe>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
</wea:layout>
</div>
<%
}
%>
<script language=javascript>
var _guid1 = $System.Math.IntUtil.genGUIDV4();
jQuery(document).ready(function(){
<%
if(!iframe){
%>
	resizeDialog(document);
<%
}
%>
	jQuery("#_guid1").val(_guid1);
});

var _getErrorInfoAjax = false;
function getErrorInfoAjax(_guid1){
	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
	if(_getErrorInfoAjax){
		_getErrorInfoAjax = false;
		jQuery.ajax({
			url : "/fna/GetErrorInfoAjax.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : "_guid1="+_guid1,
			dataType : "html",
			success: function do4Success(_html){
				document.getElementById("weaver").action="";
	    		if(_html!=""){
	    			alert(_html);
	    		}else{
	    			//成功
	    			//document.getElementById("ajaxExp").src = "/fna/FnaGlobalExpImp/fnaExp_<%=user.getUID() %>.zip?_guid1="+_guid1+"&r="+GetRandomNum(8,100000000);
	    		}
			}
		});	
	}
}

//读取数据更新进度标志符
var _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
//读取数据更新进度函数
function loadFnaBudgetEditSaveFnaLoadingAjax(_guid1){
	jQuery.ajax({
		url : "/fna/GetBudgetLoadingAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "_guid1="+_guid1,
		dataType : "html",
		success: function do4Success(_html){
		    try{
	    		if(top!=null&&top.document!=null&&top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv")!=null){
		    		top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv").innerHTML=_html;
		    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
			    		setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
		    		}
	    		}else{
		    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
			    		setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
		    		}
	    		}
	    		if(_html=="isDone"){
			    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					getErrorInfoAjax(_guid1);
	    		}
		    }catch(e1){
		    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
		    }
		}
	});	
}

function doExp(){
	//您确定要开始导出么
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128479,user.getLanguage())%>?",
		function(){
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);

			var expSubject = jQuery("#expSubject").attr("checked")?"1":"";
			var expFcc = jQuery("#expFcc").attr("checked")?"1":"";
			var wfIds = _xtable_CheckedCheckboxId();
			
			_getErrorInfoAjax = true;
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
			
			document.getElementById("ajaxExp").src="/fna/batch/FnaGlobalExpOp.jsp?operation=export&_guid1="+_guid1+
				"&expSubject="+expSubject+"&expFcc="+expFcc+"&wfIds="+wfIds+
				"&r="+GetRandomNum(8,100000000);
		},function(){}
	);
}

function doImp(){
	var _filename = jQuery("#filename").val();
	if(_filename==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30213,user.getLanguage())%>");
		return;
	}
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>?",
		function(){
			jQuery("#operation").val("import");
			
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);
			
			_getErrorInfoAjax = true;
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
				
			document.getElementById("weaver").action="/fna/batch/FnaGlobalImpOp.jsp?r="+GetRandomNum(8,100000000);
			document.getElementById("weaver").submit();
		},function(){}
	);
}

<%if(false){%>
function doInitExp(){
	//您确定要开始导出么
	top.Dialog.confirm("R U sure doInitExp?",
		function(){
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);
			
			_getErrorInfoAjax = true;
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
			
			document.getElementById("ajaxExp").src="/fna/batch/FnaGlobalExpOp.jsp?operation=doInitExp&_guid1="+_guid1+"&r="+GetRandomNum(8,100000000);
		},function(){}
	);
}

function doInitImp(){
	var _filename = jQuery("#filename").val();
	if(_filename==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30213,user.getLanguage())%>");
		return;
	}
	
	top.Dialog.confirm("R U sure doInitImp?",
		function(){
			jQuery("#operation").val("doInitImp");
			
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);
			
			_getErrorInfoAjax = true;
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
				
			document.getElementById("weaver").action="/fna/batch/FnaGlobalImpOp.jsp?r="+GetRandomNum(8,100000000);
			document.getElementById("weaver").submit();
		},function(){}
	);
}
<%}%>


//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

function onBtnSearchClick(){}

</script>

</BODY>
</HTML>
