
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
	if(jQuery("#contractvalid").attr("checked")){
		showEle("tr_contractremindperiod");
	}else{
		hideEle("tr_contractremindperiod");
	}
	
});

function isAlarm(obj)
{
	hideEle("tr_contractremindperiod");
	if(jQuery(obj).attr("checked")){
		showEle("tr_contractremindperiod");
	}
	
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
String titlename = SystemEnv.getHtmlLabelName(19149,user.getLanguage());
String needfav ="1";
String needhelp ="";

ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
String contractvalid=settings.getContractvalid();
String contractremindperiod=settings.getContractremindperiod();
//合同到期后自动将人员置为“无效”状态 :开关打开，就是合同到期后，将人员状态置为无效；关闭就是，合同到期后不改变人员状态默认关闭！
String statusWithContract=settings.getStatusWithContract();

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
	<input name="cmd" type="hidden" value="contractSave">
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
			<wea:item><%=SystemEnv.getHtmlLabelNames("32164,26928",user.getLanguage())%></wea:item>
			<wea:item><input type="checkbox"  tzCheckbox="true"  id="contractvalid" name="contractvalid" <%=contractvalid.equals("1")?"checked":"" %> value="1" onclick="isAlarm(this)" ></wea:item>
			<wea:item attributes="{'samePair':'tr_contractremindperiod'}"><%=SystemEnv.getHtmlLabelName(15792,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':'tr_contractremindperiod'}"><input type="text" name="contractremindperiod" value='<%=contractremindperiod%>' onBlur="checknumber1('contractremindperiod')" onKeyPress="ItemCount_KeyPress()""></wea:item>
			
			<wea:item attributes="{'samePair':'tr_statusWithContract'}"><%=SystemEnv.getHtmlLabelName(128837,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':'tr_statusWithContract'}">
			<input type="checkbox"  tzCheckbox="true"  id="statusWithContract" name="statusWithContract" <%=statusWithContract.equals("1")?"checked":"" %> value="1"  >
			</wea:item>
		</wea:group>
	</wea:layout>
	</FORM>
</body>
</html>
