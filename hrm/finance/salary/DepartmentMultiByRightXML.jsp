<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
String rightStr=Util.null2String(request.getParameter("rightStr"));
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
String scope=Util.null2String(request.getParameter("scope"));
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><%
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
    TreeNode root=new TreeNode();
    if (scope.equals("0")) {
    String companyname =CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_0");
    root.setTarget("_self");
    root.setIcon("/images/treeimages/global_wev8.gif");
    }else{
        String subcompanyname =SubCompanyComInfo.getSubCompanyname(subcompanyid);
        root.setTitle(subcompanyname);
        root.setNodeId("com_"+subcompanyid);
        root.setTarget("_self");
        root.setIcon("/images/treeimages/Home_wev8.gif");
    }


    //root.setHref("javascript:setCompany('com_1')");
    envelope.addTreeNode(root);
    SubCompanyComInfo.getSubCompanyTreeListByEditRight(user.getUID(),rightStr);
    if (scope.equals("0"))
    SubCompanyComInfo.getSubCompanyTreeListByEditRight(root,"0",0,100,true,"departmentMultiByRight",null,null);
    else if(scope.equals("1"))
     SubCompanyComInfo.getDepartTreeList(root,subcompanyid,"0",0,100,"departmentMultiByRight",null,null);    
    else if(scope.equals("2"))    
     SubCompanyComInfo.getSubCompanyTreeListByEditRight(root,subcompanyid,0,100,true,"departmentMultiByRight",null,null);
envelope.marshal(out);
%>
