
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.company.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<tree>
<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String departmentId = Util.null2String(request.getParameter("departmentId"));

if(!subCompanyId.equals("")){
	out.println(subCompInfo.getOrgTreeXMLBySubComp(subCompanyId,""));
}else if(!departmentId.equals("")){
	out.println(subCompInfo.getDeptTreeXMLByDept(departmentId,""));
}else{
	out.println(subCompInfo.getOrgTreeXMLByComp());
}
%>
</tree>