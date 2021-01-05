<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="DocRpSumManage" class="weaver.docs.report.DocRpSumManage" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(169,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%

DocRpSumManage.setOptional("status") ;
DocRpSumManage.getRpResult(""+user.getUID()) ;
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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
<TABLE class=ViewForm width="100%">
  <TBODY>
  <TR class=Spacing>
    <TD class=Line1></TD></TR></TBODY></TABLE>
<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="15%">
  <COL align=left width="28%">
  <COL align=right width="7%">
  <COL align=right width="7%">
  <COL align=left width="23%">
  <COL align=right width="6%">
  <COL align=right width="6%">
  <COL align=right width="6%">
  <COL align=right width="6%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
    <TH><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></TH>
    <TH>%</TH>
    <TH><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
    <TH>%</TH></TR>
<TR class=Line><TD colSpan=9></TD></TR>
	<%  while(DocRpSumManage.next())  { 
		  String resultid = DocRpSumManage.getResultID();
		  String resultcount = DocRpSumManage.getResultCount();
		  String resultpercent = DocRpSumManage.getResultPercent() ;
		  String normalpercent = DocRpSumManage.getNormalPercent() ;
		  String normalcount =  DocRpSumManage.getNormalCount() ;
		  String replycount =  DocRpSumManage.getReplyCount() ;
		  String replypercent =  DocRpSumManage.getReplyPercent() ;
	%>
  <TR class=datadark>
    <TD><%if(resultid.equals("0")) { %><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%>
	    <%if(resultid.equals("1")||resultid.equals("2")) { %><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
		<%if(resultid.equals("3")) { %><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%><%}%>
		<%if(resultid.equals("4")) { %><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%><%}%>
		<%if(resultid.equals("5")) { %><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%}%>
	</TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=redgraph <%if(Util.getFloatValue(resultpercent.substring(0,resultpercent.length()-1),0)>=1){%>width="<%=resultpercent%>"<%} else {%>width="1" <%}%> >&nbsp;</TD>
          <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD><%=resultcount%></TD>
    <TD><%=resultpercent%></TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=bluegraph width="<%=normalpercent%>">&nbsp;</TD>
          <TD class=greengraph width="<%=replypercent%>">&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD><%=normalcount%></TD>
    <TD><%=normalpercent%></TD>
    <TD><%=replycount%></TD>
    <TD><%=replypercent%></TD></TR>
	<% } %>
  </TBODY></TABLE>

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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>          
</BODY></HTML>
