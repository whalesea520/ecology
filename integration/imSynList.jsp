<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
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

</head>
<BODY>
<% 

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(125928,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean isoracle = (rs.getDBType()).equals("oracle") ;
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:rtxsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}else{
	//qc281256[80][90]数据展现集成-外部数据元素-解决流程中心元素设置不关闭,再打开外部数据元素报404错误的问题
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
}
String syndata = Util.null2String(request.getParameter("syndata"));
String syntype = Util.null2String(request.getParameter("syntype"));
String opertype = Util.null2String(request.getParameter("opertype"));
String operresult = Util.null2String(request.getParameter("operresult"));

String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String dateselect =Util.fromScreen(request.getParameter("dateselect"),user.getLanguage());
if(!dateselect.equals("") && !dateselect.equals("0")&& !dateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(dateselect,"0");
	todate = TimeUtil.getDateByOption(dateselect,"1");
}
if(dateselect.equals("") || dateselect.equals("0")) {
	fromdate = "";
	todate = "";
}

int perpage=Util.getIntValue(request.getParameter("perpage"),0);
String PageConstId = "imsyn";
if(perpage<=1 )	perpage=10;

String sqlWhere = " where  1=1 ";
String backfields = " * ";
String fromSql  = " from imsynlog  ";
if(StringUtils.isNotBlank(syndata)){
	sqlWhere += "  and syndata like '%"+syndata+"%' ";
}
if(StringUtils.isNotBlank(syntype)){
	sqlWhere += "  and syntype = '"+syntype+"' ";
}
if(StringUtils.isNotBlank(opertype)){
	sqlWhere += "  and opertype = '"+opertype+"' ";
}
if(StringUtils.isNotBlank(operresult)){
	sqlWhere += "  and operresult = '"+operresult+"' ";
}

if(!fromdate.equals("")&&fromdate!=null){
	sqlWhere += " AND operdate >= '" + fromdate + "' ";
}
if(!todate.equals("")&&todate!=null){
	sqlWhere += " AND operdate <= '" + todate + "' ";
}
String tableString = "<table instanceid=\"archivingLogTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
					"       <head>"+
					"           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(125929,user.getLanguage())+"\" column=\"syntype\" orderkey=\"syntype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.rtx.RTXSynLog.getSyntypeName\"/>"+
					"           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(125930,user.getLanguage())+"\" column=\"syndata\" orderkey=\"syndata\" />"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"\"  column=\"opertype\" orderkey=\"opertype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.rtx.RTXSynLog.getOpertypeName\"/>"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(81420,user.getLanguage())+"\"  column=\"operresult\" orderkey=\"operresult\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.rtx.RTXSynLog.getOperresultName\"/>"+
					"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(27041,user.getLanguage())+"\"  column=\"reason\" orderkey=\"reason\" />"+
					"           <col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+SystemEnv.getHtmlLabelName(277,user.getLanguage())+"\"  column=\"operdate\"  otherpara=\"column:opertime\" orderkey=\"operdate, opertime \"  transmethod=\"weaver.splitepage.transform.SptmForCrm.getTime\"/>"+ 
					"       </head>";
tableString +="</table>";

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="imSynList.jsp" name="archivingLogForm" id="archivingLogForm">
<input class=inputstyle type=hidden name=operation id=operation>
<input class=inputstyle type=hidden name=ids id=ids>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" name="syndata" value="<%=syndata%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(33267 ,user.getLanguage()) %></span>
</div>
	
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="fourCol">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%= SystemEnv.getHtmlLabelName(125929,user.getLanguage())%></wea:item>
			<wea:item>
			<select style='width:120px!important;' id="syntype" name="syntype">
				<option value="" <%if(syntype.equals("")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage()) %></option>
				<option value="0" <%if(syntype.equals("0")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(141 ,user.getLanguage()) %></option>
				<option value="1" <%if(syntype.equals("1")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(124 ,user.getLanguage()) %></option>
				<option value="2" <%if(syntype.equals("2")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(1867 ,user.getLanguage()) %></option>
			</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></wea:item>
			<wea:item>
			<select style='width:120px!important;' id="opertype" name="opertype">
				<option value="" <%if(opertype.equals("")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage()) %></option>
				<option value="0" <%if(opertype.equals("0")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(1421 ,user.getLanguage()) %></option>
				<option value="1" <%if(opertype.equals("1")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(103 ,user.getLanguage()) %></option>
				<option value="2" <%if(opertype.equals("2")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %></option>
				<option value="3" <%if(opertype.equals("3")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(20873 ,user.getLanguage()) %></option>
			</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(81420,user.getLanguage())%></wea:item>
			<wea:item>
			<select style='width:120px!important;' id="operresult" name="operresult">
				<option value="" <%if(operresult.equals("")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage()) %></option>
				<option value="0" <%if(operresult.equals("0")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(15242 ,user.getLanguage()) %></option>
				<option value="1" <%if(operresult.equals("1")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(498 ,user.getLanguage()) %></option>
			</select>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())+SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
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
					<!--QC:270810   [80][90]IM集成设置-调整高级搜索中按钮样式，以保持统一  e8_btn_submit-->
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
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
</BODY></HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script>
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
function resetCondtion(){
//281741 [80][90]IM集成设置-高级搜索中点击重置，会重置下面跳转、分页两个文本框
	$("#advancedSearchDiv input[type=text]").val('');
	//解绑，绑定
	archivingLogForm.syntype.value = "";
	jQuery(archivingLogForm.syntype).selectbox("detach");
	jQuery(archivingLogForm.syntype).selectbox();
	
	archivingLogForm.opertype.value = "";
	jQuery(archivingLogForm.opertype).selectbox("detach");
	jQuery(archivingLogForm.opertype).selectbox();
	
	archivingLogForm.operresult.value = "";
	jQuery(archivingLogForm.operresult).selectbox("detach");
	jQuery(archivingLogForm.operresult).selectbox();
	
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
function doRefresh(){
	$("#archivingLogForm").submit(); 
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
