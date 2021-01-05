<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%

session.setAttribute("initDisplayCptSearchCondition","1");

String isdata = Util.null2String(request.getParameter("isdata")) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String from = Util.null2String(request.getParameter("from")) ;
String optFrameSrc="";
if(!paraid.equals(""))
    optFrameSrc = "CptSearchTab.jsp?isdata="+isdata+"&from="+from+"&paraid="+paraid;
else
    optFrameSrc = "CptSearchTab.jsp?isdata="+isdata+"&from="+from;
%>
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
</head>
<body>
<TABLE class=viewform width=100% id=oTable1  cellpadding="0px" cellspacing="0px" height="100%">
  <TBODY>
<tr>
<td  height=100% id=oTd1 name=oTd1 width="246px" style="padding:0px;display:none;">
<IFRAME name=leftframe id=leftframe src="/cpt/maintenance/CptAssortmentTree2.jsp?isdata=<%=isdata %>&cpt_search=1&from=<%=from %>" width="100%" height="100%" frameborder=no scrolling=no >
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px">
<IFRAME name=optFrame id=optFrame src="<%=optFrameSrc %>" width="100%" height="100%" frameborder=no scrolling=yes>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>

</body>
</HTML>
