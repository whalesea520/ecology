
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="userSort" class="weaver.workflow.report.UserExceedSort" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>

		<script type="text/javascript">
			function onBtnSearchClick(){
				jQuery("#frmMain").submit();
			}
		</script>

		<style>
			.sbSelector:link{color:#000;}
			.sbOptions a:link{color:#000;}
		</style>
	</head>

	<BODY>
		

<%
	String titlename = SystemEnv.getHtmlLabelName(19037, user.getLanguage()); 

	String userRights = ReportAuthorization.getUserRights("-10",user);//得到用户查看范围
	if (userRights.equals("-100")){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String fromdate = Util.null2String(request.getParameter("fromdate"));
	String todate = Util.null2String(request.getParameter("todate"));
	
	String typeId = Util.null2String(request.getParameter("typeId"));//得到搜索条件
	String flowId = Util.null2String(request.getParameter("flowId"));//得到搜索条件
	String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
	String objStatueType = Util.null2String(request.getParameter("objStatueType"));//得到流程状态搜索条件

	String fromadridate = Util.null2String(request.getParameter("fromadridate"));//得到到达搜索条件
	String toadridate = Util.null2String(request.getParameter("toadridate"));//得到到达搜索条件
	int objType1 = Util.getIntValue(request.getParameter("objType"),0);
	String objIds = Util.null2String(request.getParameter("objId"));//得到查询对象
	String objNames = "";
	if (!"".equals(objIds)) {		
		if (objIds.startsWith(",")) {
			objIds = objIds.replaceFirst(",", "");
		}
		String[] objIdArr = objIds.split(",");
		switch (objType1){
			case 1:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(resourceComInfo.getLastname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(resourceComInfo.getLastname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
		      	break;
			case 2:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
				break;
			case 3:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
				break;
		}	
	}

	String exportSQL = "";

	String sql = "select id from hrmresource where departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3)";
	if (userRights.equals("")) {
		sql = "select id from hrmresource where hrmresource.status in (0,1,2,3)";
	}

	String sqlCondition = " and 1=1";
	switch (objType1){
		case 1:
			sql += " and hrmresource.id in ("+objIds+")";
			sqlCondition += "and workflow_currentoperator.userid in (select id from hrmresource where id in ("+objIds+"))";
	      	break;
		case 2:
			sql += " and hrmresource.departmentid in ("+objIds+")"  ; 
			sqlCondition += "and workflow_currentoperator.userid in (select id from hrmresource where departmentid in ("+objIds+"))";
			break;
		case 3:
			sql += " and hrmresource.subcompanyid1 in ("+objIds+")"  ;
			sqlCondition += "and workflow_currentoperator.userid in (select id from hrmresource where subcompanyid1 in ("+objIds+"))";
			break;
	}

	if(!"".equals(fromdate)) {
		sqlCondition += " and workflow_currentoperator.receivedate >='" +fromdate+ "'";
	}
	if(!"".equals(todate)) {
		sqlCondition += " and workflow_currentoperator.receivedate <='" +todate+ "'";
	}
	if(!"".equals(objStatueType)) {
		if("1".equals(objStatueType)) {
			sqlCondition += " and workflow_requestbase.currentnodetype ='3'";
		} else {
			sqlCondition += " and workflow_requestbase.currentnodetype <>'3'";
		}
	}
	if (!typeId.equals("")){
		sqlCondition += " and workflow_currentoperator.workflowtype="+typeId+" ";
	} 
	
	if (!versionsIds.equals("")){
		sqlCondition += " and workflow_requestbase.workflowid in ( "+versionsIds+" )";
	}
	
	exportSQL = sql + "[sqlwhere]" + sqlCondition;
	
	String backfields = " id,counts,countall,percents,1 as ranking__ ";
	String fromSQL = userSort.getFromSQL(sqlCondition) + " where id in (" + sql + ") ";
	if (objType1 == 0) {
		backfields = "0 as percents, 1 as ranking__";
		fromSQL = " from workflow_currentoperator where 1=2 ";
		exportSQL = "";
	}
	String tableString = ""+
	"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FLOWREPORT_MOSTEXCEEDPERSON,user.getUID())+"\" tabletype=\"none\">"+
	"<sql backfields=\""+backfields+"\" showCountColumn=\"false\"  sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\" sqlorderby=\"percents desc\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
	"<head>"+							 
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(19083,user.getLanguage())+SystemEnv.getHtmlLabelName(19082,user.getLanguage())+"\" column=\"ranking__\" />"+
			 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\" />"+
			 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(18015,user.getLanguage())+"\" column=\"countall\" />"+
			 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(1982,user.getLanguage())+SystemEnv.getHtmlLabelName(18015,user.getLanguage())+"\" column=\"counts\" />"+
			 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(19101,user.getLanguage())+"\" column=\"percents\" transmethod=\"weaver.workflow.report.UserExceedSort.getPercents\" />"+
			 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(18939,user.getLanguage())+SystemEnv.getHtmlLabelName(19082,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.workflow.report.UserExceedSort.getDepartmentSort\" otherpara=\""+Util.toHtmlForSplitPage(fromSQL)+"\" />"+
			 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(19082,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.workflow.report.UserExceedSort.getSubCompanySort\" otherpara=\""+Util.toHtmlForSplitPage(fromSQL)+"\" />"+
	"</head>"+
	"</table>";
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19037, user.getLanguage())%>" />
		</jsp:include>
<!-- start -->
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343, user.getLanguage()) +",javascript:doExportExcel(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(82529, user.getLanguage())%>" onClick="submitData();" />
					<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>" onClick="doExportExcel();" />
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"
						class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div>
			<FORM id=frmMain name=frmMain action=MostExceedPerson.jsp method=post>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_FLOWREPORT_MOSTEXCEEDPERSON %>"/>
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(124810, user.getLanguage())%></wea:item>
						<wea:item>
							<select style="width: 80px;float: left;" class=InputStyle id="objType" name=objType onchange="onChangeType();">
								<option value="1" <%if (objType1==1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
								<option value="2" <%if (objType1==2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
								<option value="3" <%if (objType1==3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							</select>
	
							<brow:browser width="200px" viewType="0" name="objId" browserValue='<%=""+objIds%>' 
							    getBrowserUrlFn="getObjWindowUrl"
							    completeUrl="javascript:getAjaxUrl();"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput="2"
								browserSpanValue='<%=objNames%>'></brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(27165, user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="doccreatedateselect">
								<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
								<input class=wuiDateSel type="hidden" name="todate" value="<%=todate%>">
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%></wea:item>
						<wea:item>
							<select style="width: 80px" class=InputStyle name=objStatueType>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="1" <%if("1".equals(objStatueType)){%> selected
									<%}%>><%=SystemEnv.getHtmlLabelName(18800,user.getLanguage())%></option>
								<option value="2" <%if("2".equals(objStatueType)){%> selected
									<%}%>><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="typeId"
								browserValue='<%= ""+typeId %>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								_callback="changeFlowType"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue='<%=workTypeComInfo.getWorkTypename(typeId)%>'></brow:browser>
	
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="flowId"
								browserValue='<%= ""+flowId %>'
								getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
								isSingle="true" hasBrowser="true" isMustInput="1"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=workflowComInfo.getWorkflowname(flowId)%>'></brow:browser>
						</wea:item>
					</wea:group>
					
					<wea:group context='<%=SystemEnv.getHtmlLabelName(33518, user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">
	
							<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	
						</wea:item>
					</wea:group>
					</wea:layout>
	
			</FORM>
		</div>

		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<jsp:include page="/workflow/flowReport/IncludeExcelBody.jsp">
			<jsp:param name="exportProcess" value="exceedPerson"></jsp:param>
			<jsp:param name="exportSQL" value="<%=xssUtil.put(exportSQL) %>"></jsp:param>
		</jsp:include>
		<!-- end -->
	</body>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<script type="text/javascript">
	function changeFlowType() {
		_writeBackData('flowId', 1, {id:'',name:''});
	}

	function onChangeType(){
		_writeBackData('objId', 2, {id:'',name:''});
	}

	function submitData()
	{
		   if (check_form(frmMain,'objId'))
			frmMain.submit();
	}

	function getObjWindowUrl() {
		var objType1 = jQuery('#objType').val();
		if (objType1 == 2) {
			var tmpids = document.all('objId').value;
			return "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
		} else if (objType1 == 3) {
			var tmpids = document.all('objId').value;
			return "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
		} else {
			return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $G('objId').value;
		}
	}

	function getFlowWindowUrl(){
		return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("typeId").value;
	}
	
	function doExportExcel(){
		exportExcel();
	}

	function getAjaxUrl(){
		var objType1 = jQuery('#objType').val();
		var url = "";
		if (objType1 == 2) {
			url = "/data.jsp?type=4";
		} else if (objType1 == 3) {
			url = "/data.jsp?type=164";
		} else {
			url = "/data.jsp";
		}
		return url;
	}
	
	$(document.body).css({
	    "overflow-x":"hidden",
	    "overflow-y":"hidden"
	 });
</script>
</html>
