
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>

<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowAllComInfo" class="weaver.workflow.workflow.WorkflowAllComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="OverTime" class="weaver.workflow.report.OverTimeComInfo" scope="page"/>
<jsp:useBean id="flowTypeTimeAnalyseSort" class="weaver.workflow.report.FlowTypeTimeAnalyseSort" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String flowId=Util.null2String(request.getParameter("flowId"));//得到传入条件
//String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId); 
RecordSet.executeSql("select version from workflow_base where id="+flowId);
	String versionid = "1";
	if(RecordSet.next()){
		versionid = Util.getIntValue(RecordSet.getString("version"), 1) + "";
	}
String titlename = WorkflowAllComInfo.getWorkflowname(flowId) +"(V"+versionid+")"+ " " + SystemEnv.getHtmlLabelName(19079, user.getLanguage())+ " " + SystemEnv.getHtmlLabelName(33292, user.getLanguage()); 
String needfav = "1" ;
String needhelp = "" ; 
String exportSQL="";
    String requestIdd="";
    String userRights=ReportAuthorization.getUserRights("-3",user);//得到用户查看范围
    session.setAttribute("flowReport_userRights",userRights);
    int totalcount=0;
    String typeId=Util.null2String(request.getParameter("flowType"));//得到传入条件
    session.setAttribute("flowReport_flowId",flowId);
    String tempNodeCounts=Util.null2String(request.getParameter("nodeCounts"));//得到传入条件
  
    String subsqlstr = Util.null2String(request.getParameter("subsqlstr"));
    
    String tempNodeIdd=Util.null2String(request.getParameter("nodeIds"));//得到传入条件
  // out.print(tempNodeIdd);
    String sqlCondition="";
    String objIds=Util.null2String(request.getParameter("objId"));
	String objNames="";
	if (!"".equals(objIds)) {
	    if (objIds.startsWith(",")) {
			objIds = objIds.replaceFirst(",", "");
		}
	    String[] objIdArr = objIds.split(",");
	    if (objIdArr.length == 1) {
			objNames = Util.toScreen(WorkflowRequestComInfo.getRequestName(objIdArr[0]), user.getLanguage());
		} else {
			StringBuilder sb = new StringBuilder();
			for(int i = 0; i < objIdArr.length; i++) {
				if(i > 0){
					sb.append(",");
				}
				sb.append(Util.toScreen(WorkflowRequestComInfo.getRequestName(objIdArr[i]), user.getLanguage()));
			}
			objNames = sb.toString();
		}
    }
	String flowStatus=Util.null2String(request.getParameter("flowStatus"));
	String requestParam="flowType="+typeId+"&flowId="+flowId+"&nodeCounts="+tempNodeCounts+"&subsqlstr="+subsqlstr+"&nodeIds="+tempNodeIdd+"&objId="+objIds+"&objNames="+objNames+"&flowStatus="+flowStatus;
	
	 if(!"".equals(subsqlstr)) sqlCondition += subsqlstr;
	
	 if (userRights.equals(""))
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
    //sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+")  and hrmresource.status in (0,1,2,3) )";
    //if (!typeId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowtype="+typeId;
    if (!flowId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowid in ("+flowId+") ";
    if (flowStatus.equals("1")) sqlCondition+=" and workflow_requestbase.currentnodetype=3 ";
    if (flowStatus.equals("2")) sqlCondition+=" and workflow_requestbase.currentnodetype<3 ";
    if (!objIds.equals(""))  sqlCondition+=" and workflow_requestbase.requestid in ("+objIds+")  " ;
	//得到各个节点的平均时间

	//得到节点名称
	String tempNodeIddstr=tempNodeIdd+"-1";
    ArrayList nodeNamehead=new ArrayList();
	RecordSet.execute("select nodename from workflow_nodebase where id in ("+tempNodeIddstr+") order by id ");
    while (RecordSet.next())
	{
	nodeNamehead.add(RecordSet.getString(1));
	}
    exportSQL=tempNodeIdd+"[nodeids]"+tempNodeCounts+"[nodecounts]"+typeId+"[typeid]"+flowId+"[flowid]"+sqlCondition;
    ArrayList requestIds=new ArrayList();
    ArrayList workFlowNodeCounts=new ArrayList();
    ArrayList nodeIds=new ArrayList();
    ArrayList tempNodeIds=new ArrayList();
    ArrayList tempCounts=new ArrayList();
    ArrayList nodeNames=new ArrayList();
    ArrayList nodeNametemps=new ArrayList();
    ArrayList requestNames=new ArrayList();
	 if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
   {  
String sqls="select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where "+ 
	" requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "+ 
"24*avg(case when isremark=0 then to_date(NVL2(workflow_currentoperator.operatedate,workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS')"+
" when isremark=2 and workflow_currentoperator.operatedate is not null "+
" then to_date(workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,'YYYY-MM-DD HH24:MI:SS') end "+
" -to_date(workflow_currentoperator.receivedate||' '||workflow_currentoperator.receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
" from workflow_currentoperator,workflow_requestbase,workflow_requestLog "+ 
" where workflow_requestbase.requestid=workflow_currentoperator.requestid " +
" and workflow_requestbase.requestid=workflow_requestLog.requestid " +
" and workflow_requestLog.operatedate is not null " +
" and workflow_requestbase.status is not null "+  
" and workflowtype>1  and isremark<>'4' and preisremark='0' "+sqlCondition+
" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and   "+
" workflowid=workflow_currentoperator.workflowid and nodetype<>3) "+  
" group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid"+ 
" order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid";
RecordSet.execute(sqls);
//out.print(sqls);
   }
   else
   { RecordSet.executeProc("WorkFlowTypeNodeTime_Get",sqlCondition);
   }

    while (RecordSet.next())
    { String requestId = Util.null2String(RecordSet.getString("requestid")) ;        
      String nodeId = Util.null2String(RecordSet.getString("nodeid")) ;
      String nodeName=Util.null2String(RecordSet.getString(4)) ;
      String requestName=Util.null2String(RecordSet.getString(3)) ;
      float avgNode = Util.getFloatValue(RecordSet.getString(5),0) ;
    
      int flowIndex=requestIds.indexOf(requestId);
      if (flowIndex!=-1)
      {
       tempNodeIds.add(nodeId);
       tempCounts.add(""+avgNode);
       workFlowNodeCounts.set(flowIndex,tempCounts);
       nodeIds.set(flowIndex,tempNodeIds);
       nodeNametemps.add(nodeName);
       nodeNames.set(flowIndex,nodeNametemps);
      }
      else
      {tempNodeIds=new ArrayList();
       tempNodeIds=new ArrayList();
       tempCounts=new ArrayList();
       nodeNametemps=new ArrayList();
       requestIds.add(""+requestId);
       requestNames.add(""+requestName);
       tempNodeIds.add(nodeId);
       nodeIds.add(tempNodeIds);
       tempCounts.add(""+avgNode);
       workFlowNodeCounts.add(tempCounts);
       nodeNametemps.add(nodeName);
       nodeNames.add(nodeNametemps);
      }      
    
    
    
    }
    ArrayList nodeCounts = Util.TokenizerString(tempNodeCounts,",");
    ArrayList nodeTemps = Util.TokenizerString(tempNodeIdd,",");
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<title><%=titlename%></title>
	</head>
	<style>
		TABLE.ListStyle TR.HeaderForXtalbe TH,TABLE.ListStyle TR TD {
			BORDER-RIGHT: #B2C9DB 1PX SOLID;
			BORDER-BOTTOM: #B2C9DB 1PX SOLID;
			white-space: nowrap;
		}
		TABLE.ListStyle TR.Avg TD {
			BACKGROUND-COLOR: #ECFDEA;
			FONT-WEIGHT: BOLD;
		}
		TABLE.ListStyle TR {
			vertical-align: middle;
		}
		TABLE.ListStyle TR TD {
			height: 30px;
			vertical-align: middle;
			word-break: keep-all;
			overflow: hidden;
			text-overflow: ellipsis;
		}
	</style>
	<BODY>

		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
					+ ",javascript:submitData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343, user.getLanguage())+",javascript:doExportExcel(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(82529, user.getLanguage())%>" onClick="submitData();" />
					<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>" onClick="doExportExcel();" />
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div>
			<FORM id=frmMain name=frmMain action=FlowTypeTimeAnalyse.jsp method=post>
	
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20550, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
						<wea:item>
							<span><%=WorkTypeComInfo.getWorkTypename(typeId)%></span>
						</wea:item>

						<!-- 工作流 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
						<wea:item>
							<span><%=WorkflowAllComInfo.getWorkflowname(flowId)%></span>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(19060, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="objId"
								browserValue='<%=objIds%>'
								getBrowserUrlFn="getRequestWindowUrl"
								hasInput="true"                       
								isSingle="false" hasBrowser="true" isMustInput="1"
								completeUrl="javascript:getWfUrl();"
								browserSpanValue='<%=objNames%>'></brow:browser>
						</wea:item>

						<!-- 流程状态 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
						<wea:item>
							<select style="width: 80px" class=InputStyle name=flowStatus>
								<option value=""><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
								<option value="1" <%if("1".equals(flowStatus)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1961, user.getLanguage())%></option>
								<option value="2" <%if("2".equals(flowStatus)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19062, user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>

					<wea:group context='<%=SystemEnv.getHtmlLabelName(33518, user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<input type="hidden" name="nodeCounts" value="<%=tempNodeCounts%>">
							<input type="hidden" name="nodeIds" value="<%=tempNodeIdd%>">
							<input type="hidden" name="flowId" value="<%=flowId%>">
							<input type="hidden" name="flowType" value="<%=typeId%>">
							<input type="hidden" name="subsqlstr" value="<%=xssUtil.put(subsqlstr)%>">

							<TABLE style="table-layout: fixed;width:100%;" cellspacing="0">
								<tr style="vertical-align: top;">
									<td style="width: 300px;">
										<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
											<thead>
												<TR class="HeaderForXtalbe">
													<TH style="height: 61px!important;"><%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%></TH>
													<!-- 具体流程-->
													
												</TR>
											</thead>
									
											<tbody>
												<TR class='Avg'>
													<TD style="text-align: right;">
														<span name="img" onclick="changeImg('img','detail')" style="cursor:hand;float:left;">
															<IMG SRC="/images/orderDesc_wev8.gif" BORDER="0" HEIGHT="4px" WIDTH="9px"></img>
												    	</span>
														<%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%>
													</TD>
												</TR>
												<%
													     for(int i=0;i<requestIds.size();i++){
													      requestIdd=(String)requestIds.get(i);   
													      String tempWfid = "";
													      RecordSet rs5 = new RecordSet();
													      rs5.executeProc("workflow_Requestbase_SByID", requestIdd+"");
														if(rs5.next()){	
															tempWfid = Util.getIntValue(rs5.getString("workflowid"),0) + "";
														}
													%>
													<tr name="detail" style="display:none;">
														<td><%=requestNames.get(i)%></td>
													</tr>
													<%}%>
													
											</tbody>
								
										</TABLE>
									</td>
									<td>
										<div style="overflow-x:auto;overflow-y:hidden;">
										<div>
											<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
												<thead>
													<!--详细内容在此-->
													<TR class="HeaderForXtalbe">
														<TH colspan="<%=nodeCounts.size()%>" style="width:<%=nodeCounts.size() * 150%>px;text-align:center;border-bottom: #B2C9DB 1px solid;"><%=SystemEnv.getHtmlLabelNames("15586,19079",user.getLanguage())%></TH>
														<!--节点-->
													</TR>
													<TR class="HeaderForXtalbe">
														<% if (requestIds.size()>0) {
															for (int n=0;n<nodeNamehead.size();n++){ %>
															<TH style="width:150px;"><%=nodeNamehead.get(n)%></TH>
															<%}
														   if(nodeNamehead.size() == 0){%>
															<TH colspan="3">&nbsp;</TH>
														   <%}
														}else{%>
														    <TH colspan="3">&nbsp;</TH>
														<%}%>
													</TR>
												</thead>
												
												<tbody>
													<TR class='Avg'>
													  <%if(requestIds.size()>0){%>
														<%for (int j=0;j<nodeCounts.size();j++) {
															 int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeTemps.get(j)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeTemps.get(j)),0);
															 float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeTemps.get(j)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeTemps.get(j)),0)/24;
															 boolean  overT=false;
															 
															 if ((Util.getFloatValue(""+nodeCounts.get(j),0)>overTimes)&&overTimesb!=0) overT=!overT;
															 %>
														<TD>
															<%if (overT) {%><span style="color:#B040C6;"><% }%>
																<%=flowTypeTimeAnalyseSort.getSpendsString(""+nodeCounts.get(j))%>
															<%if (overT) {%></span><%}%>
														</TD>
														<%}
														}%>
														<%if(requestIds.size()==0){%>
														    <td colspan="3">&nbsp;</td>
														 <%}%>
													</TR>
													
													<%
													     for(int i=0;i<requestIds.size();i++){
													      requestIdd=(String)requestIds.get(i);   
													      String tempWfid = "";
													      RecordSet rs5 = new RecordSet();
													      rs5.executeProc("workflow_Requestbase_SByID", requestIdd+"");
														if(rs5.next()){	
															tempWfid = Util.getIntValue(rs5.getString("workflowid"),0) + "";
														}
													%>
													<tr name="detail" style="display:none;">
														<%
														 ArrayList nodeIda=(ArrayList)nodeIds.get(i);
														 /*
														 for (int z=0;z<nodeIda.size(); z++) {
															  String tempNodeid = (String)nodeIda.get(z);
															  Map<String, String> tempnodeinfo = WorkflowVersion.getActiveWFNodeInfo(tempWfid, tempNodeid, "");
															  String tempActiveNodeid = tempnodeinfo.get("id");
															  nodeIda.set(z, tempActiveNodeid);
														 }
														*/
															 ArrayList nodeNamea=(ArrayList)nodeNames.get(i);
															 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(i);
															for (int tempnodeIndex=0;tempnodeIndex<nodeTemps.size();tempnodeIndex++)
																	  {
															            String tempnode=(String)nodeTemps.get(tempnodeIndex);
																		int k=nodeIda.indexOf(tempnode);
																		
																		if (k!=-1)
															{
															  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(k)),0);
															  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(k)),0)/24;
															  boolean  overT=false;
															  
															  if ((Util.getFloatValue(""+nodeCounta.get(k),0)>overTimes)&&overTimesb!=0) overT=!overT;
															 %>
														<td>
															<%if (overT) {%><span style="color:#B040C6;"><% }%><%=flowTypeTimeAnalyseSort.getSpendsString(""+nodeCounta.get(k))%>
															<%if (overT) {%></span><%}%>
														</td>
														<%} else {%>
														<td></td>
														<%}}%>
													</tr>
													<%}%>
												</tbody>
											
											</TABLE>
										</div>
										</div>
									</td>
								</tr>
							</TABLE>
							<!--详细内容结束-->

						</wea:item>
					</wea:group>
					</wea:layout>

			</FORM>
		</div>

		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<jsp:include page="/workflow/flowReport/IncludeExcelBody.jsp">
			<jsp:param name="exportProcess" value="handleRequest"></jsp:param>
			<jsp:param name="exportSQL" value="<%=xssUtil.put(exportSQL)%>"></jsp:param>
		</jsp:include>
		<!-- end -->

	</body>

	<script type="text/javascript">
		jQuery(document).ready(function() {
			jQuery('.ListStyle td,.ListStyle th').each(function() {
				jQuery(this).attr('title', jQuery(this).text().trim());
			});
		});

		function doExportExcel(){
		   jQuery("#loadingExcel").show();
		   var requestParam=getParamValues(frmMain);
		   document.getElementById("exportExcel").src="FlowTypeTimeAnalyseXLS.jsp?"+requestParam;
		}

		function submitData() {
			frmMain.submit();
		}

		function getRequestWindowUrl() {
			//var flowId = jQuery("#flowId").val();
			//if(flowId == "" || flowId == null){
			//	flowId = "-999";
			//}
			return "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowserRight.jsp?isfrom=flowrpt&resourceids=<%=flowId%>#<%=typeId%>";
		}
		
		function getWfUrl(){
			//var flowId = jQuery("#flowId").val();
			//if(flowId == "" || flowId == null){
			//	return false;
			//}
			var url = "/data.jsp?type=requestbrowserright&wfid=<%=flowId%>";
			return url;
		}

		function changeImg(obj1, obj2, isStarts) {
			var trs;
			var spans;
			if (isStarts) {
				trs = jQuery('tr[name^=' + obj2 + ']');
				spans = jQuery('span[name^=' + obj1 + ']');
			} else {
				trs = jQuery('tr[name=' + obj2 + ']');
				spans = jQuery('span[name=' + obj1 + ']');
			}
			if (trs.length > 0) {
				if (trs.css('display') == 'none') {
					spans.html("<IMG SRC='/images/orderAsc_wev8.gif' BORDER=0 HEIGHT=4px WIDTH=9px></img>");
					trs.show();
				} else {
					spans.html("<IMG SRC='/images/orderDesc_wev8.gif' BORDER=0 HEIGHT=4px WIDTH=9px></img>");
					trs.hide();
				}
			}
		}
	</script>
</html>
