
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML>
	<HEAD>
		<TITLE></TITLE>
<%
	if(!HrmUserVarify.checkUserRight("WorkPlanMonitorSet:Set", user))
	{
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}

	String hrmID = Util.null2String(request.getParameter("hrmID"));

	String workPlanTypeIDs[] = request.getParameterValues("workPlanTypeIDs");
	
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = (TimeUtil.getCurrentTimeString()).substring(11,19);
	String operateType="1";
	String operateName="新建";
	if(!"".equals(hrmID) && null != hrmID)
	{
		RecordSet.executeSql("select 1 FROM WorkPlanMonitor WHERE hrmID = " + hrmID);
		if(RecordSet.next()){
			operateType="2";
    		operateName="修改";
		}
	    RecordSet.executeSql("DELETE FROM WorkPlanMonitor WHERE hrmID = " + hrmID);
	    
	    if(null != workPlanTypeIDs && workPlanTypeIDs.length > 0)
	    {	
	        for(int i = 0; i < workPlanTypeIDs.length; i++)
	        {
	            RecordSet.executeSql("INSERT INTO WorkPlanMonitor(hrmID, workPlanTypeID, operatorDate, operatorTime) VALUES (" + hrmID + ", " + workPlanTypeIDs[i] + ", '" + currentDate + "', '" + currentTime + "'" + ")");	            
	        }
	    }
	    SysMaintenanceLog syslog=new SysMaintenanceLog();
	    syslog.resetParameter();
		syslog.insSysLogInfo(user,Util.getIntValue(hrmID),ResourceComInfo.getLastname(hrmID)+"-"+operateName+"日程监控","日程监控设置","213",operateType,0,Util.getIpAddr(request)); 
	}
	
	//response.sendRedirect("WorkPlanMonitorStatic.jsp");
%>
	<script type="text/javascript">
		var parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
	</script>
	</HEAD>

<BODY>
</BODY>

</HTML>
