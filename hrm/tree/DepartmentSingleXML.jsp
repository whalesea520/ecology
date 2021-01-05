<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.hrm.company.CompanyTreeNode"%><%@ page language="java" contentType="text/html; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String excludeid=Util.null2String(request.getParameter("excludeid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String subid=Util.null2String(request.getParameter("subid"));
int deptlevel = Util.getIntValue(request.getParameter("deptlevel"),2);
if(deptlevel==0){
	deptlevel=2;
}

//System.out.print("deptlevel"+deptlevel);
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
boolean exist=false;

if(nodeid.indexOf("dept")>-1){
String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_")))){
        exist=true;
        if(!excludeid.equals("")){
            String idInCookie=nodeid.substring(nodeid.lastIndexOf("_")+1);
            List l=new ArrayList();
            SubCompanyComInfo.getDepartTreeList(l,subcom,excludeid,0,999,"",null,null);
            for(Iterator iter=l.iterator();iter.hasNext();){
                   CompanyTreeNode node=(CompanyTreeNode)iter.next() ;
                   if(node.getType().equals("dept")&&node.getId().equals(idInCookie)){
                       exist=false;
                       break;
                   }
            }
        }

    }
}

if(!init.equals("")&&exist){
    TreeNode root=new TreeNode();
    String companyname =CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_0");
    root.setTarget("_self"); 
    root.setIcon("/images/treeimages/global_wev8.gif");
    envelope.addTreeNode(root);
    ArrayList l=new ArrayList();
    TreeNode node=new TreeNode();
    node.setNodeId(nodeid);
    l.add(node);
    if (excludeid.equals(""))
        SubCompanyComInfo.getAppDetachSubCompanyTreeList(root, true, "departmentSingle", l, user);
    else
        SubCompanyComInfo.getAppDetachSubCompanyTreeList(root, true, "departmentSingle", l,excludeid, user);

}else if(id.equals("")){
    TreeNode root=new TreeNode();
    String companyname =CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_0");
    root.setTarget("_self"); 
    root.setIcon("/images/treeimages/global_wev8.gif");
    envelope.addTreeNode(root);
    if (excludeid.equals(""))
        SubCompanyComInfo.getAppDetachSubCompanyTreeList(root, "0", 0, deptlevel, true, "departmentSingle", null, null, user);
    else
        SubCompanyComInfo.getAppDetachSubCompanyTreeList(root, "0", 0, deptlevel, true, "departmentSingle", null, null, excludeid, user);

} else {
    if (type.equals("com")) {
        if (excludeid.equals(""))
            SubCompanyComInfo.getAppDetachSubCompanyTreeList(envelope, id, 0, deptlevel, true, "departmentSingle", null, null, user);
        else
            SubCompanyComInfo.getAppDetachSubCompanyTreeList(envelope, id, 0, deptlevel, true, "departmentSingle", null, null, excludeid, user);
    } else {
        if (excludeid.equals(""))
            SubCompanyComInfo.getAppDetachDepartTreeList(envelope, subid, id, 0, deptlevel, "departmentSingle", null, null, user);
        else
            SubCompanyComInfo.getAppDetachDepartTreeList(envelope, subid, id, 0, deptlevel, "departmentSingle", null, null, excludeid, user);
    }
}

//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope,true);
%>
