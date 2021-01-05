
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<TITLE>CRM<%=SystemEnv.getHtmlLabelName(15098,user.getLanguage())%></TITLE>
</head>
<body>
<h1>CRM<%=SystemEnv.getHtmlLabelName(15098,user.getLanguage())%></h1>
<p>
	<a href="/CRM/data/AddCustomer.jsp"><%=SystemEnv.getHtmlLabelName(15099,user.getLanguage())%></a>
	<a href="/CRM/search/SearchOperation.jsp?destination=myAccount"><%=SystemEnv.getHtmlLabelName(6059,user.getLanguage())%></a>
	<a href="/CRM/search/SearchSimple.jsp"><%=SystemEnv.getHtmlLabelName(15100,user.getLanguage())%></a>
</p>
<form name="form" method="POST" action="/CRM/search/SearchOperation.jsp">
	<input type="hidden" name="destination" value="QuickSearch">
	<p><input type="text" name="CustomerName"><input type="submit" value="QuickSearch"></p>
<form>

<hr>
<p><a href="/CRM/search/SearchAdvanced.jsp"><%=SystemEnv.getHtmlLabelName(15100,user.getLanguage())%></a></p>
<p><a href="/CRM/CRMNews.jsp"><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></a></p>
<p><a href="/CRM/CRMOrganise.jsp"><%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></a></p>
<p><a href="/CRM/CRMReport.jsp"><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></a></p>
<p><a href="/CRM/CRMMaintenance.jsp"><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></a></p>

</body>
</html>
