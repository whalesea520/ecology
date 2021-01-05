<%@ page import="weaver.hrm.*" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<html><body>
<%
String temps="";
User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
if(user == null)  out.print("1");
else out.print("2");
%>

</body></html>