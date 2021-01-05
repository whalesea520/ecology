<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="hrmScheduleShiftsDetailCtrl" class="weaver.hrm.schedule.controller.HrmScheduleShiftsDetailController" scope="page" />
<%out.print(hrmScheduleShiftsDetailCtrl.handle(request, response).toString());%>
