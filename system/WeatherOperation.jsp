<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String opera=Util.fromScreen(request.getParameter("operation"),user.getLanguage());
int id=Util.getIntValue(request.getParameter("id"),0);
char separator = Util.getSeparator();
String procedurepara="";
String thedate=Util.fromScreen(request.getParameter("thedate"),user.getLanguage());
int picid=Util.getIntValue(request.getParameter("picid"),user.getLanguage());
String thedesc=Util.fromScreen(request.getParameter("thedesc"),user.getLanguage());
String temperature=Util.fromScreen(request.getParameter("temperature"),user.getLanguage());


String holidayname=Util.fromScreen(request.getParameter("holidayname"),user.getLanguage());
if(opera.equals("insert")){
	if(!HrmUserVarify.checkUserRight("WeatherMaintenance:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	procedurepara= thedate + separator + picid + separator + thedesc + separator + temperature;
	RecordSet.executeProc("Weather_Insert",procedurepara);
     	response.sendRedirect("Weather.jsp");
}

if(opera.equals("save")){
	if(!HrmUserVarify.checkUserRight("WeatherMaintenance:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	procedurepara=id+"" + separator + thedate + separator + picid + separator + thedesc + separator + temperature;
out.print("thedate"+thedate);
	RecordSet.executeProc("Weather_Update",procedurepara);
     	response.sendRedirect("Weather.jsp");
}
if(opera.equals("delete")){
	if(!HrmUserVarify.checkUserRight("WeatherMaintenance:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	RecordSet.executeProc("Weather_Delete",""+id);
	RecordSet.next();
	if(RecordSet.getInt(1)==2){ %>
	<%=SystemEnv.getHtmlLabelName(497,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(423,user.getLanguage())%>
	<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%><a href="Weather.jsp"><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></a>
	<%}
	else{
     	response.sendRedirect("Weather.jsp");
     	}
}
%>