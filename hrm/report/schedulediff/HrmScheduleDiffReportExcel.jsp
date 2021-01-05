<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*,java.util.*,weaver.hrm.*" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@page import="weaver.hrm.report.schedulediff.HrmScheduleDiffManager"%>
<%@page import="java.net.URLEncoder"%>
<!-- modified by wcd 2014-07-24 [E7 to E8] -->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="format" class="weaver.hrm.common.SplitPageTagFormat" scope="page"/>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page"/>
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page"/>
<jsp:useBean id="holidayManager" class="weaver.hrm.attendance.manager.HrmPubHolidayManager" scope="page" />
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="monthAttManager" class="weaver.hrm.attendance.manager.HrmScheduleDiffMonthAttManager" scope="page" />
<jsp:useBean id="leaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffOtherManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffOtherManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetSignInManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetSignInManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetSignOutManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetSignOutManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetNoSignManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetNoSignManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetAbsentFromWorkManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetAbsentFromWorkManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetBeLateManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetBeLateManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetLeaveEarlyManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetLeaveEarlyManager" scope="page"/>
<jsp:useBean id="HrmScheduleApplicationRuleManager" class="weaver.hrm.attendance.manager.HrmScheduleApplicationRuleManager" scope="page" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
<!--
td{font-size:12px}
.title{font-weight:bold;font-size:20px}
-->
</style>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	response.setContentType("application/vnd.ms-excel");
	
	Calendar today = Calendar.getInstance ();
	String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
					   + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
					   + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

	String cmd = strUtil.vString(request.getParameter("cmd"));
	String fromDate = strUtil.vString(request.getParameter("fromDate"));
	String toDate = strUtil.vString(request.getParameter("toDate"));
	String tnum = strUtil.vString(request.getParameter("tnum"));
	int subCompanyId = strUtil.parseToInt(request.getParameter("subCompanyId"),0);
	int departmentId = strUtil.parseToInt(request.getParameter("departmentId"),0);
	String resourceId = strUtil.vString(request.getParameter("resourceId"));
	String status = strUtil.vString(request.getParameter("status"));
	String _currentdate = strUtil.vString(request.getParameter("currentdate"));
	String isRule = strUtil.vString(request.getParameter("isRule"));
	String ruleid = strUtil.vString(request.getParameter("ruleid"));
	
	Calendar ____cal = null, ____Fday = null, ____Lday = null;
	if(_currentdate.length() > 0){
		Date CURRENT_DATE = dateUtil.parseToDate(_currentdate);
		____cal = dateUtil.getCalendar(CURRENT_DATE);
		____Fday = dateUtil.getCalendar(dateUtil.getFirstDayOfMonth(CURRENT_DATE));
		____Lday = dateUtil.getCalendar(dateUtil.getLastDayOfMonth(CURRENT_DATE));
		fromDate = dateUtil.getDate(____Fday.getTime());
		toDate = dateUtil.getDate(____Lday.getTime());
	}
	//安全检查  
	//查询的开始日期和结束日期必须有值且长度为10
	if(fromDate==null||fromDate.trim().equals("")||fromDate.length()!=10
	 ||toDate==null||toDate.trim().equals("")||toDate.length()!=10){
		return;
	}
	//非考勤管理员只能看到自己的记录
	if(!HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)){
		resourceId = String.valueOf(user.getUID());
	}
	if(resourceId.length() > 0) {
		if(subCompanyId <= 0) subCompanyId = strUtil.parseToInt(ResourceComInfo.getSubCompanyID(resourceId), 0);
		if(departmentId <= 0) departmentId = strUtil.parseToInt(ResourceComInfo.getDepartmentID(resourceId), 0);
	}
	String tabName = SystemEnv.getHtmlLabelNames(tnum,user.getLanguage());
    if(!ruleid.equals("")){
		ScheduleApplicationRule scheduleApplicationRule = HrmScheduleApplicationRuleManager.get(ruleid);
		tabName = scheduleApplicationRule.getReportname() + tabName;
    }
	
	String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+tabName;
	response.setHeader("Content-disposition","attachment;filename="+new String(fileName.getBytes("GBK"),"iso8859-1")+".xls");
