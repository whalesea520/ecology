
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %> 
<%@ page import="weaver.WorkPlan.WorkPlanShare" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="exchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>
<!--<jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>-->
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
</HEAD>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String userId = String.valueOf(user.getUID());
String selectUser = Util.null2String(request.getParameter("selectUser"));

boolean exchangedFlag = false;
if ((Util.null2String(request.getParameter("exchanged"))).equals("1"))
	exchangedFlag = true;

boolean superior = false;  //是否为被查看者上级或者本身
if("".equals(selectUser) || userId.equals(selectUser))
{
	selectUser = userId;
	superior = true;
}
else
{
	rs.executeSql("SELECT * FROM HrmResource WHERE ID = " + selectUser + " AND (managerStr LIKE '%," + userId + ",%' OR managerStr LIKE '" + userId + ",%')");
	
	if(rs.next())
	{
		superior = true;	
	}
}

String selectDate = Util.null2String(request.getParameter("selectdate"));
int viewType = Util.getIntValue(request.getParameter("viewtype"),2);		//viewType 	1:日计划
																			//			2:周计划

Calendar cal = Calendar.getInstance();
String currDate = Util.add0(cal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(cal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2) ;
String currTime = Util.add0(cal.getTime().getHours(), 2) +":"+
				 Util.add0(cal.getTime().getMinutes(), 2) +":"+
				 Util.add0(cal.getTime().getSeconds(), 2) ;

if (selectDate.equals("")) 
	selectDate = currDate;

String moveDate = Util.null2String(request.getParameter("movedate"));
String weekOfYear = "";
String planType = Util.null2String(request.getParameter("plantype"));
String planStatus = Util.null2String(request.getParameter("planstatus"));
String term = "";
if (!planType.equals("")) 
	term = " and t1.type_n = '" + planType + "' ";

if (planStatus.equals("")) 
	{planStatus = "0";
	term += " and (t1.status = '0' or t1.status='6')";
	}
else if  (planStatus.equals("0")) 	
   {
	term += " and (t1.status = '0' or t1.status='6')";
	}
else if (!planStatus.equals("-1")) 
	term += " and t1.status = '" + planStatus +"' ";

if(!superior)
{
	//String temptable = WorkPlanShareBase.getTempTable(userId);
	term += " AND EXISTS (SELECT * FROM WorkPlanShareDetail workPlanShareDetail WHERE t1.id = workPlanShareDetail.workID AND workPlanShareDetail.userType = 1 AND workPlanShareDetail.userID = " + userId + ")";
}

//if (planStatus.equals("")) 
//	planStatus = "0";

//if (!planStatus.equals("-1")) 
//	term += " and t1.status = '" + planStatus +"' ";

int selectYear = Util.getIntValue(selectDate.substring(0,4));
int selectMonth = Util.getIntValue(selectDate.substring(5,7))-1;
int selectDay = Util.getIntValue(selectDate.substring(8,10));
cal.set(selectYear, selectMonth, selectDay);

switch (viewType) {
	case 1:
		if (moveDate.equals("1")) 
			cal.add(Calendar.DATE,1);

		if (moveDate.equals("-1")) 
			cal.add(Calendar.DATE,-1);

		break;
	case 2:
		Date theDate = cal.getTime();
		int diffDate = (-1)*theDate.getDay();//theDate.getDay()为当星期的第几天由于西方星期的第一天为星期日再-1
		cal.add(Calendar.DATE,diffDate);
		if (moveDate.equals("1")) 
			cal.add(Calendar.WEEK_OF_YEAR,1);

		if (moveDate.equals("-1")) 
			cal.add(Calendar.WEEK_OF_YEAR,-1);

		weekOfYear = "" + cal.get(Calendar.WEEK_OF_YEAR);
		cal.add(Calendar.DATE,1);
		break;
	case 3:
		cal.set(selectYear,selectMonth,1);
		if (moveDate.equals("1")) 
			cal.add(Calendar.MONTH,1);

		if (moveDate.equals("-1")) 
			cal.add(Calendar.MONTH,-1);

		break;
}

selectDate = Util.add0(cal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(cal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2);

switch (viewType) {
	case 1:
		cal.add(Calendar.DATE,1);
		break;
	case 2:
		cal.add(Calendar.WEEK_OF_YEAR,1);		
		break;
	case 3:
		cal.add(Calendar.MONTH,1);
		break;
}

String selectToDate = Util.add0(cal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(cal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2) ;

String selectMonthEndDate = selectToDate;

ArrayList weekStr = Util.TokenizerString(
                                        SystemEnv.getHtmlLabelName(392,user.getLanguage())+","+
                                        SystemEnv.getHtmlLabelName(393,user.getLanguage())+","+
                                        SystemEnv.getHtmlLabelName(394,user.getLanguage())+","+
                                        SystemEnv.getHtmlLabelName(395,user.getLanguage())+","+
                                        SystemEnv.getHtmlLabelName(396,user.getLanguage())+","+
                                        SystemEnv.getHtmlLabelName(397,user.getLanguage())+ ","+
                                        SystemEnv.getHtmlLabelName(398,user.getLanguage()),","
                                        );

int timeCols = 0;

switch (viewType) {
	case 1://日
		timeCols = 24;
		break;
	case 2: //星期
		timeCols = 7;
		break;
	case 3: //月
		timeCols = 31;
		break;
}

ArrayList workIds = new ArrayList();
ArrayList names = new ArrayList();
ArrayList beginDates = new ArrayList();
ArrayList beginTimes = new ArrayList();
ArrayList endDates = new ArrayList();
ArrayList endTimes = new ArrayList();
ArrayList urgentLevels = new ArrayList();
ArrayList status = new ArrayList();
ArrayList types = new ArrayList();
String userType = user.getLogintype();
String m_status = "";
String id="";
String planStartDay="2000-01-01";
String planEndDay="2000-01-01";
int pageNum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10000;

boolean hasNextPage = false;

String baseWhereClause = "";

String tempTable = "WPTempTable"+ Util.getNumberRandom();
String sqlStr = "";
if((rs.getDBType()).equals("oracle")) {
		baseWhereClause = " where t1.deleted <> 1 and t1.createrType = '" + userType + "' and ( concat(concat(',',TO_CHAR(t1.resourceid)),',') ) like '%"+(","+selectUser+",")+"%'" +   
						" and ((t1.begindate < '"+selectToDate+"' and t1.begindate >= '"+selectDate+"') or "+
						" (t1.enddate < '"+selectToDate+"' and t1.enddate >= '"+selectDate+"') or "+
						" (t1.enddate >= '"+selectToDate+"' and t1.begindate < '"+selectDate+"') or (t1.enddate is null and t1.begindate <= '"+selectDate+"'))"+term;

		sqlStr = "create table "+tempTable+"  as select * from (select DISTINCT"
               + " t1.id, t1.name, t1.begindate, t1.begintime, t1.enddate, t1.endtime, t1.urgentLevel, t1.status,t1.type_n"
               + " from WorkPlan t1 " + baseWhereClause +						"  order by t1.begindate,t1.begintime asc ) where rownum<"+ (pageNum*perpage+2);
}
else {
		baseWhereClause = " where t1.deleted <> 1 and t1.createrType = '" + userType + "' and (','+CONVERT(varchar(2000), t1.resourceid)+',') like '%"+(","+selectUser+",")+"%'" +   
					" and ((t1.begindate < '"+selectToDate+"' and t1.begindate >= '"+selectDate+"') or "+
					" (t1.enddate < '"+selectToDate+"' and t1.enddate >= '"+selectDate+"') or "+
					" (t1.enddate >= '"+selectToDate+"' and t1.begindate < '"+selectDate+"') or (t1.enddate= '' and t1.begindate <= '"+selectDate+"'))"+term;

		sqlStr = "select DISTINCT top "+(pageNum*perpage+1)
               + " t1.id, t1.name, t1.begindate, t1.begintime, t1.enddate, t1.endtime, t1.urgentLevel, t1.status,t1.type_n into "
               +tempTable+" from WorkPlan t1 "+baseWhereClause+
					"  order by t1.begindate,t1.begintime asc";
}

rs.executeSql(sqlStr);

rs.executeSql("SELECT COUNT(id) recordCount FROM "+tempTable);
int recordCount = 0;
if (rs.next())
	recordCount = rs.getInt("recordCount");

if (recordCount > pageNum * perpage) 
	hasNextPage = true;

if (rs.getDBType().equals("oracle"))
	sqlStr = "SELECT * FROM (SELECT * FROM  "+tempTable+") WHERE rownum< "+(recordCount-(pageNum-1)*perpage+1) ;	
else
	sqlStr = "SELECT TOP "+(recordCount-(pageNum-1)*perpage)+" * FROM "+tempTable+"";

rs.executeSql(sqlStr);

int totalLine = 1;

while(rs.next()){
	
	workIds.add(Util.null2String(rs.getString("id")));
	names.add(Util.null2String(rs.getString("name")));
	beginDates.add(Util.null2String(rs.getString("begindate")));
	beginTimes.add(Util.null2String(rs.getString("begintime")));
	endDates.add(Util.null2String(rs.getString("enddate")));
	endTimes.add(Util.null2String(rs.getString("endtime")));
	urgentLevels.add(Util.null2String(rs.getString("urgentLevel")));
	status.add(Util.null2String(rs.getString("status")));
    types.add(Util.null2String(rs.getString("type_n")));
	totalLine += 1;
	if (totalLine > perpage)
			break;
}


rs.executeSql("DROP TABLE " + tempTable);



baseWhereClause += "  and t3.workPlanId = t1.id AND t3.exchangeCount > 0";				   
sqlStr = "SELECT DISTINCT t1.id FROM WorkPlan t1, WorkPlanExchange t3 " + baseWhereClause ;

rs.executeSql(sqlStr);
ArrayList exWorkId = new ArrayList() ;
while(rs.next()){
	exWorkId.add(rs.getString("id")) ;
}



String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2211,user.getLanguage()) + ":&nbsp;"				
				 + "<A href='/hrm/resource/HrmResource.jsp?id=" + selectUser + "'>" + Util.toScreen(resourceComInfo.getResourcename(selectUser),user.getLanguage()) + "</A>";
String needfav = "1";
String needhelp = "";

String year; 
String month; 
month=""+TimeUtil.getCalendar(selectDate).get(Calendar.MONTH);
year =""+""+TimeUtil.getCalendar(selectDate).get(Calendar.YEAR);;
String cdays="";

    Calendar thisMonth=Calendar.getInstance(); 
   if(month!=null&&(!month.equals("null"))) 
   thisMonth.set(Calendar.MONTH, Integer.parseInt(month) ); 
   if(year!=null&&(!year.equals("null"))) 
   thisMonth.set(Calendar.YEAR, Integer.parseInt(year) ); 
   year=String.valueOf(thisMonth.get(Calendar.YEAR)); 
   month=String.valueOf(thisMonth.get(Calendar.MONTH)); 
	thisMonth.setFirstDayOfWeek(Calendar.SUNDAY); 
	thisMonth.set(Calendar.DAY_OF_MONTH,1); 
	int firstIndex=thisMonth.get(Calendar.DAY_OF_WEEK)-1;  //得到日历表格中月第一天数组下标
	int maxIndex=thisMonth.getActualMaximum(Calendar.DAY_OF_MONTH);  //月的天数
	
	int calendarRowNumber = (0 == (firstIndex + maxIndex) % 7) ? ((firstIndex + maxIndex) / 7) :((firstIndex + maxIndex) / 7) + 1;  //日历表格的行数。
	String[] days = new String[42];  //用于在日历表格显示中，每一个格子代表的日期。如果该格无日期，则设为""。
	for(int i = 0; i < 42; i++)  //日历表格显示中最多有6行，7列，则格子最多有6*7格。
	{ 
		days[i] = "";
	} 
	
	for(int i=0;i<maxIndex;i++)
	{ 
		days[firstIndex+i]=String.valueOf(i+1); 
	}
	  %>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//Modify by 杨国生 2004-11-3 For TD1314
if(isgoveproj==0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17559,user.getLanguage())+",javascript:changeStyle(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(16636,user.getLanguage())+",javascript:workPlanToggleleft(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name="frmmain" method="post" action="WorkPlanView.jsp">
<INPUT type="hidden" name="movedate">
<INPUT type="hidden" name="workid">
<INPUT type="hidden" name="pagenum" value="<%=pageNum%>">
<INPUT type="hidden" name="selectdate" value="<%=selectDate%>">
<INPUT type="hidden" name="selectUser" value="<%=selectUser%>">
<INPUT type="hidden" name="viewtype" value="<%=viewType%>">
<INPUT type="hidden" name="begindate">
<INPUT type="hidden" name="begintime">
<INPUT type="hidden" name="method" value="changestyle">
<INPUT type="hidden" name="style" value="0">

<TABLE width="100%" border="0" cellpadding="0" height="100%" cellspacing="0" class="ListStyle">
	<TR >
	<TD  valign="top">
		  <TABLE class="ListStyle" width="100%" id="WorkPlanTable" height="100%" cellspacing="1">
		  <TBODY>		  
		   <TR class="Header" > 
			  <TD height="5%"><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>:
				<SELECT size="1" style="width:80" name="plantype" onchange="changePlanType()">
				<OPTION value="" <%if(planType.equals("")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
				<OPTION value="0" <%if(planType.equals("0")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15090,user.getLanguage())%></OPTION>
				<OPTION value="1" <%if(planType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1038,user.getLanguage())%></OPTION>	
				<OPTION value="2" <%if(planType.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16095,user.getLanguage())%></OPTION>
				<OPTION value="3" <%if(planType.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(6082,user.getLanguage())%></OPTION>
				<OPTION value="4" <%if(planType.equals("4")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(17487,user.getLanguage())%></OPTION>
				<OPTION value="6" <%if(planType.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%></OPTION>
				</SELECT>
				&nbsp;<%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>:
				<SELECT size="1" style="width:50" name="planstatus" onchange="changePlanStatus()">
				<OPTION value="-1"  <%if(planStatus.equals("-1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
				<OPTION value="0" <%if(planStatus.equals("0")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
				<OPTION value="1" <%if(planStatus.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
				<OPTION value="2" <%if(planStatus.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
				</SELECT>&nbsp;&nbsp;&nbsp;
			  <BUTTON onclick="doPreTime()" style="width:20px">&lt;&lt;</BUTTON>
			  <%
			  String  viewDate= "";
			  switch (viewType) {
				case 1 ://日
					viewDate = selectDate ;
					break ;
				case 2: //周
					viewDate = selectDate.substring(0,4) +  SystemEnv.getHtmlLabelName(445,user.getLanguage())+"- "+ SystemEnv.getHtmlLabelName(15323,user.getLanguage())+weekOfYear+SystemEnv.getHtmlLabelName(1926,user.getLanguage()) +" ("+selectDate+")" ;
					break ;
				case 3: //月
					viewDate = selectDate.substring(0,7) ;
					break;
				}
				%>			  
			  <%=viewDate%>&nbsp;
			  <BUTTON onclick="doNextTime()" style="width:20px">&gt;&gt;</BUTTON>
			  </TD>
		  </TR>
		 <tr><td valign="top">
		 <%if (viewType==3) {
		 %>
		 <table border="0" width="100%" height="100%"  class="BroswerStyle" > 
			  <tr class="Header"> 
			    <th width="25"  height="5%"><font color="red">日</font></th> 
			    <th width="25"  height="5%" >一</th> 
			    <th width="25"  height="5%" >二</th> 
			    <th width="25"  height="5%" >三</th> 
			    <th width="25"  height="5%" >四</th> 
			    <th width="25"  height="5%" >五</th> 
			    <th width="25"  height="5%" ><font color="green">六</font></th> 
			  </tr> 
		<%
			String isLight="DataDark";
			month=""+(Util.getIntValue(month)+1);
			for(int j = 0; j < calendarRowNumber; j++)
			{ 
				if (isLight.equals("DataDark"))
				{
				    isLight="DataLight";
				}
				else
				{
				    isLight="DataDark";
				}
		%> 
				<tr class="<%=isLight%>"> 
		<% 
				for(int i = j * 7; i < (j + 1) * 7; i++) 
				{
		%> 
			    	<td width="14%"   align="left" valign="top" height="18%">
			     		<table height="18%" cellspacing="0" cellpadding="0">
			     			<tr class="<%=isLight%>">
			     				<td valign="middle">
			     					<font color="#000080"><%=days[i]%></font>
			     				</td>
			     				<td valign="top">
			     					<table class="ListStyle" cellspacing="0" cellpadding="0">
			     						<tr  class="<%=isLight%>">
			     							<td >
		<%
					int k=0;
				    int num=0;
				    
				    for (k=0;k<workIds.size();k++)
				    {			     
				    	if (!(""+days[i]).equals(""))
				    	//如果数组为""，则代表该格不在当前月
				     	{
				     		String temp=year+"-"+month+"-"+days[i];
					        cdays=TimeUtil.getDateString(TimeUtil.getCalendar(temp,"yyyy'-'MM'-'dd"));
				     		planStartDay=(""+beginDates.get(k)).equals("")?"2000-01-01":TimeUtil.getDateString(TimeUtil.getCalendar(""+beginDates.get(k),"yyyy'-'MM'-'dd"));
					        planEndDay=(""+endDates.get(k)).equals("")?"2015-12-01":TimeUtil.getDateString(TimeUtil.getCalendar(""+endDates.get(k),"yyyy'-'MM'-'dd"));
	
				     		m_status = Util.null2String(""+status.get(k));
				     		String m_type_code = Util.null2String(""+types.get(k));
					 		id=""+workIds.get(k);				
			         
					 		if ((m_type_code.equals("6")&&m_status.equals("6"))||(!m_type_code.equals("6")))//目标计划只显示已审批的
			         		{
				     			if (TimeUtil.dateInterval(planStartDay,cdays)>=0&&(TimeUtil.dateInterval(cdays,planEndDay)>=0))
				     			//从所有日程中筛选出cdays日需要执行的日程
				     			{
				      				if (num<4)
			         				{ 
										if (!m_type_code.equals("6"))
					 					{
		%>
				 								<A onclick="javascript:doView(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
		<% 
										}
					 					else 
					 					{
		%>
				 								<A onclick="javascript:doViewP(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
		<%
										}
		%>
			     								<%=Util.getSubStr(""+names.get(k),6)%></a><br/>
		<%
			     					}
				     				if (num==4)
				     				{
				     				    break;
				     				}
				     				num++;
				     			}
				     		}
				     	}
				    }
		%>
			     							</td>
			     						</tr>
		<%
					if (num==4)
				    {
		%>
			     						<tr class="<%=isLight%>">
			     							<td align="right">
			     								<A OnClick="doOnClickTd('<%=cdays%>')" style="CURSOR: hand;">
			     									<img border=0 src="/images/more_wev8.gif"></img>
			     								</a>
			     							</td>
			     						</tr>
		<%
					}
		%>
			     					</table>
			     				</td>
			     			</tr>
			     		</table>
			     	</td> 
		<% 
				}  
		%> 
			    </tr> 
		<% 
			} 
		%> 
		</table> 
		
			<%} 
			else if (viewType==1)
			{
			String isLight="DataDark";
			String  beginTime="";
            String endTime="";
			%>
			<table border="0" width="100%" height="95%" class="BroswerStyle"> 
			<tr><td colspan="2">
			<%for (int k=0;k<workIds.size();k++)
			{
			beginTime=""+beginTimes.get(k);
			endTime=""+endTimes.get(k);
			m_status = Util.null2String(""+status.get(k));
			String m_type_code = Util.null2String(""+types.get(k));
			id=""+workIds.get(k);	
			planStartDay=""+beginDates.get(k);
			planEndDay=""+endDates.get(k);			
		    if ((m_type_code.equals("6")&&m_status.equals("6"))||(!m_type_code.equals("6")))//目标计划只显示已审批的
		    {
			if ((beginTime.equals("")&&endTime.equals(""))||((!planStartDay.equals(selectDate))&&((!planEndDay.equals(selectDate))||(planEndDay.equals(selectDate)&&endTime.equals("")))))
			{
			 //out.print(selectDate+" "+planEndDay);
			 //out.print(""+beginDates.get(k));
			 if (!m_type_code.equals("6"))
			{%>
			<A onclick="javascript:doView(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
			<% }
			else {%>
			<A onclick="javascript:doViewP(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
			<%}%>
			<%=names.get(k)%></a></br>
			<%}}
			}%>
			</td></tr>
			<%for (int i=0;i<24;i++) {
			
			if (isLight.equals("DataDark")) isLight="DataLight";
			else isLight="DataDark";%>
			<tr class="<%=isLight%>"><td width="5%" align="center"><%=i%>:00</td>
			<td width="95%">
			<%for (int k=0;k<workIds.size();k++)
			{
			beginTime=""+beginTimes.get(k);
			endTime=""+endTimes.get(k);
			planStartDay=""+beginDates.get(k);
			planEndDay=""+endDates.get(k);	
			planEndDay=planEndDay.equals("")?"2015-01-01":planEndDay;
			if (!beginTime.equals(""))
			{
			beginTime=beginTime.substring(0,2);
			beginTime= beginTime.substring(0,1).equals("0")?beginTime.substring(1,2):beginTime;
			}
			if (!endTime.equals(""))
			{
			endTime=endTime.substring(0,2);
			endTime= endTime.substring(0,1).equals("0")?endTime.substring(1,2):endTime;
			}
			m_status = Util.null2String(""+status.get(k));
			String m_type_code = Util.null2String(""+types.get(k));
			id=""+workIds.get(k);
			if ((m_type_code.equals("6")&&m_status.equals("6"))||(!m_type_code.equals("6")))//目标计划只显示已审批的
		    {				
		    if ((m_type_code.equals("6")&&m_status.equals("6"))||(!m_type_code.equals("6")))//目标计划只显示已审批的
		    { if (((planStartDay.equals(selectDate)&&Util.getIntValue(beginTime,30)<=i)&&(TimeUtil.dateInterval(selectDate,planEndDay)>0||(planEndDay.equals(selectDate)&&Util.getIntValue(endTime,-1)>=i)))||(planEndDay.equals(selectDate)&&Util.getIntValue(endTime,-1)==i))
		    {
		    if (!m_type_code.equals("6"))
			{%>
			<A onclick="javascript:doView(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
			<% }
			else {%>
			<A onclick="javascript:doViewP(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
			<%}%>
			<%=names.get(k)%></a></br>
		    <%}
		    }
		    }
		    }
		    %>
			</td></tr>
			<%}%>
			</table>
			<%}
			else if (viewType==2) {
			%>
			<table border="0" width="100%" height="100%" class="BroswerStyle" cellspacing="0">
			<tr>
			<td width="50%">
			<%for (int i=1;i<=7;i++) {
				int k=0;
			     int num=0;
			     int ws=0;
				Calendar  ca=Calendar.getInstance();
			     ca=TimeUtil.getCalendar(selectDate);
			     if (i!=7) ws=i+1; 
			     ca.set(Calendar.DAY_OF_WEEK,ws);
			     cdays=TimeUtil.getDateString(ca);
				%>
			<tr width="50%" height="35%">
			<td width="50%">
			<table width="100%" height="100%" class="BroswerStyle" cellspacing="0">
			<tr class="Header"><td height="5%" align="right"><%=weekStr.get(i-1)%>(<%=cdays%>)</td></tr>
			<tr class="DataDark"><td valign="top">
			
			 <%
			     for (k=0;k<workIds.size();k++) {
			    // Calendar ca=Calendar.getInstance();
			     //ca=TimeUtil.getCalendar(selectDate);
			     //if (i!=7) ws=i+1; 
			     //ca.set(Calendar.DAY_OF_WEEK,ws);
			     //cdays=TimeUtil.getDateString(ca);
			    // out.print(cdays);
			     planStartDay=(""+beginDates.get(k)).equals("")?"2000-01-01":TimeUtil.getDateString(TimeUtil.getCalendar(""+beginDates.get(k),"yyyy'-'MM'-'dd"));
			     planEndDay=(""+endDates.get(k)).equals("")?"2015-12-01":TimeUtil.getDateString(TimeUtil.getCalendar(""+endDates.get(k),"yyyy'-'MM'-'dd"));
			     //out.print(cdays+planStartDay+planEndDay);
			     m_status = Util.null2String(""+status.get(k));
			     String m_type_code = Util.null2String(""+types.get(k));
				 id=""+workIds.get(k);				
		         if ((m_type_code.equals("6")&&m_status.equals("6"))||(!m_type_code.equals("6")))//目标计划只显示已审批的
		         {
			     if (TimeUtil.dateInterval(planStartDay,cdays)>=0&&(TimeUtil.dateInterval(cdays,planEndDay)>=0))
			     {
			      if (num<10)
		         { 
			     %>
			     <% if (!m_type_code.equals("6"))
				 {%>
				 <A onclick="javascript:doView(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
				 <% }
				 else {%>
				 <A onclick="javascript:doViewP(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
				  <%}%>
			     <%=Util.getSubStr(""+names.get(k),10)%></a><br/>
			     <%
			     }
			     if (num==10)
			     {break;}
			     num++;
			     }
			     }
			     }%>
			
			</td></tr>
			 <%if (num==10)
			     {%>
			     <tr class="DataDark"><td align="right">
			     <A OnClick="doOnClickTd('<%=cdays%>')" style="CURSOR: hand;"><img border=0 src="/images/more_wev8.gif"></img></a>
			     </td></tr>
			<%}%>
			</table>
			</td>
			<%i++;
			 ca=Calendar.getInstance();
			     ca=TimeUtil.getCalendar(selectDate);
			     if (i!=7) ws=i+1; 
			     ca.set(Calendar.DAY_OF_WEEK,ws);
			     cdays=TimeUtil.getDateString(ca);
			%>
			<td width="50%">
			<table  width="100%" height="100%" class="BroswerStyle" cellspacing="0">
			<tr class="Header"><td height="5%" align="right"><%=weekStr.get(i-1)%>(<%=cdays%>)</td></tr>
			</td></tr>
			<tr class="DataDark"><td valign="top">
			 <%  int temp=10;
			     num=0;
			     for (k=0;k<workIds.size();k++) {
			     //Calendar ca=Calendar.getInstance();
			     //ca=TimeUtil.getCalendar(selectDate);
			     //if (i!=7) ws=i+1; 
			     //ca.set(Calendar.DAY_OF_WEEK,ws);
			     //cdays=TimeUtil.getDateString(ca);
			     //out.print(cdays);
			     planStartDay=(""+beginDates.get(k)).equals("")?"2000-01-01":TimeUtil.getDateString(TimeUtil.getCalendar(""+beginDates.get(k),"yyyy'-'MM'-'dd"));
			     planEndDay=(""+endDates.get(k)).equals("")?"2015-12-01":TimeUtil.getDateString(TimeUtil.getCalendar(""+endDates.get(k),"yyyy'-'MM'-'dd"));
			     //out.print(cdays+planStartDay+planEndDay);
			     m_status = Util.null2String(""+status.get(k));
			     String m_type_code = Util.null2String(""+types.get(k));
				 id=""+workIds.get(k);	
				 if (i==6) temp=3;			
		         if ((m_type_code.equals("6")&&m_status.equals("6"))||(!m_type_code.equals("6")))//目标计划只显示已审批的
		         {
			     if (TimeUtil.dateInterval(planStartDay,cdays)>=0&&(TimeUtil.dateInterval(cdays,planEndDay)>=0))
			     {
			      if (num<temp)
		         { 
			     %>
			     <% if (!m_type_code.equals("6"))
				 {%>
				 <A onclick="javascript:doView(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
				 <% }
				 else {%>
				 <A onclick="javascript:doViewP(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
				  <%}%>
			     <%=Util.getSubStr(""+names.get(k),10)%></a><br/>
			     <%
			     }
			     if (num==temp)
			     {break;}
			     num++;
			     }
			     }
			     }%>
			</td></tr>
			 <%if (num==temp)
			     {%>
			     <tr class="DataDark"><td align="right">
			     <A OnClick="doOnClickTd('<%=cdays%>')" style="CURSOR: hand;"><img border=0 src="/images/more_wev8.gif"></img></a>
			     </td></tr>
			<%}%>
			<%if (i==6) {
			i++;
			ca=Calendar.getInstance();
			     ca=TimeUtil.getCalendar(selectDate);
			     if (i==7) ws=1; 
				 ca.add(Calendar.WEEK_OF_YEAR,1);
			     ca.set(Calendar.DAY_OF_WEEK,ws);
			     cdays=TimeUtil.getDateString(ca);
			%>
			<tr class="Header"><td height="5%" align="right" ><%=weekStr.get(i-1)%>(<%=cdays%>)</td></tr>
			</td></tr>
			<tr  class="DataDark"><td valign="top">
			 <%  num=0;
			     for (k=0;k<workIds.size();k++) {
			    // Calendar ca=Calendar.getInstance();
			    // ca=TimeUtil.getCalendar(selectDate);
			    // if (i!=7) ws=i+1; 
			    // ca.set(Calendar.DAY_OF_WEEK,ws);
			    // cdays=TimeUtil.getDateString(ca);
			     //out.print(cdays);
			     planStartDay=(""+beginDates.get(k)).equals("")?"2000-01-01":TimeUtil.getDateString(TimeUtil.getCalendar(""+beginDates.get(k),"yyyy'-'MM'-'dd"));
			     planEndDay=(""+endDates.get(k)).equals("")?"2015-12-01":TimeUtil.getDateString(TimeUtil.getCalendar(""+endDates.get(k),"yyyy'-'MM'-'dd"));
			     //out.print(cdays+planStartDay+planEndDay);
			     m_status = Util.null2String(""+status.get(k));
			     String m_type_code = Util.null2String(""+types.get(k));
				 id=""+workIds.get(k);				
		         if ((m_type_code.equals("6")&&m_status.equals("6"))||(!m_type_code.equals("6")))//目标计划只显示已审批的
		         {
			     if (TimeUtil.dateInterval(planStartDay,cdays)>=0&&(TimeUtil.dateInterval(cdays,planEndDay)>=0))
			     {
			      if (num<3)
		         { 
			     %>
			     <% if (!m_type_code.equals("6"))
				 {%>
				 <A onclick="javascript:doView(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
				 <% }
				 else {%>
				 <A onclick="javascript:doViewP(<%=id%>)" style="CURSOR: hand;" title="<%=names.get(k)%>">
				  <%}%>
			     <%=Util.getSubStr(""+names.get(k),10)%></a><br/>
			     <%
			     }
			     if (num==3)
			     {break;}
			     num++;
			     }
			     }
			     }%>
			</td></tr>
			<%if (num==3)
			     {%>
			     <tr class="DataDark"><td align="right">
			     <A OnClick="doOnClickTd('<%=cdays%>')" style="CURSOR: hand;"><img border=0 src="/images/more_wev8.gif"></img></a>
			     </td></tr>
			<%}%>
			<%}%>
			</table>
			</td>
			<%if (i%2==0||i==7) {%>
			</tr>
			<%}}%>
			</td></tr>
			
			</table>
			<%}%>
		 </td></tr>
		<TR class="Line"><TD colspan="7"></TD></TR> 
	</TABLE>			
 
</FORM>

<FORM id="weaver" name="weaver" method="post" action="WorkSpaceRight.jsp" target="workSpaceRight">
	<input type="hidden" name="selectdater" value="<%=selectDate%>">
	<input type="hidden" name="movedater">
	<input type="hidden" name="viewtyper" value="<%=viewType%>">
</FORM>


<SCRIPT LANGUAGE="JavaScript">
function doAdd() {
	document.frmmain.action = "/workplan/data/WorkPlanAdd.jsp";
	document.frmmain.submit();
}

function doQuickAddDate(beginDate) {
	document.all("begindate").value = beginDate;
	document.frmmain.action = "/workplan/data/WorkPlanAdd.jsp";
	document.frmmain.submit();
}

function doQuickAddTime(beginTime) {
	document.all("begindate").value = document.all("selectdate").value;
	document.all("begintime").value = beginTime;
	document.frmmain.action = "/workplan/data/WorkPlanAdd.jsp";
	document.frmmain.submit();
}

function changePlanType() {
	doSubmit();
}

function changePlanStatus() {
	doSubmit();
}

function doSubmit() {
	document.frmmain.submit();
}

function workPlanToggleleft(obj) {
	var f = window.parent.workplan;
	if (f != null) {
		var c = f.cols;
		if (c == "*,0") {
			f.cols = "*,200";
			//added by lupeng 2004.05.21 for TD487.
			obj.value = "<img src='/images_face/ecologyFace_1/ClickMenuIcon/CM_2_wev8.gif' border=0 align='absmiddle'> <%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";
			//end
		} else { 
			f.cols = "*,0";
			//added by lupeng 2004.05.21 for TD487.
			obj.value = "<img src='/images_face/ecologyFace_1/ClickMenuIcon/CM_2_wev8.gif' border=0 align='absmiddle'> <%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";
			//end
		}
	}
}

function doOnClickTd(selectDate) {
		document.frmmain.selectdate.value = selectDate;
		document.frmmain.viewtype.value = 1;
		document.frmmain.submit();
        document.weaver.selectdater.value = selectDate;
		document.weaver.viewtyper.value = 1;
		document.weaver.submit();
}
function OnSubmit(pagenum) {
        document.frmmain.pagenum.value = pagenum;
		document.frmmain.submit();
}
function doView(workid) {	
	//document.frmmain.action = 
	openFullWindowForXtable("/workplan/data/WorkPlanDetail.jsp?workid="+workid+"&from=1");
	//document.all("workid").value = workid;
	//document.frmmain.submit();
}
function doViewP(workid) {	
	//document.frmmain.action =
	openFullWindowForXtable("/hrm/performance/targetPlan/PlanView.jsp?from=1&id="+workid);
	//document.all("workid").value = workid;
	//document.frmmain.submit();
}
function doPreTime() {	
	document.all("movedate").value="-1" ;
	document.frmmain.submit();
	document.all("movedater").value="-1" ;
	document.weaver.submit();
}

function doNextTime() {	
	document.all("movedate").value="1" ;
	document.frmmain.submit();
	document.all("movedater").value="1" ;
	document.weaver.submit();
}
function changeStyle() {
	document.frmmain.action = "WorkSpaceHandler.jsp";
	document.frmmain.target = "workSpaceLeft";
	document.frmmain.submit();
}

function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top=100," ; 
  szFeatures +="left=400," ;
  szFeatures +="width="+width/2+"," ;
  szFeatures +="height="+height/2+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

</SCRIPT>

</BODY>
</HTML>