
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(572,user.getLanguage());
String needfav ="1";
String needhelp ="";

int languageId = user.getLanguage();
int groupId = Util.getIntValue(request.getParameter("groupId"), 0);
String mailUserName = Util.null2String(request.getParameter("mailUserName"));
String mailAddress = Util.null2String(request.getParameter("mailAddress"));
String mailUserType = Util.null2String(request.getParameter("mailUserType"));
%>
<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<head>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript">
  
function doSearch(){
	document.getElementById("fMailContacterSearch").submit();
}
function doMove(){
   if(_xtable_CheckedCheckboxId()==""){
	   alert("<%=SystemEnv.getHtmlLabelName(20250,user.getLanguage())%>");
	   return false;
	}
  else{
	ids = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MailContacterGroupBrowser.jsp");
	if(ids || ids==0){
		with(document.getElementById("fMailContacter")){
			groupId.value = ids;
			operation.value = "contacterMove";
			contacterIds.value = _xtable_CheckedCheckboxId();
			submit();
		}
	}
  }
}
function batchDeleteContacter(){
	 if(_xtable_CheckedCheckboxId()==""){
	   alert("<%=SystemEnv.getHtmlLabelName(20250,user.getLanguage())%>");
	   return false;
	}
	if(confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>")){   
	with(document.getElementById("fMailContacter")){
		operation.value = "contacterBatchDelete";
		contacterIds.value = _xtable_CheckedCheckboxId();
		submit();
	}}
}
function contacterDel(contacterId){
	if(confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>")){
		location.href = "MailContacterOperation.jsp?operation=contacterDelete&groupId=<%=groupId%>&contacterId="+contacterId+"";
	}
}
function contacterEdit(contacterId){
	location.href = "MailContacterEdit.jsp?contacterId="+contacterId+"";
}
</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<style type="text/css">.href{color:blue;text-decoration:underline;cursor:hand}</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",MailContacterAdd.jsp?groupId="+groupId+",_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",MailContacterImport.jsp?groupId="+groupId+",_self} " ;    
RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+",,_self} " ;    
//RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:doMove(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:batchDeleteContacter(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table style="width:98%;height:92%;border-collapse:collapse" align="center">
<tr>
	<td height="10"></td>
</tr>
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<table class="viewform">
<form name="fMailContacterSearch" id="fMailContacterSearch" method="post" action="MailContacter.jsp?groupId=<%=groupId%>">
<colgroup>
	<col width="6%">
	<col width="15%">
	<col width="5%">
	<col width="10%">
	<col width="15%">
	<col width="5%">
	<col width="6%">
	<col width="25%">
</colgroup>
<tbody>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
	<td class="field"><input type="text" name="mailUserName" value="<%=mailUserName%>" class="inputstyle"/></td>
	<td></td>	
	<td><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())%></td>
	<td class="field"><input type="text" name="mailAddress" value="<%=mailAddress%>" class="inputstyle"/></td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
	<td class="field">
	<select name="mailUserType">
	<option></option>
	<option value="2" <%if(mailUserType.equals("2")){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
	<option value="3" <%if(mailUserType.equals("3")){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%></option>
	<option value="1" <%if(mailUserType.equals("1")){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(19078,user.getLanguage())%></option>
	</select>
	</td>
</tr>
<tr style="height:1px"><td class="line" colspan="8"></td></tr>
</tbody>
</form>
</table>
<!--==========================================================================================-->
<form id="fMailContacter" method="post" action="MailContacterOperation.jsp">
<input type="hidden" id="operation" name="operation" value="" />
<input type="hidden" id="contacterIds" name="contacterIds" value="" />
<input type="hidden" id="groupId" name="groupId" value="<%=groupId%>" />
<%
String sqlWhere = "WHERE userId="+user.getUID()+" AND mailgroupid="+groupId+"";
if(!mailUserName.equals("")){
	sqlWhere += " AND mailUserName LIKE '%"+mailUserName+"%'";
}
if(!mailAddress.equals("")){
	sqlWhere += " AND mailAddress LIKE '%"+mailAddress+"%'";
}
if(!mailUserType.equals("")){
	sqlWhere += " AND mailUserType='"+mailUserType+"'";
}

String tableString=""+
	"<table  pagesize=\"10\" tabletype=\"checkbox\">"+
	"<sql backfields=\"*\" sqlform=\"MailUserAddress\" sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
	"<head>"+                             
		"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"id\" orderkey=\"mailUserName\" target=\"_self\" transmethod=\"weaver.splitepage.transform.SptmForMail.getUserName\" />"+
		"<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(19805,user.getLanguage())+"\" column=\"mailAddress\" orderkey=\"mailAddress\" href=\"MailAdd.jsp\" linkkey=\"to\" linkvaluecolumn=\"mailAddress\" target=\"_self\" />"+
		"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"mailUserType\" orderkey=\"mailUserType\" transmethod=\"weaver.splitepage.transform.SptmForMail.getContacterTypeName\" otherpara=\""+String.valueOf(user.getLanguage())+"\"/>"+   
	"</head>"+
	"<operates width=\"15%\">"+
	"<popedom transmethod=\"weaver.splitepage.operate.SpopForMail.getContacterPope\" otherpara=\"column:mailUserType\"></popedom>"+
	"    <operate href=\"javascript:contacterEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>"+
	"    <operate href=\"javascript:contacterDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>"+
	"</operates>"+
	"</table>";             
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</TABLE>
	</td>
</tr>
<tr>
	<td height="10"></td>
</tr>
</table>
</body>
</html>
