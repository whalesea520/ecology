
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="mrr" class="weaver.car.CarInfoReport" scope="page"/>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CarInfoComInfo" class="weaver.car.CarInfoComInfo" scope="page"/>

<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
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
			
			int beginMinuteOfDay = getMinuteOfDay(beginTime)+1;
			int endMinuteOfDay  = getMinuteOfDay(endTime);
			
			while(beginMinuteOfDay < endMinuteOfDay)
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
			
			int beginMinuteOfHour = getMinuteOfDay(beginTime) + 1;
			int endMinuteOfHour  = getMinuteOfDay(endTime);
			
			while(beginMinuteOfHour < endMinuteOfHour)
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

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
char flag=2;
String userid=user.getUID()+"" ;
ArrayList newCarIds = new ArrayList() ;
boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));
String operation=Util.null2String(request.getParameter("operation"));
String content = java.net.URLDecoder.decode(Util.null2String(request.getParameter("content")),"UTF-8").trim();
int carid=Util.getIntValue(request.getParameter("id"),0);
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
    //RecordSet.executeSql("update meeting set cancel='1',meetingStatus=4,canceldate='"+nowdate+"',canceltime='"+nowtime+"' where id="+meetingid);
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
		//today.add(Calendar.DATE,1);
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

ArrayList carids = new ArrayList() ;
ArrayList carnames = new ArrayList() ;

//分权
RecordSet.executeSql("select carsdetachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
	 	detachable=RecordSet.getInt(1);
}
String sqlwhere = "";
if(detachable==1){
	if(!"".equals(Util.null2String(request.getParameter("subids")))){
		subids = Util.getIntValue(request.getParameter("subids"));
	}
	//operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Car:Maintenance",subCompanyId);
	if(user.getUID()!=1){
		String sqltmp = "";
		String blonsubcomid="";
		rs2.executeProc("HrmRoleSR_SeByURId", ""+user.getUID()+flag+"Car:Maintenance");
		while(rs2.next()){
			blonsubcomid=rs2.getString("subcompanyid");
			sqltmp += (", "+blonsubcomid);
		}
		if(!"".equals(sqltmp)){//角色设置的权限
			sqltmp = sqltmp.substring(1);
			sqlwhere += " and subcompanyid in ("+sqltmp+") ";
		}else{
			sqlwhere += " and subcompanyid="+user.getUserSubCompany1() ;
		}
	}
}else{
	subids = -1;
}
if(!"".equals(content.trim())){
	sqlwhere += " and c.carNo like '%" + content + "%' ";
}
if(subids>0){
	if(user.getUID()==1){
		if(subids>0){
			sqlwhere += " and subCompanyId="+subids;
		}else{
			sqlwhere += " and subCompanyId>=0";
		}
	}else{
		//sqlwhere += " and subCompanyId="+subCompanyId+" and subCompanyId>0";
		if(subids>0){
			sqlwhere += " and subCompanyId="+subids;
		}else{
			sqlwhere += " and subCompanyId>0";
		}
	}
}

String sql = "select id,carNo from CarInfo c where 1=1 " + sqlwhere + " order by id";
RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmpcarid=RecordSet.getString(1);
    String tmpcarname=RecordSet.getString(2);
    carids.add(tmpcarid) ;
    carnames.add(tmpcarname) ;
}

