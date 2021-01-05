
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %><jsp:useBean id="BudgetHandler" class="weaver.fna.budget.BudgetHandler" scope="page" /><%
int orgtype = Util.getIntValue(request.getParameter("orgtype"),0);		//报销类型 人员0/部门1/分部2   3/2/1
int orgid  = Util.getIntValue(request.getParameter("orgid"),0);                //报销单位
String returnStr = "";
String infos = BudgetHandler.getLoanAmount4DWR(orgtype, orgid, false)+"";
returnStr = infos;
%><%=returnStr%>