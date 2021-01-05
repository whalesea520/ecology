<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String subid=Util.null2String(request.getParameter("subid"));
boolean showdept=Util.null2String(request.getParameter("showdept")).toLowerCase().equals("false")?false:true;
String rightStr=Util.null2String(request.getParameter("rightStr"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
int userid = user.getUID();
if(rightStr.equals("showAllSubCompany")) userid = 1;

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if(id.equals("")){
	TreeNode root=new TreeNode();
	String companyname = CompanyComInfo.getCompanyname("1");
	root.setTitle(companyname);
	root.setNodeId("com_"+virtualtype);
	root.setTarget("_self"); 
	root.setIcon("/images/treeimages/Home_wev8.gif");
	root.setHref("javascript:setCompany('com_"+virtualtype+"')");
	envelope.addTreeNode(root);
	SubCompanyVirtualComInfo.getSubCompanyTreeListByRight(root,virtualtype,"0",0,2,showdept,"hrmStructure",null,null);
}else{
	if (type.equals("com")){
		SubCompanyVirtualComInfo.getSubCompanyTreeListByRight(envelope, virtualtype, id, 0, 2, showdept, "hrmStructure", null, null);
	}else{
    SubCompanyVirtualComInfo.getDepartTreeList(envelope, subid, id, 0, 2, "hrmStructure", null, null);
  }
}
envelope.marshal(out);
%>