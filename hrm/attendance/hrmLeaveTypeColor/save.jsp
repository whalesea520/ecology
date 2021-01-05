<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="hrmLeaveTypeColorCtrl" class="weaver.hrm.attendance.controller.HrmLeaveTypeColorController" scope="page" />
<%out.print(hrmLeaveTypeColorCtrl.handle(request, response).toString());%>