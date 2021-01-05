<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
int checkPointId = Util.getIntValue(request.getParameter("checkPointId"));
String content = Util.toHtml7(request.getParameter("content"));
String adjustDate = TimeUtil.getFormartString(Calendar.getInstance(),"yyyy-MM-dd");
double point_before = Util.getDoubleValue(request.getParameter("point_before"));
double point_after = Util.getDoubleValue(request.getParameter("modifiedPoint"));
String sql = "";

//考核结果
sql = "UPDATE HrmPerformanceCheckPoint SET point6="+point_after+",point7="+point_before+" WHERE id="+checkPointId+"";
rs.executeSql(sql);

//调整记录
sql = "INSERT INTO HrmPerformancePointAdjust (pointId,content,adjustDate,adjustPerson,point_before,point_after) VALUES ("+checkPointId+",'"+content+"','"+adjustDate+"',"+user.getUID()+","+point_before+","+point_after+")";
rs.executeSql(sql);

response.sendRedirect("modifyPoint.jsp?id="+checkPointId+"");
%>