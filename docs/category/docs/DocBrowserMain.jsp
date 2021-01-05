<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%
String url = Util.null2String(request.getParameter("url"));
//out.print(url);
%>
<html>

<head>
</head>

<frameset rows="2,98%" framespacing="0" border="0" frameborder="0" >
  <frame name="contents" target="main"  marginwidth="0" marginheight="0" scrolling="auto" noresize >
  <frame name="main" marginwidth="0" marginheight="0" scrolling="auto" src="<%=url%>">
  <noframes>
  <body>
  <p><%=SystemEnv.getHtmlLabelName(15614,user.getLanguage())%></p>

  </body>
  </noframes>
</frameset>

</html>
