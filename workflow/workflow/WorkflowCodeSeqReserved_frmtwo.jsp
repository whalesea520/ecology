
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
%>
<body>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px">
<IFRAME name=wfleftFrame id=wfleftFrame src="WorkflowCodeSeqReserved_lefttwo.jsp?subCompanyId=<%=subCompanyId%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" width="100%" height="100%" frameborder=no scrolling=no >
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<%--
<td height=100% id=oTd0 name=oTd0 width="1%">
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td> --%>
<td height=100% id=oTd2 name=oTd2 width="*">
<IFRAME name=wfmainFrame id=wfmainFrame src="WorkflowCodeSeqReservedHelp.jsp" width="100%" height="100%" frameborder=no scrolling=auto>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
</body>
</noframes></html>