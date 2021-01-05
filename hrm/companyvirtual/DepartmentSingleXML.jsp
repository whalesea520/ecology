<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.hrm.company.CompanyTreeNode"%><%@ page language="java" contentType="text/html; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String subid=Util.null2String(request.getParameter("subid"));
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
int deptlevel = Util.getIntValue(request.getParameter("deptlevel"),2);
if(deptlevel==0){
	deptlevel=2;
}

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
if(id.equals("")){
    TreeNode root=new TreeNode();
    String companyname = CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_"+virtualtype);
    root.setTarget("_self"); 
    root.setIcon("/images/treeimages/global_wev8.gif");
    envelope.addTreeNode(root);
    SubCompanyVirtualComInfo.getAppDetachSubCompanyTreeList(root, virtualtype,"0", 0, deptlevel, true, "departmentSingle", null, null, user, subcompanyid);
} else {
    if (type.equals("com")) {
       SubCompanyVirtualComInfo.getAppDetachSubCompanyTreeList(envelope,virtualtype, id, 0, deptlevel, true, "departmentSingle", null, null, user, subcompanyid);
    } else {
    		ArrayList ls=null;
    		if(nodeid.length()>0){
		      ls=new ArrayList();
		      TreeNode node=new TreeNode();
		      node.setNodeId(nodeid);
		      ls.add(node);
    		}
       SubCompanyVirtualComInfo.getAppDetachDepartTreeList(envelope, subid, id, 0, deptlevel, "departmentSingle", null, ls, user);
    }
}

//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>
