
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util,net.sf.json.JSONObject" %>

<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>

<jsp:useBean id="DocMonitorManager" class="weaver.system.systemmonitor.docs.DocMonitorManager" scope="page" />

<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String ajax = Util.null2String(request.getParameter("ajax"));

String docIdSelected = Util.null2String(request.getParameter("docIdSelected")) ;
String hasTab = Util.null2String(request.getParameter("hasTab")) ;

DocMonitorManager.setClientAddress(request.getRemoteAddr());
DocMonitorManager.executeDocMonitor(docIdSelected,operation,user);
if(ajax.equals("1")){
	JSONObject json = new JSONObject();
	json.put("msg","true");
	out.println(json);	
}else{
	response.sendRedirect("DocMonitor.jsp?hasTab="+hasTab+"&operation="+operation+"&needSubmit=1");
}



%>