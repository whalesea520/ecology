<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/WebServer.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link href="/web/css/style_wev8.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%
User user = new User() ;
//相当于init.jsp--begin
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

user = HrmUserVarify.checkUser (request , response) ;
//相当于init.jsp--end
if((user != null)&&user.getLogintype().equals("2"))  { 	
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="90" background="/web/images/bg_login_wev8.gif">
	<tr height="35"> 
		<td colspan="2" valign="top" ><img src="/web/images/icon_login-in_wev8.gif" ></td>
	</tr>
	<tr> 
		<td width="18"></td>
		<td align="center" valign="top" >
			<table width="80%" border="0" cellspacing="0" cellpadding="3">
				<tr> 
				  <td align="left">
				  <%
				  String username = "" ;
				  username=Util.toScreen(user.getUsername(),7);
				  out.print(username);
				  %>，<%=SystemEnv.getHtmlLabelName(27306, user.getLanguage())%>！
				  </td>
				</tr>
			    <tr> 
				  <td align="left">
				  <a href="/web/login/Logout.jsp" target="_top"><img src="/web/images/button_login-out_wev8.gif" border="0">
				  </td>
				</tr>
				</a>
			  </table>
		</td>
	</tr>
</table>
<%}else{%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="90" background="/web/images/bg_login_wev8.gif">
	<tr height="35"> 
		<td colspan="2" valign="top" ><img src="/web/images/icon_login_wev8.gif" ></td>
	</tr>
	<tr> 
		<td width="18"></td>
		<td align="center" valign="top" >
			<table width="80%" border="0" cellspacing="0" cellpadding="3">
				<tr> 
				  <td>
				  <a href="<%=webServerForLogin%>" target="_top"><img src="/web/images/button_login_wev8.gif" border="0">
				  </a>&nbsp;&nbsp;&nbsp;<a href="<%=webServerRegist%>" target="_top"><img src="/web/images/button_reg_wev8.gif" border="0"></a>
				  </td>
				</tr>
			  </table>
		</td>
	</tr>
</table>
<%}%>
</body>
</html>