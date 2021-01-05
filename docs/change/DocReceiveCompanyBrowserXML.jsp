<%@ page language="java" contentType="text/xml; charset=UTF-8" %>

<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

<jsp:useBean id="DocReceiveUnitManager" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<%

//被展开的上级单位id
String superId=Util.null2String(request.getParameter("superId"));
String nodeids=Util.null2String(request.getParameter("nodeids"));
String requestid=Util.null2String(request.getParameter("requestid"));

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

TreeNode root=new TreeNode();

String titleName =SystemEnv.getHtmlLabelName(19309,user.getLanguage());
root.setTitle(titleName);
root.setNodeId("unit_0");
root.setIcon("/images/treeimages/global_wev8.gif");
root.setValue("0");
root.setOncheck("check(unit_0)");

if(superId.equals("")&&nodeids.equals("")){
	envelope.addTreeNode(root);
	DocReceiveUnitManager.getReceiveUnitTreeListByDocchange(envelope,"0",0,2,"DocReceiveCompanyBrowser","",requestid);
}else if(!nodeids.equals("")){
	envelope.addTreeNode(root);

    ArrayList selectedList=new ArrayList();
    String[] ids=Util.TokenizerString2(nodeids,"|");
    for(int i=0;i<ids.length;i++){
		boolean exist=false;
        if(ids[i].indexOf("unit")>-1){
        	//System.out.println(ids[i]);
			String unitName=DocReceiveUnitComInfo.getReceiveUnitName(ids[i].substring(ids[i].lastIndexOf("_")+1));
            if(!unitName.equals("")){
				exist=true;
			}else{
				exist=false;
			}
        }
		if(exist){
			TreeNode node=new TreeNode();
			node.setNodeId(ids[i]);
			selectedList.add(node);
        }
    }
    DocReceiveUnitManager.getReceiveUnitTreeListByDocchange(envelope,"0",0,2,"DocReceiveCompanyBrowser","",requestid); 
}else{
	DocReceiveUnitManager.getReceiveUnitTreeListByDocchange(envelope,superId,0,2,"receiveUnitMulti","",requestid);
}


envelope.marshal(out);
%>