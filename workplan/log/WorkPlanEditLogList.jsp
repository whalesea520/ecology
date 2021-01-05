
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="logMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="workPlanHandler" class="weaver.WorkPlan.WorkPlanHandler" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</HEAD>

<%
String workPlanId = Util.null2String(request.getParameter("workid"));
String trmOperatorId = Util.null2String(request.getParameter("trmoperatorid"));			//操作人
String trmStartDate = Util.null2String(request.getParameter("trmstartdate"));			//开始日期
String trmEndDate = Util.null2String(request.getParameter("trmenddate"));				//结束日期

String term = "";
boolean isHead = true;

int tmpworkPlanId = Util.getIntValue(workPlanId, -1);
if (tmpworkPlanId != -1)
{
    if (isHead)
    {
        isHead = false;
        term += " WHERE workPlanId = " + workPlanId;
    }
    else
    {
        term += " AND workPlanId = " + workPlanId;
    }
}

int operatorId = Util.getIntValue(trmOperatorId, -1);
if (operatorId != -1)
{
    if (isHead)
    {
        isHead = false;
        term += " WHERE userId = " + trmOperatorId;
    }
    else
    {
        term += " AND userId = " + trmOperatorId;
    }
}

if (!trmStartDate.equals(""))
{
    if (isHead)
    {
        isHead = false;
        term += " WHERE logDate >= '" + trmStartDate + "'";
    }
    else
    {
        term += " AND logDate >= '" + trmStartDate + "'";
    }
}

if (!trmEndDate.equals(""))
{
    if (isHead)
    {
        isHead = false;
        term += " WHERE logDate <= '" + trmEndDate + "'";
    }
    else
    {
        term += " AND logDate <= '" + trmEndDate + "'";
    }
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17481,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:doRefresh(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="goBack(this)">
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
		<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(17481,user.getLanguage())%></span>
			
	 </span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanEditLogList.jsp">
		<INPUT type="hidden" name="workid" value="<%=workPlanId%>">
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="trmoperatorid" browserValue='<%=trmOperatorId%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%=Util.toScreen(resourceComInfo.getResourcename(trmOperatorId), user.getLanguage())%>'></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></wea:item>
			<wea:item>
				<button type="button" class="Calendar" id="SelectStartDate" onclick="getDate(trmstartdatespan,trmstartdate)"></BUTTON>
				<SPAN id="trmstartdatespan"><%=trmStartDate%></SPAN>
				<INPUT type="hidden" name="trmstartdate" value="<%=trmStartDate%>">&nbsp;-&nbsp;&nbsp;
				<button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(trmenddatespan,trmenddate)"></BUTTON>
				<SPAN id="trmenddatespan"><%=trmEndDate%></SPAN>
				<INPUT type="hidden" name="trmenddate" value="<%=trmEndDate%>">
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" onclick="doSearch();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</FORM>
</div>
<div class="zDialog_div_content">

	<%
		
		String sqlForm = "WorkPlanEditLog";
		String orderby = "logDate DESC, logTime DESC";
		
		String tableString=""+
			"<table pagesize=\"10\"  tabletype=\"none\"  >"+
		    "<sql backfields=\"*\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"id\" sqlorderby=\"" + orderby + "\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(term)+"\"/>"+
		    "<head>"+
		    "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(16652,user.getLanguage())+"\" column=\"workPlanId\" orderkey=\"workPlanId\"  transmethod=\"weaver.WorkPlan.WorkPlanHandler.getWorkPlanName\"/>"+
		    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage()) + "\" column=\"fieldName\" orderkey=\"fieldName\" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17485,user.getLanguage()) + "\" column=\"oldValue\" orderkey=\"oldValue\" otherpara=\"column:fieldName+"+user.getLanguage()+"\" transmethod=\"weaver.WorkPlan.WorkPlanLogMan.getWorkPlanFieldValue\" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17486,user.getLanguage()) + "\" column=\"newValue\" orderkey=\"newValue\" otherpara=\"column:fieldName+"+user.getLanguage()+"\" transmethod=\"weaver.WorkPlan.WorkPlanLogMan.getWorkPlanFieldValue\" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage()) + "\" column=\"userId\" orderkey=\"userId\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getResourceName\" />"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17484,user.getLanguage()) + "\" column=\"ipAddress\" orderkey=\"ipAddress\" />"+
			"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(2061,user.getLanguage()) + "\" column=\"logDate\" orderkey=\"logDate\" otherpara=\"column:logTime\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getShowDataTime\" />"+
		    "</head>"+
		"</table>";
	%>
	
	<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 


</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY>

<SCRIPT language="javascript">
function btn_cancle(){
	parent.btn_cancle();
}
jQuery(document).ready(function(){
	resizeDialog(document);
});


function goBack() {
	parent.goBack();
}

function doRefresh() {
	document.frmmain.submit();
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='planname']").val(name);
	doSearch();
}

function doSearch() {
	document.frmmain.submit();
}

/**
*清空搜索条件
*/
function resetCondtionAVS(){
	//清空文本框
	jQuery("#advancedSearchDiv").find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery("#advancedSearchDiv").find(".Browser").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery("#advancedSearchDiv").find("select").val("");
	jQuery("#advancedSearchDiv").find("select").trigger("change");
	//清空日期
	jQuery("#advancedSearchDiv").find(".Calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Calendar").siblings("input[type='hidden']").val("");
}


</SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
