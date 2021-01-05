
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.email.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SptmForMail" class="weaver.splitepage.transform.SptmForMail" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

int layout = 3;
rs.executeSql("SELECT * FROM MailSetting WHERE userId="+user.getUID()+"");
if(rs.next()){
	layout = rs.getInt("layout");
}

int folderId = Util.getIntValue(request.getParameter("folderId"));
int mailId = Util.getIntValue(request.getParameter("id"));
if(mailId==-1){
	rs.executeSql("SELECT id AS maxid FROM MailResource WHERE folderId="+folderId+" AND resourceid="+user.getUID()+" ORDER BY senddate DESC");
	rs.next();
	mailId = rs.getInt("maxid");
}

int flag = Util.getIntValue(request.getParameter("flag"));

int mailResourceId = 0;
rs.executeSql("SELECT resourceid FROM mailresource WHERE id="+mailId+"");
if(rs.next()){
	mailResourceId = rs.getInt("resourceid");
}
if(mailResourceId!=user.getUID() &&mailId>0){//无权限查看邮件
	response.sendRedirect("/notice/noright.jsp");
}
boolean hasAttachment = false;
String fileId = "";
String fileUrl = "";
int fileNum = 0;

String priority="",sendfrom="",sendcc="",sendto="",sendbcc="",senddate="",subject="",content="",contentType="",hasHtmlImage="",emlName="";
String _emlPath="";
ArrayList filenames = new ArrayList() ;
ArrayList filenums  = new ArrayList() ;
ArrayList filenameencodes  = new ArrayList() ;
String contentencode = "";
//=====================================================================
//Read Mail
ConnStatement statement=new ConnStatement();
try{
	if("oracle".equals(statement.getDBType())){
		statement.setStatementSql("select t1.emlpath,t1.priority,t1.sendfrom,t1.sendcc,t1.sendbcc,t1.sendto,t1.senddate,t1.subject,t1.emlName,t1.content,t1.mailtype,t1.hasHtmlImage,t2.mailcontent from MailResource t1,MailContent t2 where t1.id=t2.mailid and t1.id = " + mailId) ;
	}else{
		statement.setStatementSql("select emlpath,priority,sendfrom,sendcc,sendbcc,sendto,senddate,subject,emlName,content,mailtype,hasHtmlImage from MailResource where id = " + mailId) ;	
	}
	statement.executeQuery();
	while(statement.next()){
        priority = statement.getString("priority") ;
        sendfrom = statement.getString("sendfrom") ;
        sendcc = statement.getString("sendcc") ;
        sendbcc = statement.getString("sendbcc") ;
        sendto = statement.getString("sendto") ;
        senddate = statement.getString("senddate") ;
        subject = statement.getString("subject") ;
		emlName = statement.getString("emlName");

        if("oracle".equals(statement.getDBType())){
            CLOB theclob = statement.getClob("mailcontent");
            String readline = "";
            StringBuffer clobStrBuff = new StringBuffer("");
            BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
            while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline+"\n");
            clobin.close() ;
            content = clobStrBuff.toString();
        }else{
            content = statement.getString("content") ;
        }
    }
	contentType = statement.getString("mailtype");
	hasHtmlImage = statement.getString("hasHtmlImage") ;
}catch(Exception e) {
}finally {
	statement.close();
}

//=====================================================================
//Build WeavermailComInfo
WeavermailComInfo wmc = new WeavermailComInfo() ;
wmc.setPriority(priority) ;
wmc.setRealeSendfrom(sendfrom) ;
wmc.setRealeCC(sendcc) ;
wmc.setRealeTO(sendto) ;
wmc.setRealeBCC(sendbcc) ;
wmc.setSendDate(senddate) ;
wmc.setSubject(subject) ;
wmc.setContent(content);
wmc.setContenttype(contentType);
if(("1").equals(hasHtmlImage)){
    wmc.setHtmlimage(true);
}else{
    wmc.setHtmlimage(false);
}
contentencode = wmc.getContentencode() ; 
//=====================================================================
//Mark Mail Read
rs.executeSql("UPDATE MailResource SET status='1' WHERE id="+mailId+"");
//=====================================================================
//EML
rs.executeSql("select emlpath from MailResource WHERE id="+mailId+"");
if(rs.next()) _emlPath = Util.null2String(rs.getString("emlpath"));
String emlPath = GCONST.getRootPath() + "email" + File.separatorChar + "eml" + File.separatorChar;
File eml = new File(emlPath + emlName + ".eml");
if(!_emlPath.equals("")) eml = new File(_emlPath);

