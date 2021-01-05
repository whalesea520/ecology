<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.email.MailUserData" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="verifyMailLogin" class="weaver.email.VerifyMailLogin" scope="page" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
int userid = user.getUID() ;
WeavermailUtil.getUserMailInfo( userid ) ;
String username = Util.null2String(WeavermailUtil.getUsername()) ;
String password = Util.null2String(WeavermailUtil.getUserPassword()) ;
boolean checkright = false ;
if (!username.equals("") && !password.equals(""))
checkright = verifyMailLogin.verify(username,password ,request) ;

int msgCount = 0 ;
if (checkright) {
MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
Folder f = mud.getFolder() ;
if(!f.isOpen()) f.open(Folder.READ_WRITE);
msgCount = f.getMessageCount();
f.close(false);
}
%>

<table class=ListStyle id=tblReport cellspacing=1>
    <tbody> 
    <tr class=Header> 
      <th height = 30><%=SystemEnv.getHtmlLabelName(1213,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href = "/email/Weavermail.jsp" target = "mainFrame"><font color="FFFFFF"><%=SystemEnv.getHtmlLabelName(15086,user.getLanguage())%><%=msgCount%><%=SystemEnv.getHtmlLabelName(15087,user.getLanguage())%></font></a></th>
    </tr>

</table>

</body>
</html>