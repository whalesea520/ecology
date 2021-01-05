<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="XmlReportManage" class="weaver.report.XmlReportManage" scope="page" />
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("XmlReportSetting:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22377,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
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
<form name=frmmain method=post action="XmlReportSearch.jsp">
<table class=ListStyle cellspacing=1 >
<colgroup>
<col width="50">
<col width="200">
<col>
<col width="150">
</colgroup>
<tbody>
   <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(22385,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  </tr>
  <TR class=Line><TD colspan="5" ></TD></TR>
<%
int i = 0;
Map rptNameMap = XmlReportManage.getReportName();
Iterator it = rptNameMap.entrySet().iterator();
while(it.hasNext()) {
	i++;
	Map.Entry entry = (Map.Entry) it.next();
	String rptFlag = entry.getKey().toString();
	rptFlag = rptFlag.substring(0, rptFlag.indexOf(":"));
	//out.println(entry.getKey()+"  "+entry.getValue()+"<br>");
%>
	<TR>
    <TD><%=i%></TD>
	<TD><%=rptFlag%></TD>
    <TD><%=entry.getValue()%></TD>
	<TD><a href="XmlReportAddShare.jsp?rptFlag=<%=rptFlag%>"><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></a></TD>
  </TR>
<%
}
%>
</table>
<br>
</form>

</body>
</html>