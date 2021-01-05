
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.Util,weaver.email.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SptmForMail" class="weaver.splitepage.transform.SptmForMail" scope="page" />

<%
if(true){
	response.sendRedirect("/email/new/MailInBox.jsp?opNewEmail=1&"+request.getQueryString());
}

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
int userId = user.getUID();
WeavermailComInfo wmc = null;

//取得附件限制的大小
int emailfilesize = 0;
rs.executeSql("SELECT emailfilesize FROM SystemSet");
if(rs.next()){
	emailfilesize = rs.getInt("emailfilesize");//0:个人模板 1:公司模板
}
//TD5373
String templateType = "";
int defaultTemplateId = -1;
rs.executeSql("SELECT * FROM MailTemplateUser WHERE userId="+user.getUID()+"");
if(rs.next()){
	templateType = rs.getString("templateType");//0:个人模板 1:公司模板
	defaultTemplateId = rs.getInt("templateId");
}

int mailId = Util.getIntValue(request.getParameter("mailId"));
String to = Util.null2String(request.getParameter("to"));
String subject="", content="", contentType="", tempContent="", sendfrom="", sendto="", sendcc="", senddate="", priority="", sendbcc="",_sendcc="",_sendbcc="";
String receiver = "";
int flag = Util.getIntValue(request.getParameter("flag"));
//=============================================================================================
//flag 1:Reply 2:ReplyAll 3:Forward 4:Draft
if(flag!=-1){
	wmc = (WeavermailComInfo)session.getAttribute("WeavermailComInfo");
	subject = Util.toScreen(wmc.getSubject(), user.getLanguage(), wmc.getSubencode());
	contentType = wmc.getContenttype();
	tempContent = Util.fromHtmlToEdit(Util.toScreen(wmc.getContent(), user.getLanguage(), wmc.getContentencode()));

	//TODO Escape HTML tags
	tempContent = Util.replace(tempContent, "<body>", "", 0, false);
	tempContent = Util.replace(tempContent, "</body>", "", 0, false);
    tempContent = Util.StringReplace(tempContent, "==br==", "\n");
    tempContent = Util.replace(tempContent, "separator", "", 0, false);
    tempContent = Util.replace(tempContent, "signContent", "", 0, false);
	//替换HTML内容中的图片
	//if(wmc.hasHtmlimage()){
		rs.executeSql("select id,filerealpath,isfileattrachment,fileContentId from MailResourceFile where mailid="+mailId);
		int thefilenum = 0;
		while(rs.next()){ 
			String isfileattrachment = rs.getString("isfileattrachment");
			thefilenum++;
			String imgId = rs.getString("id");
			String thecontentid = rs.getString("fileContentId");
			String oldsrc = "cid:" + thecontentid ;
			String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+imgId+"&";
			tempContent = Util.StringReplaceOnce(tempContent, oldsrc, newsrc);
		}
	//}

	sendfrom = Util.toScreen(wmc.getRealeSendfrom(), user.getLanguage(), wmc.getFromencode());
	sendto = Util.toScreen(wmc.getRealeTO() ,user.getLanguage() , wmc.getToencode());
	_sendcc = Util.toScreen(wmc.getRealeCC() ,user.getLanguage() , wmc.getToencode());
	_sendbcc = Util.toScreen(wmc.getRealeBCC() ,user.getLanguage() , wmc.getToencode());
	if(flag==4){
		sendcc = Util.toScreen(wmc.getRealeCC() ,user.getLanguage() , wmc.getToencode());
		sendbcc = Util.toScreen(wmc.getRealeBCC() ,user.getLanguage() , wmc.getToencode());
	}
		
	senddate = wmc.getSendDate();
	priority = wmc.getPriority();
	content = "<hr />" +
			   "<strong>"+SystemEnv.getHtmlLabelName(2034,user.getLanguage())+" :</strong> " + SptmForMail.getMailAddressWithNameNoHref(sendfrom,user.getUID()+"") +
			   "<br><strong>"+SystemEnv.getHtmlLabelName(2046,user.getLanguage())+" :</strong> " + SptmForMail.getMailAddressWithNameNoHref(sendto,user.getUID()+"") +
			   "<br><strong>"+SystemEnv.getHtmlLabelName(17051,user.getLanguage())+" :</strong> " + SptmForMail.getMailAddressWithNameNoHref(_sendcc,user.getUID()+"") +
			   "<br><strong>"+SystemEnv.getHtmlLabelName(18530,user.getLanguage())+" :</strong> " + senddate +
			   "<br><strong>"+SystemEnv.getHtmlLabelName(344,user.getLanguage())+" :</strong> " + subject +
			   "<br><br><br><br>" + tempContent;

}

if(flag==1){
	subject = "Re:" + subject;
	receiver = sendfrom;
	//content = tempContent;
}else if(flag==2){
	subject = "Re:" + subject;
	//删除开始
	//receiver = ","+sendfrom + "," + sendto + ",";
	//String sql = "select accountmailaddress from mailaccount where userid = '" + user.getUID() + "'";
	//rs.executeSql(sql);

	//while(rs.next()){
		//String mailadd = Util.null2String(rs.getString(1));
		//if(!mailadd.equals("")){
			//for(int i=0;i<3;i++){	
				//receiver = Util.StringReplace(receiver,","+mailadd,",");
			//}
		//}		
	//}		
	//if(receiver.length()>1){
		//receiver = receiver.substring(1);	
		//receiver = receiver.substring(0,receiver.length()-1);
		//receiver = Util.StringReplace(receiver,",,",",");
	//}
    //if(receiver.length()==1){
		//receiver = "";
	//}
    //删除结束
	receiver = sendfrom + "," ;
	_sendcc = ","+sendto + "," + _sendcc+",";
	String sql = "select accountmailaddress from mailaccount where userid = '" + user.getUID() + "'";
	rs.executeSql(sql);

	while(rs.next()){
		String mailadd = Util.null2String(rs.getString(1));
		if(!mailadd.equals("")){
				_sendcc = _sendcc.replaceAll(","+mailadd+",",",");
		}		
	}		
	if(_sendcc.length()>1){
		if(_sendcc.indexOf(",")==0)_sendcc=_sendcc.substring(1,_sendcc.length());
		_sendcc = _sendcc.replaceAll(",,",",");
	}
    if(_sendcc.length()==1){
		_sendcc = "";
	}
}else if(flag==3){
	subject = SystemEnv.getHtmlLabelName(132408, user.getLanguage()) + subject; //转发:  Fw:
	//content = tempContent;
}else if(flag==4){
	receiver = sendto;
	content = tempContent;
}

