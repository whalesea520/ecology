<%--
  Created by IntelliJ IDEA.
  User: sean.yang
  Date: 2006-3-3
  Time: 13:26:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="ServiceReg" class="com.weaver.integration.util.ServiceRegTreeInfo" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<%
String id=Util.null2String(request.getParameter("id"));
String init=Util.null2String(request.getParameter("init"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

//System.out.println("id"+id);
//if(init.equals("y")&&!id.equals("")){
   // TreeNode root=new TreeNode();
   // root.setTitle(SystemEnv.getHtmlLabelName(831,user.getLanguage()));
    //root.setNodeId("com_0");
   // root.setHref("javascript:onClick('0')");
    //root.setTarget("_self");
   // root.setIcon("/images/treeimages/global_wev8.gif");
    //envelope.addTreeNode(root);
   // CapitalAssortmentComInfo.getTreeListById(root,id,checktype,onlyendnode,showcptcount);
//}else if(id.equals("")){
    TreeNode root=new TreeNode();
    root.setTitle(SystemEnv.getHtmlLabelName(30698 ,user.getLanguage()));
    root.setNodeId("com_0");
    root.setHref("javascript:onClick('0')");
    root.setTarget("_self");
    root.setIcon("/images/treeimages/global_wev8.gif");
    envelope.addTreeNode(root);
    ServiceReg.getTreeList(root,"0");
//}else{
   // ServiceReg.getTreeList(envelope,id);
//}
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>
