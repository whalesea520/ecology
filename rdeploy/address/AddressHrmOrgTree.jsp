
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.social.rdeploy.address.AddressHrmOrgTree"%>
<%@page import="org.json.JSONArray"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
AddressHrmOrgTree hrmOrg=new AddressHrmOrgTree(request,response);
String root = Util.null2String(request.getParameter("root"));
String operation = Util.null2String(request.getParameter("operation"));
response.setContentType("application/x-json; charset=UTF-8");
PrintWriter outPrint = response.getWriter();

if(operation.equals("hrmOrg")){
	outPrint.println(hrmOrg.getTreeData(root));
}else if(operation.equals("hrmGroup")){
	outPrint.println(hrmOrg.getTreeData2(root,user.getUID()+""));
}
%>

