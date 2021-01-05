
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="mrr" class="weaver.meeting.Maint.MeetingRoomReport" scope="page"/>
<jsp:useBean id="SptmForMeeting" class="weaver.splitepage.transform.SptmForMeeting" scope="page"/>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:include page="/systeminfo/DatepickerLangJs.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<jsp:include page="/systeminfo/WdCalendarLangJs.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />

    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
  
    <script src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>

<META http-equiv=Content-Type content="text/html; charset=UTF-8" />

</head>
<%!
public String formatText(String str, int len){
	return str.length() > len?str.substring(0,len)+"...":str;
}

public String getDayOccupied(String thisDate, List beginDateList, List beginTimeList, List endDateList, List endTimeList, List cancelList)
{
	String[] minute = new String[24 * 60];
	
	for (int i = 0; i < beginDateList.size(); i++)
	{
		String beginDate = (String)beginDateList.get(i);
		String beginTime = (String)beginTimeList.get(i);
		String endDate = (String)endDateList.get(i);
		String endTime = (String)endTimeList.get(i);
		String cancel = (String)cancelList.get(i);
				
		if(!"1".equals(cancel) && beginDate.compareTo(thisDate) <= 0 && thisDate.compareTo(endDate) <= 0)
		{
			if(beginDate.compareTo(thisDate) < 0)
			{
				beginTime = "00:00";
			}
			if(thisDate.compareTo(endDate) < 0)
			{
				endTime = "23:59";
			}
			
			int beginMinuteOfDay = getMinuteOfDay(beginTime);
			int endMinuteOfDay  = getMinuteOfDay(endTime);
			
			while(beginMinuteOfDay <= endMinuteOfDay)
			{
				if("1".equals(minute[beginMinuteOfDay]))
				{
					return "2";
				}
				else
				{
					minute[beginMinuteOfDay] = "1";
				}
			
				beginMinuteOfDay++;
			}
		}	
	}
	
	for(int i = 0; i < 24 * 60; i++)
	{
		if("1".equals(minute[i]))
		{
			return "1";
		}
	}
	return "0";
}

public String getHourOccupied(String thisDate, String thisHour, List beginDateList, List beginTimeList, List endDateList, List endTimeList, List cancelList)
{
	String[] minute = new String[24 * 60];
	
	for (int i = 0; i < beginDateList.size(); i++) 
	{
		String beginDate = (String)beginDateList.get(i);
		String beginTime = (String)beginTimeList.get(i);
		String endDate = (String)endDateList.get(i);
		String endTime = (String)endTimeList.get(i);
		String cancel = (String)cancelList.get(i);
				
		if
		(
			!"1".equals(cancel) 
			&& (beginDate.compareTo(thisDate) < 0 || (beginDate.compareTo(thisDate) == 0 && beginTime.compareTo(thisHour + ":59") <= 0)) 
			&& (thisDate.compareTo(endDate) < 0 || (thisDate.compareTo(endDate) == 0 && (thisHour + ":00").compareTo(endTime) <= 0))
		)
		{
			if(beginDate.compareTo(thisDate) < 0 || beginTime.compareTo(thisHour + ":00") < 0)
			{
				beginTime = thisHour + ":00";
			}
			if(thisDate.compareTo(endDate) < 0 || (thisHour + ":59").compareTo(endTime) <= 0)
			{
				endTime = thisHour + ":59";
			}
			
			int beginMinuteOfHour = getMinuteOfDay(beginTime);
			int endMinuteOfHour  = getMinuteOfDay(endTime);
			
			while(beginMinuteOfHour <= endMinuteOfHour)
			{
				if("1".equals(minute[beginMinuteOfHour]))
				{
					return "2";
				}
				else
				{
					minute[beginMinuteOfHour] = "1";
				}
			
				beginMinuteOfHour++;
			}
		}	
	}
		
	for(int i = 0; i < 24 * 60; i++)
	{
		if("1".equals(minute[i]))
		{
			return "1";
		}
	}

	return "0";
}

private int getMinuteOfDay(String time)
{
	List timeList = Util.TokenizerString(time, ":");
	
	return (Integer.parseInt((String)timeList.get(0)) * 60 + Integer.parseInt((String)timeList.get(1)));
}
%>

<%
int userSub = user.getUserSubCompany1(); 
Calendar calendar = Calendar.getInstance();
boolean isUseMtiManageDetach=ManageDetachComInfo.isUseMtiManageDetach();
int detachable=0;
if(isUseMtiManageDetach){
	detachable=1;
   session.setAttribute("detachable","1");
   session.setAttribute("meetingdetachable","1");
}else{
	detachable=0;
   session.setAttribute("detachable","0");
   session.setAttribute("meetingdetachable","0");
}
    

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15881,user.getLanguage());
String needfav ="1";
String needhelp ="";
char flag=2;
String userid=user.getUID()+"" ;
ArrayList newMeetIds = new ArrayList() ;
boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);
boolean canEdit = "1".equals(request.getParameter("canEdit"))||"true".equals(request.getParameter("canEdit"));

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));
String operation=Util.null2String(request.getParameter("operation"));
String content = Util.null2String(request.getParameter("content")).trim();
int meetingid=Util.getIntValue(request.getParameter("id"),0);
int subids = Util.getIntValue(request.getParameter("subids"), -1);
Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String nowtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                Util.add0(today.get(Calendar.SECOND), 2);  
//System.out.println("operation:"+operation);
//if(operation.equals("cancel")){
//	System.out.println("meetingid:"+meetingid);
//    RecordSet.executeSql("update meeting set cancel='1',meetingStatus=4,canceldate='"+nowdate+"',canceltime='"+nowtime+"' where id="+meetingid);
//}

