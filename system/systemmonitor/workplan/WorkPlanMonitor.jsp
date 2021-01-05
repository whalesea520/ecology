
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

 <%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="workPlanSearch" class="weaver.WorkPlan.WorkPlanSearch" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
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
	String currUserId = String.valueOf(user.getUID());  //用户ID
	String currUserType = user.getLogintype();  //用户类型
	String planName = Util.null2String(request.getParameter("planName"));  //日程名
	String urgentLevel = Util.null2String(request.getParameter("urgentLevel"));  //紧急程度
	String planType = Util.null2String(request.getParameter("planType"));  //日程类型
	String planStatus = Util.null2String(request.getParameter("planStatus"));  //状态  0：代办；1：完成；2、归档
	String createrID = Util.null2String(request.getParameter("createrID"));  //提交人
	//String receiveType = Util.null2String(request.getParameter("receiveType"));  //接受类型  1：人力资源 5：分部 2：部门
	//String receiveID = Util.null2String(request.getParameter("receiveID"));  //接收ID
	String beginDate = Util.null2String(request.getParameter("beginDate"));  //开始日期
	String endDate = Util.null2String(request.getParameter("endDate"));  //结束日期
	String beginDaten = Util.null2String(request.getParameter("beginDaten"));  //开始日期
	String endDaten = Util.null2String(request.getParameter("endDaten"));  //结束日期
	if (planStatus.equals("-1"))
	{
	    planStatus = "";
	}

	//1:workPlanSearch.doSearchExchanged
	//2:workPlanSearch.doSearchFinishRemind
	//其他：workPlanSearch.doSearch(currUserId, currUserType, planName, urgentLevel, planType, planStatus, 
	//							createrID, receiveID, crmIds, docIds, projectIds, requestIds, beginDate, endDate,
	//							String.valueOf(pageNum))
	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(356,user.getLanguage()) + ":&nbsp;"
					 + SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:doSearchAgain(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteWorkPlan(),_self}" ;
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("23852,555",user.getLanguage())+",javascript:doFinish(),_self}" ;
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:openLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="deleteWorkPlan()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("23852,555",user.getLanguage()) %>" class="e8_btn_top middle" onclick="doFinish()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""  />
			
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(19792,user.getLanguage())%></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
<!--================== 搜索部分 ==================-->
<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanMonitor.jsp">
<input type="hidden" name="workPlanIDs" value="">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<!--================== 标题 ==================-->	
	  		<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
	  		<wea:item><INPUT type="text" class="InputStyle" maxlength="100" name="planName" value='<%=planName%>'></wea:item>
			
			<!--================== 紧急程度 ==================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
			<wea:item>
				<SELECT id="urgentLevel" name="urgentLevel" style="width:100px;">
					<OPTION value="" <%if(!"1".equals(urgentLevel) && !"2".equals(urgentLevel) && !"3".equals(urgentLevel)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
					<OPTION value="1" <%if("1".equals(urgentLevel)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></OPTION>
					<OPTION value="2" <%if("2".equals(urgentLevel)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></OPTION>
					<OPTION value="3" <%if("3".equals(urgentLevel)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></OPTION>
				</SELECT>
			</wea:item>
			
			<!--================== 日程类型 ==================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></wea:item>
			<wea:item>
				<SELECT id="planType" name="planType" style="width:100px;">
					<OPTION value="" <%if("".equals(planType)) {%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>											
				<%
		  			rs.executeSql("SELECT * FROM WorkPlanMonitor workPlanMonitor, WorkPlanType workPlanType WHERE workPlanMonitor.workPlanTypeId = workPlanType.workPlanTypeId AND workPlanMonitor.hrmID = " + currUserId + " ORDER BY workPlanType.displayOrder ASC");
		  			while(rs.next())
		  			{
		  		%>
		  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>" <%if(planType.equals(""+rs.getInt("workPlanTypeID"))) {%>selected<%}%> ><%= Util.forHtml(rs.getString("workPlanTypeName")) %></OPTION>
		  		<%
		  			}
		  		%>
				</SELECT>
			</wea:item>
	 		<!--================== 状态 ==================-->
	  		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
	  		<wea:item>
	  			<SELECT id="planStatus" name="planStatus" style="width:100px;">
					<OPTION value="" <%if("".equals(planStatus)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
					<OPTION value="0" <%if("0".equals(planStatus)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
					<OPTION value="1" <%if("1".equals(planStatus)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
					<OPTION value="2" <%if("2".equals(planStatus)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>		
				</SELECT>
	  		</wea:item>
			
			<!--================== 提交人 ==================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="createrID" browserValue='<%=createrID%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%= Util.toScreen(resourceComInfo.getResourcename(createrID),user.getLanguage()) %>'></brow:browser>
			</wea:item>
			
			<!--================== 开始日期 结束日期 ==================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
		  	<wea:item>
				<button type="button" class="Calendar" id="SelectBeginDate" onclick="getDate(beginDateSpan,beginDate)"></BUTTON> 
			  	<SPAN id="beginDateSpan" name="beginDateSpan"><%=beginDate%></SPAN> 
		  		<INPUT type="hidden" id="beginDate" name="beginDate" value="<%=beginDate%>">  
		  		&nbsp;-&nbsp;&nbsp;
		  		<button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(endDateSpan,endDate)"></BUTTON> 
		  		<SPAN id="endDateSpan" name="endDateSpan"><%=endDate%></SPAN> 
			    <INPUT type="hidden" id="endDate" name="endDate" value="<%=endDate%>">
			</wea:item>
			<wea:item> <%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		  	<wea:item>
				<button type="button" class="Calendar" id="SelectBeginDaten" onclick="getDate(beginDateSpann,beginDaten)"></BUTTON> 
			  	<SPAN id="beginDateSpann" name="beginDateSpann"><%=beginDaten%></SPAN> 
		  		<INPUT type="hidden" id="beginDaten" name="beginDaten" value="<%=beginDaten%>">  
		  		&nbsp;-&nbsp;&nbsp;
		  		<button type="button" class="Calendar" id="SelectEndDaten" onclick="getDate(endDateSpann,endDaten)"></BUTTON> 
		  		<SPAN  id="endDateSpann" name="endDateSpann"><%=endDaten%></SPAN> 
			    <INPUT type="hidden" id="endDaten" name="endDaten" value="<%=endDaten%>">
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" onclick="doSearchAgain();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</FORM>		
</div>
<!--================== 搜索结果列表 ==================-->
<%
	String backFields = "workPlan.ID, workPlan.name, workPlan.urgentLevel, workPlan.type_n, workPlan.createrID, workPlan.status, workPlan.beginDate, workPlan.endDate, workPlan.createDate, workPlan.createTime";
	String sqlForm = "WorkPlan workPlan, WorkPlanMonitor workPlanMonitor";
	String sqlWhere = "WHERE workPlan.type_n = workPlanMonitor.workPlanTypeID AND workPlanMonitor.hrmID = " + currUserId;														
	String orderby = "workPlan.createDate, workPlan.createTime ";
									
	if(!"".equals(planName) && null != planName)
	{
		planName=planName.replaceAll("\"","＂");
		planName=planName.replaceAll("'","＇");
		sqlWhere += " AND workPlan.name LIKE '%" + planName + "%'";
	}
	if(!"".equals(urgentLevel) && null != urgentLevel)
	{
		sqlWhere += " AND workPlan.urgentLevel = '" + urgentLevel + "'";
	}
	if(!"".equals(planType) && null != planType)
	{
		sqlWhere += " AND workPlan.type_n = '" + planType + "'";
	}
	if(!"".equals(planStatus) && null != planStatus)
	{
		sqlWhere += " AND workPlan.status = '" + planStatus + "'";
	}
	if(!"".equals(createrID) && null != createrID)
	{
		sqlWhere += " AND workPlan.createrID = " + createrID;
	}
	
	/*if(!"".equals(receiveID) && null != receiveID)
	{									
		sqlWhere += " AND (";
		sqlWhere += " workPlan.resourceID = '" + receiveID + "'";
		sqlWhere += " OR workPlan.resourceID LIKE '" + receiveID + ",%'";
		sqlWhere += " OR workPlan.resourceID LIKE '%," + receiveID + ",%'";
		sqlWhere += " OR workPlan.resourceID LIKE '%," + receiveID + "'";
		sqlWhere += ")";														
	}*/
	
	if((!"".equals(beginDate) && null != beginDate) && ("".equals(endDate) || null == endDate))
	{
		sqlWhere += " AND (workPlan.beginDate >= '" + beginDate;								    
		sqlWhere += "' OR workPlan.beginDate IS NULL  or  workPlan.beginDate ='')";
	}
	else if(("".equals(beginDate) || null == beginDate) && (!"".equals(endDate) && null != endDate))
	{
		sqlWhere += " AND (workPlan.beginDate <= '" + endDate + "' OR workPlan.beginDate IS NULL  or  workPlan.beginDate ='' ) ";
	}
	else if((!"".equals(beginDate) && null != beginDate) && (!"".equals(endDate) && null != endDate))
	{
		sqlWhere += " AND (";							    	        
		sqlWhere += " workPlan.beginDate >= '" + beginDate;
		sqlWhere += "' AND workPlan.beginDate <= '" + endDate;
		sqlWhere += "')";
	}

	if((!"".equals(beginDaten) && null != beginDaten) && ("".equals(endDaten) || null == endDaten))
	{
		sqlWhere += " AND (workPlan.endDate >= '" + beginDaten;								    
		sqlWhere += "' OR workPlan.endDate IS NULL  or  workPlan.endDate ='')";
	}
	else if(("".equals(beginDaten) || null == beginDaten) && (!"".equals(endDaten) && null != endDaten))
	{
		sqlWhere += " AND (workPlan.endDate <= '" + endDaten + "' OR workPlan.endDate IS NULL  or  workPlan.endDate ='' ) ";
	}
	else if((!"".equals(beginDaten) && null != beginDaten) && (!"".equals(endDaten) && null != endDaten))
	{
		sqlWhere += " AND (";							    	        
		sqlWhere += " workPlan.endDate >= '" + beginDaten;
		sqlWhere += "' AND workPlan.endDate <= '" + endDaten;
		sqlWhere += "')";
	}												
   	//out.print(sqlWhere);
	String tableString=""+
		"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WP_WorkPlanMonitor,user.getUID())+"\" tabletype=\"checkbox\">"+
		"<sql backfields=\"" + backFields + "\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"workPlan.ID\" sqlorderby=\"" + orderby + "\"  sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
		"<head>"+
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrID\" orderkey=\"createrID\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getResourceName\" />"+							    
		"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"ID\" otherpara=\"column:name+column:type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanName\"/>"+
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"urgentLevel\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"urgentLevel\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getUrgentName\" />"+
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16094,user.getLanguage())+"\" column=\"type_n\" orderkey=\"type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanType\"/>"+
		"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2211,user.getLanguage()) + SystemEnv.getHtmlLabelName(602,user.getLanguage())+ "\" column=\"status\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getStatusName\"/>"+
		"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"beginDate\" orderkey=\"beginDate\"/>"+
		"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"endDate\" orderkey=\"endDate\"/>"+						    
		"</head>"+
"		<operates>"+
"		<popedom column=\"status\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.showFinishBtn\"></popedom> "+
"		<operate href=\"javascript:doFinish();\" text=\""+SystemEnv.getHtmlLabelNames("23852,555",user.getLanguage())+"\" target=\"_self\" index=\"0\" />"+
"		</operates>"+
		"</table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WP_WorkPlanMonitor%>"/>
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY>
</HTML>

<SCRIPT language="JavaScript">
function openLog(){
	var logURL = "";
	<%if(rs.getDBType().equals("db2"))
	{%>
		logURL = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=91" ;
	<%}
	else
	{%>
		logURL = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=91 " ;
	<%}%>
	window.open(logURL);
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
 	jQuery("#advancedSearchDiv").find("select").selectbox('detach');
	jQuery("#advancedSearchDiv").find("select").selectbox('attach');
	
	
	
	//清空日期
	jQuery("#advancedSearchDiv").find(".Calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Calendar").siblings("input[type='hidden']").val("");
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
	$("input[name='planName']").val(name);
	doSearchAgain();
}

function doSearchAgain() 
{	
	document.frmmain.submit();
}
function checkDateValid(objStartName, objEndName) {
	var dateStart = $('#'+objStartName).val();
	var dateEnd = $('#'+objEndName).val();

	if ((dateStart == null || dateStart == "") || (dateEnd == null || dateEnd == ""))
		return true;

	var yearStart = dateStart.substring(0,4);
	var monthStart = dateStart.substring(5,7);
	var dayStart = dateStart.substring(8,10);
	var yearEnd = dateEnd.substring(0,4);
	var monthEnd = dateEnd.substring(5,7);
	var dayEnd = dateEnd.substring(8,10);
		
	if (yearStart > yearEnd)		
		return false;
	
	if (yearStart == yearEnd) {
		if (monthStart > monthEnd)
			return false;
		
		if (monthStart == monthEnd)
			if (dayStart > dayEnd)
				return false;
	}

	return true;
}
function deleteWorkPlan(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        document.frmmain.action='/system/systemmonitor/workplan/WorkPlanMonitorOperation.jsp?method=delete';
        	document.frmmain.workPlanIDs.value = _xtable_CheckedCheckboxId();
        	document.frmmain.submit();
	    });
    }
    
}

function doFinish(id){
	var finishIds = "";
	var _id=id;
	//alert(_id);
    if(_id!=undefined&&_id!=""){//从操作菜单那边传来的操作
    	finishIds=_id;
	}else{//从顶部按钮传来的操作
		finishIds=_xtable_CheckedCheckboxId();
	}
	if(finishIds==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("125389,2211",user.getLanguage())%>");//请先选择 日程
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelNames("83446,23852,555,2211",user.getLanguage())%>?";//确定 强制 完成 日程？
   		window.top.Dialog.confirm(str,function(){
	        document.frmmain.action='/system/systemmonitor/workplan/WorkPlanMonitorOperation.jsp?method=finish';
        	document.frmmain.workPlanIDs.value = finishIds;
        	document.frmmain.submit();
	    });
    }
    
}
 
var diag_vote;
function view(id, workPlanTypeID){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = false;
	diag_vote.isIframe=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
	if(workPlanTypeID == 6){
		diag_vote.URL = "/hrm/performance/targetPlan/PlanView.jsp?from=2&id=" + id ;
	} else {
		diag_vote.URL = "/workplan/data/WorkPlanDetail.jsp?from=1&workid=" + id ;
	}
	diag_vote.show();
}

function init()
{
	var planName = "<%= planName %>";
	var urgentLevel = "<%= urgentLevel %>";
	var planType = "<%= planType %>";
	var planStatus = "<%= planStatus %>";
	var createrID = "<%= createrID %>";
	var beginDate = "<%= beginDate %>";
	var endDate = "<%= endDate %>";
	var beginDaten = "<%= beginDaten %>";
	var endDaten = "<%= endDaten %>";
	/*================== 标题 ==================*/
	document.frmmain.planName.value = planName;

	/*================== 紧急程度 ==================*/
	for(var i = 0; i < document.frmmain.urgentLevel.length; i++)
	{	
		if(urgentLevel == document.frmmain.urgentLevel[i].value)
		{
			document.frmmain.urgentLevel.selectedIndex = i;
		}
	}
	
	/*================== 日程类型 ==================*/
	for(var i = 0; i < document.frmmain.planType.length; i++)
	{	
		if(planType == document.frmmain.planType[i].value)
		{
			document.frmmain.planType.selectedIndex = i;
		}
	}
	
	/*================== 状态 ==================*/
	for(var i = 0; i < document.frmmain.planStatus.length; i++)
	{	
		if(planStatus == document.frmmain.planStatus[i].value)
		{
			document.frmmain.planStatus.selectedIndex = i;
		}
	}
	
	/*================== 提交人 ==================*/	
	$GetEle("createrID").value = createrID;
	$($GetEle("createrIDSpan")).html("<A href=/hrm/resource/HrmResource.jsp?id=" + createrID + "><%= resourceComInfo.getResourcename(createrID) %>" + "</A>");
		
	/*================== 开始日期 ==================*/
	$GetEle("beginDate").value = beginDate;
	$($GetEle("beginDateSpan")).text(beginDate);
	
	/*================== 结束日期 ==================*/
	$GetEle("endDate").value = endDate;
	$($GetEle("endDateSpan")).text(endDate);
	/*================== 开始日期 ==================*/
	$GetEle("beginDaten").value = beginDaten;
	$($GetEle("beginDateSpann")).text( beginDaten);
	
	/*================== 结束日期 ==================*/
	$GetEle("endDaten").value = endDaten;
	$($GetEle("endDateSpann")).text(endDaten);
}
$(function(){
	init();
});
</SCRIPT>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
