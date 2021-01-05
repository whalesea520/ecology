<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" /><%

String virtualtype=Util.null2String(request.getParameter("virtualtype"));

String subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0)+"";

String notCompany = Util.null2String(request.getParameter("notCompany"));
int deptlevel = 99;
//isedit如果为1则显示具有编辑权限以上的分部
int isedit=Util.getIntValue(request.getParameter("isedit"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

    String excludeid=Util.null2String(request.getParameter("excludeid"));
    TreeNode root=new TreeNode();
    String companyname = CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_"+virtualtype);
    root.setTarget("_self");
    root.setIcon("/images/treeimages/global_wev8.gif");
    //root.setHref("javascript:setCompany('com_1')");
    envelope.addTreeNode(root);
    if(isedit==1){
	    if (excludeid.equals("")){
	        if("1".equals(notCompany)){
	            SubCompanyVirtualComInfo.getContainSubDepartmentTreeListByEditRight(root,"0",0,deptlevel,true,"departmentSingleByRight",null,null,subcompanyid);
	        }else{
	        	SubCompanyVirtualComInfo.getSubCompanyTreeListByEditRight(root,"0",0,deptlevel,true,"departmentSingleByRight",null,null);
	        }
	    }else{
	        if("1".equals(notCompany)){
	            SubCompanyVirtualComInfo.getContainSubDepartmentTreeListByEditRight(root,"0",0,deptlevel,true,"departmentSingleByRight",null,null,subcompanyid,excludeid);
	        }else{
	            SubCompanyVirtualComInfo.getSubCompanyTreeListByEditRight(root,"0",0,deptlevel,true,"departmentSingleByRight",null,null,excludeid);
	        }
	    }
	}else{
	    if (excludeid.equals(""))
	    	SubCompanyVirtualComInfo.getSubCompanyTreeListByRight(root,"0",0,deptlevel,true,"departmentSingleByRight",null,null);
	    else
	    	SubCompanyVirtualComInfo.getSubCompanyTreeListByRight(root,"0",0,deptlevel,true,"departmentSingleByRight",null,null,excludeid);
	}
envelope.marshal(out);
%>