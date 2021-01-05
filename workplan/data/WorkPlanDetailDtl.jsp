
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.WorkPlan.MutilUserUtil"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="weaver.WorkPlan.WorkPlanShare"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanValuate" %>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.discuss.ExchangeHandler" %>

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
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="WorkPlanSetInfo"	class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
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
<%!
public String guoHtml(String s){
	if(!s.equals("")||s!=null){
		String str=s.replaceAll("<[.[^<]]*>","");
		return str;
	}else{
		return s;
	}
} 

%>
<% 
String customerid = Util.null2String(request.getParameter("customerid"));//是否来源于客户模块
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String workID = Util.null2String(request.getParameter("workid")).trim();
	String tabType=request.getParameter("tabType");
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
	
	//System.out.println("canEdit:"+canEdit);
	if(!canView){
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel>0){
			canView=true;
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
	boolean canShare=false;
	boolean belongshow=MutilUserUtil.isShowBelongto(user);
	
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
	String attachs="";
	
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
		description = Util.StringReplace(description, "<br>",""+'\n');
		description = Util.StringReplace(description, "</p>",""+'\n');
		description=guoHtml(description);
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
		attachs=Util.null2String(rs.getString("attachs"));
		hrmPerformanceCheckDetailTargetName = Util.null2String(rs.getString("targetName"));
		createrType = Util.null2String(rs.getString("createrType"));
	}
	String share_user=user.getUID()+"";
	if(createrID.equals(""+user.getUID())){//创建人
		canShare=true;
	}else{
		if(WorkPlanShare.SHARE_TYPE==2){
			if((","+memberIDs+",").indexOf(","+userID+",")>-1){//参会人员
				canShare=true;
			}
		}
	}
	//主次账号,各种权限操作用户处理开始
	String finish_user=user.getUID()+"";
	String edit_del_user=user.getUID()+"";
	boolean belongFinish=false;
	if(belongshow){
		String belongs=user.getBelongtoids();
		if(!"".equals(belongs)){
			String[] belongids=belongs.split(",");
			for(int i=0;i<belongids.length;i++){
				if(!"".equals(belongids[i])&&(","+memberIDs+",").indexOf(","+belongids[i]+",")>-1){//参会人员
					belongFinish=true;
					finish_user=belongids[i];
					break;
				}
			}
		}
		
		Map<String,Integer> map=WorkPlanShareUtil.getAllUserShareLevel(workID,user);
		if(map!=null&&map.size()>1){
			if(map.containsKey(createrID)){//创建者属于次账号
				finish_user=createrID;
			}
			if(map.get(user.getUID()+"")<2){//操作者没有编辑权限,次账号有编辑权限
				for (Entry<String,Integer> entry : map.entrySet()) {
					if(entry.getValue()==2){
						edit_del_user=entry.getKey();
						break;
					}
				}
			}
			 
		}
		
		
		if(!canShare){
			if(WorkPlanShare.SHARE_TYPE==2){
				belongs=user.getBelongtoids();
				if(!"".equals(belongs)){
					String[] belongids=belongs.split(",");
					for(int i=0;i<belongids.length;i++){
						if(!"".equals(belongids[i])&&(","+memberIDs+",").indexOf(","+belongids[i]+",")>-1){//参会人员
							canShare=true;
							share_user=belongids[i];
							break;
						}
					}
				}
			}
		}
	}
	//主次账号,各种权限操作用户处理结束
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

	if (status.equals("0") && (canEdit || (","+memberIDs+",").indexOf(","+userID+",") != -1||belongFinish))
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
	//System.out.println(memberIDs);
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage()) + ":&nbsp;" + SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav ="";
	String needhelp ="";
%>

<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/cowork/uploader.jsp" %>
<%
	if (canFinish)
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:doFinish(),_self} " ;
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
	if(canShare)
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
					value="<%=SystemEnv.getHtmlLabelName(555, user.getLanguage())%>"
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
			if(canShare)
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
	<INPUT type="hidden" name="workid" value="<%=workID%>">
	<INPUT type="hidden" name="status" value="<%=status%>" >
	<INPUT type="hidden" name="selectDate" value="<%=selectDate%>">
	<INPUT type="hidden" name="selectUser" value="<%=selectUser%>">
	<INPUT type="hidden" name="viewType" value="<%=viewType%>">
	<INPUT type="hidden" name="workPlanType" value="<%=workPlanType%>">
	<INPUT type="hidden" name="workPlanStatus" value="<%=workPlanStatus%>">
	<INPUT type="hidden" name="pageNum" value="<%=pagenum%>">
	<INPUT type="hidden" id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=finish_user%>">

	<INPUT type="hidden" name="valMembers">
	<INPUT type="hidden" name="valScores">
