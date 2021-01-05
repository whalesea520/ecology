<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="hrmScheduleWorktimeCtrl" class="weaver.hrm.schedule.controller.HrmScheduleWorktimeController" scope="page" />
<%out.print(hrmScheduleWorktimeCtrl.handle(request, response).toString());%>
