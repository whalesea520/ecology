
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>

<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowAllComInfo" class="weaver.workflow.workflow.WorkflowAllComInfo" scope="page" />
<jsp:useBean id="overTime" class="weaver.workflow.report.OverTimeComInfo" scope="page" />
<jsp:useBean id="flowTypeTimeAnalyseSort" class="weaver.workflow.report.FlowTypeTimeAnalyseSort" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="timeUtil" class="weaver.general.TimeUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<style>
		TABLE.ListStyle TR.Avg TD {
			BACKGROUND-COLOR: #ECFDEA;
			FONT-WEIGHT: BOLD;
		}
		TABLE.ListStyle TR {
			vertical-align: middle;
		}
		TABLE.ListStyle TR TD {
			border-top:1px #E9E9E2 solid;
			height: 30px;
			vertical-align: middle;
			text-overflow: ellipsis;
			white-space: nowrap;
			word-break: keep-all;
			overflow: hidden;
		}
	</style>
	<BODY>
<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(19029 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ;
String exportSQL="";
String userRights=ReportAuthorization.getUserRights("-3",user);//得到用户查看范围
  if (userRights.equals("-100"))
    {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }

    String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount1="";
	String workflowname="";
   
    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();     //总计
	ArrayList workflowcountst=new ArrayList();     //总计流程类型
	ArrayList nodeTypes=new ArrayList();           //节点类型
    ArrayList newremarkwfcounts0=new ArrayList(); 
    ArrayList wftypecounts0=new ArrayList(); 
 
    ArrayList wftypess=new ArrayList();
  
    int totalcount=0;
    String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
    String flowId = Util.null2String(request.getParameter("flowId"));//得到搜索条件
    String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId); 
    String isfrom = Util.null2String(request.getParameter("isfrom"));
    String crefromdate = Util.null2String(request.getParameter("crefromdate"));//得到搜索条件
	String cretodate = Util.null2String(request.getParameter("cretodate"));//得到搜索条件
	if("".equals(crefromdate) && "".equals(cretodate) && !"self".equals(isfrom)){
		crefromdate = timeUtil.getDateByOption("3","0");
		cretodate = timeUtil.getDateByOption("3","1");
	}
	
	String guifromdate = Util.null2String(request.getParameter("guifromdate"));//得到搜索条件
	String guitodate = Util.null2String(request.getParameter("guitodate"));//得到搜索条件
	Map<String, String> wfVersionMap = new HashMap<String, String>();
    String sqlCondition="";
    String sqlCondition_t="";
   
    String operationtemp = Util.null2String(request.getParameter("operation"));
	if("".equals(operationtemp)) sqlCondition += " and 1=2";
    
    if (userRights.equals(""))
    {sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
     sqlCondition_t=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";   
    }
    else
    {sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
     sqlCondition_t=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";   
    }
    
    if (!typeId.equals("")){
		sqlCondition += " and workflow_currentoperator.workflowtype=" + typeId;
		sqlCondition_t += " and workflow_currentoperator.workflowtype=" + typeId;
	}
    if (!versionsIds.equals("")){
    	sqlCondition += " and workflow_currentoperator.workflowid in ("+versionsIds + ")";
    	sqlCondition_t += " and workflow_currentoperator.workflowid in ("+versionsIds + ")";
	}
	String subsqlstr = "";
	
	//创建时间
	if(!"".equals(crefromdate)){
	    sqlCondition += " and workflow_requestbase.createdate >='" +crefromdate+ "'";
		subsqlstr += " and workflow_requestbase.createdate >='" +crefromdate+ "'";
	}
	if(!"".equals(cretodate)){
	    sqlCondition += " and workflow_requestbase.createdate <='" +cretodate+ "'";
		subsqlstr += " and workflow_requestbase.createdate <='" +cretodate+ "'";
	}
	
	//归档时间
	if (!guifromdate.equals("")||!guitodate.equals("")) {
	   sqlCondition+=" and workflow_requestbase.currentnodetype='3'";
	   subsqlstr += " and workflow_requestbase.currentnodetype='3'";
	}
	if(!"".equals(guifromdate)){
	    sqlCondition += " and workflow_requestbase.lastoperatedate >='" +guifromdate+ "'";
		subsqlstr += " and workflow_requestbase.lastoperatedate >='" +guifromdate+ "'";
	}
	if(!"".equals(guitodate)){
	    sqlCondition += " and workflow_requestbase.lastoperatedate <='" +guitodate+ "'";
		subsqlstr += " and workflow_requestbase.lastoperatedate <='" +guitodate+ "'";
	}
	
    String sql="select workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,  "+
    " count(distinct workflow_requestbase.requestid) workflowcount from "+
    " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
    " and (workflow_requestbase.status is not null and workflow_requestbase.status != ' ') and workflow_currentoperator.workflowtype>1  and preisremark='0' and isremark<>'4' "+sqlCondition+" group by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "+
    " order by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
	//out.print(sql);
	recordSet.executeSql(sql) ;

	while(recordSet.next()){       
        String theworkflowid = Util.null2String(recordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(recordSet.getString("workflowtype")) ;
       
		int theworkflowcount = Util.getIntValue(recordSet.getString("workflowcount"),0) ;
		rs.executeSql("select version from workflow_base where id="+theworkflowid);
		String versionid = "0";
		if(rs.next()){
			versionid = Util.getIntValue(rs.getString("version"), 1) + "";
		}
		wfVersionMap.put(theworkflowid,versionid);
        if(WorkflowAllComInfo.getIsValid(theworkflowid).equals("1") || WorkflowAllComInfo.getIsValid(theworkflowid).equals("3")){ 
            int wfindex = workflows.indexOf(theworkflowid) ;
            if(wfindex != -1) {
                workflowcounts.set(wfindex,""+(Util.getIntValue((String)workflowcounts.get(wfindex),0)+theworkflowcount)) ;
            }else{
                workflows.add(theworkflowid) ;
                workflowcounts.add(""+theworkflowcount) ;	
            }

            int wftindex = wftypes.indexOf(theworkflowtype) ;
            if(wftindex != -1) {
            wftypecounts.set(wftindex,""+(Util.getIntValue((String)wftypecounts.get(wftindex),0)+theworkflowcount)) ;
            }
            else {
                wftypes.add(theworkflowtype) ;
                wftypecounts.add(""+theworkflowcount) ;
            }

           
        }
	}
	
	//得到各个节点的平均时间

	float maxAvg = 0;
    ArrayList workFlowIds=new ArrayList();
    ArrayList workFlowNodeCounts=new ArrayList();
    ArrayList nodeIds=new ArrayList();
    ArrayList tempNodeIds=new ArrayList();
    ArrayList tempCounts=new ArrayList();
    ArrayList nodeNames=new ArrayList();
    ArrayList nodeNametemps=new ArrayList();
   if (recordSet.getDBType().equals("oracle")||recordSet.getDBType().equals("db2"))
   { 
	   
//recordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where trim(operatedate)='' "+sqlCondition_t);
	   
String sqls="select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,"+
"(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "+
"24*avg(to_date( NVL2(trim(operatedate),operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
"-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
"from workflow_currentoperator,workflow_requestbase  where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
"and (workflow_requestbase.status is not null) and workflowtype>1 and isremark<>'4' and preisremark='0' "+ sqlCondition+
"and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  "+
"workflowid=workflow_currentoperator.workflowid and nodetype<>3) "+
"group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "+
"order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid";
recordSet.execute(sqls);

   }
   else
   {
	   //recordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where rtrim(ltrim(operatedate))='' "+sqlCondition_t); 
	   recordSet.executeProc("WorkFlowNodeTime_Get",sqlCondition);
   }
   Set usedWfIds = new HashSet<String>();  //获取使用到的wfid
   while (recordSet.next())
   {    	
   		String workFlowId = Util.null2String(recordSet.getString("workflowid"));
		String nodeId = Util.null2String(recordSet.getString("nodeid"));
		String nodeName = Util.null2String(recordSet.getString(3));
		float avgNode = Util.getFloatValue(recordSet.getString(4), 0);
		//System.out.println("===========================workFlowId=" + workFlowId + ", nodeName=" + nodeName +", avgNode="+ avgNode);
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

		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
					+ ",javascript:submitData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343, user.getLanguage()) +",javascript:doExportExcel(),_self} ";
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
			<FORM id=frmMain name=frmMain action="FlowTimeAnalyse.jsp?isfrom=self" method=post>
	
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="typeId"
								browserValue='<%=typeId%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								_callback="changeFlowType"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="2" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue='<%=workTypeComInfo.getWorkTypename(typeId)%>'>
							</brow:browser>
						</wea:item>
						
						<!-- 工作流 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="flowId"
								browserValue='<%=flowId%>'
								getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
								isSingle="false" hasBrowser="true" isMustInput="1"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=WorkflowAllComInfo.getWorkflowname(flowId)%>'>
							</brow:browser>
						</wea:item>

						<!-- 创建日期 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="createdateselect" >
								<input class=wuiDateSel type="hidden" name="crefromdate" value="<%=crefromdate%>">
								<input class=wuiDateSel type="hidden" name="cretodate" value="<%=cretodate%>">
							</span>
						</wea:item>

						<!-- 归档日期 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="guidateselect" >
								<input class=wuiDateSel type="hidden" name="guifromdate" value="<%=guifromdate%>">
								<input class=wuiDateSel type="hidden" name="guitodate" value="<%=guitodate%>">
							</span>
						</wea:item>
					</wea:group>

					<wea:group context='<%=SystemEnv.getHtmlLabelName(33518, user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<input type="hidden" name="operation" value="search" />
							<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
							<!--详细内容在此-->
							  <col width="30%"> 
							  <col width="20%"> 
							  <col width="50%">
							  <thead>
							  <TR class="HeaderForXtalbe">
								  <TH>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18561,user.getLanguage())%>）- <%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></TH>
								  <TH style="text-align: right;">
								  	<%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%>
								  </TH>
								  <TH>
								  	<span style="padding-left: 0px;" class="xTable_algorithmdesc" title="<%=SystemEnv.getHtmlLabelName(124811,user.getLanguage())%> &#10;<%=SystemEnv.getHtmlLabelName(124812,user.getLanguage())%>">
										<img style="vertical-align:top;" src="/images/info_wev8.png">
									</span>
								</TH>
							  </TR>
							  </thead>
							  <tbody>
							  	<%
								   for(int i=0;i<wftypes.size();i++){
									   int i0 = 0;
								       typeid=(String)wftypes.get(i);
								       typecount=(String)wftypecounts.get(i);
								       typename=workTypeComInfo.getWorkTypename(typeid);
								 %>
								 <%for(int j=0;j<workflows.size();j++){
									 i0++;
								     workflowid=(String)workflows.get(j);
								     String curtypeid=WorkflowAllComInfo.getWorkflowtype(workflowid);
								     if(!curtypeid.equals(typeid)) continue;
								     workflowname=WorkflowAllComInfo.getWorkflowname(workflowid); 
									 String versionId = Util.null2String(wfVersionMap.get(workflowid));
									 if (!versionId.equals("")) {
											workflowname += "(V" +  versionId + ")";
									 }
								     String tempNodeCounts=""; 
								     String tempNodeIdd="";
								     int indexId=workFlowIds.indexOf(workflowid);
								     if (indexId!=-1)
								     {
								      ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
									  ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
									  
									  
									  for (int l=0;l<nodeIda.size();l++)
									  {
									  tempNodeCounts+=nodeCounta.get(l)+",";
									  tempNodeIdd+=nodeIda.get(l)+",";
									  }
								     }
								 %>
								 
								 <tr class="Flow">
									 <td>
									 	<span name="img<%=i0%>" onclick="changeImg('img<%=i0%>','detail<%=i0%>')" style="cursor:hand;float:left;"><IMG SRC="/images/-_wev8.png"  BORDER="0" HEIGHT="9px" WIDTH="9px"></img></span>&nbsp;
									 	<a style="COLOR: #538DD5;" href="FlowTypeTimeAnalyse.jsp?nodeIds=<%=tempNodeIdd%>&flowType=<%=curtypeid%>&flowId=<%=workflowid%>&nodeCounts=<%=tempNodeCounts%>&subsqlstr=<%=xssUtil.put(subsqlstr)%>" target="_newlist"><%=workflowname%>（<%=workflowcounts.get(j)%>）</a>
									 </td>
									 <td></td>
									 <td></td>
								 </tr>
								 
								 <%
								 if (indexId!=-1)
								 {
								 ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
								 ArrayList nodeNamea=(ArrayList)nodeNames.get(indexId);
								 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
								 for (int k=0;k<nodeIda.size();k++)
								 {
									 int overTimesb=Util.getIntValue(overTime.getOverHour(""+nodeIda.get(k)),0)+Util.getIntValue(overTime.getOverTime(""+nodeIda.get(k)),0);
									  float overTimes=Util.getFloatValue(overTime.getOverHour(""+nodeIda.get(k)),0)+Util.getFloatValue(overTime.getOverTime(""+nodeIda.get(k)),0)/24;
									  boolean  overT=false;
									  float tv = Util.getFloatValue(""+nodeCounta.get(k),0);
									  if (tv > overTimes && overTimesb != 0)
										  overT = !overT;
									  if (tv > maxAvg) {
										  maxAvg = tv;
									  }
								 %>
								 <tr name="detail<%=i0%>">
									 <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=nodeNamea.get(k)%></td>
									 <td style="text-align: right;">
									 	<%if (overT) {%><span style="color:#B040C6;"><% }%><%=flowTypeTimeAnalyseSort.getSpendsString(""+nodeCounta.get(k))%>
									 	<%if (overT) {%></span><%}%>
									 </td>
									 <td title="<%=tv%>" class="percent">
									 	<div class="e8_outPercent" style="width:100%;border:#FFFFFF;">
											<span class="e8_innerPercent" style="<%if (overT) {%>background:#B040C6;<%}%>"></span>
										</div>
									 </td>
								</tr>
								 <%
								 }
								 }
								 workflows.remove(j);
								 workflowcounts.remove(j);
								 j--;
								 }
								 }%>
							  </tbody>
							</TABLE>

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

	<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

	<script type="text/javascript">
		jQuery(document).ready(function() {
			jQuery('.percent').each(function() {
				var percent = parseFloat(jQuery(this).attr('title')) * 100 / <%=maxAvg%> + '%';
				jQuery('div span', this).width(percent);
				var w = jQuery('div span', this).width();
				if (/%$/.test(w)) {
					return;	
				}
				if (parseFloat(w) <= 1) {
					jQuery('div span', this).width('1px');
				}
			});
			jQuery('.ListStyle td,.ListStyle th').each(function() {
				jQuery(this).attr('title', jQuery(this).text().trim());
			});
		});


		function doExportExcel(){
		   jQuery("#loadingExcel").show();
		   var requestParam=getParamValues(frmMain);
		   document.getElementById("exportExcel").src="FlowTimeAnalyseXLS.jsp?"+requestParam;
		}

		function submitData() {
			if (check_form($G("frmMain"), 'typeId'))
		   		frmMain.submit();
		}

		function changeFlowType() {
			_writeBackData('flowId', 1, {id:'',name:''});
		}

		function getFlowWindowUrl(){
			return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("typeId").value;
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
					spans.html("<IMG SRC='/images/-_wev8.png' BORDER=0 HEIGHT=9px WIDTH=9px></img>&nbsp;");
					trs.show();
				} else {
					spans.html("<IMG SRC='/images/+_wev8.png' BORDER=0 HEIGHT=9px WIDTH=9px></img>&nbsp;");
					trs.hide();
				}
			}
		}
	</script>
</html>