content = "<br><br><br><br><div id='separator'></div>"+content;
//=============================================================================================
if(!to.equals("")){
	receiver = to;
}

//=============================================================================================
String isSent = Util.null2String(request.getParameter("isSent"));
String msg = "";
if(isSent.equals("true")){//邮件发送成功
	msg = " - <span style='color:green'>" + SystemEnv.getHtmlLabelName(2044,user.getLanguage()) + "</span>";
}else if(isSent.equals("false")){//邮件发送失败，保存到草稿箱
	msg = " - <span style='color:red'>" + SystemEnv.getHtmlLabelName(2045,user.getLanguage()) +","+SystemEnv.getHtmlLabelName(86,user.getLanguage())+SystemEnv.getHtmlLabelName(349,user.getLanguage()) +SystemEnv.getHtmlLabelName(2039,user.getLanguage())+"</span>";
}else if(isSent.equals("false1")){//邮件发送失败，保存到发件箱
	msg = " - <span style='color:red'>" + SystemEnv.getHtmlLabelName(2045,user.getLanguage()) +","+SystemEnv.getHtmlLabelName(86,user.getLanguage())+SystemEnv.getHtmlLabelName(349,user.getLanguage()) +SystemEnv.getHtmlLabelName(2038,user.getLanguage())+"</span>";
}else if(isSent.equals("draftSaved")){//邮件保存成功
	msg = " - <span style='color:green'>" + SystemEnv.getHtmlLabelName(19939,user.getLanguage()) + "</span>";
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage()) + msg;
String needfav ="1";
String needhelp ="";
%>
<html>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js">
</script>
<script language="javascript" type="text/javascript">
</script>
	
<script type="text/javascript">
function initFlashVideo(){
	//CkeditorExt.initEditor("weaver","mouldtext",lang)
}
String.prototype.trim = function() {
	return (this.replace(/^\s+|\s+$/g,""));
}

var receiverMore, currentReceiverType;

Event.observe(window, "load", function(){
	/***###@2007-08-28 add by yeriwei,初始化编辑器*/
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	CkeditorExt.initEditor('weaver','mouldtext',lang,'','300px');
	/****/
	//======================================================
	// Initialize
	//======================================================
	
	var mailTemplate = $("mailTemplate");
	var receiverSelector = $("receiverSelector");
	var receiverSelectorCC = $("receiverSelectorCC");
	var receiverSelectorBCC = $("receiverSelectorBCC");
	receiverMore = $("receiverMore");
	//======================================================
	// Add Event Listener
	//======================================================
	jQuery("#btnAddCC").bind("click",addCC);
	jQuery("#btnAddBCC").bind("click",addBCC);
	
	jQuery(receiverSelector).bind("mouseover",function(){
		jQuery(receiverSelector).removeClass("receiverSelector");
		jQuery(receiverSelector).addClass("receiverSelectorOver");
	}
);
jQuery(receiverSelectorCC).bind("mouseover",function(){
	jQuery(receiverSelectorCC).removeClass("receiverSelector");
	jQuery(receiverSelectorCC).addClass("receiverSelectorOver");
	}
);
jQuery(receiverSelectorBCC).bind("mouseover",function(){
	jQuery(receiverSelectorBCC).removeClass("receiverSelector");
	jQuery(receiverSelectorBCC).addClass("receiverSelectorOver");
	}
);

jQuery(receiverSelector).bind("mouseout",function(){
	jQuery(receiverSelector).removeClass("receiverSelectorOver");
	jQuery(receiverSelector).addClass("receiverSelector");
	}
);


jQuery(receiverSelectorCC).bind("mouseout",function(){
	jQuery(receiverSelectorCC).removeClass("receiverSelectorOver");
	jQuery(receiverSelectorCC).addClass("receiverSelector");
	}
);


jQuery(receiverSelectorBCC).bind("mouseout",function(){
	jQuery(receiverSelectorBCC).removeClass("receiverSelectorOver");
	jQuery(receiverSelectorBCC).addClass("receiverSelector");
	}
);
	
	jQuery(receiverSelector).bind("click", function(){
		var xy = Position.positionedOffset(receiverSelector); 
		toggleReciverSelector(xy[0], xy[1]+15);
		currentReceiverType = receiverSelector;
	});
	jQuery(receiverSelectorCC).bind("click", function(){
		var xy = Position.positionedOffset(receiverSelectorCC);
		toggleReciverSelector(xy[0], xy[1]+15);
		currentReceiverType = receiverSelectorCC;
	});
	jQuery(receiverSelectorBCC).bind("click", function(){
		var xy = Position.positionedOffset(receiverSelectorBCC);
		toggleReciverSelector(xy[0], xy[1]+15);
		currentReceiverType = receiverSelectorBCC;
	});
	
	jQuery(document.body).bind("click", function(e){
		e=jQuery.event.fix(e);
		var o = e.target;
		if(o!=receiverSelector && o!=receiverSelectorCC && o!=receiverSelectorBCC){Element.hide(receiverMore);}
	});
	
	Event.observe($("receiverContacter"), "click", function(){
		//alert(currentReceiverType.id);
		if(currentReceiverType.id=="receiverSelector"){
			onShowContacterMail($("receiver"), $("receiverHideContacter"));
		}else if(currentReceiverType.id=="receiverSelectorCC"){
			onShowContacterMail($("receiverCC"), $("receiverCCHideContacter"));
		}else{
			onShowContacterMail($("receiverBCC"), $("receiverBCCHideContacter"));
		}
	});
	Event.observe($("receiverHRM"), "click", function(){
		if(currentReceiverType.id=="receiverSelector"){
			onShowResourcemail($("receiver"), $("receiverHide"));
		}else if(currentReceiverType.id=="receiverSelectorCC"){
			onShowResourcemail($("receiverCC"), $("receiverCCHide"));
		}else{
			onShowResourcemail($("receiverBCC"), $("receiverBCCHide"));
		}	
	});
	if(<%=isgoveproj%>==0){
	Event.observe($("receiverCRM"), "click", function(){
		if(currentReceiverType.id=="receiverSelector"){
			onShowCRMContacterMail($("receiver"), $("receiverHide"));
		}else if(currentReceiverType.id=="receiverSelectorCC"){
			onShowCRMContacterMail($("receiverCC"), $("receiverCCHide"));
		}else{
			onShowCRMContacterMail($("receiverBCC"), $("receiverBCCHide"));
		}
	});
	}
	// Template Import
	Event.observe(mailTemplate, "change", function(e){
		e=jQuery.event.fix(e);
		//var o = e.target;
		if(confirm("<%=SystemEnv.getHtmlLabelName(19925, user.getLanguage())%>")){
			var mailTemplateId = e.target.options[e.target.selectedIndex].value;
			var mailTemplateType = e.target.options[e.target.selectedIndex].getAttribute("templateType");
			loadTemplate(mailTemplateId, mailTemplateType);
		}
	});

	<%if(defaultTemplateId!=-1 && flag==-1){%>
		setTimeout("loadTemplate(<%=defaultTemplateId%>, <%=templateType%>)",1000);
	<%}%>
	if("<%=contentType%>"=="0"){
		$("weaver").texttype.options[1].selected = true;
		$("mouldtext").style.display = "";
		$("mailTemplate").disabled = true;
	}
});
CkeditorExt['complete']=function(o){
	if("<%=contentType%>"=="0") {setTextType(1); $("mouldtext").value=$("mouldtext_temp").value;}
}
function loadMailContent(){
	// Load MailContent
	document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML = document.weaver.mouldtext.innerText;
}
function html2txt(){
	var text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	text = text.replace(/<meta.*charset.*?>/ig, "");
	text = text.stripScripts().stripTags().escapeHTML();
	$("weaver").mouldtext.value = text;
}


