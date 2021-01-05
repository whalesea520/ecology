
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlanReport" %>


<jsp:useBean id="workPlanSearch" class="weaver.WorkPlan.WorkPlanSearch" scope="page" />
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page" />

<HTML>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%   
    Calendar currentCalendar = Calendar.getInstance();
    Calendar calendar = Calendar.getInstance();
    
    String searchBeginDate = "";
    String searchEndDate = "";

    String type = request.getParameter("type");  //1：周统计 2：月统计        
    if ("".equals(type) || null == type)
    {
        type = "1";
    }
    
    String year = request.getParameter("year");    
    if (null == year)
    {
        year = "";
    }
  
    String month = request.getParameter("month");
    if (null == month)
    {
        month = "-1";
    }
  
    String week = request.getParameter("week");
    if (null == week)
    {
        week = "-1";
    }
  
    String planType = request.getParameter("planType");  //计划类型
    if (null == planType)
    {
        planType = "";
    }
  
    String planStatus = request.getParameter("planStatus");  //计划状态
    if (null == planStatus)
    {
        planStatus = "";
    }

    //int pageNum = Util.getIntValue(request.getParameter("pagenum"), 1);
            
    WorkPlanReport workPlanReport = new WorkPlanReport();
                    
    workPlanReport.setVisitUserID(String.valueOf(user.getUID()));
    workPlanReport.setPlanType(planType);
    workPlanReport.setPlanStatus(planStatus);
    workPlanReport.setYear(year);

    if("1".equals(type)) 
    //周报表
    {  
        workPlanReport.setMonth("");
        workPlanReport.setWeek(week);
        
        calendar.set(Calendar.DAY_OF_WEEK, 1);
        searchBeginDate = Util.add0(calendar.get(Calendar.YEAR), 4) + "-" + Util.add0(calendar.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(calendar.get(Calendar.DAY_OF_MONTH), 2);
        
        calendar.add(Calendar.DATE, 6);
        searchEndDate = Util.add0(calendar.get(Calendar.YEAR), 4) + "-" + Util.add0(calendar.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(calendar.get(Calendar.DAY_OF_MONTH), 2);
    }
    
    else if("2".equals(type))
    //月报表
    {
        workPlanReport.setMonth(month);
        workPlanReport.setWeek("");
    
        calendar.set(Calendar.DAY_OF_MONTH, 1);                        
        searchBeginDate = Util.add0(calendar.get(Calendar.YEAR), 4) + "-" + Util.add0(calendar.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(calendar.get(Calendar.DAY_OF_MONTH), 2);
        calendar.add(Calendar.MONTH, 1);
        calendar.add(Calendar.DATE, -1);
        searchEndDate= Util.add0(calendar.get(Calendar.YEAR), 4) + "-" + Util.add0(calendar.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(calendar.get(Calendar.DAY_OF_MONTH), 2);    
    }
            
    workPlanReport.setSearchBeginDate(searchBeginDate);
    workPlanReport.setSearchEndDate(searchEndDate);
    
    workPlanReport = workPlanService.getUserWorkPlan(workPlanReport, 0, Constants.Page_Size);
    
    session.setAttribute("workPlanReport", workPlanReport);
%>   
    
<%
    if("inner".equals(request.getParameter("from")))
    //入口为提交
    {
%> 
        <jsp:forward page = '<%="WorkPlanReportListContent.jsp?type=" + type %>'></jsp:forward>
<%    
    }
    else
    //入口为菜单
    {
%>
        <jsp:forward page = '<%="WorkPlanReportList.jsp?type=" + type%>'></jsp:forward>
<%
    }
%>    

</HEAD>

<BODY>
</BODY>
</HTML>
