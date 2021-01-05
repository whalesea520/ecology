<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.schedule.manager.HrmScheduleManager"%>
<%
	User user = HrmUserVarify.getUser(request, response);
	out.print(new HrmScheduleManager(request, response, user).currentTimeIsWorkTime());
%>