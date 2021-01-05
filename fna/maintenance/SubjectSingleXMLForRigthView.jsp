<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.hrm.*" %>
<%@ page language="java" contentType="text/xml; charset=UTF-8" %>

<%
int filterlevel = Util.getIntValue(request.getParameter("level"),0);
int filterfeetype = Util.getIntValue(request.getParameter("feetype"),0);
int para1 = Util.getIntValue(request.getParameter("para1"),0);
int para2 = Util.getIntValue(request.getParameter("para2"),0);
//System.out.println("para1="+para1);
//System.out.println("para2="+para2);
%>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<jsp:useBean id="subjectComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />

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
//System.out.println("if");
subjectComInfo.getSubjectTreeList(envelope, type,"0",2,filterlevel,filterfeetype,para1,para2);

}else{
		//System.out.println("else");
    subjectComInfo.getSubjectTreeList(envelope,type,id,1,filterlevel,filterfeetype,para1,para2);
}

envelope.marshal(out);
%>