if(!currentdate.equals("")) {
	int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
	int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
	int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
	today.set(tempyear,tempmonth,tempdate);
} 

int currentyear=today.get(Calendar.YEAR);
int thisyear=currentyear;
int currentmonth=today.get(Calendar.MONTH);  
int currentday=today.get(Calendar.DATE);

switch(bywhat) {
	case 1:
		today.set(currentyear,0,1) ;
		if(movedate.equals("1")) today.add(Calendar.YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.YEAR,-1) ;
		break ;
	case 2:
		today.set(currentyear,currentmonth,1) ;
		if(movedate.equals("1")) today.add(Calendar.MONTH,1) ;
		if(movedate.equals("-1")) today.add(Calendar.MONTH,-1) ;
		break ;
	case 3:
		Date thedate = today.getTime() ;
		int diffdate = (-1)*thedate.getDay() ;
		today.add(Calendar.DATE,diffdate) ;
		if(movedate.equals("1")) today.add(Calendar.WEEK_OF_YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.WEEK_OF_YEAR,-1) ;
		today.add(Calendar.DATE,1);
		break;
	case 4:
		if(movedate.equals("1")) today.add(Calendar.DATE,1) ;
		if(movedate.equals("-1")) today.add(Calendar.DATE,-1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE); 

currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
temptoday1.set(currentyear,currentmonth-1,currentday) ;
temptoday2.set(currentyear,currentmonth-1,currentday) ;

calendar.set(currentyear, currentmonth - 1, currentday);
calendar.add(Calendar.MONTH, 1);
calendar.set(Calendar.DATE, 1);
calendar.add(Calendar.DATE, -1);
int daysOfThisMonth = calendar.get(Calendar.DATE);


switch (bywhat) {
	case 1 :
		today.add(Calendar.YEAR,1) ;
		break ;
	case 2:
		today.add(Calendar.MONTH,1) ;
		break ;
	case 3:
		today.add(Calendar.WEEK_OF_YEAR,1) ;
		break;
	case 4:
		today.add(Calendar.DATE,1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE);  


String currenttodate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
String 	currentWeekEnd = "";
String datefrom = "" ;
String dateto = "" ;
String datenow = "" ;
String cBeginDate="";
String cEndDate="";

switch (bywhat) {
	case 1 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;
		temptoday1.add(Calendar.YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4) ;

		temptoday2.add(Calendar.YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4) ;
		break ;
	case 2 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		temptoday1.add(Calendar.MONTH,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;

		temptoday2.add(Calendar.MONTH,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2) ;
		cBeginDate = TimeUtil.getMonthBeginDay(currentdate);
		cEndDate = TimeUtil.getMonthEndDay(currentdate);
		break ;
 	case 3 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.WEEK_OF_YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;

		temptoday2.add(Calendar.WEEK_OF_YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
		cBeginDate = TimeUtil.getWeekBeginDay(currentdate);
		cEndDate = TimeUtil.getWeekEndDay(currentdate);
		break ;
	case 4 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.DATE,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		
		Calendar datetos = Calendar.getInstance();
		temptoday2.add(Calendar.DATE,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
		cBeginDate = currentdate;
		cEndDate = currentdate;
}

ArrayList meetingroomids = new ArrayList() ;
ArrayList meetingroomnames = new ArrayList() ;

String sqlwhere = "";

if(subids > 0){
	 sqlwhere = "and a.subCompanyId = "+ subids ;
}

if(!"".equals(content.trim())){
	sqlwhere = "and a.name like '%" + content + "%' ";
}

sqlwhere += " and (a.status=1 or a.status is null ) ";

String sql = "select a.id, a.name from MeetingRoom a where 1=1 " + MeetingShareUtil.getRoomShareSql(user) + sqlwhere + " order by id";
//System.out.println("sql2233:"+sql);
//RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmpmeetingroomid=RecordSet.getString(1);
    String tmpmeetingroomname=RecordSet.getString(2);
    meetingroomids.add(tmpmeetingroomid) ;
    meetingroomnames.add(tmpmeetingroomname) ;
}

//get the mapping from the select type
//HashMap mrrHash= mrr.getMapping(datenow,bywhat);	
int dspUnit=meetingSetInfo.getDspUnit();		
	
%>
<BODY style="overflow-y:hidden;background-color:#FFFFFF ">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowMONTH(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1926,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowWeek(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(390,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowDay(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(canEdit){ 
RCMenu += "{"+SystemEnv.getHtmlLabelName(15008,user.getLanguage())+",javascript:newMt(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmmain name=frmmain method=post action="MeetingRoomPlan.jsp">
<input type=hidden name=currentdate value="<%=currentdate%>"/>
<input type=hidden name=bywhat value="<%=bywhat%>"/>
<input type=hidden name=movedate value="" />
<input type=hidden name=canEdit value="<%=canEdit%>" />
<div> 
<style type=text/css>

td.room-selecting .tdfcs{
	BACKGROUND-COLOR: #59b0f2;
}
.tdfcs{
	width:4px;
	height:100%;
	float:left;
}
.thbgc{
	background:#f7f7f7;
}

.selectable .ui-selecting { background: #E1ECFF;}
.selectable .ui-selected { background: #F39814; color: white; }
.selectable { list-style-type: none; margin: 0; padding: 0;cursor :pointer; }

.TH {
	CURSOR: auto; BACKGROUND-COLOR: beige
}
.PARENT {
	CURSOR: auto
}
.TH1 {
	CURSOR: auto; HEIGHT: 25px; BACKGROUND-COLOR: beige
}
.TODAY {
	CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.T_HOUR {
	BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.TI TD {
	BORDER-TOP: 0px; FONT-SIZE: 1px; LEFT: -1px; BORDER-LEFT: 0px; CURSOR: auto; POSITION: relative; TOP: -1px
}
.CU {
	
}
.SD {
	CURSOR: auto; COLOR: white; BACKGROUND-COLOR: mediumblue
}
.L {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.LI {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.L1 {
	BORDER-TOP: white 1px solid; BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.M1 TD {
	 BORDER-bottom: 1px solid #d0d0d0;BORDER-LEFT: 1px solid #d0d0d0;color:#606060;
}


.M1 {
	BORDER-RIGHT: 1px solid #d0d0d0; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; min-width:900px !important;
}
.MI {
	TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; min-width:900px !important;
}

.M1 {
	BORDER-top: 0px solid #d0d0d0;
}
.M11 {
	BORDER-top: 1px solid #d0d0d0;BORDER-RIGHT: 1px solid #d0d0d0; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; min-width:900px !important;
}
.WE {
	BORDER-LEFT-WIDTH: 0px
}
.PI TD {
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid
}

.searchBox .searchInput{
	height:19px;
	border-right:none;
	width:170px;
	background:#fff;
}
.searchBox{
    margin-left:0px;
    margin-bottom:2px;
	background:#f7f7f7;
	line-height:23px;
	font-weight:bold;
	text-align:center;
	width:200px;
	height:23px;
	_height:25px;
	cursor:pointer;
	display:inline-block;
	opacity: 1;
}
.roomnames {
		height:25px;
		cursor :pointer;
		background:#f7f7f7;
}
.roomnames .tdtxt {
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		height:25px;
		line-height:25px;
		width:214px;
		float:left
}

.searchBox .Browser:hover{
	background:#f1eeee;
}

.subidsSpan{
	width:100px;
	word-break: keep-all;
	text-overflow: ellipsis;
	white-space: nowrap;
	overflow: hidden;
}

<%if(!canEdit){%>
.tdcls{
	  cursor: not-allowed !important;
}
<%}%>
</style>
<%
      String addBtnUrl="/meeting/calendar/css/images/icons/addBtn_wev8.png";
	  if(user.getLanguage()==8){
		  addBtnUrl="/meeting/calendar/css/images/icons/addBtn_EN_wev8.png";
	  }
%>
  </div>
    <div id="calhead" class="calHd" style="height:36px;padding-left:0px;min-width:900px !important;background-color: #f7f7f7;">
      		<div style="float:left;margin-left:10px;border:none;height:24px;">
      			<div id="showLayoutbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName(33402,user.getLanguage()) %>" val="0" unselectable="on" class="calHdBtn showLayoutbtnT" style="margin-left:10px;border:none;height:24px;">
				<INPUT type=hidden name="subids" id="subids" value="<%if(subids > 0){%><%=subids %><%} %>" />
				</div>
				
	      		<div  id="showsubcompanybtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName(33256,user.getLanguage()) %>" class="calHdBtn" style="margin-left:0px;width:auto !important;padding-left:0px;padding-right:10px;text-align:left;color:#59b0f2" >
						
						<% String subidsSpan = SystemEnv.getHtmlLabelName(141,user.getLanguage());
							if(subids > 0){
								subidsSpan += " : "+SubCompanyComInfo.getSubCompanyname(""+subids);
							} else {
								RecordSet.executeSql("SELECT companyname FROM HrmCompany WHERE id = 1");
								if(RecordSet.next()){
									subidsSpan =  SystemEnv.getHtmlLabelName(140,user.getLanguage())+" : "+Util.null2String(RecordSet.getString("companyname"));
								}
							} 
						%>
						<%=subidsSpan%>
	      		</div>
	      		<div class="rightBorder" style="margin-left:10px;margin-right:13px">|</div>
      		</div>
      		<!-- 
      		
			 -->
			<%if(canEdit){ %>
      		<div  id="firstButtons" style="float:left;min-width:40px !important;">
      			<div id="faddbtn" class="calHdBtn faddbtn" title="<%=SystemEnv.getHtmlLabelName( 15008 ,user.getLanguage())%>" style="border:none;height:25px;">
      			</div>
				<div class="rightBorder" style="margin-left:10px;margin-right:10px">|</div>
      		</div>
      		<%} %>
			<div id="editButtons2" style="float:left;min-width:60px !important;">
		      		  <%if(user.getLanguage()==8) {%>
      		    <div id="showdaybtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 390 ,user.getLanguage())%>" class="calHdBtn     <% if(bywhat==4) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="margin-left:0px;width:30px;font-size: 15px;">
	      			D
	      		</div>
	      		<div id="showweekbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> " class="calHdBtn   <% if(bywhat==3) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			W
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%>" class="calHdBtn   <% if(bywhat==2) {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			M
	      		</div>
      		    <%} else { %>
            	<div id="showdaybtn" unselectable="on" class="calHdBtn <% if(bywhat==4)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="margin-left:0px;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 390 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showweekbtn" unselectable="on" class="calHdBtn <% if(bywhat==3)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" class="calHdBtn <% if(bywhat==2)  {%>txtbtncls<%} else {%>txtbtnnoselcls<%}%>" style="border-left:none;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%> 
	      		</div>
	      		<%} %>
					<div id="showreflashbtn" unselectable="on" class="calHdBtn showreflashbtn" title="<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%>" style="height:24px;border:none;margin-left:10px;border:none;">
					</div>
				<div class="rightBorder" style="margin-left:10px;margin-right:15px">|</div>
               </div>
			   
			<div id="editButtons1" style="float:left;min-width:122px !important;">
					<% String titlestrnow=""; 
					if(bywhat==2) {
		      			titlestrnow =SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage());
					}else if(bywhat==3){
						titlestrnow=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage());
					}else if(bywhat==4){
						titlestrnow=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage()); 
					}%>
					<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="<%=titlestrnow%>" style="height:24px;margin-left:0px;border:none;">
		      			 
		      		</div>
		      		<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName( 33960 ,user.getLanguage()) %>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;">
		      		</div>
					<input type="hidden" name="txtshow" id="hdtxtshow" />
					<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtncls" style="border:none;width:auto;padding-left:1px;padding-right:10px;">
						
					</div>
		      		<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName( 33961 ,user.getLanguage()) %>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;">
		      		</div>
					
				</div>
			
      		<!--
			<div style="float:right;padding-right:5px;">
				<div  width="15" unselectable="on" class="calHdBtn" style="border:1px solid #d0d0d0;color:red;margin-left:10px;width:auto !important;padding-left:10px;padding-right:10px;text-align:left;">&nbsp;<%=(SystemEnv.getHtmlLabelName(19098,user.getLanguage())).substring(2)%>&nbsp;</div>
      		</div>
			-->
      		
      </div>
  <table class=MI id=AbsenceCard cellSpacing=0 cellPadding=0>

		<tr>
			<td id="treetd"style="display:none; BORDER-top: 1px solid #d0d0d0; BORDER-LEFT: 0px;width:247px;vertical-align: top;" rowspan="2">
				
				<div id="subCompanytDiv" style="position:absolute;width:245px;min-height:300px;background:#f7f7f7;BORDER-right: 1px solid #d0d0d0;">
					<IFRAME  id="subCompanytifm"  width="100%"  frameborder=no scrolling=no src="">
				</IFRAME>
				</div>
			</td>
			<td style="BORDER-TOP: 0px; BORDER-LEFT: 0px;vertical-align: top;width:100%">
			<div id="tablediv" style="overflow-y: hidden;overflow-x:auto;position: relative;width:100%">
			<div id="tableChlddiv">
				<input type="hidden" name="datenow" id="datenow" value="<%=datenow%>" />
				<table  class=M11 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				    <COLGROUP>
						<col width="221">
						<col width="">
				    <tr  class="thbgc">
						 	<td class="schtd" align=center style="width:220px;background:#f7f7f7;BORDER-left: 1px solid #d0d0d0;height:25px; ">
								<table height="100%" width="100%" border=0 cellspacing=0 cellpadding=0>
									<tr>
										<td width="20px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
										<button class="Browser" id=namebtn name=namebtn type="button" style="margin-top: 3px !important;" onclick="" ></button>
										</td>
										<td  width="200px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
										<INPUT id=content name=content class="searchInput" onmouseover="this.select()" onfocus="clearVal(this);" onblur="recoverVal(this);"   value="<%=content %>" style="width:180px;height:23px;border:0px;background:#f7f7f7;color:#606060" /> 
										</td>
									</tr>
								</table>
							</td>
						<%for(int i=meetingSetInfo.getTimeRangeStart();i<=meetingSetInfo.getTimeRangeEnd();i++){%>
							<%if(i == meetingSetInfo.getTimeRangeStart()) { %>
								<td class="thcls" style="BORDER-left: 1px solid #d0d0d0;" align=center><%=i%></td>
							<%}else{%>
								<td class="thcls" style="BORDER-LEFT: 0px" align=center><%=i%></td>
							<%}%>
						<%}%>
				    </tr>
				</table>
			</div>
			</div>
		</td>
	</tr>
	<tr>
		<td style="BORDER-TOP: 0px; BORDER-LEFT: 0px;vertical-align: top;">
			<div id="MeetingListDiv">
				<IFRAME name="listframe" id="listframe"  width="100%" frameborder=no scrolling=no>
				</IFRAME>
			</div>
		</td>
	</tr>
</table>



	
</FORM>
	<!-- next show meeting use list-->
	
	
	
  



<script language=javascript>
var showCnt = 0;
var diag_vote;
jQuery(document).ready(function(){
	
	//$("#MeetingListDiv").load("GetRoomMeetingList.jsp?bywhat=<%=bywhat%>&datenow=<%=datenow%>&subids=<%=subids%>&content=<%=content%>");
	//$("#listframe").attr("src","GetRoomMeetingList.jsp?bywhat=<%=bywhat%>&datenow=<%=datenow%>&subids=<%=subids%>&content=<%=content%>");
	submit();
	var cBeginDate="<%=cBeginDate%>";
	var cEndDate="<%=cEndDate%>";
	var showtime = "";
	var titletime=""; 
	
	<% if(bywhat==2) {%>
		//titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))));
		titletime = CalDateShowMonth(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
		showtime = titletime;
	<% }else if(bywhat==3){%>
	    titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))), null, true);
	    showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))));
		$(".weekclass").each(function(){
			var dateStr = new Date(Date.parse($(this).attr("val").replace(/-/g,   "/")));
			$(this).html(dateFormat.call(dateStr, getymformat(dateStr, null, null, true,null, false)));
		});
	<% }else if(bywhat==4){%>
		titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), null, null, true)+"&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>";
		showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
	<%}%>

	jQuery("body").bind("mousemove", function(event){createMeetingAction.moving(event)});
	jQuery("body").bind("mouseup", function(event){createMeetingAction.stopDrag(event)});
		
	//to show day view
  $("#showdaybtn").click(function(e) {
		
		ShowDay();
   });
   //to show week view
   $("#showweekbtn").click(function(e) {

		ShowWeek();
   });
   //to show month view
   $("#showmonthbtn").click(function(e) {
		
		ShowMONTH();

   });
   //refresh current View
   $("#showreflashbtn").click(function(e){
		submit();
   });
   
  
   //go to today
   $("#showtodaybtn").click(function(e) {
   		document.frmmain.currentdate.value = "" ;
     	submit();
   });
   //previous date range
   $("#sfprevbtn").click(function(e) {
      getSubdate();

   });
   //next date range
   $("#sfnextbtn").click(function(e) {
      getSupdate();
   });
   
   $("#namebtn").live("click", function() {
      submit();
   });
   
   $("#showLayoutbtn").click(function(e) {
    //$("#subCompanytDiv").css("right", -245).show().animate({ right: 0 }, { duration: 200, complete: function() {
	//		$("#subCompanytDiv").show();
	//		if(showCnt == 0){
	//			$("#subCompanytifm").attr("src","/meeting/Maint/MeetingSubCompanyTree.jsp");
	//			showCnt = 1;
	//		} else {
	//			var doc = document.getElementById('subCompanytifm').contentWindow.document;
	//			if(!!doc){
	//				jQuery('.flowMenusTd',doc).show();
	//			}
	//		}
	//	} });
	//
	//return false;
		showCompanyTree();
   });
   //$("#showsubcompanybtn").click(function(e) {
   //		showCompanyTree();
   //});
    
   //Add a new meeting
   $("#faddbtn").click(function(e) {
   		//var url = "/meeting/data/NewMeetingTab.jsp";
   		//var today=new Date();
   		//var currentdate = dateFormat.call(today, i18n.xgcalendar.dateformat.fulldayvalue);
		//var hours=today.getHours();
       // var min=today.getMinutes();
		//url +="?startdate="+currentdate;
		//url +="&starttime="+(hours>9?hours:"0"+hours)+":"+(min>9?min:"0"+min);
		//newMeeting(url);
		
		newMt();
   	 
   });
   
   
   //显示时间控件 
   $("#hdtxtshow").datepickernew({ 
   	   picker: "#txtdatetimeshow", 
   	   showtarget: $("#txtdatetimeshow"),
	   onReturn:function(r){
	   		var d = CalDateShow(r);
	   		if(d && r){
	   			jQuery("#frmmain")[0].currentdate.value = dateFormat.call(r, i18n.xgcalendar.dateformat.fulldayvalue);
				submit();
				$("#hdtxtshow").val(dateFormat.call(r, i18n.datepicker.dateformat.fulldayvalue));
	    		//$("#txtdatetimeshow").text(d);
	    	}
	     } 
		<% if(bywhat==2) {%>
        ,selectMode:"1"
		<%}%>
   });
   
   recoverVal($GetEle("content"));
   
	var bodyheight = document.body.offsetHeight;
	$("#subCompanytDiv").height(bodyheight - 44);
	$("#subCompanytifm").height(bodyheight - 44);
   $(".thcls").css("border-bottom","1px solid #59b0f2");
   $(".schtd").css("border-bottom","1px solid #59b0f2");
   $(".schtd").css("border-left","0px");
   $(".roomnames").css("border-left","0px");
   $("#txtdatetimeshow").text(showtime);
})
var enable = true;

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	submit();
	try{
	diag_vote.close();
	}catch(e){};
}

function dataRfsh(){
	submit();
}

function newMt(){
	var url = "/meeting/data/NewMeetingTab.jsp";
	var today=new Date();
	var currentdate = dateFormat.call(today, i18n.xgcalendar.dateformat.fulldayvalue);
	var hours=today.getHours();
	var min=today.getMinutes();
	url +="?startdate="+currentdate;
	url +="&starttime="+(hours>9?hours:"0"+hours)+":"+(min>9?min:"0"+min);
	newMeeting(url);
}

function showCompanyTree(){
	if($("#treetd").css("display")=="none"){
		$("#treetd").css("display","");
		$("#showLayoutbtn").removeClass("showLayoutbtnT");
		$("#showLayoutbtn").addClass("showLayoutbtnO");
	}else{
		$("#treetd").css("display","none");
		$("#showLayoutbtn").removeClass("showLayoutbtnO");
		$("#showLayoutbtn").addClass("showLayoutbtnT");
	}
	if($("#subCompanytifm").attr("src") == ""){
		$("#subCompanytifm").attr("src","/meeting/Maint/MeetingSubCompanyTree.jsp");
	}
	setWindowSize(document);
}

function changeShowType(obj){
	if($("#showdaybtn").hasClass("txtbtncls")){
		$("#showdaybtn").removeClass("txtbtncls");
	}
	if(!$("#showdaybtn").hasClass("txtbtnnoselcls")){
		$("#showdaybtn").addClass("txtbtnnoselcls");
	}
	
	if($("#showweekbtn").hasClass("txtbtncls")){
		$("#showweekbtn").removeClass("txtbtncls");
	}
	if(!$("#showweekbtn").hasClass("txtbtnnoselcls")){
		$("#showweekbtn").addClass("txtbtnnoselcls");
	}
	
	if($("#showmonthbtn").hasClass("txtbtncls")){
		$("#showmonthbtn").removeClass("txtbtncls");
	}
	if(!$("#showmonthbtn").hasClass("txtbtnnoselcls")){
		$("#showmonthbtn").addClass("txtbtnnoselcls");
	}
	
	if(!$(obj).hasClass("txtbtncls")){
		$(obj).addClass("txtbtncls");
	}
	if($(obj).hasClass("txtbtnnoselcls")){
		$(obj).removeClass("txtbtnnoselcls");
	}
}


function setTDWidth(cnt){
	//var chwid = $("#calhead").width();
	//var thwid = (chwid - 223)/cnt;
	//var tdwid = (chwid - 222)/cnt;
	//$(".thcls").width(thwid);
	//$(".tdcls").width(tdwid - 1);

}

function showRoomMeetingList(day,time,roomid,event){
	this.roomid = "";
	var selected = false;
	event = jQuery.event.fix(event);
	var startElement = event.target;
	clearVal($GetEle("content"));
	if(jQuery(startElement).parent("td.roomnames").hasClass("room-selecting")){
		jQuery(startElement).parent("td.roomnames").removeClass("room-selecting");
		$("#listframe").attr("src","GetRoomMeetingList.jsp?bywhat="+$GetEle("bywhat").value+"&datenow="+$GetEle("datenow").value+"&subids="+$GetEle("subids").value+"&content="+$GetEle("content").value);
	} else{
		$(".room-selecting").each(function(){
			$(this).removeClass("room-selecting");
		});
		this.roomid = startElement.id;
		jQuery(startElement).parent("td.roomnames").addClass("room-selecting");
		$("#listframe").attr("src","GetRoomMeetingList.jsp?bywhat="+$GetEle("bywhat").value+"&datenow="+$GetEle("datenow").value+"&subids="+$GetEle("subids").value+"&content="+$GetEle("content").value+"&roomid="+roomid);
	}
	
	recoverVal($GetEle("content"));
		
}

function CalDateShow(startday, endday, isshowtime, isshowweek) {
  if (!endday) {
      return dateFormat.call(startday, getymformat(startday,null,isshowtime,isshowweek));
  } else {
      var strstart= dateFormat.call(startday, getymformat(startday, null, isshowtime, isshowweek));
			var strend=dateFormat.call(endday, getymformat(endday, startday, isshowtime, isshowweek));
			var join = (strend!=""? " - ":"");
			return [strstart,strend].join(join);
  }
}

function CalDateShowMonth(startday) {
    return dateFormat.call(startday, getymformatMonth(startday));
}

function getymformatMonth(date) {
	var a = [];
	a.push(i18n.xgcalendar.dateformat.yM);
	return a.join("");
}

function getymformat(date, comparedate, isshowtime, isshowweek, showcompare, ishowyear) {
            var showyear = isshowtime != undefined ? (date.getFullYear() != new Date().getFullYear()) : true;
            if(ishowyear != undefined && ishowyear == false){
            	showyear = false;
            }
            var showmonth = true;
            var showday = true;
            var showtime = isshowtime || false;
            var showweek = isshowweek || false;
            if (comparedate) {
                showyear = comparedate.getFullYear() != date.getFullYear();
                //showmonth = comparedate.getFullYear() != date.getFullYear() || date.getMonth() != comparedate.getMonth();
                if (comparedate.getFullYear() == date.getFullYear() &&
					date.getMonth() == comparedate.getMonth() &&
					date.getDate() == comparedate.getDate()
					) {
                    showyear = showmonth = showday = showweek = false;
                }
            }

            var a = [];
            if (showyear) {
                a.push(i18n.xgcalendar.dateformat.fulldayshow)
            } else if (showmonth) {
                a.push(i18n.xgcalendar.dateformat.Md3)
            } else if (showday) {
                a.push(i18n.xgcalendar.dateformat.day);
            }
            a.push(showweek ? " (W)" : "", showtime ? " HH:mm" : "");
            return a.join("");
        }


dateFormat = function(format) {
			var __WDAY = new Array(i18n.xgcalendar.dateformat.sun, i18n.xgcalendar.dateformat.mon, i18n.xgcalendar.dateformat.tue, i18n.xgcalendar.dateformat.wed, i18n.xgcalendar.dateformat.thu, i18n.xgcalendar.dateformat.fri, i18n.xgcalendar.dateformat.sat);                                                                                                                                                                      
			var __MonthName = new Array(i18n.xgcalendar.dateformat.jan, i18n.xgcalendar.dateformat.feb, i18n.xgcalendar.dateformat.mar, i18n.xgcalendar.dateformat.apr, i18n.xgcalendar.dateformat.may, i18n.xgcalendar.dateformat.jun, i18n.xgcalendar.dateformat.jul, i18n.xgcalendar.dateformat.aug, i18n.xgcalendar.dateformat.sep, i18n.xgcalendar.dateformat.oct, i18n.xgcalendar.dateformat.nov, i18n.xgcalendar.dateformat.dec); 
			
            var o = {
                "M+": this.getMonth() + 1,
                "d+": this.getDate(),
                "h+": this.getHours(),
                "H+": this.getHours(),
                "m+": this.getMinutes(),
                "s+": this.getSeconds(),
                "q+": Math.floor((this.getMonth() + 3) / 3),
                "w": "0123456".indexOf(this.getDay()),
                "W": __WDAY[this.getDay()],
                "L": __MonthName[this.getMonth()] //non-standard
            };
            if (/(y+)/.test(format)) {
                format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            }
            for (var k in o) {
                if (new RegExp("(" + k + ")").test(format))
                    format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
            }
            return format;
};

function CreateMeetingAction()
{
	this.roomid;
	this.active;
	this.startTime;
	this.endTime;
}
CreateMeetingAction.prototype.startDrag = function(event)
{	
	<%if(canEdit){%>
	this.roomid = "";
	this.startTime = "";
	this.endTime = "";
	this.active = false;
	event = jQuery.event.fix(event);
	if(enable && (0 == event.button || 1 == event.button))
	{
		var startElement = event.target;
		this.roomid = startElement.id;
		this.startTime =jQuery(startElement).attr("target");
		this.endTime = jQuery(startElement).attr("target");
		startElement.className = "ui-selecting";
		this.active = true;
	}
	<%}%>
}
CreateMeetingAction.prototype.moving = function(event)
{	
	<%if(canEdit){%>
	if(enable && this.active)
	{
		event = jQuery.event.fix(event);
		var movingElement = event.target;
		var pElement = movingElement.parentNode;
		if(pElement.tagName=="TR"&&pElement.className=="selectable")
		{
			var roomid = movingElement.id;
			if(roomid==this.roomid)
			{
				this.roomid = movingElement.id;
				this.endTime = jQuery(movingElement).attr("target");
				
				var st=parseInt(this.startTime);
				var et=parseInt(this.endTime);
				if(st>et){
					st=parseInt(this.endTime);
					et=parseInt(this.startTime);
				}
				
				jQuery('td[roomid="'+roomid+'"]').each(function(){
					var target=parseInt(jQuery(this).attr("target"));
					if(st>target||et<target){
						if(jQuery(this).hasClass("ui-selecting")){
							jQuery(this).removeClass("ui-selecting");
						}
					}else{
						if(!jQuery(this).hasClass("ui-selecting")){
							jQuery(this).addClass("ui-selecting")
						}
					}
				});
				
				//jQuery('.ui-selecting').each(function(){
				//	var target=parseInt(jQuery(this).attr("target"));
				//	if(st>target||et<target){
				//		jQuery(this).removeClass("ui-selecting");
				//	}
					
				//});
				
				//jQuery(movingElement).css("background-color","#E1ECFF");
			}
		}
	}
	<%}%>
}
CreateMeetingAction.prototype.stopDrag = function(event)
{	
	<%if(canEdit){%>
	event = jQuery.event.fix(event);
	if(enable && this.active)
	{
		this.createMeeting();
		this.active = false;
	}
	<%}%>
}
CreateMeetingAction.prototype.createMeeting = function()
{  
	var url = "/meeting/data/NewMeetingTab.jsp";
	url +="?roomid="+this.roomid;
	var currentdate = document.frmmain.currentdate.value;
	url +="&startdate="+currentdate;
	url +="&enddate="+currentdate;
	var tempStartTime = this.startTime;
	var tempEndTime = this.endTime;
	if(parseInt(tempStartTime)>parseInt(tempEndTime))
	{
		var temp = this.startTime;
		this.startTime = this.endTime;
		this.endTime = temp;
	}
	
	tempStartTime = gettimebg(this.startTime);
	tempEndTime = gettimeend(this.endTime);


	url +="&starttime="+tempStartTime;
	url +="&endtime="+tempEndTime;
	var isused = checkMeetingRoom(this.roomid);
	var iscontinue = false;
	
	if(isused && <%=meetingSetInfo.getRoomConflictChk()%> == 1)
	{
		Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>", function (){
					resetMeetingRoom("");
					newMeeting(url);
			}, function () { resetMeetingRoom("");});
	}
	else
	{
		iscontinue = true;
		resetMeetingRoom(this.roomid);
		newMeeting(url);
	}
}

function newMeeting(url){
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
	<%if(user.getLanguage() == 8){%>
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
	<%} else {%>
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
	<%}%>
	diag_vote.URL = url;
	diag_vote.show();
}

var createMeetingAction = new CreateMeetingAction();
function checkMeetingRoom(roomid)
{	
	if(roomid!=""){
		var isuse="0";
		jQuery('td[roomid="'+roomid+'"]').each(function(){
			if(jQuery(this).hasClass("ui-selecting")){
				var bc = jQuery(this).attr("bgcolor")
				if(bc !=""&&bc != "#f5f5f5"&&typeof(bc)!="undefined"&&bc!="undefined")
				{
					isuse="1";
					return false;
				}
			}
		});
		if(isuse=="1"){
			return "1";
		}
	}
}
function resetMeetingRoom(roomid)
{	
	if(roomid!=""){
		jQuery('td[roomid="'+roomid+'"]').each(function(){
			if(jQuery(this).hasClass("ui-selecting")){
				jQuery(this).removeClass("ui-selecting"); 
			}
		});
	}else{
		jQuery('td[roomid]').each(function(){
			if(jQuery(this).hasClass("ui-selecting")){
				jQuery(this).removeClass("ui-selecting"); 
			}
		});
	}
}
function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	submit() ;
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	submit();
}
function ShowYear() {
	document.frmmain.bywhat.value = "1" ;
	document.frmmain.currentdate.value = "" ;
	submit();
}
function ShowMONTH() {
	changeShowType($("#showmonthbtn"));
	$("#txtdatetimeshow").attr("selectMode", '1');
	document.frmmain.bywhat.value = "2" ;
	document.frmmain.currentdate.value = "" ;
	submit();
}
function ShowWeek() {
	changeShowType($("#showweekbtn"));
	$("#txtdatetimeshow").attr("selectMode", '0');
	document.frmmain.bywhat.value = "3" ;
	document.frmmain.currentdate.value = "" ;
	submit();
}
function ShowDay() {
	changeShowType($("#showdaybtn"));
	$("#txtdatetimeshow").attr("selectMode", '0');
	document.frmmain.bywhat.value = "4" ;
	document.frmmain.currentdate.value = "" ;
	submit();
}
function doCancel(id){
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(20117,user.getLanguage())%>", function (){
		$.post("/meeting/data/MeetingOperation.jsp",{method:'cancelMeeting',meetingId:id},function(datas){
			submit();
		});
	}, function () {}, 320, 90,true);
	
}

