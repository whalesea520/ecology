
<%@page import="java.util.Date"%>
<%@page import="weaver.hrm.User"%><%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanExchange" %>
<%@page import="net.sf.json.*"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<%

String method = Util.null2String(request.getParameter("method"));
String showdate = Util.null2String(request.getParameter("showdate"));
String timezone = Util.null2String(request.getParameter("timezone"));
String viewtype = Util.null2String(request.getParameter("viewtype"));

if("list".equals(method)){
	request.getRequestDispatcher("/workplan/calendar/data/CalendarData.jsp").forward(request,response);
} else if("add".equals(method)){
	/*CalendarEndTime	12/22/2011 06:30
		CalendarStartTime	12/22/2011 04:30
		CalendarTitle	22
		IsAllDayEvent	0
		timezone	8
		*/
		
	out.println("{\"IsSuccess\":true,\"Data\":[]}");
}else if("addCalendarItem".equals(method)){
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);
}else if("editCalendarItemQuick".equals(method)){
	SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	SimpleDateFormat formatDate=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat formatTime=new SimpleDateFormat("HH:mm");
	Date CalendarEndTime=format1.parse(request.getParameter("CalendarEndTime"));
	Date CalendarStartTime=format1.parse(request.getParameter("CalendarStartTime"));
	request.setAttribute("startDate",formatDate.format(CalendarStartTime));
	request.setAttribute("startTime",formatTime.format(CalendarStartTime));
	request.setAttribute("endDate",formatDate.format(CalendarEndTime));
	request.setAttribute("endTime",formatTime.format(CalendarEndTime));
	request.setAttribute("id",request.getParameter("calendarId"));
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);
	//out.print("{\"IsSuccess\":true}");
} else if("getNewDisMsg".equals(method)){
	User user = HrmUserVarify.getUser(request, response);
	recordSet.executeSql(" select remindtime from workplan_disremindtime where userid ="+user.getUID()+" and usertype = "+ user.getLogintype());
	String lastDate = "";
	String lasetTime = "";
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String newRemindtime = df.format(new Date());
	if(recordSet.next()){
		String remindtime = recordSet.getString("remindtime");
		recordSet.executeSql(" update workplan_disremindtime set remindtime = '"+newRemindtime+"' where userid ="+user.getUID()+" and usertype = "+ user.getLogintype());
		if(remindtime.length() == 19){
			lastDate = remindtime.substring(0,10);
			lasetTime = remindtime.substring(11);
		}
	} else {
		recordSet.executeSql("insert into workplan_disremindtime values("+user.getUID()+","+user.getLogintype()+",'"+newRemindtime+"')");
	}
	WorkPlanExchange we = new WorkPlanExchange();
	Map result = new HashMap();
	List data = we.getNewWPExchange(user, lastDate,lasetTime);
	if(data != null){
		result.put("count",""+data.size());
		result.put("msgs",data);
	} else {
		result.put("count",'0');
	}
		
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
}
else if("updateQuick".equals(method)){
	/*CalendarEndTime	12/22/2011 06:30
	CalendarStartTime	12/22/2011 04:30
	CalendarTitle	22
	IsAllDayEvent	0
	timezone	8
	*/
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);

} else if("deleteCalendarItem".equals(method)){
	/*
	calendarId	58457
type	0
	*/
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);
} else if ("adddetails".equals(method)){
	/*
	calendarId	58457
type	0
	*/
}else if("deleteCalendarShare".equals(method)){
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);
}else if("getSubordinate".equals(method)){
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);
}else{
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);
}


 %> 