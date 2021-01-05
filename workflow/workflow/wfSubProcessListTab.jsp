<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="session"/>
<%
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String triwfid = Util.null2String(request.getParameter("subwfscope"));
String titlename = SystemEnv.getHtmlLabelName(19350,user.getLanguage());

//判断是相同子流程还是不同子流程
String isTriDiffWorkflow = "";
RecordSet.executeSql("select formId,isBill,isTriDiffWorkflow from workflow_base where id="+wfid);
if(RecordSet.next()){
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
}
if(isTriDiffWorkflow.equals("")){
	isTriDiffWorkflow="0";
}

String backfields = " 1 as ranking__,wb.workflowname,vws.formname,wt.typename ";
String sqlfrom = "";
String sqlwhere = " where 1 = 1 ";

String sqlorderby = " ws.id ";
//相同子流程 Workflow_SubwfSet
//不同子流程 Workflow_TriDiffWfDiffField
if("0".equals(isTriDiffWorkflow)){
	backfields += " ,ws.subworkflowid ";
	sqlfrom += " Workflow_SubwfSet ws,workflow_base wb,workflow_type wt,view_workflowForm_selectAll vws ";
	sqlwhere +=" and ws.subworkflowid = wb.id and wb.workflowtype = wt.id and wb.formid = vws.id and ws.id in(" + triwfid + ") and ws.mainWorkflowId = " + wfid + " and enable = 1 AND wb.ISBILL = vws.ISOLDORNEW ";
}else{
	backfields += " ,wtd.subworkflowid ";
	sqlfrom += " Workflow_TriDiffWfDiffField ws,Workflow_TriDiffWfSubWf wtd,workflow_base wb,workflow_type wt,view_workflowForm_selectAll vws";
	sqlwhere +=" and wtd.subworkflowid = wb.id and wb.workflowtype = wt.id and wb.formid = vws.id and wtd.triDiffWfDiffFieldId = ws.id and ws.id in(" + triwfid + ") and ws.mainWorkflowId = " + wfid + " and enable = 1 AND wb.ISBILL = vws.ISOLDORNEW ";
}

//快捷查询与高级搜索
String workflowname = Util.null2String(request.getParameter("workflowname"));//子流程名称
String formname = Util.null2String(request.getParameter("formname"));//对应表单
String typeid = Util.null2String(request.getParameter("typeid"));//路径类型

if(!"".equals(workflowname)){
	sqlwhere += " and wb.workflowname like '%" + workflowname + "%' ";
}
if(!"".equals(formname)){
	sqlwhere += " and vws.formname like '%" + formname + "%' ";
}
if(!"".equals(typeid)){
	sqlwhere += " and wt.id = " + typeid + " ";
}
//System.out.println("$$$$$$$$$$$$$$$$$sqlfrom = " + sqlfrom);
//System.out.println("&&&&&&&&&&&&&&&sqlwhere = " + sqlwhere);

%>
<html>
<head>	
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
jQuery(document).ready(function () {
  	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
  	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
  	$("#tabDiv").remove();		
 });
  
function onBtnSearchClick(){
	var workflowname = jQuery("input[name='workflowname1']").val();
	jQuery("input[name='workflowname']").val(workflowname);
	document.SearchForm.submit();
}
	
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent.window);
	dialog =parent.parent.getDialog(parent.window);
}catch(e){}

function onClose(){
	dialog.close();
}

function dataSummary(id,para){
	var subworkflowid = para.split("+")[0];
	var workflowname = para.split("+")[1];
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/wfSubDataAggregation.jsp?wfid=<%=wfid%>&nodeid=<%=nodeid%>&subworkflowid="+subworkflowid+"&workflowname="+workflowname;
	dialog.URL = url;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125343,user.getLanguage())%>";
	dialog.Width = 800;
	dialog.Height = 550;
	dialog.normalDialog = false;
	dialog.Drag = true;
	dialog.show();
}

</script>
</head>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content" style="height: 100%!important;">
<FORM id="SearchForm" name="SearchForm" action="wfSubProcessListTab.jsp" method="post">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_SUBPROCESSLIST%>"/>
<input type="hidden" name="subwfscope" id="subwfscope" value="<%=triwfid%>"/>
<input type="hidden" name="wfid" id="wfid" value="<%=wfid%>"/>
<input type="hidden" name="nodeid" id="nodeid" value="<%=nodeid%>"/>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" name="workflowname1" value="<%=workflowname%>"/>  
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>	
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="fourCol">
	    <wea:group context="<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>">
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19351,user.getLanguage())%></wea:item>
		    <wea:item><input type="text" class="InputStyle" size="40" name="workflowname" value="<%=workflowname%>"></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
		    <wea:item><input type="text" class="InputStyle" size="40" name="formname" value="<%=formname%>"></wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%></wea:item>
		    <wea:item>
		    <%
		    String typename = workTypeComInfo.getWorkTypename(typeid);
		    %>
		    	<brow:browser viewType="0" name="typeid"
							browserValue="<%=typeid %>"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser="true"
							isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
							browserDialogWidth="600px"
							browserSpanValue="<%=typename %>">
					</brow:browser>
		    </wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>"/> 
	    		<span class="e8_sep_line">|</span>
	    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
	    		<span class="e8_sep_line">|</span>
	    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>				
</div>	
</FORM>

<%

//String sqlWhere = "";
String tableString = "";

tableString =   " <table instanceid=\"WorkflowMonitorListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_SUBPROCESSLIST,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+sqlfrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"ws.id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"ranking__\"   />"+
                " 			<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(19351,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" otherpara=\"column:subworkflowid\" transmethod=\"weaver.workflow.workflow.WFSubDataAggregation.getWorkflownameLink\" />"+
                " 			<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(15600,user.getLanguage())+"\" column=\"formname\" orderkey=\"formname\"/>"+
                " 			<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(33806,user.getLanguage())+"\" column=\"typename\" orderkey=\"typename\"/>"+
                "       </head>"+
                "		<operates>"+
                //otherpara=\"column:subworkflowid+column:typename\"
                "		<operate href=\"javascript:dataSummary();\" otherpara=\"column:subworkflowid+column:workflowname\" text=\""+SystemEnv.getHtmlLabelName(125343,user.getLanguage())+"\"  target=\"_self\" index=\"0\"/>"+
				"		</operates>"+  
                " </table>";

%>
<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
</TABLE>

</div>

</body>
</html>