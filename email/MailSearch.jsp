
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mailSearchComInfo" class="weaver.email.search.MailSearchComInfo" scope="session" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19824,user.getLanguage());
String needfav ="1";
String needhelp ="";

String refreshTreeMenu = Util.null2String(request.getParameter("refreshTreeMenu"));
String act = Util.null2String(request.getParameter("act"));
String subject = act.equals("search") ? mailSearchComInfo.getSubject() : Util.null2String(request.getParameter("subject"));
int folderId = Util.getIntValue(request.getParameter("folderId"), 0);
int pageSize = 10;
int layout = 1;
int mainId = -1;
int subId = -1;
int secId = -1;
int crmSecId = -1;

rs.executeSql("SELECT * FROM MailSetting WHERE userId="+user.getUID()+"");
if(rs.next()){
	//pageSize = rs.getInt("perpage");
	layout = rs.getInt("layout");
	mainId = rs.getInt("mainId");
	subId = rs.getInt("subId");
	secId = rs.getInt("secId");
	crmSecId = rs.getInt("crmSecId");
}

String sendfrom = Util.null2String(request.getParameter("sendfrom"));
String sendto = Util.null2String(request.getParameter("sendto"));
String mailAccountId = Util.null2String(request.getParameter("mailAccountId"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String searchFolderId = Util.null2String(request.getParameter("searchFolderId"));
String hasAttachment = Util.null2String(request.getParameter("hasAttachment"));
String mailStatus = Util.null2String(request.getParameter("mailStatus"));
%>
<!--
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN"> 
-->
<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<SCRIPT language="VBS" src="/js/browser/CustomerMultiBrowser.vbs"></SCRIPT>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript" language="javascript">
Event.observe(window, "load", function(){
	$("searchFolderIdSpan").innerHTML = getMailInboxFolderName(<%=searchFolderId%>);
});
function viewMail(mailId,e){
	var url = "MailView.jsp?id="+mailId+"&flag=1";
	e=e||event; 
	var o =e.srcElement||e.target;
    try{    
	if(o.style.fontWeight=="bold"){
		o.style.fontWeight = "normal";
		while(o.tagName!="TR"){o=o.parentNode;}
		o.cells[1].innerHTML = "<img src='/images/mail_read_wev8.gif' />";
	}
	}catch(e){
        o=event.srcElement;
		if(o.style.fontWeight=="bold"){
		o.style.fontWeight = "normal";
		while(o.tagName!="TR"){o=o.parentNode;}
		o.cells[1].innerHTML = "<img src='/images/mail_read_wev8.gif' />";
	}
	}
	location.href = url;
}

// Menu
// ==================================================================================================
function doSearch(){
	$("searchForm").submit();
}
function doSetMailStatus(status,obj){
	if(validateCheckBox()){
		$("formMailList").operation.value = status==0 ? "unRead" : "readed";
		callAjax(obj);
	}
}
function doDelete(obj){
	if(validateCheckBox()){
		$("formMailList").operation.value = "delete";
		callAjax(obj);
	}
}
function doRemove(obj){
	if(validateCheckBox()){
		if(confirm("<%=SystemEnv.getHtmlLabelName(19951,user.getLanguage())%>")){
			$("formMailList").operation.value = "remove";
		}else{
			return false;
		}
		callAjax(obj);
	}
}
function doCopyOrMove(operation) {
	if(validateCheckBox()){
		var fId;
		$("formMailList").mailIds.value = _xtable_CheckedCheckboxId();
		fId = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MailInboxBrowser.jsp");
		if(typeof fId!="undefined"){
			$("formMailList").toFolderId.value = fId;
			$("formMailList").operation.value = operation==0 ? "copy" : "move";
			$("formMailList").submit();
		}
	}
}
function doExportDocs(){
	if(validateCheckBox()){
		if(<%=mainId%>==-1 && <%=subId%>==-1 && <%=secId%>==-1){
			//window.parent.returnValue = Array(1, id, path, mainid, subid);
			var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode=<%=MultiAclManager.OPERATION_CREATEDOC%>");
			if(result!=null){
				$("formMailList").secId.value = result[1];
				$("formMailList").mainId.value = result[3];
				$("formMailList").subId.value = result[4];
			}
		}
		$("formMailList").mailIds.value = _xtable_CheckedCheckboxId();
		$("formMailList").operation.value = "exportDocs";
		$("formMailList").submit();
		hideRightClickMenu();
		showMsgBox($("actionMsgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelName(19950,user.getLanguage())%>...");
	}
}
function doExportContacts(){
	if(validateCheckBox()){
		$("formMailList").mailIds.value = _xtable_CheckedCheckboxId();
		crmIds = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
		try{
		if(crmIds.toArray()){
			$("formMailList").crmIds.value = crmIds.toArray()[0];
			$("formMailList").operation.value = "exportContacts";
			$("formMailList").submit();
			hideRightClickMenu();
			showMsgBox($("actionMsgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelName(19949,user.getLanguage())%>...");
		}}catch(e){
			//TODO
		}
	}
}
function onSelectMailInbox(){
	var fId;
	fId = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MailInboxBrowser.jsp?hasMenu=true");
	if(typeof fId!="undefined"){
		if(fId==-4){
			$("searchFolderId").value = "";
			$("searchFolderIdSpan").innerHTML = "";
		}else{
			$("searchFolderId").value = fId;
			$("searchFolderIdSpan").innerHTML = getMailInboxFolderName(fId);
		}
	}
}
function getMailInboxFolderName(paramFolderId){
	var folderName = "";
	if(paramFolderId==-1){
		folderName = "<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%>";//发件箱
	}else if(paramFolderId==-2){
		folderName = "<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>";//草稿
	}else if(paramFolderId==-3){
		folderName = "<%=SystemEnv.getHtmlLabelName(19817,user.getLanguage())%>";//已删除邮件
	}else if(paramFolderId==0){
		folderName = "<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>";//收件箱
	}else{
		for(var i=0;i<$("folderSelect").options.length;i++){
			if(paramFolderId==$("folderSelect").options[i].value){
				folderName = $("folderSelect").options[i].innerHTML;
				break;
			}
		}
	}
	return folderName;
}
// ==================================================================================================
function callAjax(obj){
	obj.disabled=true;
	new Ajax.Request("MailOperation.jsp", {
		onSuccess : function(){_table.reLoad();obj.disabled=false;_xtable_CleanCheckedCheckbox();},
		onFailure : function(){alert("error!");},
		parameters : "mailIds="+_xtable_CheckedCheckboxId()+"&operation="+$F("operation")+""
	});
	callGetUnReadMailCount();
}
function callGetUnReadMailCount(){
	var f;
	if(window.parent.parent.document.getElementById("mailFrameSet")){
		f = window.parent.parent.document.getElementById("mailFrameSet").firstChild;
	}else{
		f = window.parent.document.getElementById("mailFrameSet").firstChild;
	}
	f.contentWindow.getUnReadMailCount();
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
function validateCheckBox(){
	if(_xtable_CheckedCheckboxId()==""){
		alert("<%=SystemEnv.getHtmlLabelName(20029,user.getLanguage())%>");
		return false;
	}
	return true;
}
</script>
<style type="text/css" media="screen">
/* <[CDATA[ */
*{font:12px MS Shell Dlg,Arial}
.menu{
	background-image:url(/images/mail_menubg_wev8.gif);width:100%;border:1px solid #B7D8ED;
}
table.menu td a{color:#00156E;text-decoration:underline;}
table.menu td a:hover{color:#00156E;text-decoration:underline;}
table.menu td a:link{color:#00156E;text-decoration:underline;}
table.menu td a:visited{color:#00156E;text-decoration:underline;}
table.menu td image{
	vertical-align:middle;
	border:0;
}
.href{
	color:blue;
	text-decoration:underline;
	cursor:hand;
}
#accountBox{
	line-height:20px;
	padding:5px;
	border:1px solid #B7D8ED;
	background-color:#FFF;
	position:absolute;
	top:18;
	left:12;
	z-index:1000;
}
#accountBox a{color:#00156E;text-decoration:underline;}
#accountBox a:hover{color:#00156E;text-decoration:underline;}
#accountBox a:link{color:#00156E;text-decoration:underline;}
#accountBox a:visited{color:#00156E;text-decoration:underline;}
#loading{
	padding:0 4px 0 4px;
}
#msgBox{
	background-color:#E9F5FD;
	padding:3px 5px 3px 9px;
	/*
	position:absolute;
	top:25;
	left:4;
	z-index:1000;
	*/
}
#mailList td{
	border-bottom:1px solid #CCC;

}
/* ]]> */
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18492,user.getLanguage())+",javascript:doSetMailStatus(1,this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19820,user.getLanguage())+",javascript:doSetMailStatus(0,this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:doCopyOrMove(0),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:doCopyOrMove(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19821,user.getLanguage())+",javascript:doExportDocs(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19822,user.getLanguage())+",javascript:doExportContacts(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doRemove(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="xTable_message" style="display:" id="actionMsgBox"></div>
<!--======================== Search From =========================================-->
<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
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

<table class="viewform">
<form id="searchForm" method="post" action="MailSearch.jsp">
<colgroup>
<col width="8%">
<col width="18%">
<col width="1%">
<col width="7%">
<col width="10%">
<col width="1%">
<col width="7%">
<col width="10%">
<col width="1%">
<col width="8%">
<col width="3%">
<tbody>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></td>
	<td class=field>
		<input type="text" name="subject" style="width:170px" class="Inputstyle" value="<%=subject%>">
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())%></td>
	<td class=field>
		<input type="text" name="sendfrom" style="" class="Inputstyle" value="<%=sendfrom%>">
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%></td>
	<td class=field>
		<input type="text" name="sendto" style="" class="Inputstyle" value="<%=sendto%>">
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(19844, user.getLanguage())%></td>
	<td>
		<select name="hasAttachment" id="hasAttachment">
			<option value=""></option>
			<option value="1" <%=("1".equals(hasAttachment)?"selected=\"selected\"":"")%> ><%=SystemEnv.getHtmlLabelName(19844, user.getLanguage())%></option>
			<option value="2" <%=("2".equals(hasAttachment)?"selected=\"selected\"":"")%> ><%=SystemEnv.getHtmlLabelName(26211, user.getLanguage())%></option>
		</select>
	</td>
</tr>
<tr style="height:1px"><td class="line" colspan="11"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(2047, user.getLanguage())%></td>
	<td class=field>
		<button class="calendar" type=button onclick="getDate(startdatespan,startdate)"></button>
		<span id="startdatespan"><%=startdate%></span>
		<input type="hidden" id="startdate" name="startdate" value="<%=startdate%>">
		－
		<button class="calendar" type=button onclick="getDate(enddatespan,enddate)"></button>
		<span id="enddatespan"><%=enddate%></span>
		<input type="hidden" id="enddate" name="enddate" value="<%=enddate%>">
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(571, user.getLanguage())%></td>
	<td class=field>
		<select name="mailAccountId" id="mailAccountId">
		<option></option>
		<%rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");while(rs.next()){%>
		<option value="<%=rs.getInt("id")%>" <%if(mailAccountId.equals(rs.getString("id")))out.print("selected");%>>
			<%=rs.getString("accountName")%>
		</option>
		<%}%>
		</select>
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(18473, user.getLanguage())%></td>
	<td class=field>
		<button class="browser" type=button onclick="onSelectMailInbox()"></button>
		<input type="hidden" id="searchFolderId" name="searchFolderId" value="<%=searchFolderId%>">
		<span id="searchFolderIdSpan"></span>
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(18958, user.getLanguage())%></td>
	<td>
		<select name="mailStatus" id="mailStatus">
			<option value=""></option>
			<option value="0" <%=("0".equals(mailStatus)?"selected=\"selected\"":"")%> ><%=SystemEnv.getHtmlLabelName(25426, user.getLanguage())%></option>
			<option value="1" <%=("1".equals(mailStatus)?"selected=\"selected\"":"")%> ><%=SystemEnv.getHtmlLabelName(25425, user.getLanguage())%></option>
		</select>
	</td>
</tr>
<tr style="height:1px"><td class="line" colspan="11"></td></tr>
</tbody>
</form>
</table>


<!--======================================================================-->
<form id="formMailList" method="post" action="MailOperation.jsp">
<input type="hidden" name="operation" value="delete">
<input type="hidden" name="mailIds" value="">
<input type="hidden" name="folderId" value="<%=folderId%>">
<input type="hidden" name="toFolderId" value="">
<input type="hidden" name="crmIds" value="">
<input type="hidden" name="from" value="search">
<input type="hidden" name="mainId" value="">
<input type="hidden" name="subId" value="">
<input type="hidden" name="secId" value="">
<input type="hidden" name="crmSecId" value="<%=crmSecId%>">
<%
String sqlwhere = "WHERE a.resourceid="+user.getUID()+"";
if(!subject.equals("")){
	sqlwhere += " AND a.subject LIKE '%"+subject+"%'";
}
if(!sendfrom.equals("")){
	sqlwhere += " AND a.sendfrom LIKE '%"+sendfrom+"%'";
}
if(!sendto.equals("")){
	sqlwhere += " AND a.sendto LIKE '%"+sendto+"%'";
}
if(!startdate.equals("")){
	sqlwhere += " AND a.senddate>='"+startdate+"'";
}
if(!enddate.equals("")){
	sqlwhere += " AND a.senddate<='"+enddate+"'";
}
if(!mailAccountId.equals("")){
	sqlwhere += " AND a.mailAccountId="+mailAccountId+"";
}
if(!searchFolderId.equals("")){
	sqlwhere += " AND a.folderId="+searchFolderId+"";
}else{//默认不列出已删除邮件
	//TD5392
	sqlwhere += " AND (folderId IN (SELECT id FROM MailInboxFolder) OR folderId IN (0,-1,-2))";
}
if(hasAttachment.equals("1")){
	sqlwhere += " AND a.attachmentNumber<>0";
}else if(hasAttachment.equals("2")){
	sqlwhere += " AND a.attachmentNumber=0";
}

if(!mailStatus.equals("")){
	sqlwhere += " AND a.status="+mailStatus+" ";
}

//out.println(sqlwhere);

String tableString=""+
	"<table  pagesize=\""+pageSize+"\" tabletype=\"checkbox\">"+
	"<sql backfields=\"a.*,b.accountName\" sqlform=\"MailResource a LEFT JOIN MailAccount b ON a.mailAccountId=b.id\" sqlprimarykey=\"a.id\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
	"<head>"+
		//状态(0:未读 1:已读)
		"<col width=\"3%\" text=\"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailStatus\" />"+
		//附件
		"<col width=\"4%\" text=\"&lt;img src=/images/mail_attachment.gif&gt;\" column=\"attachmentNumber\" orderkey=\"attachmentNumber\" transmethod=\"weaver.splitepage.transform.SptmForMail.getAttachmentNumber\" />"+
		//发件人
		"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(2034, user.getLanguage())+"\" column=\"sendfrom\" orderkey=\"sendfrom\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailAddressWithName\" />"+
		//主题
		"<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" transmethod=\"weaver.splitepage.transform.SptmForMail.getSubjectByStatus\" otherpara=\"column:status+column:id\" />"+
		//发件日期
		"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2047, user.getLanguage())+"\" column=\"senddate\" orderkey=\"senddate\" />"+
		//帐户
		"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(571, user.getLanguage())+"\" column=\"accountName\" orderkey=\"mailAccountId\" />"+
		//文件夹
		"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(18473, user.getLanguage())+"\" column=\"folderId\" orderkey=\"folderId\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailInboxFolderName\" />"+
		//邮件大小
		"<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2036, user.getLanguage())+"\" column=\"size_n\" orderkey=\"size_n\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailSize\" />"+
	"</head>"+
	/*
	"<operates width=\"15%\">"+
	"  <operate href=\"javascript:doReply()\" text=\""+SystemEnv.getHtmlLabelName(117,user.getLanguage()) +"\" index=\"0\"/>"+
	"  <operate href=\"javascript:doForward()\" text=\""+SystemEnv.getHtmlLabelName(6011,user.getLanguage()) +"\" index=\"1\"/>"+
	"	<operate href=\"javascript:doDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage()) +"\" index=\"2\"/>"+
	"</operates>"+
	*/
	"</table>";             
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
</form>
	</td>
	<td></td>

</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


<select id="folderSelect">
<%rs.executeSql("SELECT id,folderName FROM MailInboxFolder WHERE userId="+user.getUID()+"");while(rs.next()){%>
<option value="<%=rs.getString("id")%>"><%=rs.getString("folderName")%></option>
<%}%>
</select>
</body>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>



<%if(!refreshTreeMenu.equals("")){%>
<script type="text/javascript">
callGetUnReadMailCount();
</script>
<%}%>
