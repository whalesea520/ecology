<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</HEAD>

<%
String imagefilename = "/images/hdNoAccess_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15148,user.getLanguage())+"...";
String needfav ="";
String needhelp ="";
int id=user.getUID();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

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

			<TABLE class=ViewForm>
			<TR>
				<TD valign=top>
					<TABLE>
						<TR class=Section><TH style="font-size:8pt"> <%=SystemEnv.getHtmlLabelName(18354,user.getLanguage())%></TH></TR>
						
						<TR><TD><%="<a href=/hrm/resource/HrmResourcePassword.jsp?id=" + id + ">" + SystemEnv.getHtmlLabelName(18355,user.getLanguage()) + "</a>"%></TD></TR>
						
					</TABLE>
				</TD>
				
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
</HTML>