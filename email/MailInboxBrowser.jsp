
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<html>
<head>
<link type="text/css" rel="stylesheet" href="/js/mail/xtree_wev8.css" />
<style type="text/css" media="screen">
.clickRightMenu{
	BORDER-RIGHT: none;	
	BORDER-TOP: none; 
	BORDER-LEFT: none;
	BORDER-BOTTOM: none; 
	PADDING-RIGHT: 5px; 
	DISPLAY: block; 
	PADDING-LEFT: 5px; 
	LEFT: -10000px;
	PADDING-BOTTOM: 3px; 
	WIDTH: 1px; PADDING-TOP: 3px; 	
	POSITION: absolute; 
	TOP: -10000px
}
.clickRightMenuOver{
	BORDER-RIGHT: #001E9E 1px solid; 
	BORDER-TOP: #001E9E 1px solid; 
	BORDER-LEFT: #001E9E 1px solid;
	PADDING-RIGHT: 10px;	
	DISPLAY: block;
	PADDING-LEFT: 10px;
	PADDING-BOTTOM: 0px;
	FONT: 12px verdana; 	
	WIDTH: 1px; 
	COLOR: #000000; 
	PADDING-TOP: 4px; 	
	HEIGHT: 24px; 
	TEXT-DECORATION: none;
	BORDER-BOTTOM: #001E9E 1px solid; 
	BACKGROUND-COLOR: #EBF8FE
}
.clickRightMenuOut{
	BORDER-RIGHT: #fffffa 1px solid;
	BORDER-TOP: #fffffa 1px solid;
	BORDER-LEFT: #fffffa 1px solid; 
	PADDING-RIGHT: 10px;	
	DISPLAY: block;
	PADDING-LEFT: 10px;
	PADDING-BOTTOM: 0px;
	FONT: 12px verdana; 	
	WIDTH: 1px; 
	COLOR: #000000; 
	PADDING-TOP: 4px; 	
	HEIGHT: 24px; 
	TEXT-DECORATION: none;
	BORDER-BOTTOM: #fffffa 1px solid
}
table.Shadow{
	border: #000000 ;
	width:100% ;
	height:100% ;
	border-color:#ffffff;
	border-top: 3px outset #ffffff;
	border-right: 3px outset #000000;
	border-bottom: 3px outset #000000;
	border-left: 3px outset #ffffff;
	background-color:#FFFFFF
}
</style>
<script type="text/javascript" src="/js/mail/xtree_wev8.js"></script>
</head>

<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(Util.null2String(request.getParameter("hasMenu")).equals("true")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:setFolder(-4),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
</colgroup>
<tr style="height:0px"> 
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top" style="padding:5px 0 0 10px">
<!--==========================================================================================-->
<script type="text/javascript">
// WebFxTree (sText, sAction, sBehavior, sIcon, sOpenIcon)
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
tree.add(rtiInbox = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>", "javascript:setFolder(0)", "", "/images/mail_inbox_wev8.gif", "/images/mail_inbox_wev8.gif"));
rtiInbox.folderId = "0";
<%=getInboxFolderTreeNode(user, 0)%>
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%>", "javascript:setFolder(-1)", "", "/images/mail_outbox_wev8.gif", "/images/mail_outbox_wev8.gif"));
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>", "javascript:setFolder(-2)", "", "/images/mail_draft_wev8.gif", "/images/mail_draft_wev8.gif"));
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())%>", "javascript:setFolder(-3)", "", "/images/mail_junk_wev8.gif", "/images/mail_junk_wev8.gif"));
document.write(tree);
tree.expandAll();

function setFolder(folderId){
	window.parent.parent.returnValue = folderId;
	window.parent.parent.close();
}
function traceMouseDrag(){}
</script>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>
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
		html += "'javascript:setFolder("+rs.getInt("id")+")',";
		html += "'','/images/mail_folder_wev8.gif','/images/mail_folder_wev8.gif'));";
		html += "rtiInbox"+rs.getInt("id")+".folderId = '"+rs.getInt("id")+"';";
		if(rs.getInt("subCount")!=0){
			html += getInboxFolderTreeNode(user, rs.getInt("id"));
		}
	}
	return html;
}
%>