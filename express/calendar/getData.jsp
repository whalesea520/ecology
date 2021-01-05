
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%

String method = Util.null2String(request.getParameter("method"));
String showdate = Util.null2String(request.getParameter("showdate"));
String timezone = Util.null2String(request.getParameter("timezone"));
String viewtype = Util.null2String(request.getParameter("viewtype"));

if("list".equals(method)){
	request.getRequestDispatcher("/express/calendar/CalendarData.jsp").forward(request,response);
} else if("add".equals(method)){
	/*CalendarEndTime	12/22/2011 06:30
		CalendarStartTime	12/22/2011 04:30
		CalendarTitle	22
		IsAllDayEvent	0
		timezone	8
		*/
		
	out.println("{\"IsSuccess\":true,\"Data\":[]}");
}else if("addCalendarItem".equals(method)){
	request.getRequestDispatcher("/express/calendar/WorkPlanViewOperation.jsp").forward(request,response);
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
	request.getRequestDispatcher("/express/calendar/WorkPlanViewOperation.jsp").forward(request,response);
	out.print("{\"IsSuccess\":true}");
}
else if("updateQuick".equals(method)){
	/*CalendarEndTime	12/22/2011 06:30
	CalendarStartTime	12/22/2011 04:30
	CalendarTitle	22
	IsAllDayEvent	0
	timezone	8
	*/
	request.getRequestDispatcher("/express/calendar/WorkPlanViewOperation.jsp").forward(request,response); 

} else if("deleteCalendarItem".equals(method)){
	request.getRequestDispatcher("/express/calendar/WorkPlanViewOperation.jsp").forward(request,response);
} else if ("adddetails".equals(method)){
	/*
	calendarId	58457
type	0
	*/
}else if("deleteCalendarShare".equals(method)){
	request.getRequestDispatcher("/express/calendar/WorkPlanViewOperation.jsp").forward(request,response);
}else if("getSubordinate".equals(method)){
	request.getRequestDispatcher("/express/calendar/WorkPlanViewOperation.jsp").forward(request,response);
}else{
	request.getRequestDispatcher("/express/calendar/WorkPlanViewOperation.jsp").forward(request,response);
}


 %> 