%>
<%
	if(cmd.equals("HrmScheduleDiffReport")){
		List qList = colorManager.find("[map]subcompanyid:0;field002:1;field003:1");
		int qSize = qList == null ? 0 : qList.size();
    List lateRuleList = HrmScheduleApplicationRuleManager.find("[map]sharetype:1");
	int lateRuleSize = lateRuleList == null ? 0 : lateRuleList.size();
	
    List earlyRuleList = HrmScheduleApplicationRuleManager.find("[map]sharetype:2");
	int earlyRuleSize = earlyRuleList == null ? 0 : earlyRuleList.size();
	ScheduleApplicationRule scheduleRule = null;
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
	<COLGROUP>
		<COL width="9%">
		<COL width="9%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<%for(int i=0; i<qSize; i++) out.println("<COL width=\"6%\">");%>
		<%for(int i=0; i<lateRuleSize; i++) out.println("<COL width=\"6%\">");%>
		<%for(int i=0; i<earlyRuleSize; i++) out.println("<COL width=\"6%\">");%>
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
	</COLGROUP>
	<tbody>
		<tr>
			<td colspan="<%=14+qSize+lateRuleSize+earlyRuleSize%>" align="center" ><font size=4><b><%=fileName%></b></font></td>
		</tr>
		<tr>
			<td colspan="<%=14+qSize+lateRuleSize+earlyRuleSize%>" align="right" ></td>
		</tr>
		<tr>
			<td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
			<td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
			<td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
			<td colspan="<%=11+qSize+lateRuleSize+earlyRuleSize%>" align="center"><%=SystemEnv.getHtmlLabelName(20080,user.getLanguage())%></td>
		</tr>
		<tr>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(34082,user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("380,21551,81913,391,81914",user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20081,81913,18929,81914",user.getLanguage())%></td>
			<%if(lateRuleSize > 0){
				for(int i=0; i<lateRuleSize; i++){
				scheduleRule = (ScheduleApplicationRule)lateRuleList.get(i);
				String reportName = scheduleRule.getReportname();
			%>
			<td rowspan=2 align="center"><%=reportName+SystemEnv.getHtmlLabelNames("81913,18929,81914",user.getLanguage())%></td>
			<%
				}
			}%>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20082,81913,18929,81914",user.getLanguage())%></td>
			<%if(earlyRuleSize > 0){
				for(int i=0; i<earlyRuleSize; i++){
				scheduleRule = (ScheduleApplicationRule)earlyRuleList.get(i);
				String reportName = scheduleRule.getReportname();
			%>
			<td rowspan=2 align="center"><%=reportName+SystemEnv.getHtmlLabelNames("81913,18929,81914",user.getLanguage())%></td>
			<%
				}
			}%>
			
			<%if(qSize > 0){%>
			<td colspan="<%=qSize%>" align="center"><%=SystemEnv.getHtmlLabelNames("670,81913,1925,81914",user.getLanguage())%></td> 
			<%}%>
			<td colspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("6151,81913,391,81914",user.getLanguage())%></td> 
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20084,81913,1925,81914",user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("24058,81913,1925,81914",user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20085,81913,18929,81914",user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20085,81913,391,81914",user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20086,81913,18929,81914",user.getLanguage())%></td>
		</tr> 
		<%
			HrmLeaveTypeColor bean = null;
			out.println("<tr>");
			if(qSize > 0){
				for(int i=0; i<qSize; i++){
					String lName = "";
					bean = (HrmLeaveTypeColor)qList.get(i);
					switch(user.getLanguage()){
					case 7:
						lName = bean.getField007();
						break;
					case 8:
						lName = bean.getField008();
						break;
					case 9:
						lName = bean.getField009();
						break;
					}
					out.println("<td align='center'>"+strUtil.vString(lName, bean.getField001())+"</td>");
				}
			}
			out.println("<td align='center'>"+SystemEnv.getHtmlLabelName(125804,user.getLanguage())+"</td>");
			out.println("<td align='center'>"+SystemEnv.getHtmlLabelName(125805,user.getLanguage())+"</td>");
			out.println("</tr>");
			
			HrmScheduleDiffManager diffManager = new HrmScheduleDiffManager();
			List scheduleList = diffManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId,status);
			Map scheduleMap=null;
			for(int i=0; i<scheduleList.size(); i++) {
				scheduleMap = (Map)scheduleList.get(i);
				String absentFromWorkHours = strUtil.vString(scheduleMap.get("absentFromWorkHours"));
				String absentFromWork = strUtil.vString(scheduleMap.get("absentFromWork"));
				String workHours = strUtil.vString(scheduleMap.get("workHours"));
	%>
		<tr>
			<td><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
			<td><%=strUtil.vString(scheduleMap.get("workcode"))%>&nbsp;</td>
			<td><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
			<td align="right"><%=strUtil.vString(scheduleMap.get("workDays"))%></td>
			<td align="right"><%=workHours%></td>
			<td align="right"><%=strUtil.vString(scheduleMap.get("beLate"))%></td>
			<%
				for(int j=0; j<lateRuleSize; j++){
					scheduleRule = (ScheduleApplicationRule)lateRuleList.get(j);
					out.println("<td align='right'>"+strUtil.vString(scheduleMap.get("beLate"+scheduleRule.getId()))+"</td>");
				}
			%>
			<td align="right"><%=strUtil.vString(scheduleMap.get("leaveEarly"))%></td>
			<%
				for(int j=0; j<earlyRuleSize; j++){
					scheduleRule = (ScheduleApplicationRule)earlyRuleList.get(j);
					out.println("<td align='right'>"+strUtil.vString(scheduleMap.get("leaveEarly"+scheduleRule.getId()))+"</td>");
				}
			%>
			<%
				for(int j=0; j<qSize; j++){
					bean = (HrmLeaveTypeColor)qList.get(j);
					out.println("<td align='right'>"+strUtil.vString(scheduleMap.get("leave"+bean.getField004()))+"</td>");
				}
			%>
			<td align="right"><%=strUtil.vString(scheduleMap.get("overTimes0"))%></td>
			<td align="right"><%=strUtil.vString(scheduleMap.get("overTimes1"))%></td>
			<td align="right"><%=strUtil.vString(scheduleMap.get("evection"))%></td>
			<td align="right"><%=strUtil.vString(scheduleMap.get("outDays"))%></td>
			<td align="right"><%=absentFromWork%></td>
			<td align="right"><%=absentFromWorkHours%></td>
			<td align="right"><%=strUtil.vString(scheduleMap.get("noSign"))%></td>
		</tr>
	<%    
		}
	%>
		<tr>
			<td colspan="<%=13+qSize+lateRuleSize+earlyRuleSize%>" align="right" ><%=SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate%></td>
		</tr>
	</tbody>
