
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.systeminfo.*" %><%@ page import="weaver.general.*" %><%@ page import="weaver.hrm.*" %><jsp:useBean id="SubcompanyShowAttrManager" class="weaver.workflow.workflow.SubcompanyShowAttrManager" scope="page" /><tree><%
User user = HrmUserVarify.getUser (request , response);
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));

int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int isBill = Util.getIntValue(request.getParameter("isBill"),0);
int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int selectValue = Util.getIntValue(request.getParameter("selectValue"),-1);

if(!subCompanyId.equals("")){
	out.println(SubcompanyShowAttrManager.getOrgTreeXMLBySubComp(workflowId,formId,isBill,fieldId,selectValue,subCompanyId,SystemEnv.getHtmlLabelName(1867,user.getLanguage())));
}else{
	out.println(SubcompanyShowAttrManager.getOrgTreeXMLByComp(workflowId,formId,isBill,fieldId,selectValue));
}
%></tree>