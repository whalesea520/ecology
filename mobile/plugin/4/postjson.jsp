
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>

<jsp:useBean id="scheduleService" class="weaver.mobile.plugin.ecology.service.ScheduleService" scope="page"/>
<jsp:useBean id="workPlanLogMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page"/>
<%
request.setCharacterEncoding("UTF-8");
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "remote server session time out");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

String module = Util.null2String(fu.getParameter("module"));
String scope = Util.null2String(fu.getParameter("scope"));

String operation = Util.null2String(fu.getParameter("operation"));
String detailid = Util.null2String(fu.getParameter("detailid"));//日程id

String title = Util.null2String(fu.getParameter("title"));//标题
String notes = Util.null2String(fu.getParameter("notes"));//描述
String synScheduleIds = Util.null2String(fu.getParameter("synScheduleIds"));//批量上传用:手机端本地日历appWorkPlanId
String appWorkPlanId = Util.null2String(fu.getParameter("appWorkPlanId"));//手机端新建日程单个传的手机端本地日程id

SimpleDateFormat sourceDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String startdatestr = Util.null2String(fu.getParameter("startdate"));//开始时间 yyyy-MM-dd HH:mm:ss
Date startdate = null;
try {startdate = sourceDate.parse(startdatestr);} catch (Exception e) {}
String enddatestr = Util.null2String(fu.getParameter("enddate"));//开始时间 yyyy-MM-dd HH:mm:ss
Date enddate = null;
try {enddate = sourceDate.parse(enddatestr);} catch (Exception e) {}

String urgentlevel  = Util.null2String(fu.getParameter("urgentlevel"));//紧急程度
String touser = Util.null2String(fu.getParameter("touser"));//接收人
String scheduletype = Util.null2String(fu.getParameter("scheduletype"));//日程类型
String alarmway = Util.null2String(fu.getParameter("alarmway"));//提醒方式(短信...)
String alarmstart = fu.getParameter("alarmstart");//开始前提醒时间(10分钟...)
String alarmend = fu.getParameter("alarmend");//结束前提醒时间(10分钟...)
String isFromSys = Util.null2String(fu.getParameter("isFromSys"));//是否需要同步

Map<String, String> scheduleMap = new HashMap<String, String>();
scheduleMap.put("id", detailid);//日程id
scheduleMap.put("workPlanType", scheduletype);//日程类型
scheduleMap.put("planName", title);//标题
scheduleMap.put("urgentLevel", urgentlevel);//紧急程度(1.[一般]/2.重要/3.紧急)
scheduleMap.put("remindType", alarmway);//提醒类型(1.[不提醒]/2.短信/3.邮件)
if(Util.getIntValue(alarmstart,0) > 0) {
	scheduleMap.put("remindBeforeStart", "1");//是否开始前提醒
	scheduleMap.put("remindTimesBeforeStart", alarmstart);//开始前提醒时间 min
}
if(Util.getIntValue(alarmend,0) > 0) {
	scheduleMap.put("remindBeforeEnd", "1");//是否结束前提醒
	scheduleMap.put("remindTimesBeforeEnd", alarmend);//结束前提醒时间 min
}
scheduleMap.put("memberIDs", touser);//系统参与人(1,2,3...)

SimpleDateFormat targetDate = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat targetTime = new SimpleDateFormat("HH:mm");
if(startdate != null){
	scheduleMap.put("beginDate", targetDate.format(startdate));//开始日期 yyyy-MM-dd
	scheduleMap.put("beginTime", targetTime.format(startdate));//开始时间 HH:mm
} else {
	scheduleMap.put("beginDate", targetDate.format(new Date()));//开始日期 yyyy-MM-dd
	scheduleMap.put("beginTime", targetTime.format(new Date()));//开始时间 HH:mm
}
if(enddate != null){
	scheduleMap.put("endDate", targetDate.format(enddate));//结束日期 yyyy-MM-dd
	scheduleMap.put("endTime", targetTime.format(enddate));//结束时间 HH:mm
}
scheduleMap.put("description", notes);//内容
scheduleMap.put("crmIDs", "");//相关客户
scheduleMap.put("docIDs", "");//相关文档
scheduleMap.put("projectIDs", "");//相关项目
scheduleMap.put("taskIDs", "");//相关项目任务
scheduleMap.put("requestIDs", "");//相关流程
scheduleMap.put("synScheduleIds", synScheduleIds);//OA和emobile的对应关系
scheduleMap.put("appWorkPlanId", appWorkPlanId);//OA和emobile的对应关系
scheduleMap.put("isFromSys", isFromSys);//是否需要同步(接收人/提醒方式/提醒时间/紧急程度/日程类型)

Map result = new HashMap();

if("create".equals(operation)) {
	result = scheduleService.createSchedule(scheduleMap, user);
} else if("edit".equals(operation)) {
	result = scheduleService.editSchedule(scheduleMap, user);
} else if("del".equals(operation)) {
	result = scheduleService.delSchedule(detailid, user);
} else if("over".equals(operation)) {
	result = scheduleService.overSchedule(detailid, user);
} else if("view".equals(operation)) {
	String logParams[] = new String[]
	{detailid, workPlanLogMan.TP_VIEW, String.valueOf(user.getUID()), "mobile" };
	workPlanLogMan.writeViewLog(logParams);
}else if("updateAppWPId".equals(operation)) {
    result = scheduleService.updateAppWPId(synScheduleIds, user);        
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>