<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RpAgeManager" class="weaver.hrm.report.RpAgeManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(671,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<%
int departmentid=Util.getIntValue(request.getParameter("departmentid"),0);
%>
<table class=viewform>
<tr>
<td colspan=2 align=center>

<img src="/weaver/weaver.hrm.report.ShowRpAge?departmentid=<%=departmentid%>" border=0>
</td>
</tr>
<tr>
<td colspan=2 align=center>
<font size = 3><b><%=SystemEnv.getHtmlLabelName(15886,user.getLanguage())%>
<%if(departmentid!=0){%>
<%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+departmentid),user.getLanguage())%>
<%}%>
<%=SystemEnv.getHtmlLabelName(15887,user.getLanguage())%>
</b></font>
</td>
</tr>
</table>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>