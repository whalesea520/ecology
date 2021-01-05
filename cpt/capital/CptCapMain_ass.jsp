
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
String from = Util.null2String(request.getParameter("from")) ;
String optFrameSrc="";
if(!paraid.equals(""))
    optFrameSrc = "CptCapMain_data1tab.jsp?from="+from+"&paraid="+paraid;
else
    optFrameSrc = "CptCapMain_data1tab.jsp?from="+from;
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
<tr><td  height=100% id=oTd1 name=oTd1 width="246px" style="padding:0px;">
<IFRAME name=leftframe id=leftframe2 src="/cpt/maintenance/CptAssortmentTree2.jsp?isdata=1&cptdata1_maintenance=1" width="100%" height="100%" frameborder=no scrolling=no >
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px">
<IFRAME name=optFrame id=optFrame src="<%=optFrameSrc %>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>


</body>
</HTML>
