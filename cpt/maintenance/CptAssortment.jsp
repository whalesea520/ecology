
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
boolean canedit = HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit", user) ;
if(!canedit ){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String from=Util.null2String(request.getParameter("from"));
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
rs.executeSql("select cptdetachable from SystemSet");
int detachable=0;

if(rs.next()){
  detachable=rs.getInt("cptdetachable");
  session.setAttribute("cptdetachable",String.valueOf(detachable));
}
if(detachable==1&&"".equals(from)){
  response.sendRedirect("/cpt/maintenance/CptDetachableFrame.jsp?from=cptassortment");
  return;
}

String optFrameSrc="/cpt/maintenance/CptAssortmentTab.jsp?1=1";
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
<IFRAME name=leftframe id=leftframe src="CptAssortmentTree2.jsp?from=cptassortment" width="100%" height="100%" frameborder=no scrolling=no >
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
