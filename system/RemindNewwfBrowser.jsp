<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<%
int userid = user.getUID();
int usertype = 0;
String logintype = user.getLogintype();	
if(logintype.equals("2"))
	usertype = 1;
	

String type = Util.null2String(request.getParameter("type"));
%>
<body>
<br>
<div align=center>
<font color=green size=2>
<a href='#' onclick='window.returnValue ="1";window.close();'>
<%if(type.equals("1")){
%>
<%=SystemEnv.getHtmlLabelName(15031,user.getLanguage())%>!
<%}else if(type.equals("2")){
	%>
<%=SystemEnv.getHtmlLabelName(15032,user.getLanguage())%>!
<%}%>
</a>
</font>
</div>
<br>
<div align=center>
<font color=red size=2>
<a href='#' onclick='window.returnValue ="0";window.close();'>【<%=SystemEnv.getHtmlLabelName(15033,user.getLanguage())%>】</a>
</font>
</div>
</body>
</html>


