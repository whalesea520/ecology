<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.resource.TreeNode"%>
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.company.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@page import="weaver.hrm.resource.MutilResourceBrowser"%>
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page" /><jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%!
public TreeNode getSubCompanyTreeList(TreeNode companyTreeList, String subId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
	getDepartTreeList(companyTreeList, subId, "0",selectedids,isNoAccount, user, sqlwhere);
	
	SubCompanyComInfo rs = new SubCompanyComInfo();
	rs.setTofirstRow();
	while (rs.next()) {
		String id = rs.getSubCompanyid();
		String supsubcomid = rs.getSupsubcomid();
		if (supsubcomid.equals(""))supsubcomid = "0";
		if (!supsubcomid.equals(subId))continue;
		String name = rs.getSubCompanyname();
		 String canceled = rs.getCompanyiscanceled();
		
		TreeNode subCompanyNode = new TreeNode();
		subCompanyNode.setName(name);
		subCompanyNode.setId(id);
		subCompanyNode.setPid(subId);
		subCompanyNode.setNodeid("subcom_"+id);
		subCompanyNode.setPid(subId);
		subCompanyNode.setIcon("/rdeploy/assets/img/hrm/dep.png");
		subCompanyNode.setNocheck("N");
		if(hasChild("subcompany",id)){
			subCompanyNode.setIsParent("true");
		}
		subCompanyNode.setType("subcom");
		if(!"1".equals(canceled))companyTreeList.AddChildren(subCompanyNode);
		//getSubCompanyTreeList(subCompanyNode, id);
	}
	return companyTreeList;
}

public TreeNode getDepartTreeList(TreeNode departTreeList, String subId, String departmentId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
    DepartmentComInfo rsDepartment = new DepartmentComInfo();
    rsDepartment.setTofirstRow();
   
    if(departmentId.length()>0){
    	//getResourceTreeList(departTreeList, departmentId,selectedids, isNoAccount, user, sqlwhere);
    }
    while (rsDepartment.next()) {
        if(departmentId.equals(rsDepartment.getDepartmentid()))continue;
        String supdepid = rsDepartment.getDepartmentsupdepid();
        if (departmentId.equals("0") && supdepid.equals(""))supdepid = "0";
        if (!(rsDepartment.getSubcompanyid1().equals(subId) && (supdepid.equals(departmentId)||(!rsDepartment.getSubcompanyid1(supdepid).equals(subId)&&departmentId.equals("0"))))) continue;

        String id = rsDepartment.getDepartmentid();
        String name = rsDepartment.getDepartmentname();
        String canceled = rsDepartment.getDeparmentcanceled();

        TreeNode departmentNode = new TreeNode();
        departmentNode.setName(name);
        departmentNode.setPid(rsDepartment.getDepartmentsupdepid());
        departmentNode.setNocheck("Y");
        departmentNode.setId(id);
        departmentNode.setNodeid("dept_"+id);
        departmentNode.setIcon("#");
        if (hasChild("dept", id)) {
        	departmentNode.setIsParent("true");
        }
        departmentNode.setType("dept");
        if(!"1".equals(canceled))departTreeList.AddChildren(departmentNode);
    }

      return departTreeList;
  }

/**
 * 指定节点下是否有子节点
 * @param type  com:分部;dept:部门
 * @param id   节点id
 * @return  boolean
 * @throws Exception
 */
