
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.systeminfo.*" %><%@ page import="weaver.general.*" %><%@ page import="weaver.hrm.*" %><jsp:useBean id="SubcompanyDocCategoryManager" class="weaver.workflow.field.SubcompanyDocCategoryManager" scope="page" /><tree><%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));

int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int isBill = Util.getIntValue(request.getParameter("isBill"),0);
int selectValue = Util.getIntValue(request.getParameter("selectValue"),-1);

if(!subCompanyId.equals("")){
	out.println(SubcompanyDocCategoryManager.getOrgTreeXMLBySubComp(fieldId,isBill,selectValue,subCompanyId,SystemEnv.getHtmlLabelName(1867,user.getLanguage())));
}else{
	out.println(SubcompanyDocCategoryManager.getOrgTreeXMLByComp(fieldId,isBill,selectValue));
}
%></tree>