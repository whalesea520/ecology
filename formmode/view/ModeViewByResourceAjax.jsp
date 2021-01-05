
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.service.CustomResourceService"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.formmode.setup.ModeRightInfo"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.formmode.view.ModeShareManager"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="mrr" class="weaver.car.CarInfoReport" scope="page"/>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean   id="xssUtil" class="weaver.filter.XssUtil" />

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

private long timeToLong(String date){
	try{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    Date d = sdf.parse(date);
	    
	    return d.getTime();
	}catch(Exception ex){
		ex.printStackTrace();
		return new Long(0);
	}
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

String resourceId =  Util.null2String(request.getParameter("resourceId"));
if(resourceId.equals("")){
	resourceId = Util.null2String(request.getParameter("id"));
}
//String resourcesqlwhere = new String(Util.null2String(request.getParameter("resourcesqlwhere")).getBytes("ISO-8859-1"),"UTF-8");
String resourcesqlwhere = new String(Util.null2String(xssUtil.get(request.getParameter("resourcesqlwhere"))).getBytes("ISO-8859-1"),"UTF-8");
//String datasqlwhere = new String(Util.null2String(request.getParameter("datasqlwhere")).getBytes("ISO-8859-1"),"UTF-8");
String datasqlwhere = new String(Util.null2String(xssUtil.get(request.getParameter("datasqlwhere"))).getBytes("ISO-8859-1"),"UTF-8");
String sqlwhere = new String(Util.null2String(request.getParameter("sqlwhere")).getBytes("ISO-8859-1"),"UTF-8");

if(!resourcesqlwhere.equals("")){
	resourcesqlwhere = resourcesqlwhere.trim().startsWith("and")?resourcesqlwhere:" and "+resourcesqlwhere;
}
if(!datasqlwhere.equals("")){
	datasqlwhere = datasqlwhere.trim().startsWith("and")?datasqlwhere:" and "+datasqlwhere;
}
if(!sqlwhere.equals("")){
	datasqlwhere += sqlwhere.trim().startsWith("and")?sqlwhere:" and "+sqlwhere;
}
String sql_where = sqlwhere;//zwbo

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));
String operation=Util.null2String(request.getParameter("operation"));
String content = java.net.URLDecoder.decode(Util.null2String(request.getParameter("content")),"UTF-8").trim();
if(content.equals(SystemEnv.getHtmlLabelName(82529, user.getLanguage()) )){
	content = "";
}

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
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-31" ;

		temptoday2.add(Calendar.MONTH,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-01" ;
		cBeginDate = TimeUtil.getMonthBeginDay(currentdate);
		cEndDate = TimeUtil.getMonthEndDay(currentdate);
		break ;
 	case 3 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.DATE,-2) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;

		temptoday2.add(Calendar.WEEK_OF_YEAR,1) ;
		temptoday2.add(Calendar.DATE,-1) ;
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

ArrayList ids = new ArrayList() ;
ArrayList names = new ArrayList() ;

//分权
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
}
sqlwhere = "";
if(detachable==1){ 
if(subids > 0){
	sqlwhere = "and c.subCompanyId = "+ subids ;
}else{
	sqlwhere = "and c.subCompanyId = " + user.getUserSubCompany1();
}
}
else {
if(subids > 0){
	 sqlwhere = "and c.subCompanyId = "+ subids ;
} 
}

CustomResourceService customResourceService = new CustomResourceService();
customResourceService.setUser(user);
Map<String, String> fields = customResourceService.convertResourceFieldsById(resourceId);
String resourceShowTableName = fields.get("resourceShowTableName");
String resourceShowFieldName = fields.get("resourceShowFieldName");
String startDateFieldName = fields.get("startDateFieldName");
String endDateFieldName = fields.get("endDateFieldName");

String startTimeFieldName = fields.get("startTimeFieldName");
String endTimeFieldName = fields.get("endTimeFieldName");

String tablename = fields.get("tablename");
String titleFieldName = fields.get("titleFieldName");
String contentFieldName = fields.get("contentFieldName");

String resourceFieldName = fields.get("resourceFieldName");
String resourceFieldId = fields.get("resourceFieldId");

String customSearchId = fields.get("customSearchId");

String modeid = fields.get("modeid");
String formid = fields.get("formid");
String dataPool = Util.null2String(fields.get("dataPool"));