private boolean hasChild(String type, String id) throws Exception {
	boolean hasChild = false;
  if (type.equals("subcompany")) {
		SubCompanyComInfo rs = new SubCompanyComInfo();
		rs.setTofirstRow();
		while (rs.next()) {
			if (rs.getSupsubcomid().equals(id) && !"1".equals(rs.getCompanyiscanceled()))
				hasChild = true;
		}
		DepartmentComInfo rsDepartment = new DepartmentComInfo();
		rsDepartment.setTofirstRow();
		while (rsDepartment.next()) {
			if (rsDepartment.getSubcompanyid1().equals(id) && !"1".equals(rsDepartment.getDeparmentcanceled())) {
				hasChild = true;
			}
		}
	} else if (type.equals("dept")) {
		DepartmentComInfo rsDepartment = new DepartmentComInfo();
		rsDepartment.setTofirstRow();
		while (rsDepartment.next()) {
			String str = rsDepartment.getSubcompanyid1(id);
			if (rsDepartment.getSubcompanyid1().equals(str) && rsDepartment.getDepartmentsupdepid().equals(id) && !"1".equals(rsDepartment.getDeparmentcanceled()))
				hasChild = true;
		}
	}
	return hasChild;
}


%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String id=Util.null2String(request.getParameter("id"));
String subcomid=Util.null2String(request.getParameter("subcomid"));
String type=Util.null2String(request.getParameter("type"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String alllevel=Util.null2String(request.getParameter("alllevel"));
String isNoAccount=Util.null2String(request.getParameter("isNoAccount"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String cmd=Util.null2String(request.getParameter("cmd"));

selectedids = MutilResourceBrowser.getExcludeSqlWhere(selectedids,alllevel,isNoAccount,user, sqlwhere);

ArrayList selectList = new ArrayList();
if(selectedids.length()>0){
	String[] tmp_selectedids = selectedids.split(",");
	for(String selectedid:tmp_selectedids){
		selectList.add(selectedid);
	}
}
JSONArray jObject = null;
TreeNode envelope=new TreeNode();
if(cmd.equals("getVirtualType")){
	if(CompanyVirtualComInfo.getCompanyNum()>0){
		TreeNode root = new TreeNode();
		TreeNode node = new TreeNode();
		if(CompanyComInfo.getCompanyNum()>0){
			CompanyComInfo.setTofirstRow();
			while(CompanyComInfo.next()){
				node = new TreeNode();
				String dfvirtualtypename = CompanyComInfo.getCompanyname();
				node.setId(CompanyComInfo.getCompanyid());
				node.setName(dfvirtualtypename.length()>4?dfvirtualtypename.substring(0,4):dfvirtualtypename);
				root.AddChildren(node);
			}
		}
		if(CompanyVirtualComInfo.getCompanyNum()>0){
			CompanyVirtualComInfo.setTofirstRow();
			while(CompanyVirtualComInfo.next()){
				node = new TreeNode();
				String dfvirtualtypename = CompanyVirtualComInfo.getVirtualType();
				node.setId(CompanyVirtualComInfo.getCompanyid());
				node.setName(dfvirtualtypename.length()>4?dfvirtualtypename.substring(0,4):dfvirtualtypename);
				root.AddChildren(node);
			}
		}
		jObject = JSONArray.fromObject(root.getChildren());	
		out.println(jObject.toString());
	}
}else{
	if(id.equals("")){
		//初始化
		TreeNode root = new TreeNode();
		SubCompanyComInfo rs = new SubCompanyComInfo();
		String companyname = rs.getSubCompanyname(subcomid);
		root.setNodeid("subcom_"+subcomid);
		root.setName(companyname);
		root.setId(subcomid);
		root.setOpen("true");
		root.setTarget("_self"); 
	    root.setIcon("/rdeploy/assets/img/hrm/dep.png");
		root.setType("subcom");
		getSubCompanyTreeList(root,subcomid,selectList,isNoAccount, user, sqlwhere);
		jObject = JSONArray.fromObject(root);
	}else if(type.equals("subcom")){
		getSubCompanyTreeList(envelope,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}else if(type.equals("dept")){
		DepartmentComInfo DepartmentComInfo = new DepartmentComInfo();
		String subId = DepartmentComInfo.getSubcompanyid1(id);
		getDepartTreeList(envelope,subId,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}
	//System.out.println(jObject.toString());
	out.println(jObject.toString());
}
%>