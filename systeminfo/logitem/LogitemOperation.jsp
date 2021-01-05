<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
  String operation = Util.null2String(request.getParameter("operation"));
  if(operation.equalsIgnoreCase("deletelogitem")){ 
	String ids[] = request.getParameterValues("delete_logitem_id") ;
	if(ids != null) {
		for(int i=0;i<ids.length;i++) {
			if(ids[i] != null) RecordSet.executeProc("SystemLogItem_Delete",ids[i]);
		}
	}
  	response.sendRedirect("ManageLogitem.jsp");
  	return ;
  }
  else if(operation.equalsIgnoreCase("addlogitem")){ 
  	String itemid = Util.fromScreen(request.getParameter("itemid"),user.getLanguage());
	String lableid = Util.fromScreen(request.getParameter("lableid"),user.getLanguage());
	String itemdesc = Util.fromScreen(request.getParameter("itemdesc"),user.getLanguage());
	char separator = Util.getSeparator() ;
	String logitempara = itemid + separator + lableid + separator + itemdesc ;
	RecordSet.executeProc("SystemLogItem_Insert",logitempara);

  	response.sendRedirect("ManageLogitem.jsp");
  	return ;
 }
 else if(operation.equalsIgnoreCase("updatelogitem")){ 
	String itemid = Util.null2String(request.getParameter("itemid"));
  	String lableid = Util.fromScreen(request.getParameter("lableid"),user.getLanguage());
	String itemdesc = Util.fromScreen(request.getParameter("itemdesc"),user.getLanguage());
  	char separator = Util.getSeparator() ;
	String logitempara = itemid + separator + lableid + separator + itemdesc ;
	RecordSet.executeProc("SystemLogItem_Update",logitempara);

  	response.sendRedirect("ManageLogitem.jsp");
  	return ;
 }  
%>
