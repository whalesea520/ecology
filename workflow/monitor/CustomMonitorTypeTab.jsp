<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowMonitor:All",user)) 
{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String typename = Util.null2String(request.getParameter("typename"));

String inputt1 = Util.null2String(request.getParameter("inputt1"));
String inputt2 = Util.null2String(request.getParameter("inputt2"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = ""+SystemEnv.getHtmlLabelName(2239,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:newDialog(2,0),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deltype(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<TABLE class=Shadow>
	<tr>
		<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top" onclick="newDialog(2,0)"/>			
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="deltype()"/>
			<input type="text" class="searchInput" name="flowTitle"  value='<%=inputt1 %>' onchange="reSetInputt1()" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id="formSearchg" name="formSearchg" method="post" action="/workflow/monitor/CustomMonitorTypeTab.jsp">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_MONITOR_CUSTOMMONITORTYPETAB %>"/>
<wea:layout type="fourCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text name="inputt1" class=inputstyle  value="<%=inputt1 %>"/>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15521,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text name="inputt2" class=inputstyle  value="<%=inputt2 %>"/>
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit();"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>

</form>
</div>
<%

String sqlWhere = "";

if(!"".equals(inputt1) ){
	sqlWhere += " where typename like '%"+inputt1+"%' ";
}

if(!"".equals(inputt2)){
    //QC135261 修改只输入类型描述无法查询到数据的问题
    if("".equals(sqlWhere)){
        sqlWhere += " where typedesc like '%"+inputt2+"%' ";
    }else{
        sqlWhere += " and typedesc like '%"+inputt2+"%' ";
    }
}


String orderby =" typeorder,id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,typename,typedesc,typeorder ";
String fromSql  = " Workflow_MonitorType ";

tableString =   " <table instanceid=\"WorkflowMonitorTypeTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_MONITOR_CUSTOMMONITORTYPETAB,user.getUID())+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.workflow.monitor.Monitor.getCanDeleMonitorType\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(15520,user.getLanguage())+"\" column=\"typename\" otherpara=\"column:id\" orderkey=\"typename\" transmethod=\"weaver.workflow.monitor.Monitor.getLinkMonitorType\"/>"+
                "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(15521,user.getLanguage())+"\" column=\"typedesc\" orderkey=\"typedesc\" />"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"typeorder\" orderkey=\"typeorder\"/>"+
                "       </head>"+
                "		<operates>"+
                "		<popedom column=\"id\" transmethod=\"weaver.workflow.monitor.Monitor.getCanDeleMonitorTypeList\"></popedom> "+
                "		<operate href=\"javascript:newDialog(1);\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+ 
				"		</operates>"+  
                " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
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

function doSubmit() {
	document.formSearchg.submit();
}

function reSetInputt1(){
	//onchange="reSetInputt1()"
	var typename=$("input[name='flowTitle']",parent.document).val();
	$("input[name='inputt1']").val(typename);
}

function onBtnSearchClick(){
	doSubmit();
}

function newDialog(type,id){
	var title = "";
	var url = "";
	if(type==1){
		title = "<%=SystemEnv.getHtmlLabelNames("93,2239",user.getLanguage())%>";
		url="/workflow/monitor/MonitorTypeEdit.jsp?dialog=1&id="+id;
	}else{
		title = "<%=SystemEnv.getHtmlLabelNames("83981,2239",user.getLanguage())%>";
		url="/workflow/monitor/MonitorTypeAdd.jsp?dialog=1";
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 250;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL =url;
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
	if(typeids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		return false;
	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/monitor/MonitorTypeOperation.jsp?operation=deletes&typeids="+typeids;
				}, function () {}, 320, 90,true);
}

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			window.location="/workflow/monitor/MonitorTypeOperation.jsp?operation=delete&id="+id;
	}, function () {}, 320, 90,true);		
}
</script>
</HTML>