function setTextType(thisvalue){
	if(jQuery("#texttype").val()==0){
		//var switched=CkeditorExt.switchTextMode(thisvalue);
		//if(!switched)return;
		if(confirm("转换至文本编辑会丢失格式设置,确定切换吗(Y/N)")){
			var mouldtextValue=CkeditorExt.getText();
			mouldtextValue = mouldtextValue.replace(/\n/g,"");
			mouldtextValue = mouldtextValue.replace(/\r/g,"");
		    jQuery("#cke_mouldtext").hide();
		    jQuery("#mouldtext").val(mouldtextValue);
		    jQuery("#mouldtext").css({"visibility":"visible","display":""});
	    }
	}else{
	   //CkeditorExt.switchTextMode(thisvalue);
	    jQuery("#cke_mouldtext").show();
	    jQuery("#mouldtext").css({"visibility":"hidden","display":"none"});
	    alert(jQuery("#mouldtext").val());
	    CkeditorExt.setHtml(jQuery("#mouldtext").val());
	 }
	/*****###@2007-08-28 add by yeriwei! ***/
	var d=(jQuery("#texttype").val()==1)?false:true;
	$("mailTemplate").disabled =d;
	disabledMenuButton(d);//切换至文本编辑模式时，禁止[Html和最大化]按钮。
}
function disabledMenuButton(blDisabled){
	var btns=window.frames["rightMenuIframe"].document.getElementsByTagName("button");
	var t=null;
	for(var i=0;i<btns.length;i++){
		t=jQuery.trim(btns[i].innerText);
		if(t=="Html" || t=="最大化"){
			btns[i].disabled=blDisabled;
		}
	}
}
function toggleReciverSelector(posX, posY){
	receiverMore.style.left = posX;
	receiverMore.style.top = posY;
	Element.toggle(receiverMore);
}
function loadTemplate(mailTemplateId, mailTemplateType){
	if(mailTemplateId==0){//清空模板内容
		//document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML = "";
		/***##2007-08-28 modify yeriwei!**/
		CkeditorExt.setHtml("");//清空编辑器内容
		
		return false;
	}
	$("templateLoading").style.visibility = "visible";
	new Ajax.Request("MailTemplateTemp.jsp", {
		onSuccess : function(resp){setTemplate(resp);},
		onFailure : function(){alert("Template Error!");},
		parameters : "id="+mailTemplateId+"&templateType="+mailTemplateType+"&userId=<%=userId%>"
	});
}
function setTemplate(resp){
	var templateContent = resp.responseText;
	var reg = /\$\$\$(.*)\$\$\$/;
	$("mailSubject").value = templateContent.match(reg)[1];
    if($("mailSubject").value !="")
    {
         $("mailSubjectSpan").innerHTML='';
    }
    else
    {
         $("mailSubjectSpan").innerHTML="<img src='/images/BacoError_wev8.gif' align=\"absMiddle\">";
    }
    //document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML = templateContent.replace(reg, "");
	/***###@2007-08-28 modify by yeriwei! ***/
	CkeditorExt.setHtml(templateContent.replace(reg, ""));//设置编辑器内容
	
	$("templateLoading").style.visibility = "hidden";
}
function addCC(){
	Element.show($("tdCC"));
	Element.show($("tdCCLine"));
	Element.hide($("btnAddCC"));
}
function addBCC(){
	Element.show($("tdBCC"));
	Element.show($("tdBCCLine"));
	Element.hide($("btnAddBCC"));
}
function addAttachment(e){
	var e= e.srcElement||e.target;
	if((parseInt($F("attachmentCount"))+parseInt($F("hasfile"))) >= 4){
		alert("<%=SystemEnv.getHtmlLabelName(19943, user.getLanguage())%>5");
		return false;
	}
	/*
	jQuery("#attachmentCount").val(parseInt($F("attachmentCount")) + 1);
	var inputFileHTML = "<div><input type='file' <%if (emailfilesize > 0) {%>onchange='accesoryChanage(this)'<%}%> name='attachfile"+$F("attachmentCount")+"' class='inputstyle' style='width: 70%' /><%if (emailfilesize > 0) {%>(<%=SystemEnv.getHtmlLabelName(18580, user.getLanguage())%><%=emailfilesize%>M)<%}%>&nbsp;&nbsp<button class=AddDocFlow onclick='removeAttachment(this)' title='<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></button></div>";
	jQuery("#btnAddAttachment").before(inputFileHTML);
    */
    
    $("attachmentCount").value = parseInt($F("attachmentCount")) + 1;
	var inputFileHTML = "<div><input type='file' <%if(emailfilesize>0){%>onchange='accesoryChanage(this)'<%}%> name='attachfile"+$F("attachmentCount")+"' class='inputstyle' style='width: 70%' /><%if(emailfilesize>0){%>(<%=SystemEnv.getHtmlLabelName(18580,user.getLanguage())%><%=emailfilesize%>M)<%}%>&nbsp;&nbsp<button class=AddDocFlow onclick='removeAttachment(this)' title='<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button></div>";
	new Insertion.Before(e, inputFileHTML);
	
}
function removeAttachment(o){
	Element.remove(o.parentNode);
	$("attachmentCount").value = parseInt($F("attachmentCount")) - 1;
}
function deleteAttachment(fileId){
	location.href = "MailOperation.jsp?operation=deleteAttachment&flag=3&mailIds=<%=mailId%>&attachmentId="+fileId;
	//$("attachmentTable_"+fileId).
	//$("weaver").hasfile.value--;
}
//==============================================
// Browser
//==============================================
function onShowContacterMail(o1, o2){
	tmpnameCont = jQuery(o1)[0].name;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MailContacterBrowserMulti.jsp");
	if(typeof data!="undefined"){
		if(tmpnameCont=="receiver"){
			jQuery("#receiverSpan").html("");	
		}
		if(data.id!=""){
			var re = /(.*)<(.*)>/ig;
			var mailUser = data.id.split(",");
			var mailEmail = data.name.split(",");
			var mailUserId,mailUserEmail;
			for(var i=0;i<mailUser.length;i++){
				if(mailUser[i]=="") continue;
				mailUserId = mailUser[i].split("~")[0];
				mailUserEmail = mailEmail[i].split("~")[0];
				o1.value += o1.value=="" ? mailUserEmail : "," + mailUserEmail;
				o2.value += o2.value=="" ? mailUserId : "," + mailUserId;
			}
		}else{
			jQuery(o1).val("");
			jQuery(o2).val("");
		}
		
	}

}
function onShowCRMContacterMail(o1, o2){
	var ids;
	var _idspan = "";
	tmpnameCRM = jQuery(o1)[0].name;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCRMContacterBrowserMail.jsp");
	if(data){
		if(tmpnameCRM=="receiver"){
			jQuery("#receiverSpan").html("");	
		}
		if(data.id!=""){
			//alert(ids[0]);alert(ids[1]);return false;
			var _ids = data.id.split(",");
			var _names = data.name.split(",");
			for(var i=0;i<_names.length;i++){
				if(_ids[i]=="") continue;
				o1.value += o1.value=="" ? _names[i] : "," + _names[i];
				o2.value += o2.value=="" ? _ids[i] : "," + _ids[i];
			}
		}
	}
}
//==============================================
// Form Action
//==============================================
function validateMailAddress(str){
	var valid = true;
	var arr = str.split(",");
	for(var i=0;i<arr.length;i++){
		var a = arr[i];
		var pos1 = a.indexOf("<");
		var pos2 = a.lastIndexOf(">");
		if(pos1!=-1&&pos2!=-1){
			if(!checkEmail(trim(a.substring(pos1+1,pos2)))){
				valid = false;
				break;
			}
		}else{
			if(!checkEmail(trim(a))){
				valid = false;
				break;
			}
		}
	}
	return valid;
}
function validateForm(){
	if(check_form(weaver,'receiver') && check_form(weaver,'mailSubject')){
		if(validateMailAddress($("receiver").value) && validateMailAddress($("receiverCC").value) && validateMailAddress($("receiverBCC").value)){
			return true;
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");//邮件地址格式错误
			return false;
		}
	}
	return false;
}
function doSend(obj){
	if(!validateForm()) return false;
	hideRightClickMenu();
	showMsgBox($("msgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelName(19940,user.getLanguage())%>...", $("mouldtext").parentElement.offsetTop+30);
	/****###@2007-08-28 modify by yeriwei!
	if(jQuery("#texttype").val()==1){
		editorToTextarea();
	}
	***/
	
	if(jQuery("#texttype").val()==1){
		var s=CkeditorExt.getHtml();
		var div=document.createElement("div");
		div.style.display="none";
		div.innerHTML=s;
		document.body.appendChild(div);
		$("mouldtext").value=div.innerHTML;
	}else{//发送纯文本格式
		sendtxt();		
    }
    var tempvalue=$("mouldtext").value;
	$("operation").value = "sendmail";
	$("weaver").submit();
	if(jQuery("#texttype").val()==0)
	$("mouldtext").value=tempvalue;
	obj.disabled=true;
}
function sendtxt(){//纯文本发送

    var t = document.createElement("textarea");
	t.name = "mouldtext_txt";
	t.style.display = "none"; 
	//t.innerHTML = $("mouldtext").value;
	t.value = $("mouldtext").value;
	document.weaver.appendChild(t);

}
function doDraft(obj){
	if(!validateForm()) return false;
	hideRightClickMenu();
	showMsgBox($("msgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelName(19941,user.getLanguage())%>...", $("mouldtext").parentElement.offsetTop+30);
	/****##@2007-08-28 modify by yeriwei!
	if(jQuery("#texttype").val()==1){
		editorToTextarea();
	}**/
	CkeditorExt.updateContent();	
	sendtxt();
	$("weaver").savedraft.value = "1";
	$("weaver").folderId.value = "-2";
	var tempvalue=$("mouldtext").value;
	$("weaver").submit();
	if(jQuery("#texttype").val()==0)
	$("mouldtext").value=tempvalue;
	obj.disabled=true;
}
function editorToTextarea(){
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	text = text.replace(/<meta.*charset.*?>/ig, "");
	$("weaver").mouldtext.value = text;
}
function onHtml(){
	if(document.weaver.mouldtext.style.display==''){
		text = document.weaver.mouldtext.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.mouldtext.style.display='none';
		divifrm.style.display='';
	}else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.mouldtext.value=text;
		document.weaver.mouldtext.style.display='';
		divifrm.style.display='none';
	}
}
function resizeEditor(){
	var oMenuBtn = window.frames["rightMenuIframe"].event.srcElement;
	resizeObjStyle($("dhtmlFrm").style, oMenuBtn);
	resizeObjStyle($("mouldtext").style, oMenuBtn);
}
function toggleSelect(d){
	var o = document.getElementsByTagName("SELECT");
	for(var i=0;i<o.length;i++){
		o[i].style.display = d;
	}
}
function resizeObjStyle(o, btn){
	if(o.top==""){//maximize
		toggleSelect("none");
		o.position = "absolute";
		o.top = "45px";
		o.height = $("tblForm").offsetHeight;
		btn.innerHTML = btn.innerHTML.replace(/(<.*>)(.*)/ig, function(){return arguments[1]+" <%=SystemEnv.getHtmlLabelName(19965, user.getLanguage())%>";});
	}else{//minimize
		toggleSelect("");
		o.position = "relative";
		o.top = "";
		o.height = "100%";
		btn.innerHTML = btn.innerHTML.replace(/(<.*>)(.*)/ig, function(){return arguments[1]+" <%=SystemEnv.getHtmlLabelName(19944, user.getLanguage())%>";});
	}
}
function setMailSign(signid)
{
var oEditor = CKEDITOR.instances.mouldtext;
	if(signid=="")
	{
		return false;
	}
	var signContent = document.getElementById("signContent_"+signid);
	if(jQuery("#texttype").val()==0)
	{
		jQuery("#mouldtext").val(jQuery("#mouldtext").val()+"\n\n\n\n"+jQuery(signContent).text()) ;
		
		oEditor.setData( jQuery("#mouldtext").val()+"\n\n\n\n"+jQuery(signContent).text());
	}
	else
	{
		//var oEditor = FCKeditorAPI.GetInstance('mouldtext') ;
		
		var separator = document.getElementById("separator");
		var esignContent = document.getElementById("signContent");
		if(separator)
		{
			if(esignContent)
			{
				esignContent.innerHTML = signContent.innerHTML;
			}
			else
			{
				separator.outerHTML +="<div id='signContent'>"+signContent.innerHTML+"</div>";
			}
		}
		else
		{
			if(esignContent)
			{
				esignContent.outerHTML = "<br><br><br><br><div id='separator'></div>"+esignContent.outerHTML;
				esignContent.innerHTML = signContent.innerHTML;
			}
			else
			{
				oEditor.insertHtml("<br><br><br><br><div id='separator'></div><div id='signContent'>"+signContent.innerHTML+"</div>");
				//oEditor.EditorDocument.body.innerHTML += "<br><br><br><br><div id='separator'></div><div id='signContent'>"+signContent.innerHTML+"</div>";
			}
		}
	}
}

function onShowResourcemail(objNames,objIds)  {
    objidsValue = jQuery(objIds).val();
	strTemp="";
    //if(objidsValue<>"") then strTemp="?resourceids=" & objidsValue End if

    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MutiResourceMailBrowser.jsp"+strTemp);
	tmpnameRes = jQuery(objNames).attr("name");
	 if (data!=null){
        if (data.id!= ""){
          jQuery(objIds).val(data.id);
		  if(tmpnameRes == "receiver"){
			jQuery("#receiverSpan").html("");
		  }
        }else{
          jQuery(objIds).val("");
        }

        if (data.name!= ""){
			if (jQuery(objNames).val()==""){
				jQuery(objNames).val(data.name);
			}else{
				jQuery(objNames).val(jQuery(objNames).val() + "," +data.name);
			}
        }else{
          //objNames.value=""
        }
		
	 }
}
</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<style type="text/css">
input{width:95%;}
textarea{width:95%;word-break:break-all;}
select{width:200px;font:12px "MS Shell Dlg",Arial,Verdana}
.href{color:blue;text-decoration:underline;cursor:pointer;}
#templateLoading{visibility:hidden;margin-left:5px}
#receiverMore{
	/*width: 100px;
	border:1px solid #CCC;
	background-color:#FFF;
	padding:5px;
	filter:progid:DXImageTransform.Microsoft.dropshadow(OffX=2, OffY=2, Color='#FFCCCCCC', Positive=true);*/
}
#receiverMore div{
	cursor:pointer;
}
#receiverMore img{}
.receiverSelector{
	width:60px;
	/*
	border:1px solid #A4CAE4;
	background-image:url(/images/menuItemBgGray_wev8.gif);
	*/
}
.receiverSelectorOver{
	width:60px;
	cursor:pointer;
	/*
	cursor:default;
	border:1px solid #4A95C9;
	*/
}
</style>
<style id="popupmanager" type="text/css" media="screen">
.popupMenu{
	width: 100px;
	border: 1px solid #666666;
	background-color: #F9F8F7;
	padding: 1px;
}
.popupMenuTable{
	background-image: url(/images/popup/bg_menu_wev8.gif);
	background-repeat: repeat-y;
}
.popupMenuTable TD{
	font-family:MS Shell Dlg;
	font-size: 12px;
	cursor: default;
}
.popupMenuRow{
	height: 21px;
	padding: 1px;
}
.popupMenuRowHover{
	height: 21px;
	border: 1px solid #0A246A;
	background-color: #B6BDD2;
}
.popupMenuSep{
	background-color: #A6A6A6;
	height:1px;
	width: expression(parentElement.offsetWidth-27);
	position: relative;
	left: 28;
}
</style>
</head>
<body>
<%@ include file="/activex/target/ocxVersion.jsp" %>
<object ID="File" <%=strWeaverOcxInfo%> STYLE="margin:0px;padding:0px;width:0px;height:0px;overflow:hidden;"></object>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2083,user.getLanguage())+",javascript:doSend(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:doDraft(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:CkeditorExt.switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(19944,user.getLanguage())+",javascript:CkeditorExt.FullScreen(),_top} " ;
//RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="xTable_message" style="display:" id="msgBox"></div>
<!--======================== Receiptor Selector Detail =========================-->
<div id="receiverMore" class="popupMenu" style="display:none;position:absolute">
<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="popupMenuTable">
	<tr height="22">
		<td class="popupMenuRow" 
			id="receiverContacter" 
			onmouseover="this.className='popupMenuRowHover'"
			onmouseout="this.className='popupMenuRow'">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td width="28"><img src="/images/BacoBrowser_wev8.gif"/></td>
					<td><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr height="22">
		<td class="popupMenuRow" 
			id="receiverHRM"
			onmouseover="this.className='popupMenuRowHover'"
			onmouseout="this.className='popupMenuRow'">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td width="28"><img src="/images/BacoBrowser_wev8.gif" /></td>
					<td onClick=""><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></td>
				</tr>
			</table>
		</td>
	</tr>
