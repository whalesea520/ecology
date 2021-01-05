
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="spendTimeStatSort" class="weaver.workflow.report.SpendTimeStatSort" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="workFlowTransMethod" class="weaver.general.WorkFlowTransMethod" scope="page"/>
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
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19031 , user.getLanguage())%>" />
		</jsp:include>

<%
	String imagefilename = "/images/hdReport_wev8.gif" ;
	String needfav = "1" ;
	String needhelp = "" ;

	String titlename = SystemEnv.getHtmlLabelName(19031 , user.getLanguage()) ; 
	String userRights=ReportAuthorization.getUserRights("-5", user);//得到用户查看范围
    if (userRights.equals("-100")) {
	    response.sendRedirect("/notice/noright.jsp");
		return;
    }

    String typeId = Util.null2String(request.getParameter("typeId"));//得到搜索条件
    String flowId = Util.null2String(request.getParameter("flowId"));//得到搜索条件
    String wfIdVersions =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
    String flowStatus = Util.null2String(request.getParameter("flowStatus"));
    String nodeType = Util.null2String(request.getParameter("nodetype"));//得到搜索条件
    String fromcredate = Util.null2String(request.getParameter("fromcredate"));//得到创建时间搜索条件
    String tocredate = Util.null2String(request.getParameter("tocredate"));//得到创建时间搜索条件
    String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
    if(doccreatedateselect.equals(""))
    	doccreatedateselect = "0";
	if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0") && !doccreatedateselect.equals("6")) {
		fromcredate = TimeUtil.getDateByOption(doccreatedateselect, "0");
		tocredate = TimeUtil.getDateByOption(doccreatedateselect, "1");
	}
    int objType1 = Util.getIntValue(request.getParameter("objType"),0);//得到创建时间搜索条件
    String rhobjId = Util.null2String(request.getParameter("rhobjId"));
    String rhobjNames = "";
	ArrayList<String> arrCountids = new ArrayList<String>();
    if (!"".equals(rhobjId)) {		
		if (rhobjId.startsWith(",")) {
			rhobjId = rhobjId.replaceFirst(",", "");
		}
		String[] objIdArr = rhobjId.split(",");
		arrCountids = Util.getSplitString(objIdArr,arrCountids);
		switch (objType1){
			case 1:
				if (objIdArr.length == 1) {
					rhobjNames = Util.toScreen(resourceComInfo.getLastname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(resourceComInfo.getLastname(objIdArr[i]), user.getLanguage()));
					}
					rhobjNames = sb.toString();
				}
		      	break;
			case 2:
				if (objIdArr.length == 1) {
					rhobjNames = Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[i]), user.getLanguage()));
					}
					rhobjNames = sb.toString();
				}
				break;
			case 3:
				if (objIdArr.length == 1) {
					rhobjNames = Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[i]), user.getLanguage()));
					}
					rhobjNames = sb.toString();
				}
				break;
		}	
	}
    int timeType1 = Util.getIntValue(request.getParameter("timeType1"));//得到搜索条件
    int timeUnit1 = Util.getIntValue(request.getParameter("timeUnit1"));//得到搜索条件
    int timeV1 = Util.getIntValue(request.getParameter("time1"), -1);
    long time1 = spendTimeStatSort.getMinutes(timeUnit1, timeV1);//得到搜索条件
    int timeType2 = Util.getIntValue(request.getParameter("timeType2"));//得到搜索条件
    int timeUnit2 = Util.getIntValue(request.getParameter("timeUnit2"));//得到搜索条件
    int timeV2 = Util.getIntValue(request.getParameter("time2"), -1);
    long time2 = spendTimeStatSort.getMinutes(timeUnit2, timeV2);//得到搜索条件

    String search = Util.null2String(request.getParameter("search"));

    String exportSQL = "";
    String sqlCondition = "";
    String sqlCondition1 = "";

	if(objType1 != 0 && !"".equals(rhobjId)) {
	    switch (objType1) {
	        case 1:
	        	if(arrCountids.size() > 0){
	                sqlCondition=" and ("  ;
				    for(int k = 0; k < arrCountids.size(); k++) {
				        if(k == 0){
				        	sqlCondition += "  creater in ("+arrCountids.get(k)+")";
				        }else{
				            sqlCondition += " or creater in ("+arrCountids.get(k)+")";
				        }
				    }
				    sqlCondition += ")";
				}
	        break;
	        case 2:
	        	sqlCondition =" and creater in (select id from hrmresource where departmentid in ("+rhobjId+") )" ;
	        break;
	        case 3:
	        	sqlCondition =" and creater in (select id from hrmresource where subcompanyid1 in ("+rhobjId+") )" ;
	        break;
		}
    }
    if(!"".equals(fromcredate)) {
    	sqlCondition += " and createdate >='" +fromcredate+ "'";
    }
    if(!"".equals(tocredate)) {
    	sqlCondition += " and createdate <='" +tocredate+ "'";
	}
    if ("".equals(userRights)) {
    	sqlCondition1 += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    } else {
    	sqlCondition1 += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
    if (!"".equals(typeId) && !"0".equals(typeId))
    	sqlCondition1+=" and workflow_currentoperator.workflowtype=" + typeId;
    sqlCondition += " and workflow_requestbase.workflowid>1 ";
    if (!"".equals(flowId))
    	sqlCondition+=" and workflow_requestbase.workflowid in (" + wfIdVersions + ")";
    if ("1".equals(flowStatus))
    	sqlCondition+=" and workflow_requestbase.currentnodetype=3 ";
    if ("2".equals(flowStatus))
    	sqlCondition+=" and workflow_requestbase.currentnodetype<3 ";
    if (!"".equals(nodeType))
    	sqlCondition+=" and workflow_requestbase.currentnodetype='"+nodeType+"' ";

	if (RecordSet.getDBType().equals("oracle") || RecordSet.getDBType().equals("db2")) {
		if (time1 >= 0)
			sqlCondition += " and 1440*(to_date( NVL2(lastoperatedate ,lastoperatedate||' '|| NVL2(lastoperatetime,lastoperatetime,to_char(sysdate, 'HH24:MI:SS')),to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
	   						"-to_date(createdate||' '||createtime,'YYYY-MM-DD HH24:MI:SS'))"+spendTimeStatSort.getSQLTypeString(timeType1)+time1;
		if (time2 >= 0)
			sqlCondition += " and 1440*(to_date( NVL2(lastoperatedate ,lastoperatedate||' '|| NVL2(lastoperatetime,lastoperatetime,to_char(sysdate, 'HH24:MI:SS')),to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
	   						"-to_date(createdate||' '||createtime,'YYYY-MM-DD HH24:MI:SS'))"+spendTimeStatSort.getSQLTypeString(timeType2)+time2;
	} else {
	  	if (time1 >= 0)
	  		sqlCondition += " and convert(bigint,1440*(convert(float,convert(datetime, case lastoperatedate when '' then convert(char(10),getdate(),20) when null then convert(char(10),getdate(),20) else lastoperatedate end +' '+isnull(lastoperatetime,convert(char(10),getdate(),108))))"+
	  						"-convert(float,convert(datetime,createdate+' '+createtime))))"+spendTimeStatSort.getSQLTypeString(timeType1)+time1;
	  	if (time2 >= 0)
	  		sqlCondition += " and convert(bigint,1440*(convert(float,convert(datetime, case lastoperatedate when '' then convert(char(10),getdate(),20) when null then convert(char(10),getdate(),20) else lastoperatedate end +' '+isnull(lastoperatetime,convert(char(10),getdate(),108))))"+
	  						"-convert(float,convert(datetime,createdate+' '+createtime))))"+spendTimeStatSort.getSQLTypeString(timeType2)+time2;
	}

	String sqls = "";
	if (RecordSet.getDBType().equals("oracle") || RecordSet.getDBType().equals("db2")) {
		sqls = "(select requestname as id,workflow_requestbase.requestid,workflow_requestbase.workflowid,status,24*(to_date( NVL2(lastoperatedate ,lastoperatedate||' '||lastoperatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
			    "-to_date(createdate||' '||createtime,'YYYY-MM-DD HH24:MI:SS')) as spends "+
				" from workflow_requestbase where "+
				"  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid "+sqlCondition1+" ) and status is not null and exists (select 1 from workflow_base where id = workflow_requestbase.workflowid and isvalid in (1,3)) "+sqlCondition+
				"  ) ";
		exportSQL = "select requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,status,24*(to_date( NVL2(lastoperatedate ,lastoperatedate||' '||lastoperatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
				    "-to_date(createdate||' '||createtime,'YYYY-MM-DD HH24:MI:SS')) as spends "+
					" from workflow_requestbase where "+
					"  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid "+sqlCondition1+" ) and status is not null "+sqlCondition+
					"  order by spends desc";
 	} else {
 		sqls = "(select requestname as id,workflow_requestbase.requestid,workflow_requestbase.workflowid,status, 24 *( convert(float,convert(datetime, case lastoperatedate when '' then convert(char(10),getdate(),20) when null then convert(char(10),getdate(),20) else lastoperatedate end + ' ' + isnull(lastoperatetime,convert(char(10), getdate(), 108)))) "+
 				"- convert(float,convert(datetime, createdate + ' ' + createtime))) as spends "+
 				" from workflow_requestbase where "+
 				"  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid and workflow_currentoperator.preisremark='0' "+sqlCondition1+" ) and exists (select 1 from workflow_base where id = workflow_requestbase.workflowid and isvalid in (1,3)) and status is not null and status!='' "+sqlCondition+
 				"  ) as temptab";
	 	exportSQL = sqlCondition1 + "[sqlwhere]" + sqlCondition;//导出所有数据到excel
	}

    exportSQL = exportSQL.replaceAll("\\+", "%2B");

    String backfields = " id,workflowid,spends ";
	String fromSQL = sqls;
	if ("".equals(search)) {
		//fromSQL += " where 1=2";		//打开页面就加载数据

	}
	String tableString = ""+
	"<table pageId=\""+PageIdConst.WF_FLOWREPORT_SPENDTIMESTAT+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FLOWREPORT_SPENDTIMESTAT,user.getUID())+"\" tabletype=\"none\">"+
	"<sql backfields=\""+backfields+"\" showCountColumn=\"false\"  sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\" sqlorderby=\"spends\" sqlprimarykey=\"id\" sqlsortway=\"desc\" sqldistinct=\"true\" />"+
	"<head>"+							 
			 "<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\" column=\"workflowid\" transmethod=\"weaver.workflow.report.SpendTimeStatSort.getFlowTypeName\" />"+
			 "<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" transmethod=\"weaver.workflow.report.SpendTimeStatSort.getFlowName\" />"+
			 "<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(19060,user.getLanguage())+"\" column=\"id\" />"+
			 "<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(19079,user.getLanguage())+"\" column=\"spends\" transmethod=\"weaver.workflow.report.SpendTimeStatSort.getSpendsString\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(124809,user.getLanguage())+"\" />"+
	"</head>"+
	"</table>";