HashMap mrrHash= mrr.getMapping(datenow,bywhat);	
	
	
%>
			<input type="hidden" name="datenow" id="datenow" value="<%=datenow%>" />
			<!--============================ 月报表 ============================-->
			<% if(bywhat==2) {%>
  
				<table class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
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
				    <% 
				    	for (int m = 0 ; m < carids.size(); m++) {
				    		String tempcarid = (String) carids.get(m);
					        String tempcarno = (String) carnames.get(m);
				    %>
				    	<tr><!-- 用车基本信息 -->
				    		<td class="carnames"><div class="tdfcs"></div><div class="tdtxt" title="<%=SystemEnv.getHtmlLabelName(82282,user.getLanguage())%>" onclick="showCarinfoList('<%=tempcarid%>',event)"><%=tempcarno%></div></td>
				    		<%
				    			HashMap tempMap = (HashMap)mrrHash.get((String)carids.get(m));  
					        	ArrayList ids = (ArrayList)tempMap.get("ids");	
					        	
					        	if (ids.size()==0) { 
			            			for (int p=0 ;p<daysOfThisMonth;p++) {
			            				out.println("<td class='tdcls' style=\"color:#fff\"></td>");
			            			}
			            			continue;
			            		}
			            		ArrayList drivers = (ArrayList)tempMap.get("drivers");	
								ArrayList usecarerids = (ArrayList)tempMap.get("userids");	
								ArrayList startTimes = (ArrayList)tempMap.get("startTimes");
								ArrayList endTimes = (ArrayList)tempMap.get("endTimes");
								ArrayList startDates = (ArrayList)tempMap.get("startDates");
								ArrayList endDates = (ArrayList)tempMap.get("endDates");
								ArrayList cancels = (ArrayList)tempMap.get("cancels");
			            		for(int j=0; j < daysOfThisMonth; j++) {
			            			String bgcolor=""; 
									String tdTitle = "" ;	
									int cnt = 0;			
									String tmpdate = datenow + "-"+Util.add0(j+1,2) ;								
									String temp = getDayOccupied(tmpdate, startDates, startTimes, endDates, endTimes, cancels);
									if("2".equals(temp))
									{
										tdTitle = SystemEnv.getHtmlLabelName(82283,user.getLanguage()) ;//本区间车辆使用冲突
									}
									for (int h=0 ;h<ids.size();h++) {
										String driver = (String)drivers.get(h);
										String usecarerid = (String)usecarerids.get(h);
										String startTime = (String)startTimes.get(h);
										String endTime = (String)endTimes.get(h);
										String startDate = (String)startDates.get(h);
										String endDate = (String)endDates.get(h);
										String cancel = (String)cancels.get(h);
										if(cancel.equals("1"))continue;
										if(tmpdate.compareTo(startDate)>=0&& tmpdate.compareTo(endDate)<=0){
											cnt++;
											if(tdTitle.equals("")) {
                                                tdTitle =mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+tempcarid),driver,usecarerid,startDate,endDate,startTime,endTime);
                                        	} else {
                                             	tdTitle +="\n"+"--------------------------------------------------------"+"\n"+
                                                     mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+tempcarid),driver,usecarerid,startDate,endDate,startTime,endTime);
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
									}
				    		%>
				    				<td class="tdcls" style="<%if(!"".equals(bgcolor)) {%>background-color:<%=bgcolor%><%} %>" <%if(!"".equals(tdTitle)) {%>title="<%=tdTitle%>"<%}%> align=center>
				    					<%if(cnt > 1){ %><%=cnt %><%} %>
				    				</td>
				    		<%
				    			}
				    		%>
				    	</tr>
				    <%
				    	}
				    %>
				</table>
			<%}%>
			<!--============================ 周报表 ============================-->
			<% if(bywhat==3) {%>
				<table class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
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
				    <% 
				    	for (int w = 0 ; w < carids.size(); w++) {
				    		String tempcarid = (String) carids.get(w);
					        String tempcarno = (String) carnames.get(w);
				    %>
				    	<tr><!-- 用车基本信息 -->
				    		<td class="carnames"><div class="tdfcs"></div><div class="tdtxt" title="<%=SystemEnv.getHtmlLabelName(82282,user.getLanguage())%>" onclick="showCarinfoList('<%=tempcarid%>',event)"><%=tempcarno%></div></td>
				    		<%
				    			HashMap tempMap = (HashMap)mrrHash.get((String)carids.get(w));  
					        	ArrayList ids = (ArrayList)tempMap.get("ids");	
					        	
					        	if (ids.size()==0) { 
			            			for (int p=-1; p<6; p++) {
			            				out.println("<td class='tdcls' style=\"color:#fff\"></td>");
			            			}
			            			continue;
			            		}
			            		ArrayList drivers = (ArrayList)tempMap.get("drivers");	
								ArrayList usecarerids = (ArrayList)tempMap.get("userids");	
								ArrayList startTimes = (ArrayList)tempMap.get("startTimes");
								ArrayList endTimes = (ArrayList)tempMap.get("endTimes");
								ArrayList startDates = (ArrayList)tempMap.get("startDates");
								ArrayList endDates = (ArrayList)tempMap.get("endDates");
								ArrayList cancels = (ArrayList)tempMap.get("cancels");
			            		for(int j=0; j<7; j++) {
			            			String bgcolor=""; 
									String tdTitle = "" ;
									int cnt = 0;							
									String tmpdate = TimeUtil.dateAdd(datenow,j) ;						
									String temp = getDayOccupied(tmpdate, startDates, startTimes, endDates, endTimes, cancels);
									if("2".equals(temp)) {
										tdTitle = SystemEnv.getHtmlLabelName(82283,user.getLanguage()) ;//本区间车辆使用冲突
									}
									for (int h=0 ;h<ids.size();h++) {
										String driver = (String)drivers.get(h);
										String usecarerid = (String)usecarerids.get(h);
										String startTime = (String)startTimes.get(h);
										String endTime = (String)endTimes.get(h);
										String startDate = (String)startDates.get(h);
										String endDate = (String)endDates.get(h);
										String cancel = (String)cancels.get(h);
										if(cancel.equals("1"))continue;
									
										if(tmpdate.compareTo(startDate)>=0&& tmpdate.compareTo(endDate)<=0){
											cnt++;
											if(tdTitle.equals("")) {
                                                tdTitle =mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+tempcarid),driver,usecarerid,startDate,endDate,startTime,endTime);
                                        	} else {
                                             	tdTitle +="\n"+"--------------------------------------------------------"+"\n"+
                                                     mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+tempcarid),driver,usecarerid,startDate,endDate,startTime,endTime);
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
									}
				    		%>
				    				<td class="tdcls" style="<%if(!"".equals(bgcolor)) {%>background-color:<%=bgcolor%><%} %>" <%if(!"".equals(tdTitle)) {%>title="<%=tdTitle%>"<%}%> align=center>
				    					<%if(cnt > 1){ %><%=cnt %><%} %>
				    				</td>
				    		<%
				    			};	
				    		%>
				    	</tr>
				    <%
				    	}
				    %>
					</table>
			<%}%>


				<!--============================ 日报表 ============================-->
				<% if(bywhat==4) {%>

				<table  class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
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
							<%for(int i=0;i<=23;i++){%>
							<%if(i == 0) { %>
								<td class="thcls" style="BORDER-left: 1px solid #d0d0d0;" align=center><%=i%></td>
							<%}else{%>
								<td class="thcls" style="BORDER-LEFT: 0px" align=center><%=i%></td>
							<%}%>
						<%}%>
							
				    </tr>
				    <% 
				    	for (int d = 0 ; d < carids.size(); d++) {
				    		String tempcarid = (String) carids.get(d);
					        String tempcarno = (String) carnames.get(d);
				    %>
				    	<tr><!-- 用车基本信息 -->
				    		<td class="carnames"><div class="tdfcs"></div><div class="tdtxt" title="<%=SystemEnv.getHtmlLabelName(82282,user.getLanguage())%>" onclick="showCarinfoList('<%=tempcarid %>',event)"><%=tempcarno%></div></td>
				    		<%
				    			HashMap tempMap = (HashMap)mrrHash.get((String)carids.get(d));  
					        	ArrayList ids = (ArrayList)tempMap.get("ids");	
					        	
					        	if (ids.size()==0) { 
			            			for (int p=0; p <= 23; p++) {
			            				out.println("<td class='tdcls' style=\"color:#fff\"></td>");
			            			}
			            			continue;
			            		}
			            		ArrayList drivers = (ArrayList)tempMap.get("drivers");	
								ArrayList usecarerids = (ArrayList)tempMap.get("userids");	
								ArrayList startTimes = (ArrayList)tempMap.get("startTimes");
								ArrayList endTimes = (ArrayList)tempMap.get("endTimes");
								ArrayList startDates = (ArrayList)tempMap.get("startDates");
								ArrayList endDates = (ArrayList)tempMap.get("endDates");
								ArrayList cancels = (ArrayList)tempMap.get("cancels");
			            		for(int j=0; j <= 23; j++) {
			            			String bgcolor=""; 
									String tdTitle = "" ;
									int cnt = 0;													
									String tempTime = datenow+" "+Util.add0(j,2) ;	
									String temp = getHourOccupied(datenow, Util.add0(j,2), startDates, startTimes, endDates, endTimes, cancels);
									if("2".equals(temp)) {
										tdTitle = SystemEnv.getHtmlLabelName(82283,user.getLanguage()) ;//本区间车辆使用冲突
									}
									for (int h=0 ;h<ids.size();h++) {
										String driver = (String)drivers.get(h);
										String usecarerid = (String)usecarerids.get(h);
										String startTime = (String)startTimes.get(h);
										String endTime = (String)endTimes.get(h);
										String startDate = (String)startDates.get(h);
										String endDate = (String)endDates.get(h);									
									
										String tempBeginDateTime = startDate+" "+startTime.substring(0,startTime.indexOf(":"));
										String tempEndDateTime = endDate+" "+endTime.substring(0,endTime.indexOf(":"));	
										String cancel = (String)cancels.get(h);
										if(cancel.equals("1"))continue;
									
										if(tempTime.compareTo(tempBeginDateTime)>=0&& tempTime.compareTo(tempEndDateTime)<=0){
											cnt++;
											if(tdTitle.equals("")) {
                                                tdTitle =mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+tempcarid),driver,usecarerid,startDate,endDate,startTime,endTime);
                                        	} else {
                                             	tdTitle +="\n"+"--------------------------------------------------------"+"\n"+
                                                     mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+tempcarid),driver,usecarerid,startDate,endDate,startTime,endTime);
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
									}
				    		%>
				    				<td class="tdcls" style="<%if(!"".equals(bgcolor)) {%>background-color:<%=bgcolor%><%} %>" <%if(!"".equals(tdTitle)) {%>title="<%=tdTitle%>"<%}%> align=center>
				    					<%if(cnt > 1){ %><%=cnt %><%} %>
				    				</td>
				    		<%
				    			};	
				    		%>
				    	</tr>
				    <%
				    	}
				    %>
						</table>
				<%}%>