<%if(isgoveproj==0){%>
	<tr height="22">
		<td class="popupMenuRow" 
			id="receiverCRM"
			onmouseover="this.className='popupMenuRowHover'"
			onmouseout="this.className='popupMenuRow'">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td width="28"><img src="/images/BacoBrowser_wev8.gif" /></td>
					<td onClick=""><%=SystemEnv.getHtmlLabelName(17129, user.getLanguage())%></td>
				</tr>
			</table>
		</td>
	</tr>
	<%}%>
</table>
</div>
<!--======================== Receiptor Selector Detail =========================-->

<table style="width:100%;height:92%;border-collapse:collapse">

<tr>
	<td valign="top">
		<table class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form id="weaver" name="weaver" action="MailOperationSend.jsp" method="post">
<input type="hidden" name="folderId" id="folderId" />
<input type="hidden" name="operation" id="operation" />
<input type="hidden" name="attachmentCount" id="attachmentCount" value="-1" />
<!--===================================================-->
<input type="hidden" name="savedraft" id="savedraft" value="0" />
<input type="hidden" name="msgid" id="msgid" value="" />

<input type="hidden" name="location" id="location" value="1" />
<!--===================================================-->

<table id="tblForm" class="ViewForm" style="height:100%">
<colgroup>
<col width="15%">
<col width="85%">
</colgroup>
<tbody>
<tr height="20">
	<td><%=SystemEnv.getHtmlLabelName(571, user.getLanguage())%></td>
	<td class="Field">
		<select name="mailAccountId">
		<%rs.executeSql("SELECT * FROM MailAccount WHERE userId="+userId+" ORDER BY accountName");while(rs.next()){%>
		<option value="<%=rs.getInt("id")%>" 
				<%if(rs.getString("isDefault").equals("1")){out.print("selected=\"selected\"");}%>>
			<%=rs.getString("accountName")%>
		</option>
		<%}%>
		</select>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr height="20">
	<td valign="top">
	<div id="receiverSelector" class="receiverSelector"><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%> <img src="/images/menuArrowDown_wev8.gif" align="absmiddle" /></div>
	<div style="margin-top:2px">
	<span id="btnAddCC" class="href" style="display:<%=(!"".equals(_sendcc) && (flag==2 || flag==4))?"none":"inline" %>"><%=SystemEnv.getHtmlLabelName(2084, user.getLanguage())%></span> <span id="btnAddBCC" class="href" style="display:<%=(!"".equals(_sendbcc) && flag==4)?"none":"inline" %>"><%=SystemEnv.getHtmlLabelName(2085, user.getLanguage())%></span>
	</div>
	</td>
	<td class="Field">
		<textarea id="receiver" name="receiver" class="inputstyle" onChange="checkinput('receiver','receiverSpan')"><%=receiver%></textarea>
		<span id="receiverSpan"><%if(receiver.equals("")){%><img src='/images/BacoError_wev8.gif' align="absMiddle"><%}%></span>
		<!-- <input type="text" id="receiver" name="receiver" class="inputstyle" value="<%=receiver%>" /> -->
		<input type="hidden" id="receiverHide" name="receiverHide">
		<input type="hidden" id="receiverHideContacter" name="receiverHideContacter">
		<input type="hidden" id="receiverHideCRM" name="receiverHideCRM">
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr id="tdCC" style="display:<%=(!"".equals(_sendcc) && (flag==2 || flag==4))?"block":"none" %>" height="20">
	<td valign="top">
	<div id="receiverSelectorCC" class="receiverSelector"><%=SystemEnv.getHtmlLabelName(2084, user.getLanguage())%>　 <img src="/images/menuArrowDown_wev8.gif" align="absmiddle" /></div>
	</td>
	<td class="Field">
		<textarea id="receiverCC" name="receiverCC" class="inputstyle"><%=(!"".equals(_sendcc) && (flag==2 || flag==4))?_sendcc:"" %></textarea>
		<input type="hidden" id="receiverCCHide" name="receiverCCHide">
		<input type="hidden" id="receiverCCHideContacter" name="receiverCCHideContacter">
		<input type="hidden" id="receiverCCHideCRM" name="receiverCCHideCRM">
	</td>
