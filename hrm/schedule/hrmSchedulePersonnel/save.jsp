<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="hrmSchedulePersonnelCtrl" class="weaver.hrm.schedule.controller.HrmSchedulePersonnelController" scope="page" />
<%out.print(hrmSchedulePersonnelCtrl.handle(request, response).toString());%>
