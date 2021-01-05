
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
								 weaver.general.GCONST,
                 weaver.hrm.settings.ChgPasswdReminder,
                 weaver.hrm.settings.RemindSettings,java.io.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
	if(!jQuery("#entervalid").attr("checked"))jQuery("#tr_enterremindperiod").hide();
});

function isAlarm(obj)
{
	jQuery("#tr_enterremindperiod").hide();
	if(jQuery(obj).attr("checked"))jQuery("#tr_enterremindperiod").show();
}

function onBtnSearchClick(){
	//jQuery("#searchfrm").submit();
}

function onSave()
{
	jQuery("#searchfrm").submit();
}
</script>
</head>
<body>
<%
if(!HrmUserVarify.checkUserRight("OtherSettings:Edit",user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19148,user.getLanguage());
String needfav ="1";
String needhelp ="";

ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
String entervalid=settings.getEntervalid();
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("OtherSettings:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<FORM style="MARGIN-TOP: 0px" name="searchfrm" id="searchfrm" smethod=post action="HrmSettingOperation.jsp">
	<input name="cmd" type="hidden" value="enterSave">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("OtherSettings:Edit", user)){ %>
				<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
		</tr>
	</table>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(32164,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></wea:item>
			<wea:item><input type="checkbox"  tzCheckbox="true"  id="entervalid" name="entervalid" <%=entervalid.equals("1")?"checked":"" %> value="1" onchange="isAlarm(this)" ></wea:item>
		</wea:group>
	</wea:layout>
	</FORM>
</body>
</html>
