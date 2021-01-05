
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.WorkPlan.WorkPlanShareUtil"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.Constants" %>

<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
	</HEAD>
<BODY>

<%
	Calendar cal = Calendar.getInstance();
	Calendar countCalendar = Calendar.getInstance();
	String currDate = Util.add0(cal.get(Calendar.YEAR), 4) + "-" +
	                 Util.add0(cal.get(Calendar.MONTH) + 1, 2) + "-" +
	                 Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2);
	String currTime = Util.add0(cal.getTime().getHours(), 2) + ":" +
					 Util.add0(cal.getTime().getMinutes(), 2) + ":" +
					 Util.add0(cal.getTime().getSeconds(), 2);


	String userType = user.getLogintype();  //当前用户类型
	String userId = String.valueOf(user.getUID());  //当前用户Id
	String selectUser = Util.null2String(request.getParameter("selectUser"));  //选择用户Id
	if("".equals(selectUser))
	{
	    selectUser = userId;
	}
	String selectDate = Util.null2String(request.getParameter("selectdate"));  //选择日期
	if("".equals(selectDate))
	{
	    selectDate = currDate;
	}
	int viewType = Util.getIntValue(request.getParameter("viewtype"), 2);  //1:日计划显示 2:周计划显示 3:月计划显示
	String planType = Util.null2String(request.getParameter("planType"));  //日程类型
	String planStatus = Util.null2String(request.getParameter("planStatus"));  //日程状态
	int countCell = 0;
	
	//日期计算
	int selectYear = Util.getIntValue(selectDate.substring(0, 4));
	int selectMonth = Util.getIntValue(selectDate.substring(5, 7)) - 1;
	int selectDay = Util.getIntValue(selectDate.substring(8, 10));
	cal.set(selectYear, selectMonth, selectDay);
	String moveDate = Util.null2String(request.getParameter("moveDate"));
	String weekOfYear = "";
	switch (viewType) 
	{
		case 1:
		//日
			if (moveDate.equals("1")) 
			{
				cal.add(Calendar.DATE, 1);
			}
			else if (moveDate.equals("-1")) 
			{
			    cal.add(Calendar.DATE, -1);
			}			
			break;
		case 2:
		//周
			cal.add(Calendar.DATE, -1 * (cal.get(Calendar.DAY_OF_WEEK) - 1));			
			if (moveDate.equals("1")) 
			{
			    cal.add(Calendar.WEEK_OF_YEAR, 1);
			}
			else if (moveDate.equals("-1")) 
			{
			    cal.add(Calendar.WEEK_OF_YEAR, -1);
			}
			weekOfYear = String.valueOf(cal.get(Calendar.WEEK_OF_YEAR));
			break;
		case 3:
		//月
			cal.set(selectYear, selectMonth, 1);
			if (moveDate.equals("1")) 
			{
			    cal.add(Calendar.MONTH,1 );
			}
			else if (moveDate.equals("-1")) 
			{
			    cal.add(Calendar.MONTH, -1);
			}
			break;
	}
	String beginDate = Util.add0(cal.get(Calendar.YEAR), 4) + "-" +
			    Util.add0(cal.get(Calendar.MONTH) + 1, 2) + "-" +
			    Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2);
	countCalendar.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH), 0, 0);

	switch (viewType)
	{
		case 1:
			countCell = 24;
			break;
		case 2:
			cal.add(Calendar.WEEK_OF_YEAR, 1);
			cal.add(Calendar.DATE, -1);
			countCell = 7;
			break;
		case 3:
			cal.add(Calendar.MONTH, 1);
			cal.add(Calendar.DATE, -1);
			countCell = cal.get(Calendar.DAY_OF_MONTH);
			break;
	}
	String endDate = Util.add0(cal.get(Calendar.YEAR), 4) + "-" +
			    Util.add0(cal.get(Calendar.MONTH) + 1, 2) + "-" +
			    Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2);
	
	String shareSql=WorkPlanShareUtil.getShareSql(user);
	//System.out.println(beginDate + "*" + endDate + "&&" + selectDate);
