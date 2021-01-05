<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.hrm.city.CityComInfo"%><%@ page import="weaver.systeminfo.SystemEnv"%><jsp:useBean id="MonitorTree" class="weaver.workflow.workflow.MonitorTree" scope="page" /><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=Util.getIntValue(request.getParameter("operatelevel"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

TreeNode root=new TreeNode();
String companyname ="";
if(isTemplate.equals("1")){
    companyname=SystemEnv.getHtmlLabelName(2239,user.getLanguage());
}else{
    companyname= SystemEnv.getHtmlLabelName(2239,user.getLanguage());
}
root.setTitle(companyname);
root.setNodeId("workflowmonitor_0");
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");
root.setHref("javascript:setSubCompany('"+subcompanyid+"')");
//envelope.addTreeNode(root);
if(operatelevel<0)
{
    TreeNode root1=new TreeNode();
    root1.setTitle(SystemEnv.getHtmlLabelName(557,user.getLanguage()));
    root1.setNodeId("workflowmonitor_0");
    root1.setTarget("_self");
    root1.setHref("javascript:setSubCompany('"+subcompanyid+"')");
    root.addTreeNode(root1);
}
else
{
    MonitorTree.getMonitorTypeTreeList(root, type,subcompanyid,isTemplate,nodeid,detachable);
}
int nodeCount = root.getTreeNodeCount();
if(nodeCount > 0 ){
    envelope.addTreeNode(root);
}else{
    TreeNode nullNode=new TreeNode();
    nullNode.setTitle(SystemEnv.getHtmlLabelName(22521,user.getLanguage()));
    envelope.addTreeNode(nullNode);
}

envelope.marshal(out);
%>