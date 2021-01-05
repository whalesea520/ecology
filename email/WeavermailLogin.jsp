
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String userid=user.getUID()+"" ;
String message=Util.fromScreen(request.getParameter("message"),user.getLanguage());
if(!message.equals("fail")){
    RecordSet.executeProc("MailPassword_SByResourceid",userid) ;
    if(RecordSet.next()){
        response.sendRedirect("EmailLogin.jsp?fromLogin=0");
        return ;   
    }
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
if(message.equals("fail")){ 
	titlename+="<font color=red>Email Server Connect Error</font>" ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(674,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name="weaver" id="weaver" ACTION="EmailLogin.jsp" METHOD="POST" >
  <input type="hidden" name="fromLogin" value="1">
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
		  <table class=ViewForm>
			<tbody> 
			<tr class=Title> 
			  <th colspan=2><%=SystemEnv.getHtmlLabelName(2023,user.getLanguage())%></th>
			</tr>
			<tr class=Spacing> 
			  <td class=Line1 colspan=2></td>
			</tr>
			<tr> 
			  <td width="15%"><%=SystemEnv.getHtmlLabelName(2024,user.getLanguage())%></td>
			  <td class=Field> 
				<input class=InputStyle name="username" 
				  onBlur="checkinput('username','usernamespan')" value="<%=user.getEmail()%>">
				<span id=usernamespan><img src="/images/BacoError_wev8.gif" align=absMiddle></span>
				<div id="usernameinfo" style="display:none"><font color="red"><%=SystemEnv.getHtmlLabelName(19380,user.getLanguage())%></font></div>
				</td>
			</tr>
			<TR><TD class=Line colSpan=2></TD></TR> 
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
			  <td class=Field> 
				<input class=InputStyle name="password" type=password onChange="checkinput('password','passwordspan')">
				<span id=passwordspan><img src="/images/BacoError_wev8.gif" align=absMiddle></span> 
			  </td>
			</tr>
			<TR><TD class=Line colSpan=2></TD></TR> 
			<tr> 
			  <td><font face="Arial, Helvetica">
				<input type="checkbox" name="needsave" value="1">
				</font></td>
			  <td class=Field><%=SystemEnv.getHtmlLabelName(2025,user.getLanguage())%> </td>
			</tr>
			<TR><TD class=Line colSpan=2></TD></TR> 
			</tbody> 
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
  </form>
</BODY>
 <script language="javascript">
 function onSubmit(){
 var username=weaver.username.value;

 	if(check_form(weaver,"username,password")){
 		if(username.indexOf("@")==-1)
 			usernameinfo.style.display="inline";
 		else
			document.weaver.submit();
	}
 }
 </script>
</html>
