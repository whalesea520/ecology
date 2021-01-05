
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
Enumeration names = request.getParameterNames();
if(null!=names)
{
	while(names.hasMoreElements())
	{
		String pname = (String)names.nextElement();
		String pvalue = Util.null2String(request.getParameter(pname));
		out.println("pname : "+pname+" pvalue : "+java.net.URLDecoder.decode(pvalue)+" realvalue ："+SecurityHelper.decryptSimple(java.net.URLDecoder.decode(pvalue)));
		out.println("<br>");
	}
}
%>