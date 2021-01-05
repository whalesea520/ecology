<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />	
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>

<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HEAD>

<%
if(!HrmUserVarify.checkUserRight("CoreMail:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return;
}

String titlename = SystemEnv.getHtmlLabelName(125928,user.getLanguage());
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

String datatype = Util.null2String(request.getParameter("datatype"));
String operatedata = Util.null2String(request.getParameter("operatedata"));
String operatetype = Util.null2String(request.getParameter("operatetype"));
String operateresult = Util.null2String(request.getParameter("operateresult"));

String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String dateselect = Util.fromScreen(request.getParameter("dateselect"),user.getLanguage());
if(!dateselect.equals("") && !dateselect.equals("0") && !dateselect.equals("6")) {
	fromdate = TimeUtil.getDateByOption(dateselect,"0");
	todate = TimeUtil.getDateByOption(dateselect,"1");
}
if(dateselect.equals("") || dateselect.equals("0")) {
	fromdate = "";
	todate = "";
}

String PageConstId = "CoreMailSynLog_PageSize";
String backfields = " * ";
String fromSql  = " from coremaillog ";
String sqlWhere = " where 1=1 ";

if(StringUtils.isNotBlank(datatype)) {
	sqlWhere += " and datatype = '" + datatype + "' ";
}
if(StringUtils.isNotBlank(operatedata)) {
	sqlWhere += " and operatedata like '%" + operatedata + "%' ";
}
if(StringUtils.isNotBlank(operatetype)) {
	sqlWhere += " and operatetype = '" + operatetype + "' ";
}
if(StringUtils.isNotBlank(operateresult)) {
	sqlWhere += " and operateresult = '" + operateresult + "' ";
}
if(!fromdate.equals("") && fromdate != null) {
	sqlWhere += " and logdate >= '" + fromdate + "' ";
}
if(!todate.equals("") && todate != null) {
	sqlWhere += " and logdate <= '" + todate + "' ";
}

String tableString = "<table instanceid=\"CoreMailLogTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
				"       <head>"+
				"           <col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(125929,user.getLanguage())+"\" column=\"datatype\" otherpara=\""+user.getLanguage()+"\" orderkey=\"datatype\" transmethod=\"weaver.interfaces.email.CoreMailUtil.getDataTypeName\" />"+
				"           <col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(125930,user.getLanguage())+"\" column=\"operatedata\" orderkey=\"operatedata\" />"+
				"           <col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"\" column=\"operatetype\" otherpara=\""+user.getLanguage()+"\" orderkey=\"operatetype\"  transmethod=\"weaver.interfaces.email.CoreMailUtil.getOperateTypeName\" />"+
				"           <col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(81420,user.getLanguage())+"\" column=\"operateresult\" otherpara=\""+user.getLanguage()+"\" orderkey=\"operateresult\" transmethod=\"weaver.interfaces.email.CoreMailUtil.getOperateResultName\" />"+
				"           <col width=\"33%\" text=\""+SystemEnv.getHtmlLabelName(27041,user.getLanguage())+"\" column=\"operateremark\" orderkey=\"operateremark\" />"+
				"           <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelNames("83,277",user.getLanguage())+"\" column=\"logdate\" otherpara=\"column:logtime\" orderkey=\"logdate, logtime \" transmethod=\"weaver.splitepage.transform.SptmForCrm.getTime\" />"+
				"       </head>";
tableString += "</table>";

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="/integration/coremail/coremailSynLog.jsp" id="CoreMailLogForm" name="CoreMailLogForm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" name="operatedata" value="<%=operatedata%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><<%=titlename %></span>
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%= SystemEnv.getHtmlLabelName(125929,user.getLanguage())%></wea:item>
			<wea:item>
			<select style='width:120px!important;' id="datatype" name="datatype">
				<option value="" <%=datatype.equals("")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></option>
				<option value="1" <%=datatype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %></option>
				<option value="2" <%=datatype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %></option>
				<option value="3" <%=datatype.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage()) %></option>
			</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></wea:item>
			<wea:item>
			<select style='width:120px!important;' id="operatetype" name="operatetype">
				<option value="" <%=operatetype.equals("")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></option>
				<option value="1" <%=operatetype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1421,user.getLanguage()) %></option>
				<option value="2" <%=operatetype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(103,user.getLanguage()) %></option>
				<option value="3" <%=operatetype.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %></option>
				<option value="4" <%=operatetype.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(20873,user.getLanguage()) %></option>
			</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(81420,user.getLanguage())%></wea:item>
			<wea:item>
			<select style='width:120px!important;' id="operateresult" name="operateresult">
				<option value="" <%=operateresult.equals("")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></option>
				<option value="1" <%=operateresult.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage()) %></option>
				<option value="2" <%=operateresult.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(498,user.getLanguage()) %></option>
			</select>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelNames("83,277",user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					<select id="dateselect" name="dateselect" onchange="changeDate(this,'spanfromdate');">
						<option value="0" <%=dateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<option value="1" <%=dateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
						<option value="2" <%=dateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
						<option value="3" <%=dateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
						<option value="7" <%=dateselect.equals("7")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(27347,user.getLanguage())%></option>
						<option value="4" <%=dateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
						<option value="5" <%=dateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
						<option value="8" <%=dateselect.equals("8")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(81716,user.getLanguage())%></option>
						<option value="6" <%=dateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
					</select>
				</span>
				<span id="spanfromdate" style="<%=dateselect.equals("6") ? "" : "display:none;" %>">
					<button class="Calendar" type="button" id="selectfromdate" onclick="getDate('fromdatespan','fromdate');"></button>
					<span id="fromdatespan"><%=fromdate %></span>－
					<button class="Calendar" type="button" id="selecttodate" onclick="getDate('todatespan','todate');"></button>
					<span id="todatespan"><%=todate %></span>
				</span>
				<input type="hidden" id="fromdate" name="fromdate" value="<%=fromdate %>">
				<input type="hidden" id="todate" name="todate" value="<%=todate %>">
			</wea:item>
		</wea:group>
		
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="zd_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	

<TABLE width="100%" id="datatable">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</form>
</BODY>
</HTML>

<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script>
jQuery(document).ready(function() {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function() {
		$(".searchInput").val('');
	});
});

