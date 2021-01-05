<%@page import="weaver.fna.interfaces.thread.BudgetAutoMoveThread"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.budget.BudgetAutoMove"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if (!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user) && !HrmUserVarify.checkUserRight("BudgetManualTransfer:do", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String fnayear = Util.null2String(request.getParameter("fnayear"));
int periodsidNextMM = Util.getIntValue(request.getParameter("periodsid"))+1;
String _guid1 = Util.null2String(request.getParameter("_guid1"));


BudgetAutoMoveThread budgetAutoMoveThread = new BudgetAutoMoveThread();

budgetAutoMoveThread.setUser(user);
budgetAutoMoveThread.setGuid(_guid1);

budgetAutoMoveThread.setFnayear(fnayear);
budgetAutoMoveThread.setPeriodsidNextMM(periodsidNextMM);

budgetAutoMoveThread.setIsprint1(false);
budgetAutoMoveThread.setIsprint2(false);


Thread thread_1 = new Thread(budgetAutoMoveThread);
thread_1.start();

%>