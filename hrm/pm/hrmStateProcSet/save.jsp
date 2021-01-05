<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="hrmStateProcSetCtrl" class="weaver.hrm.pm.controller.HrmStateProcSetController" scope="page" />
<%out.print(hrmStateProcSetCtrl.handle(request, response).toString());%>
