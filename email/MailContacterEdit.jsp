
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(572,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

int contacterId = Util.getIntValue(request.getParameter("contacterId"));
int groupId = 0;
String mailUserName="", mailUserEmail="", mailUserType="", mailUserDesc="", mailUserEmailP="", mailUserTelP="", mailUserMobileP="", mailUserIMP="", mailUserAddressP="", mailUserTelW="", mailUserFaxW="", mailUserCompanyW="", mailUserDepartmentW="", mailUserPostW="", mailUserAddressW="";
rs.executeSql("SELECT * FROM MailUserAddress WHERE id="+contacterId+"");
if(rs.next()){
	groupId = rs.getInt("mailgroupid");
	mailUserName = rs.getString("mailUserName");
	mailUserEmail = rs.getString("mailAddress");
	mailUserType = rs.getString("mailUserType");
	mailUserDesc = rs.getString("mailUserDesc");
	mailUserEmailP = rs.getString("mailUserEmailP");
	mailUserTelP = rs.getString("mailUserTelP");
	mailUserMobileP = rs.getString("mailUserMobileP");
	mailUserIMP = rs.getString("mailUserIMP");
	mailUserAddressP = rs.getString("mailUserAddressP");
	mailUserTelW = rs.getString("mailUserTelW");
	mailUserFaxW = rs.getString("mailUserFaxW");
	mailUserCompanyW = rs.getString("mailUserCompanyW");
	mailUserDepartmentW = rs.getString("mailUserDepartmentW");
	mailUserPostW = rs.getString("mailUserPostW");
	mailUserAddressW = rs.getString("mailUserAddressW");
}
%>
<html>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript">
function doSubmit(){
	if(check_form(fMailContacter,'mailUserName') && check_form(fMailContacter,'mailUserEmail')){
		var o = $("fMailContacter").mailUserEmail;
		if(!checkEmail(o.value)){
			alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>。");
			o.focus();
			return false;
		}
		$("fMailContacter").submit();
	}
}
</script>
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
<style type="text/css" media="screen">
input{width:90%;}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<table class="Shadow">
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailContacterOperation.jsp" id="fMailContacter">
<input type="hidden" name="operation" value="contacterEdit" />
<input type="hidden" name="groupId" value="<%=groupId%>" />
<input type="hidden" name="contacterId" value="<%=contacterId%>" />
<table class="ViewForm">
<colgroup>
<col width="30%">
<col width="70%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
</tr>
<tr class="Spacing"  style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserName" class="inputstyle" value="<%=mailUserName%>" maxlength="20" onchange="checkinput('mailUserName','mailUserNameSpan')" />
		<SPAN id="mailUserNameSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserEmail" class="inputstyle" value="<%=mailUserEmail%>"  onchange="checkinput('mailUserEmail','mailUserEmailSpan')" />
		<SPAN id="mailUserEmailSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserDesc" class="inputstyle" value="<%=mailUserDesc%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<!--
<tr>
	<td>邮件地址</td>
	<td class="Field">
		<input type="text" name="mailUserEmailP" class="inputstyle" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserTelP" class="inputstyle" value="<%=mailUserTelP%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserMobileP" class="inputstyle" value="<%=mailUserMobileP%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(20030,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserIMP" class="inputstyle" value="<%=mailUserIMP%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19814,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserAddressP" class="inputstyle" value="<%=mailUserAddressP%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(15688,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserTelW" class="inputstyle" value="<%=mailUserTelW%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserFaxW" class="inputstyle" value="<%=mailUserFaxW%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserCompanyW" class="inputstyle" value="<%=mailUserCompanyW%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserDepartmentW" class="inputstyle" value="<%=mailUserDepartmentW%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserPostW" class="inputstyle" value="<%=mailUserPostW%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(17095,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="mailUserAddressW" class="inputstyle" value="<%=mailUserAddressW%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
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
</body>
</html>