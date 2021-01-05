<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*,java.util.*,weaver.hrm.*" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<!-- modified by wcd 2014-07-24 [E7 to E8] -->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="format" class="weaver.hrm.common.SplitPageTagFormat" scope="page"/>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page"/>
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page"/>
<jsp:useBean id="holidayManager" class="weaver.hrm.attendance.manager.HrmPubHolidayManager" scope="page" />
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="HrmScheduleDiffManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffManager" scope="page"/>
<jsp:useBean id="monthAttManager" class="weaver.hrm.attendance.manager.HrmScheduleDiffMonthAtt1512Manager" scope="page" />
<jsp:useBean id="leaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffOtherManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffOtherManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetSignInManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffDetSignInManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetSignOutManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffDetSignOutManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetNoSignManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffDetNoSignManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetAbsentFromWorkManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffDetAbsentFromWorkManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetBeLateManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffDetBeLateManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetLeaveEarlyManager" class="weaver.hrm.report.schedulediff1512.HrmScheduleDiffDetLeaveEarlyManager" scope="page"/>
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
	String validDate = strUtil.vString(request.getParameter("validDate"));
	if(validDate.length()>0){
		String[] arrayValidDate = validDate.split(",");
		validDate = "";
		for(String _dt : arrayValidDate){
			validDate +=(validDate.length()>0?",":"")+"'"+_dt+"'";
		}
	}
	String tnum = strUtil.vString(request.getParameter("tnum"));
	int subCompanyId = strUtil.parseToInt(request.getParameter("subCompanyId"),0);
	int departmentId = strUtil.parseToInt(request.getParameter("departmentId"),0);
	String resourceId = strUtil.vString(request.getParameter("resourceId"));
	String _currentdate = strUtil.vString(request.getParameter("currentdate"));
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
	String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+SystemEnv.getHtmlLabelNames(tnum,user.getLanguage()) ;
	response.setHeader("Content-disposition","attachment;filename="+new String(fileName.getBytes("GBK"),"iso8859-1")+".xls");
