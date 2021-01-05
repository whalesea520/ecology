<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="WeavermailSend" class="weaver.email.WeavermailSend" scope="page" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />
<jsp:useBean id="verifyMailLogin" class="weaver.email.VerifyMailLogin" scope="page" />


<%
String operation = Util.null2String(request.getParameter("operation")) ;
if(operation.equals("delete")) {
    String deletemails[] = request.getParameterValues("themail") ;
    String fromdetail = Util.null2String(request.getParameter("fromdetail")) ;

    MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
    WeavermailComInfo wmc ;

    Folder f = mud.getFolder() ;
    boolean fetchstatus = WeavermailUtil.fetchFolder( f , true , Folder.READ_WRITE ) ;
    if( !fetchstatus ) {
        verifyMailLogin.verify(null , null ,request) ;
        response.sendRedirect("Weavermail.jsp?message=fail");
        return;
    }
    int msgcount = f.getMessageCount();

    if(deletemails != null) {
        for(int i = 0 ; i< deletemails.length ; i++) {
            int deleteemailindex = Util.getIntValue(deletemails[i]) ;
            if ( deleteemailindex <= msgcount ) {
                Message m = f.getMessage(deleteemailindex);
                if(fromdetail.equals("1")) wmc = (WeavermailComInfo)session.getAttribute("WeavermailComInfo") ;
                else wmc = Weavermail.parseMail(m) ;

                Weavermail.locationMail(m,wmc , user,"3") ;
                Weavermail.deleteMail(m) ;
            }
        }
    }
    WeavermailUtil.fetchFolder( f , false , 0 ) ;
    response.sendRedirect("Weavermail.jsp");
}

if(operation.equals("deleteforever")) {
    String deletemails[] = request.getParameterValues("themail") ;

    MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
    Folder f = mud.getFolder() ;
    boolean fetchstatus = WeavermailUtil.fetchFolder( f , true , Folder.READ_WRITE ) ;
    if( !fetchstatus ) {
        verifyMailLogin.verify(null , null ,request) ;
        response.sendRedirect("Weavermail.jsp?message=fail");
        return;
    }
    int msgcount = f.getMessageCount();

    if(deletemails != null) {
        for(int i = 0 ; i< deletemails.length ; i++) {
            int deleteemailindex = Util.getIntValue(deletemails[i]) ;
            if ( deleteemailindex <= msgcount ) {
                Message m = f.getMessage(deleteemailindex);
                Weavermail.deleteMail(m) ;
            }
        }
    }

    WeavermailUtil.fetchFolder( f , false , 0 ) ;
    response.sendRedirect("Weavermail.jsp");
}

if(operation.equals("deletelocation")) {
    String deletemails[] = request.getParameterValues("themail") ;
    String mailtype = Util.null2String(request.getParameter("mailtype")) ;
    if(deletemails != null) {
        for(int i = 0 ; i< deletemails.length ; i++) {
            Weavermail.moveLocationMail(Util.getIntValue(deletemails[i]),"3") ;
        }
    }

    response.sendRedirect("WeavermailLocation.jsp?mailtype="+mailtype);
}


if(operation.equals("deleteforeverlocation")) {
    String deletemails[] = request.getParameterValues("themail") ;
    String mailtype = Util.null2String(request.getParameter("mailtype")) ;
    if(deletemails != null) {
        for(int i = 0 ; i< deletemails.length ; i++) {
            Weavermail.deleteLocationMail(Util.getIntValue(deletemails[i])) ;
        }
    }

    response.sendRedirect("WeavermailLocation.jsp?mailtype="+mailtype);
}

if(operation.equals("movemail")) {
    String movemails[] = request.getParameterValues("themail") ;
    String fromdetail = Util.null2String(request.getParameter("fromdetail")) ;

    WeavermailComInfo wmc ;

    MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
    Folder f = mud.getFolder() ;
    boolean fetchstatus = WeavermailUtil.fetchFolder( f , true , Folder.READ_WRITE ) ;
    if( !fetchstatus ) {
        verifyMailLogin.verify(null , null ,request) ;
        response.sendRedirect("Weavermail.jsp?message=fail");
        return;
    }
    int msgcount = f.getMessageCount();

    if(movemails != null) {
        for(int i = 0 ; i< movemails.length ; i++) {
            int moveemailindex = Util.getIntValue(movemails[i]) ;
            if ( moveemailindex <= msgcount ) {
                Message m = f.getMessage(moveemailindex);
                if(fromdetail.equals("1")) wmc = (WeavermailComInfo)session.getAttribute("WeavermailComInfo") ;
                else wmc = Weavermail.parseMail(m) ;

                Weavermail.locationMail(m,wmc , user,"0") ;
                Weavermail.deleteMail(m) ;
            }
        }
    }

    WeavermailUtil.fetchFolder( f , false , 0 ) ;
    response.sendRedirect("WeavermailLocation.jsp");
}

if(operation.equals("copymail")) {
    String copymails[] = request.getParameterValues("themail") ;
    String fromdetail = Util.null2String(request.getParameter("fromdetail")) ;

    WeavermailComInfo wmc ;

    MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
    Folder f = mud.getFolder() ;
    boolean fetchstatus = WeavermailUtil.fetchFolder( f , true , Folder.READ_WRITE ) ;
    if( !fetchstatus ) {
        verifyMailLogin.verify(null , null ,request) ;
        response.sendRedirect("Weavermail.jsp?message=fail");
        return;
    }
    int msgcount = f.getMessageCount();

    if(copymails != null) {
        for(int i = 0 ; i< copymails.length ; i++) {
            int copyemailindex = Util.getIntValue(copymails[i]) ;
            if ( copyemailindex <= msgcount ) {
                Message m = f.getMessage(copyemailindex);
                if(fromdetail.equals("1")) wmc = (WeavermailComInfo)session.getAttribute("WeavermailComInfo") ;
                else wmc = Weavermail.parseMail(m) ;

                Weavermail.locationMail(m,wmc , user,"0") ;
            }
        }
    }

    WeavermailUtil.fetchFolder( f , false , 0 ) ;
    response.sendRedirect("WeavermailLocation.jsp");
}

if(operation.equals("movemaill")) {
    String movemails[] = request.getParameterValues("themail") ;
    String movemailtype = Util.null2String(request.getParameter("mailtype")) ;

    if(movemails != null) {
        for(int i = 0 ; i< movemails.length ; i++) {
            Weavermail.moveLocationMail(Util.getIntValue(movemails[i]),movemailtype) ;
        }
    }
    response.sendRedirect("WeavermailLocation.jsp?mailtype="+movemailtype);
}

if(operation.equals("delfile")) {
    String sendoperation = Util.null2String(request.getParameter("sendoperation")) ;
    String msgid = Util.null2String(request.getParameter("msgid")) ;
    String location = Util.null2String(request.getParameter("location")) ;
    String fileid = Util.null2String(request.getParameter("fileid")) ;
    
    WeavermailComInfo wmc = (WeavermailComInfo)session.getAttribute("WeavermailComInfo") ;
    wmc.removeFile(fileid) ;
	
    response.sendRedirect("WeavermailAdd.jsp?operation="+sendoperation+"&msgid="+msgid+"&location="+location);
}

if(operation.equals("removepass")) {
    WeavermailUtil.removeUserMailInfo( user.getUID() ) ;
    response.sendRedirect("WeavermailIndex.jsp?message=3");
}

%>

