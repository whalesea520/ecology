
<%@ page language="java"
	contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.util.*,java.math.*"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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
	BORDER: #B2C9DB;
}

TABLE.ListStyle TR.Header {
	BACKGROUND-COLOR: #F8F8F8;
	HEIGHT: 30px;
	BORDER-Spacing: 1pt;
}

TABLE.ListStyle TR.Avg {
	BACKGROUND-COLOR: #ECFDEA;
	FONT-WEIGHT: BOLD;
}

TABLE.ListStyle TD,TABLE.ListStyle TH {
	BORDER: #B2C9DB;
}
-->
</style>
	</head>

	<BODY>
		<%
			String imagefilename = "/images/hdReport_wev8.gif";
			response.setContentType("application/vnd.ms-excel");
			User user = HrmUserVarify.getUser(request, response);
			String flowId = Util.null2String(request.getParameter("flowId"));//得到传入条件
			RecordSet.executeSql("select version from workflow_base where id="+flowId);
			String versionid = "1";
			if(RecordSet.next()){
				versionid = Util.getIntValue(RecordSet.getString("version"), 1) + "";
			}
			//String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
			String titlename = SystemEnv.getHtmlLabelName(124843, user.getLanguage()); 
			response.setHeader("Content-disposition",
					"attachment;filename="+new String(titlename.getBytes("gbk"),"iso8859-1")+".xls");
			
			String needfav = "1";
			String needhelp = "";
			String exportSQL = "";
		%>
		<%
			String requestIdd = "";
			String userRights = ReportAuthorization.getUserRights("-3", user);//得到用户查看范围
			session.setAttribute("flowReport_userRights", userRights);
			int totalcount = 0;
			String typeId = Util.null2String(request.getParameter("flowType"));//得到传入条件
			session.setAttribute("flowReport_flowId", flowId);
			String tempNodeCounts = Util.null2String(request
					.getParameter("nodeCounts"));//得到传入条件

			String subsqlstr = Util.null2String(request
					.getParameter("subsqlstr"));

			String tempNodeIdd = Util.null2String(request
					.getParameter("nodeIds"));//得到传入条件
			// out.print(tempNodeIdd);
			String sqlCondition = "";
			String objIds = Util.null2String(request.getParameter("objId"));
			String objNames = Util
					.null2String(request.getParameter("objNames"));
			String flowStatus = Util.null2String(request
					.getParameter("flowStatus"));

			if (!"".equals(subsqlstr))
				sqlCondition += subsqlstr;

			if (userRights.equals("")) {
				sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
			} else {
				sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("
						+ userRights + ") and hrmresource.status in (0,1,2,3))";
			}
			//sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+")  and hrmresource.status in (0,1,2,3) )";
			//if (!typeId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowtype="+typeId;
			if (!flowId.equals(""))
				sqlCondition += " and workflow_currentoperator.workflowid in ("+flowId + ")";
			if (flowStatus.equals("2"))
				sqlCondition += " and workflow_requestbase.currentnodetype<3 ";
			if (flowStatus.equals("1"))
				sqlCondition += " and workflow_requestbase.currentnodetype=3 ";
			if (!objIds.equals(""))
				sqlCondition += " and workflow_requestbase.requestid in ("
						+ objIds + ")  ";
			//得到各个节点的平均时间

			//得到节点名称
			String tempNodeIddstr = tempNodeIdd + "-1";
			ArrayList nodeNamehead = new ArrayList();
			RecordSet
					.execute("select nodename from workflow_nodebase where id in ("
							+ tempNodeIddstr + ") order by id ");
			while (RecordSet.next()) {
				nodeNamehead.add(RecordSet.getString(1));
			}
			exportSQL = tempNodeIdd + "[nodeids]" + tempNodeCounts
					+ "[nodecounts]" + typeId + "[typeid]" + flowId
					+ "[flowid]" + sqlCondition;
			ArrayList requestIds = new ArrayList();
			ArrayList workFlowNodeCounts = new ArrayList();
			ArrayList nodeIds = new ArrayList();
			ArrayList tempNodeIds = new ArrayList();
			ArrayList tempCounts = new ArrayList();
			ArrayList nodeNames = new ArrayList();
			ArrayList nodeNametemps = new ArrayList();
			ArrayList requestNames = new ArrayList();
			if (RecordSet.getDBType().equals("oracle")
					|| RecordSet.getDBType().equals("db2")) {
				String sqls = "select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where "
						+ " requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "
						+ "24*avg(case when isremark=0 then to_date(NVL2(workflow_currentoperator.operatedate,workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS')"
						+ " when isremark=2 and workflow_currentoperator.operatedate is not null "
						+ " then to_date(workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,'YYYY-MM-DD HH24:MI:SS') end "
						+ " -to_date(workflow_currentoperator.receivedate||' '||workflow_currentoperator.receivetime,'YYYY-MM-DD HH24:MI:SS')) "
						+ " from workflow_currentoperator,workflow_requestbase,workflow_requestLog "
						+ " where workflow_requestbase.requestid=workflow_currentoperator.requestid "
						+ " and workflow_requestbase.requestid=workflow_requestLog.requestid "
						+ " and workflow_requestLog.operatedate is not null "
						+ " and workflow_requestbase.status is not null "
						+ " and workflowtype>1  and isremark<>4 and preisremark='0' "
						+ sqlCondition
						+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and   "
						+ " workflowid=workflow_currentoperator.workflowid and nodetype<>3) "
						+ " group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid"
						+ " order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid";
				RecordSet.execute(sqls);
				//out.print(sqls);
			} else {
				RecordSet.executeProc("WorkFlowTypeNodeTime_Get", sqlCondition);
			}

			while (RecordSet.next()) {
				String requestId = Util.null2String(RecordSet
						.getString("requestid"));
				String nodeId = Util.null2String(RecordSet.getString("nodeid"));
				String nodeName = Util.null2String(RecordSet.getString(4));
				String requestName = Util.null2String(RecordSet.getString(3));
				float avgNode = Util.getFloatValue(RecordSet.getString(5), 0);

				int flowIndex = requestIds.indexOf(requestId);
				if (flowIndex != -1) {
					tempNodeIds.add(nodeId);
					tempCounts.add("" + avgNode);
					workFlowNodeCounts.set(flowIndex, tempCounts);
					nodeIds.set(flowIndex, tempNodeIds);
					nodeNametemps.add(nodeName);
					nodeNames.set(flowIndex, nodeNametemps);
				} else {
					tempNodeIds = new ArrayList();
					tempNodeIds = new ArrayList();
					tempCounts = new ArrayList();
					nodeNametemps = new ArrayList();
					requestIds.add("" + requestId);
					requestNames.add("" + requestName);
					tempNodeIds.add(nodeId);
					nodeIds.add(tempNodeIds);
					tempCounts.add("" + avgNode);
					workFlowNodeCounts.add(tempCounts);
					nodeNametemps.add(nodeName);
					nodeNames.add(nodeNametemps);
				}

			}
			//out.print(sqlCondition);
		%>


		<%
			ArrayList nodeCounts = Util.TokenizerString(tempNodeCounts, ",");
			ArrayList nodeTemps = Util.TokenizerString(tempNodeIdd, ",");
		%>
		<TABLE class=ListStyle cellspacing=1 border="1" style="BORDER-BOTTOM: #B7E0FE 2;">
			<!--详细内容在此-->
			<TR class=Header align=left>
				<TD rowspan="2" width="500"><%=SystemEnv.getHtmlLabelName(19060, user.getLanguage())%></TD>
				<!-- 具体流程-->
				<TD colspan="<%=nodeCounts.size()%>" align=center><%=SystemEnv.getHtmlLabelName(33357, user.getLanguage())%></TD>
				<!--节点-->
			</TR>
			<TR class=Header align=left>
				<%
					for (int m = 0; m < nodeCounts.size(); m++) {
				%>
				<TD width="170">
					<span><%=nodeNamehead.get(m)%></span>
				</TD>
				<%
					}
				%>
			</TR>
		</TABLE>
		<TABLE class=ListStyle cellspacing=1 border="1">
			<tr class="Avg">
				<td align=right width="500"><%=SystemEnv.getHtmlLabelName(19059, user.getLanguage())%></td>
				<%
					for (int j = 0; j < nodeCounts.size(); j++) {
						int overTimesb = Util.getIntValue(OverTime.getOverHour(""
								+ nodeTemps.get(j)), 0)
								+ Util.getIntValue(OverTime.getOverTime(""
										+ nodeTemps.get(j)), 0);
						float overTimes = Util.getFloatValue(OverTime.getOverHour(""
								+ nodeTemps.get(j)), 0)
								+ Util.getFloatValue(OverTime.getOverTime(""
										+ nodeTemps.get(j)), 0) / 24;
						boolean overT = false;

						if ((Util.getFloatValue("" + nodeCounts.get(j), 0) > overTimes)
								&& overTimesb != 0)
							overT = !overT;
				%>
				<TD>
					<%
						if (overT) {
					%><span style="color:#B040C6;">
						<%
							}
						%><%=flowTypeTimeAnalyseSort.getSpendsString("" + nodeCounts.get(j))%>
						<%
							if (overT) {
						%></span>
					<%
						}
					%>
				</TD>
				<%
					}
				%>
			</tr>
			<%
				for (int i = 0; i < requestIds.size(); i++) {
					requestIdd = (String) requestIds.get(i);
			%>
			<tr>
				<td width="500"><%=requestNames.get(i)%></td>
				<%
					ArrayList nodeIda = (ArrayList) nodeIds.get(i);
						ArrayList nodeNamea = (ArrayList) nodeNames.get(i);
						ArrayList nodeCounta = (ArrayList) workFlowNodeCounts.get(i);

						for (int tempnodeIndex = 0; tempnodeIndex < nodeTemps.size(); tempnodeIndex++) {
							String tempnode = (String) nodeTemps.get(tempnodeIndex);
							//String temmrequestnode=(String)nodeIda.get(k);
							int k = nodeIda.indexOf(tempnode);

							if (k != -1)
							// }

							//for (int k=0;k<nodeIda.size();k++)
							{
								int overTimesb = Util.getIntValue(OverTime
										.getOverHour("" + nodeIda.get(k)), 0)
										+ Util.getIntValue(OverTime.getOverTime(""
												+ nodeIda.get(k)), 0);
								float overTimes = Util.getFloatValue(OverTime
										.getOverHour("" + nodeIda.get(k)), 0)
										+ Util.getFloatValue(OverTime.getOverTime(""
												+ nodeIda.get(k)), 0) / 24;
								boolean overT = false;

								if ((Util.getFloatValue("" + nodeCounta.get(k), 0) > overTimes)
										&& overTimesb != 0)
									overT = !overT;
				%>
				<td width="170">
					<%
						if (overT) {
					%><span style="color:#B040C6;">
						<%
							}
						%><%=flowTypeTimeAnalyseSort.getSpendsString("" + nodeCounta.get(k))%>
						<%
							if (overT) {
						%></span>
					<%
						}
					%>
				</td>
				<%
					} else {
				%>
				<td width="170"></td>
				<%
					}
						}
				%>
			</tr>
			<%
				}
			%>
		</TABLE>
		<!--详细内容结束-->
	</body>
</html>
