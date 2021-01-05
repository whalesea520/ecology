
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
 <jsp:useBean id="WeavermailSend" class="weaver.email.WeavermailSend" scope="page" />
<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />
<jsp:useBean id="verifyMailLogin" class="weaver.email.VerifyMailLogin" scope="page" />
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<script language="javascript" type="text/javascript">
window.onload=function(){
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	FCKEditorExt.initEditor('weaver','body1',lang);
};
</script>
</head>

<%
String usermail=user.getEmail();

MailUserData mud = (MailUserData)session.getAttribute("WeaverMailSet") ;

if( mud == null ) {
    response.sendRedirect("WeavermailLogin.jsp") ;
    return ;
}

String sendfrom = mud.getUsermail() ;
WeavermailComInfo wmc = null ;

String operation = Util.null2String(request.getParameter("operation")) ;
String location = Util.null2String(request.getParameter("location")) ;
String msgid = Util.null2String(request.getParameter("msgid")) ;

String to = "" ;
String cc = "" ;
String bcc = "" ;
String subject = "" ;
String content = "" ;
int level = 0;
int levelNum = 0;
int hasfile = 0 ;

if(!operation.equals("")) {
    wmc = (WeavermailComInfo)session.getAttribute("WeavermailComInfo") ;
    if(operation.equals("reply")) {
        to = wmc.getRealeSendfrom() ;
        subject = "Re:" + Util.toScreen(wmc.getSubject() ,user.getLanguage() , wmc.getSubencode()) ;
        content = "\n\n\n\n -----Original Message-----\n From : "+
                Util.toScreen(wmc.getSendfrom() ,user.getLanguage() , wmc.getFromencode()) +
                "\n Send : " + wmc.getSendDate() +
                "\n To : " + Util.toScreen(wmc.getTO() ,user.getLanguage() , wmc.getToencode()) +
                "\n Cc : " + Util.toScreen(wmc.getCC() ,user.getLanguage() , wmc.getToencode()) +
                "\n Subject : " + Util.toScreen(wmc.getSubject() ,user.getLanguage() , wmc.getSubencode()) +
                "\n\n " + Util.fromHtmlToEdit(Util.toScreen(wmc.getContent() ,user.getLanguage() , wmc.getContentencode())) ;
    }
    if(operation.equals("replyall")) {
        to = wmc.getRealeSendfrom()+","+wmc.getRealeTO()+","+wmc.getRealeCC() ;
        subject = "Re:" + Util.toScreen(wmc.getSubject() ,user.getLanguage() , wmc.getSubencode()) ;
        content = "\n\n\n\n -----Original Message-----\n From : "+
                Util.toScreen(wmc.getSendfrom() ,user.getLanguage() , wmc.getFromencode()) +
                "\n Send : " + wmc.getSendDate() +
                "\n To : " + Util.toScreen(wmc.getTO() ,user.getLanguage() , wmc.getToencode()) +
                "\n Cc : " + Util.toScreen(wmc.getCC() ,user.getLanguage() , wmc.getToencode()) +
                "\n Subject : " + Util.toScreen(wmc.getSubject() ,user.getLanguage() , wmc.getSubencode()) +
                "\n\n " + Util.fromHtmlToEdit(Util.toScreen(wmc.getContent() ,user.getLanguage() , wmc.getContentencode())) ;
    }
    if(operation.equals("forward")) {
        subject = SystemEnv.getHtmlLabelName(132408, user.getLanguage()) + Util.toScreen(wmc.getSubject() ,user.getLanguage() , wmc.getSubencode()) ; //转发:  Fw:
        content = "\n\n\n\n -----Original Message-----\n From : "+
                Util.toScreen(wmc.getSendfrom() ,user.getLanguage() , wmc.getFromencode()) +
                "\n Send : " + wmc.getSendDate() +
                "\n To : " + Util.toScreen(wmc.getTO() ,user.getLanguage() , wmc.getToencode()) +
                "\n Cc : " + Util.toScreen(wmc.getCC() ,user.getLanguage() , wmc.getToencode()) +
                "\n Subject : " + Util.toScreen(wmc.getSubject() ,user.getLanguage() , wmc.getSubencode()) +
                "\n\n " + Util.fromHtmlToEdit(Util.toScreen(wmc.getContent() ,user.getLanguage() , wmc.getContentencode())) ;
    }
    if(operation.equals("send")) {
        to = wmc.getRealeTO() ;
        cc = wmc.getRealeCC() ;
        bcc = wmc.getRealeBCC() ;
        subject = Util.toScreen(wmc.getSubject() ,user.getLanguage() , wmc.getSubencode()) ;
        content = Util.fromHtmlToEdit(Util.toScreen(wmc.getContent() ,user.getLanguage() , wmc.getContentencode())) ;
    }
}




