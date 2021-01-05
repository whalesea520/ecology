
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util,,weaver.hrm.*" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="ModeTreeFieldComInfo" class="weaver.formmode.setup.ModeTreeFieldComInfo" scope="page" />
<jsp:useBean id="ModeTreeFieldManager" class="weaver.formmode.setup.ModeTreeFieldManager" scope="page" />
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

TreeNode root=new TreeNode();
String titleName=ModeTreeFieldComInfo.getTreeModeFieldName(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setTitle(titleName);
root.setNodeId("field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setTarget("_self"); 
root.setIcon("/images/treeimages/global_wev8.gif");
root.setHref("javascript:setTreeDocField('field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID+"')");
envelope.addTreeNode(root);

int maxLevel=DocTreeDocFieldConstant.TREE_DOC_FIELD_MAX_LEVEL+1;
String rootId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
ModeTreeFieldManager.getTreeFieldList(root,rootId,0,maxLevel,"");
//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>