<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.govern.service.GovernChartService" %>
<%@ page import="weaver.govern.service.GovernFieldService" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%

	String action = Util.null2String(request.getParameter("action"));
    System.out.println("=--------------------"+action);
    User user = HrmUserVarify.getUser(request, response);
    GovernChartService taskService = new GovernChartService();
   	GovernFieldService fieldService = new GovernFieldService();
	String returnStr = "";
	if("category".equals(action)){
		returnStr = taskService.getTaskCategory(user);
	}else if("status".equals(action)){
		returnStr = taskService.getTaskStatus(user);
	}else if("flowField".equals(action)){
		returnStr = fieldService.getWorkFlowFiled();
	}else if("modeField".equals(action)){
		returnStr = fieldService.getModeFiled();
	}else if("projectMode".equals(action)){
		returnStr = fieldService.getProjectModeFiled();
	}
	System.out.println(returnStr);
	response.setContentType("application/x-www-form-urlencoded; charset=utf-8");
	response.getWriter().write(returnStr);
	response.getWriter().flush();
	response.getWriter().close();

%>
