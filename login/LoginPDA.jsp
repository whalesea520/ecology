
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.systeminfo.*" %>
<%
Cookie ckTest = new Cookie("testBanCookie","test");
ckTest.setMaxAge(-1);
ckTest.setPath("/");
response.addCookie(ckTest);


RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String needusb=settings.getNeedusb();
String firmcode=settings.getFirmcode();
String usercode=settings.getUsercode();
String message0 = Util.null2String(request.getParameter("message")) ;
String message=message0;
if(!message.equals("")) message = SystemEnv.getErrorMsgName(Util.getIntValue(message0),7) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
if(logintype.equals("")) logintype="1";
String loginid=Util.null2String((String)session.getAttribute("tmploginid"));;
if(message0.equals("101")) {
    //loginid=Util.null2String((String)session.getAttribute("tmploginid"));
    //session.removeAttribute("tmploginid");
    message=SystemEnv.getHtmlLabelName(20289,7);
}
String noAllowIe = Util.null2String(request.getParameter("noAllowIe")) ;
if (noAllowIe.equals("yes")) {
	message = SystemEnv.getHtmlLabelName(129167, 7);
}

//用户并发数错误提示信息
if (message0.equals("26")) { 
	message = SystemEnv.getHtmlLabelName(23656,7);
}

//add by sean.yang 2006-02-09 for TD3609
int needvalidate=settings.getNeedvalidate();//0: ·?,1: ??



%>


<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(84169, 7)%></title>
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</head>
<script language="JavaScript">
function click() {
if (event.button==2) {alert('<%=SystemEnv.getHtmlLabelName(16641, 7)%>') }} 
document.onmousedown=click
function checkall()
{ 
	var i=0;
	var errMessage="";
if (form1.loginid.value=="") {errMessage=errMessage+<%=SystemEnv.getHtmlLabelName(16647, 7)%>+"\n";i=i+1;}
if (form1.userpassword.value=="") {errMessage=errMessage+<%=SystemEnv.getHtmlLabelName(16648, 7)%>+"\n";i=i+1;}
if (i>0){alert(errMessage);form1.loginid.focus(); return false ;}
}
</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" margin=0 onload="javascripts:form1.loginid.focus()">

<table width="100%" height=100% border="0" cellspacing="0" cellpadding="0"  bgcolor="#FFFFFF">
  <tr> 
    
    <td valign="top"> 
      <div align="left">
	  
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <!--tr>
            <td height="260">&nbsp;</td>
          </tr-->
          <tr>
            <td height="217">
			  <fieldset>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="217">
        <form name=form1 action= "VerifyLogin.jsp"  method=post onSubmit="return checkall();">
		  <INPUT type=hidden name="loginfile" value= "/login/LoginPDA.jsp?logintype=<%=logintype%>" >
		  <INPUT type=hidden name="logintype" value="<%=logintype%>">
		  <INPUT type=hidden name="loginPDA" value="1">
		  <input type=hidden name="message" value="<%=message0%>">
                  <tr> 
                    <td height="75">&nbsp;</td>
					<td height="75" valign="bottom" style="color:#FF0000;font-size:9pt"><%
				
						out.println(message);
					%></td>
                  </tr>
                  <tr> 
                    <td height="20" width="150">
                    </td>
                    <td height="20"> 
                      <%=SystemEnv.getHtmlLabelName(2024, 7)%>：<input type="text" name="loginid" class="stedit" size="10" value="<%=loginid%>"   <%if(!loginid.equals("")){%>readonly style="background-color:GrayText;"<%}%> size="15>
                    </td>
                  </tr>
                  <tr> 
                    <td colspan="2" height="12"></td>
                  </tr>
                  <tr> 
                    <td height="20" width="150"></td>
                    <td height="20"> 
                      <%=SystemEnv.getHtmlLabelName(409, 7)%>：<%
                      if("101".equals(message0)||"57".equals(message0))
	                    {
	                    %><input type="text" name="userpassword" class="stedit" size="10" >
	                    <%
	                    } 
	                    else
	                    {
	                    %><input type="password" name="userpassword" class="stedit" size="10" >
	                    <%
	                    }
	                    %>
                    </td>
                  </tr>
              
                  <tr> 
                    <td colspan="2" height="18">&nbsp; </td>
                  </tr>
                  
                  <tr> 
                    <td width=150 height="20">&nbsp;</td>
                    <td height="20"> 
                      <input type="submit" class="submit" name="Submit" value="&gt;&gt; <%=SystemEnv.getHtmlLabelName(674, 7)%>">
                    </td>
                  </tr>
                  <tr> 
                    <td>&nbsp;</td>
                  </tr>
                </form>
              </table>
			  </fieldset>
            </td>
          </tr>
          <tr>
            <td height="19" background="/images_face/login/url_wev8.jpg">&nbsp;</td>
          </tr>
		  <tr>          
			  <td>	
			
			  </td>
          </tr>
        </table>
		
      </div>
    </td>
    <td width="489" rowspan="2" valign="top"></td>
  </tr>
</table>

</body>
</html>
