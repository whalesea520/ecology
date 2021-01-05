
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.general.GCONST,
                 weaver.hrm.settings.ChgPasswdReminder,
				 weaver.hrm.common.*,
                 weaver.hrm.settings.RemindSettings,java.io.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%

if(!HrmUserVarify.checkUserRight("Car:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</script>
</head>
<%


String imagefilename = "/images/hdSystem_wev8.gif";

String titlename = SystemEnv.getHtmlLabelName(31811,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

int isremind = 0; 
int remindtype = 0; 
String sql = "select isremind,remindtype from mode_carremindset";
RecordSet.execute(sql);
if(RecordSet.next()){
	isremind = RecordSet.getInt("isremind");
	remindtype = RecordSet.getInt("remindtype");
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(false) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*密码规则(),密码变更提醒,强制修改密码,密码锁定,重复登录,网段策略,USB加密保护	,动态密码保护,登录验证码*/		
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="divContent">
<FORM id=frmMain name=frmMain method=post action="CarSettingOperation.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSubmit();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<input name="operation" type="hidden" value="saveset">
	<wea:layout type="2col" attributes="{'cws':'30%,70%','expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(128287,user.getLanguage())+SystemEnv.getHtmlLabelName(33508,user.getLanguage())%>' attributes="{'samePair':'sameDefaultResult'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(128287,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle id="isremind" name="isremind" value="1" <% if(1==isremind) {%>checked<%}%> >
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(128288,user.getLanguage()) %></wea:item>
		  <wea:item>
		  		<select class=inputstyle  name="remindtype" id="remindtype" > 	
		  			<option value="0" <% if(0==remindtype) {%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(128289,user.getLanguage()) %></option>
		  			<option value="1" <% if(1==remindtype) {%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(128290,user.getLanguage()) %></option>
		  		</select>
		  </wea:item>
		</wea:group>
		</wea:layout>
  </FORM>
</div>
</BODY>
<script language="javascript">
jQuery(document).ready(function(){
});

function onSubmit() {
	frmMain.submit();
}
 
</script>
</HTML>
