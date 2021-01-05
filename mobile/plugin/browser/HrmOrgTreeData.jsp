
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="MobileInit.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
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
String browserType=Util.null2String(request.getParameter("browserType"));
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
    if(browserType.equals("departmentSingle")||browserType.equals("departmentMulti")||browserType.equals("resourceMulti")||browserType.equals("resourceSingle")){
	    if (excludeid.equals(""))
	    	SubCompanyComInfo.getAppDetachSubCompanyTreeList(root, "0", 0, deptlevel, true, "departmentSingle", null, null, user);
	    else
	    	SubCompanyComInfo.getAppDetachSubCompanyTreeList(root, "0", 0, deptlevel, true, "departmentSingle", null, null, excludeid, user);
    }else if(browserType.equals("subcompanyMuti")){
    	if (excludeid.equals(""))
    	    SubCompanyComInfo.getSubCompanyTreeList(root,"0",0,10,false,"subcompanyMutiByRight",null,null);
    	else
    	    SubCompanyComInfo.getSubCompanyTreeList(root,"0",0,10,false,"subcompanyMutiByRight",null,null,excludeid);
    }else if(browserType.equals("subcompanySingle")){
    	 if (excludeid.equals("")){
    	    SubCompanyComInfo.getAppDetachSubCompanyTreeList(root,"0",0,10,false,"subcompanySingle",null,null,user);
    	 }else{
    	    SubCompanyComInfo.getAppDetachSubCompanyTreeList(root,"0",0,10,false,"subcompanySingle",null,null,excludeid,user);
    	 }
    }

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
Map iconMap=new HashMap();
iconMap.put("subcompanyIcon","/plugin/ecology/js/zTree/css/zTreeStyle/img/Home_wev8.gif");
iconMap.put("departmentIcon","/plugin/ecology/js/zTree/css/zTreeStyle/img/subCopany_Colse_wev8.gif");
//weaver.common.util.string.StringUtil.parseXml(out, envelope,iconMap);  
weaver.common.util.string.StringUtil.parseXml(out,envelope);
%>