<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
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
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
boolean effect = HrmUserVarify.checkUserRight("BudgetDraftBatchEffect:effect", user);//预算草稿批量生效
boolean imp = HrmUserVarify.checkUserRight("BudgetDraftBatchImport:imp", user);//预算草稿批量导入
if(!effect && !imp){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean fnaBudgetOAOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetOAOrg());
boolean fnaBudgetCostCenter = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetCostCenter());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
String needfav = "1";
String needhelp = "";

String budgetperiods = Util.null2String(request.getParameter("budgetperiods")).trim();//期间年id
String budgetyears = "";//期间年
String sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
RecordSet.executeSql(sqlstr);
if (RecordSet.next()) {
    budgetyears = RecordSet.getString("fnayear");
}

String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
%>
<HTML><HEAD>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(28576,user.getLanguage())+",javascript:onDown(),_self}";
RCMenuHeight += RCMenuHeightStep ; 
RCMenu += "{"+SystemEnv.getHtmlLabelName(34241,user.getLanguage())+",javascript:onDownNull(),_self}";
RCMenuHeight += RCMenuHeightStep ; 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("28576",user.getLanguage()) %>'/>
</jsp:include>

<form id=weaver name=frmmain method=post action="">
<input type="hidden" name="operation" value="import">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(28576,user.getLanguage())%>" class="e8_btn_top" onclick="onDown();"/><!-- 下载模板 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(28576, user.getLanguage())%>' >
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15365, user.getLanguage())%></wea:item><!-- 预算年度 -->
		<wea:item>
			<%=budgetyears%>
        	<input type="hidden" id="budgetperiods" name="budgetperiods" value="<%=budgetperiods%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("17416,386,567", user.getLanguage())%></wea:item><!-- 导出预算版本 -->
		<wea:item>
			<select id="expType" name="expType" style="width: 110px;">
				<option value="1"><%=SystemEnv.getHtmlLabelNames("18496", user.getLanguage())%></option><!-- 生效版本 -->
				<option value="2"><%=SystemEnv.getHtmlLabelNames("32669", user.getLanguage())%></option><!-- 草稿版本 -->
			</select>
		</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelNames("83371,24638", user.getLanguage())%></wea:item><!-- 承担主体重复验证字段 -->
		<wea:item>
            <select class="inputstyle" id="keyWord" name="keyWord" style="width: 80px;">
              <option value="-1">ID</option>
              <option value="1"><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></option><!-- 编码 -->
            </select>
			<%=SystemEnv.getHtmlLabelName(24646,user.getLanguage())%><!-- 重复验证字段用于判断记录在excel和数据库中是唯一的 -->
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("585,24638", user.getLanguage())%></wea:item><!-- 科目重复验证字段 -->
		<wea:item>
            <select class="inputstyle" id="keyWord2" name="keyWord2" style="width: 80px;">
              <option value="-1">ID</option>
              <option value="1"><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></option><!-- 编码 -->
            </select>
			<%=SystemEnv.getHtmlLabelName(24646,user.getLanguage())%><!-- 重复验证字段用于判断记录在excel和数据库中是唯一的 -->
		</wea:item>
		
	<%if(fnaBudgetOAOrg){ %>
    	<wea:item><%=SystemEnv.getHtmlLabelNames("140",user.getLanguage())%></wea:item><!-- 总部预算 -->
	    <wea:item>
	    	<input type="checkbox" id="zb" name="zb" class=Inputstyle value='1' />
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelNames("141",user.getLanguage())%></wea:item><!-- 分部预算 -->
	    <wea:item>
	        <brow:browser viewType="0" name="fb" browserValue="" 
	                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
	                browserSpanValue="" width="80%" >
	        </brow:browser>
	    </wea:item>
    	
    	<wea:item><%=SystemEnv.getHtmlLabelNames("124",user.getLanguage())%></wea:item><!-- 部门预算 -->
	    <wea:item>
	        <brow:browser viewType="0" name="bm" browserValue="" 
	                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
	                browserSpanValue="" width="80%" >
	        </brow:browser>
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelNames("1867",user.getLanguage())%></wea:item><!-- 人员预算 -->
	    <wea:item>
	        <brow:browser viewType="0" name="ry" browserValue="" 
	                browserUrl='<%=new BrowserComInfo().getBrowserurl("17")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(179,user.getLanguage())%>'
	                browserSpanValue="" width="80%" 
	                >
	        </brow:browser>
	    </wea:item>
	<%} %>
	<%if(fnaBudgetCostCenter){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></wea:item><!-- 成本中心 -->
		<wea:item>
	        <brow:browser viewType="0" name="fccIds" browserValue="" 
	                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp%3Fselectids=#id#"
	                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
	                completeUrl="/data.jsp?type=FnaCostCenter"  temptitle='<%= SystemEnv.getHtmlLabelName(515,user.getLanguage())%>'
	                browserSpanValue="" width="80%" >
	        </brow:browser>
		</wea:item>
	<%} %>
	    
		<wea:item><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %></wea:item><!-- 预算科目 -->
		<wea:item>
	        <brow:browser viewType="0" name="subjectId" browserValue="" 
	                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/FnaBudgetfeeTypeBrowserMulti.jsp%3Fselectids=#id#"
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=FnaBudgetfeeTypeMulti" 
	                temptitle='<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %>'
	                browserSpanValue="" width="80%" 
	                >
	        </brow:browser>
		</wea:item>
		
		<wea:item></wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20211,user.getLanguage())%><!-- 请下载模板文件，填入数据后导入! -->
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
<iframe id="dwnfrm" name="dwnfrm" src="" style="display:none"></iframe>

