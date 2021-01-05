
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageSystemModule.jsp");
    return;
}

String moduleName=""; 
String moduleReleased=""; 

moduleName = Util.null2String(request.getParameter("moduleName"));
moduleReleased = Util.null2String(request.getParameter("moduleReleased"));

%>

