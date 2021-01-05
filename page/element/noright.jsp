<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</HEAD>

<%
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
%>
<script language="JavaScript">
<%if(isovertime==1){%>
        window.opener.location.href=window.opener.location.href;
<%}%>
</script>
<BODY>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">

<tr>

	<td style="text-align:center;vertical-align:middle">
		 
						    <div style="display:inline-flex;">
							     <img src="/synergy/js/waring_wev8.png"> <%=SystemEnv.getHtmlLabelName(2012,user.getLanguage())%>
							</div>
 
	</td>

</tr>

</table>

</BODY>
</HTML>