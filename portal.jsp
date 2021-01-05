<%
String servername = request.getServerName() ;
String sslurl = "https://"+servername +"/login/Login.jsp?logintype=2" ;
response.sendRedirect(sslurl);
%>