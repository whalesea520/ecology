
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String showtype=Util.null2String(request.getParameter("showtype"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<body>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="15%">
  <COL width="84%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width=25%>
<IFRAME name=leftframe id=leftframe src="/integration/serviceReg/serviceRegMainLeft.jsp?showtype=<%=showtype %>" width="100%" height="100%" frameborder=no scrolling=yes >
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width=100%>
<IFRAME name=contentframe id=contentframe src="/integration/serviceReg/serviceRegTabs.jsp?_fromURL=<%=showtype %>" width="100%" height="100%" frameborder=no scrolling=yes>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>