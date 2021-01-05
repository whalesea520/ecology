<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String from = Util.null2String(request.getParameter("from"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isBrowser = Util.null2String(request.getParameter("isBrowser"));
String id = Util.null2String(request.getParameter("id"));
String jobgroupid = Util.null2String(request.getParameter("jobgroupid"));
String msgid = Util.null2String(request.getParameter("msgid"));
String name = "";
String jobgroupname = "";
if(id.length()>0)name = JobActivitiesComInfo.getJobActivitiesname(id);
if(jobgroupid.length()>0)jobgroupname = JobGroupsComInfo.getJobGroupsname(jobgroupid);
%>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	if("<%=isBrowser%>" == "1"){
		var returnjson={"id":"<%=id%>","name":"<%=name%>"};
		dialog.callback(returnjson);
	}else{
		if("<%=from%>"=="jobTitle"){
			parentWin.closeDialog();	
		}
		else{
			parentWin.onBtnSearchClick();
			parentWin.closeDialog();	
		}
	}
}
jQuery(document).ready(function(){
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) %>");
})
</script>
<%if(msgid!=null && msgid.equals("5")){%>
	<script type="text/javascript">
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83502,user.getLanguage()) %>");
	</script>
<%}%>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
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
<FORM id=weaver name=frmMain action="JobActivitiesOperation.jsp" method=post >
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) + SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="jobactivitymarkspan" required="true">
				<INPUT class=inputstyle type=text name="jobactivitymark" onchange='checkinput("jobactivitymark","jobactivitymarkspan")'>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) + SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="jobactivitynamespan" required="true">
				<input class=inputstyle name="jobactivityname" onchange='checkinput("jobactivityname","jobactivitynamespan")'>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></wea:item>
		<wea:item>
				<brow:browser viewType="0"  name="jobgroupid" browserValue='<%=jobgroupid %>' 
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobgroups/JobGroupsBrowser.jsp?selectedids="
        hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2' hasAdd="true"
        addUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobgroups/HrmJobGroupsAddBrowser.jsp?isBrowser=1" dialogWidth="500" dialogHeight="219"
        completeUrl="/data.jsp?type=jobgroups" width="120px" browserSpanValue='<%=JobGroupsComInfo.getJobGroupsname(jobgroupid)%>'
        ></brow:browser>
        <!-- 
        addUrl="/hrm/jobgroups/HrmJobGroupsAdd.jsp?isBrowser=1" hasAdd="true"
         -->
    </wea:item>
	</wea:group>
</wea:layout>  
			<input type="hidden" name=isBrowser value=<%=isBrowser %>>
			<input type="hidden" name=from value=<%=from %>>
			<input type="hidden" name=operation value=add>
</FORM>
 <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
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
 function submitData() {
if(check_form(frmMain,'jobactivitymark,jobactivityname,jobgroupid')){
 frmMain.submit();
}
}
</script>

 <script language=vbs>
 sub onShowJobGroup()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	jobgroupspan.innerHtml = id(1)
	frmMain.jobgroupid.value=id(0)
	else
	jobgroupspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.jobgroupid.value=""
	end if
	end if
end sub
</script>
</BODY></HTML>
