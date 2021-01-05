
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

int ruleId = Util.getIntValue(request.getParameter("ruleId"));
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveaction(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:redirect(\"MailRuleEdit.jsp?id="+ruleId+"\", \"tab2\"),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailRuleOperation.jsp" id="fMailRuleCondition">
<input type="hidden" name="operation" value="actionAdd" />
<input type="hidden" name="id" value="<%=ruleId%>" />
<table id="tblMailRule" class="ViewForm">
<colgroup>
<col width="25%">
<col width="75%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(19831,user.getLanguage())%></th>
</tr>
<tr class="Spacing"><td class="Line1" colspan="2"></td></tr>
</tbody>
<tbody>
<tr>
	<td>
		<select name="aSource" class="rule" onchange="actionChange()">
		<option value="1"><%=SystemEnv.getHtmlLabelName(19832,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19833,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(18492,user.getLanguage())%></option>
		<option value="4"><%=SystemEnv.getHtmlLabelName(19822,user.getLanguage())%></option>
		</select>
	</td>
	<td class="Field">
		<button class="browser" id="browserFolder" onclick="onSelectMailInbox()"></button>
		<button class="browser" id="browserCRM" onclick="onSelectCRM()" style="display:none"></button>
		<input type="hidden" id="aTargetFolderId" name="aTargetFolderId" />
		<span id="aTargetFolderIdSpan"><img src='/images/BacoError_wev8.gif' align="absMiddle"></span>
		<input type="hidden" name="aTargetCRMId" />
		<span id="aTargetCRMIdSpan"></span>
		<input type="hidden" name="mainId" />
		<input type="hidden" name="subId" />
		<input type="hidden" name="secId" />
	</td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
</tbody>
</table>
</form>
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