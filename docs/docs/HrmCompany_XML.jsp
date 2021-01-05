<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String subid=Util.null2String(request.getParameter("subid"));
boolean showdept=Util.null2String(request.getParameter("showdept")).toLowerCase().equals("false")?false:true;
String rightStr=Util.null2String(request.getParameter("rightStr"));
int userid = user.getUID();

if(!HrmUserVarify.checkUserRight(rightStr, user)){
    return ;
}
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
SubCompanyComInfo.setUser(user);
    if(id.equals("")){
    TreeNode root=new TreeNode();
    String companyname =CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_1");
    root.setTarget("_self"); 
    root.setIcon("/images/treeimages/global_wev8.gif");
    root.setHref("javascript:setCompany('com_1')");
    envelope.addTreeNode(root);
    SubCompanyComInfo.getSubCompanyTreeListByRight(userid,rightStr);
    SubCompanyComInfo.getSubCompanyTreeListByRight(root,"0",0,2,showdept,"hrmStructure",null,null);
    }else{
        if (type.equals("com")){
            SubCompanyComInfo.getSubCompanyTreeListByRight(userid,rightStr);
            SubCompanyComInfo.getSubCompanyTreeListByRight(envelope, id, 0, 2, showdept, "hrmStructure", null, null);
        }
        else
            SubCompanyComInfo.getDepartTreeList(envelope, subid, id, 0, 2, "hrmStructure", null, null);
    }

envelope.marshal(out);
%>