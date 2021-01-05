<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%
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

String rightStr=Util.null2String(request.getParameter("rightStr"));
int isedit=0;//Util.getIntValue(request.getParameter("isedit"),1);
String excludeid=Util.null2String(request.getParameter("excludeid"));

String id = Util.null2String(request.getParameter("id"));
String subid=Util.null2String(request.getParameter("subid"));
String nodeids=Util.null2String(request.getParameter("nodeids"));
String type = Util.null2String(request.getParameter("type"));

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
TreeNode root=new TreeNode();
String companyname =CompanyComInfo.getCompanyname("1");
root.setTitle(companyname);
root.setNodeId("com_0");
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");


if(isedit==1){
	SubCompanyComInfo.getSubCompanyTreeListByEditRight(user.getUID(),rightStr);
	if(id.equals("")&&nodeids.equals("")) {
		envelope.addTreeNode(root);
       	if (excludeid.equals("")){
        	SubCompanyComInfo.getSubCompanyTreeListByEditRight(root,"0",0,2,true,"departmentMultiByRight",null,null);
       	}else{
	        SubCompanyComInfo.getSubCompanyTreeListByEditRight(root,"0",0,2,true,"departmentMultiByRight",null,null,excludeid);
       	}
	}
	if (!"".equals(id)) {
		if (type.equals("com")) {
        	if (excludeid.equals("")){
		        SubCompanyComInfo.getSubCompanyTreeListByEditRight(envelope,id,0,2,true,"departmentMultiByRight",null,null);
        	}else{
		        SubCompanyComInfo.getSubCompanyTreeListByEditRight(envelope,id,0,2,true,"departmentMultiByRight",null,null,excludeid);
        	}
		}else{
    		SubCompanyComInfo.getDepartTreeListByDec(envelope,subid,id,0,2,"departmentMultiByRight",null,null,true);
		}
	} 
	
}else{
	SubCompanyComInfo.getSubCompanyTreeListByRight(user.getUID(),rightStr);
	if(id.equals("")&&nodeids.equals("")) {
		envelope.addTreeNode(root);
       	if (excludeid.equals("")){
        	SubCompanyComInfo.getSubCompanyTreeListByRight(root,"0",0,2,true,"departmentMultiByRight",null,null);
       	}else{
	        SubCompanyComInfo.getSubCompanyTreeListByRight(root,"0",0,2,true,"departmentMultiByRight",null,null,excludeid);
       	}
	}
	if (!"".equals(id)) {
		if (type.equals("com")) {
        	if (excludeid.equals("")){
		        SubCompanyComInfo.getSubCompanyTreeListByRight(envelope,id,0,2,true,"departmentMultiByRight",null,null);
        	}else{
		        SubCompanyComInfo.getSubCompanyTreeListByRight(envelope,id,0,2,true,"departmentMultiByRight",null,null,excludeid);
        	}
		}else{
    		SubCompanyComInfo.getDepartTreeListByDec(envelope,subid,id,0,2,"departmentMultiByRight",null,null,true);
		}
	} 
}
    
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>
