
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.systeminfo.*" %><%@ page import="weaver.general.*" %><%@ page import="weaver.hrm.company.*" %><%@ page import="weaver.hrm.*" %><%@ page import="java.util.*" %>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><tree><%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
BudgetHandler bh=new BudgetHandler();
if(!subCompanyId.equals("")){
	out.println(bh.getOrgTreeXMLBySubComp(subCompanyId,SystemEnv.getHtmlLabelName(1867,user.getLanguage())));
}
%></tree>