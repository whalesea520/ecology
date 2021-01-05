
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.Writer"%>
<%
String requestid=Util.getIntValue(request.getParameter("requestid"),0)+"";
String rand=Util.TokenizerString2(Util.null2String(request.getParameter("rand"))," ")[0];
String url="";
%>
<%
if(requestid.equals("")||requestid.equals("0")||requestid.equals("-1")){
	url = Util.null2String((String)session.getAttribute(rand+"_wfdoc"));
}else{
	url = Util.null2String((String)session.getAttribute(requestid+"_wfdoc"));
}
%>
<%=url%>