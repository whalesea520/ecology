<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.hrm.city.CityComInfo"%><%@ page import="weaver.systeminfo.SystemEnv"%><jsp:useBean id="WorkFlowTree" class="weaver.workflow.workflow.WorkFlowTree" scope="page" /><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
String subCompanyId=Util.null2String(request.getParameter("subCompanyId"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=Util.getIntValue(request.getParameter("operatelevel"));
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
String workflowIds = Util.null2String(request.getParameter("workflowIds"));
String searchStr = Util.null2String(request.getParameter("searchStr"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
String hasRightSub = "";
if(detachable == 1){
    hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",-1);
}
//没有开启分权，且有流程维护权限的
if(detachable != 1 && HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    workflowIds = "";
}


if(!init.equals("")&&id.equals("")){
    TreeNode root=new TreeNode();
    String companyname ="";
    if(isTemplate.equals("1")){
        companyname=SystemEnv.getHtmlLabelName(18334,user.getLanguage());
    }else{
        companyname= SystemEnv.getHtmlLabelName(16483,user.getLanguage());
    }
    if ("multiworkflowtype".equals(type)) {
    	companyname= SystemEnv.getHtmlLabelName(33234,user.getLanguage());
    	subCompanyId=SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",0);
    }
    root.setTitle(companyname);
    root.setNodeId("workflowtype_0");
    root.setTarget("_self");
    root.setIcon("/images/treeimages/global_wev8.gif");
    root.setHref("javascript:setSubCompany('"+Util.null2String(request.getParameter("subCompanyId"))+"')");
    
    if(detachable == 0 && HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !"multiworkflowtype".equals(type)){
     	type = "selectAll";   
    }
    
    WorkFlowTree.getWorkflowTypeTreeList(root, type,subCompanyId,isTemplate,nodeid,detachable,isWorkflowDoc,workflowIds,Util.null2String(request.getParameter("subCompanyId")),searchStr,hasRightSub);
    int nodeCount = root.getTreeNodeCount();
    if(nodeCount > 0 ){
        envelope.addTreeNode(root);
    }else{
        TreeNode nullNode=new TreeNode();
        nullNode.setTitle(SystemEnv.getHtmlLabelName(22521,user.getLanguage()));
        envelope.addTreeNode(nullNode);
    }
}else{
    WorkFlowTree.getWorkflowTreeList(envelope,type,subCompanyId,isTemplate,id,detachable,isWorkflowDoc,workflowIds,searchStr,hasRightSub);
}

envelope.marshal(out);
%>
