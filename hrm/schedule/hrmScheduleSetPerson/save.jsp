<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="hrmScheduleSetPersonCtrl" class="weaver.hrm.schedule.controller.HrmScheduleSetPersonController" scope="page" />
<%out.print(hrmScheduleSetPersonCtrl.handle(request, response).toString());%>
