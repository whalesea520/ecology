
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="java.net.URLDecoder" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="mrr" class="weaver.meeting.Maint.MeetingRoomReport" scope="page"/>
<jsp:useBean id="SptmForMeeting" class="weaver.splitepage.transform.SptmForMeeting" scope="page"/>

<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<%!
public String getTimesBg(int j,int dspUnit){
	int totalminutes = (j+1) * (60/dspUnit);
	int hours = (int)totalminutes/60;
	int minute = totalminutes%60;
	String times = (hours > 9 ? (""+hours) :("0"+hours)) +":"+  (minute > 9 ? (""+minute) :("0"+minute));
    return times;
}

public String getTimesEd(int j,int dspUnit){
	int totalminutes = (j+1) * (60/dspUnit);
	int hours = (int)totalminutes/60;
	int minute = totalminutes%60;
	if(minute==0){
		minute=59;
		hours-=1;
	}else{
		minute-=1;
	}
	String times = (hours > 9 ? (""+hours) :("0"+hours)) +":"+  (minute > 9 ? (""+minute) :("0"+minute));
    return times;
}

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
			if(!beginTime.split(":")[1].equals("59")){
				beginMinuteOfDay+=1;
			}
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

public String getHourOccupied(String thisDate, String thisHour, List beginDateList, List beginTimeList, List endDateList, List endTimeList, List cancelList,int dspUnix)
{
	String[] minute = new String[24 * 60];
	String starttime1 = dspUnix==1?((thisHour.length()==1?"0"+thisHour:thisHour)+":00"):getTimesBg(Util.getIntValue(thisHour)-1,dspUnix);
	String endtime1 = dspUnix==1?((thisHour.length()==1?"0"+thisHour:thisHour)+":59"):getTimesEd(Util.getIntValue(thisHour),dspUnix); 
	
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
			&& (beginDate.compareTo(thisDate) < 0 || (beginDate.compareTo(thisDate) == 0 && beginTime.compareTo(endtime1) <= 0)) 
			&& (thisDate.compareTo(endDate) < 0 || (thisDate.compareTo(endDate) == 0 && (starttime1).compareTo(endTime) <= 0))
		)
		{
			if(beginDate.compareTo(thisDate) < 0 || beginTime.compareTo(starttime1) < 0)
			{
				beginTime = starttime1;
			}
			if(thisDate.compareTo(endDate) < 0 || (endtime1).compareTo(endTime) <= 0)
			{
				endTime = endtime1;
			}
			
			int beginMinuteOfHour = getMinuteOfDay(beginTime);
			int endMinuteOfHour  = getMinuteOfDay(endTime);
			if(!beginTime.split(":")[1].equals("59")){
				beginMinuteOfHour+=1;
			}
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
User user = HrmUserVarify.getUser(request,response);
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
String titlename = "";
String needfav ="1";
String needhelp ="";
char flag=2;
String userid=user.getUID()+"" ;
ArrayList newMeetIds = new ArrayList() ;
boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));
String operation=Util.null2String(request.getParameter("operation"));
String content = URLDecoder.decode(Util.null2String(request.getParameter("content")).trim(),"utf-8");
String canEdit = Util.null2String(request.getParameter("canEdit"));
//System.out.println("content:"+content);
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
if(operation.equals("cancel")){
    RecordSet.executeSql("update meeting set cancel='1',meetingStatus=4,canceldate='"+nowdate+"',canceltime='"+nowtime+"' where id="+meetingid);
}

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

String sql = "select a.id, a.name from MeetingRoom a where 1=1 " + MeetingShareUtil.getRoomShareSql(user) + sqlwhere + " order by dsporder,name ";
//System.out.println("sql2233:"+sql);
RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmpmeetingroomid=RecordSet.getString(1);
    String tmpmeetingroomname=RecordSet.getString(2);
    meetingroomids.add(tmpmeetingroomid) ;
    meetingroomnames.add(tmpmeetingroomname) ;
}

//get the mapping from the select type
HashMap mrrHash= mrr.getMapping(datenow,bywhat);	
	
