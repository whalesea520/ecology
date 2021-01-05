
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.TimeUtil" %>


<%

String nowtime=TimeUtil.getCurrentTimeString();

String time8=TimeUtil.getCurrentDateString()+" 00:00:00";
//out.print(nowtime);
//out.print(time8);
//out.print("<br>");
long ll=TimeUtil.timeInterval(nowtime,time8);


%>