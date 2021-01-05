
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String receivemail = Util.null2String(request.getParameter("receivemail"));
String refreshTreeMenu = Util.null2String(request.getParameter("refreshTreeMenu"));
String subject = Util.null2String(request.getParameter("subject"));
int folderId = Util.getIntValue(request.getParameter("folderId"), 0);
int pageSize = 10;
int layout = 3;
int mainId = -1;
int subId = -1;
int secId = -1;
int crmSecId = -1;
String targetMailView = "";
String autoreceiveid = "";//自动收邮件账号id
rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+" and autoreceive = 1");
while(rs.next()){
	autoreceiveid += rs.getString("id") + ",";
}
rs.executeSql("SELECT * FROM MailSetting WHERE userId="+user.getUID()+"");
if(rs.next()){
	pageSize = rs.getInt("perpage");
	layout = rs.getInt("layout");
	mainId = rs.getInt("mainId");
	subId = rs.getInt("subId");
	secId = rs.getInt("secId");
	crmSecId = rs.getInt("crmSecId");
}
targetMailView = layout==3 ? "_self" : "mailInboxRight";
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
var el;
var dragging = false;

Event.observe(window, "load", function(){
	<%if(layout!=3){%>hideRightClickMenu();<%}%>
	weaverTable.prototype.mouseMove = function(re){
		if(dragging){
			el.style.cursor = "move";
		}
	}
	weaverTable.prototype.mouseUp = function(re){
		var event = getEvent();
		if(el){
			//alert(event.clientX);
			if(event.clientX>0 || event.clientX<-140){dragging = false;}
			el.releaseCapture();
			el.style.cursor = "default";
		}
	}
	weaverTable.prototype.mouseDown = function(re){
		var evt = getEvent();

		el = evt.srcElement ? evt.srcElement : evt.target;
		
		if(el.tagName=="TD"){
			el.setCapture();
			dragging = true;
		}
	}
});
function hideAccountBox(){
	var x = event.clientX;
	var y = event.clientY;
	var w = $("accountBox").clientWidth;
	var h = $("accountBox").clientHeight;
	if(x>w || y>h+18){
		//window.setTimeout("$('accountBox').style.display='none'", 1000);
		$("accountBox").style.display = "none";
		//$("linkGetMail").style.backgroundColor = "";
	}
}
function showAccountBox(){
	//$("linkGetMail").style.backgroundColor = "#CFE8F5";
	if($("mailAccountId").options.length==1) return false;
	$("accountBox").style.display = "";
}
function viewMail(mailId,e){
	var url = "MailView.jsp?id="+mailId+"&folderId=<%=folderId%>";
	e=e||event; 
	var o =e.srcElement||e.target;
	if(o.style.fontWeight=="bold"){
		o.style.fontWeight = "normal";
		while(o.tagName!="TR"){o=o.parentNode;}
		o.cells[1].innerHTML = "<img src='/images/mail_read_wev8.gif' />";
	}
	if(<%=layout%>==3){//平铺
		//location.href = url;
		//openFullWindow(url);
		window.open(url);
	}else{
		parent.mailInboxRight.location.href = url;
	}
}
function redirect(){
	var url;
	url = "MailAdd.jsp?to="+event.srcElement.innerHTML+"";
	redirectByFrame(url);
}
function redirectByFrame(url){
	if(parent.mailFrameLeft){
		location = url;
	}else{
		parent.location = url;
	}
}
// Logging & Get Mail
// ==================================================================================================
function getMailSingleAccount(accountId){
	$("msgBox").innerHTML = "";
	$("accountBox").style.display = "none";
	$("selectedAccountIds").value = accountId + ",";
	getMail();
}
function setMailAccountId(){
	if($("mailAccountId").options.length==1) return false;
	$("msgBox").innerHTML = "";
	$("accountBox").style.display = "none";
	$("linkGetMail").blur();
	if($F("mailAccountId")==0){
		for(var i=1; i<$("mailAccountId").options.length; i++){
			$("selectedAccountIds").value += $("mailAccountId").options[i].value + ",";
		}
	}else{
		$("selectedAccountIds").value = $F("mailAccountId") + ",";
	}
	getMail();
}
function setAutoMailAccountId(){
	if("<%=autoreceiveid%>"=="") return false;
	$("msgBox").innerHTML = "";
	$("accountBox").style.display = "none";
	$("selectedAccountIds").value = "<%=autoreceiveid%>";
	getMail();
}
function removeMailAccountId(id){
	$("msgBox").style.display = "";
	$("loading").style.display = "none";
	$("selectedAccountIds").value = $("selectedAccountIds").value.replace(""+id+",", "");
	if($("selectedAccountIds").value!=""){
		getMail();
	}else{
		$("msgBox").innerHTML += "&nbsp;<a href=\"javascript:void(0);\" onclick=\"javascript:document.getElementById('msgBox').style.display='none';\">Close</a>";
		_table.reLoad();
		callGetUnReadMailCount();
	}
}
function getMail(){
	var ids = $("selectedAccountIds").value;
	var ids2 = ids.split(",");
	$("loading").innerHTML = "<div style='width:100%;background-color:#E9F5FD;padding:3px 0 1px 7px;color:#333'><img src=\"/images/loading2_wev8.gif\" style=\"vertical-align:middle;\"> <%=SystemEnv.getHtmlLabelName(19818,user.getLanguage())%>"+getAccountName(ids2[0])+", <%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())%>...</div>";
	$("loading").style.display = "";
	$("iframeGetMail").src = "MailOperationGet.jsp?operation=get&mailAccountId=" + ids2[0];
}
function getAccountName(accountId){
	var accountName;
	for(var i=0; i<$("mailAccountId").options.length; i++){
		if(accountId==$("mailAccountId").options[i].value){
			accountName = $("mailAccountId").options[i].innerHTML;
			break;
		}
	}
	return accountName;
}

