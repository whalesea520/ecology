
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.worktask.worktask.WTSerachManager" %>
<html>
<%
	int perpage = 0;
	WTSerachManager wTSerachManager = new WTSerachManager();
	wTSerachManager.setUserID(user.getUID());
	perpage = wTSerachManager.getUserDefaultPerpage(true);
%>

<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="weaver" id="weaver" method="post" action="WorktaskUserDefaultOperation.jsp">
<input type="hidden" name="src" value="userdefault" >
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
			<TR class="Title"><TH><%=SystemEnv.getHtmlLabelName(89, user.getLanguage())%></TH></TR>
			<TR class="Spacing"><TD class="Line1"></TD></TR>
			<tr>
				<td>
					<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%>
					<input class="Inputstyle" type="text" id="perpage" name="perpage" size="3" temptitle="<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21893,user.getLanguage())%>" onKeyPress="ItemCount_KeyPress_self()" onBlur="checknumber1(this)" onChange="checkinput('perpage', 'perapgespan')" maxlength="2" value="<%=perpage%>">
					<%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>
					<span id="perapgespan"><span>
				</td>
			</tr>
			<TR class="Spacing"><TD class="Line"></TD></TR>
		</table>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</form>

<script language=javascript>
function submitData(){
	if (check_form(weaver, "perpage")){
		weaver.submit();
		enableAllmenu();
	}
}
function ItemCount_KeyPress_self(){
	if(!(window.event.keyCode>=48 && window.event.keyCode<=57)){
		window.event.keyCode=0;
	}
}
</script>
</body>
</html>
