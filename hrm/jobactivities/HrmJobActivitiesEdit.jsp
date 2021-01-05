<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String errid = Util.null2String(request.getParameter("errid"));
String jobactivitymark="";
String jobactivityname="";
int joblevelfrom=0;
int joblevelto = 0;
String jobgroupid="";
RecordSet.executeProc("HrmJobActivities_SelectByID",""+id);

if(RecordSet.next()){
	jobactivitymark = Util.toScreenToEdit(RecordSet.getString("jobactivitymark"),user.getLanguage());
	jobactivityname = Util.toScreenToEdit(RecordSet.getString("jobactivityname"),user.getLanguage());
	joblevelfrom = Util.getIntValue(Util.toScreenToEdit(RecordSet.getString("joblevelfrom"),user.getLanguage()));
	joblevelto= Util.getIntValue(Util.toScreenToEdit(RecordSet.getString("joblevelto"),user.getLanguage()),0);
	jobgroupid = Util.toScreenToEdit(RecordSet.getString("jobgroupid"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage())+":"+jobactivityname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
<%if(isclose.equals("1")){%>
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();
<%}%>
</script>
<%if(errid!=null && errid.equals("5")){%>
	<script type="text/javascript">
		alert("<%=SystemEnv.getHtmlLabelName(83502,user.getLanguage()) %>");
	</script>
<%}%>
</head>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Edit", user)){
	canEdit = true;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="JobActivitiesOperation.jsp" method=post>

<%
String isdisable = "";
if(!canEdit)
	isdisable = " disabled";
%>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) + SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="jobactivitymarkspan" required="true" value='<%=jobactivitymark%>'></wea:required>
			<%if(canEdit){%>
      <INPUT class=inputstyle type=text name="jobactivitymark" value="<%=jobactivitymark%>" onchange='checkinput("jobactivitymark","jobactivitymarkspan")'>
      <%}else{%><%=jobactivitymark%><%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) + SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="jobactivitynamespan"  required="true" value='<%=jobactivitymark%>'>
			<%if(canEdit){%><INPUT class=inputstyle type=text name="jobactivityname"  value="<%=jobactivityname%>" onchange='checkinput("jobactivityname","jobactivitynamespan")'>
      <%}else{%><%=jobactivityname%><%}%>
      </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(canEdit){%>
				<brow:browser viewType="0" id="jobgroupid"  name="jobgroupid" browserValue='<%=jobgroupid %>' 
         browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobgroups/JobGroupsBrowser.jsp?selectedids="
         hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
         completeUrl="/data.jsp?type=jobgroups" width="120px"
         hasAdd="true" addUrl="/hrm/jobgroups/HrmJobGroupsAdd.jsp"
         browserSpanValue='<%=JobGroupsComInfo.getJobGroupsname(jobgroupid)%>'></brow:browser>
         <%}else{ %><%=JobGroupsComInfo.getJobGroupsname(jobgroupid)%><%} %>
		</wea:item>
	</wea:group>
</wea:layout>
   <input class=inputstyle type="hidden" name=operation>
   <input class=inputstyle type="hidden" name=id value=<%=id%>>
 </form>
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

sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		frmMain.docid.value=id(0)&""
		docidname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub

</script>
 <script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'jobactivitymark,jobactivityname,jobgroupid')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
</BODY></HTML>