Map<String, String> resourceFields = customResourceService.getResourceFieldModeDataByFieldid(resourceFieldId);
String resourceFormid = resourceFields.get("resourceFormid");
String resourceModeid = resourceFields.get("resourceModeid");
String resourceTablename = resourceFields.get("resourceTablename");
String resourceBrowserPK = resourceFields.get("resourceBrowserPK");
sqlwhere = resourcesqlwhere;
if(!"".equals(content.trim())){
	sqlwhere += " and c."+resourceShowFieldName+" like '%" + content + "%' ";
}

boolean isVirtualForm = VirtualFormHandler.isVirtualForm(resourceFormid);	//是否是虚拟表单
String resourceDataPool = "";
String rightsql = "";
if(isVirtualForm){
	Map<String, Object> vFormInfo = VirtualFormHandler.getVFormInfo(resourceFormid);
	resourceTablename = VirtualFormHandler.getRealFromName(resourceTablename);
	
	resourceDataPool = Util.null2String(vFormInfo.get("vdatasource"));
}else{
	rightsql = customResourceService.getShareSqlByModeid(resourceModeid, resourceFormid);
	
	resourceDataPool = null;
}

//针对sqlwhere的筛选   sqlwhere = khmc = 3 zwbo
//将khmc替换为id
if(!(sql_where).equals("")&&!sql_where.equals("null")){
	sql_where = sql_where.replaceAll(resourceFieldName,"id");
	sql_where = " and c."+sql_where+" ";
}else{
	sql_where = "";
}

String sql = "select c.* from "+resourceTablename+" c where 1=1 "+sql_where+sqlwhere+ " order by id";
if(!rightsql.equals("")){
	sql = "select c.* from "+resourceTablename+" c,"+rightsql+" t2 where c.id = t2.sourceid "+sql_where+sqlwhere+ " order by id";
}
RecordSet.executeSql(sql, resourceDataPool);