%>

<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript">
Event.observe(window, "load", function(){
	var f, w;
	w = window.opener ? window.opener : window;
	Try.these(
		function(){f = w.parent.parent.document.getElementById("mailFrameSet").firstChild;f.contentWindow.getUnReadMailCount();},
		function(){f = w.parent.document.getElementById("mailFrameSet").firstChild;f.contentWindow.getUnReadMailCount();}
	);
});

function redirect(flag){
	var url;
	if(flag){
		url = "MailAdd.jsp?flag="+flag+"&mailId=<%=mailId%>";
	}else{
		var mailAddress = event.srcElement.innerHTML;
		mailAddress = mailAddress.replace("(","<");
		mailAddress = mailAddress.replace(")",">");
		url = "MailAdd.jsp?to="+mailAddress+"";
	}
	redirectByFrame(url);
}
function redirectByFrame(url){
	if(parent.mailFrameLeft||parent.mainFrame){
		location = url;
	}else{
		parent.location = url;
	}
}
function toggleSendFrom(){
	var o = $("mailHeader");
	var styleDisplay = "";
	if($("arrow").src.indexOf("Left")==-1){
		styleDisplay = "none";
		$("arrow").src = "/images/mail_arrowLeft_wev8.gif";
	}else{
		styleDisplay = "";
		$("arrow").src = "/images/mail_arrowDown_wev8.gif";
	}
	(<%if(!sendcc.equals("")){out.print("4");}else{out.print("3");}%>).times(function(i){o.rows[i+1].style.display=styleDisplay;});
}
function addToContacter(mailAddress){
	var o = event.srcElement;
	o.src = "/images/loading2_wev8.gif";
	new Ajax.Request("MailContacterOperation.jsp", {
		onSuccess : function(resp){
			o.src = "/images/replyDoc/usersuss_wev8.gif";
			var mailAddressIsExist = jQuery.trim(resp.responseText.stripScripts().stripTags().escapeHTML());
			if(mailAddressIsExist==1){
				alert("<%=SystemEnv.getHtmlLabelName(19957,user.getLanguage())%>.");//邮件地址已存在
				return false;
			}else{
				redirectByFrame("MailContacterAdd.jsp?groupId=0&mailAddress="+mailAddress+"");
			}
		},
		onFailure : function(){alert("error!")},
		parameters : "operation=contacterCheck&mailAddress="+mailAddress+""
	});
}
function downloadEML(){
	$("frmEML").submit();
}
String.prototype.trim = function(){
	return (this.replace(/^\s+|\s+$/g,""));
}
function parseEML(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(20496,user.getLanguage())%>")){
		hideRightClickMenu();
		showMsgBox($("actionMsgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelName(20495,user.getLanguage())%>");
		location.href = "ParseEML.jsp?id=<%=mailId%>";
	}
}
function showMsgBox(o, msg){
	with(o){
		innerHTML = msg;
		style.display = "inline";
		style.position = "absolute"
		style.posTop = document.body.offsetHeight/2+document.body.scrollTop-50;
		style.posLeft = document.body.offsetWidth/2-50;
	}
}

function doDelete(layoutvalue,obj){
		$("operationFORM").operation.value = "delete";
		callAjax(obj,layoutvalue);
}
function doRemove(layoutvalue,obj){
		if(confirm("<%=SystemEnv.getHtmlLabelName(19951,user.getLanguage())%>")){
			$("operationFORM").operation.value = "remove";
		}else{
			return false;
		}
		callAjax(obj,layoutvalue);
}
function callAjax(obj,layoutvalue){
	obj.disabled=true;
	new Ajax.Request("MailOperation.jsp", {
		onSuccess : function(){obj.disabled=false;backToMailInboxList(layoutvalue);},
		onFailure : function(){alert("Error!");obj.disabled=false;},
		parameters : "mailIds="+$F("mailIds")+"&operation="+$F("operation")+""
	});	
}
function backToMailInboxList(layoutvalue){
	try{
		if(layoutvalue==4){
			document.location = "MailSearch.jsp";
		}else{
			if(layoutvalue==1){
				parent.frames["mailInboxRight"].document.location = "MailView.jsp?folderId=<%=folderId%>";
				parent.frames["mailInboxLeft"].document.location = "MailInboxList.jsp?folderId=<%=folderId%>";
			}
			if(layoutvalue==2){
				parent.frames["mailInboxRight"].document.location = "MailView.jsp?folderId=<%=folderId%>";
				parent.frames["mailInboxLeft"].document.location = "MailInboxList.jsp?folderId=<%=folderId%>";
			}
			if(layoutvalue==3){
				//document.location = "MailInboxList.jsp?folderId=<%=folderId%>";
				opener.location="MailInboxList.jsp?folderId=<%=folderId%>";
				window.close();
			}
		}	
	}catch(e){}
}


