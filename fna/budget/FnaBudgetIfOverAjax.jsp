<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FnaBudgetControl" class="weaver.fna.maintenance.FnaBudgetControl" scope="page" />
<%
BaseBean bb = new BaseBean();

//poststr += "|"+budgetfeetype+","+ orgtype+","+ orgid+","+ applydate+","+applyamount
String poststr  = Util.null2String(request.getParameter("poststr")).trim();//科目+报销类型+报销单位+报销日期+实报金额
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);

if(workflowid <= 0){
	rs.executeSql("select workflowid from workflow_requestbase where requestid = "+requestid);
	if(rs.next()){
		workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
	}
}

//0预算正常 1 报销金额大于预算金额! 2预算会计年度状态为“关闭”/未生效，流程不能提交审批! 
String returnStr = "";
if(FnaBudgetControl.checkBudgetList(poststr,requestid,false)){
	returnStr = "1";
}else{
	returnStr = "0";
}
%>   
<%=returnStr%>