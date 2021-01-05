<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="WorkflowKeywordManager" class="weaver.docs.senddoc.WorkflowKeywordManager" scope="page" />
<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>


<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String keywordId=Util.null2String(request.getParameter("keywordId"));
String init=Util.null2String(request.getParameter("init"));

boolean exist=WorkflowKeywordComInfo.getKeywordName(""+keywordId).equals("")?false:true;

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");



if(!init.equals("")&&exist){
    //TreeNode root=new TreeNode();
    //String titleName=SystemEnv.getHtmlLabelName(16978,user.getLanguage());
    //root.setTitle(titleName);
    //root.setNodeId("keyword_0");
    //root.setTarget("_self"); 
    //root.setIcon("/images/treeimages/global_wev8.gif");
    //root.setHref("javascript:setKeyword('keyword_0')");
    //envelope.addTreeNode(root);
    ArrayList selectedList=new ArrayList();
    TreeNode node=new TreeNode();
    node.setNodeId("keyword_"+keywordId);
    selectedList.add(node);
    WorkflowKeywordManager.getKeywordTreeList(envelope,"keywordStructure",selectedList,"");
}else if(keywordId.equals("")){
    //TreeNode root=new TreeNode();
    //String titleName=SystemEnv.getHtmlLabelName(16978,user.getLanguage());
    //root.setTitle(titleName);
    //root.setNodeId("keyword_0");
    //root.setTarget("_self"); 
    //root.setIcon("/images/treeimages/global_wev8.gif");
    //root.setHref("javascript:setKeyword('keyword_0')");
    //envelope.addTreeNode(root);
    String rootId="0";
    WorkflowKeywordManager.getKeywordTreeList(envelope,rootId,0,3,"keywordStructure","",null,null);
}else{
    String rootId=keywordId;
    WorkflowKeywordManager.getKeywordTreeList(envelope,rootId,0,2,"keywordStructure","",null,null);
}



//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>