int dspUnit=meetingSetInfo.getDspUnit();	
%>
			<input type="hidden" name="datenow" id="datenow" value="<%=datenow%>" />
			<!--============================ 月报表 ============================-->
			<% if(bywhat==2) {%>
  
				<table class=M11 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
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
									<INPUT id=content name=content class="searchInput" onmouseover="this.select()" onfocus="clearVal(this);" onblur="recoverVal(this);"  value="<%=content %>" style="width:180px;height:23px;border:0px;background:#f7f7f7;color:#606060" /> 
									</td>
								</tr>
							</table>
						</td>
						<%for(int i=0;i<daysOfThisMonth;i++){%>
							<%if(i == 0) { %>
								<td class="thcls" style="BORDER-left: 1px solid #d0d0d0;" align=center><%=i+1%></td>
							<%}else{%>
								<td class="thcls" style="BORDER-LEFT: 0px" align=center><%=i+1%></td>
							<%}%>
							
						<%}%>
				    </tr>
				   </table>
				 <div id="tabledivData" style="overflow-y: hidden;overflow-x:hidden;position: relative;width:100%">
				 <div id="tableChlddivData">
				 <table  class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed;">
				    <COLGROUP>
						<col width="221">
						<col width="">
				   <% 			
				    for(int k=0;k<meetingroomids.size();k++){
				        String tmproomid=(String) meetingroomids.get(k);				     
				   %>
				        <tr>
								<td class="roomnames" ><div class="tdfcs"></div><div class="tdtxt" title="<%=mrr.getMeetRoomInfo(""+tmproomid, MeetingRoomComInfo,user)%>" onclick="showRoomMeetingList('','',<%=tmproomid %>,event)">&nbsp;<%=Util.forHtml(Util.toScreen(MeetingRoomComInfo.getMeetingRoomInfoname(""+tmproomid),user.getLanguage()))%></div></td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)meetingroomids.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	
			            	if (ids.size()==0) { 
			            		for (int p=0 ;p<daysOfThisMonth;p++) {
			            			out.println("<td class='tdcls' style=\"color:#fff\"></td>");
			            		}
			            		//out.println(" <TR class=Line ><TD style='padding:0;' colspan=" + (Integer.parseInt(""+daysOfThisMonth)+1)+ "></TD></TR> ");
			            		continue;
			            	};	
			            				            	
							ArrayList beginDates = (ArrayList)tempMap.get("beginDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");								
							ArrayList names = (ArrayList)tempMap.get("names");	
							ArrayList totalmembers = (ArrayList)tempMap.get("totalmembers");	
							ArrayList begintimes = (ArrayList)tempMap.get("begintimes");
							ArrayList callers = (ArrayList)tempMap.get("callers");
							ArrayList endtimes = (ArrayList)tempMap.get("endtimes");
							ArrayList contacters = (ArrayList)tempMap.get("contacters");	
							ArrayList cancels = (ArrayList)tempMap.get("cancels");
							ArrayList meetingStatuss = (ArrayList)tempMap.get("meetingStatus");
					        for(int j=0; j<daysOfThisMonth; j++)
					        {
					            String bgcolor=""; 
								String tdTitle = "" ;
								int cnt = 0;
								String tmpdate = datenow + "-"+Util.add0(j+1,2) ;	//for td4306						
								String temp = getDayOccupied(tmpdate, beginDates, begintimes, endDates, endtimes, cancels);
								if("2".equals(temp))
								{
									tdTitle = SystemEnv.getHtmlLabelName(82890,user.getLanguage()) ;
								}
								boolean existDSP=false;//待审批
								for (int h=0 ;h<ids.size();h++) 
								{
									String beginDate = (String)beginDates.get(h);
									String endDate = (String)endDates.get(h);
									
									String name = (String)names.get(h);
									String totalmember = (String)totalmembers.get(h);
									String caller = (String)callers.get(h);
									String contacter = (String)contacters.get(h);
									String begintime = (String)begintimes.get(h);
									String endtime = (String)endtimes.get(h);
									String cancel = (String)cancels.get(h);
									String meetingStatus = (String)meetingStatuss.get(h);
									if(cancel.equals("1"))continue;
									if(tmpdate.compareTo(beginDate)>=0 && tmpdate.compareTo(endDate)<=0)
									{	
										if("1".equals(meetingStatus)){
											existDSP=true;
										} 
										cnt++;
                                        if(tdTitle.equals(""))
                                        {
                                             tdTitle =mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime,user);
                                        }
                                        else
                                        {
                                             tdTitle +="\n"+"----------------------------------------------------------"+"\n"+
                                                     mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime,user);
										}
									}
								}
								
								if("2".equals(temp))
								{
									bgcolor="#FBDFEB";
								}
								else if("1".equals(temp))
								{
									bgcolor="#E3F6D8";
									if(existDSP){
										bgcolor="#FFE4C4";
									}
								}
                            %>
						         <td class="tdcls" bgcolor="<%=bgcolor%>" align=center <%if(!"".equals(tdTitle)) {%>title="<%=tdTitle%>"<%}%> >
						         <%if(cnt > 1){ %><%=cnt %><%} %>
						         </td>
					        <%}%> 
						</tr>
				    
				<%  }%>
				</table>
			<%}%>
			<!--============================ 周报表 ============================-->
			<% if(bywhat==3) {%>
				<table class=M11 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
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
									<INPUT id=content name=content class="searchInput" onmouseover="this.select()" onfocus="clearVal(this);" onblur="recoverVal(this);"  value="<%=content %>" style="width:180px;height:23px;border:0px;background:#f7f7f7;color:#606060" /> 
									</td>
								</tr>
							</table>
						</td>
						<%for(int i=0;i<7;i++){%>
							<%if(i == 0) { %>
								<td class="thcls" style="BORDER-left: 1px solid #d0d0d0;" align=center><span class="weekclass" val="<%=TimeUtil.dateAdd(cBeginDate,i)%>"></span>
								</td>
							<%}else{%>
								<td class="thcls" style="BORDER-LEFT: 0px" align=center><span class="weekclass" val="<%=TimeUtil.dateAdd(cBeginDate,i)%>"></span>
								</td>
							<%}%>
							
						<%}%>
				    </tr>
				  </table>
				 <div id="tabledivData" style="overflow-y: hidden;overflow-x:hidden;position: relative;width:100%">
				 <div id="tableChlddivData">
				 <table  class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed;">
				    <COLGROUP>
						<col width="221">
						<col width="">
				   <% 			
				    for(int k=0;k<meetingroomids.size();k++){
				        String tmproomid=(String) meetingroomids.get(k);				     
				   %>
				        <tr>
								<td class="roomnames" ><div class="tdfcs"></div><div class="tdtxt" title="<%=mrr.getMeetRoomInfo(""+tmproomid, MeetingRoomComInfo,user)%>" onclick="showRoomMeetingList('','',<%=tmproomid %>,event)">&nbsp;<%=Util.forHtml(Util.toScreen(MeetingRoomComInfo.getMeetingRoomInfoname(""+tmproomid),user.getLanguage()))%></div></td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)meetingroomids.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	
			            	if (ids.size()==0) { 
			            		for (int p=0 ;p<7;p++) {
			            			out.println("<td class='tdcls' style=\'color:#fff\'></td>");
			            		}
			            		//out.println(" <TR class=Line><TD colspan='8'></TD></TR> ");
			            		continue;
			            	};	
			            				            	
							ArrayList beginDates = (ArrayList)tempMap.get("beginDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");								
							ArrayList names = (ArrayList)tempMap.get("names");	
							ArrayList totalmembers = (ArrayList)tempMap.get("totalmembers");	
							ArrayList begintimes = (ArrayList)tempMap.get("begintimes");
							ArrayList callers = (ArrayList)tempMap.get("callers");
							ArrayList endtimes = (ArrayList)tempMap.get("endtimes");
							ArrayList contacters = (ArrayList)tempMap.get("contacters");	
							ArrayList cancels = (ArrayList)tempMap.get("cancels");
							ArrayList meetingStatuss = (ArrayList)tempMap.get("meetingStatus");
					        for(int j=-1; j<6; j++){
					            String bgcolor=""; 
								String tdTitle = "" ;
								int cnt = 0;
								String tmpdate = TimeUtil.dateAdd(datenow,j) ;						
								String temp = getDayOccupied(tmpdate, beginDates, begintimes, endDates, endtimes, cancels);
								if("2".equals(temp))
								{
									tdTitle = SystemEnv.getHtmlLabelName(82890,user.getLanguage()) ;
								}
								boolean existDSP=false;//待审批
								for (int h=0 ;h<ids.size();h++) {
									String beginDate = (String)beginDates.get(h);
									String endDate = (String)endDates.get(h);
									
									String name = (String)names.get(h);
									String totalmember = (String)totalmembers.get(h);
									String caller = (String)callers.get(h);
									String contacter = (String)contacters.get(h);
									String begintime = (String)begintimes.get(h);
									String endtime = (String)endtimes.get(h);
									String cancel = (String)cancels.get(h);
									String meetingStatus = (String)meetingStatuss.get(h);
									if(cancel.equals("1"))continue;
									if(tmpdate.compareTo(beginDate)>=0&& tmpdate.compareTo(endDate)<=0){
										if("1".equals(meetingStatus)){
											existDSP=true;
										} 
										cnt++;
										 if(tdTitle.equals("")){
                                             tdTitle =mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime,user);
                                         }else{
                                             tdTitle +="\n"+"----------------------------------------------------------"+"\n"+
                                                     mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime,user);
                                         }
									}
								}
								
								if("2".equals(temp))
								{
									bgcolor="#FBDFEB";
								}
								else if("1".equals(temp))
								{
									bgcolor="#E3F6D8";
									if(existDSP){
										bgcolor="#FFE4C4";
									}
								}
                            %>
						         <td class="tdcls" align=center bgcolor="<%=bgcolor%>" <%if(!"".equals(tdTitle)) {%>title="<%=tdTitle%>"<%}%> >
						         <%if(cnt > 1){ %><%=cnt %><%} %>
						         </td>
					        <%}%> 
						</tr>
				   
						<%  }%>
					</table>
			<%}%>


				<!--============================ 日报表 ============================-->
				<% if(bywhat==4) {%>

				<table class=M11 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed;">
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
								<td class="thcls" style="BORDER-left: 1px solid #d0d0d0;" colspan="<%=dspUnit %>" align=center><%=i%></td>
							<%}else{%>
								<td class="thcls" style="BORDER-LEFT: 0px" colspan="<%=dspUnit %>" align=center><%=i%></td>
							<%}%>
						<%}%>
				    </tr>
				 </table>
				 <div id="tabledivData" style="overflow-y: hidden;overflow-x: hidden;width:100%;">
				 <div id="tableChlddivData">
				 <table  class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed;">
				    <COLGROUP>
						<col width="221">
						<col width="">
				  <% 			
				    for(int k=0;k<meetingroomids.size();k++){
				        String tmproomid=(String) meetingroomids.get(k);				     
				   %>
				        <tr class="selectable">
					            <td class="roomnames" ><div class="tdfcs"></div><div class="tdtxt" title="<%=mrr.getMeetRoomInfo(""+tmproomid, MeetingRoomComInfo,user)%>" onclick="showRoomMeetingList('','',<%=tmproomid %>,event)">&nbsp;<%=Util.forHtml(Util.toScreen(MeetingRoomComInfo.getMeetingRoomInfoname(""+tmproomid),user.getLanguage()))%></div></td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)meetingroomids.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	
			            	if (ids.size()==0) { 
			            		for (int p=meetingSetInfo.getTimeRangeStart()*dspUnit ;p<(meetingSetInfo.getTimeRangeEnd()+1)*dspUnit;p++) {
			            			out.println("<td class='tdcls' roomid='"+tmproomid+"' id='"+tmproomid+"' style=\"color:#fff;"+(dspUnit!=1&&p%dspUnit!=0?"border-left: 0px;":"")+"\"  onselectstart='return false' target='"+p+"' onmousedown='createMeetingAction.startDrag(event);' >&nbsp;</td>");
			            		}
			            		//out.println(" <TR class=Line><TD colspan='25'></TD></TR> "); 
			            		continue;
			            	};	
			            				            	
							ArrayList beginDates = (ArrayList)tempMap.get("beginDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");								
							ArrayList names = (ArrayList)tempMap.get("names");	
							ArrayList totalmembers = (ArrayList)tempMap.get("totalmembers");	
							ArrayList begintimes = (ArrayList)tempMap.get("begintimes");
							ArrayList callers = (ArrayList)tempMap.get("callers");
							ArrayList endtimes = (ArrayList)tempMap.get("endtimes");
							ArrayList contacters = (ArrayList)tempMap.get("contacters");	
							ArrayList cancels = (ArrayList)tempMap.get("cancels");
							ArrayList meetingStatuss = (ArrayList)tempMap.get("meetingStatus");
					        for(int j=meetingSetInfo.getTimeRangeStart()*dspUnit; j<(meetingSetInfo.getTimeRangeEnd()+1)*dspUnit; j++){
					            String bgcolor=""; 
								String tdTitle = "" ;												
								
								String tempTimeBg = datenow+" "+(dspUnit==1?(Util.add0(j,2)+":00"):getTimesBg(j-1,dspUnit)) ;	
								String tempTimeed = datenow+" "+(dspUnit==1?(Util.add0(j,2)+":59"):getTimesEd(j,dspUnit)) ;	
								
								String temp=getHourOccupied(datenow, ""+j, beginDates, begintimes, endDates, endtimes, cancels,dspUnit);
								if("2".equals(temp))
								{
									tdTitle = SystemEnv.getHtmlLabelName(82890,user.getLanguage()) ;
								}
								
								 
								
								
								boolean existDSP=false;//待审批
								int cnt = 0;
								for (int h=0 ;h<ids.size();h++) {
									String beginDate = (String)beginDates.get(h);
									String endDate = (String)endDates.get(h);
									
									String name = (String)names.get(h);
									String totalmember = (String)totalmembers.get(h);
									String caller = (String)callers.get(h);
									String contacter = (String)contacters.get(h);
									String begintime = (String)begintimes.get(h);
									String endtime = (String)endtimes.get(h);
									String cancel = (String)cancels.get(h);
									String meetingStatus = (String)meetingStatuss.get(h);
									if(cancel.equals("1"))continue;
									
									String tempBeginDateTime = beginDate+" "+begintime;
									String tempEndDateTime = endDate+" "+endtime;	
																		
									if((tempTimeed).compareTo(tempBeginDateTime)>=0&& (tempTimeBg).compareTo(tempEndDateTime)<0){
										if("1".equals(meetingStatus)){
											existDSP=true;
										} 
										cnt++;
                                         if(tdTitle.equals("")){
                                             tdTitle =mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime,user);
                                         }else{
                                             tdTitle +="\n"+"----------------------------------------------------------"+"\n"+
                                                     mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime,user);
                                         }
                                    }
								}
                                if("2".equals(temp))
								{
									bgcolor="#FBDFEB";
								}
								else if("1".equals(temp))
								{
									bgcolor="#E3F6D8";
									if(existDSP){
										bgcolor="#FFE4C4";
									}
								}
								
                            %>
						         <td class="tdcls" roomid="<%=tmproomid %>" style="<%=(dspUnit!=1&&j%dspUnit!=0?"border-left: 0px;":"")%>" align=center bgcolor="<%=bgcolor%>" id="<%=tmproomid %>" target="<%=j %>" onselectstart="return false" onmousedown='createMeetingAction.startDrag(event);'  <%if(!"".equals(tdTitle)) {%> title="<%=tdTitle%>"<%}%>><%if(cnt>1) {%><%=cnt %><%} else {%>&nbsp;<%} %></td>
					        <%}%> 
							</tr>
							<%  }%>
						</table>
					</div>
					</div>
				<%}%>

<script language=javascript>

function afterLoadDate(){
	var bywhat = $GetEle("bywhat").value
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
	
	<% String titlestrnow=""; 
	if(bywhat==2) {
		titlestrnow =SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage());
	}else if(bywhat==3){
		titlestrnow=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage());
	}else if(bywhat==4){
		titlestrnow=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage()); 
	}%>
	$("#showtodaybtn").attr("title","<%=titlestrnow%>");
	
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
	jQuery("#showsubcompanybtn").html("<%=subidsSpan%>");
	
	jQuery("#tabledivData").perfectScrollbar();
	recoverVal($GetEle("content"));
	$GetEle("movedate").value = "";
	$GetEle("currentdate").value = "<%=currentdate%>";
	$(".thcls").css("border-bottom","1px solid #59b0f2");
	$(".schtd").css("border-bottom","1px solid #59b0f2");
	$(".schtd").css("border-left","0px");
	$(".roomnames").css("border-left","0px");
	$("#listframe").attr("src","GetRoomMeetingList.jsp?bywhat="+bywhat+"&datenow=<%=datenow%>&subids=<%=subids%>&content="+encodeURI('<%=content%>')+"&canEdit=<%=canEdit%>");
	$("#txtdatetimeshow").text(showtime);
}

</script>