function resetCondtion() {
	$("#CoreMailLogForm input[type=text]").val('');
	//解绑，绑定
	CoreMailLogForm.datatype.value = "";
	jQuery(CoreMailLogForm.datatype).selectbox("detach");
	jQuery(CoreMailLogForm.datatype).selectbox();
	
	CoreMailLogForm.operatetype.value = "";
	jQuery(CoreMailLogForm.operatetype).selectbox("detach");
	jQuery(CoreMailLogForm.operatetype).selectbox();
	
	CoreMailLogForm.operateresult.value = "";
	jQuery(CoreMailLogForm.operateresult).selectbox("detach");
	jQuery(CoreMailLogForm.operateresult).selectbox();
	
	$("#dateselect").val('0');
	$("#dateselect").selectbox("detach");
	__jNiceNamespace__.beautySelect("#dateselect");
	
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery("#fromdate").val("");
	jQuery("#todate").val("");
	jQuery("#fromdatespan").html("");
	jQuery("#todatespan").html("");
	jQuery("#spanfromdate").css("display","none");
}

function doRefresh() {
	$("#CoreMailLogForm").submit();
}

function changeDate(obj,formatedate) {
	var dateval = jQuery(obj).val();
	if(dateval == "6") {
		jQuery("#fromdate").val("");
		jQuery("#todate").val("");
		jQuery("#fromdatespan").html("");
		jQuery("#todatespan").html("");
		jQuery("#spanfromdate").css("display","");
	} else {
		jQuery("#spanfromdate").css("display","none");
	}
}
</script>
