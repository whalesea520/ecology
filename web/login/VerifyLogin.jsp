<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/WebServer.jsp" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyLogin" scope="page" />
<%
String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
String loginid = Util.null2String(request.getParameter("loginid")) ;
String userpassword = Util.null2String(request.getParameter("userpassword"));
String RedirectFile = webServerLogin ;
if (logintype.equals("2")) RedirectFile = webServerLogin ;

if(loginid.equals("") || userpassword.equals("") ) response.sendRedirect(loginfile + "&message=18") ;
else  {
	String usercheck = verifylogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile) ; 
	if(usercheck.equals("15") || usercheck.equals("16") || usercheck.equals("17"))  response.sendRedirect(loginfile + "&message="+usercheck) ;
	else if(usercheck.equals("19")){
		response.sendRedirect("/system/InLicense.jsp") ;
	}
	else {
		response.sendRedirect(RedirectFile+"?logmessage="+usercheck) ;
	}
}
%>

			


