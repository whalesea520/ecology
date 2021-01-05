<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.tree.HrmOrgTree"%>
<%
HrmOrgTree hrmOrg=new HrmOrgTree(request,response);
String root = Util.null2String(request.getParameter("root"));
int onlysub = Util.getIntValue(request.getParameter("onlysub"),0);
int ifShowHrm = Util.getIntValue(request.getParameter("ifShowHrm"),1);
hrmOrg.setOnlysub(onlysub);
hrmOrg.setIfshowhrm(ifShowHrm);
response.setContentType("application/x-json; charset=UTF-8");
PrintWriter outPrint = response.getWriter();
outPrint.println(hrmOrg.getTreeData(root));
%>

