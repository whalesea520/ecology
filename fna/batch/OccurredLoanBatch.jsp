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
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//new LabelComInfo().removeLabelCache();
boolean canEdit = HrmUserVarify.checkUserRight("BorroweImport:add",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
String needfav = "1";
String needhelp = "";

%>

<%@page import="weaver.filter.XssUtil"%><HTML><HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script language="javascript" src="/fna/js/e8Common_wev8.js?r=7"></script>
	<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25649,user.getLanguage())+",javascript:doImp(),_TOP} ";//开始导入
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String navName_labelName = SystemEnv.getHtmlLabelNames("128759",user.getLanguage());
%>
<iframe name="ajaxUpload" style="display:none"></iframe>
<form id=weaver name=frmmain method=post action="" enctype="multipart/form-data" target="ajaxUpload">
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=navName_labelName %>"/>
</jsp:include>

<input type="hidden" name="operation" value="import">
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
	<wea:group context='<%=SystemEnv.getHtmlLabelName(128759, user.getLanguage())%>' ><!-- 已发生借款导入 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(128761, user.getLanguage())%></wea:item><!-- 借款人重复验证字段 -->
		<wea:item>
            <select class="inputstyle" id="keyWord" name="keyWord" style="width: 80px;">
              <option value="0"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></option><!-- 名称 -->
              <option value="1"><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></option><!-- 编码 -->
            </select>
			<%=SystemEnv.getHtmlLabelName(24646,user.getLanguage())%><!-- 重复验证字段用于判断记录在excel和数据库中是唯一的 -->
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(128762, user.getLanguage())%></wea:item><!-- 生成借款对应流程 -->
		<wea:item>
		<%
		String _browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp%3Fsqlwhere="+
				new XssUtil().put("where exists (select 1 from fnaFeeWfInfo ffwi where workflow_base.id = ffwi.workflowid and ffwi.fnaWfType = 'borrow')");
		%>
	        <brow:browser viewType="0" name="workflowid" browserValue='<%="" %>' 
	                browserUrl="<%=_browserUrl %>"
	                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
	                completeUrl="/data.jsp?type=workflowBrowser" temptitle='<%= SystemEnv.getHtmlLabelName(23753,user.getLanguage())%>'
	                browserSpanValue='<%="" %>' width="40%">
	        </brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18577, user.getLanguage())%></wea:item><!-- Excel文件导入 -->
		<wea:item>
			<input id="showSrcFilename" type="text" readonly="readonly" _noMultiLang="true" /><input type="button" value="<%=SystemEnv.getHtmlLabelName(125333, user.getLanguage())%>" onclick="jQuery('#filename').click();"/><!-- 选择文件 -->
        	<input class="InputStyle" type="file" size="50" name="filename" id="filename" style="display: none;" onchange="jQuery('#showSrcFilename').val(this.value);"/>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19971, user.getLanguage())%></wea:item><!-- 模板文件 -->
		<wea:item>
			<a href="/fna/batch/OccurredLoanBatchImp.xls"><font color="blue"><%=SystemEnv.getHtmlLabelName(28576,user.getLanguage())%></font></a><!-- 下载模板 -->
			<%=SystemEnv.getHtmlLabelName(20211,user.getLanguage())%><!-- 请下载模板文件，填入数据后导入! -->
		</wea:item>
	</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
</form>

<script language=javascript>
var _parent = null;
var _guid1 = $System.Math.IntUtil.genGUIDV4();
jQuery(document).ready(function(){
	jQuery("#_guid1").val(_guid1);
	_parent = parent.getParentWindow(window).parent.parent;
});

function getErrorInfoAjax(resultJson){
	_guid1 = $System.Math.IntUtil.genGUIDV4();
	if(resultJson.flag){
		alert("<%=SystemEnv.getHtmlLabelName(25750,user.getLanguage())%>");
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
	var _workflowid = jQuery("#workflowid").val();
	if(_workflowid==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("128762,18019",user.getLanguage())%>");
		return;
	}
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>?",
		function(){
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);
			
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
			document.getElementById("weaver").action="/fna/batch/OccurredLoanBatchOp.jsp?r="+GetRandomNum(8,100000000);
			document.getElementById("weaver").submit();
		},function(){}
	);
}



function onBtnSearchClick(){}

</script>

</BODY>
</HTML>
