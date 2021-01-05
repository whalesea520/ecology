
<%@ page language="java" contentType="text/html; charset=UTF-8"%><%@ page import="weaver.general.Util,java.util.*,java.math.*"%><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page" /><jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" /><jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" /><jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /><jsp:useBean id="OverTime" class="weaver.workflow.report.OverTimeComInfo" scope="page"/>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response);
String workflowid1 = "";
String workflowname1 = "";

//获取Session中的数据
ArrayList wftypes1 = (ArrayList)session.getAttribute("wftypes_1");
ArrayList workflows1 = (ArrayList)session.getAttribute("workflows_1");
ArrayList workflowcounts1 = (ArrayList)session.getAttribute("workflowcounts_1"); //总计
ArrayList wfUsers1 = (ArrayList)session.getAttribute("wfUsers_1"); 
ArrayList flowUsers1 = (ArrayList)session.getAttribute("flowUsers_1"); 

//得到各个节点的平均时间
ArrayList workFlowNodes1 = (ArrayList)session.getAttribute("workFlowNodes_1"); 
ArrayList workFlowUserIds1 = (ArrayList)session.getAttribute("workFlowUserIds_1"); 
ArrayList workFlowNodeCounts1 = (ArrayList)session.getAttribute("workFlowNodeCounts_1"); 
ArrayList nodeIds1 = (ArrayList)session.getAttribute("nodeIds_1"); 

//系统平耗时
ArrayList tempCountsx1 = (ArrayList)session.getAttribute("tempCountsx_1"); 
ArrayList nodeNames1 = (ArrayList)session.getAttribute("nodeNames_1"); 

String subsqlstr = Util.null2String(request.getParameter("subsqlstr"));