</tr>
<tr id="tdCCLine" style="height:1px;display:<%=(!"".equals(_sendbcc) && flag==4)?"block":"none" %>"><td class="Line" colspan="2"></td></tr>
<tr id="tdBCC" style="display:none" height="20">
	<td valign="top">
	<div id="receiverSelectorBCC" name="receiverSelectorBCC" class="receiverSelector"><%=SystemEnv.getHtmlLabelName(2085, user.getLanguage())%>　 <img src="/images/menuArrowDown_wev8.gif" align="absmiddle" /></div>
	</td>
	<td class="Field">
		<textarea id="receiverBCC" name="receiverBCC" class="inputstyle"><%=(!"".equals(_sendbcc) && flag==4)?_sendbcc:"" %></textarea>
		<input type="hidden" id="receiverBCCHide" name="receiverBCCHide">
		<input type="hidden" id="receiverBCCHideContacter" name="receiverBCCHideContacter">
		<input type="hidden" id="receiverBCCHideCRM" name="receiverBCCHideCRM">
	</td>
</tr>
<tr id="tdBCCLine" style="display:none;height:1px"><td class="Line" colspan="2"></td></tr>

<tr height="20">
	<td><%=SystemEnv.getHtmlLabelName(19811, user.getLanguage())%></td>
	<td class="field">
	<table style="width:100%;" cellpadding="0" cellspacing="0">
	<colgroup>
	<col width="110">
	<col width="50">
	<col width="200">
	<col width="52">
	<col width="*">
	</colgroup>
	<tr>
		<!-- 邮件格式============================================= -->
		<td>
		<select name="texttype" id="texttype" onchange="setTextType(this.value)" style="width:100px">
		<option value="1"><%=SystemEnv.getHtmlLabelName(19112, user.getLanguage())%></option>
		<option value="0"><%=SystemEnv.getHtmlLabelName(19111, user.getLanguage())%></option>
		</select>
		</td>
		<!-- 模板============================================= -->
		<td style="background-color:#FFF">&nbsp;<%=SystemEnv.getHtmlLabelName(64, user.getLanguage())%></td>
		<td class="Field">
			<select id="mailTemplate" name="mailTemplate" style="width:170px">
			<option value=""></option>
			<%rs.executeSql("SELECT * FROM DocMailMould ORDER BY mouldname");while(rs.next()){%>
			<option value="<%=rs.getInt("id")%>" 
					<%if(templateType.equals("1") && defaultTemplateId==rs.getInt("id")){out.print("selected=\"selected\"");}%>
					templateType="1">
					<%=rs.getString("mouldname")%>
			</option>
			<%}
			rs.executeSql("SELECT * FROM MailTemplate WHERE userId="+userId+" ORDER BY templateName");while(rs.next()){%>
			<option value="<%=rs.getInt("id")%>" 
					<%if(templateType.equals("0") && defaultTemplateId==rs.getInt("id")){out.print("selected=\"selected\"");}%>
					templateType="0">
					<%=rs.getString("templateName")%>
			</option>
			<%}%>
			</select><img id="templateLoading" src="/images/loading2_wev8.gif" align="absmiddle" />
		</td>
		<!-- 插入图片============================================= -->
		<!---###@2007-08-28 modify by yeriwei!
		<td style="background-color:#FFF">&nbsp;<%//SystemEnv.getHtmlLabelName(681,user.getLanguage())%></td>
		<td class="Field">
			<div id=divimg name=divimg>
			<input class=InputStyle  type=file name="docimages_0" size=60>
			</div>
			<input type=hidden name=docimages_num value="0"></input>
			<%//SystemEnv.getHtmlLabelName(18952,user.getLanguage())%>>
		</td>
		---->
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	</table>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr height="20">
	<td><%=SystemEnv.getHtmlLabelName(24268, user.getLanguage())%></td>
	<td class="field">
		<table style="width:100%;" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="50">
				<col width="50">
				<col width="200">
				<col width="52">
				<col width="*">
			</colgroup>
			<tr>
				<!-- 插入签名 -->
				<td class="Field">
					<select id="mailSign" name="mailSign" style="width:100px" onchange="setMailSign(this.value);">
						<option value=""></option>
						<%
							rs.executeSql("SELECT * FROM MailSign WHERE userId=" + userId + " ORDER BY signName");
							while(rs.next())
							{
						%>
						<option value="<%=rs.getString("id")%>">
							<%=rs.getString("signName")%>
						</option>
						<%	
							}
						%>
					</select>
					<%
						rs.executeSql("SELECT * FROM MailSign WHERE userId=" + userId + " ORDER BY signName");
						while(rs.next())
						{
							String signId = rs.getString("id");
						    String signContent = rs.getString("signContent");
						    rs1.execute("select id ,isfileattrachment,fileContentId from MailResourceFile where signid="+signId+" and isfileattrachment=0");
						    while(rs1.next()){ 
		                        String isfileattrachment = rs1.getString("isfileattrachment");
		                        String imgId = rs1.getString("id");
		                        String thecontentid = rs1.getString("fileContentId");
		                        String oldsrc = "cid:" + thecontentid ;
		                        String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+imgId;
		                        if(signContent.indexOf(oldsrc)!= -1){
		                           signContent = signContent.replace(oldsrc,newsrc);
		                        }
		                        
		                    }
					%>
					<div id="signContent_<%=rs.getString("id")%>" style="display:none;"><%=signContent %></div>
					<%	
						}
					%>
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr height="20">
	<td><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></td>
	<td class="Field">
		<input type="text" id="mailSubject" name="mailSubject" class="inputstyle" value="<%=subject%>" onChange="checkinput('mailSubject','mailSubjectSpan')" />
		<span id="mailSubjectSpan"><%if("".equals(subject)||null==subject){%><img src='/images/BacoError_wev8.gif' align="absMiddle"><%} %></span>
	</td>
