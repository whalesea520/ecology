<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@page import="weaver.fna.budget.BudgetAutoMove"%><%@page import="weaver.general.BaseBean"%><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%><%
String result = "";
User user = HrmUserVarify.getUser (request , response) ;
if (!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user) && !HrmUserVarify.checkUserRight("BudgetManualTransfer:do", user)) {
	result = "";
}else{
	String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
	
	result = ".....";
	if(BudgetAutoMove.isExecuteIsDone() && !BudgetAutoMove.isExecuteFlag()){
		BudgetAutoMove.setExecuteIsDone(false);
		result = "";
	}else if(BudgetAutoMove.isExecuteFlag()){
		result = BudgetAutoMove.getProgress()+"...";
	}
}
%><%=result %>