String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>


<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(2083,user.getLanguage())+",javascript:doSend(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(operation.equals("")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:doDraft(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=weaver name=weaver ACTION="WeavermailSendOperation.jsp" METHOD="POST">
  <input type = hidden name=operation value=sendmail>
  <input type = hidden name=savedraft value="">
  <input type = hidden name=location value="<%=location%>">
  <input type = hidden name=msgid value="<%=msgid%>">
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
		<table class=Shadow>
		<tr>
		<td valign="top">

			  <table class=ViewForm>
				<tbody>
				<colgroup><col width="10%"><col width="90%">
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(2034,user.getLanguage())%></td>
				  <td class=Field><%=Util.toScreen(user.getUsername(),user.getLanguage())%> &lt;<%=sendfrom%>&gt;
					<input type="hidden" name="sendfrom" value="<%=sendfrom%>">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(2046,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" id="TO" name="TO" class="InputStyle" size="60" onchange='checkinput("TO","TOimage")' value='<%=WeavermailSend.getNameAndEmailStrs(to)%>'><button class=Browser
						id=SelectLocation onClick="onShowResourcemail(TO,idsTO)"></button>(<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>)
					<button class=Browser id=SelectLocation onClick="onShowResourceGroup(TO)"></button>(<%=SystemEnv.getHtmlLabelName(16637,user.getLanguage())%>)
						  <span id=TOimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span> <%=SystemEnv.getHtmlLabelName(2089,user.getLanguage())%>
						  <input type="hidden" id="idsTO"  value="<%=WeavermailSend.getUserIds(to)%>">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" name="CC" id="CC" class="InputStyle" size="60" value='<%=WeavermailSend.getNameAndEmailStrs(cc)%>'><button class=Browser
						id=SelectLocation onClick="onShowResourcemail(CC,idsCC)"></button>(<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>)
					<button class=Browser id=SelectLocation onClick="onShowResourceGroup(CC)"></button>(<%=SystemEnv.getHtmlLabelName(16637,user.getLanguage())%>)
						<%=SystemEnv.getHtmlLabelName(2090,user.getLanguage())%>
						<input type="hidden" id="idsCC"  value="<%=WeavermailSend.getUserIds(cc)%>">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(2085,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" name="BCC" id="BCC" class="InputStyle" size="60" value='<%=WeavermailSend.getNameAndEmailStrs(bcc)%>'><button class=Browser
						id=SelectLocation onClick="onShowResourcemail(BCC,idsBCC)"></button>(<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>)
					<button class=Browser id=SelectLocation onClick="onShowResourceGroup(BCC)"></button>(<%=SystemEnv.getHtmlLabelName(16637,user.getLanguage())%>)
						<%=SystemEnv.getHtmlLabelName(2091,user.getLanguage())%>
						<input type="hidden" id="idsBCC" value="<%=WeavermailSend.getUserIds(bcc)%>">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" name="subject" size="60" class="InputStyle" value=<%=subject%>>
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19110,user.getLanguage())%></td>
				  <td class=Field>
					<input TYPE="radio" NAME="texttype" checked onClick="onChangeTextType(1)" value="1"><%=SystemEnv.getHtmlLabelName(19112,user.getLanguage())%>
					<input TYPE="radio" NAME="texttype" onClick="onChangeTextType(2)" value="2"><%=SystemEnv.getHtmlLabelName(19111,user.getLanguage())%>
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr>
				<tr id="plaintext1" style="display:none">
				  <td>&nbsp;</td>
				  <td>
					<textarea id="body" name="body" class="InputStyle" style="border:1 solid #000000; font-size:9pt; overflow:auto; width:100% height=200;" cols=130 rows="15"><%=content%></textarea>
				  </td>
				</tr>
				<tr id="plaintext2" style="display:none"><td class=Line colSpan=2></td></tr>
				<tr><td colspan="2"><div id="hypertext" style="display:''"><table width="93%">
				
				<!---###@2007-08-29 modify by yeriwei!
				<tr id="hypertext1">
				  <td width="10%"><%=SystemEnv.getHtmlLabelName(681,user.getLanguage())%></td>
				  <td>
					<div id=divimg name=divimg>
					<input class=InputStyle  type=file name=docimages_0 size=60>
					</div>
					<input type=hidden name=docimages_num value=0></input>
					<%=SystemEnv.getHtmlLabelName(18952,user.getLanguage())%>
				  </td>
				</tr>
				<tr id="hypertext2"><td class=Line colSpan=2></td></tr>
				--->
				
				<tr id="hypertext3">
				  <td>&nbsp;</td>
				  <td>
					<textarea id="body1" name="body1" class="InputStyle" style="display:none;border:1px solid #000000; font-size:9pt; overflow:auto; width:100% height:200;" cols=130 rows="15"><%=content%></textarea>
					<!---###@2007-08-29 modify by yeriwei!
					<div id=divifrm>
					<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height:300px" id="dhtmlFrm"></iframe>
					</div>
					<%  if(!content.equals("")) {%>
					
					<script FOR=window event="onload" LANGUAGE=javascript>
						document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=document.weaver.body1.innerText;
					</script>
					<%}%>
					--->
				  </td>
				</tr>
				<tr id="hypertext4"><td class=Line colSpan=2></td></tr>
				</table></div></td></tr>
				<tr>
				  <td>&nbsp; </td>
				  <td>
					<input type="checkbox" name="savesend" value="1" checked >
					<%=SystemEnv.getHtmlLabelName(2092,user.getLanguage())%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(2093,user.getLanguage())%>
					<select name="priority" class="InputStyle">
					  <option value="3"><%=SystemEnv.getHtmlLabelName(2086,user.getLanguage())%></option>
					  <option value="2"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
					  <option value="4"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
					</select>
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr>
				<% if(operation.equals("forward") || operation.equals("send")) {
						String linkstr = "" ;
						if(location.equals("1")) linkstr = "/weaver/weaver.email.FileDownloadLocation?fileid=" ;
						else linkstr = "/weaver/weaver.email.FileDownload?msgid="+msgid+"&filenum=" ;

						wmc.resetCurrentfile() ;
						while(wmc.next()) {
							hasfile ++ ;
							//String isfileattrachment =  wmc.getCurrentFileAttachment() ;
							//if( isfileattrachment.equals("0") ) continue ;

	            //String filenameencode = wmc.getCurrentFilenameencode();
	            String attachName = wmc.getCurrentFilename();
	            String encodeFileName = null;
	            if(!location.equals("1")){
	                encodeFileName = new String((wmc.getCurrentFilename()).getBytes("ISO8859_1"), "UTF-8") ;
	                attachName = encodeFileName;
	            }
							//String thefilenum = wmc.getCurrentFilenum() ;
							//level = wmc.getFileLevel(thefilenum);
							//levelNum = wmc.getFileLevelNum(thefilenum);
							//String attachUrl = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownload?msgid="+msgid+"&level="+level+"&levelNum="+levelNum+"&filenum="+wmc.getCurrentFilenum();
				%>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
				  <td class=Field colspan="3"> <a href="<%=linkstr%><%=wmc.getCurrentFilenum()%>"> <%=attachName%></a>

                  &nbsp;&nbsp;<button class=btn accessKey="<%=wmc.getCurrentFilenum()%>"  onclick="if(isdel()){window.location.href='WeavermailOperation.jsp?operation=delfile&fileid=<%=wmc.getCurrentFilenum()%>&sendoperation=<%=operation%>&msgid=<%=msgid%>&location=<%=location%>'}"><u><%=wmc.getCurrentFilenum()%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button></td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr> 
				<%}}%>
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
				  <td class=Field> 
					<input type="file" name="attachfile0" size="50" class="InputStyle">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
				  <td class=Field> 
					<input type="file" name="attachfile1" size="50" class="InputStyle">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
				  <td class=Field> 
					<input type="file" name="attachfile2" size="50" class="InputStyle">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
				  <td class=Field> 
					<input type="file" name="attachfile3" size="50" class="InputStyle">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
				  <td class=Field> 
					<input type="file" name="attachfile4" size="50" class="InputStyle">
				  </td>
				</tr>
				<tr><td class=Line colSpan=2></td></tr> 
				</tbody> 
			  </table>
		</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<input type = hidden name=hasfile value="<%=hasfile%>">
</form>
</body>

<script language=javascript>
function doSend(obj){
	if(document.weaver.texttype[0].checked){
		/**
		var text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		<%
		//TD5167
		//modified by hubo, 2006-10-26
		%>
		text = text.replace(/<meta.*charset.*?>/ig, "");
		document.weaver.body1.value=text;
		***/
		FCKEditorExt.updateContent();
		//alert(document.weaver.body1.value);
	}
	//alert(document.weaver.texttype[0].value);
	if(check_form(document.weaver,'TO')) {
	    if(document.weaver.subject.value == "") {
            if(confirm("<%=SystemEnv.getHtmlLabelName(19109,user.getLanguage())%>")) 
	            document.weaver.submit();
        }
        else document.weaver.submit();
	}
}

function doDraft(){
	if(document.weaver.texttype[0].checked){
		/***###@2007-08-29 modify by yeriwei!
		var text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.body1.value=text;
		***/
		//alert(document.weaver.body1.value);
		FCKEditorExt.updateContent();
	}
    document.weaver.savedraft.value="1" ;
    document.weaver.submit();
}
String.prototype.trim = function() {
return (this.replace(/^\s+|\s+$/g,""));
}


function onChangeTextType(type){
	if(type==2){
		//if(!document.weaver.texttype[0].checked)
			//alert("警告：如果将邮件的格式由超文本改为纯文本，您将丢失邮件中的所有格式信息！");
		plaintext1.style.display="";
		plaintext2.style.display="";
		hypertext.style.display="none";
	}else{
		plaintext1.style.display="none";
		plaintext2.style.display="none";
		hypertext.style.display="";
	}
}
</script>

<script language=vbscript>

sub onShowResourcemail(objNames,objIds)   
    objidsValue=objIds.value
	strTemp=""
    if(objidsValue<>"") then strTemp="?resourceids=" & objidsValue End if

    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MutiResourceMailBrowser.jsp"&strTemp)
	
	 if (Not IsEmpty(id)) then
        if id(0)<> "" then
          objIds.value=id(0)
        else
          objIds.value=""
        end if

        if id(1)<> "" then
          objNames.value=id(1)
        else
          objNames.value=""
        end if
		
	end if 
end Sub

sub onShowResourceGroup(inputid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MailUserGroupBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0) <> "" then
            if trim(inputid.value) <> "" then
                inputid.value=inputid.value & "," & id(0)
            else
                inputid.value=id(0)
            end if
        else 
            inputid.value=""
        end if
	end if 
end sub
</script>

</html>