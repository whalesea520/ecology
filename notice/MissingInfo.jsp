<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<DIV class="HdrTitle">
<TABLE width=100% border=0 cellpadding=0 cellspacing=0>
<TR><TD width=55px align=left><IMG src="/images/hdNoAccess_wev8.gif" height=24px></TD><TD align=left><SPAN style="font-size:medium; font-weight:bold"><%=SystemEnv.getHtmlLabelName(17023,user.getLanguage())%>...</SPAN></TD><TD align=right>&nbsp;</TD></TR>
</TABLE>
</DIV>
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
						<TR class=Section><TH style="font-size:8pt"> <%=SystemEnv.getHtmlLabelName(17023,user.getLanguage())%></TH></TR>

						<TR><TD><%=SystemEnv.getHtmlLabelName(17024,user.getLanguage())%></TD></TR>

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