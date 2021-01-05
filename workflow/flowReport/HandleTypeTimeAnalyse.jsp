
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowAllComInfo" class="weaver.workflow.workflow.WorkflowAllComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="OverTime" class="weaver.workflow.report.OverTimeComInfo" scope="page"/>
<jsp:useBean id="handleRequestAnalsyeSort" class="weaver.workflow.report.HandleRequestAnalsyeSort" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String imagefilename = "/images/hdReport_wev8.gif" ; 
	String userId=Util.null2String(request.getParameter("userId"));//得到传入条件
	String flowId=Util.null2String(request.getParameter("flowId"));//得到传入条件
	//String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
	RecordSet.executeSql("select version from workflow_base where id="+flowId);
	String versionid = "1";
	if(RecordSet.next()){
		versionid = Util.getIntValue(RecordSet.getString("version"), 1) + "";
	}
	String titlename = resourceComInfo.getLastname(userId) + " " + WorkflowAllComInfo.getWorkflowname(flowId) +"(V"+versionid+")"+ " " + SystemEnv.getHtmlLabelName(19079, user.getLanguage())+ " " + SystemEnv.getHtmlLabelName(33292, user.getLanguage()); 	   
	String needfav = "1" ;
	String needhelp = "" ; 
	String userRights=ReportAuthorization.getUserRights("-3",user);//得到用户查看范围
	String exportSQL="";
	if (userRights.equals("-100")){
	    response.sendRedirect("/notice/noright.jsp") ;
		return ;
	    }
	
	    String requestIdd="";
	  
	    session.setAttribute("flowReport_userRights",userRights);
	    int totalcount=0;
	 
	    session.setAttribute("flowReport_flowId",flowId);
	    String tempNodeCounts=Util.null2String(request.getParameter("tempCount"));//得到传入条件
	    String tempNodeId=Util.null2String(request.getParameter("tempNodeId"));//得到传入条件
	    String tempNodeName=Util.null2String(request.getParameter("tempNodeName"));//得到传入条件
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
		
		String subsqlstr = Util.null2String(request.getParameter("subsqlstr"));
		String requestParam="userId="+userId+"&flowId="+flowId+"&tempCount="+tempNodeCounts+"&tempNodeId="+tempNodeId+"&tempNodeName="+java.net.URLEncoder.encode(tempNodeName)+"&objId="+objIds+"&objNames="+objNames+"&flowStatus="+flowStatus;
		
		//String flowStatus=Util.null2String(request.getParameter("flowStatus"));
	    sqlCondition=" and workflow_currentoperator.userid="+userId;
	    //if (!typeId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowtype="+typeId;
	    if (!flowId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowid in ( "+ flowId +" )";
	    if (flowStatus.equals("1")) sqlCondition+=" and workflow_requestbase.currentnodetype=3 ";
	    if (flowStatus.equals("2")) sqlCondition+=" and workflow_requestbase.currentnodetype<3 ";
	    if (!objIds.equals(""))  sqlCondition+=" and workflow_requestbase.requestid in ("+objIds+")  " ;
		//得到各个节点的平均时间

		
		if (!"".equals(subsqlstr)) {
			sqlCondition += subsqlstr;
		}
		    
	    ArrayList requestIds=new ArrayList();
	    ArrayList workFlowNodeCounts=new ArrayList();
	    ArrayList nodeIds=new ArrayList();
	    ArrayList tempNodeIds=new ArrayList();
	    ArrayList tempCounts=new ArrayList();
	    //ArrayList nodeNames=new ArrayList();
	    ArrayList nodeNametemps=new ArrayList();
	    ArrayList requestNames=new ArrayList();
	if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2")){
	String sql=" select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where "+ " requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "+
	"24*avg(case when isremark='0' then to_date(NVL2(workflow_currentoperator.operatedate,workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS')"+
	" when isremark='2' and workflow_currentoperator.operatedate is not null "+
	" then to_date(workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,'YYYY-MM-DD HH24:MI:SS') end "+
	" -to_date(workflow_currentoperator.receivedate||' '||workflow_currentoperator.receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
	" from workflow_currentoperator,workflow_requestbase,workflow_requestLog "+ 
	" where workflow_requestbase.requestid=workflow_currentoperator.requestid " +
	" and workflow_requestbase.requestid=workflow_requestLog.requestid " +
	" and workflow_requestLog.operatedate is not null " +
	" and workflow_requestbase.status is not null "+  
	" and workflowtype>1 and workflow_currentoperator.isremark <> '0' and isremark<>'4' and preisremark='0' "+sqlCondition+
	" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid "+
	" and  nodetype<3) "+
	" group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid "+
	" order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid ";
	RecordSet.execute(sql);
	}
	else
		{
		    RecordSet.executeProc("WorkFlowTypeNodeTime_Get",sqlCondition);
		}
	    while (RecordSet.next())
	    { 

            String requestId = Util.null2String(RecordSet.getString("requestid"));
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
	    if(!tempNodeId.equals(",")&&!tempNodeId.equals("")){
	    	tempNodeName = "";
	    	//System.err.println("tempNodeId:"+tempNodeId);
	    	if(tempNodeId.lastIndexOf(",")==tempNodeId.length()-1){
	    		tempNodeId = tempNodeId.substring(0,tempNodeId.length()-1);
	    	}
	    	RecordSet.executeSql("select nodename from workflow_nodebase where id in ("+tempNodeId+") order by id asc ");
	     	while(RecordSet.next()){
	     		tempNodeName += RecordSet.getString("nodename")+",";
	     	}
	    }
	    ArrayList nodeCounts=Util.TokenizerString(tempNodeCounts,",");
	    ArrayList nodeNames=Util.TokenizerString(tempNodeName,",");
	    ArrayList nodeIdss=Util.TokenizerString(tempNodeId,",");
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<title><%=titlename%></title>
		<style>
			TABLE.ListStyle TR.HeaderForXtalbe TH,TABLE.ListStyle TR TD {
				BORDER-RIGHT: #B2C9DB 1px solid;
				border-bottom: #B2C9DB 1px solid;
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
				text-overflow: ellipsis;
				white-space: nowrap;
				word-break: keep-all;
				overflow: hidden;
			}
		</style>
	</head>
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
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(28343, user.getLanguage()) +",javascript:doExportExcel(),_self} ";
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
			<FORM id=frmMain name=frmMain action=HandleTypeTimeAnalyse.jsp method=post>
	
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(22256, user.getLanguage())%></wea:item>
						<wea:item>
							<span><%=WorkTypeComInfo.getWorkTypename(WorkflowAllComInfo.getWorkflowtype(flowId))%></span>
						</wea:item>

						<!-- 工作流 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
						<wea:item>
							<span><%=WorkflowAllComInfo.getWorkflowname(flowId)%></span>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="objId"
								browserValue='<%=objIds%>'
								getBrowserUrlFn="getRequestWindowUrl"
								hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
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

							<input type="hidden" name="tempCount" value="<%=tempNodeCounts%>">
							<input type="hidden" name="tempNodeId" value="<%=tempNodeId%>">
							<input type="hidden" name="flowId" value="<%=flowId%>">
							<input type="hidden" name="userId" value="<%=userId%>">
							<input type="hidden" name="subsqlstr" value="<%=xssUtil.put(subsqlstr)%>">
							<input type="hidden" name="tempNodeName" value="<%=tempNodeName%>">
							
							<TABLE style="table-layout: fixed;width:100%;" cellspacing="0">
								<tr style="vertical-align: top;">
									<td style="width: 300px;">
										<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
										<!--详细内容在此-->
											
										<thead>
											<!--详细内容在此-->
		
											<TR class="HeaderForXtalbe">
												<!-- 具体流程-->
												<TH  style="height: 61px!important;"><%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%></TH>
											</TR>
										</thead>
										<tbody>
									
											<tr class='Avg'>
												<td style="text-align: right;">
													<span name="img" onclick="changeImg('img','detail')" style="cursor:hand;float:left;">
														<IMG SRC="/images/orderAsc_wev8.gif" BORDER="0" HEIGHT="4px" WIDTH="9px"></img>
											    	</span>
												<%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%>
												</td>
											</tr>
											<%  
											      for(int i=0;i<requestIds.size();i++){
											       requestIdd=(String)requestIds.get(i);   
											 %>
											<tr name="detail" style="display:none;">
												<td><%=requestNames.get(i)%></td>
											</tr>
											<%
											 }
											 %>
										</tbody>
										</TABLE>
									</td>
									<td>
										<div style="overflow-x:auto;overflow-y:hidden;">
										<div>
										<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
										<!--详细内容在此-->
											
										<thead>
											<!--详细内容在此-->
		
											<TR class="HeaderForXtalbe">
												<TH colspan="<%=nodeNames.size()%>" style="width:<%=nodeCounts.size() * 150%>px;text-align:center;border-bottom: #B2C9DB 1px solid;"><%=SystemEnv.getHtmlLabelNames("15586,19079",user.getLanguage())%></TH>
												<!--节点-->
											</TR>
											<TR class="HeaderForXtalbe">
												<%
												if(requestIds.size()>0){
												for (int m=0;m<nodeNames.size();m++) {%>
												<TH style="width:150px;"><%=nodeNames.get(m)%></TH>
												<%}
												}%>
												<%if(nodeNames.size()==0||requestIds.size()==0){%>
													<TH style="width:150px;">&nbsp;</TH>
												<%}%>
											</TR>
										</thead>
										<tbody>
											
											<tr class='Avg'>
												<%for (int j=0;j<nodeCounts.size();j++) {
		  
												   int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIdss.get(j)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIdss.get(j)),0);
												   float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIdss.get(j)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIdss.get(j)),0)/24;
												   boolean  overT=false;
												  
												   if ((Util.getFloatValue(""+nodeCounts.get(j),0)>overTimes)&&overTimesb!=0) overT=!overT;
												  %>
												<TD>
													<%if (overT) {%><font color="red"> <% }%><%=handleRequestAnalsyeSort.getSpendsString(""+nodeCounts.get(j))%>
														<%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font>
													<%}%>
												</TD>
												<%}%>
												<%if(nodeIdss.size()==0){%>
												    <td></td>
												 <%}%>
											</tr>
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
												 for (int z=0;z<nodeIda.size(); z++) {
													  String tempNodeid = (String)nodeIda.get(z);
													  //Map<String, String> tempnodeinfo = WorkflowVersion.getActiveWFNodeInfo(tempWfid, tempNodeid, "");
													  //String tempActiveNodeid = tempnodeinfo.get("id");
													  nodeIda.set(z, tempNodeid);
												 }
												 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(i);
												 for (int k=0;k<nodeIdss.size();k++)
												 {
												 		int tempIdIndex=-1;
														if(nodeIdss.size()>0){
															tempIdIndex = nodeIda.indexOf(""+nodeIdss.get(k));
														}
												 %>
												<td>
													<%if (tempIdIndex!=-1) {
													  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIdss.get(k)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIdss.get(k)),0);
													  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIdss.get(k)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIdss.get(k)),0)/24;
													  boolean  overT=false;
													  
													  if ((Util.getFloatValue(""+nodeCounta.get(tempIdIndex),0)>overTimes)&&overTimesb!=0) overT=!overT;
													 %>
													<%if (overT) {%><font color="red"> <% }%><%=handleRequestAnalsyeSort.getSpendsString(""+nodeCounta.get(tempIdIndex))%>
														<%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font>
													<%}%>
													<%}%>
												</td>
												<%
												 }%>
												 <%if(nodeIdss.size()==0){%>
												    <td></td>
												 <%}%>
											</tr>
											<%
											 }
											 %>
										</tbody>
										</TABLE>
										</div>
										</div>
									</td>
								</tr>
							</TABLE>

						</wea:item>
					</wea:group>
					</wea:layout>

			</FORM>
		</div>

		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<jsp:include page="/workflow/flowReport/IncludeExcelBody.jsp">
			<jsp:param name="exportProcess" value="handleTypeTime"></jsp:param>
			<jsp:param name="exportSQL" value="<%=exportSQL%>"></jsp:param>
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
	   document.getElementById("exportExcel").src="HandleTypeTimeAnalyseXLS.jsp?"+requestParam;
	}

	function submitData()
	{
	   frmMain.submit();
	}

	function getRequestWindowUrl() {
		return "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowserRight.jsp?isfrom=flowrpt&resourceids=<%=flowId%>~<%=WorkflowAllComInfo.getWorkflowtype(flowId)%>";
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
				spans.html("<IMG SRC='/images/orderDesc_wev8.gif' BORDER=0 HEIGHT=4px WIDTH=9px></img>");
				trs.show();
			} else {
				spans.html("<IMG SRC='/images/orderAsc_wev8.gif' BORDER=0 HEIGHT=4px WIDTH=9px></img>");
				trs.hide();
			}
		}
	}
</script>
</html>
