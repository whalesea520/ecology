<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>

<%@ page language="java" contentType="text/xml; charset=UTF-8" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<jsp:useBean id="TreeHelper" class="weaver.hrm.resource.browser.TreeHelper" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String subid=Util.null2String(request.getParameter("subid"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
TreeHelper.getSubCompanyTreeListByEditRight(user.getUID(),"HrmResourceAdd:Add");
if(id.equals("")){
TreeNode root=new TreeNode();
String companyname =CompanyComInfo.getCompanyname("1");
root.setTitle(companyname);
root.setNodeId("com_0");
//root.setHref("javascript:setCompany(0)");
root.setTarget("_self"); 
root.setIcon("/images/treeimages/global_wev8.gif");
envelope.addTreeNode(root);
TreeHelper.getSubCompanyTreeListByEditRight(root,"0",0,3,true,"resourceDismissSingle",null,null);
}else{
  if(type.equals("com"))
    TreeHelper.getSubCompanyTreeListByEditRight(envelope,id,0,2,true,"resourceDismissSingle",null,null);
  else
    TreeHelper.getDepartTreeList(envelope,subid,id,0,2,"resourceDismissSingle",null,null);
}
envelope.marshal(out);
%>