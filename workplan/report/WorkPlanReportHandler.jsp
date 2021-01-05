
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="report" class="weaver.WorkPlan.WorkPlanReport" scope="page" />
<jsp:useBean id="valuate" class="weaver.WorkPlan.WorkPlanValuate" scope="page" />

<%
Calendar current = Calendar.getInstance();
String currentDate = Util.add0(current.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(current.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(current.get(Calendar.DAY_OF_MONTH), 2) ;

String userId = String.valueOf(user.getUID());
String type = Util.null2String(request.getParameter("type"));
String pageNum = Util.null2String(request.getParameter("pagenum"));
String term1 = Util.null2String(request.getParameter("term1"));
String term2 = Util.null2String(request.getParameter("term2"));
String viewType = Util.null2String(request.getParameter("viewtype"));	// 1:我的计划, 2:我安排的计划, 3:我下属的计划
String status = Util.null2String(request.getParameter("status"));
String underling = Util.null2String(request.getParameter("underling"));

int perPage = report.getPerPage(userId, type);

String workPlanId = "";
String memberStr = "";
String memberId = "";
String score = "";
String[] params;
for (int i = 0; i < perPage; i++) {
	workPlanId = Util.null2String(request.getParameter("plan" + String.valueOf(i)));

	if (!workPlanId.equals("")) {		
		rs.executeSql("SELECT resourceid FROM WorkPlan WHERE id = " + workPlanId);
		rs.next();
		memberStr = Util.null2String(rs.getString("resourceid"));
		StringTokenizer st = new StringTokenizer(memberStr, ",");
		while (st.hasMoreTokens()) {
			memberId = st.nextToken().trim();
			score = Util.null2String(request.getParameter(workPlanId + "_" + memberId + "_creater"));
			if (!score.equals("")) {
				params = new String[] {workPlanId, memberId, score, currentDate};
				valuate.createrValuate(params);
			}

			score = Util.null2String(request.getParameter(workPlanId + "_" + memberId + "_manager"));
			if (!score.equals("")) {
				params = new String[] {workPlanId, memberId, score, userId, currentDate};
				valuate.managerValuate(params);
			}
		}		
	}
}

response.sendRedirect("WorkPlanReport.jsp?type=" + type + "&pagenum=" + pageNum + "&term1=" + term1 
		+ "&term2=" + term2 + "&viewtype=" + viewType + "&underling=" + underling + "&status=" + status + "&needremind=0&flag=1");
%>