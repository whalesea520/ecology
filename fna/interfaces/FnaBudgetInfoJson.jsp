<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %><jsp:useBean id="BudgetHandler" class="weaver.fna.budget.BudgetHandler" scope="page" /><%
if(true){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
int budgetfeetype  = Util.getIntValue(request.getParameter("budgetfeetype"),0);//费用科目
String orgtype = Util.null2String(request.getParameter("orgtype"));//费用类型 分部：subcmp；部门：dep；个人：hrm；
int orgid  = Util.getIntValue(request.getParameter("orgid"),0);//费用单位
String applydate  = request.getParameter("applydate");//费用日期
int orgtypeInt = 0;
if("hrm".equals(orgtype)){
	orgtypeInt=3;
}else if("dep".equals(orgtype)){
	orgtypeInt=2;
}else if("subcmp".equals(orgtype)){
	orgtypeInt=1;
}
 
String infos = BudgetHandler.getBudgetKPI4DWR(applydate, orgtypeInt, orgid, budgetfeetype, false);
//hrm 可用预算,hrm 已发生费用,hrm 审批中费用|dep 可用预算,dep 已发生费用,dep 审批中费用|subcmp 可用预算,subcmp 已发生费用,subcmp 审批中费用s
String[] infosArray = infos.split("\\|");
String[] hrmArray = infosArray[0].split(",");
String[] depArray = infosArray[1].split(",");
String[] subcmpArray = infosArray[2].split(",");
StringBuffer returnStr = new StringBuffer();
returnStr.append("{");
	returnStr.append("\"hrm\":{");
		returnStr.append("\"available\":"+JSONObject.quote(Util.null2String(hrmArray[0]).trim())+",");
		returnStr.append("\"realExpense\":"+JSONObject.quote(Util.null2String(hrmArray[1]).trim())+",");
		returnStr.append("\"pendingExpense\":"+JSONObject.quote(Util.null2String(hrmArray[2]).trim())+"");
	returnStr.append("},");
	returnStr.append("\"dep\":{");
		returnStr.append("\"available\":"+JSONObject.quote(Util.null2String(depArray[0]).trim())+",");
		returnStr.append("\"realExpense\":"+JSONObject.quote(Util.null2String(depArray[1]).trim())+",");
		returnStr.append("\"pendingExpense\":"+JSONObject.quote(Util.null2String(depArray[2]).trim())+"");
	returnStr.append("},");
	returnStr.append("\"subcmp\":{");
		returnStr.append("\"available\":"+JSONObject.quote(Util.null2String(subcmpArray[0]).trim())+",");
		returnStr.append("\"realExpense\":"+JSONObject.quote(Util.null2String(subcmpArray[1]).trim())+",");
		returnStr.append("\"pendingExpense\":"+JSONObject.quote(Util.null2String(subcmpArray[2]).trim())+"");
	returnStr.append("}");
returnStr.append("}");
%><%=returnStr.toString()%>