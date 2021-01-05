BK
<%@ page language="java"
	contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.util.*,java.math.*"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="shareRights"
	class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="WorkTypeComInfo"
	class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowAllComInfo"
	class="weaver.workflow.workflow.WorkflowAllComInfo" scope="page" />
<jsp:useBean id="OverTime"
	class="weaver.workflow.report.OverTimeComInfo" scope="page" />
	<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="flowTypeTimeAnalyseSort" class="weaver.workflow.report.FlowTypeTimeAnalyseSort" scope="page" />
<HTML>
	<HEAD>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<style>
<!--
TABLE.ListStyle {
	width: "100%";
	BACKGROUND-COLOR: #FFFFFF;
	BORDER-Spacing: 1pt;
}

TABLE.ListStyle TR.Header {
	COLOR: #FFFFFF;
	BACKGROUND-COLOR: #808080;
	HEIGHT: 40px;
	FONT-WEIGHT: BOLD;
}

TABLE.ListStyle TR.Flow {
	COLOR: #FFFFFF;
	BACKGROUND-COLOR: #538DD5;
	FONT-WEIGHT: BOLD;
}
-->
</style>
	</head>

	<BODY>
		<%
			response.setContentType("application/vnd.ms-excel");
			User user = HrmUserVarify.getUser(request, response);
			String imagefilename = "/images/hdReport_wev8.gif";
			String titlename = SystemEnv.getHtmlLabelName(19029, user
			.getLanguage());
			response.setHeader("Content-disposition",
					"attachment;filename="+new String(titlename.getBytes("gbk"),"iso8859-1")+".xls");
			String needfav = "1";
			String needhelp = "";
			String exportSQL = "";
			String userRights = ReportAuthorization.getUserRights("-3", user);//得到用户查看范围
		    if ("-100".equals(userRights)) {
			    response.sendRedirect("/notice/noright.jsp");
				return;
		    }
		%>
		<%
			String typeid = "";
			String typecount = "";
			String typename = "";
			String workflowid = "";
			String workflowcount = "";
			String newremarkwfcount0 = "";
			String newremarkwfcount1 = "";
			String workflowname = "";

			ArrayList wftypes = new ArrayList();
			ArrayList wftypecounts = new ArrayList();
			ArrayList workflows = new ArrayList();
			ArrayList workflowcounts = new ArrayList(); //总计
			ArrayList workflowcountst = new ArrayList(); //总计流程类型
			ArrayList nodeTypes = new ArrayList(); //节点类型
			ArrayList newremarkwfcounts0 = new ArrayList();
			ArrayList wftypecounts0 = new ArrayList();

			ArrayList wftypess = new ArrayList();
			Map<String, String> wfVersionMap = new HashMap<String, String>();
			int totalcount = 0;
			String typeId = Util.null2String(request.getParameter("typeId"));//得到搜索条件
			String flowId = Util.null2String(request.getParameter("flowId"));//得到搜索条件
			String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
			String crefromdate = Util.null2String(request
					.getParameter("crefromdate"));//得到搜索条件
			String cretodate = Util.null2String(request
					.getParameter("cretodate"));//得到搜索条件
			String guifromdate = Util.null2String(request
					.getParameter("guifromdate"));//得到搜索条件
			String guitodate = Util.null2String(request
					.getParameter("guitodate"));//得到搜索条件
			String sqlCondition = "";
			String sqlCondition_t = "";

			String operationtemp = Util.null2String(request
					.getParameter("operation"));
			if ("".equals(operationtemp))
				sqlCondition += " and 1=2";

			if (userRights.equals("")) {
				sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
				sqlCondition_t = " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
			} else {
				sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("
						+ userRights + ") and hrmresource.status in (0,1,2,3))";
				sqlCondition_t = " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("
						+ userRights + ") and hrmresource.status in (0,1,2,3))";
			}

			if (!typeId.equals("")) {
				sqlCondition += " and workflow_currentoperator.workflowtype="
						+ typeId;
				sqlCondition_t += " and workflow_currentoperator.workflowtype="
						+ typeId;
			}
			if (!versionsIds.equals("")){
		    	sqlCondition += " and workflow_currentoperator.workflowid in ("+versionsIds + ")";
		    	sqlCondition_t += " and workflow_currentoperator.workflowid in ("+versionsIds + ")";
			}
			String subsqlstr = "";

			//创建时间
			if (!"".equals(crefromdate)) {
				sqlCondition += " and workflow_requestbase.createdate >='"
						+ crefromdate + "'";
				subsqlstr += " and workflow_requestbase.createdate >='"
						+ crefromdate + "'";
			}
			if (!"".equals(cretodate)) {
				sqlCondition += " and workflow_requestbase.createdate <='"
						+ cretodate + "'";
				subsqlstr += " and workflow_requestbase.createdate <='"
						+ cretodate + "'";
			}

			//归档时间
			if (!guifromdate.equals("") || !guitodate.equals("")) {
				sqlCondition += " and workflow_requestbase.currentnodetype='3'";
				subsqlstr += " and workflow_requestbase.currentnodetype='3'";
			}
			if (!"".equals(guifromdate)) {
				sqlCondition += " and workflow_requestbase.lastoperatedate >='"
						+ guifromdate + "'";
				subsqlstr += " and workflow_requestbase.lastoperatedate >='"
						+ guifromdate + "'";
			}
			if (!"".equals(guitodate)) {
				sqlCondition += " and workflow_requestbase.lastoperatedate <='"
						+ guitodate + "'";
				subsqlstr += " and workflow_requestbase.lastoperatedate <='"
						+ guitodate + "'";
			}
			exportSQL = sqlCondition;
			String sql = "select workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,  "
					+ " count(distinct workflow_requestbase.requestid) workflowcount from "
					+ " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "
					+ " and (workflow_requestbase.status is not null and workflow_requestbase.status != ' ') and workflow_currentoperator.workflowtype>1  and preisremark='0' and isremark<> '4' "
					+ sqlCondition
					+ " group by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "
					+ " order by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
			//out.print(sql);
			RecordSet.executeSql(sql);
			//System.out.println("==============================sql:" + sql);
			while (RecordSet.next()) {
				String theworkflowid = Util.null2String(RecordSet.getString("workflowid"));
				String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype"));				
				int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"), 0);
				rs.executeSql("select version from workflow_base where id="+theworkflowid);
					String versionid = "0";
					if(rs.next()){
						versionid = Util.getIntValue(rs.getString("version"), 1) + "";
					}
					wfVersionMap.put(theworkflowid,versionid);
					if (WorkflowAllComInfo.getIsValid(theworkflowid).equals("1") || WorkflowAllComInfo.getIsValid(theworkflowid).equals("3")) {
					int wfindex = workflows.indexOf(theworkflowid);
					if (wfindex != -1) {
						workflowcounts.set(wfindex, ""
								+ (Util.getIntValue((String) workflowcounts
										.get(wfindex), 0) + theworkflowcount));
					} else {
						workflows.add(theworkflowid);
						workflowcounts.add("" + theworkflowcount);
					}

					int wftindex = wftypes.indexOf(theworkflowtype);
					if (wftindex != -1) {
						wftypecounts.set(wftindex, ""
								+ (Util.getIntValue((String) wftypecounts
										.get(wftindex), 0) + theworkflowcount));
					} else {
						wftypes.add(theworkflowtype);
						wftypecounts.add("" + theworkflowcount);
					}

				}
			}

			//得到各个节点的平均时间

			ArrayList workFlowIds = new ArrayList();
			ArrayList workFlowNodeCounts = new ArrayList();
			ArrayList nodeIds = new ArrayList();
			ArrayList tempNodeIds = new ArrayList();
			ArrayList tempCounts = new ArrayList();
			ArrayList nodeNames = new ArrayList();
			ArrayList nodeNametemps = new ArrayList();
			if (RecordSet.getDBType().equals("oracle")
					|| RecordSet.getDBType().equals("db2")) {

			    //RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where trim(operatedate)='' "+sqlCondition_t);
			    RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where operatedate='' "+sqlCondition_t);

				String sqls = "select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,"
						+ "(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "
                        + "24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"
						+ "-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "
						+ "from workflow_currentoperator,workflow_requestbase  where workflow_requestbase.requestid=workflow_currentoperator.requestid "
						+ "and (workflow_requestbase.status is not null) and workflowtype>1 and isremark<> '4' and preisremark='0' "
						+ sqlCondition
						+ "and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  "
						+ "workflowid=workflow_currentoperator.workflowid and nodetype<>3) "
						+ "group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "
						+ "order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid";
				RecordSet.execute(sqls);

			} else {
				//RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where rtrim(ltrim(operatedate))='' "+sqlCondition_t);
				RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where operatedate='' "+sqlCondition_t);
				RecordSet.executeProc("WorkFlowNodeTime_Get", sqlCondition);
			}
			int maxnode=0;
			Set usedWfIds = new HashSet<String>();  //获取使用到的wfid
			while (RecordSet.next()) {
		   		String workFlowId = Util.null2String(RecordSet.getString("workflowid"));
				String nodeId = Util.null2String(RecordSet.getString("nodeid"));
				String nodeName = Util.null2String(RecordSet.getString(3));
				float avgNode = Util.getFloatValue(RecordSet.getString(4), 0);
				if(!workFlowId.equals("")){
				    usedWfIds.add(workFlowId);
				}
				//Map<String,String>nodeInfo = WorkflowVersion.getActiveWFNodeInfo(workFlowId,nodeId,nodeName);
				//nodeId = nodeInfo.get("id");
				//nodeName = nodeInfo.get("name");
				//workFlowId = WorkflowVersion.getActiveVersionWFID(workFlowId);		
				int flowIndex = workFlowIds.indexOf(workFlowId);
				if (flowIndex != -1) {
				    int nodeIndex = tempNodeIds.indexOf(nodeId);
				    if(nodeIndex != -1){
				        Float nodeExist  = Float.parseFloat(tempCounts.get(nodeIndex).toString());
				        avgNode = avgNode + nodeExist;
				        tempCounts.set(nodeIndex, avgNode);
				    }else{
				        tempCounts.add("" + avgNode);		//节点平均时间
						tempNodeIds.add(nodeId);				//节点Id
						nodeIds.set(flowIndex, tempNodeIds);   
						nodeNametemps.add(nodeName);
						nodeNames.set(flowIndex, nodeNametemps);
				    }			
					workFlowNodeCounts.set(flowIndex, tempCounts); 
				} else {
					tempNodeIds = new ArrayList();
					tempNodeIds = new ArrayList();
					tempCounts = new ArrayList();
					nodeNametemps = new ArrayList();
					workFlowIds.add("" + workFlowId);
					tempNodeIds.add(nodeId);
					nodeIds.add(tempNodeIds);
					tempCounts.add("" + avgNode);
					workFlowNodeCounts.add(tempCounts);
					nodeNametemps.add(nodeName);
					nodeNames.add(nodeNametemps);
				}
				if(maxnode<tempNodeIds.size())
					maxnode=tempNodeIds.size();

			}
		   for(int i=0; i< workFlowIds.size(); i++){
		       ArrayList times = (ArrayList)workFlowNodeCounts.get(i);
		       float wfCount = usedWfIds.size();
		       for(int j=0; j<times.size(); j++){           
		           times.set(j,Float.parseFloat(times.get(j).toString()) / wfCount);
		       }
		       workFlowNodeCounts.set(i,times);
		       //System.out.println("================workFlowId=" + workFlowIds.get(i)+", nodeName="+nodeNames.get(i) +", avgtime="+ workFlowNodeCounts.get(i)+ ", wfcount=" + wfCount);
		   }
		%>
		<!--查询条件-->

		<TABLE class=ListStyle cellspacing=1 border="1">
			<!--详细内容在此-->
			<COLGROUP/>
				<col align=left width="50%">
				<col align=right width="50%">
			<TR class=Header>
				<!-- 流程类型－工作流（流程数量）－节点-->
				<TD style="text-align:left;"><%=SystemEnv.getHtmlLabelNames("259,124842", user.getLanguage())%></TD>
				<TD style="text-align:right;"><%=SystemEnv.getHtmlLabelName(19059, user.getLanguage())%></TD>
				<!--节点-->
			</TR>
		</TABLE>
		<TABLE class=ListStyle cellspacing=1 border="1"> 
			<COLGROUP/>
				<col align=left width="50%">
				<col align=right width="50%">
				<%
					for (int i = 0; i < wftypes.size(); i++) {
						typeid = (String) wftypes.get(i);
						typecount = (String) wftypecounts.get(i);
						typename = WorkTypeComInfo.getWorkTypename(typeid);
				%>
				<%
					for (int j = 0; j < workflows.size(); j++) {
							workflowid = (String) workflows.get(j);
							String curtypeid = WorkflowAllComInfo.getWorkflowtype(workflowid);
							if (!curtypeid.equals(typeid)) continue;
							workflowname = WorkflowAllComInfo.getWorkflowname(workflowid);
							String versionId = Util.null2String(wfVersionMap.get(workflowid));
							 if (!versionId.equals("")) {
									workflowname += "(V" +  versionId + ")";
							 }
							int indexId = workFlowIds.indexOf(workflowid);
				%>
				<TR class=Flow>
					<TD><%=workflowname%>（<%=workflowcounts.get(j)%>）</TD>
					<TD></TD>
				</TR>
				<%
					if (indexId != -1) {
						ArrayList nodeIda = (ArrayList) nodeIds.get(indexId);
						ArrayList nodeNamea = (ArrayList) nodeNames.get(indexId);
						ArrayList nodeCounta = (ArrayList) workFlowNodeCounts.get(indexId);
						for (int k = 0; k < nodeIda.size(); k++) {
				%>
				<TR>
					<TD>&nbsp;&nbsp;&nbsp;&nbsp;<%=nodeNamea.get(k)%></TD>
					<%
						int overTimesb = Util.getIntValue(OverTime
								.getOverHour("" + nodeIda.get(k)), 0)
								+ Util.getIntValue(OverTime.getOverTime(""
										+ nodeIda.get(k)), 0);
						float overTimes = Util.getFloatValue(OverTime
								.getOverHour("" + nodeIda.get(k)), 0)
								+ Util.getFloatValue(OverTime
										.getOverTime("" + nodeIda.get(k)),
										0) / 24;
						boolean overT = false;
	
						if ((Util.getFloatValue("" + nodeCounta.get(k), 0) > overTimes) && overTimesb != 0)
							overT = !overT;
					%>
					<TD>
						<%if (overT) {%>
							<span style="color:#B040C6;">
						<%}%>
						<%=flowTypeTimeAnalyseSort.getSpendsString("" + nodeCounta.get(k))%>
						<%if (overT) {%></span><%}%>
					</TD>
				</TR>
				<%
							}
							}
							workflows.remove(j);
							workflowcounts.remove(j);
							j--;
						}
					}
				%>
		</TABLE>
		<!--详细内容结束-->

	</body>
</html>
