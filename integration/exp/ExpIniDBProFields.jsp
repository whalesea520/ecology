<%@page contentType="text/html; charset=GBK"%>
<%@page import="weaver.expdoc.ExpUtil"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
    String dbProid=request.getParameter("dbProid");
	ExpUtil eu=new ExpUtil();
	String flag=eu.IniDBProFields(dbProid);

	 out.print(flag);
%>
