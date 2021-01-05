<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="weaver.hrm.schedule.manager.HrmScheduleManager"%>
<jsp:useBean id="hrmScheduleSetCtrl" class="weaver.hrm.schedule.controller.HrmScheduleSetController" scope="page" />
<%out.print(hrmScheduleSetCtrl.handle(request, response).toString());
try{
  HrmScheduleManager.mapIsWorkDay.clear();
  HrmScheduleManager.mapKqSystem.clear();
}catch (Exception e) {
	hrmScheduleSetCtrl.writeLog("hrmScheduleSet/save.jsp清理HrmScheduleManager>>>>mapIsWorkDay异常");
	hrmScheduleSetCtrl.writeLog("hrmScheduleSet/save.jsp清理HrmScheduleManager>>>>mapKqSystem异常"+e.getStackTrace().toString());
}
%>