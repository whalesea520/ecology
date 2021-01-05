<%@ page language="java" contentType="text/html;charset=UTF-8"%><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="weaver.hrm.User" %><%@ page import="weaver.hrm.HrmUserVarify" %><%@ page import="weaver.systeminfo.SystemEnv" %><%@ page import="weaver.docs.senddoc.DocReceiveUnitConstant" %><jsp:useBean id="DocReceiveUnitManager" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page" /><jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String type = Util.null2String(request.getParameter("type"));
String id = Util.null2String(request.getParameter("id"));

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
String rightStr_tmp = Util.null2String((String)session.getAttribute("rightStr_tmp"+user.getUID()));
String excludeid = Util.null2String(request.getParameter("excludeid"));
String superiorUnitId = Util.null2String(request.getParameter("superiorUnitId"));
TreeNode root=new TreeNode();
if("".equals(id)){
	String titleName =SystemEnv.getHtmlLabelName(19309,user.getLanguage());
	root.setTitle(titleName);
	root.setValue("0");
	root.setOncheck("check(unit_0)");
	root.setNodeId("unit_0");
	root.setTarget("_self");
	root.setIcon("/images/treeimages/global_wev8.gif");
	envelope.addTreeNode(root);

	int maxLevel = 10;
	if(!"".equals(superiorUnitId)){
		maxLevel = DocReceiveUnitManager.getLevel(Util.getIntValue(superiorUnitId, 0), 0, 0);
		if(maxLevel < 3){
    		maxLevel = 3;
    	}
	}
	if("".equals(rightStr_tmp)){
		DocReceiveUnitManager.getSubCompanyTreeList(user.getUID());
	}else{
		DocReceiveUnitManager.getSubCompanyTreeListByRight(user.getUID(),rightStr_tmp);
	}
	DocReceiveUnitManager.getSubCompanyTreeListByRight(root,"0",0,maxLevel,true,"receiveUnitSingle",null,null,excludeid);
}else{
	if("com".equalsIgnoreCase(type)){
		if("".equals(rightStr_tmp)){
			DocReceiveUnitManager.getSubCompanyTreeList(user.getUID());
		}else{
			DocReceiveUnitManager.getSubCompanyTreeListByRight(user.getUID(),rightStr_tmp);
		}
		DocReceiveUnitManager.getSubCompanyTreeListByRight(envelope,id,0,2,true,"receiveUnitSingle",null,null,excludeid);
	}else{
		String subcompanyid = DocReceiveUnitComInfo.getSubcompanyid(id);
		DocReceiveUnitManager.getReceiveUnitTreeList(envelope,id,0,2,"receiveUnitSingle",null,subcompanyid);
	}
}
//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);

%>