function setSubcompany(subid){
	$("#subids").val(subid);
	onSubChange();
}

function onSubChange(){
	submit();
}

function selectRoot(){
	$("#subids").val("");
	onSubChange();
}

function submit(){
	clearVal($GetEle("content"));
	//document.frmmain.submit();
	getMeetingInfo();
}

var expr = new RegExp('>[ \t\r\n\v\f]*<', 'g');
function getMeetingInfo(){
	
	$.post("/meeting/report/AjaxMeetingRoomPlan.jsp",{bywhat:$GetEle("bywhat").value,currentdate:$GetEle("currentdate").value,movedate:$GetEle("movedate").value,content:encodeURIComponent($GetEle("content").value),subids:$GetEle("subids").value,canEdit:$GetEle("canEdit").value},function(datas){
		datas = datas.replace(expr, '><');
		jQuery("#tableChlddiv").html(datas);
		//jQuery("#tableChlddiv").append(datas);
		afterLoadDate();
	});
}


function setWindowSize(_document){
	if(!!_document)_document = document;
	var bodyheight = _document.body.offsetHeight;
	var listframeh = jQuery("#listdiv",window.frames["listframe"].document).height() + 5;
	
	//获取list列表内容实际高度
	var listH=jQuery("#_xTable",window.frames["listframe"].document).find("tr.Spacing").length*30+30+60;//数据高度+表头+分页
	var listSizeNum=jQuery("#_xTable",window.frames["listframe"].document).find("tr.Spacing").length;//几条数据
	listH=listH>120?listH:120;//无数据的时候,最小120
	listframeh=listframeh>listH?listframeh:listH;
	
	var max_listframeh=(bodyheight-65)/2;//list允许的最大高度. 默认为一半.
	var tabledivDataH=jQuery("#tableChlddivData").height()+65;//上半部分当前高度
	max_listframeh=tabledivDataH>(bodyheight-65)/2?max_listframeh:(bodyheight-20-tabledivDataH)
	listframeh=listframeh>max_listframeh?max_listframeh:listframeh;
	//解决当列表内容(1条或者2条时), 分页控件无法选择分页条数. 会导致底部留白
	if(listframeh<max_listframeh && listSizeNum>0 && listSizeNum<3){
		listframeh=200+(30*listSizeNum);
	}
	
	//listframeh = 305;
	jQuery("#listframe").height(listframeh);
	var bottomheight = listframeh+2;
	jQuery("#MeetingListDiv").height(listframeh+2);
	
	if(bottomheight>0){
		bottomheight = 51 + bottomheight;
	}
	var tdhm1 = jQuery(".M1").height();
	if(jQuery(".M1").width() > jQuery("#tabledivData").width()){
		tdhm1 = tdhm1 + 16;
	}
	
	var cah = bodyheight-bottomheight-26;
	jQuery("#tabledivData").css("height",tdhm1 > cah ? cah:tdhm1+2);
	var width_M11=jQuery(".M11").width();//QC327344
	
	jQuery("#tabledivData").perfectScrollbar('update');
	jQuery(".ps-scrollbar-y").position.top=jQuery("#tabledivData").position.top;
	jQuery("#tabledivData").css("width",width_M11);//QC327344
	
}

