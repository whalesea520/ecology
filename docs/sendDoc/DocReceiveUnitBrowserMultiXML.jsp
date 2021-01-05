<%@ page language="java" contentType="text/xml;charset=UTF-8"%><%@ page import="java.util.ArrayList" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="weaver.hrm.User" %><%@ page import="weaver.hrm.HrmUserVarify" %><%@ page import="weaver.systeminfo.SystemEnv" %><jsp:useBean id="DocReceiveUnitManager" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page" /><jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String type = Util.null2String(request.getParameter("type"));
String id = Util.null2String(request.getParameter("id"));
String rightStr_tmp = Util.null2String((String)session.getAttribute("rightStr_tmp"+user.getUID()));
//被展开的上级单位id
String superId=Util.null2String(request.getParameter("superId"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if("".equals(id)){
	TreeNode root=new TreeNode();
	String titleName =SystemEnv.getHtmlLabelName(19309,user.getLanguage());
	root.setTitle(titleName);
	root.setNodeId("unit_0");
	root.setTarget("_self"); 
	root.setIcon("/images/treeimages/global_wev8.gif");
	root.setHref("javascript:setSubcompany('com_0')");
	envelope.addTreeNode(root);
	if("".equals(rightStr_tmp)){
		DocReceiveUnitManager.getSubCompanyTreeList(user.getUID());
	}else{
		DocReceiveUnitManager.getSubCompanyTreeListByRight(user.getUID(),rightStr_tmp);
	}
	int maxLevel = 10;
	if(!"".equals(nodeid) && nodeid.indexOf("com_") > -1){
		maxLevel = DocReceiveUnitManager.getLevel(Util.getIntValue(nodeid.substring(nodeid.indexOf("_")+1), 0), 0, 1);
		if(maxLevel < 3){
    		maxLevel = 3;
    	}
	}
	DocReceiveUnitManager.getSubCompanyTreeListByRight(root,"0",0,maxLevel,true,"receiveUnitMulti",null,null,"");
}else{
	if("com".equalsIgnoreCase(type)){
		if("".equals(rightStr_tmp)){
			DocReceiveUnitManager.getSubCompanyTreeList(user.getUID());
		}else{
			DocReceiveUnitManager.getSubCompanyTreeListByRight(user.getUID(),rightStr_tmp);
		}
		DocReceiveUnitManager.getSubCompanyTreeListByRight(envelope,id,0,2,true,"receiveUnitMulti",null,null,"");
	}else{
		String subcompanyid = DocReceiveUnitComInfo.getSubcompanyid(id);
		DocReceiveUnitManager.getReceiveUnitTreeList(envelope,id,0,2,"receiveUnitMulti",null,subcompanyid);
	}
}


envelope.marshal(out);
%>