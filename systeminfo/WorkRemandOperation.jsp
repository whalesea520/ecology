<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char flag=2;
String src=Util.null2String(request.getParameter("src"));
String type=Util.null2String(request.getParameter("type"));
String paraid=Util.null2String(request.getParameter("paraid"));

if(src.equals("delete")){
    if(type.equals("time")){
        RecordSet.executeProc("bill_HrmTime_UpdateRemind",paraid+flag+"0");
    }
    if(type.equals("finance")){
        RecordSet.executeProc("bill_HrmFinance_UpdateRemind",paraid+flag+"0");
    }
    response.sendRedirect("/system/homepage/HomePageWorkRemind.jsp");
}
%>