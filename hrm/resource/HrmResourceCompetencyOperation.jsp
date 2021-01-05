<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
  String operation = Util.null2String(request.getParameter("operation"));
  String resourceid = Util.null2String(request.getParameter("resourceid"));
  char separator = Util.getSeparator() ;
  Calendar today = Calendar.getInstance();
  String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
  Enumeration eu = request.getParameterNames();
  while(eu.hasMoreElements()) {
		String euname = (String)eu.nextElement();
		if(!euname.equals("operation") && !euname.equals("resourceid"))  {
			String competencyid = euname ;
			String currentgrade = Util.null2String(request.getParameter(euname)) ;
			if(currentgrade.equals("")) currentgrade ="0";
			String procedurepara = resourceid+separator+competencyid+separator+currentgrade+separator+currentdate ;
			if(operation.equalsIgnoreCase("addcompetency"))
				RecordSet.executeProc("HrmResourceCompetency_Insert",procedurepara);
			if(operation.equalsIgnoreCase("editcompetency"))
				RecordSet.executeProc("HrmResourceCompetency_Update",procedurepara);
		}
  }
  response.sendRedirect("HrmResourceCompetency.jsp?id="+resourceid);
%>