
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="page" />
<jsp:setProperty name="MeetingSearchComInfo" property="name" param="names"/>
<jsp:setProperty name="MeetingSearchComInfo" property="meetingtype" param="meetingtype"/>
<jsp:setProperty name="MeetingSearchComInfo" property="address" param="address"/>
<jsp:setProperty name="MeetingSearchComInfo" property="begindate" param="begindate"/>
<jsp:setProperty name="MeetingSearchComInfo" property="enddate" param="enddate"/>
<jsp:setProperty name="MeetingSearchComInfo" property="callers" param="callers"/>
<jsp:setProperty name="MeetingSearchComInfo" property="callersDep" param="callersDep"/>
<jsp:setProperty name="MeetingSearchComInfo" property="callersSub" param="callersSub"/>
<jsp:setProperty name="MeetingSearchComInfo" property="contacters" param="contacters"/>
<jsp:setProperty name="MeetingSearchComInfo" property="contactersDep" param="contactersDep"/>
<jsp:setProperty name="MeetingSearchComInfo" property="contactersSub" param="contactersSub"/>
<jsp:setProperty name="MeetingSearchComInfo" property="creaters" param="creaters"/>
<jsp:setProperty name="MeetingSearchComInfo" property="creatersDep" param="creatersDep"/>
<jsp:setProperty name="MeetingSearchComInfo" property="creatersSub" param="creatersSub"/>
<jsp:setProperty name="MeetingSearchComInfo" property="hrmids" param="hrmids"/>
<jsp:setProperty name="MeetingSearchComInfo" property="crmids" param="crmids"/>
<jsp:setProperty name="MeetingSearchComInfo" property="projectid" param="projectid"/>
<jsp:setProperty name="MeetingSearchComInfo" property="timeSag" param="timeSag"/>
<jsp:setProperty name="MeetingSearchComInfo" property="meetingStartdatefrom" param="meetingStartdatefrom"/>
<jsp:setProperty name="MeetingSearchComInfo" property="meetingStartdateto" param="meetingStartdateto"/>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<%	
	String userid = ""+user.getUID();
	//是否重复会议
	int isInterval = Util.getIntValue(request.getParameter("isInterval"), 0);
	//是否初次加载
	int isFirst = Util.getIntValue(request.getParameter("isFirst"), 1);
	//重复会议不用判断是否初次加载
	if(isInterval == 1 ){
		isFirst = 0;
	}
	int repeatType = Util.getIntValue(request.getParameter("repeatType"),0);
	int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
	MeetingSearchComInfo.setTimeSag(timeSag);
	 
	boolean simpleSearch="1".equals(Util.null2String(request.getParameter("simpleSearch")));//快速部署,隐藏高级查询
	String meetingstatus=Util.null2String(request.getParameter("meetingstatus"));
	String mstatus1="";//用来区分会议状态：正常和结束
	if("5".equals(meetingstatus)){//结束
		mstatus1="5";
		meetingstatus="2";
	}else if("2".equals(meetingstatus)){//正常
		mstatus1="2";
	}
	MeetingSearchComInfo.setmeetingstatus(meetingstatus);
	
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17625, user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
    
    String meetingTypename = "";
    
    if(!"".equals(MeetingSearchComInfo.getmeetingtype())){
    	rs.executeSql("select name from Meeting_Type where id in ("+MeetingSearchComInfo.getmeetingtype()+")");
    	while(rs.next()){
    		meetingTypename += Util.null2String(rs.getString("name"))+",";
    	}
    	if(!"".equals(meetingTypename)){
    		meetingTypename = meetingTypename.substring(0,meetingTypename.length() - 1);
    	}
    }
	
	if(isInterval == 1){
		MeetingSearchComInfo.setTimeSag(0);
	}
	
    //构建where语句
    String SqlWhere = MeetingSearchComInfo.FormatSQLSearch(user.getLanguage())  ;  
    String allUser=MeetingShareUtil.getAllUser(user);
    
    if(!SqlWhere.equals(""))
	{
		SqlWhere +=" AND (";
	}
	else
	{
		SqlWhere =" WHERE (";
	}
	SqlWhere +=" (t1.id = t2.meetingId) AND ";
	if(isInterval != 1){
		//待审批，审批退回的会议，召集人 联系人 创建人  审批人都可以看
		SqlWhere +=" ((t1.meetingStatus in (1, 3) AND t2.userId in (" + allUser + ") AND t2.shareLevel in (1,4))" ;
		//草稿中的创建人可以看见
		SqlWhere +=" OR (t1.meetingStatus = 0 AND (t1.creater in (" + allUser + ")) AND (t2.userId in (" + allUser + ")) ) ";
		//正常和取消的会议所有参会人员都可见
		SqlWhere +=" OR (t1.meetingStatus IN (2, 4) AND (t2.userId in (" + allUser + "))))";
		SqlWhere +=")";
	} else {
	   //重复会议只有召集人，创建人，和联系人可以看见
		SqlWhere +="( t1.creater in (" + allUser + ") or ((t1.caller in("+ allUser + ") or t1.contacter  in("+ allUser +")) and t1.meetingStatus in (1,2) ) ) ";
		SqlWhere +=")";
	}
	
	//过滤重复会议
	if(isInterval == 1){
		if(repeatType > 0){
			SqlWhere +=" and t1.repeatType = "+repeatType;
		} else {
			SqlWhere +=" and t1.repeatType > 0 ";
		}
		//重复会议时间
		if(timeSag > 0&&timeSag<6){
			String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSag,"0");
			String doclastmoddateto = TimeUtil.getDateByOption(""+timeSag,"1");
			if(!doclastmoddatefrom.equals("")){
				SqlWhere += " and t1.repeatenddate >= '" + doclastmoddatefrom + "'";
			}
			
			if(!doclastmoddateto.equals("")){
				SqlWhere += " and t1.repeatbegindate <= '" + doclastmoddateto + "'";
			}
			
		}else{
			if(timeSag==6){//指定时间
				if(!"".equals(MeetingSearchComInfo.getMeetingStartdatefrom())){
					SqlWhere += " and t1.repeatenddate >= '" + MeetingSearchComInfo.getMeetingStartdatefrom() + "'";
				}
				
				if(!"".equals(MeetingSearchComInfo.getMeetingStartdateto())){
					SqlWhere += " and t1.repeatbegindate <= '" + MeetingSearchComInfo.getMeetingStartdateto() + "'";
				}
				
			}
			
		}
	} else {
		SqlWhere +=" and t1.repeatType = 0 ";
	}
    
    if(mstatus1.equals("5")){
      SqlWhere +=" and ( enddate<'"+CurrentDate+"' or (endDate = '"+CurrentDate+"' AND endTime < '"+CurrentTime+"') or isdecision=2) ";
      meetingstatus="5";
    }else if(mstatus1.equals("2")){
      SqlWhere +=" and ( enddate>'"+CurrentDate+"' or (endDate = '"+CurrentDate+"' AND endTime >= '"+CurrentTime+"')) and isdecision<>2 ";
    }
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
  </HEAD>
  <BODY >
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<% 

    //RCMenu += "{"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+",javascript:search()',_top} " ;
    //RCMenuHeight += RCMenuHeightStep ;
    if(isFirst == 1) {
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+",javascript:search()',_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(2022, user.getLanguage())+",javascript:resetCondtion()',_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    }else if(isFirst != 1 && isInterval != 1){
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(81272, user.getLanguage())+",javaScript:_xtable_getAllExcel()',_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    }
    
    if(isInterval == 1){
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(82, user.getLanguage())+",javascript:add()',_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    }

	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right; ">
				<%if(isFirst == 1) {%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="search();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_top" onclick="resetCondtion();"/>
				<%} else { %>
					<% if(isInterval == 1){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
				<%}else{%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(81272,user.getLanguage())%>" style="margin-left: 5px" class="e8_btn_top_first" onclick="_xtable_getAllExcel();">
					<%} %>
				<input type="text" class="searchInput" id="t_name" name="t_name" value=""/>
				<%if(!simpleSearch){ %>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
				<%}
				} %>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
			</td>
		</tr>
	</table>
	<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
				<span id="ALL" val="0" onclick="clickTab(this)" class="tabClass <%=(timeSag == 0 || timeSag < 0)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>
				<span id="TODAY" val="1" onclick="clickTab(this)" class="tabClass <%=(timeSag == 1)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></span>
				<span id="WEEK" val="2" onclick="clickTab(this)" class="tabClass <%=(timeSag == 2)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></span>
				<span id="MOUTH" val="3" onclick="clickTab(this)" class="tabClass <%=(timeSag == 3)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></span>
				<span id="SEASON" val="4" onclick="clickTab(this)" class="tabClass <%=(timeSag == 4)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></span>
				<span id="YEAR" val="5" onclick="clickTab(this)" class="tabClass <%=(timeSag == 5)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></span>
				
		 </span>
	</div>
	<%if(isFirst != 1) {%>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	<%} else { %>
	<div class="advancedSearchDiv1" id="advancedSearchDiv1">
	<%} %>
	<FORM id=weaverA name=weaverA action="MeetingSearch.jsp" method=post  >
		<input type="hidden" name="isInterval" id="isInterval" value="<%= isInterval%>"/>
		<input type="hidden" name="isFirst" id="isFirst" value="0"/>
		<input type="hidden" name="simpleSearch" id="simpleSearch" value="<%=simpleSearch %>"/>
		<%String attrs = "{'expandAllGroup':'"+((isFirst == 1)?"true":"false")+"'}"; %>
		<wea:layout type="4col" attributes='<%=attrs %>'>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(32905, user.getLanguage())%>' >
				<!-- 会议名称 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("2")),user.getLanguage())%></wea:item>
				<wea:item>
					<input type="text" class="InputStyle" id="names" name="names"  style="width:60%" value="<%=Util.forHtml(MeetingSearchComInfo.getname())%>">
				</wea:item>
			   
				<!-- 会议状态 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(22260,user.getLanguage())%></wea:item>
				<wea:item>
					<select name="meetingstatus" id="meetingstatus" style="width:100px;">
						<option value="" <%=meetingstatus.equals("")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<option value="0" <%=meetingstatus.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
						<option value="1" <%=meetingstatus.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%></option>
						<option value="2" <%=meetingstatus.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
						<option value="3" <%=meetingstatus.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%></option>
						<option value="4" <%=meetingstatus.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(20114,user.getLanguage())%></option>
						<option value="5" <%=meetingstatus.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
					</select>
				</wea:item>
			  
				<!-- 会议地点 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("5")),user.getLanguage())%></wea:item>
				<wea:item>
				  <%
				   String addressSpan = "";
				   if(!"".equals(MeetingSearchComInfo.getaddress())){
						addressSpan +=MeetingRoomComInfo.getMeetingRoomInfoname(MeetingSearchComInfo.getaddress());
					}%>
	
					<brow:browser viewType="0" name="address" browserValue='<%=MeetingSearchComInfo.getaddress()%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp?forall=1"
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="300px"
					completeUrl="/data.jsp?type=87&forall=1" linkUrl="/meeting/Maint/MeetingRoom.jsp?id=" 
					browserSpanValue='<%= addressSpan %>'></brow:browser>
					<!-- 
					<button class="Browser" onclick="onShowMeetingRoom('addressSpan','address')" type="button"></button>
					<input class=inputstyle type="hidden" id="address" name="address" value="<%=MeetingSearchComInfo.getaddress()%>"/>
					<span id="addressSpan" name="addressSpan"><%= addressSpan %></span>
					 -->
				</wea:item>
			
				<!-- 会议类型 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("1")),user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="meetingtype" browserValue='<%=MeetingSearchComInfo.getmeetingtype() %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutiMeetingTypeBrowser.jsp?forall=1&resourceids="
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
					completeUrl="/data.jsp?type=89&forall=1" linkUrl="/meeting/Maint/ListMeetingType.jsp?id=#id#" 
					browserSpanValue='<%=meetingTypename %>'></brow:browser>
				</wea:item>
			
				<!-- 召集人 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage())%></wea:item>
				<wea:item>
					<%
				   String callersSpan = "";
				   if(!"".equals(MeetingSearchComInfo.getcallers())){
					ArrayList callersl = Util.TokenizerString(MeetingSearchComInfo.getcallers(),",");
					for(int i=0;i<callersl.size();i++){
					callersSpan +=ResourceComInfo.getResourcename(""+callersl.get(i))+",";
					}}%>
					<brow:browser viewType="0" name="callers" browserValue='<%=MeetingSearchComInfo.getcallers()%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
					browserSpanValue='<%= callersSpan %>'></brow:browser>
				</wea:item>
				<!-- 联系人 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("4")),user.getLanguage())%></wea:item>
				<wea:item>
					<%
				   String contactersSpan = "";
				   if(!"".equals(MeetingSearchComInfo.getcontacters())){
					ArrayList ids = Util.TokenizerString(MeetingSearchComInfo.getcontacters(),",");
					for(int i=0;i<ids.size();i++){
	
					//contactersSpan +="<a href=\'javascript:openhrm("+ ids.get(i)+")\' onclick=\'pointerXY(event)\'>"+ResourceComInfo.getResourcename(""+ids.get(i))+"</a>&nbsp";
					contactersSpan +=ResourceComInfo.getResourcename(""+ids.get(i))+",";
					}}%>
					<brow:browser viewType="0" name="contacters" browserValue='<%=MeetingSearchComInfo.getcontacters()%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
					browserSpanValue='<%= contactersSpan %>'></brow:browser>
				</wea:item>
				<%if(isInterval == 1){ %>
					<!-- 会议时间 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2103,user.getLanguage())+(user.getLanguage() == 8?" ":"")+SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
						<select name="timeSag" id="timeSag" onchange="changeDate(this,'meetingStartdate');" style="width:100px;">
							<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
							<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
							<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
							<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
							<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
							<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
						</select>
					</span>
					<span id="meetingStartdate"  style="<%=timeSag==6?"":"display:none;" %>">
						<button type="button" class=calendar id=SelectDate onClick="getDate(meetingStartdatefromspan,meetingStartdatefrom)"></button>&nbsp;
						<span id=meetingStartdatefromspan><%=MeetingSearchComInfo.getMeetingStartdatefrom() %></span>
						-&nbsp;&nbsp;
						<button type="button" class=calendar id=SelectDate2 onClick="getDate(meetingStartdatetospan,meetingStartdateto)"></button>&nbsp;
						<span id="meetingStartdatetospan" ><%=MeetingSearchComInfo.getMeetingStartdateto() %></span>
						<input type="hidden" name="meetingStartdatefrom" id="meetingStartdatefrom" value="<%=MeetingSearchComInfo.getMeetingStartdatefrom() %>">
						<input type="hidden" name="meetingStartdateto" id="meetingStartdateto" value="<%=MeetingSearchComInfo.getMeetingStartdateto() %>"> 
					</span>
				</wea:item>
				<!-- 会议重复模式 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(25894,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle name="repeatType" id="repeatType" style="width:150px;" > 
						<option value="0" <%if (repeatType == 0) {%>selected<%}%>> </option>
						<option value="1" <%if (repeatType == 1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(25895,user.getLanguage())%> </option>
						<option value="2" <%if (repeatType == 2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(25896,user.getLanguage())%></option>
						<option value="3" <%if (repeatType == 3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(25897,user.getLanguage())%></option>
					</select>
				</wea:item>
				<%}else{%>
				<!-- 会议时间 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())+(user.getLanguage() == 8?" ":"")+SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
						<select name="timeSag" id="timeSag" onchange="changeDate(this,'meetingStartdate');" style="width:100px;">
							<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
							<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
							<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
							<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
							<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
							<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
						</select>
					</span>
					<span id="meetingStartdate"  style="<%=timeSag==6?"":"display:none;" %>">
						<button type="button" class=calendar id=SelectDate onClick="getDate(meetingStartdatefromspan,meetingStartdatefrom)"></button>&nbsp;
						<span id=meetingStartdatefromspan><%=MeetingSearchComInfo.getMeetingStartdatefrom() %></span>
						-&nbsp;&nbsp;
						<button type="button" class=calendar id=SelectDate2 onClick="getDate(meetingStartdatetospan,meetingStartdateto)"></button>&nbsp;
						<span id="meetingStartdatetospan" ><%=MeetingSearchComInfo.getMeetingStartdateto() %></span>
						<input type="hidden" name="meetingStartdatefrom" id="meetingStartdatefrom" value="<%=MeetingSearchComInfo.getMeetingStartdatefrom() %>">
						<input type="hidden" name="meetingStartdateto" id="meetingStartdateto" value="<%=MeetingSearchComInfo.getMeetingStartdateto() %>"> 
					</span>
				</wea:item>
				<%}%>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(32843, user.getLanguage())%>' >
				<!-- 召集人部门 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="callersDep" browserValue='<%=MeetingSearchComInfo.getCallersDep() %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
					browserSpanValue='<%=DepartmentComInfo.getDepartmentname(MeetingSearchComInfo.getCallersDep()) %>'></brow:browser>

				</wea:item>
			  
				<!-- 召集人分部 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="callersSub" browserValue='<%=MeetingSearchComInfo.getCallersSub() %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(MeetingSearchComInfo.getCallersSub()) %>'></brow:browser>
				</wea:item>
				
				<!-- 联系人部门 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("4")),user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="contactersDep" browserValue='<%=MeetingSearchComInfo.getContactersDep() %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
					browserSpanValue='<%=DepartmentComInfo.getDepartmentname(MeetingSearchComInfo.getContactersDep()) %>'></brow:browser>
				</wea:item>
				<!-- 联系人分部 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("4")),user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="contactersSub" browserValue='<%=MeetingSearchComInfo.getContactersSub() %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(MeetingSearchComInfo.getContactersSub()) %>'></brow:browser>
				
				</wea:item>
				<!-- 创建人 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
				<wea:item>
					<%
					   String creatersSpan = "";
					   if(!"".equals(MeetingSearchComInfo.getcreaters())){
						ArrayList ids = Util.TokenizerString(MeetingSearchComInfo.getcreaters(),",");
						for(int i=0;i<ids.size();i++){
						//creatersSpan +="<a href=\'javascript:openhrm("+ ids.get(i)+")\' onclick=\'pointerXY(event)\'>"+ResourceComInfo.getResourcename(""+ids.get(i))+"</a>&nbsp";
						creatersSpan +=ResourceComInfo.getResourcename(""+ids.get(i))+",";
						}}%>
						<brow:browser viewType="0" name="creaters" browserValue='<%=MeetingSearchComInfo.getcreaters()%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue='<%= creatersSpan %>'></brow:browser>
				</wea:item>
				<!-- 创建人部门 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="creatersDep" browserValue='<%=MeetingSearchComInfo.getCreatersDep() %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
					browserSpanValue='<%=DepartmentComInfo.getDepartmentname(MeetingSearchComInfo.getCreatersDep()) %>'></brow:browser>
				</wea:item>
				<!-- 创建人分部 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="creatersSub" browserValue='<%=MeetingSearchComInfo.getCreatersSub() %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(MeetingSearchComInfo.getCreatersSub()) %>'></brow:browser>
				</wea:item>
				<!-- 参会人员 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("29")),user.getLanguage())%></wea:item>
				<wea:item>
				 <% String hrmidsSpan = "";
				   if(!"".equals(MeetingSearchComInfo.gethrmids())){
					ArrayList ids = Util.TokenizerString(MeetingSearchComInfo.gethrmids(),",");
					for(int i=0;i<ids.size();i++){
	
					//hrmidsSpan +="<a href=\'javascript:openhrm("+ ids.get(i)+")\' onclick=\'pointerXY(event)\'>"+ResourceComInfo.getResourcename(""+ids.get(i))+"</a>&nbsp";
					hrmidsSpan +=ResourceComInfo.getResourcename(""+ids.get(i))+",";
					}}%>
					<brow:browser viewType="0" name="hrmids" browserValue='<%=MeetingSearchComInfo.gethrmids()%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue='<%= hrmidsSpan %>'></brow:browser>
				</wea:item>
				<!-- 参会客户 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("32")),user.getLanguage())%></wea:item>
				<wea:item>
					<% String crmidsSpan = "";
					if(!"".equals(MeetingSearchComInfo.getcrmids())){
					ArrayList ids = Util.TokenizerString(MeetingSearchComInfo.getcrmids(),",");
					for(int i=0;i<ids.size();i++){
					crmidsSpan +=CustomerInfoComInfo.getCustomerInfoname(""+ids.get(i))+",";
					}}%>
					<brow:browser viewType="0" name="crmids" browserValue='<%=MeetingSearchComInfo.getcrmids()%>' 
					browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="%>'
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
					completeUrl="/data.jsp?type=18" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
					browserSpanValue='<%=crmidsSpan%>'></brow:browser>
				</wea:item>
				<!--相关项目 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("34")),user.getLanguage())%></wea:item>
				<wea:item>
					<%
				   String projectidSpan = "";
				   if(!"".equals(MeetingSearchComInfo.getprojectid())){
						projectidSpan +=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(MeetingSearchComInfo.getprojectid()),user.getLanguage());
					}%>
					<brow:browser viewType="0" name="projectid" browserValue='<%=MeetingSearchComInfo.getprojectid()%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="300px"
					completeUrl="/data.jsp?type=8" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#" 
					browserSpanValue='<%= projectidSpan %>'></brow:browser>
				</wea:item>
			</wea:group>
			<%if(isFirst != 1) {%>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" onclick="search();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
			<%} %>
		</wea:layout>
	</FORM>

	</div>

	<%if(isFirst != 1) {%>
		<%if(isInterval == 1){ %>
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.MT_IntervalMeeting%>"/>
				  <%
	
					int  perpage=10;
					String backfields = "t1.id,t1.name,t1.address,t1.customizeaddress,t1.caller,t1.contacter,t1.creater,t1.createdate,t1.createtime,t1.meetingstatus,t1.begindate,t1.begintime,t1.enddate,t1.endtime,t1.isdecision,t1.repeatbegindate,t1.repeatenddate,t1.repeatType";
					String fromSql  = " Meeting t1, Meeting_ShareDetail t2 ";
					if(SqlWhere.length()>1){
						int indx=SqlWhere.indexOf("where");
						if(indx>-1)
							SqlWhere=SqlWhere.substring(indx+5);
					}
					String sqlWhere = SqlWhere;
	            	//System.out.println("sqlWhere:"+sqlWhere);
	
					String orderby = " t1.repeatbegindate,t1.repeatenddate ,t1.id " ;
					String tableString = "";
					tableString =" <table instanceid=\"meetingTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.MT_IntervalMeeting,user.getUID())+"\" >"+
										 //" <checkboxpopedom    popedompara=\"column:fromUser\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCanCheckBox\" />"+
										 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
										 "			<head>"+
										 "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("2")),user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingName\" otherpara=\"column:id+column:status\" />"+
										 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("5")),user.getLanguage())+"\" column=\"address\" orderkey=\"address\" otherpara=\""+user.getLanguage()+"+column:customizeaddress\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingAddress\" />"+
										 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
										 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("4")),user.getLanguage())+"\" column=\"contacter\" orderkey=\"contacter\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
										 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
										 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"  orderkey=\"createdate,createtime\" otherpara=\"column:createtime\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
										 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("8")),user.getLanguage())+"\" column=\"repeatType\" otherpara=\""+user.getLanguage()+"\" orderkey=\"repeatType\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingRepeatType\" />"+
										 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("15")),user.getLanguage())+"\" column=\"repeatbegindate\"  orderkey=\"repeatbegindate\" />"+
										 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("16")),user.getLanguage())+"\" column=\"repeatenddate\"  orderkey=\"repeatenddate\" />"+
										 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingstatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision+column:repeatenddate+column:repeatType\" orderkey=\"meetingstatus\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingStatus\" />"+
										 "			</head>"+
										 "		<operates>"+
										 "			<popedom column=\"id\" otherpara=\"column:caller+column:contacter+column:creater+column:meetingstatus+column:repeatenddate+"+allUser+"+"+CurrentDate+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkMeetingIntervalOpt\"></popedom> "+
										 "			<operate href=\"javascript:onStopIntvl();\" text=\""+SystemEnv.getHtmlLabelNames("17581,33171",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
										 "			<operate href=\"javascript:onChgIntvl();\" text=\""+SystemEnv.getHtmlLabelName(33172,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
										 "		</operates>"+
										 "</table>";
				 %>
				 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		<%} else { %>
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.MT_MeetingSearch%>"/>
				  <%
				int  perpage=10;
				String backfields = "t1.id,t1.name,t1.address,t1.customizeaddress,t1.caller,t1.createdate,t1.createtime,t1.contacter,t1.creater,t1.meetingstatus,t1.begindate,t1.begintime,t1.enddate,t1.endtime,t1.isdecision";
				String fromSql  = " Meeting t1, Meeting_ShareDetail t2 ";
				if(SqlWhere.length()>1){
					int indx=SqlWhere.indexOf("where");
					if(indx>-1)
						SqlWhere=SqlWhere.substring(indx+5);
				}
				String sqlWhere = SqlWhere;
				String orderby = " t1.enddate,t1.endtime ,t1.id " ;
				String tableString = "";
				tableString =" <table instanceid=\"meetingTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.MT_MeetingSearch,user.getUID())+"\" >"+
									 //" <checkboxpopedom    popedompara=\"column:fromUser\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCanCheckBox\" />"+
									 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
									 "			<head>"+
									 "				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("2")),user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingName\" otherpara=\"column:id+column:status\" />"+
									 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("5")),user.getLanguage())+"\" column=\"address\" orderkey=\"address\" otherpara=\""+user.getLanguage()+"+column:customizeaddress\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingAddress\" />"+
									 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
									 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("4")),user.getLanguage())+"\" column=\"contacter\" orderkey=\"contacter\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
									 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
									 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"  orderkey=\"createdate,createtime\" otherpara=\"column:createtime\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
									 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingstatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision\" orderkey=\"meetingstatus\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingStatus\" />"+
									 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("17")),user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate,begintime\" otherpara=\"column:begintime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
									 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("19")),user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate,endtime\" otherpara=\"column:endtime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
									 "			</head>"+
									 "</table>";
			 %>
			 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
		<%} %>
	<%} %>
    </BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
