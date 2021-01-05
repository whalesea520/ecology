<%@ page import="weaver.general.Util" %>
<jsp:useBean id="verifylogin" class="weaver.portal.login.VerifyLogin" scope="page" />


<%
String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
String loginid = Util.null2String(request.getParameter("loginid")) ;
String userpassword = Util.null2String(request.getParameter("userpassword"));

if(loginid.equals("") || userpassword.equals("") ) response.sendRedirect(loginfile + "?message=18") ;
else  {
	String usercheck = verifylogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile) ; 
	if(!usercheck.equals(""))  response.sendRedirect(loginfile + "?message="+usercheck) ;
	else 
		response.sendRedirect("/portal/main.jsp") ;
}
%>

			


