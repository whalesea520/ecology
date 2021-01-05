
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@page import="java.util.*"%>
<%@ page import="weaver.general.*" %>
<%@page import="net.sf.json.JSONObject"%><%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="net.sf.json.JsonConfig"%>
<%@page import="java.util.StringTokenizer"%>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<%@page import="weaver.WorkPlan.MutilUserUtil"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<%!
	public String[] getDate(String startDate,String endDate,String planStart,String planEnd){
		String format="yyyy-MM-dd";
		String[] str=new String[2]; 
		if("".equals(planStart)){
			str[0]=startDate;
		}else{
			Date startDate1=TimeUtil.getString2Date(startDate,format);
			Date planStart1=TimeUtil.getString2Date(planStart,format);
			if(startDate1.before(planStart1)){
				str[0]=planStart;
			}else{
				str[0]=startDate;
			}
		}
		if("".equals(planEnd)){
			str[1]=endDate;
		}else{
			Date endDate1=TimeUtil.getString2Date(endDate,format);
			Date planEnd1=TimeUtil.getString2Date(planEnd,format);
			if(endDate1.before(planEnd1)){
				str[1]=endDate;
			}else{
				str[1]=planEnd;
			}
		}
		return str;
	}
	
	public void putEvent(String[] str,Map<String,Set<String>> map,String id){
		String format="yyyy-MM-dd";
		Date sd=TimeUtil.getString2Date(str[0],format);
		Date ed=TimeUtil.getString2Date(str[1],format);
		String tempStr=str[0];
		if(sd.equals(ed)){
			if(map.containsKey(tempStr)){
				map.get(tempStr).add(id);
			}else{
				Set<String> set=new LinkedHashSet <String>();
				set.add(id);
				map.put(tempStr,set);
			}
		}else{
			while(!sd.after(ed)){
				tempStr=TimeUtil.getDateString(sd);
				if(map.containsKey(tempStr)){
					map.get(tempStr).add(id);
				}else{
					Set<String> set=new LinkedHashSet <String>();
					set.add(id);
					map.put(tempStr,set);
				}
				tempStr=TimeUtil.dateAdd(tempStr, 1);
				sd=TimeUtil.getString2Date(tempStr,format);
			}
		}
	}

