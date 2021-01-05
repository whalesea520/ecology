<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobTitlesTempletComInfo" class="weaver.hrm.job.JobTitlesTempletComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

//如果不是来自HrmTab页，增加页面跳转
if(!Util.null2String(request.getParameter("fromHrmDialogTab")).equals("1")){
	String url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesEdit&id="+id;
	response.sendRedirect(url.toString()) ;
	return;
}

/*Added by Charoes Huang, June 4,2004*/
String errorMsg ="";
if("1".equals(Util.null2String(request.getParameter("message")))){
	errorMsg = SystemEnv.getHtmlLabelName(17426,user.getLanguage());
}

String jobtitlemark = Util.toScreenToEdit(JobTitlesTempletComInfo.getJobTitlesmark(""+id),user.getLanguage());
String jobtitlename = Util.toScreenToEdit(JobTitlesTempletComInfo.getJobTitlesname(""+id),user.getLanguage());
String jobactivityid = Util.toScreenToEdit(JobTitlesTempletComInfo.getJobactivityid(""+id),user.getLanguage());
String jobresponsibility = Util.toScreenToEdit(JobTitlesTempletComInfo.getJobresponsibility(""+id),user.getLanguage());
String jobcompetency = Util.toScreenToEdit(JobTitlesTempletComInfo.getJobcompetency(""+id),user.getLanguage());
String jobtitleremark = Util.toScreenToEdit(JobTitlesTempletComInfo.getJobtitleremark(""+id),user.getLanguage());
String jobdoc = Util.toScreenToEdit(JobTitlesTempletComInfo.getJobdoc(""+id),user.getLanguage());

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage())+":"+jobtitlename;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>" == "1"){
	parentWin.onBtnSearchClick();
	parentWin.parent.parent.refreshTreeMain(<%=id%>,<%=jobactivityid%>);
	parentWin.closeDialog();
}

function doDel(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			jQuery.ajax({
				url:"JobTitlesTempletOperation.jsp?isdialog=1&operation=delete&id="+id,
				type:"post",
				async:true,
				complete:function(xhr,status){
					//关闭刷新页面
					parentWin.parent.parent.refreshTreeMain(<%=id%>,<%=jobactivityid%>);
					parentWin.onBtnSearchClick();
					parentWin.closeDialog();
				}
			});
	});
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=157 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=157")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)){
	canEdit = true;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel("+id+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmJobTitles:Log", user)){
  RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+id+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%
		if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
		<%}if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel(<%=id %>)">
		<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="JobTitlesTempletOperation.jsp" method=post>
<%
String isdisable = "";
if(!canEdit)isdisable = " disabled";
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%if(!"".equals(errorMsg)){%>
<DIV>
<font color=red size=2>
				<%=errorMsg%>
</font>
</DIV>
<%}%>
		<wea:layout>
			<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
				<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="jobtitlemarkspan">
					<%if(canEdit){%><INPUT class=inputstyle type=text name="jobtitlemark" value="<%=jobtitlemark%>" onchange='checkinput("jobtitlemark","jobtitlemarkspan")'>
       		<%}else{%><%=jobtitlemark%><%}%>
					</wea:required>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="jobtitlenamespan">
						<%if(canEdit){%><INPUT class=inputstyle type=text size=30 name="jobtitlename"  value="<%=jobtitlename%>" onchange='checkinput("jobtitlename","jobtitlenamespan")'>
        		<%}else{%><%=jobtitlename%><%}%>
					</wea:required>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(canEdit){%>
         <brow:browser viewType="0" name="jobactivityid" browserValue="<%=jobactivityid %>" 
            browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobactivities/JobActivitiesBrowser.jsp?selectedids="
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
            completeUrl="/data.jsp?type=jobactivity" linkUrl="/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=" width="300px" hasAdd="true"
            addUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobactivities/HrmJobActivitiesAdd.jsp?isdialog=1&isBrowser=1" dialogWidth="500" dialogHeight="300"
            browserSpanValue="<%=JobActivitiesComInfo.getJobActivitiesname(jobactivityid)%>"></brow:browser>

          <%}else{%><%=JobActivitiesComInfo.getJobActivitiesname(jobactivityid)%><%}%>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(canEdit){%>
		      <textarea class=inputstyle style="width: 95%" rows=4 name="jobresponsibility" value="<%=jobresponsibility%>"><%=jobresponsibility%></textarea>
		      <%}else{%><%=jobresponsibility%><%}%>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(canEdit){%>
					 <brow:browser viewType="0"  name="jobdoc" browserValue="<%=jobdoc %>" 
            browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            browserSpanValue="<%=DocComInfo.getDocname(jobdoc)%>"
            completeUrl="/data.jsp?type=9"></brow:browser>
	      	<%}else{%>
	      		 <SPAN id=departmentspan> <%=DocComInfo.getDocname(jobdoc)%></SPAN> 
	          <INPUT class=inputstyle id=jobdoc type=hidden name=jobdoc value="<%=jobdoc%>"> 
	      	<%} %>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(895,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(canEdit){%><textarea class=inputstyle style="width: 95%" rows=4 name="jobcompetency" value="<%=jobcompetency%>"><%=jobcompetency%></textarea>
      		<%}else{%><%=jobcompetency%><%}%>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(canEdit){%>
          <TEXTAREA class=inputstyle name=jobtitleremark rows=8 style="width: 95%" <%=isdisable%>><%=jobtitleremark%></TEXTAREA>
          <%}else{%><%=jobtitleremark%><%}%>
				</wea:item>
			</wea:group>
		</wea:layout>
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type="hidden" name=id value=<%=id%>>
</FORM></div>
 <%if("1".equals(isDialog)){ %>
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
 function onSave(){
	if(check_form(document.frmMain,'jobtitlemark,jobtitlename,jobactivityid')){
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
jQuery(document).ready(function(){
	checkinput("jobtitlemark","jobtitlemarkspan");
	checkinput("jobtitlename","jobtitlenamespan");
});
 </script>
</BODY>
</HTML>

