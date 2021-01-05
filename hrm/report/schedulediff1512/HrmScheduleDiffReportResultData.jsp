<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor"%>
<!-- modified by wcd 2014-07-24 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="HrmScheduleDiffManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="leaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
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
	String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+SystemEnv.getHtmlLabelName(20078,user.getLanguage()) ;
    User tempUser = new User();
    String sql="select id,lastname,subcompanyid1,countryid from HrmResource where 1=1 ";    
    if(resourceId.length()>0)
		sql=sql+" and id in ("+resourceId+")";
    if(departmentId>0)
		sql=sql+" and departmentid="+departmentId; 
    if(subCompanyId>0)
		sql=sql+" and subcompanyid1="+subCompanyId; 
    rs.execute(sql);
    if(rs.next()){
		subCompanyId = strUtil.parseToInt(rs.getString("subcompanyid1"), 0);
    	tempUser.setUserSubCompany1(subCompanyId);
    	tempUser.setCurrencyid(rs.getString("countryid"));
		HrmScheduleDiffManager.setUser(tempUser);
    }
	int workingDays = HrmScheduleDiffManager.getTotalWorkingDays(fromDate,toDate);
	
	String _currentDate="";
	String oldDate="";
	boolean hasReachToDate=false;
	boolean isWorkday=true;
	StringBuffer dates = new StringBuffer();
	for(_currentDate=fromDate;!hasReachToDate;){
		if(_currentDate.equals(toDate)) hasReachToDate=true;
		isWorkday=HrmScheduleDiffUtil.getIsWorkday(_currentDate,subCompanyId,"");
		oldDate = _currentDate;
		_currentDate=TimeUtil.dateAdd(_currentDate,1);
		if(!isWorkday) continue;
		dates.append(dates.length() > 0?",":"").append(oldDate);
	}
	List qList = colorManager.find("[map]subcompanyid:0;field002:1;field003:1");
	int qSize = qList == null ? 0 : qList.size();
	HrmLeaveTypeColor bean = null;
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
		<%for(int i=0; i<qSize; i++) out.println("<COL width=\"6%\">");%>
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
	</COLGROUP>
	<tbody>
		<tr>
			<td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
			<td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
			<td colspan="<%=8+qSize%>" align="center"><%=SystemEnv.getHtmlLabelName(20080,user.getLanguage())%></td> 
		</tr>
		<tr>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(34082,user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20082,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
			<%if(qSize > 0){%>
			<td colspan="<%=qSize%>" align="center"><%=SystemEnv.getHtmlLabelName(670,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td> 
			<%}%>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20084,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(24058,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(6151,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20086,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
		</tr> 
		<%
			if(qSize > 0){
				out.println("<tr>");
				String lName = "";
				int lanId = user.getLanguage();
				for(int i=0; i<qSize; i++){
					bean = (HrmLeaveTypeColor)qList.get(i);
					switch(lanId){
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
					out.println("<td align=\"center\">"+strUtil.vString(lName, bean.getField001())+"</td>");
				}
				out.println("</tr>");
			}
		List scheduleList=HrmScheduleDiffManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
		Map scheduleMap=null;

		String departmentName="";
		String resourceName="";
		String beLateA="";
		String beLateB="";
		String leaveEarlyA="";
		String leaveEarlyB="";
		String sickLeave="";
		String privateAffairLeave="";
		String otherLeaveA="";
		String otherLeaveB="";
		String evection="";
		String tempOut="";
		String absentFromWork="";
		String noSign="";
		String remark="";
		String overDays = "";
		double workHours = leaveTimeManager.getWorkHoursBySubCompany(subCompanyId);
		for(int i=0 ; i<scheduleList.size() ; i++ ) {
			scheduleMap=(Map)scheduleList.get(i);
			departmentName=strUtil.vString(scheduleMap.get("departmentName"));
			resourceName=strUtil.vString(scheduleMap.get("resourceName"));
			beLateA=strUtil.vString(scheduleMap.get("beLateA"));
			beLateB=strUtil.vString(scheduleMap.get("beLateB"));
			leaveEarlyA=strUtil.vString(scheduleMap.get("leaveEarlyA"));
			leaveEarlyB=strUtil.vString(scheduleMap.get("leaveEarlyB"));
			sickLeave=strUtil.vString(scheduleMap.get("sickLeave"));
			privateAffairLeave=strUtil.vString(scheduleMap.get("privateAffairLeave"));
			otherLeaveA=strUtil.vString(scheduleMap.get("otherLeaveA"));
			otherLeaveB=strUtil.vString(scheduleMap.get("otherLeaveB"));
			evection=strUtil.vString(scheduleMap.get("evection"));
			tempOut=strUtil.vString(scheduleMap.get("out"));
			absentFromWork=strUtil.vString(scheduleMap.get("absentFromWork"));
			noSign=strUtil.vString(scheduleMap.get("noSign"));
			remark=strUtil.vString(scheduleMap.get("remark"));
			overDays = strUtil.vString(scheduleMap.get("overDays"));
			int lateCount = Tools.parseToInt(beLateA,0)+Tools.parseToInt(beLateB,0);
			int leaveEarlyCount = Tools.parseToInt(leaveEarlyA,0)+Tools.parseToInt(leaveEarlyB,0);
	%>
		<tr>
			<td><%=departmentName%></td>
			<td><%=resourceName%></td>
			<td align="right"><%=workingDays%></td>
			<td align="right"><%=lateCount <= 0 ? "" : lateCount%></td>
			<td align="right"><%=leaveEarlyCount <= 0 ? "" : leaveEarlyCount%></td>
			<%
				for(int j=0; j<qSize; j++){
					bean = (HrmLeaveTypeColor)qList.get(j);
					out.println("<td align=\"right\">"+strUtil.vString(scheduleMap.get("leave"+bean.getField004()))+"</td>");
				}
			%>
			<td align="right"><%=evection%></td>
			<td align="right"><%=strUtil.vString(scheduleMap.get("outDays"))%></td>
			<td align="right"><%=strUtil.isNull(overDays) ? "" : dateUtil.hourToDay(strUtil.parseToDouble(overDays), workHours)%></td>
			<td align="right"><%=absentFromWork%></td>
			<td align="right"><%=noSign%></td>
		</tr>
	<%    
		} 
	%>
	</tbody>
</table>
<table border=0 width="100%">
	<tbody>
		<tr>
			<td align="right" ><%=SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate%></td>
		</tr>
		<tr>
			<td align="center" >
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffSignInDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20241,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20241,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffSignOutDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20242,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20242,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffBeLateDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20088,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20088,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffLeaveEarlyDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20089,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20089,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffAbsentFromWorkDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20090,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20090,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffNoSignDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20091,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20091,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffLeaveDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20092,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20092,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffEvectionDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20093,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20093,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffOutDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(20094,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(20094,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleOvertimeWorkDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelName(33501,user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelName(33501,user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="todo('/hrm/report/tab.jsp?topage=hrmReport&name=HrmScheduleDiffOtherDetail&fromDate=<%=fromDate%>&toDate=<%=toDate%>&validDate=<%=dates.toString()%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>','<%=SystemEnv.getHtmlLabelNames("375,17463",user.getLanguage())%>')" href="#"><%=SystemEnv.getHtmlLabelNames("375,17463",user.getLanguage())%></a>
			</td>
		</tr>
	</tbody>
</table>