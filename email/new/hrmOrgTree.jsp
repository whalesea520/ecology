
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.blog.HrmOrgTree"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
request.setAttribute("user",user);
String isaccount = Util.null2String(request.getParameter("isaccount"));
request.setAttribute("isaccount",isaccount);
HrmOrgTree hrmOrg=new HrmOrgTree(request,response);
String root = Util.null2String(request.getParameter("root"));
String operation = Util.null2String(request.getParameter("operation"));
String hrmtype = Util.null2String(request.getParameter("hrmtype"));
String objid = Util.null2String(request.getParameter("objid"));
hrmOrg.setTreeType("email");
response.setContentType("application/x-json; charset=UTF-8");
PrintWriter outPrint = response.getWriter();
//outPrint.println(hrmOrg.getTreeData2(root,user.getUID()+""));
if(operation.equals("innerHrm")){
	outPrint.println(hrmOrg.getTreeData(root));
}else if(operation.equals("getHrm")){
	ResourceComInfo resourceComInfo=new ResourceComInfo();
	
	JSONArray returnObj=new JSONArray();
	resourceComInfo.setTofirstRow();
	while(resourceComInfo.next()){
		String status=resourceComInfo.getStatus(); //状态
		if(status.equals("0")||status.equals("1")||status.equals("2")||status.equals("3")){
			
			String resourceid=resourceComInfo.getResourceid();
			String subcompanyid=resourceComInfo.getSubCompanyID();
			String departmentid=resourceComInfo.getDepartmentID();
			String lastname=resourceComInfo.getLastname();
			String email=resourceComInfo.getEmail();
			String loginId = resourceComInfo.getLoginID();
			
			if((hrmtype.equals("2")&&subcompanyid.equals(objid))||(hrmtype.equals("3")&&departmentid.equals(objid))||(hrmtype.equals("1")&&
					resourceid.equals(objid))){
				if(loginId != null && !"".equals(loginId)){
					JSONObject subObj=new JSONObject();
					subObj.put("text", lastname);
					subObj.put("id", resourceid);
					subObj.put("dpid", departmentid);
					subObj.put("email", email);
					returnObj.put(subObj);
				}
				
			} 
		}
	}	
	outPrint.print(returnObj);
}else{
	//outPrint.println(hrmOrg.getTreeData2(root,user.getUID()+""));
	outPrint.println(hrmOrg.getTreeDataComm(root,user.getUID()+""));
}
%>

