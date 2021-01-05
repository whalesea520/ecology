
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.*" %><%@ page import="weaver.hrm.*" %><%@ page import="java.util.*" %><jsp:useBean id="chatCompInfo" class="weaver.hrm.chat.ChatHrmListTree" scope="page" /><tree><%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String departmentId = Util.null2String(request.getParameter("departmentId"));

if(!subCompanyId.equals("")){
	out.println(chatCompInfo.getChatOrgTreeXMLBySubComp(subCompanyId,""));
}else if(!departmentId.equals("")){
	out.println(chatCompInfo.getChatDeptTreeXMLByDept(departmentId,""));
}else{
	out.println(chatCompInfo.getOrgTreeXMLByComp());
}
%></tree>