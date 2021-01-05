<%@ page import="weaver.general.Util,java.util.*" %>
<%@ page isErrorPage="true" import="java.io.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head><title>error page</title></head>
<body>

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

				<table width="100%" cellspacing="5" cellpadding="5" border="1" bordercolor="#FFFFFF">
				  <tr bgcolor="#CCCCCC">
					<td width="19%"><b>Exception</b></td>
					<td width="81%"></td>
				  </tr>
				  <tr>
					<td colspan="2" height="5"></td>
				  </tr>
				  <tr bgcolor="#CCCCCC">
					<td width="19%"><b>Message</b></td>
					<td width="81%"></td>
				  </tr>
				  <tr>
					<td colspan="2" height="5"></td>
				  </tr>
				  <tr bgcolor="#CCCCCC">
					<td width="19%"><b>Localized Message</b></td>
					<td width="81%"></td>
				  </tr>
				  <tr>
					<td colspan="2" height="5"></td>
				  </tr>
				  <tr bgcolor="#CCCCCC">
					<td width="19%"><b>Stack Trace</b></td>
					<td width="81%">
					  <%
					StringWriter sw = new StringWriter() ;
					PrintWriter pw = new PrintWriter(sw) ;
					exception.printStackTrace(pw) ;
					//out.println(sw) ;
					%>
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