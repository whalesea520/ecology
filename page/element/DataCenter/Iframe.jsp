
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/element/viewCommon.jsp"%>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<html>
    <head>
        <title>
        </title>
    </head>
    <body>
    <iframe id="ifrm_dataCenter"  height="260px" name="ifrm_dataCenter" border="0" frameborder="no" noresize="NORESIZE" scrolling="auto" width="100%"  src="/page/element/DataCenter/View.jsp?<%=request.getQueryString()%>"></ifram
    </body>
</html>