
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<%
String meetingid = Util.null2String(request.getParameter("meetingid"));
RecordSet.executeProc("Meeting_SelectByID",meetingid);
RecordSet.next();
String repeatenddate=RecordSet.getString("repeatenddate");
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/ecology8/request/seachBody_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:saveDate(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="javascript:saveDate()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="zDialog_div_content" style="overflow-x: hidden;">
<FORM id=weaver name=weaver action="/meeting/data/MeetingReOthersOperation.jsp" method=post >
<input type="hidden" name="meetingid" value="<%=meetingid%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		<wea:item>
			<button type="button" class=Calendar onclick="onShowDate(EndDatespan,enddate)"></BUTTON> 
	        <SPAN id=EndDatespan ><%if("".equals(repeatenddate)){ %><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{ %><%=repeatenddate %><%} %></SPAN> 
	        <input class=inputstyle type="hidden" name="enddate" id="enddate" value="<%=repeatenddate%>">
		</wea:item>
	</wea:group>
</wea:layout>

<div style="margin-top:20px;margin-left:30px;color:red;"><%=SystemEnv.getHtmlLabelName(83350, user.getLanguage()).replace("param",repeatenddate)%></div>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
<script language=javascript>
function btn_cancle(){
	 var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.diag_vote.close();
}
jQuery(document).ready(function(){
	resizeDialog(document);
});

function saveDate(){
	if($("#enddate").val() == ""){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(27938,user.getLanguage())%>");
	} 
	if($("#enddate").val() > "<%=repeatenddate %>"){
		Dialog.alert('<%=SystemEnv.getHtmlLabelName(83351,user.getLanguage()).replace("param",repeatenddate)%>');
	} else {
		$.post("/meeting/data/AjaxMeetingOperation.jsp",{method:"stopIntervalMeeting",meetingid:"<%=meetingid%>",enddate:$("#enddate").val()},function(datas){
			var parentWin = parent.parent.getParentWindow(window.parent);
     		parentWin.closeDlgARfsh();
		});
	}
}
</script>
</html>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