<script language=javascript>

function afterLoadDate(){
	var bywhat = $GetEle("bywhat").value
	var cBeginDate="<%=cBeginDate%>";
	var cEndDate="<%=cEndDate%>";
	var showtime = "";
	var titletime=""; 
	
	<% if(bywhat==2) {%>
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
		titlestrnow =SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage());//本月
	}else if(bywhat==3){
		titlestrnow=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage());//本周
	}else if(bywhat==4){
		titlestrnow=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage());//今天
	}%>
	$("#showtodaybtn").attr("title","<%=titlestrnow%>");
	
	<% String subidsSpan = SystemEnv.getHtmlLabelName(141,user.getLanguage());//分部
		if(subids > 0){
			subidsSpan += " : "+SubCompanyComInfo.getSubCompanyname(""+subids);
		} else {
			RecordSet.executeSql("SELECT companyname FROM HrmCompany WHERE id = 1");
			if(RecordSet.next()){//总部
				subidsSpan =  SystemEnv.getHtmlLabelName(140,user.getLanguage())+" : "+Util.null2String(RecordSet.getString("companyname"));
			}
		} 
	%>
	jQuery("#showsubcompanybtn").html("<%=subidsSpan%>");
	
	jQuery("#tablediv").perfectScrollbar("update");
	recoverVal($GetEle("content"));
	$GetEle("movedate").value = "";
	$GetEle("currentdate").value = "<%=currentdate%>";
	$(".thcls").css("border-bottom","1px solid #59b0f2");
	$(".schtd").css("border-bottom","1px solid #59b0f2");
	$(".schtd").css("border-left","0px");
	$(".carnames").css("border-left","0px");
	$("#listframe").attr("src","getCarInfoList.jsp?bywhat="+bywhat+"&datenow=<%=datenow%>&subids=<%=subids%>&content=<%=content%>");
	$("#txtdatetimeshow").text(showtime);
}

</script>


