
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowAllComInfo" class="weaver.workflow.workflow.WorkflowAllComInfo" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="overTime" class="weaver.workflow.report.OverTimeComInfo" scope="page" />
<jsp:useBean id="handleRequestAnalsyeSort" class="weaver.workflow.report.HandleRequestAnalsyeSort" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<BODY>

		<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(19030 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
String userRights=ReportAuthorization.getUserRights("-4",user);//得到用户查看范围
    if (userRights.equals("-100")){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }

    overTime.removeBrowserCache();
	String exportSQL="";
    String typeid="";
	//String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
	String workflowname="";
    ArrayList temp=new ArrayList();  
    ArrayList wftypes=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();     //总计
	ArrayList nodeTypes=new ArrayList();           //节点类型
    ArrayList userIds=new ArrayList();
    ArrayList wftypess=new ArrayList();
    ArrayList wfUsers=new ArrayList();
    ArrayList flowUsers=new ArrayList();
    
   //得到各个节点的平均时间

	
    ArrayList workFlowNodes=new ArrayList();
    ArrayList workFlowUserIds=new ArrayList();
    ArrayList workFlowNodeCounts=new ArrayList();
    ArrayList nodeIds=new ArrayList();
    ArrayList tempNodeIds=new ArrayList();
    ArrayList tempCounts=new ArrayList();
     //系统平耗时

    ArrayList tempCountsx=new ArrayList();
    ArrayList tempSum=new ArrayList();
    ArrayList nodeNames=new ArrayList();
    ArrayList nodeNametemps=new ArrayList();
    ArrayList nodeUserIds=new ArrayList();
    float maxAvg = 0;
    int totalcount=0;
    String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
    String flowId=Util.null2String(request.getParameter("flowId"));//得到搜索条件
    String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(flowId);
    String objIds=Util.null2String(request.getParameter("objId"));//得到搜索条件
    
    String fromcredate = Util.null2String(request.getParameter("fromcredate"));//得到创建时间搜索条件
	String tocredate = Util.null2String(request.getParameter("tocredate"));//得到创建时间搜索条件
	
    String fromadridate = Util.null2String(request.getParameter("fromadridate"));//得到到达搜索条件
	String toadridate = Util.null2String(request.getParameter("toadridate"));//得到到达搜索条件
	
	String objStatueType = Util.null2String(request.getParameter("objStatueType"));//得到流程状态搜索条件

   
    String showObj="none";
	
    String subsqlstr = "";
    
    String tempsql="";
    String tempsql1="";
    int objType1=Util.getIntValue(request.getParameter("objType"),0);
	String objNames = "";
	if (!"".equals(objIds)) {		
		if (objIds.startsWith(",")) {
			objIds = objIds.replaceFirst(",", "");
		}
		String[] objIdArr = Util.splitString(objIds,",");
		switch (objType1){
			case 1:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(resourceComInfo.getLastname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(resourceComInfo.getLastname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
		      	break;
			case 2:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
				break;
			case 3:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
				break;
		}	
	}
	Map<String, String> wfVersionMap = new HashMap<String, String>();
    String sqlCondition=" and 1=1";
    int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
    String requestParam="typeId="+typeId+"&flowId="+flowId+"&fromcredate="+fromcredate+"&tocredate="+tocredate+"&fromadridate="+fromadridate+"&toadridate="+toadridate+"&objStatueType="+objStatueType+"&objType="+objType1+"&objNames="+objNames;
    int	perpage=10;
    session.setAttribute("objIds",objIds);
    boolean hasNextPage=false;
	int recordSetCounts = 0;
   if (objType1!=0)
   {
    switch (objType1){
	        case 1:
	        //tempsql="select id from hrmresource where  id in ("+objIds+") ";
			sqlCondition=" and ("+Util.getSubINClause(objIds,"userid","in")+")";
	        break;
	        case 2:
	        //tempsql=" select id from hrmresource where departmentid in ("+objIds+") ";
	        sqlCondition=" and userid in  (select id from hrmresource where  departmentid in ("+objIds+") )" ;
	        break;
	        case 3:
	        //tempsql=" select id from hrmresource where  subcompanyid1 in ("+objIds+") ";
	        sqlCondition=" and userid in (select id from hrmresource where  subcompanyid1 in ("+objIds+") )" ;
	        break;
	}
	
	if (userRights.equals(""))
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
   
	if (!typeId.equals("")&&!typeId.equals("0")){
		sqlCondition+=" and workflow_currentoperator.workflowtype="+typeId;
		subsqlstr += " and workflow_currentoperator.workflowtype ="+typeId;
	}
    if (!flowId.equals("")){
		sqlCondition+=" and workflow_currentoperator.workflowid in( "+ versionsIds + ")";
		subsqlstr += " and workflow_currentoperator.workflowid in( "+ versionsIds + ")";
	}
    
    if(!"".equals(fromcredate)) {
	    sqlCondition += " and workflow_requestbase.createdate >='" +fromcredate+ "'";
		subsqlstr += " and workflow_requestbase.createdate >='" +fromcredate+ "'";
	}
	if(!"".equals(tocredate)) {
	    sqlCondition += " and workflow_requestbase.createdate <='" +tocredate+ "'";
        subsqlstr += " and workflow_requestbase.createdate <='" +tocredate+ "'";
	}
	if(!"".equals(fromadridate)) {
		sqlCondition += " and workflow_currentoperator.receivedate >='" +fromadridate+ "'";
		subsqlstr += " and workflow_currentoperator.receivedate >='" +fromadridate+ "'";
	}
	if(!"".equals(toadridate)) {
		sqlCondition += " and workflow_currentoperator.receivedate <='" +toadridate+ "'";
		subsqlstr += " and workflow_currentoperator.receivedate <='" +toadridate+ "'";
	}
	if(!"".equals(objStatueType)) {
		if("1".equals(objStatueType)) {
			sqlCondition += " and workflow_requestbase.currentnodetype ='3'";
            subsqlstr += " and workflow_requestbase.currentnodetype ='3'";
		} else {
			sqlCondition += " and workflow_requestbase.currentnodetype <>'3'";
            subsqlstr += " and workflow_requestbase.currentnodetype <>'3'";
		}
	}

     if (recordSet.getDBType().equals("oracle")||recordSet.getDBType().equals("db2")){
	 
	   String sql="select workflow_currentoperator.userid,workflow_currentoperator.workflowtype,workflow_currentoperator.workflowid,  "+
    " count(distinct workflow_requestbase.requestid) workflowcount from "+
    " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
    " and (workflow_requestbase.status is not null ) and workflow_currentoperator.workflowtype>1  "+sqlCondition+" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and workflowid=workflow_currentoperator.workflowid and nodetype<>3) group by "+ 
	" workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "+
    " order by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
	
	recordSet.executeSql(sql) ;
	 }
	 else
	   {
	String sql="select workflow_currentoperator.userid,workflow_currentoperator.workflowtype,workflow_currentoperator.workflowid,  "+
    " count(distinct workflow_requestbase.requestid) workflowcount from "+
    " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
    " and (workflow_requestbase.status is not null and workflow_requestbase.status!='') and workflow_currentoperator.workflowtype>1 and preisremark='0' and isremark<>'4' "+sqlCondition+" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and workflowid=workflow_currentoperator.workflowid and nodetype<>3) group by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "+
    " order by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";

	recordSet.executeSql(sql) ;
	   }
	while(recordSet.next()){       
        String theworkflowid = Util.null2String(recordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(recordSet.getString("workflowtype")) ;
        String userid=Util.null2String(recordSet.getString("userid")) ;
		int theworkflowcount = Util.getIntValue(recordSet.getString("workflowcount"),0) ;
		rs.executeSql("select version from workflow_base where id="+theworkflowid);
		String versionid = "0";
		if(rs.next()){
			versionid = Util.getIntValue(rs.getString("version"), 1) + "";
		}
		wfVersionMap.put(theworkflowid,versionid);
        if(WorkflowAllComInfo.getIsValid(theworkflowid).equals("1") || WorkflowAllComInfo.getIsValid(theworkflowid).equals("3")){            
            int wfindex = workflows.indexOf(userid+","+theworkflowid) ;
            if(wfindex != -1) {                
	     		String count[] = Util.splitString(workflowcounts.get(wfindex).toString(),",");
                int wfCount  = Util.getIntValue(count[2]) + theworkflowcount;	                
                workflowcounts.set(wfindex, userid+","+theworkflowid+","+wfCount);
            }else{
                workflows.add(userid+","+theworkflowid);
                workflowcounts.add(userid+","+theworkflowid+","+theworkflowcount) ;	
            }            
            //workflows.add(theworkflowid) ;
            //workflowcounts.add(""+theworkflowcount);
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
        //System.out.println("========================workflows= " + workflows + ",workflowcounts= "+ workflowcounts + "\n");
	}
if (recordSet.getDBType().equals("oracle")||recordSet.getDBType().equals("db2")){
    //recordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where trim(operatedate)='' ");
    recordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where operatedate='' ");
    
	
String sql="select workflow_currentoperator.userid,workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid),"+
"24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
"-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
" from workflow_currentoperator,workflow_requestbase "+
" where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null  "+        
"  ) and workflowtype>1 and workflow_currentoperator.isremark <> '0' and isremark<>'4' and preisremark='0' "+sqlCondition +
" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  "+  
" workflowid=workflow_currentoperator.workflowid and nodetype<>3) "+ 
"group by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "+
"order by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid ";
recordSet.execute(sql);

}
else
	   {
    //recordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where rtrim(ltrim(operatedate))='' ");
    recordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where operatedate='' ");

    recordSet.executeProc("PersonNodeTime_Get",sqlCondition);
	   }
    while (recordSet.next())
    { String userId=Util.null2String(recordSet.getString("userid")) ; 
      String workFlowId = Util.null2String(recordSet.getString("workflowid")) ;        
      String nodeId = Util.null2String(recordSet.getString("nodeid")) ;
      String nodeName=Util.null2String(recordSet.getString(4)) ;
      float avgNode = Util.getFloatValue(recordSet.getString(5),0) ;
      int flowIndex=workFlowUserIds.indexOf(userId+"$"+workFlowId);
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
       workFlowUserIds.add(userId+"$"+workFlowId);
       tempNodeIds.add(nodeId);
       nodeIds.add(tempNodeIds);
       tempCounts.add(""+avgNode);
       workFlowNodeCounts.add(tempCounts);
       nodeNametemps.add(nodeName);
       nodeNames.add(nodeNametemps);
      }     
     
    } 
     //系统平均耗时   (是否考虑在其他页面操作，点击时才出现???,by ben 太耗性能了！:（  )
if (recordSet.getDBType().equals("oracle")||recordSet.getDBType().equals("db2")){
	
	String sql=" select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "+
"24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
"-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
" from workflow_currentoperator,workflow_requestbase "+
" where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null ) "+
"	and workflowtype>1 and workflow_currentoperator.isremark <> '0' and isremark<>'4' and preisremark='0' "+
" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and "+ " workflowid=workflow_currentoperator.workflowid and nodetype<>3) "+
" group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "+
" order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid ";
	recordSet.execute(sql);
}
else {
       recordSet.executeProc("WorkFlowSysNodeTime_Get",sqlCondition);
}
   
       while (recordSet.next())
      {

       workFlowNodes.add(""+Util.null2String(recordSet.getString("nodeid")));
       tempCountsx.add(""+Util.getFloatValue(recordSet.getString(4),0));
      }     
    
    }
   
    //System.out.println(sqlCondition);
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
			<FORM id=frmMain name=frmMain action=HandleRequestAnalyse.jsp method=post>
	
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(124810, user.getLanguage())%></wea:item>
						<wea:item>
							<select style="width: 100px;float: left;" class=InputStyle id="objType" name=objType onchange="onChangeType();">
								<option value="1" <%if (objType1==1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
								<option value="2" <%if (objType1==2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
								<option value="3" <%if (objType1==3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							</select>
	
							<brow:browser width="200px" viewType="0" name="objId" browserValue='<%=""+objIds%>' 
							    getBrowserUrlFn="getObjWindowUrl"
							    completeUrl="javascript:getAjaxUrl();" 
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput="2"
								browserSpanValue='<%=objNames%>'></brow:browser>
						</wea:item>

						<!-- 流程状态 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
						<wea:item>
							<select style="width: 100px" class=InputStyle name=objStatueType>
								<option value=""><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
								<option value="1" <%if("1".equals(objStatueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%></option>
								<option value="2" <%if("2".equals(objStatueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
							</select>
						</wea:item>

						<!-- 创建日期 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="createdateselect" >
								<input class=wuiDateSel type="hidden" name="fromcredate" value="<%=fromcredate%>">
								<input class=wuiDateSel type="hidden" name="tocredate" value="<%=tocredate%>">
							</span>
						</wea:item>

						<!-- 归档日期 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(27165,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="adridateselect" >
								<input class=wuiDateSel type="hidden" name="fromadridate" value="<%=fromadridate%>">
								<input class=wuiDateSel type="hidden" name="toadridate" value="<%=toadridate%>">
							</span>
						</wea:item>
						
						<wea:item><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="typeId"
								browserValue='<%= ""+typeId %>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								_callback="changeFlowType"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl=""
								browserDialogWidth="600px"
								browserSpanValue='<%=workTypeComInfo.getWorkTypename(typeId)%>'></brow:browser>
	
						</wea:item>
						
						<!-- 工作流 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="flowId"
								browserValue='<%= ""+flowId %>'
								getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
								isSingle="true" hasBrowser="true" isMustInput="1"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=WorkflowAllComInfo.getWorkflowname(flowId)%>'></brow:browser>
						</wea:item>
					</wea:group>

					<wea:group context='<%=SystemEnv.getHtmlLabelName(33518, user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<input type="hidden" name="pagenum" value=''>
							<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
									<!--详细内容在此-->
									<COLGROUP>
									<col width="30%">
									<col width="15%">
									<col width="20%">
									<col width="15%">
									<col width="20%">
									</COLGROUP>
								<thead>
									<TR class="HeaderForXtalbe">
										<TH>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(124813, user.getLanguage())%></TH>
										<TH style="text-align: right;"><%=SystemEnv.getHtmlLabelName(19059, user.getLanguage())%></TH>
										<TH></TH>
										<TH style="text-align: right;"><%=SystemEnv.getHtmlLabelName(124814, user.getLanguage())%></TH>
										<TH></TH>
									</TR>
								</thead>
								<tbody>
										<%	if (objType1!=0) {
										      for(int i=0;i<userIds.size();i++){
										       String objId=(String)userIds.get(i);
										 %>
										<tr style="vertical-align: middle;">
											<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">
												<span name="img<%=i%>_" onclick="changeImg('img<%=i%>_','detail<%=i%>_', true)" style="cursor:hand">
													<IMG SRC="/images/-_wev8.png" BORDER="0" HEIGHT="9px" WIDTH="9px"></img>
											    </span>
											    &nbsp;
												<a href="javaScript:openhrm(<%=objId%>);" onclick='pointerXY(event);'><b><%=resourceComInfo.getLastname(objId)%></b></a>
											</td>
											<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"></td>
											<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"></td>
											<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"></td>
											<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"></td>
										</tr>
										<%
										int j0 = 0;
										for(int j=0;j<wftypes.size();j++){
											
											 String tempObjId=""+wfUsers.get(j);
											 String wfId=""+wftypes.get(j);
											 if (!tempObjId.equals(objId)) continue;
										%>
											<!--<tr>
												<td>
											    	<%=workTypeComInfo.getWorkTypename(wfId)%>
											    </td>
												<td></td>
												<td></td>
											</tr>
												--><%
												for(int k=0;k<workflows.size();k++){
													j0++;
												     String[] wfInfo= Util.splitString((String)workflows.get(k),",");
												     workflowid= wfInfo[1];
												     String curtypeid=WorkflowAllComInfo.getWorkflowtype(workflowid);
													 String tempUser=wfInfo[0];
													 if(!curtypeid.equals(wfId)||!tempUser.equals(objId))	continue;		
												     workflowname=WorkflowAllComInfo.getWorkflowname(workflowid); 
													 String versionId = Util.null2String(wfVersionMap.get(workflowid));
													 if (!versionId.equals("")) {
															workflowname += "(V" +  versionId + ")";
													 }
												     String tempNodeCounts=""; 
												     String tempNodeIdSend="";
												     String tempNodeNameSend="";
												     int indexId=workFlowUserIds.indexOf(tempUser+"$"+workflowid);
												     if (indexId!=-1)
												     {
												      ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
													  ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
													  ArrayList nodeNameas=(ArrayList)nodeNames.get(indexId);
													  for (int l=0;l<nodeIda.size();l++)
													  {
													  tempNodeCounts+=nodeCounta.get(l)+",";
													  tempNodeIdSend+=nodeIda.get(l)+",";
													  tempNodeNameSend+=nodeNameas.get(l)+",";
													  }
												     }
												     String[] wfcountInfo = ((String)workflowcounts.get(k)).split(",");
												 %>

												<tr name="detail<%=i%>_">
													<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">	
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<span name="img<%=i%>_<%=j0%>" onclick="changeImg('img<%=i%>_<%=j0%>','detail<%=i%>_<%=j0%>')" style="cursor:hand">
															<IMG SRC="/images/-_wev8.png"  BORDER="0" HEIGHT="9px" WIDTH="9px"></img>
												    	</span>
												    	&nbsp;
														<a style="COLOR: #538DD5;" href="HandleTypeTimeAnalyse.jsp?tempNodeId=<%=tempNodeIdSend%>&tempCount=<%=tempNodeCounts%>&flowId=<%=workflowid%>&userId=<%=objId%>&subsqlstr=<%=xssUtil.put(subsqlstr)%>&tempNodeName=<%=java.net.URLEncoder.encode(tempNodeNameSend)%>" target="_newlist"><%=workflowname%>（<%=wfcountInfo[2]%>）</a>
													</td>
													<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"></td>
													<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"></td>
													<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"></td>
													<td style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"></td>
												</tr>
												<%
													if (indexId!=-1) {
														ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
														ArrayList nodeNamea=(ArrayList)nodeNames.get(indexId);
														ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
														for (int m=0;m<nodeIda.size();m++) {
															int indexIds = workFlowNodes.indexOf("" + nodeIda.get(m));
															float tv1 = Util.getFloatValue("" + nodeCounta.get(m));
															float tv2 = Util.getFloatValue("" + tempCountsx.get(indexIds));
															if (tv1 > maxAvg) {
																maxAvg = tv1;
															}
															if (tv2 > maxAvg) {
																maxAvg = tv2;
															}
												%>
														<TR name="detail<%=i%>_<%=j0%>">
															<TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=nodeNamea.get(m)%></TD>
															<TD style="text-align: right;border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">
																<span><%=handleRequestAnalsyeSort.getSpendsString("" + tv1)%></span>
															</TD>
															<TD title="<%=tv1%>" class="percent" style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">
																<div class="e8_outPercent" style="width:100%;border:#FFFFFF;display:inline-block;top:10%;">
																	<span class="e8_innerPercent" style=""></span>
																</div>
															</TD>
															<TD style="text-align: right;border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">
																<span><%=handleRequestAnalsyeSort.getSpendsString("" + tv2)%></span>
															</TD>
															<TD title="<%=tv2%>" class="percent" style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">
																<div class="e8_outPercent" style="width:100%;border:#FFFFFF;display:inline-block;top:10%;">
																	<span class="e8_innerPercent" style=""></span>
																</div>
															</TD>
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
													 }%>
													<%
													 wftypes.remove(j);
													 wfUsers.remove(j);
													 j--;
													}%>
												
										<%
										 }
										 }%>
										<!-- <%if(pagenum>1){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:frmMain.prepage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
						<button type=submit  style="display:none" class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
						<%}%>
						<%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:frmMain.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
						<button type=submit style="display:none" class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
						<%}%>
						-->
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

		function getObjWindowUrl() {
			var objType1 = jQuery('#objType').val();
			if (objType1 == 2) {
				var tmpids = document.all('objId').value;
				return "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
			} else if (objType1 == 3) {
				var tmpids = document.all('objId').value;
				return "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
			} else {
				return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $G('objId').value;
			}
		}

	  	function getFlowWindowUrl(){
			return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("typeId").value;
		}

		function onChangeType(){
			_writeBackData('objId', 1, {id:'',name:''});
			var img = jQuery("#objIdspanimg img");
			if(img.length == 0){
				jQuery("#objIdspanimg").append("<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
			}
		}

		function changeFlowType() {
			_writeBackData('flowId', 1, {id:'',name:''});
		}

		function submitData() {
			if (check_form($G("frmMain"),'objId'))
				$G("frmMain").submit();
		}
	
		function doExportExcel() {
		   jQuery("#loadingExcel").show();
		   var requestParam=getParamValues(frmMain);
		   document.getElementById("exportExcel").src="HandleRequestAnalsyeXLS.jsp?"+requestParam;
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
					spans.html("<IMG SRC='/images/-_wev8.png' BORDER=0 HEIGHT=9px WIDTH=9px></img>");
					trs.show();
				} else {
					spans.html("<IMG SRC='/images/+_wev8.png' BORDER=0 HEIGHT=9px WIDTH=9px></img>");
					trs.hide();
				}
			}
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
