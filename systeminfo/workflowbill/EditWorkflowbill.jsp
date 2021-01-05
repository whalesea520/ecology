<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.workflowbill.WorkFlowBillUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
 WorkFlowBillUtil wf = new WorkFlowBillUtil();
 if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageWorkflowbill.jsp");
}   
%>


