
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanValuate" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.discuss.ExchangeHandler" %>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="customerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="meetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="exchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<!--<jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>-->
<HTML>
	<HEAD>
	<script type="text/javascript">
function toBreakWord(intLen, id){

 var obj=document.getElementsByName(id);
 for(var a =0;a<obj.length;a++){
 var strContent=obj[a].innerHTML;
 var strTemp="";
 while(strContent.length>intLen){
  strTemp+=strContent.substr(0,intLen)+"<br/>";
  strContent=strContent.substr(intLen,strContent.length);
 }
 strTemp+= strContent;
 obj[a].innerHTML=strTemp;
 }
 
}
  window.onload=function()
            {
                  toBreakWord(100,"hh");
                  
            }

</script>
	
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
	    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</HEAD>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String workID = Util.null2String(request.getParameter("workid"));
	String userID = String.valueOf(user.getUID());
	String from = Util.null2String(request.getParameter("from"));
	boolean canView = false;
	boolean canEdit = false;

	int shareLevel=WorkPlanShareUtil.getShareLevel(workID,user);
	if(shareLevel>-1){
		canView = true;
		if(shareLevel==2){
			canEdit = true;
		}
	}

	if (!canView)
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
    PoppupRemindInfoUtil.updatePoppupRemindInfo(Util.getIntValue(userID),12,"0",Util.getIntValue(workID));
	PoppupRemindInfoUtil.updatePoppupRemindInfo(Util.getIntValue(userID),13,"0",Util.getIntValue(workID));
	boolean canFinish = false;
	boolean canValuate = false;
	boolean canConvert = false;

	String selectUser = Util.null2String(request.getParameter("selectuser"));
	String selectDate = Util.null2String(request.getParameter("selectdate"));
	String viewType = Util.null2String(request.getParameter("viewtype"));
	String workPlanType = Util.null2String(request.getParameter("workplantype"));
	String workPlanStatus = Util.null2String(request.getParameter("workplanstatus"));
	int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);

	String type_n = "";
	String workPlanTypeName = "" ;
	String planName = "" ;
	String memberIDs = "";
	String beginDate = "";
	String beginTime = "";
	String endDate = "";
	String endTime = "";
	String description = "";
	String location = ""; //地图位置
	String requestIDs = "";
	String projectIDs = "";
	String taskIDs = "";
	String crmIDs = "";
	String docIDs = "";
	String meetingIDs = "";
	String status = "";
	String isRemind = "";
	String deleted = "";
	String createrID = "";
	String urgentLevel = "";
	int wakeTime = 0;
	String unitType = "1";
	float remindValue = 0;
	
	String remindType = "";  //日程提醒方式
	String remindBeforeStart = "";  //是否开始前提醒
	String remindBeforeEnd = "";  //是否结束前提醒
	String remindTimesBeforeStart = "";  //开始前提醒时间数
	String remindTimesBeforeEnd = "";  //结束前提醒时间数
	String remindDateBeforeStart = "";  //开始前提醒日期
	String remindTimeBeforeStart = "";  //开始前提醒时间
	String remindDateBeforeEnd = "";  //结束前提醒日期
	String remindTimeBeforeEnd = "";  //结束前提醒时间
	
	String hrmPerformanceCheckDetailTargetName = "";  //自定义考核叶子节点名称
	String createrType = ""; 
			
	String sql = "SELECT a.*, hrmPerformanceCheckDetail.targetName FROM "
		+ " (SELECT workPlan.*, workPlanType.workPlanTypeName "
	    + " FROM WorkPlan workPlan, WorkPlanType workPlanType "
	    + " WHERE workPlan.type_n = workPlanType.workPlanTypeID "
	    + " AND workPlan.ID = " + workID
	    + " ) a "
	    + " LEFT JOIN HrmPerformanceCheckDetail hrmPerformanceCheckDetail "
	    + " ON a.hrmPerformanceCheckDetailID = hrmPerformanceCheckDetail.ID";

	rs.executeSql(sql);
	
	if (rs.next()) 
	{
	    type_n = Util.null2String(rs.getString("type_n"));
	    workPlanTypeName = Util.forHtml(Util.null2String(rs.getString("workPlanTypeName")));
		planName = Util.forHtml(Util.null2String(rs.getString("name")).replaceAll("'","\\'"));
		memberIDs = Util.null2String(rs.getString("resourceID"));
		beginDate = Util.null2String(rs.getString("begindate"));
		beginTime = Util.null2String(rs.getString("begintime"));
		endDate = Util.null2String(rs.getString("enddate"));
		endTime = Util.null2String(rs.getString("endtime"));
		description = Util.null2String(rs.getString("description")).replaceAll("'","\\'");
		if(description.indexOf("<br>")==-1)
			description = Util.forHtml(description);
		location = Util.null2String(rs.getString("location"));
		requestIDs = Util.null2String(rs.getString("requestID"));
		projectIDs = Util.null2String(rs.getString("projectID"));
		taskIDs = Util.null2String(rs.getString("taskID"));
		crmIDs = Util.null2String(rs.getString("crmID"));
		docIDs = Util.null2String(rs.getString("docID"));
		meetingIDs = Util.null2String(rs.getString("meetingID"));
		status = Util.null2String(rs.getString("status"));
		isRemind = Util.null2String(rs.getString("isremind"));
		wakeTime = Util.getIntValue(rs.getString("waketime"), 0);
		deleted = Util.null2String(rs.getString("deleted"));
		createrID = Util.null2String(rs.getString("createrID"));
		urgentLevel = Util.null2String(rs.getString("urgentLevel"));

		remindType = Util.null2String(rs.getString("remindType"));
		remindBeforeStart = Util.null2String(rs.getString("remindBeforeStart"));
		remindBeforeEnd = Util.null2String(rs.getString("remindBeforeEnd"));
		remindTimesBeforeStart = Util.null2String(rs.getString("remindTimesBeforeStart"));
		remindTimesBeforeEnd = Util.null2String(rs.getString("remindTimesBeforeEnd"));
		remindDateBeforeStart = Util.null2String(rs.getString("remindDateBeforeStart"));
		remindTimeBeforeStart = Util.null2String(rs.getString("remindTimeBeforeStart"));
		remindDateBeforeEnd = Util.null2String(rs.getString("remindDateBeforeEnd"));
		remindTimeBeforeEnd = Util.null2String(rs.getString("remindTimeBeforeEnd"));
		
		hrmPerformanceCheckDetailTargetName = Util.null2String(rs.getString("targetName"));
		createrType = Util.null2String(rs.getString("createrType"));
	}

	String valMembers = "";
	boolean existUnderling = false;
	if (status.equals("0"))
	{
		valMembers = memberIDs;
	}

	//判断是否存在下属
	if (status.equals("1")) 
	{
		WorkPlanValuate workPlanValuate = new WorkPlanValuate();
		workPlanValuate.setManager(Integer.parseInt(userID));
		valMembers = workPlanValuate.checkUnderling(memberIDs);
		if (valMembers != null)
		{
			existUnderling = true;
		}
	}

	if (status.equals("0") && (canEdit || memberIDs.indexOf(userID) != -1))
	{
		canFinish = true;
	}

	if (!status.equals("0"))
	{
		canEdit = false;
	}

	if (status.equals("1") && existUnderling && !type_n.equals("4"))
	{
	    canValuate = true;
	}

	if (type_n.equals("4") && status.equals("0") && userID.equals(createrID))
	{
	    canConvert = true;
	}

	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage()) + ":&nbsp;" + SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav ="";
	String needhelp ="";
