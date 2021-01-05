
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:formSubmit(\"fMailRuleCondition\", \"tab2\"),_self} " ;    
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
<input type="hidden" name="operation" value="conditionAdd" />
<input type="hidden" name="id" value="<%=ruleId%>" />
<table id="tblMailRule" class="ViewForm">
<colgroup>
<col width="25%">
<col width="75%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(19841, user.getLanguage())%></th>
</tr>
<tr class="Spacing"><td class="Line1" colspan="2"></td></tr>
<tbody>
<tr>
	<td>
		<select name="cSource" class="rule" onchange="conditionChange()">
		<option value="1"><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%></option>
		<option value="4"><%=SystemEnv.getHtmlLabelName(2084, user.getLanguage())%></option>
		<option value="5"><%=SystemEnv.getHtmlLabelName(848, user.getLanguage())%></option>
		<option value="6"><%=SystemEnv.getHtmlLabelName(2047, user.getLanguage())%></option>
		<option value="7"><%=SystemEnv.getHtmlLabelName(19842, user.getLanguage())%></option>
		</select>
	</td>
	<td class="Field">
		<select name="operator" id="operator1">
		<option value="1"><%=SystemEnv.getHtmlLabelName(346, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(15507, user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%></option>
		<option value="4"><%=SystemEnv.getHtmlLabelName(19843, user.getLanguage())%></option>
		</select>
		<select name="operator" id="operator2" style="display:none" disabled="true">
		<option value="5"><%=SystemEnv.getHtmlLabelName(15508, user.getLanguage())%></option>
		<option value="6"><%=SystemEnv.getHtmlLabelName(15509, user.getLanguage())%></option>
		</select>
		<select name="operator" id="operator3" style="display:none" disabled="true">
		<option value="3"><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%></option>
		</select>
		<input type="text" name="cTarget" id="cTarget" class="inputstyle" style="width:250px" />
		<select name="cTargetPriority" id="cTargetPriority" style="display:none">
		<option value="3"><%=SystemEnv.getHtmlLabelName(2086, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
		<option value="4"><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></option>
		</select>
		<button class="calendar" id="browserDate" onclick="getDate(sendDate,sendDateSpan)" style="display:none"></button>
		<span id="sendDateSpan"></span>
		<input type="hidden" id="sendDate" name="sendDate" value="">
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