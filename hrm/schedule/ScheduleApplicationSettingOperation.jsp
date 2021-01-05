
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.dao.HrmScheduleApplicationRuleDao"%>
<%@page import="weaver.hrm.attendance.domain.ScheduleApplicationRule"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.StringUtil" %>
<%@ page import="weaver.hrm.attendance.domain.HrmScheduleApplication" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrmScheduleApplicationManager" class="weaver.hrm.attendance.manager.HrmScheduleApplicationManager" scope="page" />
<jsp:useBean id="HrmScheduleApplicationRuleManager" class="weaver.hrm.attendance.manager.HrmScheduleApplicationRuleManager" scope="page" />


<%
String action =  request.getParameter("action");

if("save".equals(action)){
	double onedayworkhours = Util.getDoubleValue(request.getParameter("onedayworkhours"),8.0);
	int ScheduleUnit = Util.getIntValue(request.getParameter("ScheduleUnit"),-1);
	int type = Util.getIntValue(request.getParameter("type"),0);//0 表示是请假流程，当前只开发请假流程，所以type都是0
	int id = Util.getIntValue(request.getParameter("id"),0);
	
	HrmScheduleApplication bean = new HrmScheduleApplication();
	bean.setId(StringUtil.parseToLong(""+id));
	bean.setUnit(ScheduleUnit);
	bean.setType(type);
	bean.setOnedayworkhours(onedayworkhours);
	long saveResult = hrmScheduleApplicationManager.save(bean);

   response.sendRedirect("ScheduleApplicationSetting.jsp?error=1");
}else if("addRule".equals(action)){
	String sharetype = Util.null2String(request.getParameter("sharetype"),"");
	String seclevel = Util.null2String(request.getParameter("seclevel"),"");
	String seclevelend = Util.null2String(request.getParameter("seclevelend"),"");
	String reportname = Util.null2String(request.getParameter("reportname"),"");
	List<ScheduleApplicationRule> listSchedules = HrmScheduleApplicationRuleManager.find("[map]sharetype:"+sharetype+";");
	boolean isOk = true;
	for(ScheduleApplicationRule sar : listSchedules){
		int tmpseclevel = StringUtil.parseToInt(sar.getSeclevel(),0);
		int tmpseclevelend = StringUtil.parseToInt(sar.getSeclevelend(),0);
		if(StringUtil.parseToInt(seclevel,0) >= tmpseclevel && StringUtil.parseToInt(seclevel,0) <= tmpseclevelend){
			isOk = false;
			break;
		}
		if(StringUtil.parseToInt(seclevelend,0) >= tmpseclevel && StringUtil.parseToInt(seclevelend,0) <= tmpseclevelend){
			isOk = false;
			break;
		}
	}
	if(isOk){
		ScheduleApplicationRule bean = new ScheduleApplicationRule();
		bean.setSharetype(StringUtil.parseToInt(sharetype));
		bean.setSeclevel(seclevel);
		bean.setSeclevelend(seclevelend);
		bean.setReportname(reportname);
		long saveResult = HrmScheduleApplicationRuleManager.save(bean);
	}
	if(isOk){
		response.sendRedirect("ScheduleApplicationRuleSetting.jsp?isclose=1");
	}else{
		response.sendRedirect("ScheduleApplicationRuleSetting.jsp?msg=1&isdialog=1");
	}
}else if("delete".equals(action)){
	int id = Util.getIntValue(request.getParameter("id"),0);
	HrmScheduleApplicationRuleManager.delete(id);
  	out.print("ok");
}
else{
		response.sendRedirect("ScheduleApplicationSetting.jsp?error=1");
}
%>
