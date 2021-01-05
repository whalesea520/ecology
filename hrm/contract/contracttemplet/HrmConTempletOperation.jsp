<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String templetname = Util.fromScreen(request.getParameter("templetname"),user.getLanguage());
String mouldtext = Util.fromScreen(request.getParameter("mouldtext"),user.getLanguage());
String templetdocid = Util.fromScreen(request.getParameter("templetdocid"),user.getLanguage());

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String para = "";
char separator = Util.getSeparator() ;

if(operation.equalsIgnoreCase("edit")){
  para = ""+id+separator+templetname+separator+templetdocid+separator+mouldtext;
  out.println(para);
  rs.executeProc("HrmConTemplet_Update",para);
  response.sendRedirect("HrmContractTemplet.jsp");
  return;
}

if(operation.equalsIgnoreCase("add")){
  para = templetname+separator+mouldtext;
  out.println(para);
  rs.executeProc("HrmConTemplet_Insert",para);
  response.sendRedirect("HrmContractTemplet.jsp");
  return;
}

if(operation.equalsIgnoreCase("delete")){
  para = ""+id;
  out.println(para);
  rs.executeProc("HrmConTemplet_Delete",para);
  response.sendRedirect("HrmContractTemplet.jsp");
  return;
}
%>