
<%@ page language="java"
	contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.util.*,java.math.*"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="shareRights"
	class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="WorkTypeComInfo"
	class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowAllComInfo"
	class="weaver.workflow.workflow.WorkflowAllComInfo" scope="page" />
<jsp:useBean id="resourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="OverTime"
	class="weaver.workflow.report.OverTimeComInfo" scope="page" />
<jsp:useBean id="handleRequestAnalsyeSort"
	class="weaver.workflow.report.HandleRequestAnalsyeSort" scope="page" />
	<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<HTML>
	<HEAD>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
			response.setContentType("application/vnd.ms-excel");
	User user = HrmUserVarify.getUser(request, response);
	String flowId = Util.null2String(request.getParameter("flowId"));//得到传入条件
	RecordSet.executeSql("select version from workflow_base where id="+flowId);
	String versionid = "1";
	if(RecordSet.next()){
		versionid = Util.getIntValue(RecordSet.getString("version"), 1) + "";
	}
	//String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
	String userId = Util.null2String(request.getParameter("userId"));//得到传入条件
	String titlename = resourceComInfo.getLastname(userId) + "_" + WorkflowAllComInfo.getWorkflowname(flowId) +"(V"+versionid+")"+ " " + SystemEnv.getHtmlLabelName(129046, user.getLanguage());
			response.setHeader("Content-disposition",
					"attachment;filename="+new String(titlename.getBytes("gbk"),"iso8859-1")+".xls");
			
			if (user == null)
				return;
			String imagefilename = "/images/hdReport_wev8.gif";
			
			String needfav = "1";
			String needhelp = "";
			String userRights = ReportAuthorization.getUserRights("-3", user);//得到用户查看范围
			if (userRights.equals("-100")) {
				response.sendRedirect("/notice/noright.jsp");
				return;
			}
		%>
		<%
			String requestIdd = "";

			session.setAttribute("flowReport_userRights", userRights);
			int totalcount = 0;
			session.setAttribute("flowReport_flowId", flowId);
			String tempNodeCounts = Util.null2String(request
					.getParameter("tempCount"));//得到传入条件
			String tempNodeId = Util.null2String(request
					.getParameter("tempNodeId"));//得到传入条件
			String tempNodeName = Util.null2String(request
					.getParameter("tempNodeName"));//得到传入条件
					tempNodeName=URLDecoder.decode(tempNodeName);
					
			if(!tempNodeId.equals(",")&&!tempNodeId.equals("")){
				    	tempNodeName = "";
				    	if(tempNodeId.lastIndexOf(",")==tempNodeId.length()-1){
				    		tempNodeId = tempNodeId.substring(0,tempNodeId.length()-1);
				    	}
				    	RecordSet.executeSql("select nodename from workflow_nodebase where id in ("+tempNodeId+") order by id asc ");
				     	while(RecordSet.next()){
				     		tempNodeName += RecordSet.getString("nodename")+",";
				     	}
				    }
			String sqlCondition = "";
			String objIds = Util.null2String(request.getParameter("objId"));
			String objNames = Util
					.null2String(request.getParameter("objNames"));

			String subsqlstr = Util.null2String(request
					.getParameter("subsqlstr"));

			String flowStatus=Util.null2String(request.getParameter("flowStatus"));
			sqlCondition = " and workflow_currentoperator.userid=" + userId;
			//if (!typeId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowtype="+typeId;
			if (!flowId.equals(""))
				sqlCondition += " and workflow_currentoperator.workflowid in ( "
						+ flowId + " )";
			if (flowStatus.equals("2")) sqlCondition+=" and workflow_requestbase.currentnodetype<3 ";
			if (flowStatus.equals("1")) sqlCondition+=" and workflow_requestbase.currentnodetype=3 ";
			if (!objIds.equals(""))
				sqlCondition += " and workflow_requestbase.requestid in ("
						+ objIds + ")  ";
			//得到各个节点的平均时间


			if (!"".equals(subsqlstr)) {
				sqlCondition += subsqlstr;
			}

			ArrayList requestIds = new ArrayList();
			ArrayList workFlowNodeCounts = new ArrayList();
			ArrayList nodeIds = new ArrayList();
			ArrayList tempNodeIds = new ArrayList();
			ArrayList tempCounts = new ArrayList();
			//ArrayList nodeNames=new ArrayList();
			ArrayList nodeNametemps = new ArrayList();
			ArrayList requestNames = new ArrayList();
			if (RecordSet.getDBType().equals("oracle")
					|| RecordSet.getDBType().equals("db2")) {


				String sql = " select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where "
						+ " requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "
						+ "24*avg(case when isremark='0' then to_date(NVL2(workflow_currentoperator.operatedate,workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS')"
						+ " when isremark='2' and workflow_currentoperator.operatedate is not null "
						+ " then to_date(workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,'YYYY-MM-DD HH24:MI:SS') end "
						+ " -to_date(workflow_currentoperator.receivedate||' '||workflow_currentoperator.receivetime,'YYYY-MM-DD HH24:MI:SS')) "
						+ " from workflow_currentoperator,workflow_requestbase,workflow_requestLog "
						+ " where workflow_requestbase.requestid=workflow_currentoperator.requestid "
						+ " and workflow_requestbase.requestid=workflow_requestLog.requestid "
						+ " and workflow_requestLog.operatedate is not null "
						+ " and workflow_requestbase.status is not null "
						+ " and workflowtype>1 and workflow_currentoperator.isremark <> '0' and isremark<>'4' and preisremark='0' "
						+ sqlCondition
						+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid "
						+ " and  nodetype<3) "
						+ " group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid "
						+ " order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid ";
				RecordSet.execute(sql);
			} else {
				RecordSet.executeProc("WorkFlowTypeNodeTime_Get", sqlCondition);
			}
			while (RecordSet.next()) {
				String requestId = Util.null2String(RecordSet
						.getString("requestid"));
				String nodeId = Util.null2String(RecordSet.getString("nodeid"));
				String nodeName = Util.null2String(RecordSet.getString(4));
				String requestName = Util.null2String(RecordSet.getString(3));
	            float avgNode = Util.getFloatValue(RecordSet.getString(5), -1);

				int flowIndex = requestIds.indexOf(requestId);
				if (flowIndex != -1) {
					tempNodeIds.add(nodeId);
					tempCounts.add("" + avgNode);
					workFlowNodeCounts.set(flowIndex, tempCounts);
					nodeIds.set(flowIndex, tempNodeIds);
					//nodeNametemps.add(nodeName);
					//nodeNames.set(flowIndex,nodeNametemps);
				} else {
					tempNodeIds = new ArrayList();
					tempNodeIds = new ArrayList();
					tempCounts = new ArrayList();
					//nodeNametemps=new ArrayList();
					requestIds.add("" + requestId);
					requestNames.add("" + requestName);
					tempNodeIds.add(nodeId);
					nodeIds.add(tempNodeIds);
					tempCounts.add("" + avgNode);
					workFlowNodeCounts.add(tempCounts);
					//nodeNametemps.add(nodeName);
					//nodeNames.add(nodeNametemps);
				}

			}
			//out.print(sqlCondition);
		%>

		<%
			ArrayList nodeCounts = Util.TokenizerString(tempNodeCounts, ",");
			ArrayList nodeNames = Util.TokenizerString(tempNodeName, ",");
			ArrayList nodeIdss = Util.TokenizerString(tempNodeId, ",");
		%>
		<TABLE class=ListStyle cellspacing=1 border="1" style="BORDER-BOTTOM: #B7E0FE 2;">
			<!--详细内容在此-->
			<TR class=Header align=left>
				<!-- 具体流程-->
				<TD rowspan="2" width="500"><%=SystemEnv.getHtmlLabelName(19060, user.getLanguage())%></TD>
				<!-- 具体流程-->
				<TD colspan="<%=nodeNames.size()%>" align=center><%=SystemEnv.getHtmlLabelName(33357, user.getLanguage())%></TD>
				<!--节点-->
			</TR>
			<TR class=Header align=left>
				<%
					for (int m = 0; m < nodeNames.size(); m++) {
				%>
				<TD width="170">
				<%=nodeNames.get(m)%>
				</TD>
				<%
					}
				%>
			</TR>
		</table>
		<TABLE class=ListStyle cellspacing=1 border="1">
			<%
				if ("".equals(objIds)) {
			%>
			<tr class=Avg>
				<td align=right width="500"><%=SystemEnv.getHtmlLabelName(19059, user
										.getLanguage())%></td>
				<%
					for (int j = 0; j < nodeCounts.size(); j++) {

							int overTimesb = Util.getIntValue(OverTime.getOverHour(""
									+ nodeIdss.get(j)), 0)
									+ Util.getIntValue(OverTime.getOverTime(""
											+ nodeIdss.get(j)), 0);
							float overTimes = Util.getFloatValue(OverTime
									.getOverHour("" + nodeIdss.get(j)), 0)
									+ Util.getFloatValue(OverTime.getOverTime(""
											+ nodeIdss.get(j)), 0) / 24;
							boolean overT = false;

							if ((Util.getFloatValue("" + nodeCounts.get(j), 0) > overTimes)
									&& overTimesb != 0)
								overT = !overT;
				%>
				<TD>
					<%
						if (overT) {
					%><font color="red">
						<%
							}
						%><%=handleRequestAnalsyeSort.getSpendsString("" + nodeCounts.get(j))%>
						<%
							if (overT) {
						%>(<%=SystemEnv.getHtmlLabelName(19081, user
										.getLanguage())%>)</font>
					<%
						}
					%>
				</TD>
				<%
					}
				%>
			</tr>
			<%
				}
			%>
			<%
				for (int i = 0; i < requestIds.size(); i++) {
					requestIdd = (String) requestIds.get(i);
			%>
			<tr>
				<td width="500"><%=requestNames.get(i)%></td>
				<%
					ArrayList nodeIda = (ArrayList) nodeIds.get(i);
						ArrayList nodeCounta = (ArrayList) workFlowNodeCounts.get(i);
						for (int k = 0; k < nodeIdss.size(); k++) {
							int tempIdIndex = nodeIda.indexOf("" + nodeIdss.get(k));
				%>
				<td>
					<%
						if (tempIdIndex != -1) {
									int overTimesb = Util.getIntValue(OverTime
											.getOverHour("" + nodeIdss.get(k)), 0)
											+ Util.getIntValue(OverTime.getOverTime(""
													+ nodeIdss.get(k)), 0);
									float overTimes = Util.getFloatValue(OverTime
											.getOverHour("" + nodeIdss.get(k)), 0)
											+ Util.getFloatValue(OverTime.getOverTime(""
													+ nodeIdss.get(k)), 0) / 24;
									boolean overT = false;

									if ((Util.getFloatValue(""
											+ nodeCounta.get(tempIdIndex), 0) > overTimes)
											&& overTimesb != 0)
										overT = !overT;
					%>
					<%
						if (overT) {
					%><font color="red">
						<%
							}
						%><%=handleRequestAnalsyeSort.getSpendsString("" + nodeCounta.get(tempIdIndex))%>
						<%
							if (overT) {
						%>(<%=SystemEnv.getHtmlLabelName(19081, user
											.getLanguage())%>)</font>
					<%
						}
					%>
					<%
						}
					%>&nbsp;
				</td>
				<%
					}
				%>
			</tr>
			<%
				}
			%>
			<!--详细内容结束-->
	</body>
</html>