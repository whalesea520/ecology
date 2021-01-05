<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String operation = Util.null2String(request.getParameter("operation"));
String id = Util.null2String(request.getParameter("id"));
String planid = Util.null2String(request.getParameter("planid"));
String type_n = Util.null2String(request.getParameter("type_n"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String seclevel = Util.null2String(request.getParameter("seclevel_from")); 
String seclevel_to = Util.null2String(request.getParameter("seclevel_to")); 

if(operation.equals("add")){
	rs.executeSql("insert into HrmTrainPlanRange(planid, type_n, resourceid, seclevel, seclevel_to)" 
							 + " values('"+planid+"','"+type_n+"','"+resourceid+"','"+seclevel+"','"+seclevel_to+"')");
	response.sendRedirect("HrmTrainPlanRangeAdd.jsp?isclose=1") ;
	return;
}if(operation.equals("edit")){
	rs.executeSql("update HrmTrainPlanRange set type_n='"+type_n+"', resourceid='"+resourceid+"', seclevel='"+seclevel+"', seclevel_to='"+seclevel_to+"' where id="+id);
	response.sendRedirect("HrmTrainPlanRangeEdit.jsp?isclose=1&id="+id) ;
	return;
}else if(operation.equals("delete")){
	rs.executeSql("delete HrmTrainPlanRange where id = "+id);
	response.sendRedirect("HrmTrainPlanRange.jsp?isclose=1") ;
	return;
}

%>