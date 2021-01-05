<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
  String operation = Util.null2String(request.getParameter("operation"));
  if(operation.equalsIgnoreCase("deleteprocedure")){ 
	String ids[] = request.getParameterValues("delete_procedure_id") ;
	if(ids != null) {
		for(int i=0;i<ids.length;i++) {
			if(ids[i] != null) RecordSet.executeProc("ProcedureInfo_Delete",ids[i]);
		}
	}
  	response.sendRedirect("ManageProcedure.jsp");
  	return ;
  }
  else if(operation.equalsIgnoreCase("addprocedure")){ 
  	String procedurename = Util.fromScreen(request.getParameter("procedurename"),user.getLanguage());
	String proceduretable = Util.fromScreen(request.getParameter("proceduretable"),user.getLanguage());
	String procedurescript = Util.fromScreen(request.getParameter("procedurescript"),user.getLanguage());
	String proceduredesc = Util.fromScreen(request.getParameter("proceduredesc"),user.getLanguage());
	char separator = Util.getSeparator() ;
	String procedurepara = procedurename + separator + proceduretable + separator + procedurescript +
						   separator + proceduredesc ;
	RecordSet.executeProc("ProcedureInfo_Insert",procedurepara);

  	response.sendRedirect("ManageProcedure.jsp");
  	return ;
 }
 else if(operation.equalsIgnoreCase("updateprocedure")){ 
	String id = Util.null2String(request.getParameter("id"));
  	String procedurename = Util.fromScreen(request.getParameter("procedurename"),user.getLanguage());
	String proceduretable = Util.fromScreen(request.getParameter("proceduretable"),user.getLanguage());
	String procedurescript = Util.fromScreen(request.getParameter("procedurescript"),user.getLanguage());
	String proceduredesc = Util.fromScreen(request.getParameter("proceduredesc"),user.getLanguage());
  	char separator = Util.getSeparator() ;
	String procedurepara = id + separator + procedurename + separator + proceduretable + separator +                             procedurescript + separator + proceduredesc ;
	RecordSet.executeProc("ProcedureInfo_Update",procedurepara);

  	response.sendRedirect("ManageProcedure.jsp");
  	return ;
 }  
%>
