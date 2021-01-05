<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="java.util.*" %>
 

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />
<jsp:useBean id="verifyMailLogin" class="weaver.email.VerifyMailLogin" scope="page" />

<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
int pagenum=Util.getIntValue(request.getParameter("pagenum"),0) ;
String message = Util.null2String(request.getParameter("message")) ;
MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
if( mud == null ) {
    response.sendRedirect("WeavermailLogin.jsp") ; 
    return ;
}
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
int perpage=10 ;

int startpos=msgCount-pagenum*perpage ;
int endpos = msgCount-(pagenum+1)*perpage ;
if(endpos<0)    endpos=0 ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
if(message.equals("fail"))
	titlename += "<font color=red>"+SystemEnv.getHtmlLabelName(17002,user.getLanguage())+"</font>" ;

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(2029,user.getLanguage())+",WeavermailAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2030,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doDeleteforever(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2032,user.getLanguage())+",WeavermailIndex.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(pagenum>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",Weavermail.jsp?pagenum="+(pagenum-1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(endpos!=0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",Weavermail.jsp?pagenum="+(pagenum+1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM ACTION="WeavermailOperation.jsp" name="weaver" METHOD="POST" onSubmit="return check_form(this,'username,password')">
  <input type="hidden" name="fromLogin" value="1">
  <input type = hidden name=operation value=delete>
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

			  <table class=ListStyle cellspacing="1">
				<colgroup> <col width="5%"> <col width="5%"> <col width="25%"> <col width="40%">  <col width="15%"> <col width="10%">
				<tbody> 
				<tr class=Header> 
				  <th colspan=6><%=SystemEnv.getHtmlLabelName(16435,user.getLanguage())%> : <%=msgCount%></th>
				</tr>
				<tr class=Header>
				  <td>&nbsp;</td>
				  <td nowrap><%=SystemEnv.getHtmlLabelName(848,user.getLanguage())%></td>
				  <td><%=SystemEnv.getHtmlLabelName(2034,user.getLanguage())%></td>
				  <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
				  <td><%=SystemEnv.getHtmlLabelName(19736,user.getLanguage())%></td>
				  <td><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></td>
				</tr>
				<TR class=Line><TD colspan="6" ></TD></TR> 
				<%
			  int i=0;
			  Message m = null;
			  for (int j = startpos ; j >endpos ; j--) {
				m = f.getMessage(j);
				WeavermailComInfo wmc =  Weavermail.parseMail(m,false) ;

				if( wmc == null ) continue ;

				String subencode = wmc.getSubencode() ;
				String toencode = wmc.getToencode() ;
				String fromencode = wmc.getFromencode() ;
				//out.print("subencode is :"+subencode) ;
				//out.print("toencode is :"+toencode) ;
				//out.print("fromencode is :"+fromencode) ;
				String mailsubject = wmc.getSubject() ;
				if(mailsubject.equals("")) mailsubject = "No subject" ;
				if(i==0){
					i=1;
			  %>
				<tr class=datalight> 
				  <%
				}else{
					i=0;
			  %>
				<tr class=datadark> 
				  <%} %>
				  <td>
					<input type="checkbox" name="themail" value="<%=j%>">
				  </td>
				  <td nowrap><%
				  if(wmc.getPriority().equals("") || Util.getIntValue(wmc.getPriority().substring(0,1),3) ==3 ) {%>
				  <%=SystemEnv.getHtmlLabelName(2086,user.getLanguage())%>
				  <%} else if(Util.getIntValue(wmc.getPriority().substring(0,1),3) > 3 ) {%>
				   <%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
				  <%} else if(Util.getIntValue(wmc.getPriority().substring(0,1),3) < 3 ) {%>
				   <%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
				  <%}%>
				  </td>
				  <td><%=Util.toScreen(wmc.getSendfrom(),user.getLanguage(),fromencode)%></td>
				  <td><a href="WeavermailDetail.jsp?msgid=<%=j%>"><%=Util.toScreen(mailsubject,user.getLanguage(),subencode)%></a></td>
				  <td><%=wmc.getReceivedate()%></td>
				  <td><%=wmc.getSize()%></td>
				</tr>
				<%}
				WeavermailUtil.fetchFolder( f , false , 0 ) ; %>
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
<script>
function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='delete';
	document.weaver.submit();
	}
}

function doDeleteforever(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='deleteforever';
	document.weaver.submit();
	}
}
</script>


</html>