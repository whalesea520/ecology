<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.templetecheck.RulePath" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD></HEAD><body></body></HTML>
<%
RulePath rulePath  = new RulePath();
String path  = request.getParameter("path");
String ishtml = request.getParameter("ishtml");
String tabtype = request.getParameter("tabtype");

rulePath.savePath(tabtype,path);
//0--流程模板 1--配置文件 2--web.xml 3.其他
if("3".equals(ishtml)) {
	response.sendRedirect("matchrule.jsp?tabtype="+tabtype+"&ishtml="+ishtml);
} else if("0".equals(ishtml)) {
	response.sendRedirect("matchruleHtml.jsp?tabtype="+tabtype+"&ishtml="+ishtml);
} else {
	response.sendRedirect("matchruleConfig.jsp?tabtype="+tabtype+"&ishtml="+ishtml);
}


%>