%>

<%	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(16652, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(20168,user.getLanguage())+",javascript:changeToTimeView(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM name="frmmain" method="post" action="WorkPlanViewEventShare.jsp">
<INPUT type="hidden" name="selectUser" value="<%= selectUser %>">
<INPUT type="hidden" name="viewtype" value="<%= viewType %>">
<INPUT type="hidden" name="selectdate" value="<%= beginDate %>">
<INPUT type="hidden" name="moveDate" value="0">
<TABLE width="100%" border="0" cellpadding="0" height="100%" cellspacing="0" class="ListStyle">
	<TR>
	<TD valign="top">
		<TABLE class="ListStyle" width="100%" id="WorkPlanTable" height="100%" cellspacing="1">
			<TBODY>		  
			<TR class="Header" > 
				<TD height="5%">
					<%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>:
					<SELECT size="1" style="width:80" name="planType">
						<OPTION value="" <%if(planStatus.equals("")){%>selected<%}%> ></OPTION>
						<%
		  					recordSet.executeSql("SELECT * FROM WorkPlanType WHERE available = '1' ORDER BY displayOrder ASC");
		  					//System.out.println("SELECT * FROM WorkPlanType WHERE available = '1' ORDER BY displayOrder ASC");
							while(recordSet.next())
		  					{
		  					    String planTypeOption = recordSet.getString("workPlanTypeID");
		  				%>
						<OPTION value=<%= planTypeOption %> <%if(planType.equals(planTypeOption)){%>selected<%}%> ><%= recordSet.getString("workPlanTypeName") %></OPTION>
		  				<%
		  					}
		  				%>	
					</SELECT>
					&nbsp;
					<%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>:
					<SELECT size="1" style="width:50" name="planStatus">
						<OPTION value="" <%if(planStatus.equals("")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
						<OPTION value="0" <%if(planStatus.equals("0")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
						<OPTION value="1" <%if(planStatus.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
						<OPTION value="2" <%if(planStatus.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
					</SELECT>&nbsp;&nbsp;&nbsp;
					<BUTTON onclick="doPreTime()" style="width:20px">&lt;&lt;</BUTTON>
					<%
						String  viewDate= "";
						switch (viewType)
						{
							case 1://日
								viewDate = beginDate;
								break;
							case 2: //周
								viewDate = beginDate.substring(0,4) + SystemEnv.getHtmlLabelName(445,user.getLanguage()) + "-" + SystemEnv.getHtmlLabelName(15323,user.getLanguage()) + weekOfYear + SystemEnv.getHtmlLabelName(1926,user.getLanguage()) + "("+beginDate+")" ;
								break ;
							case 3: //月
								viewDate = beginDate.substring(0,7) ;
								break;
						}
					%>			  
					<%= viewDate %>&nbsp;
					<BUTTON onclick="doNextTime()" style="width:20px">&gt;&gt;</BUTTON>
			  	</TD>
			</TR>
			<%
			String sqlSelect = "SELECT C.*, WorkPlanExchange.exchangeCount FROM(SELECT * FROM "
				+ "("
				+ "SELECT workPlan.*, workPlanType.workPlanTypeColor"
				+ " FROM WorkPlan workPlan, WorkPlanType workPlanType"
				+ " WHERE "
				//+ Constants.WorkPlan_Status_Finished
				//+ " AND workPlan.status <>"
				//+ Constants.WorkPlan_Status_Archived
			 	+ "  workPlan.type_n = workPlanType.workPlanTypeId" ;
				//+ " AND workPlan.createrType = '" + userType + "'"
				//+ " AND ("
				//+ " workPlan.resourceID = '" + selectUser + "'"
				//+ " OR workPlan.resourceID LIKE '" + selectUser + ",%'"
				//+ " OR workPlan.resourceID LIKE '%," + selectUser + ",%'"
				//+ " OR workPlan.resourceID LIKE '%," + selectUser + "'"
				//+ " )";
			
				if(!"".equals(planType))
				{
				    sqlSelect += " AND type_n = " + planType; 
				}
				if(!"".equals(planStatus))
				{
				    sqlSelect += " AND status = '" + planStatus + "'";
				}	
				
				sqlSelect += " AND ( (workPlan.beginDate >= '" + beginDate + "' AND workPlan.beginDate <= '" + endDate + "') OR "
				+ " (workPlan.endDate >= '" + beginDate + "' AND workPlan.endDate <= '" + endDate + "') OR "
				+ " (workPlan.endDate >= '" + endDate + "' AND workPlan.beginDate <= '" + beginDate + "') OR "
				+ " ((workPlan.endDate IS null OR workPlan.endDate = '') AND workPlan.beginDate <= '" + beginDate + "') )"
				+ " ) A"
				
				+ " LEFT JOIN"
				+ shareSql
				+ " ) B"
				
				+ " ON A.id = B.workId) C"
				
				+ " LEFT JOIN WorkPlanExchange"

				+ " ON C.id = WorkPlanExchange.workPlanId AND WorkPlanExchange.memberId = " + userId
			
				+ " WHERE shareLevel > 0"
				
				+ " ORDER BY beginDate DESC, beginTime DESC";
			
				//out.println(sqlSelect);
				recordSet.executeSql(sqlSelect);
			%>
			<TR>
				<TD valign="top">
					<%					
					if(1 == viewType)
					//日
					{
					%> 
					<TABLE class="ListStyle" cellspacing="1" id="result">
						<TR class="Header">
							<TD><%= SystemEnv.getHtmlLabelName(229,user.getLanguage()) %></TD>
					<%
						    for(int i = 0; i < countCell; i++)
							{
					%>
							<TD><%= Util.add0(i, 2) %></TD>
					<%
							}
					%>
						</TR>

					<%
						boolean isLight = true;
						while(recordSet.next())
						{
						    int workplanId = recordSet.getInt("id");
						    String workplanName = recordSet.getString("name");
						    String urgentLevelTemp = recordSet.getString("urgentLevel");
						    int urgentLevel = 1;
						    if(null != urgentLevelTemp && !"".equals(urgentLevelTemp))
						    {
						        urgentLevel = Integer.parseInt(urgentLevelTemp);
						    }
						    String workPlanType = recordSet.getString("type_n");
						    String workplanColor = recordSet.getString("workPlanTypeColor");
						    String workplanBeginDate = recordSet.getString("beginDate");
						    String workplanBeginTime = recordSet.getString("beginTime");
						    if("".equals(workplanBeginTime) || null == workplanBeginTime)
						    {
						        workplanBeginTime = Constants.WorkPlan_StartTime;						        
						    }
						    String workplanEndDate = recordSet.getString("endDate");
						    String workplanEndTime = recordSet.getString("endTime");
						    int exchangeCount = recordSet.getInt("exchangeCount");
					%>
						<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
							<TD><%= getUrgent(urgentLevel) %><% if ("6".equals(workPlanType)) { %><A href='#' onclick=openFullWindow1('/hrm/performance/targetPlan/PlanView.jsp?id=<%= workplanId %>&from=2')><% } else { %><A href='#' onclick=openFullWindow1('/workplan/data/WorkPlanDetail.jsp?workid=<%= workplanId %>&from=1')><% } %><%= isBold(workplanName, exchangeCount) %></A></TD>
					<%
						    for(int i = 0; i < countCell; i++)
							{
								if(isTimeOccupied(countCalendar, workplanBeginDate, workplanBeginTime, workplanEndDate, workplanEndTime))
								{
						
					%>
								<TD style="background-color='<%= workplanColor %>'"></TD>
					<%
								}
								else
								{
						
					%>
								<TD></TD>
					<%
								}
								countCalendar.add(Calendar.HOUR_OF_DAY, 1);
							}
					%>
						</TR>
					<%					
							countCalendar.add(Calendar.HOUR_OF_DAY, -1 * countCell);
							isLight = !isLight;
						}
					%>
					</TABLE>  
					<%
					}
					else if(2 == viewType)
					//周
					{
					%>
					<TABLE class="ListStyle" cellspacing="1" id="result">
						<TR class="Header">
							<TD><%= SystemEnv.getHtmlLabelName(229,user.getLanguage()) %></TD>
							<TD><%= SystemEnv.getHtmlLabelName(398,user.getLanguage()) %></TD>
							<TD><%= SystemEnv.getHtmlLabelName(392,user.getLanguage()) %></TD>
							<TD><%= SystemEnv.getHtmlLabelName(393,user.getLanguage()) %></TD>
							<TD><%= SystemEnv.getHtmlLabelName(394,user.getLanguage()) %></TD>
							<TD><%= SystemEnv.getHtmlLabelName(395,user.getLanguage()) %></TD>
							<TD><%= SystemEnv.getHtmlLabelName(396,user.getLanguage()) %></TD>
							<TD><%= SystemEnv.getHtmlLabelName(397,user.getLanguage()) %></TD>
						</TR>

					<%
						boolean isLight = true;
						while(recordSet.next())
						{
						    int workplanId = recordSet.getInt("id");
						    String workplanName = recordSet.getString("name");
						    String urgentLevelTemp = recordSet.getString("urgentLevel");
						    int urgentLevel = 1;
						    if(null != urgentLevelTemp && !"".equals(urgentLevelTemp))
						    {
						        urgentLevel = Integer.parseInt(urgentLevelTemp);
						    }						    
						    String workPlanType = recordSet.getString("type_n");
						    String workplanColor = recordSet.getString("workPlanTypeColor");
						    String workplanBeginDate = recordSet.getString("beginDate");
						    String workplanBeginTime = recordSet.getString("beginTime");
						    String workplanEndDate = recordSet.getString("endDate");
						    String workplanEndTime = recordSet.getString("endTime");
						    int exchangeCount = recordSet.getInt("exchangeCount");
					%>
						<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
							<TD><%= getUrgent(urgentLevel) %><% if ("6".equals(workPlanType)) { %><A href='#' onclick=openFullWindow1('/hrm/performance/targetPlan/PlanView.jsp?id=<%= workplanId %>&from=2')><% } else { %><A href='#' onclick=openFullWindow1('/workplan/data/WorkPlanDetail.jsp?workid=<%= workplanId %>&from=1')><% } %><%= isBold(workplanName, exchangeCount) %></A></TD>
					<%
						    for(int i = 0; i < countCell; i++)
							{
						        String paraDate = Util.add0(countCalendar.get(Calendar.YEAR), 4) + "-" +
											    Util.add0(countCalendar.get(Calendar.MONTH) + 1, 2) + "-" +
											    Util.add0(countCalendar.get(Calendar.DAY_OF_MONTH), 2);

								if(isDayOccupied(countCalendar, workplanBeginDate, workplanEndDate))
								{
						
					%>
								<TD style="background-color='<%= workplanColor %>'" onclick=changeToDayEventView('<%= paraDate %>')></TD>
					<%
								}
								else
								{
						
					%>
								<TD onclick=changeToDayEventView('<%= paraDate %>')></TD>
					<%
								}
								countCalendar.add(Calendar.DATE, 1);
							}
					%>
						</TR>
					<%
							countCalendar.add(Calendar.DATE, -1 * countCell);
							isLight = !isLight;
						}
					%>
					</TABLE>
					<%
					}
					else if(3 == viewType)
					//月
					{
					%>
					<TABLE class="ListStyle" cellspacing="1" id="result">
						<TR class="Header">
							<TD><%= SystemEnv.getHtmlLabelName(229,user.getLanguage()) %></TD>
					<%
						    for(int i = 0; i < countCell; i++)
							{
					%>
							<TD><%= Util.add0(i + 1, 2) %></TD>
					<%
							}
					%>
						</TR>

					<%
						boolean isLight = true;
						while(recordSet.next())
						{
						    int workplanId = recordSet.getInt("id");
						    String workplanName = recordSet.getString("name");
						    String urgentLevelTemp = recordSet.getString("urgentLevel");
						    int urgentLevel = 1;
						    if(null != urgentLevelTemp && !"".equals(urgentLevelTemp))
						    {
						        urgentLevel = Integer.parseInt(urgentLevelTemp);
						    }
						    String workPlanType = recordSet.getString("type_n");
						    String workplanColor = recordSet.getString("workPlanTypeColor");
						    String workplanBeginDate = recordSet.getString("beginDate");
						    String workplanBeginTime = recordSet.getString("beginTime");
						    String workplanEndDate = recordSet.getString("endDate");
						    String workplanEndTime = recordSet.getString("endTime");
						    int exchangeCount = recordSet.getInt("exchangeCount");
					%>
						<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
							<TD><%= getUrgent(urgentLevel) %><% if ("6".equals(workPlanType)) { %><A href='#' onclick=openFullWindow1('/hrm/performance/targetPlan/PlanView.jsp?id=<%= workplanId %>&from=2')><% } else { %><A href='#' onclick=openFullWindow1('/workplan/data/WorkPlanDetail.jsp?workid=<%= workplanId %>&from=1')><% } %><%= isBold(workplanName, exchangeCount) %></A></TD>
					<%
						    for(int i = 0; i < countCell; i++)
							{
						        String paraDate = Util.add0(countCalendar.get(Calendar.YEAR), 4) + "-" +
											    Util.add0(countCalendar.get(Calendar.MONTH) + 1, 2) + "-" +
											    Util.add0(countCalendar.get(Calendar.DAY_OF_MONTH), 2);						        
						        
								if(isDayOccupied(countCalendar, workplanBeginDate, workplanEndDate))
								{
						
					%>
								<TD style="background-color='<%= workplanColor %>'" onclick=changeToDayEventView('<%= paraDate %>')></TD>
					<%
								}
								else
								{
						
					%>
								<TD onclick=changeToDayEventView('<%= paraDate %>')></TD>
					<%
								}
								countCalendar.add(Calendar.DATE, 1);
							}
					%>
						</TR>
					<%
							countCalendar.add(Calendar.DATE, -1 * countCell);
							isLight = !isLight;
						}
					%>
					</TABLE>					
					<%
					}
					%>
				</TD>
			</TR>
		</TABLE>			
	</TR>
</TABLE>
</FORM>

<!-- FORM id="weaver" name="weaver" method="post" action="WorkPlanRight.jsp" target="workplanRight">
	<input type="hidden" name="selectdater" value="<%//selectDate%>">
	<input type="hidden" name="movedater" value="0">
	<input type="hidden" name="viewtyper" value="<%//viewType%>">
</FORM -->

</BODY>
</HTML>

<%!
	public String isBold(String workplanName, int exchangeCount)
	{
    	if(exchangeCount > 0)
    	{
    	    return "<B>" + workplanName + "</B>";
    	}
    	else
    	{
    	    return workplanName;
    	}    
	}

	public boolean isDayOccupied(Calendar thisDate, String beginDate, String endDate)
	{
	    String thisDateString = Util.add0(thisDate.get(Calendar.YEAR), 4) + "-" +
					    Util.add0(thisDate.get(Calendar.MONTH) + 1, 2) + "-" +
					    Util.add0(thisDate.get(Calendar.DAY_OF_MONTH), 2);
	    if(string2Int(beginDate, "-") <= string2Int(thisDateString, "-") && ("".equals(endDate) || null == endDate || string2Int(thisDateString, "-") <= string2Int(endDate, "-")))
	    {
	        return true;
	    }
	    else
	    {
	        return false;
	    }
	}

	public boolean isTimeOccupied(Calendar thisDate, String beginDate, String beginTime, String endDate, String endTime)
	{
	    String thisDateString = Util.add0(thisDate.get(Calendar.YEAR), 4) + "-" +
					    Util.add0(thisDate.get(Calendar.MONTH) + 1, 2) + "-" +
					    Util.add0(thisDate.get(Calendar.DAY_OF_MONTH), 2);
	    String thisTimeString = Util.add0(thisDate.get(Calendar.HOUR_OF_DAY), 2);
	    
		//开始日期在当前日期前，并且结束日期在当前日期后
	    if(string2Int(beginDate, "-") < string2Int(thisDateString, "-") 
	    	&& ("".equals(endDate) || null == endDate || string2Int(thisDateString, "-") < string2Int(endDate, "-")))
	    {
	        return true;
	    }
		//开始日期等于当前日期，并且结束日期在当前日期后
	    else if(string2Int(beginDate, "-") == string2Int(thisDateString, "-") && ("".equals(endDate) || null == endDate || string2Int(thisDateString, "-") < string2Int(endDate, "-")))
	    {
	        if(string2Int(beginTime, ":") <= string2Int(thisTimeString + ":59", ":"))
	        {
	            return true;
	        }
	        else
	        {
	            return false;
	        }
	    }
		//开始日期在当前日期前，并且结束日期等于当前日期
	    else if(string2Int(beginDate, "-") < string2Int(thisDateString, "-") && string2Int(thisDateString, "-") == string2Int(endDate, "-"))
	    {
	        if("".equals(endTime) || null == endTime || string2Int(thisTimeString + ":00", ":") <= string2Int(endTime, ":"))
	        {
	            return true;
	        }
	        else
	        {
	            return false;
	        }
	    }
		//开始日期等于当前日期，并且结束日期等于当前日期
	    else if(string2Int(beginDate, "-") == string2Int(thisDateString, "-") && string2Int(thisDateString, "-") == string2Int(endDate, "-"))
	    {
	        if(string2Int(beginTime, ":") <= string2Int(thisTimeString + ":59", ":") && ("".equals(endTime) || null == endTime || string2Int(thisTimeString + ":00", ":") <= string2Int(endTime, ":")))
	        {
	            return true;
	        }
	        else
	        {
	            return false;
	        }
	    }
	    else
	    {
	        return false;
	    }
	}
	
	public String getUrgent(int urgentLevel)
	{
	    if(2 == urgentLevel)
	    {
	        return "<IMG src='/images/important_wev8.gif' align=absMiddle>";
	    }
	    else if(3 == urgentLevel)
	    {
	        return "<IMG src='/images/urgent_wev8.gif' align=absMiddle>";
	    }
	    else
	    {
	        return "";
	    }
	}
	
	public int string2Int(String original, String symbol)
	{
	    return Util.getIntValue(Util.StringReplace(original, symbol, ""));
	}
%>

<SCRIPT LANGUAGE="JavaScript">

function openFullWindow1(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ; 
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function doPreTime() 
{	
	document.all("moveDate").value = "-1" ;
	document.frmmain.submit();
	//document.all("movedater").value = "-1" ;
	//document.weaver.submit();
}

function doNextTime() 
{	
	document.all("movedate").value = "1" ;
	document.frmmain.submit();
	//document.all("movedater").value = "1" ;
	//document.weaver.submit();
}

function doSearch() 
{	
	document.all("movedate").value = "0" ;
	document.frmmain.submit();
}

function changeToTimeView()
{
	document.frmmain.action = "WorkPlanViewShare.jsp#rushHour";
	document.frmmain.submit();
}

function changeToDayEventView(paraDate)
{
	document.frmmain.action = "WorkPlanViewEventShare.jsp";
	document.frmmain.viewtype.value = "1";
	document.frmmain.selectdate.value = paraDate;

	document.frmmain.submit();
}
</SCRIPT>
