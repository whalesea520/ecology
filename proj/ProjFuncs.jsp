<html>
<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<TITLE><%=SystemEnv.getHtmlLabelName(15261,user.getLanguage())%></TITLE>
</head>
<body>
<h1><%=SystemEnv.getHtmlLabelName(15261,user.getLanguage())%></h1>
<p>
	<a href="/Proj/data/AddProject.jsp"><%=SystemEnv.getHtmlLabelName(15262,user.getLanguage())%></a>
	<a href="/Proj/search/SearchOperation.jsp?destination=myProject"><%=SystemEnv.getHtmlLabelName(1211,user.getLanguage())%></a>
	<a href="/Proj/search/Search.jsp"><%=SystemEnv.getHtmlLabelName(15100,user.getLanguage())%></a>
</p>
<form name="form" method="POST" action="/proj/search/SearchOperation.jsp">
	<input type="hidden" name="destination" value="QuickSearch">
	<p><input type="text" name="CustomerName"><input type="submit" value="QuickSearch"></p>
<form>

<hr>
<p><a href="/Proj/search/Search.jsp"><%=SystemEnv.getHtmlLabelName(15100,user.getLanguage())%></a></p>
<p><a href="/Proj/ProjNews.jsp"><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></a></p>
<p><a href="/Proj/ProjOrganise.jsp"><%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></a></p>
<p><a href="/Proj/ProjReport.jsp"><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></a></p>
<p><a href="/Proj/ProjMaintenance.jsp"><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></a></p>

</body>
</html>
