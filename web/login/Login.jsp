<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
String message = Util.null2String(request.getParameter("message")) ;
if(!message.equals("")) message = SystemEnv.getErrorMsgName(Util.getIntValue(message),7) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
if(logintype.equals("")) logintype="2";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" language="JavaScript1.2" src="/web/login/js/stm31_wev8.js"></script>
<link href="/web/css/style_wev8.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--



function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function checkall()
{ 
	var i=0;
	var errMessage="";
if (form1.loginid.value=="") {errMessage=errMessage+<%=SystemEnv.getHtmlLabelName(16647, 7)%>+"\n";i=i+1;}
if (form1.userpassword.value=="") {errMessage=errMessage+<%=SystemEnv.getHtmlLabelName(16648, 7)%>+"\n";i=i+1;}
if (i>0){alert(errMessage);form1.loginid.focus(); return false ;}
 else { form1.submit() ; }
}
// -->

</SCRIPT>
<script language="JavaScript">
function click() {
if (event.button==2) {alert('<%=SystemEnv.getHtmlLabelName(129311, 7)%>') }
}
document.onmousedown=click

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div align=center> <!-- #BeginLibraryItem "/Library/headnavi.lbi" --><table width="774" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="171" height="65" align="center" valign="middle" bgcolor="27287A"><img src="../images/logo_sunyard_wev8.gif" name="Image1" width="114" height="33" id="Image1"></td>
    <td bgcolor="27287A">&nbsp;</td>
    <td width="250" align="right" valign="middle" bgcolor="27287A"> 

    </td>
  </tr>
</table>

<!-- #EndLibraryItem -->
  <table width="774" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="400" rowspan="2"><img src="../images/hp_cover_wev8.gif" width="400" height="230"></td>
      <td height="115" valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="F4EFE2">
		<tr background="/web/images/icon_login_bg_wev8.gif"><td height="31"><img src="/web/images/icon_login_2_wev8.gif"></td></tr>
		<form name=form1 action= "/web/login/VerifyLogin.jsp"  method=post >
		<INPUT type=hidden name="loginfile" value= "/web/login/Login.jsp?logintype=<%=logintype%>" >
		<INPUT type=hidden name="logintype" value="<%=logintype%>"> 
		<tr> 
			<td align="center" valign="top" bgcolor="F4EFE2"><BR><BR>
				<table width="80%" border="0" cellspacing="0" cellpadding="3">
					<tr> 
					  <td width="65"><%=SystemEnv.getHtmlLabelName(2072, 7)%>：</td>
					  <td><input name="loginid" type="text" size="20"></td>
					</tr>
					<tr> 
					  <td width="65"><%=SystemEnv.getHtmlLabelName(129312, 7)%>：</td>
					  <td><input name="userpassword" type="password" size="20"></td>
					</tr>
					<tr> 
					  <td ></td>
					  <td >
						<input name="imageField22" type="image" src="/web/images/button_login_wev8.gif" width="40" height="20" border="0" onclick="return checkall()"> &nbsp;&nbsp;&nbsp;
						<a href = "#"><img src="/web/images/button_reg_wev8.gif" border="0"></a><BR><BR>
						<font color="#FF0000"><%=message%></font><BR>
					  </td>
					</tr>
				</table>
				<br>
			</td>
		 </tr>
		</form>
		</table>
	  </td>
	</tr>	
  </table>
</div>
</body>
</html>
