<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<html><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<body>

<DIV align=right>
<BUTTON class=btn accessKey=C onclick="window.parent.close()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%></BUTTON>
</DIV>
</body>
</html>


