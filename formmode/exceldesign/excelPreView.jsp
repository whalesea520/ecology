<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<% 
	int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"),-1);
	int layoutid = Util.getIntValue(request.getParameter("layoutid"), 0);
	response.sendRedirect("/formmode/view/AddFormModeIframe.jsp?isPreview=1&modeId="+modeid+"&formId="+formid+"&type="+layouttype+"&layoutid="+layoutid);
	return;
%>