// Menu
// ==================================================================================================
//TD24205 modify yangdacheng 20111214
function doSetMailStatus1(status){
	if(validateCheckBox()){
	$("formMailList").operation.value = status==0 ? "unRead" : "readed";
    callAjax(this);
	}
}
function doDelete1(){
	if(validateCheckBox()){
		$("formMailList").operation.value = "delete";
		callAjax(this);
	}
}
function doRemove1(){
	if(validateCheckBox()){
		if(confirm("<%=SystemEnv.getHtmlLabelName(19951,user.getLanguage())%>")){
			$("formMailList").operation.value = "remove";
		}else{
			return false;
		}
		callAjax(this);
	}
}
function doClear1(){
	if(validateCheckBox()){
	if(confirm("<%=SystemEnv.getHtmlLabelName(19929,user.getLanguage())%>")){
		$("formMailList").operation.value = "clear";
	}else{
		return false;
	}
	callAjax(this);
	}
}
//TD24205


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
function doClear(obj){
	if(confirm("<%=SystemEnv.getHtmlLabelName(30838,user.getLanguage())%>")){
		$("formMailList").operation.value = "clear";
	}else{
		return false;
	}
	callAjax(obj);
}
function doCopyOrMove(operation) {
	if(validateCheckBox()){
		$("formMailList").mailIds.value = _xtable_CheckedCheckboxId();
		folderId = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MailInboxBrowser.jsp");
		if(typeof folderId!="undefined"){
			$("formMailList").toFolderId.value = folderId;
			$("formMailList").operation.value = operation==0 ? "copy" : "move";
			$("formMailList").submit();
		}
		reloadMail();
	}
}
function doExportDocs(){
	if(validateCheckBox()){
		if(<%=mainId%><1 && <%=subId%><1 && <%=secId%><1){
			//window.parent.returnValue = Array(1, id, path, mainid, subid);
			var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode=<%=MultiAclManager.OPERATION_CREATEDOC%>");
			if(result!=null){
				$("formMailList").secId.value = result[1];
				$("formMailList").mainId.value = result[3];
				$("formMailList").subId.value = result[4];
			}
			//alert($("formMailList").secId.value);
			//alert($("formMailList").mainId.value);
			//alert($("formMailList").subId.value);
			if($("formMailList").secId.value=="" || $("formMailList").secId.value==0 || $("formMailList").mainId.value=="" || $("formMailList").subId.value==""){
				return;
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
	if(crmIds){
		try{
			if(crmIds.id!=""){
				$("formMailList").crmIds.value =crmIds.id;
				alert($("formMailList").crmIds.value);
				$("formMailList").operation.value = "exportContacts";
				$("formMailList").submit();
				hideRightClickMenu();
				showMsgBox($("actionMsgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelName(19949,user.getLanguage())%>...");
			}
		}catch(e){
			//TODO
			alert("error");
		}
	}
   }
}
function callAjax(obj){
	obj.disabled=true;
	new Ajax.Request("MailOperation.jsp", {
		onSuccess : function(){callGetUnReadMailCount();_table.reLoad();obj.disabled=false;_xtable_CleanCheckedCheckbox();reloadMail();},
		onFailure : function(){alert("Error!");obj.disabled=false;},
		parameters : "mailIds="+_xtable_CheckedCheckboxId()+"&operation="+$F("operation")+""
	});	
}
function reloadMail(){
	try{
		parent.frames["mailInboxRight"].document.location = "MailView.jsp?folderId=<%=folderId%>";
	}catch(e){}
}
function callGetUnReadMailCount(){
	try{
		var f;
		if(window.parent.parent.document.getElementById("mailFrameSet")){
			f = window.parent.parent.document.getElementById("mailFrameSet").firstChild;
		}else{
			f = window.parent.document.getElementById("mailFrameSet").firstChild;
		}
		f.contentWindow.getUnReadMailCount();
	}catch(e){
	}
}
function showMsgBox(o, msg){
	with(o){
		innerHTML = msg;
		style.display = "inline";
		style.position = "absolute"
		style.top = document.body.offsetHeight/2+document.body.scrollTop-50;
		style.left = document.body.offsetWidth/2-50;
	}
}
function validateCheckBox(){
	if(_xtable_CheckedCheckboxId()==""){
		alert("<%=SystemEnv.getHtmlLabelName(20029,user.getLanguage())%>");
		return false;
	}
	return true;
}
function a(accountName, mailNo){
	$("loading").innerHTML = "<div style='width:100%;background-color:#E9F5FD;padding:3px 0 1px 7px;color:#333'><img src=\"/images/loading2_wev8.gif\" style=\"vertical-align:middle;\"> "+accountName+":<%=SystemEnv.getHtmlLabelName(19955,user.getLanguage())%>(<span style='font-weight:bold;color:#000'>"+mailNo+"</span>),<%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())%>...</div>";
}
</script>
<style type="text/css" media="screen">
/* <[CDATA[ */
body{overflow:auto}
*{font:12px MS Shell Dlg,Arial}
.menu{
	width:100%;border:1px solid #B7D8ED;
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
	padding:3px 2px 5px 2px;
	/*border:1px solid #B7D8ED;*/
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
.popupMenuRow{
	height: 21px;
	padding: 1px;
}
.popupMenuRowHover{
	height: 21px;
	border: ;
	background-color: ;
}
/* ]]> */
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body>
<div class="xTable_message" style="display:" id="actionMsgBox"></div>
<img src="/images/loading2_wev8.gif" style="display:none">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18492,user.getLanguage())+",javascript:doSetMailStatus(1,this),_self} " ;//标记为已读
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19820,user.getLanguage())+",javascript:doSetMailStatus(0,this),_self} " ;//标记为未读
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:doCopyOrMove(0),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:doCopyOrMove(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19821,user.getLanguage())+",javascript:doExportDocs(),_self} " ;//导出文档
RCMenuHeight += RCMenuHeightStep ;
if(isgoveproj==0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(19822,user.getLanguage())+",javascript:doExportContacts(),_self} " ;//导出客户联系
RCMenuHeight += RCMenuHeightStep ;
}
if(folderId!=-3){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doRemove(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(folderId==-3){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:doClear(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<div id="divTopMenu">
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>


<div id="accountBox" style="display:none" onmouseout="hideAccountBox()">
<%rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");while(rs.next()){%>
<div style="padding:1px 25px 0 1px;border:1px solid #FFF"
	onmouseover="this.style.border='1px solid #FFF';this.style.backgroundColor='#B6BDD2'"
	onmouseout="this.style.border='1px solid #FFF';this.style.backgroundColor='#FFF'">
<a href="javascript:getMailSingleAccount(<%=rs.getInt("id")%>)"><%=rs.getString("accountName")%></a>
</div>
<%}%>
</div>

<table style="width:100%" cellspacing="0" cellpadding="0">
<tr>
<td width="4px"></td>
<td>
	<table class="menu" cellspacing="0" cellpadding="0" id="mailInBoxLstTbl">
	<tr>
		<td width="8px"></td>
		<td width="75px">
			<select name="mailAccountId" id="mailAccountId" style="display:none">
			<option value="0"></option>
			<%rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");while(rs.next()){%>
			<option value="<%=rs.getInt("id")%>"><%=rs.getString("accountName")%></option>
			<%}%>
			</select>
			<input type="hidden" id="selectedAccountIds" value="" />
			<a href="javascript:void(0)" 
				id="linkGetMail"
				onclick="setMailAccountId()" 
				onmouseover="showAccountBox()"
				onmouseout="">
				<%=SystemEnv.getHtmlLabelName(19823,user.getLanguage())%><img src="/images/ql_wev8.gif"></a>
		</td>
		<td width="0px"></td>
		<%if(layout!=2){%>
		<td>
		<a href="javascript:doCopyOrMove(0)"><%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></a>
		<a href="javascript:doCopyOrMove(1)"><%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%></a>
		<a href="javascript:doExportDocs()"><%=SystemEnv.getHtmlLabelName(19821,user.getLanguage())%></a>
		<%if(isgoveproj==0){%>
		<a href="javascript:doExportContacts()"><%=SystemEnv.getHtmlLabelName(19822,user.getLanguage())%></a>
		<%}%>
		</td>
		<%}%>
		<form id="searchForm" method="post" action="MailInboxList.jsp?folderId=<%=folderId%>">
			<td width="*" style="text-align:right">
			<input type="text" name="subject" style="border:1px solid #B7D8ED" value="<%=subject%>" />
			</td>
			<td width="23px"><img src="/images/mail_searchbtn2_wev8.gif" style="cursor:hand" onclick="javascript:$('searchForm').submit()"></td>
		</form>
		<td width="5px"></td>
	</tr>
	</table>
</td>
<td width="4px"></td>
</tr>
</table>
<!--==========================-->
<div id="loading" style="display:none"></div>
<div style="padding:0 4px 0 4px;border-top:1px solid #FFF"><div id="msgBox" style="display:none"></div></div>
<!--==========================-->

<iframe id="iframeGetMail" style="width:100%;height:100px;display:none"></iframe>

<form id="formMailList" method="post" action="MailOperation.jsp">
<input type="hidden" name="operation" value="delete">
<input type="hidden" name="mailIds" value="">
<input type="hidden" name="folderId" value="<%=folderId%>">
<input type="hidden" name="toFolderId" value="">
<input type="hidden" name="crmIds" value="">
<input type="hidden" name="mainId" value="">
<input type="hidden" name="subId" value="">
<input type="hidden" name="secId" value="">
<input type="hidden" name="crmSecId" value="<%=crmSecId%>">
<%
String sqlwhere = "WHERE resourceid="+user.getUID()+" AND folderId="+folderId+"";
if(!subject.equals("")){
	sqlwhere += " AND subject LIKE '%"+subject+"%'";
}
String mailHref = "";
String linkkey = "";
//if(folderId==-2){
//	mailHref = "MailAdd.jsp?flag=4";
//	linkkey = "mailId";
//	targetMailView = "mailFrameRight";
//}else{
	mailHref = "MailView.jsp?folderId="+folderId+"";
	linkkey = "id";
//}
String tableString=""+
	"<table pagesize=\""+pageSize+"\" tabletype=\"checkbox\">"+
	"<sql backfields=\"a.*, b.accountName\" sqlform=\"MailResource a LEFT JOIN MailAccount b ON a.mailAccountId=b.id\" sqlprimarykey=\"a.id\" sqlorderby=\"senddate\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
	"<head>"+
		//状态(0:未读 1:已读)
		"<col width=\"3%\" text=\"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailStatus\" />"+
		//附件
		"<col width=\"4%\" text=\"&lt;img src=/images/mail_attachment.gif&gt;\" column=\"attachmentNumber\" orderkey=\"attachmentNumber\" transmethod=\"weaver.splitepage.transform.SptmForMail.getAttachmentNumber\" />";
		if(layout==2){
			tableString += 
			//主题
			"<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" transmethod=\"weaver.splitepage.transform.SptmForMail.getSubjectFromByStatus\" otherpara=\"column:status+column:id+column:sendfrom\" />";
		}else{
			if(folderId==-1||folderId==-2||folderId<-3){
				tableString += 
				//发件箱显示收件人
				"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(2046,user.getLanguage())+"\" column=\"sendto\" orderkey=\"sendto\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailAddressWithName\" />";
			}else{
				tableString += 
				//收件箱显示发件人
				"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(2034,user.getLanguage())+"\" column=\"sendfrom\" orderkey=\"sendfrom\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailAddressWithName\" />";
			}
			tableString += 
			//主题
			"<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" transmethod=\"weaver.splitepage.transform.SptmForMail.getSubjectByStatus\" otherpara=\"column:status+column:id\" />";
		}
		tableString += 
		//发件日期
		"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(18961,user.getLanguage())+"\" column=\"senddate\" orderkey=\"senddate\" />";
		if(layout!=2){
			tableString +=
			//帐户
			"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(571,user.getLanguage())+"\" column=\"accountName\" orderkey=\"accountName\" />";
			if(folderId!=-1&&folderId!=-2){
				tableString += 
				//邮件大小
				"<col width=\"6%\" text=\"大小\" column=\"size_n\" orderkey=\"size_n\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailSize\" />";
			}
		}
		tableString +=
	"</head>"+
	"</table>";             
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
</form>
</body>
</html>



<%if(!refreshTreeMenu.equals("")){%>
<script type="text/javascript">
callGetUnReadMailCount();
</script>
<%}%>
<script type="text/javascript">

function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

function window_onload(){
  <%if(receivemail.equals("true")){%>
     if(window.parent.frames["mailFrameRight"].document.readyState=="complete"){
        setAutoMailAccountId();
     }
  <%}%>
}
document.onreadystatechange = window_onload;
</script>
