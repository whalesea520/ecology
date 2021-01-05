<%@ page language="java" contentType="text/xml;charset=UTF-8"%><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="weaver.hrm.User" %><%@ page import="weaver.hrm.HrmUserVarify" %><%@ page import="weaver.systeminfo.SystemEnv" %><%@ page import="weaver.docs.senddoc.DocReceiveUnitConstant" %><jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/><jsp:useBean id="DocReceiveUnitManager" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page" /><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String type = Util.null2String(request.getParameter("type"));
String id = Util.null2String(request.getParameter("id"));
String isWfDoc = Util.null2String(request.getParameter("isWfDoc"));

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

int maxLevel=DocReceiveUnitConstant.RECEIVE_UNIT_MAX_LEVEL+1;
String rightStr = "SRDoc:Edit";
DocReceiveUnitManager.setIsWfDoc(isWfDoc);
if("".equals(id)){
	TreeNode root=new TreeNode();
	String titleName =SystemEnv.getHtmlLabelName(19309,user.getLanguage());
	root.setTitle(titleName);
	root.setNodeId("unit_0");
	root.setId("undefined");
	root.setTarget("_self"); 
	root.setIcon("/images/treeimages/global_wev8.gif");
	root.setHref("javascript:setSubcompany('com_0')");
	envelope.addTreeNode(root);
	DocReceiveUnitManager.getSubCompanyTreeListByRight(user.getUID(),rightStr);
	DocReceiveUnitManager.getSubCompanyTreeListByRight(root,"0",0,2,true,"receiveUnitStructure",null,null,"",true);
	//DocReceiveUnitManager.getReceiveUnitTreeList(root,"0",0,maxLevel,"receiveUnitStructure","");
}else{
	if("com".equalsIgnoreCase(type)){
		DocReceiveUnitManager.getSubCompanyTreeListByRight(user.getUID(),rightStr);
		DocReceiveUnitManager.getSubCompanyTreeListByRight(envelope,id,0,2,true,"receiveUnitStructure",null,null,"",true);
	}else{
		String subcompanyid = DocReceiveUnitComInfo.getSubcompanyid(id);
		DocReceiveUnitManager.getReceiveUnitTreeList(envelope,id,0,2,"receiveUnitStructure",null,subcompanyid,true);
	}
}

envelope.marshal(out);
%>