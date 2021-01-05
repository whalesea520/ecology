<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@ page import="weaver.hrm.attendance.manager.*"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement"%>
<%@ page import="weaver.hrm.schedule.manager.HrmScheduleManager"%>
<%@ page import="net.sf.json.JSONObject,weaver.common.StringUtil" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowService" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowServiceImpl" %>
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<%
BaseBean logBean = new BaseBean();
//获取当前
try{
	String action = StringUtil.vString(request.getParameter("action"));
	String _cmd = StringUtil.vString(request.getParameter("cmd"));
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	if("getLeaveDays".equals(action)){
		String fromDate = StringUtil.vString(request.getParameter("fromDate"));
		String fromTime = StringUtil.vString(request.getParameter("fromTime"));
		String toDate = StringUtil.vString(request.getParameter("toDate"));
		String toTime = StringUtil.vString(request.getParameter("toTime"));
		String resourceId = StringUtil.vString(request.getParameter("resourceId"));
		String newLeaveType = StringUtil.vString(request.getParameter("newLeaveType"));
		boolean worktime = Boolean.parseBoolean(StringUtil.vString(request.getParameter("worktime"), "true"));
		WorkflowService wfService = new WorkflowServiceImpl();
		String result = wfService.getLeaveDays(fromDate, fromTime, toDate, toTime, resourceId, worktime,newLeaveType);
		
		Map daymap = new HashMap();
		daymap.put("resourceId", resourceId);
		daymap.put("days", result);
		
		JSONObject jo = JSONObject.fromObject(daymap);
		result = jo.toString();
		out.print(result);
	} else if(_cmd.equals("leaveInfo")) {
		String result = "";
		String allannualValue = "";
		String allpsldaysValue = "";
		String paidLeaveDaysValue = "";
		float realAllannualValue = 0;
		float realAllpsldaysValue = 0;
		float realPaidLeaveDaysValue = 0;
		String currentDate = StringUtil.vString(request.getParameter("currentDate"));
		String resourceId = StringUtil.vString(request.getParameter("resourceId"));
		String bohai = StringUtil.vString(request.getParameter("bohai"));
		int workflowid = StringUtil.parseToInt(request.getParameter("workflowid"));
		int nodetype = StringUtil.parseToInt(request.getParameter("nodetype"));
		HrmAttVacationManager attVacationManager = new HrmAttVacationManager();
		if("getAnnualInfo".equals(action)){
			String userannualinfo = HrmAnnualManagement.getUserAannualInfo(resourceId,currentDate);
			String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
			String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
			String allannual = Util.TokenizerString2(userannualinfo,"#")[2];
			allannualValue = allannual;
			float[] freezeDays = attVacationManager.getFreezeDays(resourceId,currentDate);
			if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];	
			realAllannualValue = strUtil.parseToFloat(allannualValue, 0);
			if(bohai.equals("true")){
					realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
			}else{
				if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
					realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
				}
			}
			result = SystemEnv.getHtmlLabelName(21614,user.getLanguage())+" : "+lastyearannual+"\r\n"+SystemEnv.getHtmlLabelName(21615,user.getLanguage())+" : "+thisyearannual+"\r\n"+SystemEnv.getHtmlLabelName(21616,user.getLanguage())+" : "+allannual;	
		} else if("getPSInfo".equals(action)){
			String leavetype = Util.null2String(request.getParameter("leavetype"));
			String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceId, currentDate,leavetype);
			String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
			String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
			String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
			allpsldaysValue = allpsldays;
	 		float freezeDays = attVacationManager.getPaidFreezeDays(resourceId,leavetype);
		 	if(freezeDays > 0) allpsldays += " - "+freezeDays;
		 	realAllpsldaysValue = strUtil.parseToFloat(allpsldaysValue, 0);
			if(bohai.equals("true")){
					realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezeDays);
			}else{
				if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
					realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezeDays);
				}
			}	
			result = SystemEnv.getHtmlLabelName(131649,user.getLanguage())+" : "+lastyearpsldays+"\r\n"+SystemEnv.getHtmlLabelName(131650,user.getLanguage())+" : "+thisyearpsldays+"\r\n"+SystemEnv.getHtmlLabelName(131651,user.getLanguage())+" : "+allpsldays;
		} else if("getTXInfo".equals(action)){
			HrmPaidLeaveTimeManager paidLeaveTimeManager = new HrmPaidLeaveTimeManager();
			String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(resourceId, currentDate));
			paidLeaveDaysValue = paidLeaveDays;
			float[] freezeDays = attVacationManager.getFreezeDays(resourceId);
			realPaidLeaveDaysValue = strUtil.parseToFloat(paidLeaveDaysValue, 0);
			if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];	
			if(bohai.equals("true")){
					realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
			}else{
				if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
					realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
				}
			}
			result = SystemEnv.getHtmlLabelName(82854,user.getLanguage())+" : "+paidLeaveDays;	
		}
		Map daymap = new HashMap();
		daymap.put("resourceId", resourceId);
		daymap.put("info", result);
		daymap.put("allannualValue", allannualValue);
		daymap.put("realAllannualValue", realAllannualValue);
		daymap.put("allpsldaysValue", allpsldaysValue);
		daymap.put("realAllpsldaysValue", realAllpsldaysValue);
		daymap.put("paidLeaveDaysValue", paidLeaveDaysValue);
		daymap.put("realPaidLeaveDaysValue", realPaidLeaveDaysValue);
		
		JSONObject jo = JSONObject.fromObject(daymap);
		result = jo.toString();
		out.print(result);
	}
}catch(Exception e) {
	logBean.writeLog("", e);
}
%>
