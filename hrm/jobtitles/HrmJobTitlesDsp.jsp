<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String id = Util.null2String(request.getParameter("id"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";

String jobtitlemark = Util.toScreen(JobTitlesComInfo.getJobTitlesmark(""+id),user.getLanguage());
String jobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(""+id),user.getLanguage());
String jobactivityid = Util.toScreen(JobTitlesComInfo.getJobactivityid(""+id),user.getLanguage());
String jobresponsibility = Util.toScreen(JobTitlesComInfo.getJobresponsibility(""+id),user.getLanguage());
String jobcompetency = Util.toScreen(JobTitlesComInfo.getJobcompetency(""+id),user.getLanguage());
String jobtitleremark = Util.toScreen(JobTitlesComInfo.getJobtitleremark(""+id),user.getLanguage());
String jobdoc = Util.toScreen(JobTitlesComInfo.getJobdoc(""+id),user.getLanguage());

boolean canDel = true;
String sql = "select count(id) from HrmResource where jobtitle = "+id;
rs.executeSql(sql);
rs.next();	
if(rs.getInt(1)>0){
	canDel=false;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmSearch").submit();
}

function doDel(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"JobTitlesOperation.jsp?isdialog=1&operation=delete&id="+id,
			type:"post",
			async:true,
			complete:function(xhr,status){
				//刷新页面
				window.parent.parent.reLoad();
			}
		});
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesEdit&id="+id;
	}
	dialog.Width = 700;
	dialog.Height = 593;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=26 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=26")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
jQuery(document).ready(function(){
	parent.setTabObjName("<%=jobtitlename %>");
})

function reLoadTree(){
 window.parent.parent.reLoad();
}
</script>
</head>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:openDialog("+id+");,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
 }

if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)&&canDel){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel("+id+");,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
}

if(HrmUserVarify.checkUserRight("HrmJobTitles:Log", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+id+");,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="frmSearch" name="frmSearch" action="HrmJobTitlesDsp.jsp" method="post">
<input name="id" type="hidden" value="<%=id %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)){%>
		<input type=button class="e8_btn_top" onclick="openDialog(<%=id %>);" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
		<%}if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)&&canDel){%>
		<input type=button class="e8_btn_top" onclick="doDel(<%=id %>);" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
		<%} %>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("6086,399",user.getLanguage())%></wea:item>
		<wea:item><%=jobtitlemark%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("6086,15767",user.getLanguage())%></wea:item>
		<wea:item><%=jobtitlename%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15855,user.getLanguage())%></wea:item>
		<wea:item><%=JobActivitiesComInfo.getJobActivitiesname(jobactivityid)%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toHtml(jobresponsibility)%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
		<wea:item><a onclick="" href="/docs/docs/DocDsp.jsp?id=<%=jobdoc %>" target="_blank"><%=DocComInfo.getDocname(jobdoc)%></a></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(895,user.getLanguage())%></wea:item>
	  <wea:item><%=jobcompetency%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
	  <wea:item><%=jobtitleremark%></wea:item>
	</wea:group>
</wea:layout>
</form>
</BODY>
</HTML>
