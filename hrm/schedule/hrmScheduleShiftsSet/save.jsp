<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="hrmScheduleShiftsSetCtrl" class="weaver.hrm.schedule.controller.HrmScheduleShiftsSetController" scope="page" />
<%out.print(hrmScheduleShiftsSetCtrl.handle(request, response).toString());%>