%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser(request, response);
	if(user == null)  return ;
	
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
	
	String selectUser = Util.null2String(request.getParameter("selectUser")); //被选择用户Id				
	String viewType = "3";//月视图
	String selectDateString = Util.null2String(request.getParameter("selectdate")); //被选择日期

	boolean appendselectUser = false;

	if ("".equals(selectUser) || userId.equals(selectUser)) {
		appendselectUser = true;
		selectUser = userId;
	}
	selectUser = selectUser.replaceAll(",", "");
	
	boolean belongshow=MutilUserUtil.isShowBelongto(user);
	String belongids="";
	if(belongshow){
		belongids=User.getBelongtoidsByUserId(user.getUID());
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

 
	//月计划显示
	selectCalendar.set(Calendar.DATE, 1); //设置为月第一天
	int offsetDayOfWeek = selectCalendar.get(Calendar.DAY_OF_WEEK) - 1;
	offsetDays = Integer.parseInt(selectDayOfMonth) - 1
			+ offsetDayOfWeek;
	selectCalendar.add(Calendar.DAY_OF_WEEK, -1 * offsetDayOfWeek); //设置为月首日那周的第一天
 
	beginYear = Util.add0(selectCalendar.get(Calendar.YEAR), 4); //年 
	beginMonth = Util.add0(selectCalendar.get(Calendar.MONTH) + 1, 2); // 月
	beginDay = Util.add0(selectCalendar.get(Calendar.DAY_OF_MONTH), 2); //日 
	beginDate = beginYear + "-" + beginMonth + "-" + beginDay;
	 
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
			.append("SELECT name,begindate,begintime ,enddate,endtime,workPlan.id,status,type_n, workPlanType.workPlanTypeColor");
	sqlStringBuffer
			.append(" FROM WorkPlan workPlan, WorkPlanType workPlanType");
	//显示所有日程，包含已结束日程
	//sqlStringBuffer.append(" WHERE (workPlan.status = 0 or workPlan.status = 1 or workPlan.status = 2)");
	sqlStringBuffer.append(" WHERE (workPlan.status = 0 ");
	if("1".equals(overAvailable)){
		sqlStringBuffer.append(" or workPlan.status =1 ");
	}
	if("2".equals(archiveAvailable)){
		sqlStringBuffer.append(" or workPlan.status =2 ");
	}
	sqlStringBuffer.append(" ) ");
	//sqlStringBuffer.append(Constants.WorkPlan_Status_Unfinished);
	/** Add By Hqf for TD9970 Start **/
	sqlStringBuffer.append(" AND workPlan.deleted <> 1");
	/** Add By Hqf for TD9970 End **/
	sqlStringBuffer
			.append(" AND workPlan.type_n = workPlanType.workPlanTypeId");
	sqlStringBuffer.append(" AND workPlan.createrType = '" + userType
			+ "'");
	
	sqlStringBuffer.append(" AND (");
	
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
	if(!"".equals(belongids)){
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
	}
	sqlStringBuffer.append(")");
	
	sqlStringBuffer.append(" )");


	sqlStringBuffer.append(" AND ( workPlan.beginDate <= '");
	sqlStringBuffer.append(endDate);
	sqlStringBuffer.append("' AND workPlan.endDate >= '");
	sqlStringBuffer.append(beginDate);
	sqlStringBuffer.append("') ");
	sqlStringBuffer.append(" ) A ) C");
	sqlStringBuffer.append(" LEFT JOIN overworkplan ON overworkplan.id=c.status ");
	//sqlStringBuffer.append(" ORDER BY beginDate asc, beginTime ASC");
	sqlStringBuffer.append(" ORDER BY enddate asc, endtime ASC,beginDate asc, beginTime ASC");
	recordSet.executeSql(sqlStringBuffer.toString());
	//recordSet.writeLog(sqlStringBuffer.toString());
	Map result = new HashMap();
	SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm");
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	SimpleDateFormat format3 = new SimpleDateFormat("HH:mm");
	Map<String,List> dateMap=new HashMap<String,List>();
	String begindate1="";
	String begintime="";
	String enddate1="";
	String showEndDate="";
	String endTime="";
	List event =null;
	Date timeDate=null;
	Map eventMap=new HashMap();
	String id="";
	Map dateResult = new HashMap();
	while (recordSet.next()) {
		try {
			begindate1=recordSet.getString("begindate").trim();
			boolean isAllDay = false;
			if("".equals(begindate1)) continue;
			id=recordSet.getString("id");
			begintime=recordSet.getString("begintime").trim();
			enddate1=recordSet.getString("enddate").trim();
			
			begintime="".equals(begintime)?"00:00":begintime;
			event= new ArrayList();
			event.add(id);
			event.add(recordSet.getString("name"));
			event.add(begindate1);
			event.add(begintime);
			timeDate=TimeUtil.getString2Date(begintime,"HH:mm");
			event.add(timeDate.getHours()<12?"AM":"PM");
			Date startDate = format2.parse(begindate1+ " " + begintime);
			if (format2.parse(beginDate + " 00:00").getTime()
					- startDate.getTime() > 0) {
				beginDate = recordSet.getString("begindate");
			}
			showEndDate=enddate1;
			if (!"".equals(enddate1)) {
				endTime = recordSet.getString("endtime");
				if ("".equals(endTime.trim())) {
					endTime = "23:59";
				}
				Date endDate2 = format2.parse(enddate1+ " " + endTime);
			}else{
				showEndDate="";
				enddate1=begindate1;//;
				endTime = "23:59";
			}
			if(recordSet.getInt("status")==0){
				event.add(recordSet.getString("workPlanTypeColor"));//颜色
			}else{
				event.add(recordSet.getString("workplancolor"));//颜色
			}
			event.add(begindate1+" "+begintime+("".equals(showEndDate)?"":" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+(enddate1+" "+endTime)));
			putEvent(getDate(beginDate,endDate,begindate1,enddate1),dateResult,id);

		} catch (Exception e) {
			
		}
		eventMap.put(id,event);
	}

	result.put("events", eventMap);
	result.put("dateevents", dateResult);
	result.put("start", beginDate + " 00:00");
	result.put("end", endDate + " 23:59");

	JSONObject obj = JSONObject.fromObject(result);
	out.clearBuffer();
	out.print(obj.toString());
%>