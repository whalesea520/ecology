<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%
if(!HrmUserVarify.checkUserRight("HrmJobGroupsAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String isclose = Util.null2String(request.getParameter("isclose"));
String id = Util.null2String(request.getParameter("id"));
String name = "";
if(id.length()>0)name = JobGroupsComInfo.getJobGroupsname(id);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
try{
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("805",user.getLanguage())%>");
}catch(e){
	if(window.console)console.log(e+"-->HrmJobGroupAddBrowser.jsp");
}
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
<%if(isclose.equals("1")){%>
	var returnjson={"id":"<%=id%>","name":"<%=name%>"};
	dialog.callback(returnjson);
<%}%>
</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(805,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmMain name=frmMain action="JobGroupsOperation.jsp" method=post>
<input name="isBrowser" type="hidden" value="1">
<input class=inputstyle type="hidden" name=operation value=add>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item>
	    <INPUT class=inputstyle type=text name="jobgroupname" onchange='checkinput("jobgroupname","jobgroupmarkimage")'>
	    <SPAN id=jobgroupmarkimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=text name=jobgroupremark ></wea:item>
</wea:group>
</wea:layout>
 </form>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<script language=javascript>
function submitData() {
 if(check_form(document.frmMain,'jobgroupmark,jobgroupname')){
 		document.frmMain.submit();
 }
}
</script>
</BODY>
</HTML>