</tr>

<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td colspan="2">
	<textarea name="mouldtext" id="mouldtext" style="display:none;width:100%;height:250"><%=content%></textarea>

	<textarea name="mouldtext_temp" id="mouldtext_temp" style="display:none;width:100%;height:250"><%=tempContent%></textarea>
	<!---###@2007-08-28 modify by yeriwei!
	<div id="divifrm" style="display:;width:100%;height:100%">
	<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height:100%" id="dhtmlFrm" 
		<%if(mailId!=-1){%>
		onload="loadMailContent()"
		<%}%>
	>
	</iframe>
	-->
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr height="20">
	<td valign="top"><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%></td>
	<td class="field">
	<%//转发或草稿时显示已添加的附件
	int attachmentNumber = 0;
	if(flag==3 || flag==4){
		wmc.resetCurrentfile();
		String attachmentName = "";
		String attachmentNameEncode = "";
		String linkstr = "";
		String attachUrl = "";
		while(wmc.next()){
			attachmentNameEncode = new String((wmc.getCurrentFilename()).getBytes("ISO8859_1"), "UTF-8");
			linkstr = "/weaver/weaver.email.FileDownloadLocation?fileid="+wmc.getCurrentFilenum()+"";
			attachUrl = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+wmc.getCurrentFilenum();
	%>
	<table id="attachmentTable_<%=wmc.getCurrentFilenum()%>" cellpadding="0" cellspacing="0" style="width:100%;border:1px solid #FFF">
	<tr>
	<td>
		<a href="<%=linkstr%>"><%=wmc.getCurrentFilename()%></a>
	</td>
	<td style="text-align:right">
		<button class="btnDelete" onClick="deleteAttachment(<%=wmc.getCurrentFilenum()%>)">
			-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
		</button>
		<button class="btnSave" onClick="parent.location.href='<%=attachUrl%>&download=1'">
			-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>
		</button>
	</td>
	</tr>
	</table>
	<%attachmentNumber++;}}%>
	<span id="btnAddAttachment" class="href" onclick="addAttachment(event)"><%=SystemEnv.getHtmlLabelName(19812, user.getLanguage())%></span>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr height="20">
	<td><%=SystemEnv.getHtmlLabelName(2092, user.getLanguage())%></td>
	<td class="Field">
		<input type="checkbox" name="savesend" value="1" class="inputstyle" style="width:20px" />
		<%=SystemEnv.getHtmlLabelName(848, user.getLanguage())%>
		<select name="priority">
		<option value="3" <%if(priority.equals("3"))out.print("selected");%>><%=SystemEnv.getHtmlLabelName(2086, user.getLanguage())%></option>
		<option value="2" <%if(priority.equals("2"))out.print("selected");%>><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
		<option value="4" <%if(priority.equals("4"))out.print("selected");%>><%=SystemEnv.getHtmlLabelName(19952, user.getLanguage())%></option>
		</select>
</tr>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<input type="hidden" name="hasfile" id="hasfile" value="<%=attachmentNumber%>" />
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>

</table>
</body>
<script language="javascript">
setTimeout("addccbcc()",0);
function addccbcc(){
	<%
		if(!sendcc.equals("")){
	%>
			document.all("btnAddCC").click();
	<%	
		}
		if(!sendbcc.equals("")){
	%>
			document.all("btnAddBCC").click();
	<%	
		}
	%>
}
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;  
        fileLenth= File.getFileSize();  
    } catch (e){
        alert("用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系！");
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = fileLenth/(1024*1024) 
	var fileLenthByK =  fileLenth/1024;
	var fileLenthByM =  fileLenthByK/1024;

	var fileLenthName;
	if(fileLenthByM>=0.1){
		fileLenthName=fileLenthByM.toFixed(1)+"M";
	}else if(fileLenthByK>=0.1){
		fileLenthName=fileLenthByK.toFixed(1)+"K";
	}else{
		fileLenthName=fileLenth+"B";
	}
    if (fileLenthByM><%=emailfilesize%>) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthName+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=emailfilesize%>M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>");		
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.style.width = '70%';
    newObj.onchange=function(){accesoryChanage(this);};
    
    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode); 
}


</script>
</html>