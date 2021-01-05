<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><%

String rightStr=Util.null2String(request.getParameter("rightStr"));
//isedit如果为1则显示具有编辑权限以上的分部    
int isedit=Util.getIntValue(request.getParameter("isedit"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

    String excludeid=Util.null2String(request.getParameter("excludeid"));
    TreeNode root=new TreeNode();
    String companyname =CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_0");
    root.setTarget("_self");
    root.setIcon("/images/treeimages/global_wev8.gif");
    //root.setHref("javascript:setCompany('com_1')");
    envelope.addTreeNode(root);
    if(isedit==1){
        SubCompanyComInfo.getSubCompanyTreeListByEditRight(user.getUID(),rightStr);
        if (excludeid.equals("")){
        SubCompanyComInfo.getSubCompanyTreeListByEditRight(root,"0",0,10,false,"subcopanySingleByRight",null,null);
        }
        else{
        SubCompanyComInfo.getSubCompanyTreeListByEditRight(root,"0",0,10,false,"subcopanySingleByRight",null,null,excludeid);
        }
    }else{
        SubCompanyComInfo.getSubCompanyTreeListByRight(user.getUID(),rightStr);
        if (excludeid.equals(""))
        SubCompanyComInfo.getSubCompanyTreeListByRight(root,"0",0,10,false,"subcopanySingleByRight",null,null);
        else
        SubCompanyComInfo.getSubCompanyTreeListByRight(root,"0",0,10,false,"subcopanySingleByRight",null,null,excludeid);
    }

envelope.marshal(out);
%>
