
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<style type="text/css">
.versioninfo{
	color:#FF0000;
}
</style>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=10;
String searchName=Util.null2String(request.getParameter("searchName"));
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doCrate(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
<tr>
	<td></td>
	<td class="rightSearchSpan">
	<%//if(subCompanyId!=0){
		//if(operatelevel>0){%>
			<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:doCrate()"/>				
		<%//}%>
	<%//}%>
		<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="javascript:doAdd()"/>
		<input type="text" class="searchInput" value="<%=searchName%>" id="flowTitle" name="flowTitle"/>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
	</td>
</tr>
<form id="frmmain" NAME="frmmain" STYLE="margin-bottom:0" action="/cpt/car/UseCarWorkflowSetIframe.jsp" method=post>
	<input type="hidden" id="searchName" name="searchName" value="<%=searchName%>" />
</form>
</table>
<%
	String backfields = " id,workflowid,workflowname,formid,formname,isuse ";
	String fromSql = " from (select s.id,s.workflowid,s.workflowname,s.formid,info.labelname as formname,isuse from (select t.id,t.workflowid,workflowname,formid,namelabel,isuse from (select bc.id,b.id as workflowid,b.workflowname,b.formid,isuse " + 
	                 "  from workflow_base b left join carbasic bc on b.id=bc.workflowid " + 
			         "   where b.formid=163 or (b.formid!=163 and b.id=bc.workflowid)) t left join workflow_bill fb on t.formid=fb.id) s left join htmllabelinfo info on s.namelabel=info.indexid and info.languageid="+user.getLanguage()+") a";
	String sqlWhere = "";
	if (!searchName.equals("")) sqlWhere = " where workflowname like '%" +searchName+ "%'"; 
	String orderby = " workflowname,workflowid ";
	String tableString = "<table instanceid=\"UseCarSetTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
		                 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"workflowid\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
		                 "	 <head>"+
		                 "		<col width=\"33%\"  text=\""+SystemEnv.getHtmlLabelName(18104,user.getLanguage())+"\" column=\"workflowid\"  transmethod=\"weaver.formmode.interfaces.WfToModeTransmethod.getWorkflowName\"  otherpara=\""+user.getLanguage()+"\"/>"+ //流程名称
		                 "		<col width=\"33%\"   text=\""+SystemEnv.getHtmlLabelName(19532,user.getLanguage())+"\" column=\"formname\"/>"+ //表单
		                 "		<col width=\"34%\"   text=\""+SystemEnv.getHtmlLabelName(18624,user.getLanguage())+"\" column=\"isuse\" transmethod=\"weaver.cpt.car.UseCarWorkflowSet.getUsename\"/>"+ //是否启用
		                 "	 </head>";
						 tableString +=	"<operates><popedom otherpara=\"column:isuse\" otherpara2=\"column:formid\" transmethod=\"weaver.cpt.car.UseCarWorkflowSet.getOperate\"></popedom> ";
				         tableString +=	"<operate href=\"javascript:doUse()\" otherpara=\"column:id\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"; //启用
				         tableString +=	"<operate href=\"javascript:doClose()\" otherpara=\"column:id\"  text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"; //禁用
						 tableString +=	"<operate href=\"javascript:doEdit()\" otherpara=\"column:id\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"  index=\"2\"/>"; //编辑
						 tableString +=	"<operate href=\"javascript:doSet()\"  text=\""+SystemEnv.getHtmlLabelName(21954,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"; //流程设置
						 tableString +=	"<operate href=\"javascript:doDel()\" otherpara=\"column:id\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"4\"/>"; //删除
		  tableString += "</operates></table>";
%>
    <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
</BODY>
<script language=javascript>
var diag_vote;
function doDel(wid,id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	Dialog.confirm(
		str, 
		function(){
			document.frmmain.action="UseCarWorkflowSetOperation.jsp?operation=delete&id="+id;
			document.frmmain.submit();
		}, 
		function(){
			return;
		}, 
		200, 
		80
	);
}
function closeDlgARfsh(){
	diag_vote.close();
	doSearchsubmit();
}

function doSearchsubmit(){
	document.frmmain.submit();
}
function onBtnSearchClick(){
	document.frmmain.searchName.value = jQuery("#flowTitle").val();
	document.frmmain.submit();
}
function closeDialog(){
	//diag_vote.close();
	diag_vote.close();
}
function doCrate(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(128244,user.getLanguage())%>";
	diag_vote.URL = "/cpt/car/UseCarWorkflowSetCreateTab.jsp?dialog=1";
	diag_vote.show();
}
function doAdd(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(128245,user.getLanguage())%>";
	diag_vote.URL = "/cpt/car/UseCarWorkflowSetAddTab.jsp?dialog=1";
	diag_vote.show();
}
function doUse(wid,id){
	document.frmmain.action="UseCarWorkflowSetOperation.jsp?operation=use&id="+id;
	document.frmmain.submit();
}
function doClose(wid,id){
	document.frmmain.action="UseCarWorkflowSetOperation.jsp?operation=close&id="+id+"&workflowid="+wid;
	document.frmmain.submit();
}
function doEdit(wid,id){
    url = "/cpt/car/UseCarWorkflowSetAddTab.jsp?dialog=1&id="+id;
	showDialog(url);
}
function doSet(id){
	window.parent.location = "/workflow/workflow/addwf.jsp?ajax=1&src=editwf&wfid="+id+"&isTemplate=0";
}
function showDialog(url){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+""+SystemEnv.getHtmlLabelName(17630,user.getLanguage())%>";
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}
function openWorkflowEditPage(workflowid){
	var url = "/workflow/workflow/addwf.jsp?src=editwf&wfid="+workflowid+"&isTemplate=0";
	openFullWindowHaveBar(url);
}
</script>
</HTML>
