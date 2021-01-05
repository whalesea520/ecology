<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>   
<%@ page import="com.itextpdf.text.DocumentException"%>   
<%@ page import="java.io.IOException"%>   
<%@ page import="weaver.contractn.exception.ContractException"%>   
<%@page import="com.alibaba.fastjson.*"%>
<jsp:useBean id="pdf" class="weaver.contractn.util.PdfFormat" scope="page" />
<jsp:useBean id="WorkFlowConfig" class="weaver.contractn.util.WorkFlowConfig" scope="page" />


<%
User user = HrmUserVarify.getUser (request , response) ;
String requestid = request.getParameter("requestid");
String formid = request.getParameter("formid");
String workflowid = request.getParameter("workflowid");
JSONObject formObj = WorkFlowConfig.queryWrokFlowFormInfo(workflowid,formid,requestid);
out.print(pdf.getPngOfcons(formObj,user));
//try{
	//message = pdf.getPngOfcons(wrequestid,user);
//}catch(IOException e ){
	//out.print("faild");
//}catch(DocumentException e ){
////	out.print("faild");
//}catch(ContractException e ){
//	out.print("faild");
//}
//out.print(message);
%>