var diag_vote;

jQuery(document).ready(function(){
	<%if(isFirst != 1) {%>
	$(".tab_menu",window.parent.document).show();
	jQuery("li.current",parent.document).removeClass("current");
	if(jQuery("#timeSag").val()=="0"){
		jQuery("#ALLli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="1"){
		jQuery("#TODAYli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="2"){
		jQuery("#WEEKli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="3"){
		jQuery("#MOUTHli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="4"){
		jQuery("#SEASONli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="5"){
		jQuery("#YEARli",parent.document).addClass("current");
	} else {
		jQuery("#ALLli",parent.document).addClass("current");
	}
	<%}%>
});

function resetCondtion(){
	<%if(isFirst != 1){%>
	resetCondtionBrw("advancedSearchDiv");
	<%} else {%>
	resetCondtionBrw("advancedSearchDiv1");
	<%}%>
	//清空下拉框
	jQuery("#meetingstatus").val("");
	jQuery("#meetingstatus").trigger("change");
	jQuery("#meetingstatus").selectbox('detach');
	jQuery("#meetingstatus").selectbox('attach');
}

function preDo(){
	//tabSelectChg();
	<%if(isFirst != 1){%>
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	<%}%>
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='names']").val(name);
	doSearchsubmit();
}

function clickTab(obj){
	jQuery("#timeSag").val(jQuery(obj).attr("val"));
	doSearchsubmit();
}

function search(){
	doSearchsubmit();
}

function doSearchsubmit(){
	$('#weaverA').submit();
}

function onSearch(obj) {
    obj.disabled = true ;
    doSearchsubmit();
}

function view(id)
{
	if(id!="0" && id !=""){
		if(window.top.Dialog){
			diag_vote = new window.top.Dialog();
		} else {
			diag_vote = new Dialog();
		}
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 550;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = true;
		diag_vote.checkDataChange = false;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
		diag_vote.URL = "/meeting/data/ViewMeetingTab.jsp?meetingid="+id;
		diag_vote.show();
	}
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
	diag_vote.URL = "/meeting/data/NewMeetingTab.jsp?isInterval=1";
	diag_vote.show();
}

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	doSearchsubmit();
}

function dataRfsh(){
	_table.reLoad();
}

//终止周期会议
function onStopIntvl(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33814,user.getLanguage())%>", function (){
		$.post("/meeting/data/AjaxMeetingOperation.jsp",{method:"stopIntervalMeeting",meetingid:id},function(datas){
			doSearchsubmit();
		});
	}, function () {}, 320, 90,true);
	
}

//修改周期会议结束日期
function onChgIntvl(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 330;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(33172,user.getLanguage())%>";
	diag_vote.URL = "/meeting/data/MeetingOthTab.jsp?toflag=chgrepeat&meetingid="+id;
	diag_vote.show();
}

</SCRIPT>
