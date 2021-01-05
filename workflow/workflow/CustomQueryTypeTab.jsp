<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23799,user.getLanguage());
String needfav ="1";
String needhelp ="";


String shortName = Util.null2String(request.getParameter("shortName"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javaScript:newDialog(2,0),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javaScript:deltype(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE class=Shadow>
<tr>
<td valign="top">
<form name="frmSearch" method="post" action="CustomQueryTypeTab.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top" onclick="newDialog(2,0)"/>			
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="deltype()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=shortName%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
<wea:layout type="fourCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage()) %>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%></wea:item>
	    <wea:item><input type="text" name="shortName" class="inputStyle" value='<%=shortName%>'></wea:item>
    </wea:group>
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="e8_btn_submit" type="submit" name="submit" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
    		<input class="e8_btn_cancel" type="button" name="reset" onclick="onReset();" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_CUSTOMQUERYTYPETAB %>"/>
</form>
<%
String sqlWhere = "";

if(!"".equals(shortName)){
	sqlWhere += " where typename like '%"+shortName+"%' ";
}
String orderby =" showorder,typename ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,typename,typenamemark,showorder ";
String fromSql  = " workflow_customQuerytype ";
tableString =   " <table instanceid=\"workflowcustomQuerytypeTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_CUSTOMQUERYTYPETAB,user.getUID())+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.workflow.workflow.CustomQueryManager.getCanDele\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15520,user.getLanguage())+"\" column=\"typename\" otherpara=\"column:id+true\" orderkey=\"typename\" transmethod=\"weaver.workflow.workflow.CustomQueryManager.getCustomQueryLink\"/>"+
                "           <col width=\"60%\"  text=\""+SystemEnv.getHtmlLabelName(15521,user.getLanguage())+"\" column=\"typenamemark\" orderkey=\"typenamemark\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\" />"+
                "       </head>"+
                "		<operates>"+
                "		<popedom column=\"id\" transmethod=\"weaver.workflow.workflow.CustomQueryManager.getCanDeleList\"></popedom> "+
                "		<operate href=\"javascript:newDialog(1);\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
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
<script type="text/javascript">
    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function donewQueryType(){
        enableAllmenu();
        location.href="/workflow/workflow/CustomQueryTypeAdd.jsp";        
    }
</script>

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
		title = "<%=SystemEnv.getHtmlLabelName(125098,user.getLanguage())%>";
		url="/workflow/workflow/CustomQueryTypeEdit.jsp?dialog=1&id="+id;
	}else{
		title = "<%=SystemEnv.getHtmlLabelName(125099,user.getLanguage())%>";
		url="/workflow/workflow/CustomQueryTypeAdd.jsp?dialog=1";
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 300;
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
						window.location="/workflow/workflow/CustomQueryTypeOperation.jsp?operation=querytypedeletes&typeids="+typeids;
				}, function () {}, 320, 90,true);
}

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			window.location="/workflow/workflow/CustomQueryTypeOperation.jsp?operation=querytypedelete&id="+id;
	}, function () {}, 320, 90,true);
}

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	try{
		typename = encodeURI(typename);
	}catch(e){
		if(window.console)console.log(e)
	 }
	$("input[name='shortName']").val(typename);
	window.location="/workflow/workflow/CustomQueryTypeTab.jsp?shortName="+typename;
}

function onReset() {
	jQuery('input[name="flowTitle"]', parent.document).val('');
	jQuery('input[name="shortName"]').val('');
}
</script>
</HTML>
