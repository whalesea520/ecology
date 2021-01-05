<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
String id = ""+user.getUID() ;
if( id.equals("1") ) {
    response.sendRedirect("/hrm/resource/HrmResourcePassword.jsp?id="+id) ;
    return ;
}
RecordSet.executeProc("HrmResource_SCountBySubordinat",id);
RecordSet.next();
int subordinatescount = RecordSet.getInt(1) ;
if(subordinatescount <= 0) {
	response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+id) ;
}
else {
	response.sendRedirect("HrmResourceView.jsp?id="+id) ;
}
%>