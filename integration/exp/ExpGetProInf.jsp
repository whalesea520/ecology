<%@page contentType="text/html; charset=GBK"%>
<%@page import="weaver.expdoc.ExpUtil"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
    String id=request.getParameter("Proid");
	ExpUtil eu=new ExpUtil();
	String flag=eu.getProInfById(id);

	 out.print(flag);
%>
