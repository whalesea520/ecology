<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String operation = Util.null2String(request.getParameter("operation"));
String id = Util.null2String(request.getParameter("id"));
String sharetype = Util.null2String(request.getParameter("sharetype"));
String relatedId = Util.null2String(request.getParameter("relatedId"));
String level_from = Util.null2String(request.getParameter("level_from")); 
String level_to = Util.null2String(request.getParameter("level_to")); 

if(operation.equals("add")){
	rs.executeSql("insert into HrmArrangeShiftSet(sharetype, relatedId, level_from, level_to)" 
							 + " values('"+sharetype+"','"+relatedId+"','"+level_from+"','"+level_to+"')");
	response.sendRedirect("HrmArrangeShiftSetAdd.jsp?isclose=1") ;
}if(operation.equals("edit")){
	rs.executeSql("update HrmArrangeShiftSet set sharetype='"+sharetype+"', relatedId='"+relatedId+"', level_from='"+level_from+"', level_to='"+level_to+"' where id="+id);
	response.sendRedirect("HrmArrangeShiftSetEdit.jsp?isclose=1&id="+id) ;
}else if(operation.equals("delete")){
	rs.executeSql("delete HrmArrangeShiftSet where id = "+id);
	response.sendRedirect("HrmArrangeShiftSet.jsp?isclose=1") ;
}

%>