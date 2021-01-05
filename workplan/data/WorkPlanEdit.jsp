
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.WorkPlan.MutilUserUtil"%> 

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/cowork/uploader.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.file.FileUpload" %>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="WorkPlanSetInfo"	class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />

<!--<jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>-->
<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	<STYLE>
		.vis1	{ visibility:"visible" }
		.vis2	{ visibility:"hidden" }
	</STYLE>
	<SCRIPT language="javascript" src="/js/workplan/workplan_wev8.js"></script>
<!--swfupload相关-->
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
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


//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String workID = Util.null2String(request.getParameter("workid"));
	String from = Util.null2String(request.getParameter("from"));
	String userID = String.valueOf(user.getUID());
	String userType = user.getLogintype();
	
	String method = "add";
	int intWpid = Util.getIntValue(workID, -1);
	
	String logintype = user.getLogintype();
	int userid=user.getUID();
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	boolean canView = false;
	boolean canEdit = false;

	String selectUser = Util.null2String(request.getParameter("selectUser"));
	String selectDate = Util.null2String(request.getParameter("selectDate"));
	String viewType = Util.null2String(request.getParameter("viewType"));
	String workPlanType = Util.null2String(request.getParameter("workPlanType"));
	String workPlanStatus = Util.null2String(request.getParameter("workPlanStatus"));
	
	String type_n = Util.null2String(request.getParameter("type_n")) ;
	String planName = "" ;
	String memberIDs = Util.null2String(request.getParameter("resourceid"));
	String beginDate = "";
	String beginTime = "";
	String endDate = "";
	String endTime = "";
	String description = Util.null2String(request.getParameter("description"));
	String requestIDs = "";
	String projectIDs = Util.null2String(request.getParameter("projectid"));
	String crmIDs = Util.null2String(request.getParameter("crmid"));
	String docIDs = Util.null2String(request.getParameter("docid"));
	String attachs = Util.null2String(request.getParameter("attachs"));
	String taskIDs = "";
	String meetingIDs = "";
	String status = "";
	String isRemind = "";
	String deleted = "";
	String createrID = "";
	String createrType = "";
	String urgentLevel = "";
	int wakeTime = 0;
	String unitType = "1";
	float remindValue = 0;
	
	String remindType = ""+WorkPlanSetInfo.getDefaultRemider();  //日程提醒方式
	String remindBeforeStart = "";  //是否开始前提醒
	String remindBeforeEnd = "";  //是否结束前提醒
	String remindTimesBeforeStart = "";  //开始前提醒时间数
	String remindTimesBeforeEnd = "";  //结束前提醒时间数
	String remindDateBeforeStart = "";  //开始前提醒日期
	String remindTimeBeforeStart = "";  //开始前提醒时间
	String remindDateBeforeEnd = "";  //结束前提醒日期
	String remindTimeBeforeEnd = "";  //结束前提醒时间
	String secId=WorkPlanSetInfo.getInfoaccessorydir();
	String maxsize="";
		
		if(!secId.equals(""))
		{
			rs.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
			rs.next();
		    maxsize = Util.null2String(rs.getString(1));
		} 
	String hrmPerformanceCheckDetailID = "";  //自定义考核叶子节点ID
	String  attachsJson="[]";
	if(intWpid > 0){
		method = "edit";
		int shareLevel=WorkPlanShareUtil.getShareLevel(workID,user);
		if(shareLevel>-1){
			canView = true;
			if(shareLevel==2){
				canEdit = true;
			}
		}
		
		if (!canEdit)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		String sql = "SELECT * FROM WorkPlan WHERE id = " + workID;
		
		rs.executeSql(sql);
		if (rs.next()) 
		{
			type_n = Util.null2String(rs.getString("type_n"));
			planName = Util.forHtml(Util.null2String(rs.getString("name")));
			memberIDs = Util.null2String(rs.getString("resourceID"));
			beginDate = Util.null2String(rs.getString("beginDate"));
			beginTime = Util.null2String(rs.getString("beginTime"));
			endDate = Util.null2String(rs.getString("endDate"));
			endTime = Util.null2String(rs.getString("endTime"));
			description = Util.null2String(rs.getString("description"));
			description = Util.StringReplace(description, "<br>",""+'\n');
			description = Util.StringReplace(description, "</p>",""+'\n');
			description=guoHtml(description);
	    	if(description.indexOf("<br>")==-1)
				description = Util.forHtml(description);
			requestIDs = Util.null2String(rs.getString("requestID"));
			projectIDs = Util.null2String(rs.getString("projectID"));
			crmIDs = Util.null2String(rs.getString("crmID"));
			docIDs = Util.null2String(rs.getString("docID"));
			meetingIDs = Util.null2String(rs.getString("meetingID"));
			status = Util.null2String(rs.getString("status"));
			isRemind = Util.null2String(rs.getString("isRemind"));
			wakeTime = Util.getIntValue(rs.getString("wakeTime"), 0);
			deleted = Util.null2String(rs.getString("deleted"));
			createrID = Util.null2String(rs.getString("createrID"));
			urgentLevel = Util.null2String(rs.getString("urgentLevel"));
			createrType = Util.null2String(rs.getString("createrType"));
		    taskIDs = Util.null2String(rs.getString("taskID"));
		    
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
			hrmPerformanceCheckDetailID = Util.null2String(String.valueOf(rs.getInt("hrmPerformanceCheckDetailID")));
		    
			if (isRemind.equals("2") && wakeTime > 0) 
			{
				BigDecimal b1 = new BigDecimal(wakeTime);
		
				if (wakeTime >= 1440) 
				{
					BigDecimal b2 = new BigDecimal("1440");
					remindValue = b1.divide(b2, 1, BigDecimal.ROUND_HALF_UP).floatValue();
					unitType = "2";
				}
				else 
				{
					BigDecimal b2 = new BigDecimal("60");
					remindValue = b1.divide(b2, 1, BigDecimal.ROUND_HALF_UP).floatValue();
				}
			}
		}
	} else {
		
		int timeRangeStart=0;
		int timeRangeEnd=23;
		rs.executeSql("select * from WorkPlanSet order by id");
		if(rs.next()){
			timeRangeStart	= Util.getIntValue(rs.getString("timeRangeStart"), 0);
			timeRangeEnd	= Util.getIntValue(rs.getString("timeRangeEnd"), 23);
		}
		String sTime=(timeRangeStart<10?"0"+timeRangeStart:timeRangeStart)+":00";
		String eTime=(timeRangeEnd<10?"0"+timeRangeEnd:timeRangeEnd)+":59";
		
		planName = Util.null2String(request.getParameter("planName"));
		beginDate = Util.null2String(request.getParameter("beginDate"));
		if("".equals(beginDate)){
			beginDate = currentdate;
		}
		beginTime = Util.null2String(request.getParameter("beginTime"));
		if("".equals(beginTime)){
			beginTime =sTime;
		}
		endDate = Util.null2String(request.getParameter("endDate"));
		if("".equals(endDate)){
			endDate = currentdate;
		}
		endTime = Util.null2String(request.getParameter("endTime"));
		if("".equals(endTime)){
			endTime = eTime;
		}
		if("".equals(memberIDs)){
			memberIDs = ""+selectUser;
		}
		if("".equals(memberIDs)){
			memberIDs=""+userid;
		}
	}
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) + ":&nbsp;"
					+ SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav = "";
	String needhelp = "";
	
	int temmhour=Util.getIntValue(remindTimesBeforeStart,0)/60;
	int temptinme=Util.getIntValue(remindTimesBeforeStart,0)%60;
	int temmhourend=Util.getIntValue(remindTimesBeforeEnd,0)/60;
	int temptinmeend=Util.getIntValue(remindTimesBeforeEnd,0)%60;
	
	String navName = SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	if(!"".equals(planName)){
		navName = planName;
	}

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(intWpid > 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="schedule"/>
   <jsp:param name="navName" value="<%=navName%>"/>
</jsp:include>

<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
		   <td>
			</td>
			<td class="rightSearchSpan" style="text-align:right; ">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="doSave(this)">
				<%if(intWpid > 0){ %>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="goBack(this)">
				<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
			</td>
		</tr>
	</table>
	<FORM name="frmmain" action="/workplan/data/WorkPlanOperation.jsp" method="post">
	<INPUT type="hidden" name="method" value="<%=method%>">
	<INPUT type="hidden" name="status" value="<%=status%>" >
	<INPUT type="hidden" name="workid" value="<%=workID%>">
	<INPUT type="hidden" name="from" value="<%=from%>">
	<INPUT type="hidden" name="selectDate" value="<%=selectDate%>">
	<INPUT type="hidden" name="selectUser" value="<%=selectUser%>">
	<INPUT type="hidden" name="viewType" value="<%=viewType%>">
	<INPUT type="hidden" name="meetingIDs" value="<%=meetingIDs%>">
	<INPUT type="hidden" name="f_weaver_belongto_userid" value="<%=user.getUID()%>">
	<%if("3".equals(type_n)&& WorkPlanSetInfo.getInfoCrm()==0){%>
	<input type="hidden" name="crmIDs" id="crmIDs" value="<%=crmIDs %>">
	<%} %>
	<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
				<wea:item>
					<!--================ 日程类型 ================-->
					<%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>
				</wea:item>
				<wea:item>
				<%
					if(1 <= Util.getIntValue(type_n) &&  Util.getIntValue(type_n) <= 6)
					{
				%>
					<SELECT name="" style="width:150px;">
				<%
						rs.executeSql("SELECT * FROM WorkPlanType WHERE workPlanTypeId = " + type_n);
						while(rs.next())
						{
				%>
						<OPTION value="<%= rs.getInt("workPlanTypeID") %>" selected><%= Util.forHtml(rs.getString("workPlanTypeName")) %></OPTION>
				<%
						}
				%>
					</SELECT>
					<INPUT type=hidden name="workPlanType" value="<%= rs.getInt("workPlanTypeID") %>">
				<%		  				    
					}
					else
					{
				%>
					<SELECT name="workPlanType" style="width:150px;">
				<%
						rs.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
														
						while(rs.next())
						{
							String workPlanTypeID = String.valueOf(rs.getInt("workPlanTypeID"));
				%>
						<OPTION value="<%= workPlanTypeID %>" <% if(type_n.equals(workPlanTypeID)) { %> selected <% } %> ><%= Util.forHtml(rs.getString("workPlanTypeName")) %></OPTION>
				<%
						}
					}
				%>
					</SELECT>
		  	</wea:item>
        <!--================ 标题  ================-->
          	<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
          	<wea:item>
          		<INPUT class="InputStyle" maxLength="100" size="30" id="planName" name="planName" onchange="checkinput('planName','nameImage')" value="<%=planName%>">
          		<SPAN id=nameImage><%if("".equals(planName)) {%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%} %></SPAN>
          	</wea:item>

		<!--================ 考核项  ================-->
		<!--================ 内容  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
          	<wea:item>
          		<TEXTAREA class=InputStyle NAME="description" ROWS="5" STYLE="width:90%"><%= Util.convertDB2Input(description) %></TEXTAREA>
          	</wea:item>
		
		
		
		<!--================ 接收人  ================-->	
			<wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></wea:item>
			<wea:item> 
				<%
				String tmpaccepterids="";
				String tmpaccepterNames="";
				ArrayList accepterids1=Util.TokenizerString(memberIDs,",");
				if(accepterids1.size()!=0){
					for(int m=0; m < accepterids1.size(); m++){
						String tmpaccepterid=(String) accepterids1.get(m);
						tmpaccepterids+=","+tmpaccepterid;
						
						//tmpaccepterNames+="<a href='/hrm/resource/HrmResource.jsp?id="+tmpaccepterid+"' target='_blank'>"+Util.toScreen(ResourceComInfo.getResourcename(tmpaccepterid),user.getLanguage())+"</a> &nbsp;";
						tmpaccepterNames+=Util.toScreen(ResourceComInfo.getResourcename(tmpaccepterid),user.getLanguage())+",";
					}
				}
				
				%>
				<brow:browser viewType="0" name="memberIDs" browserValue='<%=tmpaccepterids %>' tempTitle='<%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="300px" 
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%=tmpaccepterNames%>'></brow:browser>
				
			</wea:item>
		
        <!--================ 紧急程度  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" value="1" name="urgentLevel" <%if (!"2".equals(urgentLevel)&&!"3".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
				&nbsp;&nbsp;
				<INPUT type="radio" value="2" name="urgentLevel" <%if ("2".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
				&nbsp;&nbsp;
				<INPUT type="radio" value="3" name="urgentLevel" <%if ("3".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
			</wea:item>
		<!--================ 开始时间  ================-->	
			<wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
          	<wea:item>
          		<button type="button" class=Calendar id="selectBeginDate" onclick="onshowPlanDate('beginDate','selectBeginDateSpan')"></BUTTON> 
              	<SPAN id=selectBeginDateSpan ><%=beginDate%><%if("".equals(beginDate)) {%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%} %></SPAN> 
              	<INPUT type="hidden" name="beginDate" value="<%=beginDate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectBeginTime" onclick="onShowTime(selectBeginTimeSpan,beginTime)"></BUTTON>
              	<SPAN id="selectBeginTimeSpan"><%=beginTime%></SPAN>
              	<INPUT type=hidden name="beginTime" value="<%=beginTime%>">
            </wea:item>
			<!--================ 结束时间  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
          	<wea:item>
          		<button type="button" class=Calendar id="selectEndDate" onclick="onshowPlanDate('endDate','endDateSpan')"></BUTTON> 
            	<SPAN id=endDateSpan><%=endDate%><%if("".equals(endDate)) {%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%} %></SPAN> 
            	<INPUT type="hidden" name="endDate" value="<%=endDate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectEndTime" onclick="onShowTime(endTimeSpan,endTime)"></BUTTON>
              	<SPAN id="endTimeSpan"><%=endTime%></SPAN>
              	<INPUT type=hidden name="endTime" value="<%=endTime%>">
			</wea:item>
			<%if(WorkPlanSetInfo.getShowRemider()==1){ %>
		<!--================ 日程提醒方式  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) <%if (!"2".equals(remindType)&& !"3".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this) <%if ("2".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this) <%if ("3".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</wea:item>
			<%}else{%>
			<!-- 不开启提醒,默认不提醒 -->
				<wea:item attributes="{'display':'none','samePair':'ShowRemider'}"><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></wea:item>
				<wea:item attributes="{'display':'none','samePair':'ShowRemider'}">
					<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) checked><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				</wea:item>	
				
			<%} %>
		<!--================ 日程提醒时间  ================-->
			<wea:item attributes="{'samePair':\"remindTime\"}">
				<%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':\"remindTime\"}">
				<INPUT type="checkbox" name="remindBeforeStart" value="1" <% if("1".equals(remindBeforeStart)) { %>checked<% } %>>
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size=5 value="<%= temmhour %> ">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="<%= temptinme %>">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
					&nbsp&nbsp&nbsp
				<INPUT type="checkbox" name="remindBeforeEnd" value="1" <% if("1".equals(remindBeforeEnd)) { %>checked<% } %>>

					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="<%= temmhourend%>">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" name="remindTimeBeforeEnd"  onchange="checkint('remindTimeBeforeEnd')" size=5 value="<%= temptinmeend %>">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':\"reminddesc\"}">
				&nbsp;
			</wea:item>
			<wea:item attributes="{'samePair':\"reminddesc\"}">
				<%=SystemEnv.getHtmlLabelName(24155,user.getLanguage())%>
			</wea:item>
		</wea:group>
		<%	
		if(WorkPlanSetInfo.getInfoCrm()==1||WorkPlanSetInfo.getInfoPrj()==1||WorkPlanSetInfo.getInfoPrjTask()==1||WorkPlanSetInfo.getInfoDoc()==1||WorkPlanSetInfo.getInfoWf()==1 || WorkPlanSetInfo.getInfoaccessory()==1){ %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(22078, user.getLanguage())%>' >
		<%if(WorkPlanSetInfo.getInfoCrm()==1){%>
			<!--================ 相关客户  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
        	<wea:item>
				<%
					String crmNames="";
					if (!crmIDs.equals("")) 
					{
						ArrayList crms = Util.TokenizerString(crmIDs,",");
						for (int i = 0; i < crms.size(); i++)
						{
							//crmNames+="<A  href='/CRM/data/ViewCustomer.jsp?CustomerID="+crms.get(i)+"' target='_blank'>"
							//		+CustomerInfoComInfo.getCustomerInfoname(""+crms.get(i))+"</a>&nbsp;";
							crmNames+=CustomerInfoComInfo.getCustomerInfoname(""+crms.get(i))+",";
						}
					}
				%>
				
				<%
					if(type_n.equals("3")){ //如果是从客户模块关联过来的日程信息，客户信息不允许修改
						crmNames = crmNames.substring(0,crmNames.length()-1);	
				%>
					<input type="hidden" name="crmIDs" id="crmIDs" value="<%=crmIDs %>">
					<a style="margin-left:10px;" href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmIDs%>" title="<%=CustomerInfoComInfo.getCustomerInfoname(crmIDs) %>" target="_blank"><%=crmNames %></a>
				<%}else{ %>
					<brow:browser viewType="0" name="crmIDs" browserValue='<%=crmIDs%>' 
					browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="%>'
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px" 
					completeUrl="/data.jsp?type=18" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
					browserSpanValue='<%=crmNames%>'></brow:browser>
				<%} %>
				<!--
				<INPUT type="hidden" class="wuiBrowser" name="crmIDs" value="<%=crmIDs%>" _displayText="<%=crmNames %>" _param="resourceids"
					_displayTemplate="<A href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
					_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
					-->
		  	</wea:item>
		<%}
		if(WorkPlanSetInfo.getInfoDoc()==1){%>
		<!--================ 相关文档  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
          	<wea:item>
          		<%
          			String docNames="";
        			if (!docIDs.equals("")) 
					{
						ArrayList docs = Util.TokenizerString(docIDs,",");
					for (int i = 0; i < docs.size(); i++) 
					{
						//docNames+="<A  href='/docs/docs/DocDsp.jsp?id="+docs.get(i)+"' target='_blank'>"
						//		+DocComInfo.getDocname(""+docs.get(i))+"</a>&nbsp;";
						docNames+= DocComInfo.getDocname(""+docs.get(i))+",";
					}
					}
          		%>
				<brow:browser viewType="0" name="docIDs" browserValue='<%=docIDs%>' 
				browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px" 
				completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id=" 
				browserSpanValue='<%=docNames %>'></brow:browser>

          	</wea:item>
		<%}if(WorkPlanSetInfo.getInfoPrj()==1){%>
		<!--================ 相关项目  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
			<wea:item>
				<%
					String prjNames="";
					if (!projectIDs.equals("")) 
					{
						ArrayList projects = Util.TokenizerString(projectIDs,",");
						for (int i = 0; i < projects.size(); i++) 
						{
							//prjNames+="<A  href='/proj/data/ViewProject.jsp?ProjID="+projects.get(i)+"' target='_blank'>"
							//		+ProjectInfoComInfo.getProjectInfoname(""+projects.get(i))+"</a>&nbsp;";
							prjNames+= ProjectInfoComInfo.getProjectInfoname(""+projects.get(i))+",";
						}
					}
				%>
				<brow:browser viewType="0" name="projectIDs" browserValue='<%=projectIDs%>' 
				browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="%>'
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px" 
				completeUrl="/data.jsp?type=8" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#" 
				browserSpanValue='<%=prjNames %>'></brow:browser>
			</wea:item>
		<%}if(WorkPlanSetInfo.getInfoPrjTask()==1){%>
		<!--================ 相关项目任务  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></wea:item>
			<wea:item>
				<%
					String taskNames="";
					if (!taskIDs.equals("") && !taskIDs.equals("0")) 
					{
						ArrayList tasks = Util.TokenizerString(taskIDs,",");
						for (int i = 0; i < tasks.size(); i++) 
						{
							//taskNames+="<A  href='/proj/process/ViewTask.jsp?taskrecordid="+tasks.get(i)+"' target='_blank'>"+ProjectTaskApprovalDetail.getTaskSuject(tasks.get(i).toString())+"("+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+ProjectTaskApprovalDetail.getProjectNameByTaskId(tasks.get(i).toString())+")</A>&nbsp;";
							taskNames+=ProjectTaskApprovalDetail.getTaskSuject(tasks.get(i).toString())+"("+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+ProjectTaskApprovalDetail.getProjectNameByTaskId(tasks.get(i).toString())+"),";
						}
					}
				%>
				<brow:browser viewType="0" name="taskIDs" browserValue='<%=taskIDs%>' 
				browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids="%>'
				hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px" 
				completeUrl="/data.jsp" linkUrl="/proj/process/ViewTask.jsp?taskrecordid=#id#&id=#id#" 
				browserSpanValue='<%=taskNames %>'></brow:browser>
			</wea:item>
		<%}if(WorkPlanSetInfo.getInfoWf()==1){%>
		<!--================ 相关流程  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item>
			<wea:item>
				<%
					String requestNames="";
					if (!requestIDs.equals("")) 
					{
						ArrayList requests = Util.TokenizerString(requestIDs,",");
						for (int i = 0; i < requests.size(); i++) 
						{
							//requestNames+="<A  href='/workflow/request/ViewRequest.jsp?requestid="+requests.get(i)+"' target='_blank'>"
							//		+requestComInfo.getRequestname(""+requests.get(i))+"</a>&nbsp;";
							requestNames+=requestComInfo.getRequestname(""+requests.get(i))+",";
						}
					}
				%>
				<brow:browser viewType="0" name="requestIDs" browserValue='<%=requestIDs%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
				hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px" 
				completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
				browserSpanValue='<%=requestNames %>'></brow:browser>
			</wea:item>
		<%}if(WorkPlanSetInfo.getInfoaccessory()==1){%>
		<!--================ 相关附件  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></wea:item>
			
			<wea:item attributes="{'id':'divAccessory'}" >
				<TABLE class=viewForm width="100%">
         			<COLGROUP>
         			<COL width="60px">
					<COL width="">
			        <TBODY>
			           <%
			          	String display = "0";
			       
			    		if(!attachs.equals("")) {
			    			display = "1";
				            String sql="select id,docsubject,accessorycount from docdetail where id in ("+attachs+") order by id asc";
				            rs.executeSql(sql);
				            int linknum=-1;
				            while(rs.next()){
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
				
				              if(DocImageManager.next()){
				                //DocImageManager会得到doc第一个附件的最新版本
				                docImagefileid = DocImageManager.getImagefileid();
				                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
				                docImagefilename = DocImageManager.getImagefilename();
				                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
				                versionId = DocImageManager.getVersionId();
				              }
				              if(accessoryCount>1){
				              	fileExtendName ="htm";
				              }
			
			              	  String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
			              %>
				          <tr>
				            <input type=hidden name="field_del_<%=linknum%>" value="0" >
				            <td class=field  colSpan="2">
				              <%=imgSrc%>
				              <%
				              if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("ppt")||fileExtendName.equalsIgnoreCase("pptx")||fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")))
				              {
				              %>
				                <a style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
				              <%
				              }
				              else
				              {
				              %>
				                <a style="cursor:hand" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp;
				              <%
				              }
				              %>
				              <input type=hidden name="field_id_<%=linknum%>" value=<%=showid%>>

							  <input type="button" class="e8_btn_cancel" accessKey=1  onclick='onChangeSharetype("span_id_<%=linknum%>","field_del_<%=linknum%>","<%=0%>")' value="<%=linknum + "-" +SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"/>
								<span id="span_id_<%=linknum%>" name="span_id_<%=linknum%>" style="visibility:hidden">
									<B><FONT COLOR="#FF0033">√</FONT></B>
								</span>
				            </td>
				          </tr>
				          <TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>
				          <%
				          }
				          %>
			             <input type=hidden name="field_idnum" value=<%=linknum+1%>>
			             <input type=hidden name="field_idnum_1" value=<%=linknum+1%>>
			          <%}%> 
			          <TR>
			             <td class=field colspan=2 id="divAccessory" name="divAccessory">
			             
			             <%if(!"".equals(secId)){ %>
					  <input type=hidden id="accessory_num" name="accessory_num" value="1">
						    <div id="uploadDiv" mainId="-1" subId="-1" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
						<%}else{%>   
							<font color=red>(<%=SystemEnv.getHtmlLabelName(20476,user.getLanguage())%>)</font>
						<%}%>
			    		</td>
			          </TR>
				     </TBODY>
				 </TABLE>
				 
				 
			</wea:item>
		
		<%}%>
		</wea:group>
		<%} %>
	</wea:layout>
</FORM>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<SCRIPT language="JavaScript" src="/js/OrderValidator_wev8.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
  //绑定附件上传
   if(jQuery("#uploadDiv").length>0)
     bindUploaderDiv(jQuery("#uploadDiv"),"attachs"); 
function btn_cancle(){
	if("<%=intWpid%>"==-1&&$('#planName').val()!=''){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81581,user.getLanguage())%>",function(){
		    var dialog;
		    try{
		    	dialog = parent.getDialog(window);
		    }catch(e){}
		    if(!!dialog){
		    	dialog.closeByHand();
		    } else {
		    	window.close();
		    }
			//var parentWin = parent.getParentWindow(window);
			//parentWin.closeDialog();
		});
	}else{
			var dialog;
		    try{
		    	dialog = parent.getDialog(window);
		    }catch(e){}
		    if(!dialog){
		    	try{
			    	dialog = parent.parent.getDialog(parent);
			    }catch(e){}
		    }
		    if(!!dialog){
		    	dialog.closeByHand();
		    } else {
		    	window.close();
		    }
			//var parentWin = parent.getParentWindow(window);
			//parentWin.closeDialog();
	}

	
}
jQuery(document).ready(function(){
	if("0"=="<%=WorkPlanSetInfo.getShowRemider()%>"){
		hideEle("ShowRemider", true);
	}

	var remindType=$("input[name='remindType']:checked").val();
	if("2" != remindType && "3" != remindType)
	{
		hideEle("remindTime", true);
		hideEle("reminddesc", true);
	}
	else
	{
		showEle("remindTime");
		showEle("reminddesc");
	}
	resizeDialog(document);
});
$(function(){
	if($("input[name=memberIDs]").val()==""){
	document.getElementById("memberIDsspan").style.display='none';
	}else{
		document.getElementById("memberIDsspan").style.display='';
	}
});
function goBack() {	
	//document.frmmain.action = "/workplan/data/WorkPlanDetail.jsp";
	//document.frmmain.submit();
	window.location.href="/workplan/data/WorkPlanDetail.jsp?from=1&workid=<%=workID%>";
}

