<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
  String operation = Util.null2String(request.getParameter("operation"));
  String resourceid = Util.null2String(request.getParameter("resourceid"));
  String jobactivity = Util.null2String(request.getParameter("jobactivity"));
  if(operation.equalsIgnoreCase("deleteskill")){ 
	String ids[] = request.getParameterValues("id") ;
	if(ids != null) {
		for(int i=0;i<ids.length;i++) {
			if(ids[i] != null) RecordSet.executeProc("HrmResourceSkill_Delete",ids[i]);
		}
	}
  	response.sendRedirect("HrmResourceSkill.jsp?id="+resourceid+"&jobactivity="+jobactivity);
  	return ;
  }
  else if(operation.equalsIgnoreCase("addskill")){ 
	char separator = Util.getSeparator() ;
	String skilldesc = Util.fromScreen(request.getParameter("skilldesc"),user.getLanguage());
	String skillpara = resourceid + separator + skilldesc ;
	RecordSet.executeProc("HrmResourceSkill_Insert",skillpara);

  	response.sendRedirect("HrmResourceSkill.jsp?id="+resourceid+"&jobactivity="+jobactivity);
  	return ;
 }
 else if(operation.equalsIgnoreCase("editskill")){ 
	String id = Util.null2String(request.getParameter("id"));
  	String skilldesc = Util.fromScreen(request.getParameter("skilldesc"),user.getLanguage());
  	char separator = Util.getSeparator() ;
	String skillpara = id + separator + skilldesc;
	RecordSet.executeProc("HrmResourceSkill_Update",skillpara);

  	response.sendRedirect("HrmResourceSkill.jsp?id="+resourceid+"&jobactivity="+jobactivity);
  	return ;
 }  
%>
