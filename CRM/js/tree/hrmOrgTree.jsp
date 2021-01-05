
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.credit.HrmOrgTree"%>
<%
HrmOrgTree hrmOrg=new HrmOrgTree(request,response); 
String root = Util.null2String(request.getParameter("root"));
int onlysub = Util.getIntValue(request.getParameter("onlysub"),0);
hrmOrg.setOnlysub(onlysub);
response.setContentType("application/x-json; charset=UTF-8");
PrintWriter outPrint = response.getWriter();
outPrint.println(hrmOrg.getTreeData(root));
%>

