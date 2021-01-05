<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="hrmTree" class="weaver.worktask.request.HrmTree" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><%
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String departmentId = Util.null2String(request.getParameter("departmentId"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
if(!subCompanyId.equals("")){
	envelope=hrmTree.getOrgTreeXMLBySubComp(subCompanyId);
}else if(!departmentId.equals("")){
	envelope=hrmTree.getDeptTreeXMLByDept(departmentId);
}else{
	//组织结构
	envelope=hrmTree.getOrgTreeXMLByComp();
}
envelope.marshal(out);
%>
