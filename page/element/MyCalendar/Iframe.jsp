
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/element/viewCommon.jsp"%>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>
	
<html>
    <head>
        <title>
        </title>
    </head>
    <body>
    <iframe id="ifrm_myCalendar_<%=eid %>" name="ifrm_myCalendar_<%=eid %>" border="0" frameborder="no" noresize="NORESIZE" scrolling="auto" width="100%"  src="/page/element/MyCalendar/View.jsp?eid=<%=eid %>"></ifram
    </body>
</html>