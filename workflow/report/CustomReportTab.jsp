<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="ReportShare" class="weaver.workflow.report.ReportShare" scope="page" />
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(16532,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17615,user.getLanguage());
String needfav ="1";
String needhelp ="";


String reporttype = Util.null2String(request.getParameter("reporttype"));
String reportname = Util.null2String(request.getParameter("reportname"));


int userid=0;
userid=user.getUID();

//if(userid > 1) {
//    RecordSet.executeSql("select departmentid,seclevel,subcompanyid1 from hrmresource where id="+userid);
//	if(RecordSet.next()) {
//	   ReportShare.SetNewHrmReportShare(""+userid,RecordSet.getString("departmentid"),RecordSet.getString("subcompanyid1"),RecordSet.getString("seclevel"));
//	}	
//}

%>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<!--  -->

<form name="frmSearch" method="post" >
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REPORT_CUSTOMREPORTTAB %>"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" name="flowTitle"  value='<%=reportname %>'/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347 ,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721 ,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="fourCol">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905 ,user.getLanguage())%>'>			  
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></wea:item>
		    <wea:item><input type="text" class="InputStyle" size="40" id="reporttype" name="reporttype" value=""></wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></wea:item>
		    <wea:item><input type="text" class="InputStyle" size="40" id="reportname" name="reportname" value=""></wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit(2);"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>				
</div>	
	</form>

<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>
<%
String allreport = "";
//String sql = "select reportid from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 ";
//System.out.println("sql = "+sql);

//RecordSet.executeSql(sql);

//while(RecordSet.next()) {
//	String tempreportid = Util.null2String(RecordSet.getString(1)) ;
//	allreport += tempreportid+",";
//}

allreport = ReportAuthorization.getReportIdByUserId(user);

String  backfields  =  "*"; 
String  fromSql  = " from Workflow_Report";
String sqlWhere = " where 1=1 ";
if(!allreport.equals("")){
	allreport = allreport.substring(0,allreport.length() - 1);
}
sqlWhere +="  and (" + Util.getSubINClause(allreport, "id", "IN") + ") " ;

if(!"".equals(reportname)){
	sqlWhere += " and reportname like '%"+reportname+"%' ";
}
if(!"".equals(reporttype)){
	sqlWhere += " and reporttype in (select id from Workflow_ReportType where typename like '%"+reporttype+"%' ) ";
}

String orderby =" reporttype ";
String tableString = "";
int perpage=10;                                 

tableString =   " <table instanceid=\"workflowReportTypeTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REPORT_CUSTOMREPORTTAB,user.getUID())+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.workflow.report.ReportTypeComInfo.getCanDelType\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                //"           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15517,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\"column:id\" transmethod=\"weaver.workflow.report.ReportTypeComInfo.getLinkType\" />"+
                //"           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(15434,user.getLanguage())+"\" column=\"typename\"  orderkey=\"typename\" />"+
                "             <col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15517,user.getLanguage())+"\" column=\"reportname\" orderkey=\"reportname\" transmethod=\"weaver.splitepage.transform.SptmForWorkFlowReport.getEditReportName\" otherpara=\"column:id\" />"+
                "             <col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15434,user.getLanguage())+"\"  column=\"reporttype\" orderkey=\"reporttype\" transmethod=\"weaver.splitepage.transform.SptmForWorkFlowReport.getReportType\" otherpara=\""+user.getLanguage()+"\" />"+          
                
                //"           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"typedesc\" orderkey=\"typedesc\" />"+
                //"           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"typeorder\" orderkey=\"typeorder\"/>"+
                "       </head>"+
                //"		<operates>"+
                //"		<popedom column=\"id\" transmethod=\"weaver.workflow.report.ReportTypeComInfo.getCanDelTypeList\"></popedom> "+
                //"		<operate href=\"javascript:newDialog(1);\" text=\""+"编辑"+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
				//"		<operate href=\"javascript:onDel();\" text=\""+"删除"+"\" target=\"_self\" index=\"1\"/>"+
				//"		</operates>"+                
                " </table>";
%>

<TABLE width="100%"  cellspacing=0>
    <tr>
        <td valign="top" >  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>


	<!--  -->
  </body>
  <script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});

function doSubmit(type) {
	if(type == "1"){
		var typename=$("input[name='flowTitle']",parent.document).val();
		$("input[name='reportname']").val(typename);
	}
	document.frmSearch.submit();
}

function editDialog(reportwfid,reportname){
	/*
	var url = "/workflow/report/ReportConditionTab.jsp?id="+reportwfid;
	window.parent.location=url;
	*/
	jQuery("#e8_navtab span", parent.window.document).html(reportname);
    url = "/workflow/report/ReportCondition.jsp?id=" + reportwfid;
    window.location=url;
}

function onBtnSearchClick(){
	doSubmit(1);
}	
</script>
</html>
