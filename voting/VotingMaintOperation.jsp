
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char flag=2 ;
String Procpara="";

String method=Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String createrid = Util.null2String(request.getParameter("createrid"));
String approverid = Util.null2String(request.getParameter("approverid"));

if(method.equals("add")){
    Procpara=createrid+flag+approverid ;
    RecordSet.executeProc("VotingMaintDetail_Insert",Procpara);
}
if(method.equals("delete")){
    RecordSet.executeProc("VotingMaintDetail_Delete",id);
}
response.sendRedirect("VotingMaint.jsp");
return ;
%>