</script>
<style type="text/css" media="screen">
/* <[CDATA[ */
.header{background-color:#CCC}
#mailHeader td{padding:2px 0 2px 10px;font:12px "MS Shell Dlg",Arial,Verdana}
/* ]]> */
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body style="overflow:auto">
<div class="xTable_message" style="display:" id="actionMsgBox"></div>

<form id="frmEML" method="post" action="DownloadEML.jsp">
<input type="hidden" name="mailId" id="mailId" value="<%=mailId%>"/>
<input type="hidden" name="subject" id="subject" value="<%=subject%>"/>
</form>

<form id="operationFORM" method="post" action="MailOperation.jsp">
<input type="hidden" name="operation" value="">
<input type="hidden" name="mailIds" value="<%=mailId%>"/>
<input type="hidden" name="folderId" value="<%=folderId%>">
</form>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(folderId==-2){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:redirect(4),_self} ";//发送
	RCMenuHeight += RCMenuHeightStep;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(117,user.getLanguage())+",javascript:redirect(1),_self} ";//回复
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2053,user.getLanguage())+",javascript:redirect(2),_self} ";//回复全部
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(6011,user.getLanguage())+",javascript:redirect(3),_self} ";//转发
	RCMenuHeight += RCMenuHeightStep;
}
if(eml.exists()){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20494,user.getLanguage())+",javascript:parseEML(),_self} " ;    
	RCMenuHeight += RCMenuHeightStep;
}
if(folderId!=-3){
	if(flag==1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(4,this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else{
		if(layout == 1){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(1,this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(layout == 2){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(2,this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(layout == 3){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(3,this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	}
}
if(flag==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doRemove(4,this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	if(layout == 1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doRemove(1,this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(layout == 2){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doRemove(2,this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(layout == 3){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doRemove(3,this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="mailHeader" cellspacing="0" style="height:50px;width:100%">
<tr class="header">
	<td width="50" nowrap><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%>:</td>
	<td width="100%" style="font-weight:bold"><%=subject%></td>
	<td onclick="toggleSendFrom()" style="cursor:hand;text-align:right"><img id="arrow" src="/images/mail_arrowDown_wev8.gif">&nbsp;</td>
</tr>
<tr class="header">
	<td><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())%>:</td>
	<td colspan="2">
		<%if(sendfrom.equals("")){%>
			<span style="color:blue;text-decoration:underline;cursor:hand" onclick="redirect()"></span>
			<img src="/images/replyDoc/usersuss_wev8.gif" 
			style="vertical-align:middle;cursor:hand;<%if(sendfrom.equals(""))out.print("display:none;");%>" 
			alt="<%=SystemEnv.getHtmlLabelName(19956, user.getLanguage())%>" 
			onclick="addToContacter('<%=sendfrom%>')"/>
		<%}else{%>
			<span style="color:blue;text-decoration:underline;cursor:hand" onclick="redirect()"><%=SptmForMail.getNameByEmail(sendfrom)%></span>
			<img src="/images/replyDoc/usersuss_wev8.gif" 
			style="vertical-align:middle;cursor:hand;<%if(sendfrom.equals(""))out.print("display:none;");%>" 
			alt="<%=SystemEnv.getHtmlLabelName(19956, user.getLanguage())%>" 
			onclick="addToContacter('<%=sendfrom%>')"/>
		<%}%>
		
	</td>
</tr>
<tr class="header">
	<td><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%>:</td>
	<td colspan="2"><%=senddate%></td>
</tr>
<tr class="header">
	<td><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%>:</td>
	<td colspan="2">
	<%
	String _sendto = sendto + ",";
	String[] arraySendTo = Util.TokenizerString2(_sendto, ",");
	for(int i=0;i<arraySendTo.length;i++){
		if(arraySendTo[i].equals("")){continue;}
		out.print("<span style='color:blue;text-decoration:underline;cursor:hand' onclick='redirect()'>"+SptmForMail.getNameByEmail(arraySendTo[i])+"</span> ");
		out.println("<img src='/images/replyDoc/usersuss_wev8.gif' style='vertical-align:middle;cursor:hand'	alt='"+SystemEnv.getHtmlLabelName(19956, user.getLanguage())+"' onclick='addToContacter(\""+arraySendTo[i]+"\")'/> ");
	}
	%>
	</td>
</tr>
<%if(!sendcc.equals("")){%>
<tr class="header">
	<td><%=SystemEnv.getHtmlLabelName(2084, user.getLanguage())%>:</td>
	<td colspan="2">
	<%
	String _sendcc = sendcc + ",";
	String[] arraySendCc = Util.TokenizerString2(_sendcc, ",");
	for(int i=0;i<arraySendCc.length;i++){
		if(arraySendCc[i].equals("")){continue;}
		out.print("<span style='color:blue;text-decoration:underline;cursor:hand' onclick='redirect()'>"+SptmForMail.getNameByEmail(arraySendCc[i])+"</span> ");
		out.print("<img src='/images/replyDoc/usersuss_wev8.gif' style='vertical-align:middle;cursor:hand' alt='"+SystemEnv.getHtmlLabelName(19956, user.getLanguage())+"' onclick='addToContacter(\""+arraySendCc[i]+"\")'/> ");
	}
	%>
	</td>
</tr>
<%}
if(wmc.hasHtmlimage()){
	rs.executeSql("select id ,isfileattrachment,fileContentId from MailResourceFile where mailid="+mailId+" and isfileattrachment=0");
	int thefilenum = 0;
	while(rs.next()){ 
		String isfileattrachment = rs.getString("isfileattrachment");
		thefilenum++;
		String imgId = rs.getString("id");
		String thecontentid = rs.getString("fileContentId");
		String oldsrc = "cid:" + thecontentid ;
		String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+imgId;
		content = Util.StringReplaceOnce(content , oldsrc , newsrc ) ;
	}
}
//=====================================================================
//Get Mail Attachments
rs.executeSql("select * from MailResourceFile where mailid = " + mailId+" and isfileattrachment=1");
if(rs.next()){
	hasAttachment = true;
	rs.beforFirst();
}

//图片显示处理
rs1.executeSql("select id ,isfileattrachment,fileContentId from MailResourceFile where mailid="+mailId);
int thefilenum = 0;
while(rs1.next()){ 
	String isfileattrachment = rs1.getString("isfileattrachment");
	thefilenum++;
	String imgId = rs1.getString("id");
	String thecontentid = rs1.getString("fileContentId");
	String oldsrc = "cid:" + thecontentid ;
	String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+imgId+"&";
	content = Util.StringReplaceOnce(content , oldsrc , newsrc ) ;
}

if(hasAttachment){
%>
<tr class="header">
	<td><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%>:</td>
	<td colspan="2">
	<%
	while(rs.next()){ 
		fileId = rs.getString("id");
		filenames.add(rs.getString("filename")) ;
		filenums.add(fileId) ;
		filenameencodes.add("1") ;
		fileNum++ ; 
		fileUrl = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+fileId;
	%>
	<a href="<%=fileUrl%>&download=1" style="color:blue;text-decoration:underline"><%=Util.toScreen(rs.getString("filename"), user.getLanguage())%></a>&nbsp;
	<%}%>
	</td>
</tr>
<%
}
	
wmc.setTotlefile(fileNum);
wmc.setFilenames(filenames);
wmc.setFilenums(filenums);
wmc.setFilenameencodes(filenameencodes);
session.setAttribute("WeavermailComInfo", wmc);

content = Util.replace(content, "==br==", "\n", 0);

if(eml.exists()){
%>
<tr class="header">
	<td nowrap><%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(71, user.getLanguage())%>:</td>
	<td colspan="2">
	<span onclick="javascript:downloadEML();" class="href"><%=Util.toScreen(subject, user.getLanguage())%>.eml</span>&nbsp;
	</td>
</tr>
<%}%>
<tr>
	<td colspan="3" style="padding:10px"><%if(contentType.equals("0")){out.print("<pre style='font:12px MS Shell Dlg,Arial'>"+content+"</pre>");}else{out.print(content);}%></td>
</tr>
</table>
</body>
</html>