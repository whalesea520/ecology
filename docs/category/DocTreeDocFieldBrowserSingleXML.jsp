<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util,weaver.hrm.*" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

%>


<%

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

String excludeId=Util.null2String(request.getParameter("excludeId"));
TreeNode root=new TreeNode();
String titleName=DocTreeDocFieldComInfo.getTreeDocFieldName(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setTitle(titleName);
root.setRadio("Y");
root.setValue(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setOncheck("check(field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID+")");
root.setNodeId("field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");
envelope.addTreeNode(root);

int maxLevel=DocTreeDocFieldConstant.TREE_DOC_FIELD_MAX_LEVEL+1;
String rootId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
DocTreeDocFieldManager.getTreeDocFieldTreeList(root,rootId,0,maxLevel,"treeDocFieldSingle",excludeId);

//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);

%>