String objId = Util.null2String(request.getParameter("objId"));
%>
<table class=ListStyle cellspacing=1>
<tr>
<td valign="top" width="90"><a href="/hrm/resource/HrmResource.jsp?id=<%=objId%>" target="_new"><%=resourceComInfo.getLastname(objId)%></a></td>
<td colspan="3">
<table class=ListStyle cellspacing=0>
<%
boolean isLight1 = false ;
boolean isLight2 = false ;
for(int j=0;j<wftypes1.size();j++){
	 isLight2 = !isLight2 ; 
	 String tempObjId=""+wfUsers1.get(j);
	 String wfId=""+wftypes1.get(j);
	 if (!tempObjId.equals(objId)) continue;
%>
	<tr>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	<tr class='<%=( isLight2 ? "datalight" : "datadark" )%>'>
		<td valign="top" width="240">
			<%=WorkTypeComInfo.getWorkTypename(wfId)%>
		</td>
		<td colspan="2">
			<table class=ListStyle cellspacing=1>
				<%
				     for(int k=0;k<workflows1.size();k++){
					     isLight1 = !isLight1 ;
					     workflowid1=(String)workflows1.get(k);
					     String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid1);
						 String tempUser=""+flowUsers1.get(k);
						 if(!curtypeid.equals(wfId)||!tempUser.equals(objId))	continue;		
					     workflowname1=WorkflowComInfo.getWorkflowname(workflowid1); 
					     String tempNodeCounts=""; 
					     String tempNodeIdSend="";
					     String tempNodeNameSend="";
					     int indexId=workFlowUserIds1.indexOf(tempUser+"$"+workflowid1);
					     if (indexId!=-1){
						      ArrayList nodeIda=(ArrayList)nodeIds1.get(indexId);
							  ArrayList nodeCounta=(ArrayList)workFlowNodeCounts1.get(indexId);
							  ArrayList nodeNameas=(ArrayList)nodeNames1.get(indexId);
							  for (int l=0;l<nodeIda.size();l++)
							  {
								  tempNodeCounts+=nodeCounta.get(l)+",";
								  tempNodeIdSend+=nodeIda.get(l)+",";
								  tempNodeNameSend+=nodeNameas.get(l)+",";
							  }
					     }
				%>
				<tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
					<td width="150">
						<a
							href="HandleTypeTimeAnalyse.jsp?tempNodeId=<%=tempNodeIdSend%>&tempNodeName=<%=tempNodeNameSend%>&tempCount=<%=tempNodeCounts%>&flowId=<%=workflowid1%>&userId=<%=objId%>&subsqlstr=<%=subsqlstr%>"><%=workflowname1%>
						</a>(
						<%=workflowcounts1.get(k)%>
						)
					</td>
					<td width="500">
						<table class=ListStyle cellspacing=0>
							<tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
								<%
									 if (indexId!=-1)
									 {
									 ArrayList nodeIda=(ArrayList)nodeIds1.get(indexId);
									 ArrayList nodeNamea=(ArrayList)nodeNames1.get(indexId);
									 for (int m=0;m<nodeIda.size();m++)
									 {
								%>
								<td width="170">
									<%=nodeNamea.get(m)%>
								</td>
								<%
								}
								%>
								<%
								}
								%>
							</tr>
						</table>
					</td>
				</tr>
				<%
				isLight1=!isLight1;
				%>
				<tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
					<td width="150">
						<%=SystemEnv.getHtmlLabelName(19059, user.getLanguage())%>
					</td>
					<td width="500">
						<table class=ListStyle cellspacing=1>
							<tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
								<%
								 if (indexId!=-1)
								 {
								 ArrayList nodeIda=(ArrayList)nodeIds1.get(indexId);
								 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts1.get(indexId);
								 for (int l=0;l<nodeIda.size();l++)
								 { int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(l)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(l)),0);
								  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(l)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(l)),0)/24;
								  boolean  overT=false;
								  
								  if ((Util.getFloatValue(""+nodeCounta.get(l),0)>overTimes)&&overTimesb!=0) overT=!overT;
								%>
								<td width="170">
									<%
									if (overT) {
									%>
									<font color="red">
										<%
										}
										%>
										<%=Util.round(""+nodeCounta.get(l),1)%>(<%=SystemEnv.getHtmlLabelName(391, user.getLanguage())%>)
										<%
										if (overT) {
										%>(<%=SystemEnv.getHtmlLabelName(19081, user.getLanguage())%>)</font>
									<%
									}
									%>
								</td>
								<%
								}
								%>

								<%
								}
								%>
							</tr>
						</table>
					</td>
				</tr>
				<%
				isLight1=!isLight1;
				%>
				<tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
					<td width="150">
						<%=SystemEnv.getHtmlLabelName(124814, user.getLanguage())%>
					</td>
					<td width="500">
						<table class=ListStyle cellspacing=1>
							<tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
								<%
								 if (indexId!=-1)
								 {
								 ArrayList nodeIda=(ArrayList)nodeIds1.get(indexId);
								 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts1.get(indexId);
								 for (int b=0;b<nodeIda.size();b++)
								 {int indexIds=workFlowNodes1.indexOf(""+nodeIda.get(b));
								 if (indexIds!=-1) {
								 
								  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(b)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(b)),0);
								  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(b)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(b)),0)/24;
								  boolean  overT=false;
								  
								  if ((Util.getFloatValue(""+tempCountsx1.get(indexIds),0)>overTimes)&&overTimesb!=0) overT=!overT;
								%>
								<td width="170">
									<%
									if (overT) {
									%>
									<font color="red">
										<%
										}
										%>
										<%=Util.round(""+tempCountsx1.get(indexIds),1)%>(<%=SystemEnv.getHtmlLabelName(391, user.getLanguage())%>)
										<%
										if (overT) {
										%>(<%=SystemEnv.getHtmlLabelName(19081, user.getLanguage())%>)</font>
									<%
									}
									%>
								</td>
								<%
									 }
									 }
								%>

								<%
								}
								%>
							</tr>
						</table>
					</td>
				</tr>
				<%
				 workflows1.remove(k);
				 workflowcounts1.remove(k);
				 flowUsers1.remove(k);
				 k--;
				 }
				%>

			</table>
		</td>
	</tr>
	<%
		  wftypes1.remove(j);
		  wfUsers1.remove(j);
		  j--;
		 }
	%>
</table>
 </td>
 </tr>
 <TR class=Line><TD colspan="4" ></TD></TR>
 </TABLE>
