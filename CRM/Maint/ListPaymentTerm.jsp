
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	RecordSet.executeProc("CRM_PaymentTerm_SelectAll","");
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":&nbsp;"+SystemEnv.getHtmlLabelName(577,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("AddPaymentTerm:add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/CRM/Maint/AddPaymentTerm.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

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
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="30%">
  <COL width="70%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=2></TD></TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<TD><a href="/CRM/Maint/EditPaymentTerm.jsp?id=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%></TD>
	</TR>
<%
	}
%>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