%>

		<!-- start -->
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
			<FORM id=frmMain name=frmMain action=SpendTimeStat.jsp method=post>
			<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_FLOWREPORT_SPENDTIMESTAT %>"/>
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="typeId"
								browserValue='<%="" + typeId%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								_callback="changeFlowType"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue='<%=workTypeComInfo.getWorkTypename(typeId)%>'>
							</brow:browser>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(259, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="flowId"
								browserValue='<%="" + flowId%>'
								getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
								isSingle="true" hasBrowser="true" isMustInput="1"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=workflowComInfo.getWorkflowname(flowId)%>'>
							</brow:browser>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
						<wea:item>
							<select style="width: 80px" class=InputStyle name="flowStatus">
								<option value=""><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
								<option value="1" <%if("1".equals(flowStatus)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%></option>
								<option value="2" <%if("2".equals(flowStatus)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
							</select>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(124810, user.getLanguage())%></wea:item>
						<wea:item>
							<select style="width: 80px;float: left;" class=InputStyle id="objType" name=objType onchange="onChangeType();">
								<option value="1" <%if (objType1==1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())%></option>
								<option value="2" <%if (objType1==2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></option>
								<option value="3" <%if (objType1==3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></option>
							</select>
	
							<brow:browser width="200px" viewType="0" name="rhobjId" browserValue='<%="" + rhobjId%>' 
							    getBrowserUrlFn="getObjWindowUrl"
							    completeUrl="javascript:getAjaxUrl();"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput="1"
								browserSpanValue='<%=rhobjNames%>'></brow:browser>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="doccreatedateselect" selectValue="">
								<input class=wuiDateSel type="hidden" name="fromcredate" value="<%=fromcredate%>">
								<input class=wuiDateSel type="hidden" name="tocredate" value="<%=tocredate%>">
							</span>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></wea:item>
						<wea:item>
							<select class=inputstyle name="nodetype" style="width: 80px;">
								<option value=""><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
								<option value="0" <%if (nodeType.equals("0")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
								<option value="1" <%if (nodeType.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
								<option value="2" <%if (nodeType.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
								<option value="3" <%if (nodeType.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
							</select>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(19079,user.getLanguage())%></wea:item>
						<wea:item attributes="{colspan:3}">
							<select class=inputstyle name="timeType1" style="width: 80px;">
								<option value="1" <%if (timeType1 == 1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
								<option value="2" <%if (timeType1 == 2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
								<option value="3" <%if (timeType1 == 3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
								<option value="4" <%if (timeType1 == 4) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
								<option value="5" <%if (timeType1 == 5) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
								<option value="6" <%if (timeType1 == 6) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
							</select>
							<input class=inputstyle name="time1" value='<%=timeV1 > 0 ? timeV1:""%>' size=8 style="width: 110px;" onchange="checkint('time1');" />
							<select class=inputstyle name="timeUnit1" style="width: 80px;">
								<option value="1" <%if (timeUnit1 == 1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
								<option value="2" <%if (timeUnit1 == 2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(32751,user.getLanguage())%></option>
								<option value="3" <%if (timeUnit1 == 3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
							</select>
							<select class=inputstyle name="timeType2" style="width: 80px;">
								<option value="1" <%if (timeType2 == 1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
								<option value="2" <%if (timeType2 == 2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
								<option value="3" <%if (timeType2 == 3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
								<option value="4" <%if (timeType2 == 4) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
								<option value="5" <%if (timeType2 == 5) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
								<option value="6" <%if (timeType2 == 6) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
							</select>
							<input class=inputstyle name="time2" value='<%=timeV2 > 0 ? timeV2:""%>' size=8 style="width: 110px;" onchange="checkint('time2');" />
							<select class=inputstyle name="timeUnit2" style="width: 80px;">
								<option value="1" <%if (timeUnit2 == 1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
								<option value="2" <%if (timeUnit2 == 2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(32751,user.getLanguage())%></option>
								<option value="3" <%if (timeUnit2 == 3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>
					
					<wea:group context='<%=SystemEnv.getHtmlLabelName(33518, user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<input type="hidden" name="search" value="search" />
							<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	
						</wea:item>
					</wea:group>
					</wea:layout>
	
			</FORM>
		</div>

		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<jsp:include page="/workflow/flowReport/IncludeExcelBody.jsp">
			<jsp:param name="exportProcess" value="spendTime"></jsp:param>
			<jsp:param name="exportSQL" value="<%=xssUtil.put(exportSQL)%>"></jsp:param>
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
		_writeBackData('rhobjId', 1, {id:'',name:''});
	}

	function submitData() {
		document.frmMain.submit();
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
</script>
</html>
