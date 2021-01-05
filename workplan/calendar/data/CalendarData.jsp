
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@page import="java.util.Calendar"%><%@page import="net.sf.json.JSONObject"%><%@page import="weaver.hrm.User"%><%@page import="weaver.hrm.HrmUserVarify"%><%@ page import="org.apache.commons.logging.Log"%><%@ page import="org.apache.commons.logging.LogFactory"%><%@page import="weaver.general.Util"%><%@page import="java.util.Map"%><%@page import="java.util.HashMap"%><%@page import="java.util.List"%><%@page import="java.util.ArrayList"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.util.Date"%>
<%@page import="net.sf.json.JsonConfig"%>
<%@page import="java.util.StringTokenizer"%>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<%@page import="weaver.WorkPlan.MutilUserUtil"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkPlanSetInfo" class="weaver.WorkPlan.WorkPlanSetInfo" scope="page"/>
<%
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
	String sql=WorkPlanShareUtil.getShareSql(user);

	String selectUser = Util.null2String(request
			.getParameter("selectUser")); //被选择用户Id				
	String hasrightview = Util.null2String(request
			.getParameter("hasrightview")); //是否有权限查看	
	String viewType = request.getParameter("viewtype"); //1:日计划显示 2:周计划显示 3:月计划显示
	String selectDateString = Util.null2String(request
			.getParameter("selectdate")); //被选择日期
	String isShare = Util.null2String(request.getParameter("isShare")); //是否是共享    1：共享日程
	String selectUserNames = Util.null2String(request
			.getParameter("selectUserNames")); //查看其他人姓名
	String workPlanType = Util.null2String(request
			.getParameter("workPlanType")); //被选择用户Id	
	boolean appendselectUser = false;

	viewType = "day".equals(viewType) ? "1"
			: ("week".equals(viewType) ? "2" : "3");

	if ("".equals(selectUser) || userId.equals(selectUser)) {
		appendselectUser = true;
		selectUser = userId;
	}
	
	boolean belongshow=MutilUserUtil.isShowBelongto(user);
	String belongids="";
	if(belongshow){
		belongids=User.getBelongtoidsByUserId(user.getUID());
	}
	
	selectUser = selectUser.replaceAll(",", "");
	if (!"1".equals(isShare) && !"".equals(selectUser)
			&& !userId.equals(selectUser)) {
		boolean hasright = false;
		String tempsql = "select a.managerstr "
				+ "	  from hrmresource a "
				+ "	  where (a.managerstr = '" + userId
				+ "' or a.managerstr like '" + userId + ",%' or "
				+ "	        a.managerstr like '%," + userId
				+ ",%' or a.managerstr like '%," + userId + "') "
				+ "	        and a.id=" + selectUser;
		recordSet.executeSql(tempsql);
		if (recordSet.next()) {
			String tmanagerstr = recordSet.getString(1);
			if (!"".equals(tmanagerstr)) {
				hasright = true;
			}
		}
		if (!hasright) {
			out.clearBuffer();

		}
	}
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
		//日计划显示
		offsetDays = 0;
		break;
	case 2:
		//周计划显示
		offsetDays = Integer.parseInt(selectDayOfWeek) - 1;
		selectCalendar.add(Calendar.DAY_OF_WEEK, -1
				* Integer.parseInt(selectDayOfWeek) + 1);
		break;
	case 3:
		//月计划显示
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

	String overColor = "";
	String archiveColor = "";
	String archiveAvailable = "0";
	String overAvailable = "0";
	String oversql = "select * from overworkplan order by workplanname desc";
	recordSet.executeSql(oversql);
	while (recordSet.next()) {
		String id = recordSet.getString("id");
		String workplanname = recordSet.getString("workplanname");
		String workplancolor = recordSet.getString("workplancolor");
		String wavailable = recordSet.getString("wavailable");
		if ("1".equals(id)) {
			overColor = workplancolor;
			if ("1".equals(wavailable))
				overAvailable = "1";
		} else {
			archiveColor = workplancolor;
			if ("1".equals(wavailable))
				archiveAvailable = "2";
		}
	}
	if ("".equals(overColor)) {
		overColor = "#c3c3c2";
	}
	if ("".equals(archiveColor)) {
		archiveColor = "#937a47";
	}
	//String temptable = WorkPlanShareBase.getTempTable(userId);
	StringBuffer sqlStringBuffer = new StringBuffer();

	sqlStringBuffer
			.append("SELECT C.*,overworkplan.workplancolor FROM (SELECT * FROM ");
	sqlStringBuffer.append("(");
	sqlStringBuffer
			.append("SELECT workPlan.*, workPlanType.workPlanTypeColor");
	sqlStringBuffer
			.append(" FROM WorkPlan workPlan, WorkPlanType workPlanType");
	//显示所有日程，包含已结束日程
	//sqlStringBuffer.append(" WHERE (workPlan.status = 0 or workPlan.status = 1 or workPlan.status = 2)");
	sqlStringBuffer.append(" WHERE (workPlan.status = 0 ");
	if("1".equals(overAvailable)){
		sqlStringBuffer.append(" or workPlan.status = 1 ");
	}
	if("2".equals(archiveAvailable)){
		sqlStringBuffer.append(" or workPlan.status = 2 ");
	}
	sqlStringBuffer.append(" ) ");		
	//sqlStringBuffer.append(Constants.WorkPlan_Status_Unfinished);
	/** Add By Hqf for TD9970 Start **/
	sqlStringBuffer.append(" AND workPlan.deleted <> 1");
	if(!"".equals(workPlanType)){
		sqlStringBuffer.append(" AND workPlan.type_n = '"+workPlanType+"'");		
	}
	/** Add By Hqf for TD9970 End **/
	sqlStringBuffer
			.append(" AND workPlan.type_n = workPlanType.workPlanTypeId");
	sqlStringBuffer.append(" AND workPlan.createrType = '" + userType
			+ "'");

	////////////////////////////////////////////
	if (!"1".equals(isShare)) {
		sqlStringBuffer.append(" AND (");
		if(appendselectUser&&!"".equals(belongids)){//自己
			sqlStringBuffer.append("(");
				if (recordSet.getDBType().equals("oracle")) {
					sqlStringBuffer
							.append(" ','||workPlan.resourceID||',' LIKE '%,"
									+ selectUser + ",%'");
				} else {
					sqlStringBuffer
							.append(" ','+workPlan.resourceID+',' LIKE '%,"
									+ selectUser + ",%'");
				}
		
				StringTokenizer idsst = new StringTokenizer(belongids, ",");
				while (idsst.hasMoreTokens()) {
					String id = idsst.nextToken();
					if (recordSet.getDBType().equals("oracle")) {
						sqlStringBuffer
								.append(" OR ','||workPlan.resourceID||',' LIKE '%,"
										+ id + ",%'");
					} else {
						sqlStringBuffer
								.append(" OR ','+workPlan.resourceID+',' LIKE '%,"
										+ id + ",%'");
					}
				}
				sqlStringBuffer.append(")");
			
		}else{
			if (recordSet.getDBType().equals("oracle")) {
			sqlStringBuffer
				.append("  ','||workPlan.resourceID||',' LIKE '%,"
						+ selectUser + ",%'");
			}else{
				sqlStringBuffer
				.append("  ','+workPlan.resourceID+',' LIKE '%,"
						+ selectUser + ",%'");
			}
		}
		 
		/*
		sqlStringBuffer.append(" workPlan.resourceID = '");
		sqlStringBuffer.append(selectUser);
		sqlStringBuffer.append("'");
		sqlStringBuffer.append(" OR workPlan.resourceID LIKE '"
				+ selectUser + ",%'");
		sqlStringBuffer.append(" OR workPlan.resourceID LIKE '%,"
				+ selectUser + ",%'");
		sqlStringBuffer.append(" OR workPlan.resourceID LIKE '%,"
				+ selectUser + "'");
		*/
		sqlStringBuffer.append(" )");
	} else {
		if (!appendselectUser) {
			sqlStringBuffer.append(" AND (");
			StringTokenizer namesst = new StringTokenizer(
					selectUserNames, ",");
			StringTokenizer idsst = new StringTokenizer(selectUser, ",");
			sqlStringBuffer.append(" workPlan.resourceID = '");
			sqlStringBuffer.append(selectUser);
			sqlStringBuffer.append("'");
			while (idsst.hasMoreTokens()) {
				String id = idsst.nextToken();
				if (recordSet.getDBType().equals("oracle")) {
					sqlStringBuffer
							.append(" OR ','||workPlan.resourceID||',' LIKE '%,"
									+ id + ",%'");
				} else {
					sqlStringBuffer
							.append(" OR ','+workPlan.resourceID+',' LIKE '%,"
									+ id + ",%'");
				}
			}
			sqlStringBuffer.append(")");
		}

	}
	sqlStringBuffer.append(" AND (  workPlan.beginDate <= '");
	sqlStringBuffer.append(endDate);
	sqlStringBuffer.append("' and ");
	sqlStringBuffer.append(" workPlan.endDate >= '");
	sqlStringBuffer.append(beginDate);
	sqlStringBuffer.append("' )");
	sqlStringBuffer.append(" ) A");
	sqlStringBuffer.append(" JOIN");
	sqlStringBuffer.append(" (");
	sqlStringBuffer.append(sql);
	sqlStringBuffer.append(" ) B");
	sqlStringBuffer.append(" ON A.id = B.workId) C");
	//sqlStringBuffer.append(" LEFT JOIN WorkPlanExchange");
	//sqlStringBuffer
	//		.append(" ON C.id = WorkPlanExchange.workPlanId AND WorkPlanExchange.memberId = ");
	//sqlStringBuffer.append(userId);
	sqlStringBuffer.append(" LEFT JOIN overworkplan ON overworkplan.id=c.status ");
	sqlStringBuffer.append(" WHERE shareLevel >= 1");

	sqlStringBuffer.append(" ORDER BY beginDate asc, beginTime ASC");

	//System.out.println("######" + beginDate); 
	//System.out.println("######" + endDate);
	recordSet.executeSql(sqlStringBuffer.toString());
	//System.out.println(sqlStringBuffer.toString());
	Map result = new HashMap();
	List eventslist = new ArrayList();
	SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm");
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	SimpleDateFormat format3 = new SimpleDateFormat("HH:mm");
	
	int timeRangeStart=WorkPlanSetInfo.getTimeRangeStart();
	int timeRangeEnd=WorkPlanSetInfo.getTimeRangeEnd();
	String sTime=(timeRangeStart<10?"0"+timeRangeStart:timeRangeStart)+":00";
	String eTime=(timeRangeEnd<10?"0"+timeRangeEnd:timeRangeEnd)+":59";
	
	while (recordSet.next()) {
		try {
			boolean isAllDay = false;
			List event = new ArrayList();
			event.add(recordSet.getString("id"));
			event.add(recordSet.getString("name"));
			Date startDate = format2.parse(recordSet.getString(
					"begindate").trim()
					+ " " + ("".equals(recordSet.getString("begintime").trim())?sTime:recordSet.getString("begintime").trim()));
			event.add(format.format(startDate));
			if (format2.parse(beginDate + " 00:00").getTime()
					- startDate.getTime() > 0) {
				//beginDate = recordSet.getString("begindate");
			}
			if (!"".equals(recordSet.getString("enddate"))) {
				String endTime = recordSet.getString("endtime");
				if ("".equals(endTime.trim())) {
					endTime = eTime;
				}
				Date endDate2 = format2.parse(recordSet
						.getString("enddate")
						+ " " + endTime);
				//if (endDate2.getTime() - startDate.getTime() > 0
						//|| endDate2.getHours() - startDate.getHours() >= 24||endDate2.getYear()-startDate.getYear()>0) {
				//if(Util.dayDiff(format2.format(startDate),format2.format(endDate2))>1){
				if(recordSet.getString("enddate").compareTo(recordSet.getString("begindate")) > 0){
					isAllDay = true;
				} else {

				}
				if(endDate2.getTime() - startDate.getTime() < 0){
					endDate2 = startDate;
				}
				event.add(format.format(endDate2));
			} else {
				//endDate = "01/01/10000";
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
			if(recordSet.getInt("status")==0){
				event.add(recordSet.getString("workPlanTypeColor"));//颜色
			}else{
				event.add(recordSet.getString("workplancolor"));//颜色
			}
			if (recordSet.getInt("shareLevel")>1 && recordSet.getInt("status")==0) {
				event.add("1");//editable
			} else {
				event.add("0");//editable
			}
			event.add("");
			event.add("0");
			event.add("");
			eventslist.add(event);
		} catch (Exception e) {
			e.printStackTrace();
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