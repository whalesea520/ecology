<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.budget.BudgetAutoMove"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
boolean execFlag = false;
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
}else{
	if (!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user) && !HrmUserVarify.checkUserRight("BudgetManualTransfer:do", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	execFlag = BudgetAutoMove.isExecuteFlag();
}
%>{"execFlag":<%=execFlag?"true":"false" %>}