function doSave(obj) {	
	if (check_form(frmmain,"planName,memberIDs,beginDate,endDate") && checkWorkPlanRemind()) {
		if (!checkOrderValid("beginDate", "endDate")) {
			Dialog.alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
			return;
		}
        //td1976 判断是否只为空格和回车
        var dd=$GetEle("description").value;
	    dd=dd.replace(/^[ \t\n\r]+/g, "");
	    dd=dd.replace(/[ \t\n\r]+$/g, "");

		var dateStart = $GetEle("beginDate").value;
		var dateEnd = $GetEle("endDate").value;

		if (dateStart == dateEnd && !checkOrderValid("beginTime", "endTime")) {
			Dialog.alert("<%=SystemEnv.getHtmlNoteName(55,user.getLanguage())%>");
			return;
		}
		obj.disabled = true ;
		 var oUploader=window[jQuery("#uploadDiv").attr("ouploaderindex")];
		try{
		
		    if(oUploader.getStats().files_queued==0) 
		   	doSaveAfterAccUpload();
		    else 
		    oUploader.startUpload();
		}catch(e){
			doSaveAfterAccUpload();
		}
	}
}
function doSaveAfterAccUpload(){
	document.frmmain.submit();
}
function showRemindTime(obj)
{	
	if("2" != obj.value && "3" != obj.value)
	{
		hideEle("remindTime", true);
		hideEle("reminddesc", true);
	}
	else
	{
		showEle("remindTime");
		showEle("reminddesc");
	}
}

