
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String paravalue=Util.fromScreen(request.getParameter("paravalue"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
if(operation.equals("add")){
    char separator = Util.getSeparator() ;
	String para = name + separator + paravalue + separator + description;
	RecordSet.executeProc("CarParameter_Insert",para); 	
}
 
else if(operation.equals("edit")){
    char separator = Util.getSeparator() ;
  	String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
	String para = id + separator + name + separator + paravalue + separator + description;
	RecordSet.executeProc("CarParameter_Update",para);
}

else if(operation.equals("delete")){
    char separator = Util.getSeparator() ;
  	String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
	String para = id;
	RecordSet.executeProc("CarParameter_Delete",para);
}
response.sendRedirect("CarParameterList.jsp");
%>