<script language=javascript>
var _guid1 = "<%=_guid1 %>";

function getErrorInfoAjax(resultJson){
	var _guid1_old = _guid1;
	_guid1 = $System.Math.IntUtil.genGUIDV4();
	if(resultJson.flag){
		document.getElementById("dwnfrm").src = "/fna/batch/ExpFnaBatchExcelExp.jsp?_guid1="+_guid1_old+"&gotoDl=1&r="+GetRandomNum(8,100000000);
	}else{
		alert(resultJson.msg);
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

function onDown(){
	_onDown(1);
}

function onDownNull(){
	_onDown(2);
}

function _onDown(dlType){
	var zb = jQuery("#zb").attr("checked")?"1":"";
	var fb = jQuery("#fb").val();
	var bm = jQuery("#bm").val();
	var ry = jQuery("#ry").val();
	var fccIds = jQuery("#fccIds").val();
	var subjectId = jQuery("#subjectId").val();
	
	if(zb==null){
		zb = "";
	}
	if(fb==null){
		fb = "";
	}
	if(bm==null){
		bm = "";
	}
	if(ry==null){
		ry = "";
	}
	if(fccIds==null){
		fccIds = "";
	}
	if(subjectId==null){
		subjectId = "";
	}
	
<%if(fnaBudgetOAOrg){ %>
	if(zb=="" && fb=="" && bm=="" && ry=="" && fccIds==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34217,user.getLanguage())%>");
		return;
	}
<%}else if(fnaBudgetOAOrg){ %>
	if(zb=="" && fb=="" && bm=="" && ry==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34217,user.getLanguage())%>");
		return;
	}
<%}else if(fnaBudgetCostCenter){ %>
	if(fccIds==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34217,user.getLanguage())%>");
		return;
	}
<%} %>
	var keyWord = jQuery("#keyWord").val();
	var keyWord2 = jQuery("#keyWord2").val();
	
	var _data = "_guid1="+_guid1+"&zb="+zb+"&fb="+fb+"&bm="+bm+"&ry="+ry+"&fccIds="+fccIds+"&subjectId="+subjectId+
		"&keyWord="+keyWord+"&keyWord2="+keyWord2+
		"&r="+$System.Math.IntUtil.genGUIDV4();
	jQuery.ajax({
		url : "/fna/batch/ExpFnaBatchExcel1.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "html",
		success: function do4Success(_html){
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
			
			var budgetperiods = jQuery("#budgetperiods").val();
			var expType = jQuery("#expType").val();
			document.getElementById("dwnfrm").src = "/fna/batch/ExpFnaBatchExcelExp.jsp?_guid1="+_guid1+"&budgetperiods="+budgetperiods+"&expType="+expType+"&dlType="+dlType+
					"&r="+GetRandomNum(8,100000000);
		}
	});	
}



//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

function onBtnSearchClick(){}

</script>

</BODY>
</HTML>
