
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
%>
<html>
<head>
<link type="text/css" rel="stylesheet" href="/js/mail/xtree_wev8.css" />
<style type="text/css" media="screen">
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
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
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
tree.add(rtiContacter = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>", "javascript:setContacterGroup(0)", "", "/images/mail_contact_wev8.gif", "/images/mail_contact_wev8.gif"));
rtiContacter.groupId = "0";
<%=getContacterGroupTreeNode(user, 0)%>
document.write(tree);
tree.expandAll();

function setContacterGroup(groupId){
	window.parent.returnValue = groupId;
	window.close();
}
function traceMouseDrag(){}
</script>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>

<%!
//=================================================================
// Tree Node Recursion
//=================================================================
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
		html += "'javascript:setContacterGroup("+rs.getInt("mailgroupid")+")',";
		html += "'','/images/mail_contact_wev8.gif','/images/mail_contact_wev8.gif'));";
		html += "rtiContacter"+rs.getInt("mailgroupid")+".groupId = '"+rs.getInt("mailgroupid")+"';";
		if(rs.getInt("subCount")!=0){
			html += getContacterGroupTreeNode(user, rs.getInt("mailgroupid"));
		}
	}
	return html;
}
%>