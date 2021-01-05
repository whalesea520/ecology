<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.city.CityComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<jsp:useBean id="cityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />

<%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));

//System.out.print("nodeid"+nodeid);
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if(!init.equals("")&&id.equals("")){
//TreeNode root=new TreeNode();

/*root.setTitle(" ");
root.setNodeId("glob_0");
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");
envelope.addTreeNode(root);*/
cityComInfo.getProvinceTreeList(envelope, type,"0",1);

}else{

    cityComInfo.getProvinceTreeList(envelope,type,id,1);

}

weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>