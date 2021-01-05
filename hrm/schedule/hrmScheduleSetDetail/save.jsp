<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="hrmScheduleSetDetailCtrl" class="weaver.hrm.schedule.controller.HrmScheduleSetDetailController" scope="page" />
<%out.print(hrmScheduleSetDetailCtrl.handle(request, response).toString());%>