//QC327344 窗口变化时，重新计算表格宽度
jQuery(window.frames["mainFrame"]).css("overflow-x","scroll");//解决IE8下，页面横向滚动条不出现的问题
jQuery(window).resize(
		function(){
			var width_M11=jQuery(".M11").width();
			jQuery("#tabledivData").css("width",width_M11);
});

<!--

function clearVal(obj){
	if(obj.value=='<%=SystemEnv.getHtmlLabelName(82892,user.getLanguage())%>'){
		obj.value="";
		obj.style.color="#606060";
	}
}

function recoverVal(obj){
	if(obj.value==''||obj.value==null){
		obj.value="<%=SystemEnv.getHtmlLabelName(82892,user.getLanguage())%>";
		obj.style.color="#d0d0d0";
	}
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
		diag_vote.URL = "/meeting/data/ViewMeetingTab.jsp?needRefresh=false&meetingid="+id;
		diag_vote.show();
	}
}

//function closeDialog(){
//	diag_vote.close();
//}

//function closeDlgARfsh(){
//	diag_vote.close();
//}
//-->

function gettimebg(index){
	if("1"=="<%=dspUnit%>"){//一小时
		if(index.length==1)
		{
			index = "0"+index;
		}
		return index+":00";
	}else{//半小时
		var hour = parseInt(index/parseInt("<%=dspUnit%>"));
		var minute = (60/parseInt("<%=dspUnit%>"))*parseInt(index%parseInt("<%=dspUnit%>"));
		var times = (hour > 9 ? (""+hour) :("0"+hour)) +":"+  (minute > 9 ? (""+minute) :("0"+minute));
	    return times;
	}
	
}
function gettimeend(index){
	if("1"=="<%=dspUnit%>"){//半小时
    	if(index.length==1)
		{
			index = "0"+index;
		}
		return index + ":59";
    }else{
		var hour = parseInt(index/parseInt("<%=dspUnit%>"));
		var minute = ((60/parseInt("<%=dspUnit%>"))*(parseInt(index%parseInt("<%=dspUnit%>"))+1)-1);// parseInt(index%parseInt("<%=dspUnit%>") == 0 ?29:59;
		var times = (hour > 9 ? (""+hour) :("0"+hour)) +":"+  (minute > 9 ? (""+minute) :("0"+minute));
	    return times;
    }
}

function doOver(id){
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126004,user.getLanguage())%>", function (){
		$.post("/meeting/data/MeetingOperation.jsp",{method:'overMeeting',meetingId:id},function(datas){
			submit();
		});
	}, function () {}, 320, 90,true);
}
</script>


</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
</html>

