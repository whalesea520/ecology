<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.mail.internet.*" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />
<jsp:useBean id="verifyMailLogin" class="weaver.email.VerifyMailLogin" scope="page" />

<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
int msgid = Util.getIntValue(request.getParameter("msgid")) ;
if(msgid == -1) {
    response.sendRedirect("Weavermail.jsp");
    return ;
}

MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;
Folder f = mud.getFolder() ;
boolean fetchstatus = WeavermailUtil.fetchFolder( f , true , Folder.READ_ONLY ) ;
if( !fetchstatus ) {
    verifyMailLogin.verify(null , null ,request) ;
    response.sendRedirect("Weavermail.jsp?message=fail");
	return;
}

int msgcount = f.getMessageCount();
if( msgcount < msgid ) {
    response.sendRedirect("Weavermail.jsp?message=fail");
	return;
} 

Message m = f.getMessage(msgid);
WeavermailComInfo wmc = Weavermail.parseMail(m) ;

if( wmc == null ) {
    WeavermailUtil.forseCloseStore( f ) ;
    verifyMailLogin.verify(null , null ,request) ;
    response.sendRedirect("Weavermail.jsp?message=fail");
	return;
} 

session.setAttribute("WeavermailComInfo" , wmc) ;  

String subencode = wmc.getSubencode() ;
String toencode = wmc.getToencode() ;
String fromencode = wmc.getFromencode() ;
String contentencode = wmc.getContentencode() ; 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
int level = 0;
int levelNum = 0;
%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(2029,user.getLanguage())+",WeavermailAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2054,user.getLanguage())+",WeavermailAdd.jsp?operation=reply,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2053,user.getLanguage())+",WeavermailAdd.jsp?operation=replyall,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2052,user.getLanguage())+",WeavermailAdd.jsp?operation=forward&msgid="+msgid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2030,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doDeleteforever(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(16639,user.getLanguage())+",javascript:doMove(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(16640,user.getLanguage())+",javascript:doCopy(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!--added by lupeng 2004.05.25 for TD117-->
<IFRAME name="BlankSavePage" width="0" height="0" style="display:none"></IFRAME>
<!--end-->

<FORM id=weaver name=weaver ACTION="WeavermailOperation.jsp" METHOD="POST">
  <input type = hidden name=operation value=movemail>
  <input type = hidden name=themail value=<%=msgid%>>
  <input type="hidden" name="fromdetail" value="1">
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
			<tr class=Spacing> 
			  <td class=Line1 colspan=4></td>
			</tr>
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(2034,user.getLanguage())%></td>
			  <td class=Field><%=Util.toScreen(wmc.getSendfrom(),user.getLanguage(),fromencode)%> 
			  </td>
			  <td>CC</td>
			  <td class=Field><%=Util.toScreen(wmc.getCC(),user.getLanguage(),toencode)%> 
			  </td>
			</tr>
			<TR><TD class=Line colSpan=4></TD></TR> 
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(2046,user.getLanguage())%></td>
			  <td class=Field><%=Util.toScreen(wmc.getTO(),user.getLanguage(),toencode)%> 
			  </td>
			  <td><%=SystemEnv.getHtmlLabelName(2047,user.getLanguage())%></td>
			  <td class=Field><%=wmc.getSendDate()%> </td>
			</tr>
			<TR><TD class=Line colSpan=4></TD></TR> 
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
			  <td class=Field colspan="3"><%=Util.toScreen(wmc.getSubject(),user.getLanguage(),subencode)%></td>
			</tr>
			<tr class=Spacing> 
			  <td class=Line1 colspan=4></td>
			</tr>
			<tr> 
			  <td colspan="4"><br>
			  <% 
				String mailcontent = "" ; 
				if(wmc.getContenttype().equals("0")) 
					mailcontent = Util.toHtml(Util.toScreen(wmc.getContent(),user.getLanguage(),contentencode)) ;
				else 
					mailcontent = Util.toScreen(wmc.getContent(),user.getLanguage(),contentencode) ;
				
				if(wmc.hasHtmlimage()) {
					while(wmc.next()) {
						String isfileattrachment =  wmc.getCurrentFileAttachment() ;
						if( isfileattrachment.equals("1") ) 
							continue ;
							
							String thefilenum = wmc.getCurrentFilenum() ;
							level = wmc.getFileLevel(thefilenum);
							levelNum = wmc.getFileLevelNum(thefilenum);
						
							String thecontentid = wmc.getCurrentFileContentId() ;
							String oldsrc = "cid:" + thecontentid ;
							String newsrc =  "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownload?msgid="+msgid+"&level="+level+"&levelNum="+levelNum+"&filenum="+thefilenum ;

							mailcontent = Util.StringReplaceOnce(mailcontent , oldsrc , newsrc ) ;
					}
				}
			  %>
			  <%=mailcontent%>
			  <br><br></td>
			</tr>
			<tr class=Spacing> 
			  <td class=Line1 colspan=4></td>
			</tr>
			<%  wmc.resetCurrentfile() ;
				while(wmc.next()) { 
					String isfileattrachment =  wmc.getCurrentFileAttachment() ;
					if( isfileattrachment.equals("0") ) continue ;
                    
                    String filenameencode = wmc.getCurrentFilenameencode();
                    String attachName = wmc.getCurrentFilename();
                    String encodeFileName = null;

                    if(filenameencode.equals("1")){
                        encodeFileName = new String((wmc.getCurrentFilename()).getBytes("ISO8859_1"), "UTF-8") ;	
                        attachName = encodeFileName;
                    }
					String thefilenum = wmc.getCurrentFilenum() ;
					level = wmc.getFileLevel(thefilenum);
					levelNum = wmc.getFileLevelNum(thefilenum);
					String attachUrl = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownload?msgid="+msgid+"&level="+level+"&levelNum="+levelNum+"&filenum="+wmc.getCurrentFilenum();

            %>
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
			  <td class=Field colspan="3"><a href="<%=attachUrl%>"> <%=attachName%></a>   &nbsp;&nbsp;<BUTTON class=btn   onclick="BlankSavePage.location.href='<%=attachUrl%>&download=1'"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></BUTTON></td>
			</tr>
			<TR><TD class=Line colSpan=4></TD></TR> 
			<%}%>
			</tbody> 
		  </table>
 <% // f.close(false);%>

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

function doMove(){
	document.weaver.operation.value='movemail';
	document.weaver.submit();
}

function doCopy(){
	document.weaver.operation.value='copymail';
	document.weaver.submit();
}
</script>

</html>