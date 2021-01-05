<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.hrm.*" %>

<%@ page language="java" contentType="text/xml; charset=UTF-8" %>


<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<jsp:useBean id="citytwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page" />

<%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String citypid=Util.null2String(request.getParameter("pid"));
//System.out.print("citypid"+citypid);

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if(!init.equals("")&&id.equals("")){
//TreeNode root=new TreeNode();

/*root.setTitle(" ");
root.setNodeId("glob_0");
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");
envelope.addTreeNode(root);*/
citytwoComInfo.getCityTreeList(envelope, type,"0",2,citypid);

}else{

    citytwoComInfo.getCityTreeList(envelope,type,id,1,citypid);

}

//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>