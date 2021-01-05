
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>

<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />

<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16641, 7)%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body background="/images_frame/top_bg_wev8.gif">
<br>
<table class=form width=100%>
	<tr>
		<td align=center>
			<font size=4 color=#ffffff><b><%=CompanyComInfo.getCompanyname("1")%></b></font>
		</td>
	</tr>
</table>

</body>
</html>
