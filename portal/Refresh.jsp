<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String message = Util.null2String(request.getParameter("message")) ;
%>


<SCRIPT LANGUAGE="VBScript">
	Sub Window_OnLoad()
	   On Error Resume Next
	   window.top.location.href = "<%=loginfile%>?message=<%=message%>"
	End Sub
</SCRIPT>