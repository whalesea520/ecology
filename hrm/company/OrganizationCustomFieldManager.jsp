
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17088,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

%>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",AddHrmCustomField.jsp?parentid="+parentid+",_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr style="height:1px;">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">


<TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="100%">

  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(17549,user.getLanguage())%></th>
  </tr>
	<TR CLASS=DataLight>
		<TD><a href="/hrm/company/addSubcompanyDefineForm.jsp"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></a></TD>
	</TR>
	<TR CLASS=DataDark>
		<TD><a href="/hrm/company/addDeptDefineForm.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></a></TD>
	</TR>	
 </TABLE>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>

</BODY>
</HTML>
