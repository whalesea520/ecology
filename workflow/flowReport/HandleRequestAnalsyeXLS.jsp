
<%@ page language="java"
	contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.util.*,java.math.*"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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

TABLE.ListStyle TR.User {
	COLOR: #FFFFFF;
	BACKGROUND-COLOR: #538DD5;
	FONT-WEIGHT: BOLD;
}

TABLE.ListStyle TR.Flowtype {
	FONT-WEIGHT: BOLD;
}

TABLE.ListStyle TR.Flow {
	COLOR: #538DD5;
}
-->
</style>
	</head>

	<BODY>
		<%
			response.setContentType("application/vnd.ms-excel");
			User user = HrmUserVarify.getUser(request, response);
			String titlename = SystemEnv.getHtmlLabelName(19030, user
					.getLanguage());
			response.setHeader("Content-disposition",
					"attachment;filename="+new String(titlename.getBytes("gbk"),"iso8859-1")+".xls");
			String imagefilename = "/images/hdReport_wev8.gif";
			
			String needfav = "1";
			String needhelp = "";
			String userRights = ReportAuthorization.getUserRights("-4", user);//得到用户查看范围
			if (userRights.equals("-100")) {
				response.sendRedirect("/notice/noright.jsp");
				return;
			}
		%>
		<%
			OverTime.removeBrowserCache();
			String typeid = "";
			//String typecount="";
			String typename = "";
			String workflowid = "";
			String workflowcount = "";
			String workflowname = "";
			ArrayList temp = new ArrayList();
			ArrayList wftypes = new ArrayList();
			ArrayList workflows = new ArrayList();
			ArrayList workflowcounts = new ArrayList(); //总计
			ArrayList nodeTypes = new ArrayList(); //节点类型
			ArrayList userIds = new ArrayList();
			ArrayList wftypess = new ArrayList();
			ArrayList wfUsers = new ArrayList();
			ArrayList flowUsers = new ArrayList();

			//得到各个节点的平均时间


			ArrayList workFlowNodes = new ArrayList();
			ArrayList workFlowUserIds = new ArrayList();
			ArrayList workFlowNodeCounts = new ArrayList();
			ArrayList nodeIds = new ArrayList();
			ArrayList tempNodeIds = new ArrayList();
			ArrayList tempCounts = new ArrayList();
			//系统平耗时

			ArrayList tempCountsx = new ArrayList();
			ArrayList tempSum = new ArrayList();
			ArrayList nodeNames = new ArrayList();
			ArrayList nodeNametemps = new ArrayList();
			ArrayList nodeUserIds = new ArrayList();

			int totalcount = 0;
			String typeId = Util.null2String(request.getParameter("typeId"));//得到搜索条件
			String flowId = Util.null2String(request.getParameter("flowId"));//得到搜索条件
			String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
			String objIds = Util.null2String(request.getParameter("objId"));//得到搜索条件
			if(null == objIds || "".equals(objIds)){
			    objIds = (String)session.getAttribute("objIds");
			}
			if(objIds.equals(""))objIds="-1";
			String fromcredate = Util.null2String(request
					.getParameter("fromcredate"));//得到创建时间搜索条件
			String tocredate = Util.null2String(request
					.getParameter("tocredate"));//得到创建时间搜索条件
			String fromadridate = Util.null2String(request
					.getParameter("fromadridate"));//得到到达搜索条件
			String toadridate = Util.null2String(request
					.getParameter("toadridate"));//得到到达搜索条件
			String objStatueType = Util.null2String(request
					.getParameter("objStatueType"));//得到流程状态搜索条件


			String showObj = "none";

			String subsqlstr = "";

			String tempsql = "";
			String tempsql1 = "";
			int objType1 = Util.getIntValue(request.getParameter("objType"), 0);
			String objNames = Util
					.null2String(request.getParameter("objNames"));
			String sqlCondition = " and 1=1";
			int pagenum = 1;
			int perpage = 10;
			Map<String, String> wfVersionMap = new HashMap<String, String>();
			boolean hasNextPage = false;
			int RecordSetCounts = 0;
			if (objType1 != 0) {
				switch (objType1) {
				case 1:
					//tempsql="select id from hrmresource where  id in ("+objIds+") ";
					sqlCondition = " and ("+Util.getSubINClause(objIds,"userid","in")+")";
					break;
				case 2:
					//tempsql=" select id from hrmresource where departmentid in ("+objIds+") ";
					sqlCondition = " and userid in  (select id from hrmresource where  departmentid in ("
							+ objIds + ") )";
					break;
				case 3:
					//tempsql=" select id from hrmresource where  subcompanyid1 in ("+objIds+") ";
					sqlCondition = " and userid in (select id from hrmresource where  subcompanyid1 in ("
							+ objIds + ") )";
					break;
				}

				if (userRights.equals("")) {
					sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
				} else {
					sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("
							+ userRights
							+ ") and hrmresource.status in (0,1,2,3))";
				}

				if (!typeId.equals("") && !typeId.equals("0")) {
					sqlCondition += " and workflow_currentoperator.workflowtype="
							+ typeId;
					subsqlstr += " and workflow_currentoperator.workflowtype ="
							+ typeId;
				}
				if (!versionsIds.equals("")) {
					sqlCondition += " and workflow_currentoperator.workflowid in ( "
							+ versionsIds + " )";
					subsqlstr += " and workflow_currentoperator.workflowid in ( "
						+ versionsIds + " )";
				}

				if (!"".equals(fromcredate)) {
					sqlCondition += " and workflow_requestbase.createdate >='"
							+ fromcredate + "'";
					subsqlstr += " and workflow_requestbase.createdate >='"
							+ fromcredate + "'";
				}
				if (!"".equals(tocredate)) {
					sqlCondition += " and workflow_requestbase.createdate <='"
							+ tocredate + "'";
					subsqlstr += " and workflow_requestbase.createdate <='"
							+ tocredate + "'";
				}
				if (!"".equals(fromadridate)) {
					sqlCondition += " and workflow_currentoperator.receivedate >='"
							+ fromadridate + "'";
					subsqlstr += " and workflow_currentoperator.receivedate >='"
							+ fromadridate + "'";
				}
				if (!"".equals(toadridate)) {
					sqlCondition += " and workflow_currentoperator.receivedate <='"
							+ toadridate + "'";
					subsqlstr += " and workflow_currentoperator.receivedate <='"
							+ toadridate + "'";
				}
				if (!"".equals(objStatueType)) {
					if ("1".equals(objStatueType)) {
						sqlCondition += " and workflow_requestbase.currentnodetype ='3'";
						subsqlstr += " and workflow_requestbase.currentnodetype ='3'";
					} else {
						sqlCondition += " and workflow_requestbase.currentnodetype <>'3'";
						subsqlstr += " and workflow_requestbase.currentnodetype <>'3'";
					}
				}
				if (RecordSet.getDBType().equals("oracle")
						|| RecordSet.getDBType().equals("db2")) {

					String sql = "select workflow_currentoperator.userid,workflow_currentoperator.workflowtype,workflow_currentoperator.workflowid,  "
							+ " count(distinct workflow_requestbase.requestid) workflowcount from "
							+ " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "
							+ " and (workflow_requestbase.status is not null ) and workflow_currentoperator.workflowtype>1  "
							+ sqlCondition
							+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and workflowid=workflow_currentoperator.workflowid and nodetype<>3) group by "
							+ " workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "
							+ " order by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";

					RecordSet.executeSql(sql);
				} else {
					String sql = "select workflow_currentoperator.userid,workflow_currentoperator.workflowtype,workflow_currentoperator.workflowid,  "
							+ " count(distinct workflow_requestbase.requestid) workflowcount from "
							+ " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "
							+ " and (workflow_requestbase.status is not null and workflow_requestbase.status!='') and workflow_currentoperator.workflowtype>1 and preisremark='0' and isremark<>'4' "
							+ sqlCondition
							+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and workflowid=workflow_currentoperator.workflowid and nodetype<>3) group by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "
							+ " order by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
					RecordSet.executeSql(sql);
				}
				while (RecordSet.next()) {
					String theworkflowid = Util.null2String(RecordSet
							.getString("workflowid"));
					String theworkflowtype = Util.null2String(RecordSet
							.getString("workflowtype"));
					String userid = Util.null2String(RecordSet
							.getString("userid"));
					int theworkflowcount = Util.getIntValue(RecordSet
							.getString("workflowcount"), 0);
					rs.executeSql("select version from workflow_base where id="+theworkflowid);
					String versionid = "0";
					if(rs.next()){
						versionid = Util.getIntValue(rs.getString("version"), 1) + "";
					}
					wfVersionMap.put(theworkflowid,versionid);
					if (WorkflowAllComInfo.getIsValid(theworkflowid).equals("1") || WorkflowAllComInfo.getIsValid(theworkflowid).equals("3")) {					    
			            int wfindex = workflows.indexOf(userid+","+theworkflowid) ;
			            if(wfindex != -1) {                
				     		String count[] = workflowcounts.get(wfindex).toString().split(",");
			                int wfCount  = Util.getIntValue(count[2]) + theworkflowcount;	                
			                workflowcounts.set(wfindex, userid+","+theworkflowid+","+wfCount);
			            }else{
			                workflows.add(userid+","+theworkflowid);
			                workflowcounts.add(userid+","+theworkflowid+","+theworkflowcount) ;	
			            } 
			            
			            flowUsers.add(""+userid);
			            int userIndex=userIds.indexOf(userid);
			            int tempIndex=temp.indexOf(userid+"$"+theworkflowtype);
			            if (userIndex!=-1)
			            {
				            if(tempIndex == -1){            	
				                temp.add(userid+"$"+theworkflowtype); 
				        		wftypes.add(theworkflowtype) ;
				        		wfUsers.add(userid);
				        	}
			            }else{
			           		userIds.add(""+userid);
			           		temp.add(userid+"$"+theworkflowtype);
			           		wftypes.add(theworkflowtype) ;
			           		wfUsers.add(userid);          
			          	}
					}
				}
				if (RecordSet.getDBType().equals("oracle")
						|| RecordSet.getDBType().equals("db2")) {

					String sql = "select workflow_currentoperator.userid,workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid),"
							+ "24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"
							+ "-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "
							+ " from workflow_currentoperator,workflow_requestbase "
							+ " where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null  "
							+ "  ) and workflowtype>1 and workflow_currentoperator.isremark <> '0' and isremark<>'4' and preisremark='0' "
							+ sqlCondition
							+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  "
							+ " workflowid=workflow_currentoperator.workflowid and nodetype<>3) "
							+ "group by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "
							+ "order by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid ";
					RecordSet.execute(sql);

				} else {

					RecordSet.executeProc("PersonNodeTime_Get", sqlCondition);
				}
				while (RecordSet.next()) {
					String userId = Util.null2String(RecordSet
							.getString("userid"));
					String workFlowId = Util.null2String(RecordSet
							.getString("workflowid"));
					String nodeId = Util.null2String(RecordSet
							.getString("nodeid"));
					String nodeName = Util.null2String(RecordSet.getString(4));
					float avgNode = Util.getFloatValue(RecordSet.getString(5),
							0);
					int flowIndex = workFlowUserIds.indexOf(userId + "$"
							+ workFlowId);
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
						workFlowUserIds.add(userId + "$" + workFlowId);
						tempNodeIds.add(nodeId);
						nodeIds.add(tempNodeIds);
						tempCounts.add("" + avgNode);
						workFlowNodeCounts.add(tempCounts);
						nodeNametemps.add(nodeName);
						nodeNames.add(nodeNametemps);
					}

				}
				//系统平均耗时   (是否考虑在其他页面操作，点击时才出现???,by ben 太耗性能了！:（  )
				if (RecordSet.getDBType().equals("oracle")
						|| RecordSet.getDBType().equals("db2")) {
				    //RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where trim(operatedate)='' ");
				    RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where operatedate='' ");
					String sql = " select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "
							+ "24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"
							+ "-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "
							+ " from workflow_currentoperator,workflow_requestbase "
							+ " where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null ) "
							+ "	and workflowtype>1 and workflow_currentoperator.isremark <> '0' and isremark<>'4' and preisremark='0' "
							+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and "
							+ " workflowid=workflow_currentoperator.workflowid and nodetype<>3) "
							+ " group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "
							+ " order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid ";
					RecordSet.execute(sql);
				} else {
				    //RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where rtrim(ltrim(operatedate))='' ");
				    RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where operatedate='' ");
					RecordSet.executeProc("WorkFlowSysNodeTime_Get",
							sqlCondition);
				}
				while (RecordSet.next()) {

					workFlowNodes.add(""
							+ Util.null2String(RecordSet.getString("nodeid")));
					tempCountsx.add(""
							+ Util.getFloatValue(RecordSet.getString(4), 0));

				}

			}
		%>

		<TABLE class=ListStyle cellspacing=1 border="1">
			<!--详细内容在此-->
			<COLGROUP />
			<col align=left width="70%">
			<col align=right width="15%">
			<col align=right width="15%">
			<TR class=Header>
				<TD><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(259, user.getLanguage())%></TD>
				<!--平均耗时-->
				<TD><%=SystemEnv.getHtmlLabelName(19059, user.getLanguage())%></TD>
				<!--系统耗时-->
				<TD><%=SystemEnv.getHtmlLabelName(124844, user.getLanguage())%></TD>
			</TR>
		</TABLE>
		<TABLE class=ListStyle cellspacing=1 border="1">
			<COLGROUP />
			<col align=left width="70%">
			<col align=right width="15%">
			<col align=right width="15%">
			<%
				if (objType1 != 0) {
					boolean isLight = false;
					boolean isLight1 = false;
					boolean isLight2 = false;
					for (int i = 0; i < userIds.size(); i++) {
						isLight = !isLight;
						String objId = (String) userIds.get(i);
			%>
			<TR class=User>
				<TD><%=resourceComInfo.getLastname(objId)%></TD>
				<TD></TD>
				<TD></TD>
			</TR>
			<%
				for (int j = 0; j < wftypes.size(); j++) {
					isLight2 = !isLight2;
					String tempObjId = "" + wfUsers.get(j);
					String wfId = "" + wftypes.get(j);
					if (!tempObjId.equals(objId))
						continue;
			%>
			<TR class=Flowtype>
				<TD>&nbsp;&nbsp;&nbsp;<%=WorkTypeComInfo.getWorkTypename(wfId)%></TD>
				<TD></TD>
				<TD></TD>
			</TR>
			<%
				for (int k = 0; k < workflows.size(); k++) {
					isLight1 = !isLight1;
					String[] wfInfo=((String)workflows.get(k)).split(",");
				    workflowid= wfInfo[1];
					String curtypeid = WorkflowAllComInfo.getWorkflowtype(workflowid);
					String tempUser=wfInfo[0];
					if (!curtypeid.equals(wfId) || !tempUser.equals(objId))
						continue;
					workflowname = WorkflowAllComInfo.getWorkflowname(workflowid);
					workflowname = Util.processBody(workflowname,user.getLanguage()+"");
					String versionId = Util.null2String(wfVersionMap.get(workflowid));
					 if (!versionId.equals("")) {
							workflowname += "(V" +  versionId + ")";
					 }
					int indexId = workFlowUserIds.indexOf(tempUser + "$" + workflowid);
					String[] wfcountInfo = ((String)workflowcounts.get(k)).split(",");
			%>
			<TR class=Flow>
				<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=workflowname%>（<%=wfcountInfo[2]%>）</TD>
				<TD></TD>
				<TD></TD>
			</TR>
			<%
				if (indexId != -1) {
					ArrayList nodeIda = (ArrayList) nodeIds.get(indexId);
					ArrayList nodeNamea = (ArrayList) nodeNames.get(indexId);
					ArrayList nodeCounta = (ArrayList) workFlowNodeCounts.get(indexId);
					for (int m = 0; m < nodeIda.size(); m++) {
					isLight1 = !isLight1;
						int indexIds = workFlowNodes.indexOf("" + nodeIda.get(m));
			%>
			<TR>
				<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=nodeNamea.get(m)%></TD>
				<TD><%=handleRequestAnalsyeSort.getSpendsString("" + nodeCounta.get(m))%></TD>
				<TD width="45"><%=handleRequestAnalsyeSort.getSpendsString("" + tempCountsx.get(indexIds))%></TD>
			</TR>
			<%
					}
				}
			%>
			<%
					workflows.remove(k);
					workflowcounts.remove(k);
					flowUsers.remove(k);
					k--;
				}
			%>
			<%
					wftypes.remove(j);
					wfUsers.remove(j);
					j--;
				}
			%>

			<%
				}
				}
			%>
		</TABLE>
		<!--详细内容结束-->
	</body>
</html>
