
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@page import="java.util.Calendar"%><%@page import="net.sf.json.JSONObject"%><%@page import="weaver.hrm.User"%><%@page import="weaver.hrm.HrmUserVarify"%><%@ page import="org.apache.commons.logging.Log"%><%@ page import="org.apache.commons.logging.LogFactory"%><%@page import="weaver.general.Util"%><%@page import="java.util.Map"%><%@page import="java.util.HashMap"%><%@page import="java.util.List"%><%@page import="java.util.ArrayList"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.util.Date"%>
<%@page import="net.sf.json.JsonConfig"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="weaver.general.TimeUtil"%><jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="taskUtil" class="weaver.task.TaskUtil" scope="page"/>
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
	String selectedUser=Util.null2String(request.getParameter("selectUser"));
	
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
	String hasrightview = Util.null2String(request
			.getParameter("hasrightview")); //是否有权限查看	
	String viewType = request.getParameter("viewtype"); //1:日计划显示 2:周计划显示 3:月计划显示
	String selectDateString = Util.null2String(request
			.getParameter("selectdate")); //被选择日期
	String isShare = Util.null2String(request.getParameter("isShare")); //是否是共享    1：共享日程
	String selectUserNames = Util.null2String(request
			.getParameter("selectUserNames")); //查看其他人姓名
	boolean appendselectUser = false;

	viewType = "day".equals(viewType) ? "1"
			: ("week".equals(viewType) ? "2" : "3");

	if ("".equals(selectUser) || userId.equals(selectUser)) {
		appendselectUser = true;
		selectUser = userId;
	}
	selectUser = selectUser.replaceAll(",", "");
	
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

	String sqlatt=taskUtil.getScheduleSql(userId,selectUser,beginDate,endDate); 
	recordSet.execute(sqlatt);
	
	Map result = new HashMap();
	List eventslist = new ArrayList();
	SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm");
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	SimpleDateFormat format3 = new SimpleDateFormat("HH:mm");
	while (recordSet.next()) {
		try {
			boolean isAllDay = true;
			List event = new ArrayList();
			
			String taskid=recordSet.getString("taskid");      //任务id
			String taskname=recordSet.getString("taskname");  //任务名称
			String tasktype=recordSet.getString("tasktype");  //任务类型
			String taskdate=recordSet.getString("taskdate");  //标记日期
			String taskbegindate=recordSet.getString("begindate").trim();  //标记日期
			
			if(taskbegindate.equals(""))
				taskbegindate=taskdate;
			
			event.add(taskid);
			event.add(taskname);
			
			Date startDate = format2.parse(taskbegindate+ " " +"00:00:00");
			event.add(""+format.format(startDate));
			
			if (format2.parse(beginDate + " 00:00").getTime()
					- startDate.getTime() > 0) {
				beginDate = beginDate;
			}
			
			Date endDate2;
			if(tasktype.equals("1")||tasktype.equals("3")||tasktype.equals("9")||tasktype.equals("10"))
			    endDate2 = format2.parse(recordSet.getString("enddate")+ " "+"23:59:59");
			else
				endDate2 = format2.parse(taskbegindate+ " "+"23:59:59");
			
			
			event.add(format.format(endDate2));

			event.add("0");  //是否显示具体时间
			if (isAllDay) {
				event.add("1");//是不是全天
			} else {
				event.add("0");
			}

			event.add("0");//,0,1,0,-1,1,
			
			//String[] colors={"#2952a3","#a32929","#be6d00","#b1440e","#528800","#7a367a","","","#b1365f "};
			//event.add(colors[Integer.parseInt(tasktype)-1]);//颜色
			event.add(tasktype);//颜色
			
			if(tasktype.equals("3")||tasktype.equals("9"))
			   event.add("0");//editable
			else   
			   event.add("1");//editable   
			   
			event.add("");
			event.add("0");
			event.add("");
			event.add(""+tasktype);
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