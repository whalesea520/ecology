
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@page import="java.util.Calendar"%><%@page import="net.sf.json.JSONObject"%><%@page import="weaver.hrm.User"%><%@page import="weaver.hrm.HrmUserVarify"%><%@ page import="org.apache.commons.logging.Log"%><%@ page import="org.apache.commons.logging.LogFactory"%><%@page import="weaver.general.Util"%><%@page import="java.util.Map"%><%@page import="java.util.HashMap"%><%@page import="java.util.List"%><%@page import="java.util.ArrayList"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.util.Date"%>
<%@page import="net.sf.json.JsonConfig"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="java.util.StringTokenizer"%>
<%@page import="weaver.WorkPlan.MutilUserUtil"%>
<%@page import="weaver.meeting.MeetingShareUtil"%><jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/><%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser(request, response);
	//if(user == null)  return ;
	Log logger = LogFactory.getLog(this.getClass());

	//onmousemove="coordinateReport()"
	/*
	 * 页面参数接收
	 * 数据库数据读取
	 */
	Calendar thisCalendar = Calendar.getInstance(); //当前日期
	Calendar selectCalendar = Calendar.getInstance(); //用于显示的日期
	Calendar currntCalendar = Calendar.getInstance();

	int countDays = 0; //需要显示的天数
	int offsetDays = 0; //相对显示显示第一天的偏移天数
	String thisDate = ""; //当前日期
	String selectDate = ""; //用于显示日期

	String beginDate = "";
	String endDate = "";

	String beginYear = "";
	String beginMonth = "";
	String beginDay = "";

	String endYear = "";
	String endMonth = "";
	String endDay = "";

	//参数传递
	String userId = String.valueOf(user.getUID()); //当前用户Id
	String userType = user.getLogintype(); //当前用户类型
	String selectUser = Util.null2String(request
			.getParameter("selectUser")); //被选择用户Id	
	String selectedType = Util.null2String(request
			.getParameter("selectedType")); //被选择类型
	String selectedDept = Util.null2String(request
			.getParameter("selectedDept")); //被选择部门
	String selectedSub = Util.null2String(request
			.getParameter("selectedSub")); //被选择分部			
	String hasrightview = Util.null2String(request
			.getParameter("hasrightview")); //是否有权限查看	
	String viewType = request.getParameter("viewtype"); //1:日计划显示 2:周计划显示 3:月计划显示
	String selectDateString = Util.null2String(request
			.getParameter("selectdate")); //被选择日期
	String isShare = Util.null2String(request.getParameter("isShare")); //是否是共享    1：共享日程
	String selectUserNames = Util.null2String(request
			.getParameter("selectUserNames")); //查看其他人姓名
	String meetingType =  Util.null2String(request
			.getParameter("meetingType")); //会议的进行状态
	
    SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd HH:mm") ;
    Calendar calendar = Calendar.getInstance() ;
    String currenttime = SDF.format(calendar.getTime()) ;
	
	boolean appendselectUser = false;

	viewType = "day".equals(viewType) ? "1"
			: ("week".equals(viewType) ? "2" : "3");

	if ("".equals(selectUser) || userId.equals(selectUser)) {
		appendselectUser = true;
		selectUser = userId;
	}
	selectUser = selectUser.replaceAll(",", "");
	
	String allUser=MeetingShareUtil.getAllUser(user);
	
	String thisYear = Util.add0((thisCalendar.get(Calendar.YEAR)), 4); //当前年
	String thisMonth = Util.add0(
			(thisCalendar.get(Calendar.MONTH)) + 1, 2); //当前月
	String thisDayOfMonth = Util.add0((thisCalendar
			.get(Calendar.DAY_OF_MONTH)), 2); //当前日
	thisDate = thisYear + "-" + thisMonth + "-" + thisDayOfMonth;

	if (!"".equals(selectDateString))
	//当选择日期
	{
		int selectYear = Util.getIntValue(selectDateString.substring(0,
				4)); //被选择年
		int selectMonth = Util.getIntValue(selectDateString.substring(
				5, 7)) - 1; //被选择月
		int selectDay = Util.getIntValue(selectDateString.substring(8,
				10)); //被选择日
		selectCalendar.set(selectYear, selectMonth, selectDay);
	}

	String selectYear = Util.add0((selectCalendar.get(Calendar.YEAR)),
			4); //年 
	String selectMonth = Util.add0(
			(selectCalendar.get(Calendar.MONTH)) + 1, 2); // 月
	String selectDayOfMonth = Util.add0((selectCalendar
			.get(Calendar.DAY_OF_MONTH)), 2); //日    
	String selectWeekOfYear = String.valueOf(selectCalendar
			.get(Calendar.WEEK_OF_YEAR)); //第几周
	String selectDayOfWeek = String.valueOf(selectCalendar
			.get(Calendar.DAY_OF_WEEK)); //一周第几天
	selectDate = selectYear + "-" + selectMonth + "-"
			+ selectDayOfMonth;

	switch (Integer.parseInt(viewType))
	//设置为显示的第一天
	{
	case 1:
		//日显示
		offsetDays = 0;
		break;
	case 2:
		//周显示
		offsetDays = Integer.parseInt(selectDayOfWeek) - 1;
		selectCalendar.add(Calendar.DAY_OF_WEEK, -1
				* Integer.parseInt(selectDayOfWeek) + 1);
		break;
	case 3:
		//月显示
		selectCalendar.set(Calendar.DATE, 1); //设置为月第一天
		int offsetDayOfWeek = selectCalendar.get(Calendar.DAY_OF_WEEK) - 1;
		offsetDays = Integer.parseInt(selectDayOfMonth) - 1
				+ offsetDayOfWeek;
		selectCalendar.add(Calendar.DAY_OF_WEEK, -1 * offsetDayOfWeek); //设置为月首日那周的第一天
		break;
	}
	beginYear = Util.add0(selectCalendar.get(Calendar.YEAR), 4); //年 
	beginMonth = Util.add0(selectCalendar.get(Calendar.MONTH) + 1, 2); // 月
	beginDay = Util.add0(selectCalendar.get(Calendar.DAY_OF_MONTH), 2); //日 
	beginDate = beginYear + "-" + beginMonth + "-" + beginDay;
	//System.out.println("viewType:" + viewType);
	switch (Integer.parseInt(viewType))
	//设置为显示的最后一天
	{
	case 1:
		//日计划显示
		countDays = 1;
		break;
	case 2:
		//周计划显示
		selectCalendar.add(Calendar.WEEK_OF_YEAR, 1);
		selectCalendar.add(Calendar.DATE, -1);
		countDays = 7;
		break;
	case 3:
		//月计划显示
		selectCalendar.add(Calendar.DATE, offsetDays);
		//System.out.println("######" + selectCalendar.get(Calendar.DATE));
		selectCalendar.set(Calendar.DATE, 1); //设置为月第一天
		selectCalendar.add(Calendar.MONTH, 1);
		selectCalendar.add(Calendar.DATE, -1);
		countDays = selectCalendar.get(Calendar.DAY_OF_MONTH); //当月天数
		int offsetDayOfWeekEnd = 7 - selectCalendar
				.get(Calendar.DAY_OF_WEEK);
		selectCalendar.add(Calendar.DAY_OF_WEEK, offsetDayOfWeekEnd); //设置为月末日那周的最后一天
		break;
	}
	endYear = Util.add0(selectCalendar.get(Calendar.YEAR), 4); //年 
	endMonth = Util.add0(selectCalendar.get(Calendar.MONTH) + 1, 2); // 月
	endDay = Util.add0(selectCalendar.get(Calendar.DAY_OF_MONTH), 2); //日
	endDate = endYear + "-" + endMonth + "-" + endDay;
	

	//String temptable = WorkPlanShareBase.getTempTable(userId);
	StringBuffer sqlStringBuffer = new StringBuffer();

	sqlStringBuffer
			.append("SELECT DISTINCT t1.id,t1.name,t1.address,t1.customizeAddress,t1.caller,t1.contacter,t1.begindate,t1.begintime,t1.enddate,t1.endtime,t1.meetingstatus,t1.isdecision, t3.status as status,t.id as tid, t.name as typename ")
			.append(" FROM Meeting_ShareDetail t2,   Meeting t1 left join Meeting_View_Status t3 on t3.meetingId = t1.id and t3.userId = " + userId + ", Meeting_Type  t   ");
	sqlStringBuffer.append(" WHERE t1.meetingtype = t.id");
	
	sqlStringBuffer.append(" and (t1.id = t2.meetingId) and t1.repeatType = 0  AND");
	sqlStringBuffer.append(" ((t1.meetingStatus in (1, 3) and t2.userId in ( " + allUser + ") AND t2.shareLevel in (1,4))" );
	sqlStringBuffer.append(" OR (t1.meetingStatus = 0  AND t1.creater in ( " + allUser + ")  AND (t2.userId in ( " + allUser + ")) )");
	sqlStringBuffer.append(" OR (t1.meetingStatus IN (2, 4) AND (t2.userId in ( " + allUser + ")))) ");
	if(!userId.equals(selectUser)){
		if("2".equals(selectedType)){
			//部门
			sqlStringBuffer.append(" and ( exists (select 1 from HrmResource where t1.caller = HrmResource.id and HrmResource.departmentid = "+ selectedDept +") ) ");
		} else if("3".equals(selectedType)){
			//分部
			sqlStringBuffer.append(" and ( exists (select 1 from HrmResource where t1.caller = HrmResource.id and HrmResource.subcompanyid1 = "+ selectedSub +") ) ");
		} else {
			//人员
			sqlStringBuffer.append(" and ( exists ( select 1 from Meeting_Member2 where t1.id = Meeting_Member2.meetingid and Meeting_Member2.membertype = 1 and Meeting_Member2.memberid = "+ selectUser +") or t1.caller = "+ selectUser +" or t1.contacter = "+ selectUser +") ");
		}
	}
	 
	//取消的会议不在日历中显示
    sqlStringBuffer.append(" and (t1.cancel <> 1 or t1.cancel is null) ");
	sqlStringBuffer.append(" AND ( (t1.beginDate >= '");
	sqlStringBuffer.append(beginDate);
	sqlStringBuffer.append("' AND t1.beginDate <= '");
	sqlStringBuffer.append(endDate);
	sqlStringBuffer.append("') OR ");
	sqlStringBuffer.append(" (t1.endDate >= '");
	sqlStringBuffer.append(beginDate);
	sqlStringBuffer.append("' AND t1.endDate <= '");
	sqlStringBuffer.append(endDate);
	sqlStringBuffer.append("') OR ");
	sqlStringBuffer.append(" (t1.endDate >= '");
	sqlStringBuffer.append(endDate);
	sqlStringBuffer.append("' AND t1.beginDate <= '");
	sqlStringBuffer.append(beginDate);
	sqlStringBuffer.append("') OR ");
	sqlStringBuffer
			.append(" ((t1.endDate IS null OR t1.endDate = '') AND t1.beginDate <= '");
	sqlStringBuffer.append(beginDate);
	sqlStringBuffer.append("') )");
	
	String btimeStr = "t1.beginDate+' '+t1.begintime ";
	String etimeStr = "t1.endDate+' '+t1.endtime ";
	if ((recordSet.getDBType()).equals("oracle")) {
	 	btimeStr = "t1.beginDate||' '||t1.begintime ";
	 	etimeStr = "t1.endDate||' '||t1.endtime ";
	}
	if("1".equals(meetingType)){
		sqlStringBuffer.append(" AND ("+etimeStr+" < '"+ currenttime + "' ");
		sqlStringBuffer.append(" or t1.isdecision = 2 ) ");
	} else if("2".equals(meetingType)){
		sqlStringBuffer.append(" AND ("+btimeStr+" <= '"+ currenttime + "' ");
		sqlStringBuffer.append("   AND "+etimeStr+" >= '"+ currenttime + "' and t1.isdecision <> 2) ");
	
	} else if("3".equals(meetingType)){
		sqlStringBuffer.append(" AND (("+btimeStr+" > '"+ currenttime + "' and t1.isdecision <> 2) )");
	}
	
	sqlStringBuffer.append(" order by t1.beginDate ,t1.begintime, t1.id ");

	//System.out.println("######" + beginDate); 
	//System.out.println("######" + endDate);
	recordSet.executeSql(sqlStringBuffer.toString());
	//recordSet.writeLog(sqlStringBuffer.toString());
	//System.out.println(sqlStringBuffer.toString());
	Map result = new HashMap();
	List eventslist = new ArrayList();
	SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm");
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	SimpleDateFormat format3 = new SimpleDateFormat("HH:mm");
	int meetingstatus = 0;
	while (recordSet.next()) {
		try {
			boolean isAllDay = false;
			List event = new ArrayList();
			meetingstatus = Util.getIntValue(recordSet.getString("meetingstatus"), 0);
			String isdecision=recordSet.getString("isdecision");
			event.add(recordSet.getString("id"));
			if(meetingstatus == 0)
			{
				event.add("("+SystemEnv.getHtmlLabelName(220, user.getLanguage())+")"+recordSet.getString("name"));
			}else if(meetingstatus==1){
				event.add("("+SystemEnv.getHtmlLabelName(2242, user.getLanguage())+")"+recordSet.getString("name"));
			}else if(meetingstatus==3){
				event.add("("+SystemEnv.getHtmlLabelName(236, user.getLanguage())+")"+recordSet.getString("name"));
			}else {
				event.add(recordSet.getString("name"));
			}
			Date startDate = format2.parse(recordSet.getString(
					"begindate").trim()
					+ " " + recordSet.getString("begintime").trim());
			event.add(format.format(startDate));
			if (format2.parse(beginDate + " 00:00").getTime()
					- startDate.getTime() > 0) {
				beginDate = recordSet.getString("begindate");
			}
			Date endDate2 = null;
			if (!"".equals(recordSet.getString("enddate"))) {
				String endTime = recordSet.getString("endtime");
				if ("".equals(endTime.trim())) {
					endTime = "23:59";
				}
				endDate2 = format2.parse(recordSet
						.getString("enddate")
						+ " " + endTime);
				//if (endDate2.getTime() - startDate.getTime() > 0
						//|| endDate2.getHours() - startDate.getHours() >= 24||endDate2.getYear()-startDate.getYear()>0) {
				if(recordSet.getString("enddate").compareTo(recordSet.getString("begindate")) > 0){
					isAllDay = true;
				} else {

				}

				event.add(format.format(endDate2));
			} else {
				endDate = "01/01/10000";
				event.add("01/01/10000 00:00");
				isAllDay = true;
			}

			event.add("0");
			if (isAllDay) {
				event.add("1");//是不是全天
			} else {
				event.add("0");
			}

			event.add("0");//,0,1,0,-1,1,
			
			if("2".equals(isdecision)){
				event.add("0");
			} else {
				if(startDate.getTime() >  currntCalendar.getTime().getTime()){
					event.add("2");
				} else if(endDate2 != null && currntCalendar.getTime().getTime() <= endDate2.getTime()){
					event.add("1");
				} else {
					event.add("0");
				}
			}
			
			event.add("");
			event.add("0");
			event.add("");
			event.add("");
			eventslist.add(event);
		} catch (Exception e) {
			
		}
	}

	result.put("events", eventslist);
	result.put("issort", ""+true);
	result.put("start", beginDate + " 00:00");
	result.put("end", endDate + " 23:59");
	result.put("error", null);

	JSONObject obj = JSONObject.fromObject(result);
	out.clearBuffer();
	out.print(obj.toString());
%>