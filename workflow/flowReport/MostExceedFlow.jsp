
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.util.*,java.math.*"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="mostExceedFlow" class="weaver.workflow.report.MostExceedFlow" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet"></jsp:useBean>
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
	String titlename = SystemEnv.getHtmlLabelName(19036, user.getLanguage());

	String userRights = ReportAuthorization.getUserRights("-9", user);//得到用户查看范围
	if (userRights.equals("-100")) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String fromcredate = Util.null2String(request.getParameter("fromcredate"));//得到创建时间搜索条件
	String tocredate = Util.null2String(request.getParameter("tocredate"));//得到创建时间搜索条件

	String typeId = Util.null2String(request.getParameter("typeId"));//得到搜索条件
	String flowId = Util.null2String(request.getParameter("flowId"));//得到搜索条件
	String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
	String objStatueType = Util.null2String(request.getParameter("objStatueType"));//得到流程状态搜索条件

	String objIds = Util.null2String(request.getParameter("objId"));
	if (objIds.startsWith(",")) {
		objIds = objIds.replaceFirst(",", "");
	}
	String objNames="";
	
	if(!"".equals(objIds)){
		RecordSet.executeSql("select requestid,requestname from workflow_requestbase  where requestid in ("+objIds+")");
		while(RecordSet.next()){
			objNames+=RecordSet.getString("requestname")+",";
		}
	}
	//String objNames = Util.null2String(request.getParameter("objNames"));
	int objType1 = Util.getIntValue(request.getParameter("objType"), 0);//得到创建时间搜索条件
	String rhobjId = Util.null2String(request.getParameter("rhobjId"));
	String rhobjNames = "";
	ArrayList<String> arrCountids = new ArrayList<String>();
	if (!"".equals(rhobjId)) {		
		if (rhobjId.startsWith(",")) {
			rhobjId = rhobjId.replaceFirst(",", "");
		}
		String[] rhobjIdArr = rhobjId.split(",");
		arrCountids = Util.getSplitString(rhobjIdArr,arrCountids);
		switch (objType1){
			case 1:
				if (rhobjIdArr.length == 1) {
					rhobjNames = Util.toScreen(resourceComInfo.getLastname(rhobjIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < rhobjIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(resourceComInfo.getLastname(rhobjIdArr[i]), user.getLanguage()));
					}
					rhobjNames = sb.toString();
				}
		      	break;
			case 2:
				if (rhobjIdArr.length == 1) {
					rhobjNames = Util.toScreen(departmentComInfo.getDepartmentname(rhobjIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < rhobjIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(departmentComInfo.getDepartmentname(rhobjIdArr[i]), user.getLanguage()));
					}
					rhobjNames = sb.toString();
				}
				break;
			case 3:
				if (rhobjIdArr.length == 1) {
					rhobjNames = Util.toScreen(subCompanyComInfo.getSubCompanyname(rhobjIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < rhobjIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(subCompanyComInfo.getSubCompanyname(rhobjIdArr[i]), user.getLanguage()));
					}
					rhobjNames = sb.toString();
				}
				break;
		}	
	}

	session.setAttribute("flowReport_flowId", flowId);
    session.setAttribute("flowReport_userRights", userRights);

	String exportSQL="";
	String sqlCondition = "";

	if (objType1 != 0 && !"".equals(rhobjId)) {
		switch (objType1) {
		case 1:
		    if(arrCountids.size() > 0){
                sqlCondition=" and ("  ;
			    for(int k = 0; k < arrCountids.size(); k++) {
			        if(k == 0){
			        	sqlCondition += "  userid in ("+arrCountids.get(k)+")";
			        }else{
			            sqlCondition += " or userid in ("+arrCountids.get(k)+")";
			        }
			    }
			    sqlCondition += ")";
			}
			break;
		case 2:
			sqlCondition = " and userid in (select id from hrmresource where departmentid in (" + rhobjId + ") )";
			break;
		case 3:
			sqlCondition = " and userid in (select id from hrmresource where subcompanyid1 in (" + rhobjId + ") )";
			break;
		}
	}
	if (!"".equals(fromcredate)) {
		sqlCondition += " and exists (select 1 from workflow_requestbase where requestid=t1.requestid and createdate >='" + fromcredate + "')";
	}
	if (!"".equals(tocredate)) {
		sqlCondition += " and exists (select 1 from workflow_requestbase where requestid=t1.requestid and createdate <='" + tocredate + "')";
	}
	if (!"".equals(objStatueType)) {
		if ("1".equals(objStatueType)) {
			sqlCondition += " and exists (select 1 from workflow_requestbase where requestid=t1.requestid and currentnodetype = '3')";
		} else {
			sqlCondition += " and exists (select 1 from workflow_requestbase where requestid=t1.requestid and currentnodetype <>'3') ";
		}
	}

	if (!typeId.equals("")) sqlCondition += " and workflowtype=" + typeId + " ";
	if (!versionsIds.equals("")) sqlCondition += " and workflowid in ( " + versionsIds + " )";
	if (!objIds.equals("")) sqlCondition += " and requestid in (" + objIds + ")  ";

	//List sortsExceed = MostExceedFlow.getMostExceedSort(sqlCondition);
	//ArrayList requestnamelist = new ArrayList();//0
	//ArrayList workflowlist = new ArrayList();//1
	//ArrayList overtimelist = new ArrayList();//2

	exportSQL = sqlCondition;

	String backfields = "id,workflowid,requestname,operatedate,isremark,receivedate,nodeid,destnodeid,1 as ranking__";
	String fromSQL = mostExceedFlow.getFromSQL(sqlCondition);
    if ("".equals(typeId) || "".equals(flowId)) {
    	backfields = " 0 as id,1 as ranking__ ";
    	fromSQL = " from workflow_currentoperator where 1=2 ";
    	exportSQL = "";
    }
    String tableString = ""+
    "<table instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FLOWREPORT_MOSTEXCEEDFLOW,user.getUID())+"\" tabletype=\"none\">"+
    "<sql backfields=\""+backfields+"\" showCountColumn=\"false\"  sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\" sqlwhere=\"\" sqlorderby=\"id\" sqlprimarykey=\"id\" sqlsortway=\"desc\" sqldistinct=\"true\" />"+
    "<head>"+							 
    		 "<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(19082, user.getLanguage())+"\" column=\"ranking__\" />"+
    		 "<col width=\"22%\" text=\""+SystemEnv.getHtmlLabelName(19060, user.getLanguage())+"\" column=\"requestname\" />"+
    		 "<col width=\"22%\" text=\""+SystemEnv.getHtmlLabelName(259, user.getLanguage())+"\" column=\"workflowid\" transmethod=\"weaver.workflow.report.MostExceedFlow.getFlowName\" />"+
    		 "<col width=\"22%\" text=\""+SystemEnv.getHtmlLabelName(16579, user.getLanguage())+"\" column=\"workflowid\" transmethod=\"weaver.workflow.report.MostExceedFlow.getFlowTypeName\" />"+
    		 "<col width=\"22%\" text=\""+SystemEnv.getHtmlLabelName(124828, user.getLanguage()) +"\" column=\"id\" transmethod=\"weaver.workflow.report.MostExceedFlow.getOverTimeString\" otherpara=\"column:operatedate+column:isremark+column:receivedate+column:workflowid+column:nodeid+column:destnodeid\" />"+
    "</head>"+
    "</table>";
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19036, user.getLanguage())%>" />
		</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())+ ",javascript:submitData(this),_self}";
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
				<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(82529, user.getLanguage())%>" onClick="submitData(this);" />
				<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>" onClick="doExportExcel();" />
				<span
					title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"
					class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div>
		<FORM id=frmMain name=frmMain action=MostExceedFlow.jsp method=post>
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_FLOWREPORT_MOSTEXCEEDFLOW %>"/>
			<ipnut type="hidden" id="objNames" name="objNames" value = "<%=objNames%>">
			<wea:layout type="4col" attributes="{'isTableList':'true','width':'25%'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="typeId"
							browserValue='<%= ""+typeId %>'
							browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
							_callback="changeFlowType"
							hasInput="true" isSingle="true" hasBrowser="true"
							isMustInput="2" completeUrl="/data.jsp?type=worktypeBrowser"
							browserDialogWidth="600px"
							browserSpanValue='<%=workTypeComInfo.getWorkTypename(""+typeId)%>'></brow:browser>

					</wea:item>

					<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="flowId"
							browserValue='<%= ""+flowId %>'
							getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
							isSingle="true" hasBrowser="true" isMustInput="2"
							completeUrl="/data.jsp?type=workflowBrowser"
							browserSpanValue='<%=workflowComInfo.getWorkflowname(""+flowId)%>'></brow:browser>
					</wea:item>

					<wea:item><%=SystemEnv.getHtmlLabelName(19060, user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="objId"
							browserValue='<%= ""+objIds %>'
							getBrowserUrlFn="getRequestWindowUrl" hasInput="true"
							isSingle="false" hasBrowser="true" isMustInput="1"
							completeUrl="javascript:getWfUrl();"
							browserSpanValue='<%=objNames%>'></brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(81517, user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="doccreatedateselect" >
							<input class=wuiDateSel type="hidden" name="fromcredate" value="<%=fromcredate%>">
							<input class=wuiDateSel type="hidden" name="tocredate" value="<%=tocredate%>">
						</span>
					</wea:item>

					<wea:item><%=SystemEnv.getHtmlLabelName(124810, user.getLanguage())%></wea:item>
					<wea:item>
						<select style="width: 80px;float: left;" class=inputstyle id="objType" name=objType onchange="onChangeType()">
							<option value="1" <%if (objType1==1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
							<option value="2" <%if (objType1==2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							<option value="3" <%if (objType1==3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
						</select>

						<brow:browser width="200px" viewType="0" name="rhobjId" browserValue='<%= ""+rhobjId %>' 
						    getBrowserUrlFn="getObjWindowUrl"
						    completeUrl="javascript:getAjaxUrl();"
							hasInput="true" isSingle="false" hasBrowser="true"
							isMustInput="1"
							browserSpanValue='<%=rhobjNames%>'></brow:browser>
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%></wea:item>
					<wea:item>
						<select style="width: 80px" class=inputstyle name=objStatueType>
							<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%if("1".equals(objStatueType)){%> selected
								<%}%>><%=SystemEnv.getHtmlLabelName(18800,user.getLanguage())%></option>
							<option value="2" <%if("2".equals(objStatueType)){%> selected
								<%}%>><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>
						</select>
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
	<!-- end -->
	
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<jsp:include page="/workflow/flowReport/IncludeExcelBody.jsp">
			<jsp:param name="exportProcess" value="exceedFlow"></jsp:param>
			<jsp:param name="exportSQL" value="<%=xssUtil.put(exportSQL) %>"></jsp:param>
		</jsp:include>
	</body>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<script>
	function changeFlowType() {
		_writeBackData('flowId', 2, {id:'',name:''});
	}

	function getRequestWindowUrl() {
		var flowId = jQuery("#flowId").val();
		if(flowId == "" || flowId == null){
			flowId = "-999";
		}
		return "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowserRight.jsp?isfrom=flowrpt&resourceids="+flowId+"#"+jQuery("#typeId").val()+"&selectedids="+jQuery("#objId");
	}

	function getFlowWindowUrl() {
		return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G('typeId').value;
	}

	function getObjWindowUrl() {
		var objType1 = jQuery('#objType').val();
		if (objType1 == 2) {
			var tmpids = document.all('rhobjId').value;
			return "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
		} else if (objType1 == 3) {
			var tmpids = document.all('rhobjId').value;
			return "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
		} else {
			return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $G('rhobjId').value;
		}
	}

	function doExportExcel(){
		exportExcel();
	}

	function onChangeType(){
	    _writeBackData('rhobjId', 1, {id:'',name:''});	
	}     
	
	function submitData(obj) {
	   if (check_form(frmMain,'typeId,flowId')){
	        obj.disabled = true;
			frmMain.submit();
	   }
	}

	function getWfUrl(){
		var flowId = jQuery("#flowId").val();
		if(flowId == "" || flowId == null){
			return false;
		}
		var url = "/data.jsp?type=requestbrowserright&wfid="+flowId;
		return url;
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
