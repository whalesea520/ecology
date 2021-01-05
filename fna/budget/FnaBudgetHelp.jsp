
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
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

<TABLE class=viewform>
  <colgroup>
  <col width="10">
  <col width="">
  <TR class=Title>
    <TH colspan="2"><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colspan="2"></TD></TR>
  <TR>
    <TD></TD>
    <TD><li><%=SystemEnv.getHtmlLabelName(21636,user.getLanguage())%></li></TD>
  </TR>
  <TR>
    <TD></TD>
    <TD><li><a href='javascript:Periods(this)'><%=SystemEnv.getHtmlLabelName(16504,user.getLanguage())%></a></li></TD>
  </TR>   
</TABLE>

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
</BODY>
<script language="javascript">
   function Periods(){        
       window.parent.location = '/fna/maintenance/FnaYearsPeriods.jsp';
   }
</script>
</HTML>