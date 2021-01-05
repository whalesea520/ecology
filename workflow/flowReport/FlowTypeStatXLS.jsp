
<%@ page language="java"
	contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.util.*,java.math.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo"
	class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo"
	class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="shareRights"
	class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<HTML>
	<HEAD>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Pragma" content="no-cache">
		<style>
<!--
TABLE.ListStyle {
	width: "100%";
	BACKGROUND-COLOR: #FFFFFF;
	BORDER-Spacing: 1pt;
}

TABLE.ListStyle TR.Header {
	COLOR: #003366;
	BACKGROUND-COLOR: #C8C8C8;
	HEIGHT: 40px;
	BORDER-Spacing: 1pt
}

TABLE.ListStyle TR.DataLight {
	BACKGROUND-COLOR: #FFFFFF;
	HEIGHT: 22px;
	BORDER-Spacing: 1pt
}

TABLE.ListStyle TR.DataLight TD {
	PADDING-RIGHT: 0pt;
	PADDING-LEFT: 0pt;
	LINE: 100%
}
-->
</style>
	</head>

	<BODY>
		<%
		User user = HrmUserVarify.getUser(request, response);
		String imagefilename = "/images/hdReport_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(19027, user
				.getLanguage());
			response.setContentType("application/vnd.ms-excell;charset=UTF-8");
			response.setHeader("Content-disposition",
					"attachment;filename="+new String(titlename.getBytes("gbk"),"iso8859-1")+".xls");
			
			String needfav = "1";
			String needhelp = "";
			String userRights = ReportAuthorization.getUserRights("-1", user);//得到用户查看范围
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
			ArrayList newremarkwfcounts0 = new ArrayList(); //草稿总数
			ArrayList newremarkwfcounts1 = new ArrayList(); //待批准

			ArrayList newremarkwfcounts2 = new ArrayList(); //待提交

			ArrayList newremarkwfcounts3 = new ArrayList(); //归档
			ArrayList wftypecounts0 = new ArrayList(); //草稿总数总计
			ArrayList wftypecounts1 = new ArrayList(); //待批准总计
			ArrayList wftypecounts2 = new ArrayList(); //待提交总计
			ArrayList wftypecounts3 = new ArrayList(); //归档总计
			ArrayList wftypess = new ArrayList();
			int totalcount = 0;
			String sqlCondition = "";
			String fromdate = Util
					.null2String(request.getParameter("fromdate"));
			String todate = Util.null2String(request.getParameter("todate"));
			String fromdateOver = Util.null2String(request
					.getParameter("fromdateOver"));
			String todateOver = Util.null2String(request
					.getParameter("todateOver"));
			String search = Util.null2String(request.getParameter("search"));

			//创建日期 
			if (userRights.equals("")) {
				sqlCondition = " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
			} else {
				sqlCondition = " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("
						+ userRights + ") and hrmresource.status in (0,1,2,3))";
			}
			if (!"search".equals(search)) {
				sqlCondition += " and 1=2";
			}
			if (!fromdate.equals("")) {
				sqlCondition += " and workflow_requestbase.createdate>='"
						+ fromdate + "'";
			}
			if (!todate.equals("")) {
				sqlCondition += " and workflow_requestbase.createdate<='"
						+ todate + "'";
			}
			//归档日期
			if (!todateOver.equals("") || !todateOver.equals("")) {
				sqlCondition += " and workflow_requestbase.currentnodetype='3' ";
			}
			if (!fromdateOver.equals("")) {
				sqlCondition += " and workflow_requestbase.lastoperatedate>='"
						+ fromdateOver + "'";
			}

			if (!todateOver.equals("")) {
				sqlCondition += " and workflow_requestbase.lastoperatedate<='"
						+ todateOver + "'";
			}
			String sql = "select workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,  currentnodetype,"
					+ " count(distinct workflow_requestbase.requestid) workflowcount from "
					+ " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "
					+ " and workflow_currentoperator.workflowtype>1  "
					+ sqlCondition
					+ " group by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,currentnodetype "
					+ " order by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
			//out.print(sql);
			RecordSet.executeSql(sql);

			while (RecordSet.next()) {
				String theworkflowid = Util.null2String(RecordSet.getString("workflowid"));
				String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype"));
				int nodetype = Util.getIntValue(RecordSet.getString("currentnodetype"), 0);
				int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"), 0);
				theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
				if (WorkflowComInfo.getIsValid(theworkflowid).equals("1")) {
					int wfindex = workflows.indexOf(theworkflowid);
					if (wfindex != -1) {
						workflowcounts.set(wfindex, ""+(Util.getIntValue((String) workflowcounts.get(wfindex), 0) + theworkflowcount));
						if (nodetype == 0) {
							newremarkwfcounts0.set(wfindex, ""+(Util.getIntValue((String) newremarkwfcounts0.get(wfindex),0) + theworkflowcount));
						}
						if (nodetype == 1) {
							newremarkwfcounts1.set(wfindex,""+ (Util.getIntValue((String) newremarkwfcounts1.get(wfindex),0) + theworkflowcount));
						}
						if (nodetype == 2) {
							newremarkwfcounts2.set(wfindex,""+ (Util.getIntValue((String) newremarkwfcounts2.get(wfindex),0) + theworkflowcount));
						}
						if (nodetype == 3) {
							newremarkwfcounts3.set(wfindex,""+ (Util.getIntValue((String) newremarkwfcounts3.get(wfindex),0) + theworkflowcount));
						}
					} else {
						workflows.add(theworkflowid);
						workflowcounts.add("" + theworkflowcount);
						if (nodetype == 0) {
							newremarkwfcounts0.add("" + theworkflowcount);
							newremarkwfcounts1.add("" + 0);
							newremarkwfcounts2.add("" + 0);
							newremarkwfcounts3.add("" + 0);
						} else if (nodetype == 1) {
							newremarkwfcounts0.add("" + 0);
							newremarkwfcounts1.add("" + theworkflowcount);
							newremarkwfcounts2.add("" + 0);
							newremarkwfcounts3.add("" + 0);
						} else if (nodetype == 2) {
							newremarkwfcounts0.add("" + 0);
							newremarkwfcounts1.add("" + 0);
							newremarkwfcounts2.add("" + theworkflowcount);
							newremarkwfcounts3.add("" + 0);
						} else if (nodetype == 3) {
							newremarkwfcounts0.add("" + 0);
							newremarkwfcounts1.add("" + 0);
							newremarkwfcounts2.add("" + 0);
							newremarkwfcounts3.add("" + theworkflowcount);

						}

					}

					int wftindex = wftypes.indexOf(theworkflowtype);
					if (wftindex != -1) {
						if (wfindex != -1) {
							//wftypess.set(wftindex,""+(Util.getIntValue((String)wftypess.get(wftindex),0)+1));
						} else {
							wftypess.set(wftindex, ""+ (Util.getIntValue((String) wftypess.get(wftindex), 0) + 1));
							//wftypess.add(""+1);
						}
						wftypecounts.set(wftindex, ""+ (Util.getIntValue((String) wftypecounts.get(wftindex), 0) + theworkflowcount));
						if (nodetype == 0) {
							wftypecounts0.set(wftindex,""+ (Util.getIntValue((String) wftypecounts0.get(wftindex),0) + theworkflowcount));
						} else if (nodetype == 1) {
							wftypecounts1.set(wftindex,""+ (Util.getIntValue((String) wftypecounts1.get(wftindex),0) + theworkflowcount));
						} else if (nodetype == 2) {
							wftypecounts2.set(wftindex,""+ (Util.getIntValue((String) wftypecounts2.get(wftindex),0) + theworkflowcount));
						} else if (nodetype == 3) {
							wftypecounts3.set(wftindex,""+ (Util.getIntValue((String) wftypecounts3.get(wftindex),0) + theworkflowcount));
						}

					} else {
						wftypess.add("" + 1);
						wftypes.add(theworkflowtype);
						wftypecounts.add("" + theworkflowcount);
						if (nodetype == 0) {
							wftypecounts0.add("" + theworkflowcount);
							wftypecounts1.add("" + 0);
							wftypecounts2.add("" + 0);
							wftypecounts3.add("" + 0);
						} else if (nodetype == 1) {
							wftypecounts0.add("" + 0);
							wftypecounts1.add("" + theworkflowcount);
							wftypecounts2.add("" + 0);
							wftypecounts3.add("" + 0);
						} else if (nodetype == 2) {
							wftypecounts0.add("" + 0);
							wftypecounts1.add("" + 0);
							wftypecounts2.add("" + theworkflowcount);
							wftypecounts3.add("" + 0);
						} else if (nodetype == 3) {
							wftypecounts0.add("" + 0);
							wftypecounts1.add("" + 0);
							wftypecounts2.add("" + 0);
							wftypecounts3.add("" + theworkflowcount);

						}
					}

					totalcount += theworkflowcount;
				}
			}
		%>

		<TABLE class=ListStyle cellspacing=1 border="1">
			<!--详细内容在此-->
			<COLGROUP />
				<col width="30%">
				<col width="9%">
				<col width="9%">
				<col width="9%">
				<col width="9%">
				<col width="9%">
				<col width="25%">
			<TR class=Header align=left style="color:#fff;background:#808080;">
				<TD><b><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(259, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331, user
									.getLanguage())%>)</b>
				</TD>
				<TD style="text-align: right;"><b><%=SystemEnv.getHtmlLabelName(83443, user.getLanguage())%></TD>
				<!--草稿-->
				<TD style="text-align: right;"><b><%=SystemEnv.getHtmlLabelName(19044, user.getLanguage())%></b></TD>
				<!--待批准-->
				<TD style="text-align: right;"><b><%=SystemEnv.getHtmlLabelName(19045, user.getLanguage())%></b></TD>
				<!--戴提交-->
				<TD style="text-align: right;"><b><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></b></TD>
				<!--归档-->
				<TD style="text-align: right;"><b><%=SystemEnv.getHtmlLabelName(523, user.getLanguage())%></b></TD>
				<!--总计-->
				<TD style="text-align: right;">
					<b><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></b>
				</TD>
				<!--%-->

			</TR>
		</table>
		<TABLE class=ListStyle cellspacing=1 border="1">

			<COLGROUP />
				<col width="30%">
				<col width="9%">
				<col width="9%">
				<col width="9%">
				<col width="9%">
				<col width="9%">
				<col width="25%">
			<%
				if (wftypes.size() > 0) {
			%><TR>
				<TD style="padding: 0px;" colspan="7">
					<span id="headSum"> <%
 	int sumNodes0 = 0;
 		int sumNodes1 = 0;
 		int sumNodes2 = 0;
 		int sumNodes3 = 0;
 		int sumNodess = 0;
 		for (int i = 0; i < wftypes.size(); i++) {
 			sumNodes0 += Util.getIntValue("" + wftypecounts0.get(i), 0);
 			sumNodes1 += Util.getIntValue("" + wftypecounts1.get(i), 0);
 			sumNodes2 += Util.getIntValue("" + wftypecounts2.get(i), 0);
 			sumNodes3 += Util.getIntValue("" + wftypecounts3.get(i), 0);
 			sumNodess += Util.getIntValue("" + wftypecounts.get(i), 0);
 		}
 %>
						<table class=ListStyle cellspacing=1 border="1">
							<tr style="background:#ebf1de;">
								<TD align=right width=30%>
									<%=SystemEnv.getHtmlLabelName(523, user.getLanguage())%>
								</TD>
								<TD width=9%><%=sumNodes0%></TD>
								<TD width=9%><%=sumNodes1%></TD>
								<TD width=9%><%=sumNodes2%></TD>
								<TD width=9%><%=sumNodes3%></TD>
								<TD width=9%><%=sumNodess%></TD>
								<TD width=25%></td>
							</tr>
						</table> 
				</span>
				</TD>
			</TR>
			<%
				}
			%>
			<%
				int sumNode0 = 0;
				int sumNode1 = 0;
				int sumNode2 = 0;
				int sumNode3 = 0;
				int sumNodes = 0;
				float percents = 0;
				String percentString = "";
				for (int i = 0; i < wftypes.size(); i++) {
					typeid = (String) wftypes.get(i);
					typecount = (String) wftypecounts.get(i);
					typename = WorkTypeComInfo.getWorkTypename(typeid);
			%>
			<tr style="background:#538dd5;color:#fff;">
				<TD>
					<b><%=Util.toScreen(typename, user.getLanguage())%>(<%=wftypess.get(i)%>)</b>
				</TD>
				<TD><%=wftypecounts0.get(i)%></TD>
				<TD><%=wftypecounts1.get(i)%></TD>
				<TD><%=wftypecounts2.get(i)%></TD>
				<TD><%=wftypecounts3.get(i)%></TD>
				<TD><%=wftypecounts.get(i)%></TD>
				<TD width="45" style= 'text-align: right;vnd.ms-excel.numberformat:@ '>
					<%
						if (Util.getIntValue("" + totalcount, 0) != 0) {

								percentString = ""
										+ ((Util.getFloatValue("" + wftypecounts.get(i), 0) / Util
												.getFloatValue("" + totalcount, 0)) * 100);

								percentString = Util.round(percentString, 2);
							}
					%>
					<%=percentString%>%
				</TD>
				<!--%-->
			</tr>
				<%
									for (int j = 0; j < workflows.size(); j++) {
											workflowid = (String) workflows.get(j);
											String curtypeid = WorkflowComInfo
													.getWorkflowtype(workflowid);
											if (!curtypeid.equals(typeid))
												continue;
											workflowname = WorkflowComInfo.getWorkflowname(workflowid);
											workflowname = Util.processBody(workflowname,user.getLanguage()+"");
								%>
							
							<tr>
								<TD>
									&nbsp;&nbsp;<%=workflowname%></TD>
								<TD><%=newremarkwfcounts0.get(j)%></TD>
								<TD><%=newremarkwfcounts1.get(j)%></TD>
								<TD><%=newremarkwfcounts2.get(j)%></TD>
								<TD><%=newremarkwfcounts3.get(j)%></TD>
								<TD><%=workflowcounts.get(j)%></TD>
								<TD width="45" style= 'text-align: right;vnd.ms-excel.numberformat:@ '>
									<%
										percentString = "0";
												if (Util.getIntValue("" + wftypecounts.get(i), 0) != 0) {

													percentString = ""
															+ ((Util.getFloatValue(""
																	+ workflowcounts.get(j), 0) / Util
																	.getFloatValue(
																			"" + wftypecounts.get(i), 0)) * 100);
													percentString = Util.round(percentString, 2);
												}
									%>
									<%=percentString%>%
								</TD>
								<!--%-->
							</tr>
							<%
								workflows.remove(j);
										workflowcounts.remove(j);
										newremarkwfcounts0.remove(j);
										newremarkwfcounts1.remove(j);
										newremarkwfcounts2.remove(j);
										newremarkwfcounts3.remove(j);
										j--;
									}
							%>
			<%
				sumNode0 += Util.getIntValue("" + wftypecounts0.get(i), 0);
					sumNode1 += Util.getIntValue("" + wftypecounts1.get(i), 0);
					sumNode2 += Util.getIntValue("" + wftypecounts2.get(i), 0);
					sumNode3 += Util.getIntValue("" + wftypecounts3.get(i), 0);
					sumNodes += Util.getIntValue("" + wftypecounts.get(i), 0);
				}
			%>
			<%
				if (wftypes.size() > 0) {
			%>
			<tr style="background:#ebf1de;">
				<TD align="right">
					<%=SystemEnv.getHtmlLabelName(523, user.getLanguage())%>
				</TD>
				<TD><%=sumNode0%></TD>
				<TD><%=sumNode1%></TD>
				<TD><%=sumNode2%></TD>
				<TD><%=sumNode3%></TD>
				<TD><%=sumNodes%></TD>
				<TD></td>
			</tr>
				<%
					}
				%>
		</TABLE>
		<!--详细内容结束-->

	</body>
</html>