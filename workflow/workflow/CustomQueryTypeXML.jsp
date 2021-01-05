<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.hrm.city.CityComInfo"%><%@ page import="weaver.systeminfo.SystemEnv"%><jsp:useBean id="CustomQueryManager" class="weaver.workflow.workflow.CustomQueryManager" scope="page" /><%
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
int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),-1);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=Util.getIntValue(request.getParameter("operatelevel"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if(!init.equals("")&&id.equals("")){
    TreeNode root=new TreeNode();
    String  companyname=SystemEnv.getHtmlLabelName(23799,user.getLanguage());
    root.setTitle(companyname);
    root.setNodeId("SearchType_0");
    root.setTarget("_self");
    root.setIcon("/images/treeimages/global_wev8.gif");
    root.setHref("javascript:setSubCompany('"+subcompanyid+"')");
    CustomQueryManager.getSearchTypeList(root, type,subcompanyid,nodeid,detachable,user.getUID());
    int nodeCount = root.getTreeNodeCount();
    if(nodeCount > 0 ){
        envelope.addTreeNode(root);
    }else{
        TreeNode nullNode=new TreeNode();
        nullNode.setTitle(SystemEnv.getHtmlLabelName(22521,user.getLanguage()));
        envelope.addTreeNode(nullNode);
    }
}else{
    CustomQueryManager.getSearchTypeList(envelope,type,subcompanyid,id,detachable,user.getUID());    
}

envelope.marshal(out);
%>