function checkWorkPlanRemind()
{
	if(false == document.frmmain.remindType[0].checked)
	{
		if(document.frmmain.remindBeforeStart.checked || document.frmmain.remindBeforeEnd.checked)
		{
			return true;			
		}
		else
		{
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20238,user.getLanguage())%>");
			return false;
		}
	}
	else
	{
		document.frmmain.remindBeforeStart.checked = false;
		document.frmmain.remindBeforeEnd.checked = false;
		document.frmmain.remindTimeBeforeStart.value = 10;
		document.frmmain.remindTimeBeforeEnd.value = 10;
		
		return true;		
	}
}

function onWPShowDate(spanname,inputname){
  var returnvalue;	  
  var oncleaingFun = function(){
		 $(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
		 $(inputname).value = '';
	}
   WdatePicker({onpicked:function(dp){
	returnvalue = dp.cal.getDateStr();	
	$dp.$(spanname).innerHTML = returnvalue;
	$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}

function onWPNOShowDate(spanname,inputname){
  var returnvalue;	  
  var oncleaingFun = function(){
		 $(spanname).innerHTML = ""; 
		 $(inputname).value = '';
	}
   WdatePicker({onpicked:function(dp){
	returnvalue = dp.cal.getDateStr();	
	$dp.$(spanname).innerHTML = returnvalue;
	$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}

function changeView(viewFlag,hiddenspan,accepterspan,flag){
	try {
		if(flag==1){
			document.getElementById(viewFlag).style.display='none';
			document.getElementById(hiddenspan).style.display='';
			document.getElementById(accepterspan).style.display='';
		}
		if(flag==0){
			document.getElementById(viewFlag).style.display='';
			document.getElementById(hiddenspan).style.display='none';
			document.getElementById(accepterspan).style.display='none';
		}
	}
	catch(e) {}
}

function onShowResource(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
function onChangeSharetype(delspan,delid,ismand){
fieldid=delid.substr(0,delid.indexOf("_"));
fieldidnum=fieldid+"_idnum_1";
fieldidspan=fieldid+"span";
fieldidspans=fieldid+"spans";
fieldid=fieldid+"_1";
   if($GetEle(delspan).style.visibility=='visible'){
     $GetEle(delspan).style.visibility='hidden';
     $GetEle(delid).value='0';
  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
   }else{
     $GetEle(delspan).style.visibility='visible';
     $GetEle(delid).value='1';
  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
   }
 }
 
 function addannexRow(){
	var nrewardTable = document.getElementById("AccessoryTable");
	var maxsize = document.getElementById("maxsize").value;
	oRow = nrewardTable.insertRow(-1);
	oRow.height=20;
	for(j=0; j<2; j++) {
		oCell = oRow.insertCell(-1);
		switch(j) {
    		case 0:
				var sHtml = "";
				oCell.innerHTML = sHtml;
				break;
	        case 1:
	       		oCell.className = "field";
	            var sHtml = "<input class=InputStyle  type=file name='accessory"+accessorynum+"' onchange='accesoryChanage(this)'>(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:"+maxsize+"M)";
				oCell.innerHTML = sHtml;
				break;
		}
	}
	document.getElementById("accessory_num").value = accessorynum ;
	accessorynum = accessorynum*1 +1;
	oRow1 = nrewardTable.insertRow(-1);
	oCell1 = oRow1.insertCell(-1);
    oCell1.colSpan = 2
    oCell1.className = "Line";
    $(oRow1).css("height","1px");
}
function accesoryChanage1(obj){
	var secId = '<%=secId%>';
	if(secId=="")
	{
		alert("<%=SystemEnv.getHtmlLabelName(24429,user.getLanguage())%>!");
		obj.value = "";
		createAndRemoveObj(obj);
		return;
	}
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        try{
        	fileLenth=parseInt(obj.files[0].size);
        }catch (e) {
        	if(e.message=="Type mismatch")
                alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
                else
                alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
                createAndRemoveObj(obj);
                return  ;
		}
    	
    }
  
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    var fileLenthByK =  fileLenth/1024;
		var fileLenthByM =  fileLenthByK/1024;
	
		var fileLenthName;
		if(fileLenthByM>=0.1){
			fileLenthName=fileLenthByM.toFixed(1)+"M";
		}else if(fileLenthByK>=0.1){
			fileLenthName=fileLenthByK.toFixed(1)+"K";
		}else{
			fileLenthName=fileLenth+"B";
		}
		maxsize = document.getElementById("maxsize").value;
    if (fileLenthByM>maxsize) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxsize+"M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>!");
        createAndRemoveObj(obj);
    }
}
function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.onchange=function(){accesoryChanage(this);};

    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode);
}
 
</SCRIPT>


</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

</HTML>
