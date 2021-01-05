
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.MailUserData" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="java.util.*" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />
<jsp:useBean id="verifyMailLogin" class="weaver.email.VerifyMailLogin" scope="page" />

<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
String message = Util.null2String(request.getParameter("message")) ;
MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
Folder f = mud.getFolder() ;
boolean fetchstatus = WeavermailUtil.fetchFolder( f , true , Folder.READ_ONLY ) ;
if( !fetchstatus ) {
    verifyMailLogin.verify(null , null ,request) ;
    mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
    f = mud.getFolder() ;
    fetchstatus = WeavermailUtil.fetchFolder( f , true , Folder.READ_ONLY ) ;
    if( !fetchstatus ) {
        response.sendRedirect("WeavermailLogin.jsp?message=fail");
	    return;
    }
}
int msgCount = f.getMessageCount();

WeavermailUtil.fetchFolder( f , false , 0 ) ;

RecordSet.executeProc("MailResource_SelectCount", ""+user.getUID()) ;
RecordSet.next() ;

int localcount = RecordSet.getInt(1) ;
int sendcount = RecordSet.getInt(2) ;
int draftcount = RecordSet.getInt(3) ;
int deletecount = RecordSet.getInt(4) ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
if(message.equals("1")) 
titlename += "<font color = red>"+SystemEnv.getHtmlLabelName(2044,user.getLanguage())+"</font>" ;
if(message.equals("2")) 
titlename += "<font color = red>"+SystemEnv.getHtmlLabelName(2045,user.getLanguage())+"</font>" ;
if(message.equals("3")) 
titlename += "<font color = red>"+SystemEnv.getHtmlLabelName(17003,user.getLanguage())+"</font>" ;
%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(18005,user.getLanguage())+",WeavermailLogin.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2029,user.getLanguage())+",WeavermailAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(16637,user.getLanguage())+",MailUserGroup.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(16638,user.getLanguage())+",javascript:doRemovePass(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM ACTION="WeavermailOperation.jsp" METHOD="POST" name=weaver>
  <input type="hidden" name="fromLogin" value="1">
  <input type = hidden name=operation value=removepass>
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
				<colgroup> <col width="15%"> <col width="85%">
				<tbody> 
				<tr class=Title> 
				  <th colspan=6><%=SystemEnv.getHtmlLabelName(2043,user.getLanguage())%> :<%=Util.toScreen(user.getUsername(),user.getLanguage())%></th>
				</tr>
				<tr class=Spacing> 
				  <td class=Line1 colspan=6 ></td>
				</tr>
				
				<tr  > 
				  <td><a href="Weavermail.jsp"><%=SystemEnv.getHtmlLabelName(2033,user.getLanguage())%></a>:</td>
				  <td class=Field><%=msgCount%></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR> 
				<tr  > 
				  <td><a href="WeavermailLocation.jsp?mailtype=0"><%=SystemEnv.getHtmlLabelName(2042,user.getLanguage())%></a>:</td>
				  <td class=Field><%=localcount%></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR> 
				<tr  > 
				  <td><a href="WeavermailLocation.jsp?mailtype=1"><%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%></a>:</td>
				  <td class=Field><%=sendcount%></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR> 
				<tr  > 
				  <td><a href="WeavermailLocation.jsp?mailtype=2"><%=SystemEnv.getHtmlLabelName(2039,user.getLanguage())%></a>:</td>
				  <td class=Field><%=draftcount%></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR> 
				<tr  > 
				  <td><a href="WeavermailLocation.jsp?mailtype=3"><%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())%></a>:</td>
				  <td class=Field><%=deletecount%></td>
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
  <script>
function doRemovePass(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17004,user.getLanguage())%>")) {
	    document.weaver.operation.value='removepass';
	    document.weaver.submit();
	}
}
</script>
</BODY>
</html>