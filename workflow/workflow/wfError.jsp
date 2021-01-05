
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<HTML><HEAD>
</head>
<%
String msgstr=Util.null2String(request.getParameter("msg"));
if(msgstr.equals("")) msgstr=SystemEnv.getHtmlLabelName(18975,user.getLanguage());
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<br>
<font color="red"><b><%=msgstr%></b></font>
</body>
</html>