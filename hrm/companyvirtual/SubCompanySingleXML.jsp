<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" /><%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser (request , response);
	if(user == null)
	{
	    return;
	}
	String virtualtype=Util.null2String(request.getParameter("virtualtype"));
	TreeNode envelope=new TreeNode();
	envelope.setTitle("envelope");

    TreeNode root = new TreeNode();
    String companyname = CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_"+virtualtype);
    root.setTarget("_self");
    root.setIcon("/images/treeimages/global_wev8.gif");

    envelope.addTreeNode(root);

    SubCompanyVirtualComInfo.getAppDetachSubCompanyTreeList(root,virtualtype,"0",0,10,false,"subcompanySingle",null,null,user);
	//envelope.marshal(out);
	weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>