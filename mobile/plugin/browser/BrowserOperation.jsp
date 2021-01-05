
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.mobile.browser.BrowserService"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="MobileInit.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String operation=Util.null2String(request.getParameter("operation"));

BrowserService browserService=new BrowserService();
if(operation.equals("getUserList")){
	String sharetype=Util.null2String(request.getParameter("sharetype"));
	String shareid=Util.null2String(request.getParameter("shareid"));
	String seclevel=Util.null2String(request.getParameter("seclevel"));
	String rolelevel=Util.null2String(request.getParameter("rolelevel"));
	
	String userListStr=browserService.getUserList(sharetype,shareid,seclevel,rolelevel); 
	out.print(userListStr);
}else if(operation.equals("getWorkflowTtree")){
	int level=Util.getIntValue(fu.getParameter("level"),0);
	int nodeValue=Util.getIntValue(fu.getParameter("nodeValue"),0);
	
	String formids=Util.null2String(fu.getParameter("formids"));
	
	String selectids=Util.null2String(fu.getParameter("selectids"));
	String workflowTreeStr=browserService.getWorkflowTtree(level,nodeValue,formids,selectids);
	out.print(workflowTreeStr);
}else if(operation.equals("getHrmOrgChildren")){   //获得组织架构下级id
	String suptype = Util.null2String(request.getParameter("suptype"));
	String subId = Util.null2String(request.getParameter("subId"));
	ArrayList departMentList = new ArrayList();
	String returnStr = "";
	if("com".equals(suptype)){
	    departMentList = SubCompanyComInfo.getSubDepartmentStrByEditRight(subId,departMentList);
	    for(int i=0;i<departMentList.size();i++){
	        returnStr = returnStr + departMentList.get(i) + ",";
	    }
	}else if("dep".equals(suptype)){
	    departMentList = SubCompanyComInfo.getsubDepartmentStr(subId,departMentList);
	    for(int i=0;i<departMentList.size();i++){
	        returnStr = returnStr + departMentList.get(i) + ",";
	    }
	}else if("subcom".equals(suptype)){
	    departMentList = SubCompanyComInfo.getsubCompanyStr(subId,departMentList);
	    for(int i=0;i<departMentList.size();i++){
	        returnStr = returnStr + departMentList.get(i) + ",";
	    }
	}
	out.println(returnStr);
}
%>