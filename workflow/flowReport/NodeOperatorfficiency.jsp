
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
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
			.e8_showNameClass a:link,.sbOptions a:link{color:#000;}
		</style>
	</head>
	<BODY>

<%
	String titlename = SystemEnv.getHtmlLabelName(19035, user.getLanguage());

	String userRights = ReportAuthorization.getUserRights("-8", user);//得到用户查看范围
	if (userRights.equals("-100")) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String typeId = Util.null2String(request.getParameter("typeId"));//得到搜索条件
	String flowId = Util.null2String(request.getParameter("flowId"));//得到搜索条件
	String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId); 
	String nodeType = Util.null2String(request.getParameter("nodeType"));//得到搜索条件
	String fromdate = Util.null2String(request.getParameter("fromdate"));//得到到达搜索条件
	String todate = Util.null2String(request.getParameter("todate"));//得到到达搜索条件
	

	String sqlCondition = "";
	if (userRights.equals("")) {
		sqlCondition = " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
	} else {
		sqlCondition = " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in (" + userRights + ") and hrmresource.status in (0,1,2,3))";
	}
	if (!"".equals(fromdate)) {
		sqlCondition += " and workflow_currentoperator.receivedate >='" + fromdate + "'";
	}
	if (!"".equals(todate)) {
		sqlCondition += " and workflow_currentoperator.receivedate <='" + todate + "'";
	}

	if (!typeId.equals("") && !typeId.equals("0"))
		sqlCondition += " and workflow_currentoperator.workflowid in (" + versionsIds + ")";
		//sqlCondition += " and workflow_currentoperator.workflowid = "+ flowId ;
	else
		sqlCondition = " and 1=2";
	if (!flowId.equals("") && !nodeType.equals("")) {
		//RecordSet.execute("select nodeid from workflow_flownode where workflowid =" + flowId + " and nodetype='" + nodeType + "' ");
		RecordSet.execute("select nodeid from workflow_flownode where workflowid in (" + versionsIds + ")" + " and nodetype='" + nodeType + "' ");
		String nodeids = "-1";
		while (RecordSet.next()) {
			nodeids = nodeids + "," + RecordSet.getInt(1);
		}
		if (!nodeids.equals("-1")) {
			sqlCondition += " and workflow_currentoperator.nodeid in (" + nodeids + ")";
		} else {
			sqlCondition = " and 1=2";
		}
	}

	String exportSQL = sqlCondition;

	StringBuilder sb = new StringBuilder();
	if (RecordSet.getDBType().equals("oracle") || RecordSet.getDBType().equals("db2")) {
	    //RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where trim(operatedate)='' " + sqlCondition);
	    RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where operatedate='' " + sqlCondition);

		sb.append("(select userid as id");//userid
		sb.append(", 24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')");
		sb.append("-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) as spends");//spends
		sb.append(" from workflow_currentoperator where exists (select 1 from workflow_requestbase where");
		sb.append(" workflow_requestbase.requestid=workflow_currentoperator.requestid");
		sb.append(" and status is not null) ").append(sqlCondition);
		sb.append(" group by userid) temptab");
	} else {
		RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where operatedate='' " + sqlCondition);

		sb.append("(select userid as id");//userid
		sb.append(",24*avg(convert(float,convert(datetime,case isremark when '2' then operatedate else isnull(operatedate ,convert(char(10),getdate(),20)) end  +' '+case isremark when '2' then operatetime else isnull(operatetime, convert(char(10),getdate(),108)) end ))");
		sb.append("-convert(float,convert(datetime,receivedate+' '+receivetime))) as spends");//spends
		sb.append(" from workflow_currentoperator where exists (select 1 from workflow_requestbase where");
		sb.append(" workflow_requestbase.requestid=workflow_currentoperator.requestid");
		sb.append(" and status is not null and status!='') ").append(sqlCondition);
		sb.append(" group by userid) as temptab");
	}

	String backfields = " id,spends,1 as ranking__ ";
	String fromSQL = sb.toString();
	if ("".equals(typeId) || "".equals(flowId)) {
		backfields = "0 as spends, 1 as ranking__";
		fromSQL = " from workflow_currentoperator where 1=2 ";
		exportSQL = "";
	}
	String tableString = ""+
	"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FLOWREPORT_NODEOPERATORFFICIENCY,user.getUID())+"\" tabletype=\"none\">"+
	"<sql backfields=\""+backfields+"\" showCountColumn=\"false\" sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\" sqlorderby=\"spends\" sqlprimarykey=\"id\" sqlsortway=\"desc\" sqldistinct=\"true\" />"+
	"<head>"+							 
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(19082,user.getLanguage())+"\" column=\"ranking__\" />"+
			 "<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\" />"+
			 "<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(19059,user.getLanguage())+"\" column=\"spends\" transmethod=\"weaver.workflow.report.NodeOperatorfficiencySort.getSpendsString\" />"+
	"</head>"+
	"</table>";
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow" />
	<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19035, user.getLanguage())%>" />
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
			+ ",javascript:submitData(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343, user.getLanguage())+",javascript:doExportExcel(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<!-- start -->
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(82529, user.getLanguage())%>" onClick="submitData();" />
					<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>" onClick="doExportExcel();" />
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
						class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div>
			<FORM id=frmMain name=frmMain action=NodeOperatorfficiency.jsp method=post>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_FLOWREPORT_NODEOPERATORFFICIENCY %>"/>
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(15774, user
									.getLanguage())%>">
						<wea:item><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="typeId"
								browserValue='<%="" + typeId%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								_callback="changeFlowType"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="2" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue='<%=workTypeComInfo.getWorkTypename(typeId)%>'></brow:browser>
	
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(259, user
										.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="flowId"
								browserValue='<%="" + flowId%>'
								getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
								isSingle="true" hasBrowser="true" isMustInput="2"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=workflowComInfo.getWorkflowname(flowId)%>'></brow:browser>
						</wea:item>

						
						<wea:item><%=SystemEnv.getHtmlLabelName(15536, user
										.getLanguage())%></wea:item>
						<wea:item>
							<select class=inputstyle size=1 name=nodeType style="width: 80px">
								<option value="0" <%if (nodeType.equals("0")) {%> selected
									<%}%>><%=SystemEnv.getHtmlLabelName(125, user
										.getLanguage())%></option>
								<option value="1" <%if (nodeType.equals("1")) {%> selected
									<%}%>><%=SystemEnv.getHtmlLabelName(142, user
										.getLanguage())%></option>
								<option value="2" <%if (nodeType.equals("2")) {%> selected
									<%}%>><%=SystemEnv.getHtmlLabelName(725, user
										.getLanguage())%></option>
								<!-- option value="3" <%if (nodeType.equals("0")) {%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(251, user
										.getLanguage())%></option-->
							</select>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(27165, user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="doccreatedateselect" >
								<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
								<input class=wuiDateSel type="hidden" name="todate" value="<%=todate%>">
							</span>
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
			<jsp:param name="exportProcess" value="nodeOperator"></jsp:param>
			<jsp:param name="exportSQL" value="<%=xssUtil.put(exportSQL)%>"></jsp:param>
		</jsp:include>
		<!-- end -->

	</body>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		
<script type="text/javascript">
	function getFlowWindowUrl(){
		return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("typeId").value;
	}

	function changeFlowType() {
		_writeBackData('flowId', 2, {id:'',name:''});
	}
	
	function submitData() {   
		if (check_form(frmMain,'typeId,flowId'))
	   		frmMain.submit();
	}
	
	function doExportExcel(){
		exportExcel();
	}
	$(document.body).css({
	    "overflow-x":"hidden",
	    "overflow-y":"hidden"
	 });
</script>
</html>
