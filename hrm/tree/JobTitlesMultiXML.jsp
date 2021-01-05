<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeids=Util.null2String(request.getParameter("nodeids"));
String subid=Util.null2String(request.getParameter("subid"));

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

TreeNode root=new TreeNode();
String companyname =CompanyComInfo.getCompanyname("1");
root.setTitle(companyname);
root.setNodeId("com_1");
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");
//root.setHref("javascript:setCompany('com_1')");

//SubCompanyComInfo.getSubCompanyTreeListByRight(user.getUID(),rightStr);
if(id.equals("")){
	envelope.addTreeNode(root);
	SubCompanyComInfo.getSubCompanyTreeList(root,"0",0,10,true,"jobTitlesMulti",null,null);
//}else if(!nodeids.equals("")){
	
}else 
	SubCompanyComInfo.getSubCompanyTreeList(envelope,id,0,10,true,"jobTitlesMulti",null,null);

weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>