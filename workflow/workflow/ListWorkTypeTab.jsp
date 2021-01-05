<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
    String typename = Util.null2String(request.getParameter("typename"));
    String typedesc = Util.null2String(request.getParameter("typedesc"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16579,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body style="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:newDialog(2,0),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deltype(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE class=Shadow>
<tr>
<td valign="top">
<form name="frmSearch" method="post" id="frmSearch" >
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage()) %>" class="e8_btn_top"  onclick="newDialog(2,0)"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="deltype()"/>
				<input type="text" class="searchInput" name="flowTitle" value="<%=typename %>" />
				&nbsp;&nbsp;&nbsp;
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>		
	<!-- bpf start 2013-10-29 -->
	<div class="advancedSearchDiv" id="advancedSearchDiv">
		<wea:layout type="fourCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage()) %>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			    <wea:item><input type=text name=typename class=Inputstyle value='<%=typename %>'></wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		    	<wea:item><input type=text name=typedesc class=Inputstyle value='<%=typedesc %>'></wea:item>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage()) %>"/>
		    		<input class="e8_btn_cancel" type="reset"  name="reset"   value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage()) %>"/>
		    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage()) %>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
	</div>
</form>		
<%
String sqlWhere = "";

if(!"".equals(typename)){
	if(sqlWhere.equals("")){
		sqlWhere += " where typename like '%"+typename+"%' ";
	}else{
		sqlWhere += " and typename like '%"+typename+"%' ";
	}
}
if(!"".equals(typedesc)){
	if(sqlWhere.equals("")){
		sqlWhere += " where typedesc like '%"+typedesc+"%' ";
	}else{
		sqlWhere += " and typedesc like '%"+typedesc+"%' ";
	}
}
String orderby =" dsporder ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,typename,typedesc,dsporder ";
String fromSql  = " workflow_type ";

tableString =   " <table instanceid=\"workflowTypeListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_LISTWORKTYPETAB,user.getUID())+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.workflow.workflow.WorkTypeComInfo.getCanDelType\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"typename\" otherpara=\"column:id\" orderkey=\"typename\" transmethod=\"weaver.workflow.workflow.WorkTypeComInfo.getLinkType\"/>"+
                "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"typedesc\" orderkey=\"typedesc\" />"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\"/>"+
                "       </head>"+
                "		<operates>"+
                "		<popedom column=\"id\" transmethod=\"weaver.workflow.workflow.WorkTypeComInfo.getCanDelTypeList\"></popedom> "+
                "		<operate href=\"javascript:newDialog(1);\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+                  
                " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
            <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_LISTWORKTYPETAB %>"/>
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
	//diag_vote = new Dialog();
	var title = "";
	var url = "";
	if(type==1){
		title = "<%=SystemEnv.getHtmlLabelName(125043,user.getLanguage())%>";
		url="/workflow/workflow/EditWorkType.jsp?dialog=1&id="+id;
	}else{
		title = "<%=SystemEnv.getHtmlLabelName(125044,user.getLanguage())%>";
		url="/workflow/workflow/AddWorkType.jsp?dialog=1";
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
	if(typeids=="") {
	    //QC166503
		//top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34095, user.getLanguage())%>");
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83066, user.getLanguage())%>");
		return ;
	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/workflow/WorkTypeOperation.jsp?method=deles&typeids="+typeids;
				}, function () {}, 320, 90,true);
}	

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/workflow/WorkTypeOperation.jsp?method=delete&id="+id;
				}, function () {}, 320, 90,true);		
}	

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	try{
		typename = encodeURI(typename);
	}catch(e){
		if(window.console)console.log(e)
	 }
	$("input[name='typename']").val(typename);
	//$("#frmSearch").submit();
	window.location="/workflow/workflow/ListWorkTypeTab.jsp?typename="+typename;
}

</script>
</HTML>
