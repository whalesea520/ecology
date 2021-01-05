<%@page contentType="text/html; charset=GBK"%>
<%@page import="weaver.interfaces.outter.*"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");

	OutterUtil ut=new OutterUtil();
	 out.print(ut.getEncrptClassOpetions());
%>
