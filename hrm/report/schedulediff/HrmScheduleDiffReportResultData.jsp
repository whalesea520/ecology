<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor"%>
<%@page import="weaver.hrm.report.schedulediff.HrmScheduleDiffManager"%>
<%@page import="weaver.hrm.attendance.domain.ScheduleApplicationRule"%>
<!-- modified by wcd 2014-07-24 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="leaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="HrmScheduleApplicationRuleManager" class="weaver.hrm.attendance.manager.HrmScheduleApplicationRuleManager" scope="page" />
<%
	Calendar today = Calendar.getInstance ();
	String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
					   + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
					   + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

	String fromDate = strUtil.vString(request.getParameter("fromDate"));
	String toDate = strUtil.vString(request.getParameter("toDate"));
	int subCompanyId = strUtil.parseToInt(request.getParameter("subCompanyId"),0);
	int departmentId = strUtil.parseToInt(request.getParameter("departmentId"),0);
	String resourceId = strUtil.vString(request.getParameter("resourceId"));
	String status = strUtil.vString(request.getParameter("status"));
	String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+SystemEnv.getHtmlLabelName(20078,user.getLanguage()) ;
    List qList = colorManager.find("[map]subcompanyid:0;field003:1");
	int qSize = qList == null ? 0 : qList.size();
	
    List lateRuleList = HrmScheduleApplicationRuleManager.find("[map]sharetype:1");
	int lateRuleSize = lateRuleList == null ? 0 : lateRuleList.size();
	
    List earlyRuleList = HrmScheduleApplicationRuleManager.find("[map]sharetype:2");
	int earlyRuleSize = earlyRuleList == null ? 0 : earlyRuleList.size();
	ScheduleApplicationRule scheduleRule = null;
%>
<table  border=0 width="100%" >
	<tbody>
		<tr>
			<td align="center" ><font size=4><b><%=fileName%></b></font></td>
		</tr>
		<tr>
			<td align="right" ></td>
		</tr>
	</tbody>
</table>
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
			<td><%=strUtil.vString(scheduleMap.get("workcode"))%></td>
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
	</tbody>
</table>
<%
	String otherParam = "fromDate="+fromDate+"&toDate="+toDate+"&subCompanyId="+diffManager.getSubCompanyId()+"&departmentId="+departmentId+"&resourceId="+resourceId+"&status="+status;
%>
<table border=0 width="100%">
	<tbody>
		<tr>
			<td align="right" ><%=SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate%></td>
		</tr>
		<tr>
			<td align="center" >
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffSignInDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20241,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20241,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffSignOutDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20242,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20242,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffBeLateDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20088,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20088,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<%if(lateRuleSize > 0){
					
					for(int i=0; i<lateRuleSize; i++){
						String lateParams = "";
						scheduleRule = (ScheduleApplicationRule)lateRuleList.get(i);
						String reportName = scheduleRule.getReportname();
						String ruleid = strUtil.vString(scheduleRule.getId());
						lateParams = otherParam + "&isRule=1&ruleid="+ruleid;
				%>
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffBeLateDetail&<%=lateParams%>','<%=reportName+SystemEnv.getHtmlLabelName(17463,user.getLanguage())%>')" href="#"><%=reportName+SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<%
					}
				}
				%>
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffLeaveEarlyDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20089,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20089,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				
				<%if(earlyRuleSize > 0){
					for(int i=0; i<earlyRuleSize; i++){
						String earlyParams = "";
						scheduleRule = (ScheduleApplicationRule)earlyRuleList.get(i);
						String reportName = scheduleRule.getReportname();
						String ruleid = strUtil.vString(scheduleRule.getId());
						earlyParams = otherParam + "&isRule=1&ruleid="+ruleid;
				%>
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffLeaveEarlyDetail&<%=earlyParams%>','<%=reportName+SystemEnv.getHtmlLabelName(17463,user.getLanguage())%>')" href="#"><%=reportName+SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<%
					}
				}
				%>
				
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffAbsentFromWorkDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20090,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20090,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffNoSignDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20091,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20091,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffLeaveDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20092,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20092,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffEvectionDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20093,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20093,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffOutDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(20094,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20094,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleOvertimeWorkDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelName(33501,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(33501,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffOtherDetail&<%=otherParam%>','<%=SystemEnv.getHtmlLabelNames("127655,17463",user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelNames("127655,17463",user.getLanguage())%></a>
			</td>
		</tr>
	</tbody>
</table>