String idstr = "";
int dataCount = RecordSet.getCounts();
while(RecordSet.next()){
	String tmpid="";
	if(null!=resourceBrowserPK&&!resourceBrowserPK.equals("")){
		tmpid=RecordSet.getString(resourceBrowserPK);
	}else{
		tmpid=RecordSet.getString("id");
	}

    String tmpname=RecordSet.getString(resourceShowFieldName.toLowerCase());
    ids.add(tmpid) ;
    names.add(tmpname) ;
    idstr += ",'"+tmpid+"'";
}
//不考虑多选，可使用
datasqlwhere = " and (t1."+startDateFieldName+">'"+datefrom+"' and t1."+startDateFieldName+"<'"+dateto+"' or t1."+endDateFieldName+">'"+datefrom+"' and t1."+endDateFieldName+"<'"+dateto+"' or t1."+startDateFieldName+"<='"+datefrom+"' and t1."+endDateFieldName+">='"+dateto+"') "+datasqlwhere;
if(!idstr.equals("")){
	idstr = idstr.substring(1);
	datasqlwhere += " and t1."+resourceFieldName+" in ("+idstr+")";
}else{
	datasqlwhere += " and t1."+resourceFieldName+" in ('')";
}
%>
			<input type="hidden" name="datenow" id="datenow" value="<%=datenow%>" />
			<!--============================ 月报表 ============================-->
			<% if(bywhat==2) {%>
  
				<table class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed;border-left: 1px solid #d0d0d0;border-right: 1px solid #d0d0d0;">
				    <COLGROUP>
						<%if(resourceShowFieldName.equals("")){ %>
					    	<col width="0">
					    <%}else{ %>
							<col width="221">
						<%} %>
						<col width="">
				    <tr  class="thbgc" style="height: 25px;">
				    	<td class="schtd" align=center style="<%=resourceShowFieldName.equals("")?"display:none;":"width:220px;display:block;" %>background:#f7f7f7;BORDER-left: 1px solid #d0d0d0;height:25px; ">
							<table height="100%" width="100%" border=0 cellspacing=0 cellpadding=0>
								<tr>
									<td width="20px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
									<button class="Browser" id=namebtn name=namebtn type="button" style="margin-top: 3px !important;" onclick="" ></button>
									</td>
									<td  width="200px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
									<INPUT id=content name=content class="searchInput" onmouseover="this.select()" onfocus="clearVal(this);" onblur="recoverVal(this);" onchange="onSearch();"  value="<%=content %>" style="width:180px;height:23px;border:0px;background:#f7f7f7;color:#606060" /> 
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
				    	for (int m = 0 ; m < ids.size(); m++) {
				    		String tempid = (String) ids.get(m);
					        String temname = (String) names.get(m);
					        List<Map<String, Object>> resourceList = customResourceService.getDataByBetweenDate(datasqlwhere, tablename, resourceFieldName, tempid, modeid, formid, dataPool);					        
				    %>
				    	<tr style="height: 25px;"><!-- 用车基本信息 -->
				    		<td class="carnames" style="<%=resourceShowFieldName.equals("")?"display:none;":"width:220px;display:block;" %>"><div class="tdfcs"></div><div class="tdtxt" title="<%=temname %>" onclick="showCarinfoList('<%=tempid %>',&quot;<%=xssUtil.put(datasqlwhere+" and t1."+resourceFieldName+"='"+tempid+"'") %>&quot;,event)"><%=temname%></div></td>
				    		<%
			            		for(int j=0; j < daysOfThisMonth; j++) {
			            			String bgcolor=""; 
									String tdTitle = "" ;
									int cnt = 0;													
									
									String tempDate = datenow + "-"+Util.add0(j+1,2) ;
									
									String _startTime = tempDate+" 00:00:00";
									String _endTime = tempDate+" 23:59:59";
									Long _startTimeLong = timeToLong(_startTime);
									Long _endTimeLong = timeToLong(_endTime);
									
									for(Map map : resourceList){
										String tmpStratTime = Util.null2String(map.get(startDateFieldName))+" "+Util.null2String(map.get(startTimeFieldName));
										String tmpEndTime = Util.null2String(map.get(endDateFieldName))+" "+Util.null2String(map.get(endTimeFieldName));
										
										Long tmpStratTimeLong = timeToLong(tmpStratTime+":00");
										Long tmpEndTimeLong = timeToLong(tmpEndTime+":00");
										
										String resourceStr = Util.null2String(map.get(resourceFieldName));
										
										if((","+resourceStr+",").indexOf(","+tempid+",")>-1){
											if(!(_startTimeLong>tmpEndTimeLong || _endTimeLong<tmpStratTimeLong)){
												cnt++;
												if(tdTitle.equals("")) {
	                                                tdTitle =   SystemEnv.getHtmlLabelName(24986,user.getLanguage())+"："+Util.null2String(map.get(titleFieldName))+"\n"+
	                                                			SystemEnv.getHtmlLabelName(124948,user.getLanguage())+"："+tmpStratTime+" - "+tmpEndTime+"\n"+
	                                                			SystemEnv.getHtmlLabelName(33368,user.getLanguage())+"："+Util.null2String(map.get(contentFieldName));
	                                        	} else {
	                                             	tdTitle +="\n"+"--------------------------------------------------------"+"\n"+
	                                             				SystemEnv.getHtmlLabelName(24986,user.getLanguage())+"："+Util.null2String(map.get(titleFieldName))+"\n"+
	                                             				SystemEnv.getHtmlLabelName(124948,user.getLanguage())+"："+tmpStratTime+" - "+tmpEndTime+"\n"+
	                                             				SystemEnv.getHtmlLabelName(33368,user.getLanguage())+"："+Util.null2String(map.get(contentFieldName));
											    }
												
												if(cnt>1)
												{
													bgcolor="#FBDFEB";
												}
												else
												{
													bgcolor="#E3F6D8";
												}
											}
										}
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
			<!--============================ 周报表 ============================-->
			<% if(bywhat==3) {%>
				<table class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed;border-left: 1px solid #d0d0d0;border-right: 1px solid #d0d0d0;">
				   <COLGROUP>
						<%if(resourceShowFieldName.equals("")){ %>
					    	<col width="0">
					    <%}else{ %>
							<col width="221">
						<%} %>
						<col width="">
				    <tr  class="thbgc" style="height: 25px;">
				    	<td class="schtd" align=center style="<%=resourceShowFieldName.equals("")?"display:none;":"width:220px;display:block;" %>background:#f7f7f7;BORDER-left: 1px solid #d0d0d0;height:25px; ">
							<table height="100%" width="100%" border=0 cellspacing=0 cellpadding=0>
								<tr>
									<td width="20px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
									<button class="Browser" id=namebtn name=namebtn type="button" style="margin-top: 3px !important;" onclick="" ></button>
									</td>
									<td  width="200px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
									<INPUT id=content name=content class="searchInput" onmouseover="this.select()" onfocus="clearVal(this);" onblur="recoverVal(this);" onchange="onSearch();"  value="<%=content %>" style="width:180px;height:23px;border:0px;background:#f7f7f7;color:#606060" /> 
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
				    	for (int w = 0 ; w < ids.size(); w++) {
				    		String tempid = (String) ids.get(w);
					        String temname = (String) names.get(w);
					        List<Map<String, Object>> resourceList = customResourceService.getDataByBetweenDate(datasqlwhere, tablename, resourceFieldName, tempid, modeid, formid, dataPool);
				    %>
				    	<tr style="height: 25px;"><!-- 用车基本信息 -->
				    		<td class="carnames" style="<%=resourceShowFieldName.equals("")?"display:none;":"width:220px;display:block;" %>"><div class="tdfcs"></div><div class="tdtxt" title="<%=temname %>" onclick="showCarinfoList('<%=tempid %>',&quot;<%=xssUtil.put(datasqlwhere+" and t1."+resourceFieldName+"='"+tempid+"'") %>&quot;,event)"><%=temname%></div></td>
				    		<%
			            		for(int j=-1; j<6; j++) {
			            			String bgcolor=""; 
									String tdTitle = "" ;
									int cnt = 0;													
									
									String tempDate = TimeUtil.dateAdd(datenow,j) ;	
									
									String _startTime = tempDate+" 00:00:00";
									String _endTime = tempDate+" 23:59:59";
									Long _startTimeLong = timeToLong(_startTime);
									Long _endTimeLong = timeToLong(_endTime);
									
									for(Map map : resourceList){
										String tmpStratTime = Util.null2String(map.get(startDateFieldName))+" "+Util.null2String(map.get(startTimeFieldName));
										String tmpEndTime = Util.null2String(map.get(endDateFieldName))+" "+Util.null2String(map.get(endTimeFieldName));
										
										Long tmpStratTimeLong = timeToLong(tmpStratTime+":00");
										Long tmpEndTimeLong = timeToLong(tmpEndTime+":00");
										
										String resourceStr = Util.null2String(map.get(resourceFieldName));
										
										if((","+resourceStr+",").indexOf(","+tempid+",")>-1){
											if(!(_startTimeLong>tmpEndTimeLong || _endTimeLong<tmpStratTimeLong)){
												cnt++;
												if(tdTitle.equals("")) {
	                                                tdTitle =   SystemEnv.getHtmlLabelName(24986,user.getLanguage())+"："+Util.null2String(map.get(titleFieldName))+"\n"+
	                                                			SystemEnv.getHtmlLabelName(124948,user.getLanguage())+"："+tmpStratTime+" - "+tmpEndTime+"\n"+
	                                                			SystemEnv.getHtmlLabelName(33368,user.getLanguage())+"："+Util.null2String(map.get(contentFieldName));
	                                        	} else {
	                                             	tdTitle +="\n"+"--------------------------------------------------------"+"\n"+
	                                             				SystemEnv.getHtmlLabelName(24986,user.getLanguage())+"："+Util.null2String(map.get(titleFieldName))+"\n"+
	                                             				SystemEnv.getHtmlLabelName(124948,user.getLanguage())+"："+tmpStratTime+" - "+tmpEndTime+"\n"+
	                                             				SystemEnv.getHtmlLabelName(33368,user.getLanguage())+"："+Util.null2String(map.get(contentFieldName));
											    }
												
												if(cnt>1)
												{
													bgcolor="#FBDFEB";
												}
												else
												{
													bgcolor="#E3F6D8";
												}
											}
										}
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

				<table  class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed;border-left: 1px solid #d0d0d0;border-right: 1px solid #d0d0d0;">
				    <COLGROUP>
				    <%if(resourceShowFieldName.equals("")){ %>
				    <col width="0">
				    <%}else{ %>
						<col width="221">
					<%} %>
						<col width="">
				    <tr  class="thbgc" style="height: 25px;">
						 	<td class="schtd" align=center style="<%=resourceShowFieldName.equals("")?"display:none;":"width:220px;display:block;" %>background:#f7f7f7;BORDER-left: 1px solid #d0d0d0;height:25px; ">
								<table height="100%" width="100%" border=0 cellspacing=0 cellpadding=0>
									<tr>
										<td width="20px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
										<button class="Browser" id=namebtn name=namebtn type="button" onclick="submit();" style="margin-top: 3px !important;"  ></button>
										</td>
										<td  width="200px" style="BORDER-bottom:0px;BORDER-LEFT: 0px">
										<INPUT id=content name=content class="searchInput" onmouseover="this.select()" onfocus="clearVal(this);" onblur="recoverVal(this);" onchange="onSearch();"  value="<%=content %>" style="width:180px;height:23px;border:0px;background:#f7f7f7;color:#606060" /> 
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
				    	for (int d = 0 ; d < ids.size(); d++) {
				    		String tempid = (String) ids.get(d);
					        String temname = (String) names.get(d);
					        List<Map<String, Object>> resourceList = customResourceService.getDataByBetweenDate(datasqlwhere, tablename, resourceFieldName, tempid, modeid, formid, dataPool);
				    %>
				    	<tr style="height: 25px;"><!-- 用车基本信息 -->
				    		<td class="carnames" style="<%=resourceShowFieldName.equals("")?"display:none;":"display:block;" %>"><div class="tdfcs"></div><div class="tdtxt" title="<%=temname %>" onclick="showCarinfoList('<%=tempid %>',&quot;<%=xssUtil.put(datasqlwhere+" and t1."+resourceFieldName+"='"+tempid+"'") %>&quot;,event)"><%=temname%></div></td>
				    		<%
			            		for(int j=0; j <= 23; j++) {
			            			String bgcolor=""; 
									String tdTitle = "" ;
									int cnt = 0;													
									
									String _startTime = datenow+" "+((j+"").length()==1?"0"+j:j)+":00:00";
									String _endTime = datenow+" "+((j+"").length()==1?"0"+j:j)+":59:59";
									Long _startTimeLong = timeToLong(_startTime);
									Long _endTimeLong = timeToLong(_endTime);
									
									for(Map<String, Object> map : resourceList){
										String tmpStratTime = Util.null2String(map.get(startDateFieldName))+" "+Util.null2String(map.get(startTimeFieldName));
										String tmpEndTime = Util.null2String(map.get(endDateFieldName))+" "+Util.null2String(map.get(endTimeFieldName));
										
										Long tmpStratTimeLong = timeToLong(tmpStratTime+":00");
										Long tmpEndTimeLong = timeToLong(tmpEndTime+":00");
										
										String resourceStr = Util.null2String(map.get(resourceFieldName));
										
										if((","+resourceStr+",").indexOf(","+tempid+",")>-1){
											if(!(_startTimeLong>tmpEndTimeLong || _endTimeLong<tmpStratTimeLong)){
												cnt++;
												if(tdTitle.equals("")) {
	                                                tdTitle =   SystemEnv.getHtmlLabelName(24986,user.getLanguage())+"："+Util.null2String(map.get(titleFieldName))+"\n"+
	                                                			SystemEnv.getHtmlLabelName(124948,user.getLanguage())+"："+tmpStratTime+" - "+tmpEndTime+"\n"+
	                                                			SystemEnv.getHtmlLabelName(33368,user.getLanguage())+"："+Util.null2String(map.get(contentFieldName));
	                                        	} else {
	                                             	tdTitle +="\n"+"--------------------------------------------------------"+"\n"+
	                                             				SystemEnv.getHtmlLabelName(24986,user.getLanguage())+"："+Util.null2String(map.get(titleFieldName))+"\n"+
	                                             				SystemEnv.getHtmlLabelName(124948,user.getLanguage())+"："+tmpStratTime+" - "+tmpEndTime+"\n"+
	                                             				SystemEnv.getHtmlLabelName(33368,user.getLanguage())+"："+Util.null2String(map.get(contentFieldName));
											    }
												
												if(cnt>1)
												{
													bgcolor="#FBDFEB";
												}
												else
												{
													bgcolor="#E3F6D8";
												}
											}
										}
									}
				    		%>
				    				<td class="tdcls" style="<%if(!"".equals(bgcolor)) {%>background-color:<%=bgcolor%><%} %>" title="<%=tdTitle%>" align=center>
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
	setCalHeight(<%=dataCount %>);

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
	$("#listframe").attr("src","/formmode/search/CustomSearchBySimple.jsp?customid=<%=customSearchId %>&datasqlwhere=<%=xssUtil.put(datasqlwhere) %>");
	$("#txtdatetimeshow").text(showtime);
}

</script>


