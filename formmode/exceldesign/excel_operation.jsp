
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="htmlLayoutOperate" class="weaver.formmode.exceldesign.HtmlLayoutOperate" scope="page"/>
<%
String operation = Util.null2String(request.getParameter("operation"));
if("syncLayouttypes".equalsIgnoreCase(operation)){		//同步到其他节点
	htmlLayoutOperate.setRequest(request);
	htmlLayoutOperate.setUser(user);
	htmlLayoutOperate.syncLayouts();
	response.sendRedirect("syncLayoutsBrowser.jsp?isclose=1");
}
%>