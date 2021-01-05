<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"),-1);
	if(!HrmUserVarify.checkUserRight("WorkFlowPlanSet:All", user) && !HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
	 	return;
	}
	rs.executeSql("delete WorkFlowPlanSet where flowId = " + wfid);
	String alertType="0";
	int status = Util.getIntValue(request.getParameter("status"),1);
	String frequencyt = Util.null2String(request.getParameter("frequencyt"));
	String dateType = Util.null2String(request.getParameter("dateType"));
	int dateSum = Util.getIntValue(request.getParameter("dateSum"),1);
	String timeSet = Util.null2String(request.getParameter("timeSet"));
	String alertType1 = Util.null2String(request.getParameter("alertType1"));
	String alertType2 = Util.null2String(request.getParameter("alertType2"));
	if (alertType1.equals("1")&&alertType2.equals("2")) alertType="3";
	else if (alertType1.equals("1")) alertType="1";
	else if (alertType2.equals("2")) alertType="2";
    rs.executeSql("insert into WorkFlowPlanSet (status,frequencyt,dateType,dateSum,alertType,flowId,timeSet) values ('"+status+"','"+frequencyt+"','"+dateType+"',"+dateSum+",'"+alertType+"',"+wfid+",'"+timeSet+"')");
	response.sendRedirect("WorkFlowPlanSet.jsp?ajax=1&wfid="+wfid);
%>




