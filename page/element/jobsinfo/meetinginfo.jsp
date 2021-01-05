

<%@ page language="java" contentType="text/html; charset=utf-8" %>

<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String userid = request.getParameter("userid");

StringBuffer stringBuffer = new StringBuffer();
String CurrentDate=TimeUtil.getCurrentDateString();
String CurrentTime=TimeUtil.getOnlyCurrentTimeString();

stringBuffer.append("SELECT DISTINCT t1.id, t1.name, t1.caller, t1.contacter, t1.address,");
stringBuffer.append(" t1.beginDate, t1.beginTime, t1.endDate, t1.endTime, t1.meetingStatus, t1.customizeAddress,");
stringBuffer.append(" (SELECT status FROM Meeting_View_Status WHERE meetingId = t1.id AND userId = ");
stringBuffer.append(userid); 
stringBuffer.append(") AS status");
stringBuffer.append(" FROM Meeting t1, Meeting_Member2 t2");
stringBuffer.append(" WHERE t1.id = t2.meetingId and t1.isdecision<>2");
stringBuffer.append(" AND (t2.memberId = ");
stringBuffer.append("'"+userid+"'");
stringBuffer.append(" OR t2.othermember = ");
stringBuffer.append("'"+userid+"'");
stringBuffer.append(" OR t1.caller = ");
stringBuffer.append(userid);
stringBuffer.append(" OR t1.contacter = ");
stringBuffer.append("'"+userid+"'");
stringBuffer.append(") AND t1.meetingStatus = 2");
stringBuffer.append(" AND (t1.endDate > '");
stringBuffer.append(CurrentDate);
stringBuffer.append("' OR (t1.endDate = '");
stringBuffer.append(CurrentDate);
stringBuffer.append("' AND t1.endTime > '");
stringBuffer.append(CurrentTime);
stringBuffer.append("'))");
stringBuffer.append(" ORDER BY t1.beginDate DESC, t1.beginTime DESC");
 
RecordSet rs  = new RecordSet();
rs.execute(stringBuffer.toString());
out.clearBuffer();
out.println(rs.getCounts());

%>
