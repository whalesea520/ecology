<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreelistManager" class="weaver.docs.category.DocTreelistManager" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />

<%

response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<%
boolean needPeop=Util.null2String(request.getParameter("needPeop")).equals("1")?true:false;

//被展开的上级单位id
String superId=Util.null2String(request.getParameter("superId"));


//remember maincateids subcateids
String mainCateIds=Util.null2String(request.getParameter("mainCateIds"));
String subCateIds=Util.null2String(request.getParameter("subCateIds"));

String leveltype=Util.null2String(request.getParameter("leveltype"));
String nodlevelid=Util.null2String(request.getParameter("nodlevelid"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

TreeNode root=new TreeNode();

String titleName= CompanyComInfo.getCompanyname("1");
root.setTitle(titleName);
root.setNodeId("field_0");
root.setCheckbox("Y");
root.setIcon("/images/treeimages/global_wev8.gif");
//if(needPeop){
	if(user.getUID()==1) root.setCheckbox("Y");
//} else{
//	root.setCheckbox("Y");
//}
root.setValue(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setOncheck("check(field_0)");

int maxLevel=DocTreeDocFieldConstant.TREE_DOC_FIELD_MAX_LEVEL;
if(superId.equals("") || leveltype.equals("1")){
	envelope.addTreeNode(root);
	if(!"".equals(mainCateIds) && !",".equals(mainCateIds)){
		DocTreelistManager.getTreeDocFieldTreeListRem(root,"0",0,2,"doclistmulti","",needPeop,user,mainCateIds,subCateIds);
	}else{
		DocTreelistManager.getTreeDocFieldTreeList(root,"0",0,2,"doclistmulti","",needPeop,user);
	}

}else if(!superId.equals("") && leveltype.equals("")){
	DocTreelistManager.getTreeDocFieldTreeListSec(envelope,superId,0,2,"doclistmulti","",needPeop,user);

}else if (!superId.equals("") && leveltype.equals("2")){
	DocTreelistManager.getTreeDocFieldTreeListRd(envelope,superId,0,2,"doclistmulti","",needPeop,user);
}
	//envelope.marshal(out);
	weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>