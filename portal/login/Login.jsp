<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String message = Util.null2String(request.getParameter("message")) ;
if(!message.equals("")) message = SystemEnv.getErrorMsgName(Util.getIntValue(message),7) ;
%>

<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(84169,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
// -->
</script>
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</head>
<SCRIPT language=javascript1.1>
<!--
function checkall()
{ 
	var i=0;
	var errMessage="";
if (form1.loginid.value=="") {errMessage=errMessage+"请输入用户名！\n";i=i+1;}
if (form1.userpassword.value=="") {errMessage=errMessage+"请输入密码！\n";i=i+1;}
if (i>0){alert(errMessage);form1.loginid.focus(); return false ;}
//  else { form1.submit() ; }
}
// -->
</SCRIPT>
<script language="JavaScript">
function click() {
if (event.button==2) {alert('www.weaver.com.cn') }}
document.onmousedown=click
</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" margin=0 onload="javascripts:form1.loginid.focus()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="489" rowspan="2"><img src="/images_frame/login/left_wev8.jpg"></td>
    <td valign="top"> 
      <div align="left">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="301">&nbsp;</td>
          </tr>
          <tr>
            <td height="217">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="217" background="/images_frame/login/tablebg_wev8.jpg">
        <form name=form1 action= "VerifyLogin.jsp"  method=post onSubmit="return checkall()">
		  <INPUT type=hidden name="loginfile" value= "/login/Login.jsp" >
		  <INPUT type=hidden name="logintype" value="1"> 
                  <tr> 
                    <td height="85">&nbsp;</td>
					<td height="85" valign="bottom"><font color="#FF0000"><%=message%></font></td>
                  </tr>
                  <tr> 
                    <td height="20" width="150">
                      <table width="150" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td></td>
                        </tr>
                      </table>
                    </td>
                    <td height="20"> 
                      <input type="text" name="loginid" class="stedit" size="10">
                    </td>
                  </tr>
                  <tr> 
                    <td colspan="2" height="18">&nbsp; </td>
                  </tr>
                  <tr> 
                    <td height="20" width="150"></td>
                    <td height="20"> 
                      <input type="password" name="userpassword" class="stedit" size="10" >
                    </td>
                  </tr>
                  <tr> 
                    <td colspan="2" height="18">&nbsp; </td>
                  </tr>
                  <tr> 
                    <td width=150 height="20">&nbsp;</td>
                    <td height="20"> 
                      <input type="submit" class="submit" name="Submit" value="&gt;&gt; <%=SystemEnv.getHtmlLabelName(674,user.getLanguage())%>">
                    </td>
                  </tr>
                  <tr> 
                    <td>&nbsp;</td>
                  </tr>
                </form>
              </table>
            </td>
          </tr>
          <tr>
            <td height="19" background="/images_frame/login/url_wev8.jpg">&nbsp;</td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>
</body>
</html>
