
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %><jsp:useBean id="BudgetHandler" class="weaver.fna.budget.BudgetHandler" scope="page" /><%
int budgetfeetype  = Util.getIntValue(request.getParameter("budgetfeetype"),0);//科目
int orgtype = Util.getIntValue(request.getParameter("orgtype"),0);		//报销类型 人员0/部门1/分部2   3/2/1
int orgid  = Util.getIntValue(request.getParameter("orgid"),0);                //报销单位
String applydate  = request.getParameter("applydate") ;                        //报销日期
String returnStr = "";
String infos = BudgetHandler.getBudgetKPI(applydate,orgtype,orgid,budgetfeetype, true);
returnStr = infos;
%><%=returnStr%>