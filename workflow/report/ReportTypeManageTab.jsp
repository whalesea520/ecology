<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
boolean isedit = true;
//if(user.getUID()!=1){
	//isedit = false;
//}

String typename1 = Util.null2String(request.getParameter("typename1"));
String typedesc2 = Util.null2String(request.getParameter("typedesc2"));
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15519,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isedit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:newDialog(2,0),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE class=Shadow>
		<tr>
		<td valign="top">
<form name="frmSearch" method="post" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    <%if(isedit){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%>" class="e8_btn_top" onclick="newDialog(2,0)"/>		    
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>"  class="e8_btn_top" onclick="deltype()"/>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle"  value='<%=typename1 %>'/>
			<input type="hidden" name=typename  value='<%=typename1 %>'>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="fourCol">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%></wea:item>
		    <wea:item><input type="text" class="InputStyle" size="40" id="typename1" name="typename1" value=""></wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(15521,user.getLanguage())%></wea:item>
		    <wea:item><input type="text" class="InputStyle" size="40" id="typedesc2" name="typedesc2" value=""></wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>"/> 
	    		<span class="e8_sep_line">|</span>
	    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>"/>
	    		<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>				
</div>		
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REPORT_REPORTTYPEMANAGETAB%>"/>
</form>

<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>
<%
String sqlWhere = " where 1=1 ";
if(!"".equals(typename1)){
	sqlWhere += " and typename like '%"+typename1+"%' ";
}
if(!"".equals(typedesc2)){
	sqlWhere += " and typedesc like '%"+typedesc2+"%' ";
}
String orderby =" typeorder ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,typename,typedesc,typeorder ";
String fromSql  = " Workflow_ReportType ";

tableString =   " <table instanceid=\"workflowReportTypeTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REPORT_REPORTTYPEMANAGETAB,user.getUID())+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.workflow.report.ReportTypeComInfo.getCanDelType\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" orderkey=\"id\"/>"+
                "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"typename\" otherpara=\"column:id\" orderkey=\"typename\" transmethod=\"weaver.workflow.report.ReportTypeComInfo.getLinkType\"/>"+
                "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"typedesc\" orderkey=\"typedesc\" />"+
                //"           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"typeorder\" orderkey=\"typeorder\"/>"+
                "       </head>"+
                "		<operates>"+
                "		<popedom column=\"id\" transmethod=\"weaver.workflow.report.ReportTypeComInfo.getCanDelTypeList\"></popedom> "+
                "		<operate href=\"javascript:newDialog(1);\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+                
                " </table>";
%>

<TABLE width="100%"  cellspacing=0>
    <tr>
        <td valign="top" >  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
		</td>
		</tr>
		</TABLE>
</BODY>
<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});
function newDialog(type,id){
	var title = "";
	var url = "";
	if(type==1){
		title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(33664,user.getLanguage())%>";
		url="/workflow/report/ReportTypeEdit.jsp?dialog=1&id="+id;
	}else{
		title =  "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(33664,user.getLanguage())%>";
		url="/workflow/report/ReportTypeAdd.jsp?dialog=1";
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 250;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.isIframe=false;
	diag_vote.show();
}

function closeDialog(){
	diag_vote.close();
}

function deltype(){
	var typeids = "";
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))			
			typeids = typeids +$(this).attr("checkboxId")+",";
	});
	if(typeids=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/report/ReportTypeOperation.jsp?operation=reporttypedeletes&typeids="+typeids;
				}, function () {}, 320, 90,true);
}

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/report/ReportTypeOperation.jsp?operation=reporttypedelete&id="+id;
				}, function () {}, 320, 90,true);		
}

function onBtnSearchClick(){
	doSubmit(1);
}	

function doSubmit(type) {
	if(type == "1"){
		var typename=$("input[name='flowTitle']",parent.document).val();
		$("input[name='typename1']").val(typename);
	}
	document.frmSearch.submit();
}
</script>
</HTML>
