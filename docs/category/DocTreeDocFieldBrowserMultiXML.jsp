
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<%
boolean needPeop=Util.null2String(request.getParameter("needPeop")).equals("1")?true:false;
int fromid=Util.getIntValue(request.getParameter("fromid"));
int permissiontype=Util.getIntValue(request.getParameter("permissiontype"));

//被展开的上级单位id
String superId=Util.null2String(request.getParameter("superId"));

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

TreeNode root=new TreeNode();

String titleName=DocTreeDocFieldComInfo.getTreeDocFieldName(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);

root.setTitle(titleName);
root.setNodeId("field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
//root.setIcon("/images/treeimages/global_wev8.gif");
//if(needPeop){
	if(user.getUID()==1) root.setCheckbox("Y");
//} else{
//	root.setCheckbox("Y");
//}
root.setValue(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setOncheck("check(field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID+")");


int maxLevel=3;

if(superId.equals("")){
    envelope.addTreeNode(root);
	DocTreeDocFieldManager.getTreeDocFieldTreeList(root,DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID,0,maxLevel,"treeDocFieldMulti","",needPeop,user,fromid,permissiontype);   
}else{
	DocTreeDocFieldManager.getTreeDocFieldTreeList(envelope,superId,0,maxLevel,"treeDocFieldMulti","",needPeop,user,fromid,permissiontype);
}
	//envelope.marshal(sw);
	weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>