</table>
<%
	}else if(cmd.equals("HrmScheduleDiffSignInDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="10%">
  <COL width="6%">
  <COL width="8%">
  <COL width="8%">
  <COL width="12%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="13%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="9" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    HrmScheduleDiffDetSignInManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetSignInManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("statusName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signDate"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signTime"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("clientAddress"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("addrDetail"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%
	}else if(cmd.equals("HrmScheduleDiffSignOutDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="10%">
  <COL width="6%">
  <COL width="8%">
  <COL width="8%">
  <COL width="12%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="13%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="9" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20039,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<% 
    String trClass="DataLight";
    HrmScheduleDiffDetSignOutManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetSignOutManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("statusName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signDate"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signTime"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("clientAddress"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("addrDetail"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffBeLateDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="10%">
  <COL width="6%">
  <COL width="8%">
  <COL width="8%">
  <COL width="12%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="13%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="9" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    HrmScheduleDiffDetBeLateManager.setUser(user);
    String dataParam = "fromDate:"+fromDate+";toDate:"+toDate+";subCompanyId:"+subCompanyId+";departmentId:"+departmentId+";resourceId:"+resourceId+";status:"+status+";isRule:"+isRule+";ruleid:"+ruleid;
    Map<String, Comparable> belateMap1 =  HrmScheduleDiffDetBeLateManager.getMapParam(dataParam);
    Map<String, String> belateMap = new HashMap<String, String>();
    for(Map.Entry me : belateMap1.entrySet()){
    	belateMap.put((String)me.getKey(),(String)me.getValue());
    }
    List scheduleList=HrmScheduleDiffDetBeLateManager.getScheduleList(user,belateMap,request,response);
    //List scheduleList=HrmScheduleDiffDetBeLateManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("statusName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signDate"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signTime"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("clientAddress"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("addrDetail"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffLeaveEarlyDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="10%">
  <COL width="6%">
  <COL width="8%">
  <COL width="8%">
  <COL width="12%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="13%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="9" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20039,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    HrmScheduleDiffDetLeaveEarlyManager.setUser(user);
    String dataParam = "fromDate:"+fromDate+";toDate:"+toDate+";subCompanyId:"+subCompanyId+";departmentId:"+departmentId+";resourceId:"+resourceId+";status:"+status+";isRule:"+isRule+";ruleid:"+ruleid;
    Map<String, Comparable> leaveEarlyMap1 =  HrmScheduleDiffDetBeLateManager.getMapParam(dataParam);
    Map<String, String> leaveEarlyMap = new HashMap<String, String>();
    for(Map.Entry me : leaveEarlyMap1.entrySet()){
    	leaveEarlyMap.put((String)me.getKey(),(String)me.getValue());
    }
    List scheduleList=HrmScheduleDiffDetLeaveEarlyManager.getScheduleList(user,leaveEarlyMap,request,response);
    //List scheduleList=HrmScheduleDiffDetLeaveEarlyManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("statusName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signDate"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signTime"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("clientAddress"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("addrDetail"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffAbsentFromWorkDetail")){
%>
	<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="20%">
  <COL width="10%">
  <COL width="10%">
  <COL width="15%">
  <COL width="15%">
  <COL width="15%">
  <COL width="15%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelNames("20085,81913,391,81914",user.getLanguage())%></td>
</tr> 

<%
    String trClass="DataLight";
    HrmScheduleDiffDetAbsentFromWorkManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetAbsentFromWorkManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("statusName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("currentDate"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("ABSENT_realHours"))%></td>
</tr>
<%    
        if(trClass.equals("DataLight")){
	        trClass="DataDark";
        }else{
	        trClass="DataLight";
		}
 } 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffNoSignDetail")){
%>
	<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="20%">
  <COL width="10%">
  <COL width="10%">
  <COL width="15%">
  <COL width="15%">
  <COL width="30%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="6" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
</tr> 
 

<%
    String trClass="DataLight";
    HrmScheduleDiffDetNoSignManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetNoSignManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("statusName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("currentDate"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("scheduleName"))%></td>
</tr>
<%    
        if(trClass.equals("DataLight")){
	        trClass="DataDark";
        }else{
	        trClass="DataLight";
		}
 } 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffLeaveDetail")){
%>
	<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="12%">
  <COL width="6%">
  <COL width="10%">
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="10%">
<tbody>
<tr>
	<td colspan="8" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(828,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,0,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("leaveDays"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("leaveType"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffEvectionDetail")){
%>
	<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="12%">
  <COL width="6%">
  <COL width="10%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="12%">
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20095,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,1,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("days"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%> 
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffOutDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="12%">
  <COL width="6%">
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="12%">
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20096,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,2,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("days"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%> 
</tbody>
</table>
<%
	}else if(cmd.equals("HrmScheduleDiffOtherDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="30%">
  <COL width="6%">
  <COL width="12%">
  <COL width="20%">
  <COL width="20%">
  <COL width="12%">
<tbody>
<tr>
	<td colspan="6" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,4,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("outName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffMonthAttDetail")){
		//当查询条件只是部门的时候，需要重新获取部门对应的分部
		if(departmentId > 0) {
			if(subCompanyId <= 0) subCompanyId = strUtil.parseToInt(DepartmentComInfo.getSubcompanyid1(String.valueOf(departmentId)), 0);
		}
		int __year = ____cal.get(Calendar.YEAR), __month = ____cal.get(Calendar.MONTH), fDay = ____Fday.get(Calendar.DATE), lDay = ____Lday.get(Calendar.DATE);
		boolean isAfter = __month >= strUtil.parseToInt(dateUtil.getMonth(), 0) && __year >= strUtil.parseToInt(dateUtil.getYear(), 0);
%>
	<table id="monthAttData" class="altrowstable" border=1 cellspacing=0 cellpadding=0 style="width:99.7%;margin-left: 0.2%;margin-top: -1px">
		<%out.println("<tr><td align='center' colspan='"+(lDay+2)+"'><font size=4><b>"+fileName+"</b></font></td></tr>");%>
		<tr style="height:2px;background-color: #f7f7f7;">
			<td style="width:3%;text-align:center;"><%=strUtil.addWords(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "<br>")%></td>
			<td style="width:3%;text-align:center;"><%=strUtil.addWords(SystemEnv.getHtmlLabelName(124,user.getLanguage()), "<br>")%></td>
			<%for(int __date=fDay; __date<=lDay; __date++) out.println("<td height=\"20px\" width=\"3%\" ALIGN=CENTER>"+__date+"</td>");%>
		</tr>
		<%
		List hList = holidayManager.find("[map]countryid:1;sql_holidaydate:and t.holidaydate like '"+__year+"%'");
		int hSize = hList == null ? 0 : hList.size();
		HrmPubHoliday hBean = null;
		Calendar tempday = Calendar.getInstance();
		Map colorMap = new HashMap();
		int curDay = 0;
		String bgColor = "", curDate = "";
		for(int __date=fDay; __date<=lDay; __date++){
			tempday.clear();
			tempday.set(__year, __month, __date);
			curDay = tempday.getTime().getDay();
			bgColor = curDay == 0 || curDay == 6 ? "#f7f7f7" : "";
			curDate = dateUtil.getDate(tempday.getTime());
			for(int j=0; j<hSize; j++) {
				hBean = (HrmPubHoliday)hList.get(j);
				if(curDate.equals(hBean.getHolidaydate())){
					switch(hBean.getChangetype()) {
					case 1 :
						bgColor = "RED";
						break ;
					case 2 :
						bgColor = "GREEN";
						break ;
					case 3 :
						bgColor = "MEDIUMBLUE";
						break ;
					}
					break;
				}
			}
			colorMap.put(curDate, bgColor);
		}
		monthAttManager.setUser(user);
		List list = monthAttManager.getMonthReport("fromDate:"+fromDate+";toDate:"+toDate+";subCompanyId:"+subCompanyId+";departmentId:"+departmentId+";resourceId:"+resourceId+";status:"+status);
		int dSize = list == null ? 0 : list.size();
		HrmScheduleDiffMonthAtt bean = null;
		for(int i=0; i<dSize; i++){
			bean = (HrmScheduleDiffMonthAtt)list.get(i);
			out.println("<tr>");
			out.println("<td style=\"border-color:#E6E6E6;text-align:center;\" title=\""+bean.getResourceName()+"\">"+bean.getResourceName()+"</td>");
			out.println("<td style=\"border-color:#E6E6E6;text-align:center;\" title=\""+bean.getDepartmentName()+"\">"+bean.getDepartmentName()+"</td>");
			for(int __date=fDay; __date<=lDay; __date++){
				tempday.clear();
				tempday.set(__year, __month, __date);
				curDate = dateUtil.getDate(tempday.getTime());
		%>
				<td height="20px" align="center" style="background-color:<%=strUtil.vString(colorMap.get(curDate))%>;border-color: #E6E6E6;"><%=isAfter ? "" : bean.getValue(curDate)%></td>
		<%
			}
			out.println("</tr>");
		}
		%>
	</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffMonthAttDateDetail")){
		String curDate = strUtil.vString(request.getParameter("curDate"), fromDate);
		resourceId = strUtil.vString(request.getParameter("resourceId"));
		HrmScheduleDiffUtil.setUser(user);
		monthAttManager.setUser(user);
		subCompanyId = strUtil.parseToInt(ResourceComInfo.getSubCompanyID(resourceId));
		Map timeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(curDate, subCompanyId);
		
		HrmMFScheduleDiff diffBean = new HrmMFScheduleDiff();
		diffBean.setCurrentDate(curDate);
		diffBean.setResourceId(resourceId);
		diffBean.setSubCompanyId(subCompanyId);
		diffBean.setOffDutyTimeAM(strUtil.vString(timeMap.get("offDutyTimeAM")));
		diffBean.setOffDutyTimePM(strUtil.vString(timeMap.get("offDutyTimePM")));
		diffBean.setOnDutyTimeAM(strUtil.vString(timeMap.get("onDutyTimeAM")));
		diffBean.setOnDutyTimePM(strUtil.vString(timeMap.get("onDutyTimePM")));
		diffBean.setSignStartTime(strUtil.vString(timeMap.get("signStartTime")));
		diffBean.setSignType(strUtil.vString(timeMap.get("signType"), "1"));
		diffBean.setFlag(true);
		List sList = monthAttManager.getScheduleList(curDate, resourceId, diffBean, status);
		List fList = monthAttManager.getScheduleList(curDate, curDate, resourceId);
		boolean showFList = fList!=null && fList.size() > 0;
		String[] colWidths = "15%,13%,13%,24%,15%,15%".split(",");
		String[] colNames = "124;413;97;125799;20035;20039".split(";");
		Map map = null;
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
<tbody>
<tr>
	<td align="center" colspan="<%=colWidths.length%>"><font size=4><b><%=fileName%></b></font></td>
</tr>
<%if(showFList){%>
<tr class="header">
	<td align="left" colspan="<%=colWidths.length%>"><%=SystemEnv.getHtmlLabelNames("15880,17463",user.getLanguage())%></td>
</tr>
<%}%>
<tr class="header">
	<%for(int i=0; i<colWidths.length; i++) out.println("<td align='center' width='"+colWidths[i]+"'>"+SystemEnv.getHtmlLabelNames(colNames[i],user.getLanguage())+"</td>");%>
</tr> 
<%
    String trClass="DataLight";
    for(int i=0; i<sList.size(); i++){
		map = (Map)sList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(map.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(map.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(map.get("signDate"))%></td>
  <td align="left"><%=strUtil.vString(map.get("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(map.get("signInTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("signOutTime"))%></td>
</tr>
<%    
	trClass = trClass.equals("DataLight") ? "DataDark" : "DataLight";
	}
%>
</tbody>
</table>
<%if(showFList){%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
<tbody>
<tr class="header">
	<td align="left" colspan="<%=colWidths.length%>"><%=SystemEnv.getHtmlLabelNames("15880,18015",user.getLanguage())%></td>
</tr>
<tr class="header">
	<td align='center' width='20%'><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
	<td align='center' width='12%'><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
	<td align='center' width='15%'><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
	<td align='center' width='15%'><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
	<td align='center' width='12%'><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
	<td align='center' width='14%'><%=SystemEnv.getHtmlLabelName(670,user.getLanguage())+"/"+SystemEnv.getHtmlLabelNames("31345,496",user.getLanguage())%></td>
	<td align='center' width='12%'><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
</tr> 
<%
    trClass="DataLight";
    for(int i=0; i<fList.size(); i++){
		map = (Map)fList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(map.get("requestName"))%></td>
  <td align="left"><%=strUtil.vString(map.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(map.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("status"))%></td>
  <td align="left"><%=strUtil.vString(map.get("days"))%></td>
  <td align="left"><%=strUtil.vString(map.get("dType"))%></td>
</tr>
<%    
	trClass = trClass.equals("DataLight") ? "DataDark" : "DataLight";
	}
%>
</tbody>
</table>
<%		}
	}else if(cmd.equals("HrmScheduleOvertimeWorkDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="30%">
  <COL width="6%">
  <COL width="12%">
  <COL width="20%">
  <COL width="20%">
  <COL width="12%">
<tbody>
<tr>
	<td colspan="6" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,3,false,true,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("outName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("workcode"))%>&nbsp;</td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}
%>