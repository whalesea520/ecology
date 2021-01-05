<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" /><%

String virtualtype=Util.null2String(request.getParameter("virtualtype"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
TreeNode root=new TreeNode();
String companyname = CompanyComInfo.getCompanyname("1");
root.setTitle(companyname);
root.setNodeId("root_0");
root.setCheckbox("Y");
root.setOncheck("check(root_0)");
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");
envelope.addTreeNode(root);
SubCompanyVirtualComInfo.getSubCompanyTreeList(root,virtualtype,"0",0,10,false,"subcompanyMutiByRight",null,null,"",user);
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>