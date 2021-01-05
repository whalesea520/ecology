<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="verifyMailLogin" class="weaver.email.VerifyMailLogin" scope="page" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />

<%
String fromLogin = Util.null2String(request.getParameter("fromLogin")) ;
if(fromLogin.equals("1")) {
    String username = Util.null2String(request.getParameter("username")) ;
    String password = Util.null2String(request.getParameter("password")) ;
    String needsave = Util.null2String(request.getParameter("needsave")) ;

    boolean checkright = verifyMailLogin.verify(username,password ,request) ;

    if( checkright ) {
        if( needsave.equals("1")) {
            int userid = user.getUID() ;
            WeavermailUtil.saveMailinfo(userid , username , password ) ;
        }
        response.sendRedirect("WeavermailIndex.jsp");
    }
    else response.sendRedirect("WeavermailLogin.jsp?message=fail");
}
else {
    int userid = user.getUID() ;
    WeavermailUtil.getUserMailInfo( userid ) ;
    String username = Util.null2String(WeavermailUtil.getUsername()) ;
    String password = Util.null2String(WeavermailUtil.getUserPassword()) ;

    boolean checkright = verifyMailLogin.verify(username,password ,request) ;

    if( checkright ) response.sendRedirect("WeavermailIndex.jsp");
    else response.sendRedirect("WeavermailLogin.jsp?message=fail");
}
%>