%>

<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if (canFinish)
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(22177,user.getLanguage())+",javascript:doFinish(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	if (canEdit) 
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;		
	}

	if (canConvert) 
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(17508,user.getLanguage())+",javascript:doConvert(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	if (status.equals("1") && existUnderling && type_n.equals("4")) 
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+",javascript:doValuate(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(createrID.equals(""+userID))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doShare(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17480,user.getLanguage())+",javascript:onViewLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17481,user.getLanguage())+",javascript:onEditLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+",javascript:window.close(),_self} " ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="schedule"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<%
			if (canEdit) 
			{%>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="doEdit()">
			<%}
			
			if (canFinish)
			{ %>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(22177, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="doFinish()">
			<%}

			

			if (canConvert) 
			{%>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(17508, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="doConvert()">
			<%}

			if (status.equals("1") && existUnderling && type_n.equals("4")) 
			{%>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="doValuate()">
			<%}
			if(createrID.equals(""+userID))
			{%>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(119, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="doShare()">
			<%}
			if (canEdit) 
			{%>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="doDelete()">
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<FORM name="frmmain" action="/workplan/data/WorkPlanOperation.jsp" method="post">
	<INPUT type="hidden" name="method" value="view">
	<INPUT type="hidden" name="from" value="<%=from%>">
	<INPUT type="hidden" name="frm" value="cal">
	<INPUT type="hidden" name="workid" value="<%=workID%>">
	<INPUT type="hidden" name="status" value="<%=status%>" >
	<INPUT type="hidden" name="selectDate" value="<%=selectDate%>">
	<INPUT type="hidden" name="selectUser" value="<%=selectUser%>">
	<INPUT type="hidden" name="viewType" value="<%=viewType%>">
	<INPUT type="hidden" name="workPlanType" value="<%=workPlanType%>">
	<INPUT type="hidden" name="workPlanStatus" value="<%=workPlanStatus%>">
	<INPUT type="hidden" name="pageNum" value="<%=pagenum%>">

	<INPUT type="hidden" name="valMembers">
	<INPUT type="hidden" name="valScores">
</FORM>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
       	<!--================ 日程类型  ================-->
          	<wea:item><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></wea:item>
          	<wea:item><%= workPlanTypeName %></wea:item>
		<!--================ 日程标题  ================-->
        	<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
          	<wea:item><%=planName%></wea:item>
		<!--================ 考核项  ================-->
		<!-- TR>
			<TD><%//=SystemEnv.getHtmlLabelName(18064,user.getLanguage())%></TD>
		  	<TD class="Field"><%//= hrmPerformanceCheckDetailTargetName %></TD>
		</TR>
		<TR>
			<TD class="Line" colSpan="2"></TD>
		</TR -->

		<!--================ 紧急程度  ================-->
          	<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
          	<wea:item>
          	<%
          		if (urgentLevel.equals("1")) 
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
		  	<%
		  		}
          		else if (urgentLevel.equals("2")) 
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
		  	<%
		  		}
          		else 
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
		  	<%
		  		}
		  	%>
		  	</wea:item>
		<!--================ 日程提醒方式  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></wea:item>
			<wea:item>
			<%
				if("1".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
			<%
				}
				else if("2".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
			<%
				}
				else if("3".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			<%
				}
			%>
			</wea:item>
		
		<%
			if(!"1".equals(remindType))
			{
		%>
		<!--================= 日程提醒时间 =================-->
          	<wea:item><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></wea:item>
          	<wea:item>
     		<%
     			if("1".equals(remindBeforeStart))
     			{	int temmhour=Util.getIntValue(remindTimesBeforeStart,0)/60;
		            int temptinme=Util.getIntValue(remindTimesBeforeStart,0)%60;
     		%>
          		<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
                   <%= temmhour %>
				<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<%= temptinme %>
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				&nbsp&nbsp&nbsp
			<%
     			}
	     		if("1".equals(remindBeforeEnd))
	 			{   int temmhour=Util.getIntValue(remindTimesBeforeEnd,0)/60;
		            int temptinme=Util.getIntValue(remindTimesBeforeEnd,0)%60;
			%>
				<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
				 <%= temmhour %>
				<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<%= temptinme %>
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			<%
	 			}
			%>
          	</wea:item>
		<%
			}
		%>
		<%if (!user.getLogintype().equals("2")){ %>
          	<wea:item><%=SystemEnv.getHtmlLabelName(787,user.getLanguage())%></wea:item>
          	<wea:item>
          		<%if(!createrType.equals("") && createrType.equals("1")){%>
          			<A style="CURSOR: hand;" href="/hrm/resource/HrmResource.jsp?id=<%=createrID%>" target='_blank'><%=resourceComInfo.getResourcename(createrID)%></A>
          		<%}else{%>
          			<A style="CURSOR: hand;" href="/hrm/resource/HrmResource.jsp?id=<%=createrID%>" target='_blank'><%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(createrID),user.getLanguage())%></A>
          		<%}%>
          	</wea:item>

          	<wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></wea:item>
          	<wea:item>
			<%
				if (!memberIDs.equals("")) 
				{
					ArrayList members = Util.TokenizerString(memberIDs,",");
					for (int i = 0; i < members.size(); i++) 
					{
			%>
					<%if(!createrType.equals("") && createrType.equals("1")){%>
          				<A style="CURSOR: hand;" href='/hrm/resource/HrmResource.jsp?id=<%=""+members.get(i)%>' target='_blank'><%=resourceComInfo.getResourcename(""+members.get(i))%></A>&nbsp;
	          		<%}else{%>
	          			<A style="CURSOR: hand;" href='/hrm/resource/HrmResource.jsp?id=<%=""+members.get(i)%>' target='_blank'><%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(""+members.get(i)),user.getLanguage())%></A>&nbsp;
	          		<%}%>
					
			<%		}
				}
			%>
		 	</wea:item>
        <%}else{ %>
          	<wea:item><%=SystemEnv.getHtmlLabelName(787,user.getLanguage())%></wea:item>
          	<wea:item>
          	    <A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=createrID%>" target='_blank'>
					<%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(createrID),user.getLanguage())%></A>
          	</wea:item>

          	<wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></wea:item>
          	<wea:item>
			<A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=createrID%>" target='_blank'>
					<%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(createrID),user.getLanguage())%></A>
		 	</wea:item>
        <%} %>

			<wea:item><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
          	<wea:item><%=beginDate%>&nbsp;&nbsp;&nbsp;<%=beginTime%>
		  	</wea:item>

          	<wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
          	<wea:item>
          		<%=endDate%>&nbsp;&nbsp;&nbsp;<%=endTime%>
		  	</wea:item>

          	<wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
          	<wea:item>
          		<%=description%>
          	</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(22078, user.getLanguage())%>' >
		<%if(isgoveproj==0){%>
          	<wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
          	<wea:item>
			<%
				if (!crmIDs.equals("")) 
				{
					ArrayList crms = Util.TokenizerString(crmIDs,",");
					for (int i = 0; i < crms.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+crms.get(i)%>' target='_blank'><%=customerInfoComInfo.getCustomerInfoname(""+crms.get(i))%></A>&nbsp;
			<%	
					}
				}
			%>
		  	</wea:item>
		<%}%>
          	<wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
          	<wea:item>
			<%
				if (!docIDs.equals(""))
				{
					ArrayList docs = Util.TokenizerString(docIDs,",");
					for (int i = 0; i < docs.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/docs/docs/DocDsp.jsp?id=<%=""+docs.get(i)%>' target='_blank'><%=docComInfo.getDocname(""+docs.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
		  	</wea:item>

		<%if(isgoveproj==0){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
			<wea:item>
			<%
				if (!projectIDs.equals("")) 
				{
					ArrayList projects = Util.TokenizerString(projectIDs,",");
					for (int i = 0; i < projects.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/proj/data/ViewProject.jsp?ProjID=<%=""+projects.get(i)%>' target='_blank'><%=projectInfoComInfo.getProjectInfoname(""+projects.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></wea:item>
			<wea:item>
			<%
				if (!taskIDs.equals("")&&!taskIDs.equals("0")) 
				{
					ArrayList tasks = Util.TokenizerString(taskIDs,",");
					for (int i = 0; i < tasks.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/proj/process/ViewTask.jsp?taskrecordid=<%=""+tasks.get(i)%>' target='_blank'><%=ProjectTaskApprovalDetail.getTaskSuject(tasks.get(i).toString())%>(<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+ProjectTaskApprovalDetail.getProjectNameByTaskId(tasks.get(i).toString())%>)</A>&nbsp;
			<%
					}
				}
			%>
			</wea:item>

		<%}%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item>
			<wea:item>
			<%
				if (!requestIDs.equals("")) 
				{
					ArrayList requests = Util.TokenizerString(requestIDs,",");
					for (int i = 0; i < requests.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href="/workflow/request/ViewRequest.jsp?requestid=<%=requests.get(i)%>" target='_blank'><%=requestComInfo.getRequestname(""+requests.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
			</wea:item>

			<wea:item><%=SystemEnv.getHtmlLabelName(926,user.getLanguage())%></wea:item>
			<wea:item>
			<%
				if (!meetingIDs.equals("")) 
				{
					ArrayList meetings = Util.TokenizerString(meetingIDs,",");
					for (int i = 0; i < meetings.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/meeting/data/ProcessMeeting.jsp?meetingid=<%=""+meetings.get(i)%>' target='_blank'><%=meetingComInfo.getMeetingInfoname(""+meetings.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
			</wea:item>
        </wea:group>
	</wea:layout>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="dialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%
	//write "view" of view log.
	String[] logParams;
	WorkPlanLogMan logMan = new WorkPlanLogMan();
	logParams = new String[] 
	{
	        workID,
			WorkPlanLogMan.TP_VIEW,
			userID,
			request.getRemoteAddr()
	};
	
	logMan.writeViewLog(logParams);
	//end
	
	//reset the exchange flag.
	int[] viewParams = new int[] {Integer.parseInt(workID), Integer.parseInt(userID)};
	
	exchange.exchangeView(viewParams);
%>
<SCRIPT LANGUAGE="JavaScript">
var dialog = parent.getDialog(window);
function btn_cancle(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

function doEdit() {
	document.frmmain.action = "/workplan/calendar/data/WorkPlanEditCal.jsp";
	document.frmmain.submit();
}

function doFinish() {
		<%if (userID.equals(createrID)) {%>
		$GetEle("method").value = "notefinish";
	    <%} else {%>
		$GetEle("method").value = "finish";
		<%}%>
		document.frmmain.submit();

}

function doValuate() {
    <%if (!type_n.equals("4")) {%>
	    onShowValuate();
    <%} else {%>
        $GetEle("method").value = "notefinish";
		document.frmmain.submit();
    <%}%>
}

function doConvert() {
	$GetEle("method").value = "convert";
	document.frmmain.submit();
}

function doDelete() {
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>", function (){
			$GetEle("method").value = "delete";
			document.frmmain.submit();
		}, function () {}, 320, 90,false);
}

function doShare() {
	document.frmmain.action = "/workplan/share/WorkPlanShare.jsp?frm=cal&planID=<%=workID%>";
	document.frmmain.submit();
}

function doSave1() {
	if (check_form(document.Exchange,"ExchangeInfo"))
		document.Exchange.submit();
}

function displaydiv_1() {
	if (WorkFlowDiv.style.display == "") {
		WorkFlowDiv.style.display = "none";
		WorkFlowspan.innerHTML = "<a href='#' onClick='displaydiv_1()'><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
	} else {
		WorkFlowspan.innerHTML = "<a href='#' onClick='displaydiv_1()'><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowDiv.style.display = "";
	}
}

function onViewLog() {
	document.frmmain.action = "/workplan/log/WorkPlanViewLog.jsp?frm=cal&workid=<%=workID%>";
	document.frmmain.submit();
}

function onEditLog() {
	document.frmmain.action = "/workplan/log/WorkPlanEditLog.jsp?frm=cal&workid=<%=workID%>";
	document.frmmain.submit();
}
function showLocation(gps,nowtime){
		
		var diag = new Dialog();
	    diag.Modal = true;
	    diag.Drag=true;
		diag.Width = 620;
		diag.Height = 420;
		diag.ShowButtonRow=false;
		diag.Title ='<%=SystemEnv.getHtmlLabelNames("82639,33555",user.getLanguage())%>';

		diag.URL = "/mobile/plugin/crm/CrmShowLocation.jsp?gps="+gps+"&nowtime="+nowtime; 
	    diag.show();
}
jQuery(document).ready(function(){
	resizeDialog(document);
});
</SCRIPT>

</BODY>
</HTML>
