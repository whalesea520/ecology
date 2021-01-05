<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.social.HrmOrgTree"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	return;
}
request.setAttribute("user",user);
HrmOrgTree hrmOrg=new HrmOrgTree(request,response);
String root = Util.null2String(request.getParameter("root"));
String groupid = Util.null2String(request.getParameter("groupid"));
String operation = Util.null2String(request.getParameter("operation"));
response.setContentType("application/x-json; charset=UTF-8");
//PrintWriter outPrint = response.getWriter();

if(operation.equals("hrmOrg")){
	out.println(hrmOrg.getTreeData(root));
}else if(operation.equals("hrmGroup")){
	out.println(hrmOrg.getTreeData2(groupid.isEmpty()?root: groupid,user));
}


%>

