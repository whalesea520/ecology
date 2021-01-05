
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<!--<jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>-->
<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	<STYLE>
		.vis1	{ visibility:"visible" }
		.vis2	{ visibility:"hidden" }
	</STYLE>
</HEAD>
<%
    int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String workID = Util.null2String(request.getParameter("workid"));
	String from = Util.null2String(request.getParameter("from"));
	String userID = String.valueOf(user.getUID());
	String userType = user.getLogintype();
	
	String logintype = user.getLogintype();
	int userid=user.getUID();
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	
	String method = "add";
	int intWpid = Util.getIntValue(workID, -1);
	
	boolean canView = false;
	boolean canEdit = false;
	
	String selectUser = Util.null2String(request.getParameter("selectUser"));
	String selectDate = Util.null2String(request.getParameter("selectDate"));
	String viewType = Util.null2String(request.getParameter("viewType"));
	String workPlanType = Util.null2String(request.getParameter("workPlanType"));
	String workPlanStatus = Util.null2String(request.getParameter("workPlanStatus"));
	
	String type_n = "" ;
	String planName = "" ;
	String memberIDs = "";
	String beginDate = "";
	String beginTime = "";
	String endDate = "";
	String endTime = "";
	String description = "";
	String requestIDs = "";
	String projectIDs = "";
	String crmIDs = "";
	String docIDs = "";
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
	
	String remindType = "";  //日程提醒方式
	String remindBeforeStart = "";  //是否开始前提醒
	String remindBeforeEnd = "";  //是否结束前提醒
	String remindTimesBeforeStart = "";  //开始前提醒时间数
	String remindTimesBeforeEnd = "";  //结束前提醒时间数
	String remindDateBeforeStart = "";  //开始前提醒日期
	String remindTimeBeforeStart = "";  //开始前提醒时间
	String remindDateBeforeEnd = "";  //结束前提醒日期
	String remindTimeBeforeEnd = "";  //结束前提醒时间
	
	String hrmPerformanceCheckDetailID = "";  //自定义考核叶子节点ID
	
	if(intWpid > 0){
		method = "edit";
		//String temptable = WorkPlanShareBase.getTempTable(userID);
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
		planName = Util.null2String(request.getParameter("planName"));
		beginDate = Util.null2String(request.getParameter("beginDate"));
		beginTime = Util.null2String(request.getParameter("beginTime"));
		endDate = Util.null2String(request.getParameter("endDate"));
		endTime = Util.null2String(request.getParameter("endTime"));
		memberIDs = ""+userid;
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
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="doSave(this)">
				<%if(intWpid > 0){ %>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="goBack()">	
				<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
			</td>
		</tr>
	</table>
	<FORM name="frmmain" action="/workplan/data/WorkPlanOperation.jsp" method="post">
	<INPUT type="hidden" name="method" value="<%=method%>">
	<INPUT type="hidden" name="status" value="<%=status%>" >
	<INPUT type="hidden" name="workid" value="<%=workID%>">
	<INPUT type="hidden" name="frm" value="cal">
	<INPUT type="hidden" name="selectDate" value="<%=selectDate%>">
	<INPUT type="hidden" name="selectUser" value="<%=selectUser%>">
	<INPUT type="hidden" name="viewType" value="<%=viewType%>">
	<INPUT type="hidden" name="meetingIDs" value="<%=meetingIDs%>">
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
					<SELECT name="" disabled style="width:150px;">
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
          		<INPUT class=INPUTStyle maxLength=100 size=30 name="planName" onchange="checkinput('planName','nameImage')" value="<%=planName%>">
          		<SPAN id=nameImage><%if("".equals(planName)) {%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%} %></SPAN>
          	</wea:item>
		<!--================ 内容  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
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
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px" 
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%=tmpaccepterNames%>'></brow:browser>
				
			</wea:item>
	
		<!--================ 紧急程度  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" value="1" name="urgentLevel" <%if ("1".equals(urgentLevel)||"".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
				&nbsp;&nbsp;
				<INPUT type="radio" value="2" name="urgentLevel" <%if ("2".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
				&nbsp;&nbsp;
				<INPUT type="radio" value="3" name="urgentLevel" <%if ("3".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
			</wea:item>

		<!--================ 日程提醒方式  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) <%if ("1".equals(remindType)||"".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this) <%if ("2".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this) <%if ("3".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</wea:item>

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
					<br>
				<INPUT type="checkbox" name="remindBeforeEnd" value="1" <% if("1".equals(remindBeforeEnd)) { %>checked<% } %>>

					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="<%= temmhourend%>">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" name="remindTimeBeforeEnd"  onchange="checkint('remindTimeBeforeEnd')" size=5 value="<%= temptinmeend %>">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</wea:item>
		
		<!--================ 开始时间  ================-->	
			<wea:item><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
          	<wea:item>
          		<button type="button" class=Calendar id="selectBeginDate" onclick="onshowPlanDate('beginDate','selectBeginDateSpan')"></BUTTON> 
              	<SPAN id=selectBeginDateSpan ><%=beginDate%></SPAN> 
              	<INPUT type="hidden" name="beginDate" value="<%=beginDate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectBeginTime" onclick="onShowTime(selectBeginTimeSpan,beginTime)"></BUTTON>
              	<SPAN id="selectBeginTimeSpan"><%=beginTime%></SPAN>
              	<INPUT type=hidden name="beginTime" value="<%=beginTime%>">
            </wea:item>
			<!--================ 结束时间  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
          	<wea:item>
          		<button type="button" class=Calendar id="selectEndDate" onclick="onshowPlanDate('endDate','endDateSpan')"></BUTTON> 
            	<SPAN id=endDateSpan><%=endDate%></SPAN> 
            	<INPUT type="hidden" name="endDate" value="<%=endDate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectEndTime" onclick="onShowTime(endTimeSpan,endTime)"></BUTTON>
              	<SPAN id="endTimeSpan"><%=endTime%></SPAN>
              	<INPUT type=hidden name="endTime" value="<%=endTime%>">
			</wea:item>
		<%if(isgoveproj==0){%>
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
				<brow:browser viewType="0" name="crmIDs" browserValue='<%=crmIDs%>' 
				browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="%>'
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="200px" 
				completeUrl="/data.jsp?type=18" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
				browserSpanValue='<%=crmNames%>'></brow:browser>
				<!--
				<INPUT type="hidden" class="wuiBrowser" name="crmIDs" value="<%=crmIDs%>" _displayText="<%=crmNames %>" _param="resourceids"
					_displayTemplate="<A href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
					_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
					-->
		  	</wea:item>
		<%}%>
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
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="200px" 
				completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id=" 
				browserSpanValue='<%=docNames %>'></brow:browser>

          	</wea:item>
		<%if(isgoveproj==0){%>
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
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="200px" 
				completeUrl="/data.jsp?type=18" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#" 
				browserSpanValue='<%=prjNames %>'></brow:browser>
			</wea:item>
		<%}%>
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
				hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1' width="200px" 
				completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
				browserSpanValue='<%=requestNames %>'></brow:browser>
			</wea:item>
		</wea:group>
	</wea:layout>
</FORM>
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

<SCRIPT language="JavaScript" src="/js/OrderValidator_wev8.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
var dialog = parent.getDialog(window);
function btn_cancle(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}
jQuery(document).ready(function(){
	showRemindTime($GetEle("remindType"));
	resizeDialog(document);
});

function goBack() {	
	//document.frmmain.action = "/workplan/data/WorkPlanDetail.jsp";
	//document.frmmain.submit();
	window.location.href="/workplan/calendar/data/WorkPlanDetailCal.jsp?from=1&workid=<%=workID%>";
}

function doSave(obj) {	
	if (check_form(frmmain,"planName,memberIDs,begindate") && checkWorkPlanRemind()) {
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
		document.frmmain.submit();
	}
}

function showRemindTime(obj)
{
	if("1" == obj.value)
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
	

</SCRIPT>


</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
