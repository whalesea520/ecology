
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.WorkPlan.WorkPlanHandler" %>
<%@ page import="weaver.workspace.WorkSpaceStyle"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="workSpaceStyle" class="weaver.workspace.WorkSpaceStyle" scope="page" />

<%
String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();

String method = Util.null2String(request.getParameter("method"));

WorkPlanHandler workPlanHandler = new WorkPlanHandler();

String[] logParams;
WorkPlanLogMan logMan = new WorkPlanLogMan();

if (method.equals("addnote")) {
    String note = Util.null2String(request.getParameter("note"));

    String planId = String.valueOf(workPlanHandler.addNote(note, userId, userType));

	workPlanViewer.setWorkPlanShareById(planId);

	//write "add" of view log
	logParams = new String[] {planId,
							WorkPlanLogMan.TP_CREATE,
							userId,
							request.getRemoteAddr()};
	logMan.writeViewLog(logParams);
	//end

	//workPlanComInfo.addWorkPlanCache(planId);

	response.sendRedirect("WorkPlanView.jsp");
} else if (method.equals("changestyle")) {
	int style = Util.getIntValue(request.getParameter("style"), -1);
	if (style == WorkSpaceStyle.WS_NEWS || style == WorkSpaceStyle.WS_WORKPLAN) {
		workSpaceStyle.setStyleType(userId, userType, style);
		if (style == WorkSpaceStyle.WS_NEWS)
			response.sendRedirect("WorkSpaceNews.jsp");
		else
			response.sendRedirect("WorkPlanView.jsp");
	}
}
%>