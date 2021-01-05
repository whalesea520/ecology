<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%
if(!HrmUserVarify.checkUserRight("HrmJobGroupsAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String isBrowser = Util.null2String(request.getParameter("isBrowser"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = Util.null2String(request.getParameter("id"));
String name = "";
if(id.length()>0)name = JobGroupsComInfo.getJobGroupsname(id);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>" == "1"){
	if("<%=isBrowser%>" == "1"){
		window.parent.returnValue={"id":"<%=id%>","name":"<%=name%>"};
		window.parent.close();
	}else{
		//parentWin.leftTreeReload();
		//parentWin.onBtnSearchClickById('<%=id%>');
		parentWin.closeDialog();
	}
}
</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(805,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<FORM id=weaver name=frmMain action="JobGroupsOperation.jsp" method=post >
<input class=inputstyle type="hidden" name=operation value=add>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item>
	    <INPUT class=inputstyle type=text name="jobgroupname" id="jobgroupname" onchange='checkinput("jobgroupname","jobgroupmarkimage")'>
	    <SPAN id=jobgroupmarkimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=text name=jobgroupremark ></wea:item>
</wea:group>
</wea:layout>
 </form>
  <%if("1".equals(isDialog)){ %>
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
	<%} %>
<script language=javascript>

function checkNameValid(){
	var a = jQuery("#jobgroupname").val();
	if(a.indexOf("<") != -1 || a.indexOf(">") != -1){ 
    	alert('<%=SystemEnv.getHtmlLabelName(83504,user.getLanguage()) %>'); 
    	return false;
	} 
	return true;
}
function submitData() {
	if(checkNameValid()){
		 if(check_form(document.frmMain,'jobgroupmark,jobgroupname')){
		 	document.frmMain.submit();
		}
	}
}
</script>

</BODY>
</HTML>