</FORM>
<div id="nomalDiv" style="display:<%=!"2".equals(tabType)?"":"none" %>">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
		<!--================ 日程标题  ================-->
        	<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}"><%=planName%></wea:item>
       	<!--================ 日程类型  ================-->
          	<wea:item><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></wea:item>
          	<wea:item><%= workPlanTypeName %></wea:item>
		

		<!--================ 紧急程度  ================-->
          	<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
          	<wea:item>
          	
		  	<%
          		if (urgentLevel.equals("2")) 
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
		  	<%
		  		}
          		else if(urgentLevel.equals("3")) 
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
		  	<%
		  		}
		  		else
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
		  	<%  } %>	
		  	</wea:item>
		  	
		  	<wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}">
          		<%=description%>
          		<%if(!location.equals("")){%>
		    	&nbsp;&nbsp;<a href='javascript:return false' onclick="showLocation('<%=location%>','<%=beginTime%>');return false;"><img src='/blog/images/location_icon_1_wev8.png' border='0'/><%=SystemEnv.getHtmlLabelNames("82639,22981", user.getLanguage())%></a>
		   <%}%>
          	</wea:item>

		<%if (!user.getLogintype().equals("2")){ %>
          	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}">
          		<%if(!createrType.equals("") && createrType.equals("1")){%>
          			<A style="CURSOR: hand;" href="/hrm/resource/HrmResource.jsp?id=<%=createrID%>" target='_blank'><%=resourceComInfo.getResourcename(createrID)%></A>
          		<%}else{%>
          			<A style="CURSOR: hand;" href="/hrm/resource/HrmResource.jsp?id=<%=createrID%>" target='_blank'><%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(createrID),user.getLanguage())%></A>
          		<%}%>
          	</wea:item>

          	<wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}">
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
          	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}">
          	    <A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=createrID%>" target='_blank'>
					<%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(createrID),user.getLanguage())%></A>
          	</wea:item>

          	<wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}">
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
		  	<%if(WorkPlanSetInfo.getShowRemider()==1||!"1".equals(remindType)){ %>
			<!--================ 日程提醒方式  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></wea:item>
			<wea:item attributes="{'colspan':'full'}">
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
			<%} %>
		<%
			if(!"1".equals(remindType))
			{
		%>
		<!--================= 日程提醒时间 =================-->
          	<wea:item><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}">
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
          	

			<%if (!crmIDs.equals("")){ %>
          	<wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}">
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
		  	<%} %>

		  <%if (!docIDs.equals("")){ %>
          	<wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
          	<wea:item attributes="{'colspan':'full'}">
			<%
				if (!docIDs.equals(""))
				{
					ArrayList docs = Util.TokenizerString(docIDs,",");
					for (int i = 0; i < docs.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/docs/docs/DocDsp.jsp?id=<%=""+docs.get(i)%>&workplanid=<%=workID %>' target='_blank'><%=docComInfo.getDocname(""+docs.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
		  	</wea:item>
		  <%} %>
		  
		 
		   <%if (!projectIDs.equals("")) { %>
			<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
			<wea:item attributes="{'colspan':'full'}">
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
		  <%} %>
		  <%if (!taskIDs.equals("")&&!taskIDs.equals("0")) { %>
			<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></wea:item>
			<wea:item attributes="{'colspan':'full'}">
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
		   <%} %>

		<%if (!requestIDs.equals("")) { %>
			<wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item>
			<wea:item attributes="{'colspan':'full'}">
			<%
				if (!requestIDs.equals("")) 
				{
					ArrayList requests = Util.TokenizerString(requestIDs,",");
					for (int i = 0; i < requests.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href="/workflow/request/ViewRequest.jsp?fromModul=workplan&modulResourceId=<%=workID %>&requestid=<%=requests.get(i)%>" target='_blank'><%=requestComInfo.getRequestname(""+requests.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
			</wea:item>
         <%} %>
         <%if (!meetingIDs.equals("")) { %>
			<wea:item><%=SystemEnv.getHtmlLabelName(926,user.getLanguage())%></wea:item>
			<wea:item attributes="{'colspan':'full'}">
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
		<%}if(WorkPlanSetInfo.getInfoaccessory()==1){%>
		<!--================ 相关附件  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></wea:item>
			<wea:item>
			<TABLE class=viewForm>
				<TBODY>
						<%
						ArrayList arrayaccessorys = Util.TokenizerString(attachs,",");
						for(int i=0;i<arrayaccessorys.size();i++)
						{
							String accessoryid = (String)arrayaccessorys.get(i);
							//System.out.println("accessoryid : "+accessoryid);
							if(accessoryid.equals(""))
							{
								continue;
							}
							rs.executeSql("select id,docsubject,accessorycount from docdetail where id="+accessoryid);
							int linknum=-1;
							if(rs.next())
							{
					  %>
						<TR CLASS=DataDark>
							<td class=field>
					  <%
								linknum++;
								String showid = Util.null2String(rs.getString(1)) ;
								String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
								int accessoryCount=rs.getInt(3);
				
								DocImageManager.resetParameter();
								DocImageManager.setDocid(Integer.parseInt(showid));
								DocImageManager.selectDocImageInfo();
				
								String docImagefileid = "";
								long docImagefileSize = 0;
								String docImagefilename = "";
								String fileExtendName = "";
								int versionId = 0;
				
								if(DocImageManager.next())
								{
									//DocImageManager会得到doc第一个附件的最新版本
									docImagefileid = DocImageManager.getImagefileid();
									docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
									docImagefilename = DocImageManager.getImagefilename();
									fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
									versionId = DocImageManager.getVersionId();
								}
								if(accessoryCount>1)
								{
									fileExtendName ="htm";
								}
								String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
						%>
								<%=imgSrc%>
								<%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("ppt")||fileExtendName.equalsIgnoreCase("pptx")||fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")))
								{
								%>
								<a style="cursor:hand" href='javascript:void(0)' onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp;
					  <%
								}
								else
								{
					  %>
								<a style="cursor:hand" href='javascript:void(0)' onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp;
					  <%
								}
								if(accessoryCount==1)
								{
					  %>
							  <span id = "selectDownload">
								<%
								  //boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
								  //if(!isLocked){
								%>
								  &nbsp;<a href='javascript:void(0)'  onclick="downloads('<%=docImagefileid%>');return false;" class='relatedLink'><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>(<%=(docImagefileSize/1000)%>K)</a>
								<%//}%>
							  </span>	
						</td>
					</tr>
					
					<%
								}
							}
						}
					%>
				 </TBODY>
			 </TABLE>
			</wea:item>
		<%}%>
        </wea:group>
	</wea:layout>
</div>
<!--相关交流-->
<div id="discussDiv" style="display:<%="2".equals(tabType)?"":"none" %>">
<% String types = "WP";
   String sortid =  workID;
 %>
<%@ include file="/meeting/data/MeetingDiscuss.jsp" %>
</div>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value='<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>'
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
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
			Util.getIpAddr(request)
	};
	logMan.setUserType(""+user.getLogintype());
	logMan.writeViewLog(logParams);
	//end
	
	//reset the exchange flag.
	int[] viewParams = new int[] {Integer.parseInt(workID), Integer.parseInt(userID)};
	
	exchange.exchangeView(viewParams);
%>
<SCRIPT LANGUAGE="JavaScript">
var diag_vote;
function showDialog(url, title, w,h){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = w;
	diag_vote.Height = h;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}
function btn_cancle(){
	parent.btn_cancle();
}

function doEdit() {
	parent.doEdit("<%=edit_del_user%>");
}


function doFinish() {
		<%if (userID.equals(createrID)||finish_user.equals(createrID)) {%>
			$GetEle("method").value = "notefinish";
			document.frmmain.submit();
	    <%} else {%>
	    	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126173,user.getLanguage())%>", function (){
				$GetEle("method").value = "finish";
				document.frmmain.submit();
			}, function(){}, 320, 90,false);
		<%}%>
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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>", function (){
			jQuery('#f_weaver_belongto_userid').val("<%=edit_del_user%>");
			$GetEle("method").value = "delete";
			document.frmmain.submit();
		});
}

function doShare() {
	parent.doShare("<%=share_user%>");
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
	parent.onViewLog();
}

function onEditLog() {
	parent.onEditLog();
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
	if("<%=tabType%>"=="2"){
		resetDiv();
	}
});
function downloads(files)
{
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&workplanid="+<%=workID%>;

}
function opendoc(showid,versionid,docImagefileid)
{
	openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&workplanid=<%=workID%>");
}
function opendoc1(showid)
{
	openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&workplanid="+<%=workID%>);
}
</SCRIPT>

</BODY>
</HTML>
