<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page language="java" contentType="text/xml; charset=GBK" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String subid=Util.null2String(request.getParameter("subid"));

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

boolean exist=false;
if(nodeid.indexOf("com")>-1){
exist=SubCompanyComInfo.getSubCompanyname(nodeid.substring(nodeid.lastIndexOf("_")+1)).equals("")?false:true;
}else if(nodeid.indexOf("dept")>-1){
String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}

if(!init.equals("")&&exist){
TreeNode root=new TreeNode();
String companyname =CompanyComInfo.getCompanyname("1");
root.setTitle(companyname);
root.setNodeId("com_0");
root.setHref("javascript:setCompany(0)");
root.setTarget("_self"); 
root.setIcon("/images/treeimages/global.gif");
envelope.addTreeNode(root);
ArrayList l=new ArrayList();
TreeNode node=new TreeNode();
node.setNodeId(nodeid);
l.add(node);
SubCompanyComInfo.getSubCompanyTreeList(root,true,"resourceSingle",l);
}else if(id.equals("")){
TreeNode root=new TreeNode();
String companyname =CompanyComInfo.getCompanyname("1");
root.setTitle(companyname);
root.setNodeId("com_0");
root.setHref("javascript:setCompany(0)");
root.setTarget("_self"); 
root.setIcon("/images/treeimages/global.gif");
envelope.addTreeNode(root);


SubCompanyComInfo.getSubCompanyHrmTreeList(root,"0",0,3,true,"resourceSingle",null,null);

}else{
  if(type.equals("com")) 
    SubCompanyComInfo.getSubCompanyHrmTreeList(envelope,id,0,2,true,"resourceSingle",null,null);
  else if(type.equals("dept"))
    SubCompanyComInfo.getDepartHrmTreeList(envelope,subid,id,0,2,"resourceSingle",null,null);
  else 
    SubCompanyComInfo.getHrmTreeList(envelope,subid,id,0,2,"",null,null);
}

envelope.marshal(out);
%>