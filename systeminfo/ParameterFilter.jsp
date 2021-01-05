<%@ page import="java.util.Enumeration" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %> 
<%@ page import="weaver.general.TimeUtil" %>
<%
Enumeration enum1 = request.getParameterNames();
String errmessageben="";
if (request.getMethod().equals("POST")){
	while (enum1.hasMoreElements()) {
		String param = (String) enum1.nextElement();  
		String paramvalues = new String(((String) request.getParameter(param)).getBytes("ISO8859_1"), "UTF-8");

		if ((paramvalues.toUpperCase().indexOf("CRM_CUSTOMERINFO") > -1 || paramvalues.toUpperCase().indexOf("CRMSHAREDETAIL") > -1||	paramvalues.toUpperCase().indexOf("WORKFLOW_CURRENTOPERATOR") > -1 || paramvalues.toUpperCase().indexOf("COWORK_ITEMS") > -1|| paramvalues.toUpperCase().indexOf("WORKPLANSHAREDETAIL") > -1|| paramvalues.toUpperCase().indexOf("WORKPLAN") > -1|| paramvalues.toUpperCase().indexOf("DOCDETAIL") > -1|| paramvalues.toUpperCase().indexOf("WORKFLOW_REQUESTBASE") > -1|| paramvalues.toUpperCase().indexOf("WORKFLOW_FORM") > -1|| paramvalues.toUpperCase().indexOf("WORKFLOW_REQUESTLOG") > -1|| paramvalues.toUpperCase().indexOf("CRM_VIEWLOG1") > -1 || paramvalues.toUpperCase().indexOf("SHAREINNERDOC") > -1)
			&& (paramvalues.toUpperCase().indexOf("INSERT") > -1 || paramvalues.toUpperCase().indexOf("UPDATE") > -1 || paramvalues.toUpperCase().indexOf("DROP") > -1|| paramvalues.toUpperCase().indexOf("TRUNCATE") > -1|| paramvalues.toUpperCase().indexOf("DELETE") > -1)) {

			errmessageben+="no allowed log in,ip:" + request.getRemoteAddr() + "|url:" + request.getRequestURI()+"  ";
			errmessageben+="param:" + param + "|" + new String(((String) request.getParameter(param)).getBytes("ISO8859_1"), "UTF-8")+"  ";
			
			Cookie[] cookies = request.getCookies();
			String cookiestr = "cookie:";
			for (int i = 0; i < cookies.length; i++) {
				Cookie cookie = cookies[i];
				cookiestr += cookie.getName() + "|" + cookie.getValue();
			}
			

			response.sendRedirect("/login/Logout.jsp");
			return;
		}
	}
}
%>
