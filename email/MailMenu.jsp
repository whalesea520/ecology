
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!--
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
-->
<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<base target="mailFrameRight" />
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript" src="/js/mail/xtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/js/mail/xtree_wev8.css" />
<style type="text/css" media="screen">
body{margin:4px 0 0 8px}
#divFavContent{display:none;}
#ifrm{width:0;height:0}
#loading{background-color:#CC4444;color:#FFF;position:absolute;top:0;right:0;font:12px MS Shell Dlg,Verdana}
</style>
<style id="popupmanager" type="text/css" media="screen">
.popupMenu{width:100px;border:1px solid #666666;background-color:#F9F8F7;padding:1px;}
.popupMenuTable{background-image:url(/images/popup/bg_menu_wev8.gif);background-repeat:repeat-y;}
.popupMenuTable TD{font-family:MS Shell Dlg;font-size:12px;cursor:default;}
.popupMenuRow{height:21px;padding:1px;}
.popupMenuRowHover{height:21px;border:1px solid #0A246A;background-color:#B6BDD2;}
.popupMenuSep{background-color:#A6A6A6;height:1px;width:expression(parentElement.offsetWidth-27);position:relative;left:28;}
</style>
</head>
<body>
<div id="mailTreeMenu">
<script type="text/javascript">
//====================================================================
// WebFxTree (sText, sAction, sBehavior, sIcon, sOpenIcon)
//====================================================================
webFXTreeConfig.openRootIcon	= "/images/xp/openfolder_wev8.png";
webFXTreeConfig.folderIcon		= "/images/xp/folder_wev8.png";
webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder_wev8.png";
webFXTreeConfig.fileIcon		= "/images/xp/file_wev8.png";
webFXTreeConfig.blankIcon		= "/images/xp2/blank_wev8.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus_wev8.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus_wev8.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus_wev8.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus_wev8.png";
webFXTreeConfig.iIcon			= "/images/xp2/I_wev8.png";
webFXTreeConfig.lIcon			= "/images/xp2/L_wev8.png";
webFXTreeConfig.tIcon			= "/images/xp2/T_wev8.png";

var rti;
var tree = new WebFXTree("<%=SystemEnv.getHtmlLabelName(1213,user.getLanguage())%>", "", "", "/images/mail_wev8.gif", "/images/mail_wev8.gif");
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(2029,user.getLanguage())%>","MailAdd.jsp","","/images/mail_add_wev8.gif","/images/mail_add_wev8.gif"));

tree.add(rtiInbox = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>", "MailInbox.jsp", "", "/images/mail_inbox_wev8.gif", "/images/mail_inbox_wev8.gif"));
rtiInbox.folderId = "0";
<%=getInboxFolderTreeNode(user, 0)%>
tree.add(rtiOutbox = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%>", "MailInbox.jsp?groupId=-1", "", "/images/mail_outbox_wev8.gif", "/images/mail_outbox_wev8.gif"));
rtiOutbox.folderId = "-1";
tree.add(rtiDraftbox = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>", "MailInbox.jsp?groupId=-2", "", "/images/mail_draft_wev8.gif", "/images/mail_draft_wev8.gif"));
rtiDraftbox.folderId = "-2";
tree.add(rtiTrashbox = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(19817,user.getLanguage())%>", "MailInbox.jsp?groupId=-3", "", "/images/mail_junk_wev8.gif", "/images/mail_junk_wev8.gif"));
rtiTrashbox.folderId = "-3";

tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(19824,user.getLanguage())%>", "MailSearch.jsp", "", "/images/mail_search_wev8.gif", "/images/mail_search_wev8.gif"));

tree.add(rtiContacter = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>", "MailContacter.jsp", "", "/images/mail_contact_wev8.gif", "/images/mail_contact_wev8.gif"));
rtiContacter.groupId = "0";
<%=getContacterGroupTreeNode(user, 0)%>

tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(16218,user.getLanguage())%>", "MailTemplate.jsp", "", "/images/mail_template_wev8.gif", "/images/mail_template_wev8.gif"));
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(24267,user.getLanguage())%>", "MailSign.jsp", "", "/images/mail_template_wev8.gif", "/images/mail_template_wev8.gif"));
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>", "MailOption.jsp", "", "/images/mail_option_wev8.gif", "/images/mail_option_wev8.gif"));

document.write(tree);
tree.expandAll();

// Refresh TreeMenu
function refrehMailTreeMenu(){
	$("mailTreeMenu").innerHTML = tree.toString();
}

function traceMouseDrag(){
	var b = parent.frames[2].mailInboxLeft||parent.frames[2];
//================================================================================
//邮件拖动操作
	if(b.dragging){
		rtiInbox.setFolderId();
		rtiOutbox.setFolderId();
		rtiDraftbox.setFolderId();
		rtiTrashbox.setFolderId();
		setFolderId(rtiInbox);
		var srcID = event.srcElement.id;
		b.dragging = false;
		var myHidden = "webfx-tree-object-"+srcID.match(/[0-9]+/ig)+"-hidden";
		var myAnchor = "webfx-tree-object-"+srcID.match(/[0-9]+/ig)+"-anchor";
		var targetFolderId = document.getElementById(myHidden).innerHTML;
		if(targetFolderId!=""){
			var mailIds = b._xtable_CheckedCheckboxId();
			//alert(mailIds);
			if(mailIds==""){
				alert("<%=SystemEnv.getHtmlLabelName(20029,user.getLanguage())%>");
				return false;
			}
			if(confirm("<%=SystemEnv.getHtmlLabelName(20251,user.getLanguage())%>["+$(myAnchor).innerHTML+"]?")){
				new Ajax.Request("MailOperation.jsp", {
					onSuccess : function(){
						getUnReadMailCount();
						b._table.reLoad();
						b._xtable_CleanCheckedCheckbox();
					},
					onFailure : function(){alert("error!");},
					parameters : "mailIds="+mailIds+"&operation=move&toFolderId="+targetFolderId+""
				});
			}
			b.dragging = false;
		}
	}
//================================================================================
//联系人拖动操作
	if(b.draggingContacter){
		rtiContacter.setGroupId();
		setGroupId(rtiContacter);
		var srcID = event.srcElement.id;
		b.draggingContacter = false;
		var myHidden = "webfx-tree-object-"+srcID.match(/[0-9]+/ig)+"-hidden";
		var myAnchor = "webfx-tree-object-"+srcID.match(/[0-9]+/ig)+"-anchor";
		var targetGroupId = document.getElementById(myHidden).innerHTML;
		//alert(targetGroupId);
		if(targetGroupId!=""){
			var contacterIds = b._xtable_CheckedCheckboxId();
			//alert(contacterIds);
			if(contacterIds==""){
				alert("<%=SystemEnv.getHtmlLabelName(20250,user.getLanguage())%>");
				return false;
			}
			if(confirm("<%=SystemEnv.getHtmlLabelName(20252,user.getLanguage())%>["+$(myAnchor).innerHTML+"]?")){
				new Ajax.Request("MailContacterOperation.jsp", {
					onSuccess : function(){
						b._table.reLoad();
						b._xtable_CleanCheckedCheckbox();
					},
					onFailure : function(){alert("error!");},
					parameters : "contacterIds="+contacterIds+"&operation=move&groupId="+targetGroupId+""
				});
			}
			b.draggingContacter = false;
		}
	}
//================================================================================
}
function setFolderId(o){
	for(var i=0;i<o.childNodes.length;i++){
		o.childNodes[i].setFolderId();
		if(o.childNodes[i].childNodes.length!=0){
			setFolderId(o.childNodes[i]);
		}
	}
}
function setGroupId(o){
	for(var i=0;i<o.childNodes.length;i++){
		o.childNodes[i].setGroupId();
		if(o.childNodes[i].childNodes.length!=0){
			setGroupId(o.childNodes[i]);
		}
	}
}
</script>
</div>

<script type="text/javascript">
var oPopup;
try{
    oPopup = window.createPopup();
}catch(e){}
//======================================================================================
// Get unread mail count
//======================================================================================
Event.observe(window, "load", function(){
	<%
		rs.executeSql("select mailAutoCloseLeft from SystemSet");
		if(rs.next()){
			String  mailAutoCloseLeft=Util.null2String(rs.getString(1));
			if("1".equals(mailAutoCloseLeft)) out.println(" hideLeftMenu(); ");
		}
	%>		
	getUnReadMailCount();
});
function hideLeftMenu(){
	if(top.leftFrame!=null){
		var o = top.leftFrame.frames["mainFrameSet"];
		o.cols = "0,*";
	}
}
function getUnReadMailCount(){
	new Ajax.Request("UpdateMailTreeMenuAll.jsp", {
		onSuccess : function(resp){updateFolderUnReadMailCount(resp);},
		onFailure : function(){alert("Error!");},
		parameters : "userId=<%=user.getUID()%>"
	});
}
function updateFolderUnReadMailCount(resp){
	var fId, fName;
	var _rtiBox = "";
	var treeNodeText = resp.ResponseText.escapeHTML();
	//alert(treeNodeText);
	var aTreeNodeText;

	aTreeNodeText = treeNodeText.split("~");
	for(var i=0;i<aTreeNodeText.length;i++){
		if(aTreeNodeText[i]=="") continue;
		fId = aTreeNodeText[i].split("|")[1];
		fName = aTreeNodeText[i].split("|")[0];
		if(fId==0){
			_rtiBox = eval("rtiInbox");
		}else if(fId==-1){
			_rtiBox = eval("rtiOutbox");
		}else if(fId==-2){
			_rtiBox = eval("rtiDraftbox");
		}else if(fId==-3){
			_rtiBox = eval("rtiTrashbox");
		}else{
			try{_rtiBox = eval("rtiInbox"+fId);}catch(e){continue;}
		}
		_rtiBox.text = fName;
	}
	refrehMailTreeMenu();
}
//======================================================================================
// ContextMenu Event
//======================================================================================
Event.observe(document.body, "contextmenu", function(e){
	var o = e.srcElement;
	if(o.nodeName=="A"){
		var h = o.href.substring(o.href.lastIndexOf("/"), o.href.length);
		h.indexOf("=")==-1 ? toggleMenuItem("none") : toggleMenuItem("");
		if(h.indexOf("MailInbox")!=-1 && h.indexOf("-")==-1){
			showFav(webFXTreeHandler.all[o.parentNode.id], "folder");
		}else if(h.indexOf("MailContacter")!=-1){
			showFav(webFXTreeHandler.all[o.parentNode.id], "group");
		}
		return false;
	}
});

function toggleMenuItem(sDisplay){
	(2).times(function(i){$("divFavContent").firstChild.firstChild.rows[i+1].style.display = sDisplay;});
}



var currentParentTreeItem;
var currentTreeItem;

function addTreeNode(id, name, flag){
	var url, imgsrc;
	url = flag=="folder" ? "MailInbox.jsp?groupId="+id+"" : "MailContacter.jsp?groupId="+id+"";
	imgsrc = flag=="folder" ? "/images/mail_folder_wev8.gif" : "/images/mail_contact_wev8.gif";
	currentParentTreeItem.add(eval("rtiInbox"+id+" = new WebFXTreeItem(name, url, '', imgsrc, imgsrc)"));
	if(flag=="folder"){
		eval("rtiInbox"+id+".folderId = id");
	}else{
		eval("rtiInbox"+id+".groupId = id");
	}	
	$("loading").style.display = "none";
}
function updateTreeNode(name){
	currentTreeItem.text = name;
	refrehMailTreeMenu();
	$("loading").style.display = "none";
}

function addInboxFolder(parentTreeItem){
	var folderName = prompt("<%=SystemEnv.getHtmlLabelName(19825,user.getLanguage())%>","");
	if(folderName){
		currentParentTreeItem = parentTreeItem;
		$("ifrm").src = "MailInboxOperation.jsp?operation=folderAdd&userId=<%=user.getUID()%>&parentId="+parentTreeItem.folderId+"&folderName="+folderName+"";
		$("loading").style.display = "";
	}
}

function deleteInboxFolder(parentTreeItem){
	if(confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>") && confirm("<%=SystemEnv.getHtmlLabelName(19923,user.getLanguage())%>")){
		new Ajax.Request("MailInboxOperation.jsp", {
			onSuccess : function(resp){
				parentTreeItem.remove();
			},
			onFailure : function(){alert("error!")},
			parameters : "id="+parentTreeItem.folderId+""
		});
	}
}

function renameInboxFolder(treeItem){
	var folderName = prompt("<%=SystemEnv.getHtmlLabelName(19825,user.getLanguage())%>","");//文件夹名称
	if(folderName){
		currentTreeItem = treeItem;
		$("ifrm").src = "MailInboxOperation.jsp?operation=folderRename&userId=<%=user.getUID()%>&id="+treeItem.folderId+"&folderName="+folderName+"";
		$("loading").style.display = "";
	}
}

function addContacterGroup(parentTreeItem){
	var groupName = prompt("<%=SystemEnv.getHtmlLabelName(19826,user.getLanguage())%>","");
	if(groupName){
		currentParentTreeItem = parentTreeItem;
		$("ifrm").src = "MailContacterOperation.jsp?operation=groupAdd&userId=<%=user.getUID()%>&parentId="+parentTreeItem.groupId+"&groupName="+groupName+"";
	}
	$("loading").style.display = "";
}

function deleteContacterGroup(parentTreeItem){
	if(confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>") && confirm("<%=SystemEnv.getHtmlLabelName(19924,user.getLanguage())%>")){
		new Ajax.Request("MailContacterOperation.jsp", {
			onSuccess : function(resp){
				parentTreeItem.remove();
			},
			onFailure : function(){alert("error!")},
			parameters : "operation=groupDelete&groupId="+parentTreeItem.groupId+""
		});
	}
}
function renameContacterGroup(treeItem){
	var groupName = prompt("<%=SystemEnv.getHtmlLabelName(19826,user.getLanguage())%>","");//组名称
	if(groupName){
		currentTreeItem = treeItem;
		$("ifrm").src = "MailContacterOperation.jsp?operation=groupRename&userId=<%=user.getUID()%>&groupId="+treeItem.groupId+"&groupName="+groupName+"";
		$("loading").style.display = "";
	}
}
//==============================================
// PopupMenu
//==============================================
function GetPopupCssText(){
	var styles = document.styleSheets;
	var csstext = "";
	for(var i=0; i<styles.length; i++){
		if (styles[i].id == "popupmanager")
			csstext += styles[i].cssText;
	}
	return csstext;
}

function showFav(oNode, sNodeType){
  try{
	var popupX = 0;
	var popupY = 0;
	contentBox = $("divFavContent");
	var o = event.srcElement;
	popupX = Event.pointerX(window.event);
	popupY = Event.pointerY(window.event);

	if(!oPopup) return false;

	var oPopBody = oPopup.document.body;
	var s = oPopup.document.createStyleSheet();
	s.cssText = GetPopupCssText();
	oPopBody.innerHTML = contentBox.innerHTML;
	oPopBody.attachEvent("onmouseout",mouseout);

	for(var i=0;i<oPopup.document.getElementsByTagName("TD").length;i++){
		var oTD = oPopup.document.getElementsByTagName("TD")[i];
		var sMenuId = oTD.getAttribute("menuid");
		if(sMenuId != null){
			oTD.onmouseover = function(){this.className='popupMenuRowHover';};
			oTD.onmouseout = function(){this.className='popupMenuRow';};
			if(sNodeType=="folder"){
				switch(sMenuId){
					case "1" : oTD.onclick = function(){addInboxFolder(oNode);};	break;
					case "2" : oTD.onclick = function(){deleteInboxFolder(oNode);};	break;
					case "3" : break;
					case "4" : break;
					case "5" : oTD.onclick = function(){renameInboxFolder(oNode);};	break;
				}
			}else if(sNodeType=="group"){
				switch(sMenuId){
					case "1" : oTD.onclick = function(){addContacterGroup(oNode);};	break;
					case "2" : oTD.onclick = function(){deleteContacterGroup(oNode);};	break;
					case "3" : break;
					case "4" : break;
					case "5" : oTD.onclick = function(){renameContacterGroup(oNode);};	break;
				}
			}			
		}
	}

	oPopup.show(0, 0, 100, 0);
	var realHeight = oPopBody.scrollHeight;
	oPopup.hide();
	oPopup.show(popupX+15, popupY, 100, realHeight, document.body);
  }catch(e){}	
}

function mouseout(){
  try{
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) oPopup.hide();
  }catch(e){}
}
//==============================================
// Util
//==============================================
function trim(s){
	if(s==null){return s;}
	var i;
	var beginIndex = 0;
	var endIndex = s.length - 1;
	for(i=0;i<s.length;i++){
		if(s.charAt(i)==' ' || s.charAt(i)=='　'){
			beginIndex++;
		}else{
			break;
		}
	}
	for(i=s.length-1;i>=0;i--){
		if(s.charAt(i)==' ' || s.charAt(i)=='　'){
			endIndex--;
		}else{
			break;
		}
	}
	if(endIndex<beginIndex){return "";}
	return s.substring(beginIndex, endIndex + 1);
}

</script>

<!--===================================================-->
<!-- Context Menu Item -->
<!--===================================================-->
<div id="divFavContent">
<div class="popupMenu">
<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="popupMenuTable">
	<tr height="22">
		<td class="popupMenuRow" menuid="1">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td width="28"><img src="/images/popup/newfolder_wev8.gif" /></td>
					<td><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr height="22">
		<td class="popupMenuRow" menuid="2">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td width="28"><img src="/images/popup/remove_wev8.gif" /></td>
					<td onclick=""><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></td>
				</tr>
			</table>
		</td>
	</tr>
<!--
	<tr height="22">
		<td class="popupMenuRow" menuid="3">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td width="28"><img src="/images/popup/moveup_wev8.gif" /></td>
					<td onclick="">向上移动</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr height="22">
		<td class="popupMenuRow" menuid="4">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td width="28"><img src="/images/popup/movedown_wev8.gif" /></td>
					<td onclick="">向下移动</td>
				</tr>
			</table>
		</td>
	</tr>
-->
	<tr height="22">
		<td class="popupMenuRow" menuid="5">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td width="28"></td>
					<td onclick=""><%=SystemEnv.getHtmlLabelName(19827,user.getLanguage())%></td>
				</tr>
			</table>
		</td>
	</tr>
	<!--
	<tr height="3"><td><div class="popupMenuSep"><img height="1px"></div></td></tr>
	-->
</table>
</div>
</div>

<div id="loading" style="display:none">Loading...</div>
<iframe id="ifrm"></iframe>
</body>
</html>

<%!
//=================================================================
// Tree Node Recursion
//=================================================================
String getInboxFolderTreeNode(weaver.hrm.User user, int parentId){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String html = "";
	String sql = "SELECT * FROM MailInboxFolder WHERE userId="+user.getUID()+" AND parentId="+parentId+" ORDER BY folderName";
	rs.executeSql(sql);
	while(rs.next()){
		if(parentId==0){
			html += "rtiInbox.add(rtiInbox"+rs.getInt("id")+" = new WebFXTreeItem('"+rs.getString("folderName")+"',";
		}else{
			html += "rtiInbox"+parentId+".add(rtiInbox"+rs.getInt("id")+" = new WebFXTreeItem('"+rs.getString("folderName")+"',";
		}
		html += "'MailInbox.jsp?groupId="+rs.getInt("id")+"',";
		html += "'','/images/mail_folder_wev8.gif','/images/mail_folder_wev8.gif'));";
		html += "rtiInbox"+rs.getInt("id")+".folderId = '"+rs.getInt("id")+"';";
		if(rs.getInt("subCount")!=0){
			html += getInboxFolderTreeNode(user, rs.getInt("id"));
		}
	}
	return html;
}

String getContacterGroupTreeNode(weaver.hrm.User user, int parentId){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String html = "";
	String sql = "SELECT * FROM MailUserGroup WHERE createrid="+user.getUID()+" AND parentId="+parentId+" ORDER BY mailgroupname";
	rs.executeSql(sql);
	while(rs.next()){
		if(parentId==0){
			html += "rtiContacter.add(rtiContacter"+rs.getInt("mailgroupid")+" = new WebFXTreeItem('"+rs.getString("mailgroupname")+"',";
		}else{
			html += "rtiContacter"+parentId+".add(rtiContacter"+rs.getInt("mailgroupid")+" = new WebFXTreeItem('"+rs.getString("mailgroupname")+"',";
		}
		html += "'MailContacter.jsp?groupId="+rs.getInt("mailgroupid")+"',";
		html += "'','/images/mail_contact_wev8.gif','/images/mail_contact_wev8.gif'));";
		html += "rtiContacter"+rs.getInt("mailgroupid")+".groupId = '"+rs.getInt("mailgroupid")+"';";
		if(rs.getInt("subCount")!=0){
			html += getContacterGroupTreeNode(user, rs.getInt("mailgroupid"));
		}
	}
	return html;
}

/*
String getUnreadMailCount(int folderId, String folderName, weaver.hrm.User user){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String mailBoxName = "";
	int unreadMailCount = 0;
	rs.executeSql("SELECT COUNT(id) AS unreadMailCount FROM MailResource WHERE folderId="+folderId+" AND resourceid="+user.getUID()+" AND status=0");
	if(rs.next()){
		unreadMailCount = rs.getInt("unreadMailCount");
	}
	mailBoxName = unreadMailCount>0 ? ""+folderName+"("+unreadMailCount+")" : folderName;
	return mailBoxName;
}
*/
%>