%>
<%
	if(cmd.equals("HrmScheduleDiffReport")){
		User tempUser=new User();
		String sql="select id,lastname,subcompanyid1,countryid from HrmResource where 1=1 ";    
		if(resourceId.length()>0)
			sql=sql+" and id in ("+resourceId+")";
		if(departmentId>0)
			sql=sql+" and departmentid="+departmentId; 
		if(subCompanyId>0)
			sql=sql+" and subcompanyid1="+subCompanyId; 
		RecordSet.execute(sql);
		Map rWorkDays = new HashMap();
		while(RecordSet.next()){
			subCompanyId = Util.getIntValue(RecordSet.getString("subcompanyid1"));
			tempUser.setUserSubCompany1(subCompanyId);
			tempUser.setCurrencyid(RecordSet.getString("countryid"));
			HrmScheduleDiffManager.setUser(tempUser);
			
			rWorkDays.put("r"+RecordSet.getString("id"), String.valueOf(HrmScheduleDiffManager.getTotalWorkingDays(fromDate,toDate)));
		}
		List qList = colorManager.find("[map]subcompanyid:0;field002:1;field003:1");
		int qSize = qList == null ? 0 : qList.size();
		HrmLeaveTypeColor bean = null;
%>
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
			<td colspan="<%=10+qSize%>" align="center" ><font size=4><b><%=fileName%></b></font></td>
		</tr>
		<tr>
			<td colspan="<%=10+qSize%>" align="right" ></td>
		</tr>
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
			departmentName=strUtil.vString((String)scheduleMap.get("departmentName"));
			resourceName=strUtil.vString((String)scheduleMap.get("resourceName"));
			beLateA=strUtil.vString((String)scheduleMap.get("beLateA"));
			beLateB=strUtil.vString((String)scheduleMap.get("beLateB"));
			leaveEarlyA=strUtil.vString((String)scheduleMap.get("leaveEarlyA"));
			leaveEarlyB=strUtil.vString((String)scheduleMap.get("leaveEarlyB"));
			sickLeave=strUtil.vString((String)scheduleMap.get("sickLeave"));
			privateAffairLeave=strUtil.vString((String)scheduleMap.get("privateAffairLeave"));
			otherLeaveA=strUtil.vString((String)scheduleMap.get("otherLeaveA"));
			otherLeaveB=strUtil.vString((String)scheduleMap.get("otherLeaveB"));
			evection=strUtil.vString((String)scheduleMap.get("evection"));
			tempOut=strUtil.vString((String)scheduleMap.get("out"));
			absentFromWork=strUtil.vString((String)scheduleMap.get("absentFromWork"));
			noSign=strUtil.vString((String)scheduleMap.get("noSign"));
			remark=strUtil.vString((String)scheduleMap.get("remark"));
			overDays = strUtil.vString(scheduleMap.get("overDays"));
			int lateCount = Tools.parseToInt(beLateA,0)+Tools.parseToInt(beLateB,0);
			int leaveEarlyCount = Tools.parseToInt(leaveEarlyA,0)+Tools.parseToInt(leaveEarlyB,0);
	%>
		<tr>
			<td align="center"><%=departmentName%></td>
			<td align="center"><%=resourceName%></td>
			<td align="right"><%=strUtil.vString(rWorkDays.get("r"+strUtil.vString(scheduleMap.get("resourceId"))))%></td>
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
		<tr>
			<td colspan="<%=10+qSize%>" align="right" ><%=SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate%></td>
		</tr>
	</tbody>
</table>
<%
	}else if(cmd.equals("HrmScheduleDiffSignInDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="20%">
  <COL width="10%">
  <COL width="8%">
  <COL width="12%">
  <COL width="10%">
  <COL width="15%">
  <COL width="25%">
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%  
	String tempDepartmentName="";
	String tempResourceName="";
	String tempStatusName="";
	String tempCurrentDate="";
	String tempCurrentTime="";	
	String tempCurrentIp="";
	String tempCurrentAddr="";

    String trClass="DataLight";

    HrmScheduleDiffDetSignInManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetSignInManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		tempDepartmentName=strUtil.vString((String)scheduleMap.get("departmentName"));
		tempResourceName=strUtil.vString((String)scheduleMap.get("resourceName"));
		tempStatusName=strUtil.vString((String)scheduleMap.get("statusName"));
		tempCurrentDate=strUtil.vString((String)scheduleMap.get("signDate"));
		tempCurrentTime=strUtil.vString((String)scheduleMap.get("signTime"));
		tempCurrentIp=strUtil.vString((String)scheduleMap.get("clientAddress"));
		tempCurrentAddr=strUtil.vString((String)scheduleMap.get("addrDetail"));
%>
<tr class="<%=trClass%>">
  <td align="left"><%=tempDepartmentName%></td>
  <td align="left"><%=tempResourceName%></td>
  <td align="left"><%=tempStatusName%></td>
  <td align="left"><%=tempCurrentDate%></td>
  <td align="left"><%=tempCurrentTime%></td>
  <td align="left"><%=tempCurrentIp%></td>
  <td align="left"><%=tempCurrentAddr%></td>
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
  <COL width="20%">
  <COL width="10%">
  <COL width="8%">
  <COL width="12%">
  <COL width="10%">
  <COL width="15%">
  <COL width="25%">
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(20039,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%  
	String tempDepartmentName="";
	String tempResourceName="";
	String tempStatusName="";
	String tempCurrentDate="";
	String tempCurrentTime="";	
	String tempCurrentIp="";
	String tempCurrentAddr="";

    String trClass="DataLight";

    HrmScheduleDiffDetSignOutManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetSignOutManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		tempDepartmentName=strUtil.vString((String)scheduleMap.get("departmentName"));
		tempResourceName=strUtil.vString((String)scheduleMap.get("resourceName"));
		tempStatusName=strUtil.vString((String)scheduleMap.get("statusName"));
		tempCurrentDate=strUtil.vString((String)scheduleMap.get("signDate"));
		tempCurrentTime=strUtil.vString((String)scheduleMap.get("signTime"));
		tempCurrentIp=strUtil.vString((String)scheduleMap.get("clientAddress"));
		tempCurrentAddr=strUtil.vString((String)scheduleMap.get("addrDetail"));
%>
<tr class="<%=trClass%>">
  <td align="left"><%=tempDepartmentName%></td>
  <td align="left"><%=tempResourceName%></td>
  <td align="left"><%=tempStatusName%></td>
  <td align="left"><%=tempCurrentDate%></td>
  <td align="left"><%=tempCurrentTime%></td>
  <td align="left"><%=tempCurrentIp%></td>
  <td align="left"><%=tempCurrentAddr%></td>
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
  <COL width="20%">
  <COL width="10%">
  <COL width="8%">
  <COL width="12%">
  <COL width="10%">
  <COL width="15%">
  <COL width="25%">
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%  
	String tempDepartmentName="";
	String tempResourceName="";
	String tempStatusName="";
	String tempCurrentDate="";
	String tempCurrentTime="";	
	String tempCurrentIp="";
	String tempCurrentAddr="";

    String trClass="DataLight";

    HrmScheduleDiffDetBeLateManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetBeLateManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		tempDepartmentName=strUtil.vString((String)scheduleMap.get("departmentName"));
		tempResourceName=strUtil.vString((String)scheduleMap.get("resourceName"));
		tempStatusName=strUtil.vString((String)scheduleMap.get("statusName"));
		tempCurrentDate=strUtil.vString((String)scheduleMap.get("signDate"));
		tempCurrentTime=strUtil.vString((String)scheduleMap.get("signTime"));
		tempCurrentIp=strUtil.vString((String)scheduleMap.get("clientAddress"));
		tempCurrentAddr=strUtil.vString((String)scheduleMap.get("addrDetail"));
%>
<tr class="<%=trClass%>">
  <td align="left"><%=tempDepartmentName%></td>
  <td align="left"><%=tempResourceName%></td>
  <td align="left"><%=tempStatusName%></td>
  <td align="left"><%=tempCurrentDate%></td>
  <td align="left"><%=tempCurrentTime%></td>
  <td align="left"><%=tempCurrentIp%></td>
  <td align="left"><%=tempCurrentAddr%></td>
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
  <COL width="20%">
  <COL width="10%">
  <COL width="8%">
  <COL width="12%">
  <COL width="10%">
  <COL width="15%">
  <COL width="25%">
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(20039,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%  
	String tempDepartmentName="";
	String tempResourceName="";
	String tempStatusName="";
	String tempCurrentDate="";
	String tempCurrentTime="";	
	String tempCurrentIp="";
	String tempCurrentAddr="";

    String trClass="DataLight";

    HrmScheduleDiffDetLeaveEarlyManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetLeaveEarlyManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		tempDepartmentName=strUtil.vString((String)scheduleMap.get("departmentName"));
		tempResourceName=strUtil.vString((String)scheduleMap.get("resourceName"));
		tempStatusName=strUtil.vString((String)scheduleMap.get("statusName"));
		tempCurrentDate=strUtil.vString((String)scheduleMap.get("signDate"));
		tempCurrentTime=strUtil.vString((String)scheduleMap.get("signTime"));
		tempCurrentIp=strUtil.vString((String)scheduleMap.get("clientAddress"));
		tempCurrentAddr=strUtil.vString((String)scheduleMap.get("addrDetail"));
%>
<tr class="<%=trClass%>">
  <td align="left"><%=tempDepartmentName%></td>
  <td align="left"><%=tempResourceName%></td>
  <td align="left"><%=tempStatusName%></td>
  <td align="left"><%=tempCurrentDate%></td>
  <td align="left"><%=tempCurrentTime%></td>
  <td align="left"><%=tempCurrentIp%></td>
  <td align="left"><%=tempCurrentAddr%></td>
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
  <COL width="30%">
  <COL width="25%">
  <COL width="20%">
  <COL width="25%">
<tbody>
<tr>
	<td colspan="4" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
</tr> 
 

<%  

	String tempDepartmentName="";
	String tempResourceName="";
	String tempStatusName="";
	String tempCurrentDate="";

    String trClass="DataLight";

    HrmScheduleDiffDetAbsentFromWorkManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetAbsentFromWorkManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		tempDepartmentName=strUtil.vString((String)scheduleMap.get("departmentName"));
		tempResourceName=strUtil.vString((String)scheduleMap.get("resourceName"));
		tempStatusName=strUtil.vString((String)scheduleMap.get("statusName"));
		tempCurrentDate=strUtil.vString((String)scheduleMap.get("currentDate"));
%>
<tr class="<%=trClass%>">
  <td align="left"><%=tempDepartmentName%></td>
  <td align="left"><%=tempResourceName%></td>
  <td align="left"><%=tempStatusName%></td>
  <td align="left"><%=tempCurrentDate%></td>
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
  <COL width="30%">
  <COL width="25%">
  <COL width="20%">
  <COL width="25%">
<tbody>
<tr>
	<td colspan="4" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
</tr> 
 

<% 
	String tempDepartmentName="";
	String tempResourceName="";
	String tempStatusName="";
	String tempCurrentDate="";

    String trClass="DataLight";

    HrmScheduleDiffDetNoSignManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetNoSignManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		tempDepartmentName=strUtil.vString((String)scheduleMap.get("departmentName"));
		tempResourceName=strUtil.vString((String)scheduleMap.get("resourceName"));
		tempStatusName=strUtil.vString((String)scheduleMap.get("statusName"));
		tempCurrentDate=strUtil.vString((String)scheduleMap.get("currentDate"));
%>
<tr class="<%=trClass%>">
  <td align="left"><%=tempDepartmentName%></td>
  <td align="left"><%=tempResourceName%></td>
  <td align="left"><%=tempStatusName%></td>
  <td align="left"><%=tempCurrentDate%></td>
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
  <COL width="15%">
  <COL width="10%">
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <COL width="15%">
  <COL width="10%">
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(828,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,0);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
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
  <COL width="15%">
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="15%">
<tbody>
<tr>
	<td colspan="6" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20095,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,1);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
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
  <COL width="15%">
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="15%">
<tbody>
<tr>
	<td colspan="6" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20096,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,2);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
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
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
<tbody>
<tr>
	<td colspan="5" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,4);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("outName"))%></td>
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
		List list = monthAttManager.getMonthReport("fromDate:"+fromDate+";toDate:"+toDate+";subCompanyId:"+subCompanyId+";departmentId:"+departmentId+";resourceId:"+resourceId);
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
		List sList = monthAttManager.getScheduleList(curDate, resourceId, diffBean);
		List fList = monthAttManager.getScheduleList(curDate, curDate, resourceId);
		boolean showFList = fList!=null && fList.size() > 0;
		String[] colWidths = diffBean.isSecSign() ? "16%,12%,12%,15%,15%,15%,15%".split(",") : "20%,20%,20%,20%,20%".split(",");
		String[] colNames = diffBean.isSecSign() ? "124;413;97;24585;24586;24587;24588".split(";") : "124;413;97;20035;20039".split(";");
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
  <%
	if(diffBean.isSecSign()){
  %>
  <td align="left"><%=strUtil.vString(map.get("signInTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("signOutTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("pmSignInTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("pmSignOutTime"))%></td>
  <%} else {%>
  <td align="left"><%=strUtil.vString(map.get("signInTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("signOutTime"))%></td>
  <%}%>
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
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
<tbody>
<tr>
	<td colspan="5" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,3,false,true);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("outName"))%></td>
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