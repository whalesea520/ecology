<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.systeminfo.SystemEnv"%><jsp:useBean id="WorkflowCodeSeqReservedTree" class="weaver.workflow.workflow.WorkflowCodeSeqReservedTree" scope="page" /><%
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
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));

if(!init.equals("")&&id.equals("")){
    TreeNode root=new TreeNode();
    String companyname ="";

    companyname= SystemEnv.getHtmlLabelName(34067,user.getLanguage());

    root.setTitle(companyname);
    root.setNodeId("workflowtype_0");
	root.setTarget("wfmainFrame");
    root.setIcon("/images/treeimages/global_wev8.gif");
    root.setHref("/workflow/workflow/WorkflowCodeSeqReservedHelp.jsp");
    envelope.addTreeNode(root);
    if(operatelevel<0){
        TreeNode root1=new TreeNode();
        root1.setTitle(SystemEnv.getHtmlLabelName(557,user.getLanguage()));
        root1.setNodeId("workflowtype_0");
        root1.setTarget("wfmainFrame");
        root1.setHref("/workflow/workflow/WorkflowCodeSeqReservedHelp.jsp");
        root.addTreeNode(root1);
    }else{
        WorkflowCodeSeqReservedTree.getWorkflowTypeTreeList(root, type,subCompanyId,isTemplate,nodeid,detachable,sqlwhere);
    }
}else{
    WorkflowCodeSeqReservedTree.getWorkflowTreeList(envelope,type,subCompanyId,isTemplate,id,detachable,sqlwhere);
}

envelope.marshal(out);
%>
