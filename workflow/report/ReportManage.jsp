<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
	<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css" >
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");    	
	return;
}
String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage());
int otype = Util.getIntValue(request.getParameter("otype"),0);
if(otype == 0){
	otype = Util.getIntValue(Util.null2String(session.getAttribute("reportmanage_otype")),0);
}
int subcompanyid = Util.getIntValue(Util.null2String(session.getAttribute("reportmanage_subcompanyid")),0);
String reportname = Util.null2String(request.getParameter("reportname"));
String reportTypeName = "";
if(otype != 0){
	RecordSet.executeSql(" select typename from Workflow_ReportType where id = "+otype);
	if(RecordSet.next()){
		reportTypeName=RecordSet.getString("typename");
	}
}
String reportid = Util.null2String(request.getParameter("reportid"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel = -1;
if(detachable==1){                                                    
	if(subcompanyid>0){
	    operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowReportManage:All", subcompanyid);
	}else{
	    int tempsubcompanyid2[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowReportManage:All",2);
		if(null!=tempsubcompanyid2 && tempsubcompanyid2.length > 0){
		    operatelevel = 2;
		}else{
		    tempsubcompanyid2 = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowReportManage:All",1);
		    if(null!=tempsubcompanyid2 && tempsubcompanyid2.length > 0){
		        operatelevel = 1;
		    }
		}
	}
}else{
    operatelevel = 2;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<div>
<%
if(operatelevel > 0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:newDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id="SearchForm" name="SearchForm" action="ReportManage.jsp" method="post">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REPORT_REPORTMANAGE %>"/>
<TABLE class=Shadow>
		<tr>
		<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		  	<%if(operatelevel > 0){ %>
		  	<input type="button" value="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%>" class="e8_btn_top" onclick="newDialog()"/>
		  	<%} if(operatelevel > 1){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="deltype()"/>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=reportname%>"/>  
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="fourCol">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></wea:item>
		    <wea:item><input type="text" class="InputStyle" size="40" id="reportname" name="reportname" value='<%=reportname%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></wea:item>
		    <wea:item>
		    	<brow:browser name="otype" viewType="0" hasBrowser="true" hasAdd="false"
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/report/ReportTypeBrowser.jsp?rightStr=WorkflowReportManage:All&isedit=1" 
					isMustInput="1" isSingle="true" hasInput="true" completeUrl="/data.jsp?type=reportTypeBrowser"  
					width="50%" browserValue='<%=String.valueOf(otype)%>' browserSpanValue='<%=reportTypeName %>'/>
		    </wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
	    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
	    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>				
</div>		
<table cellspacing=0 > 
  		<tr> <td valign="top">  
  			<%  
  			String  tableString  =  "";  
  			String  backfields  =  "*"; 
  			String  fromSql  = " from Workflow_Report";
  			StringBuffer buffer =  new StringBuffer();
  			buffer.append(" where 1=1 ");
  			//System.out.println("otype = "+otype);
  			if(detachable==1){
  				if(!"".equals(reportid)){
  				  buffer.append(" and id='"+reportid+"' ");
  				}
				if(!"".equals(reportname)){
					buffer.append(" and reportname like '%"+reportname+"%' ");
				}

				if(rs.getDBType().equals("oracle")){
					if(otype>0){
					    buffer.append(" and nvl(reporttype,0) =").append(otype);
					}
					if(subcompanyid>0){
						buffer.append(" and nvl(subcompanyid,0)=").append(subcompanyid);
					}
				}else{
					if(otype>0){
					    buffer.append(" and isnull(reporttype,0) =").append(otype);
					}
					if(subcompanyid>0){
					    buffer.append(" and isnull(subcompanyid,0)=").append(subcompanyid);
					}
				}

				if(user.getUID()!=1){
				    String hasRightSub=subCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowReportManage:All",-1);
					if(StringUtils.isNotBlank(hasRightSub)){
					    buffer.append(" and subcompanyid in(").append(hasRightSub).append(")");
					}else{
					    buffer.append(" and 1=2");
					}
				}
  			}else{
  				if(!"".equals(reportid)){
  				  buffer.append("and id ='").append(reportid).append("' ");
  				}
  				
				if(!"".equals(reportname)){
				    buffer.append(" and reportname like '%").append(reportname).append("%' ");
				}

	    		if(rs.getDBType().equals("oracle")){
					if(otype>0)
					    buffer.append(" and nvl(reporttype,0) =").append(otype);
				}else{
					if(otype>0)
					    buffer.append(" and isnull(reporttype,0) =").append(otype);
				}
				
  			}	
		String orderby  =  "id";
		String  sqlwhere  = buffer.toString();
		tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REPORT_REPORTMANAGE,user.getUID())+"\" >"+      
								 "<checkboxpopedom  id=\"checkbox\" popedompara=\"column:subcompanyid+"+ user.getUID()+"+"+detachable+"\" showmethod=\"weaver.workflow.report.ReportManager.getCheckBox\" />"+
								 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlisdistinct=\"true\"  />"+   
								 "<head>";   
  		tableString+="<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15517,user.getLanguage())+"\" column=\"reportname\" orderkey=\"reportname\" transmethod=\"weaver.splitepage.transform.SptmForWorkFlowReport.getEditReportNameNew\" otherpara=\"column:id\" />"; 
        tableString+="<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15434,user.getLanguage())+"\"  column=\"reporttype\" orderkey=\"reporttype\" transmethod=\"weaver.splitepage.transform.SptmForWorkFlowReport.getReportType\" otherpara=\""+user.getLanguage()+"\" />";           
        tableString+="<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15451,user.getLanguage())+"\" column=\"formid\" orderkey=\"formid\" transmethod=\"weaver.splitepage.transform.SptmForWorkFlowReport.getReportFormName\" otherpara=\""+user.getLanguage()+"+column:isbill\" />";
        tableString+="<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15295,user.getLanguage())+"\" column=\"reportwfid\" orderkey=\"reportwfid\" transmethod=\"weaver.splitepage.transform.SptmForWorkFlowReport.getReportWFlowName\" />";
        if(detachable==1)
        {           
        	tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\"/>";
        }
        tableString+="</head>";
        tableString+="<operates>";
        tableString+="<popedom otherpara=\"column:subcompanyid+"+ user.getUID()+"+"+detachable+"\" transmethod=\"weaver.workflow.report.ReportManager.getCanDelTypeList\"></popedom> ";
        tableString+="<operate href=\"javascript:editDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>";
        tableString+="<operate href=\"javascript:editrptShare();\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"1\"/>";
        tableString+="<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"2\"/>";
		tableString+="</operates>";  
	    tableString+="</table>";
        %> 
         
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
		</td>
	</tr>
</table>
</td>
</tr>
</TABLE>
</FORM>
</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});
function newDialog(){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" + "<%=SystemEnv.getHtmlLabelName(33665,user.getLanguage())%>";
	diag_vote.URL = "/workflow/report/ReportAdd.jsp?dialog=1&reportType=<%=otype %>";
	diag_vote.isIframe=false;
	diag_vote.show();
}

function editDialog(id,__dialog){
	if (!!__dialog) {
		__dialog.close();
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 900;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.Title =  "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" + "<%=SystemEnv.getHtmlLabelName(33665,user.getLanguage())%>";
	diag_vote.URL = "/workflow/report/addDefineReport.jsp?id="+id+"&reportType=<%=otype %>";
	diag_vote.isIframe=false;
	diag_vote.show();
}

function editrptShare(id){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 900;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.Title =  "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" + "<%=SystemEnv.getHtmlLabelName(33665,user.getLanguage())%>";
	diag_vote.URL = "/workflow/report/addDefineReport.jsp?id="+id+"&isfrom=reportShare&reportType=<%=otype %>";
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
						window.location="/workflow/report/ReportOperation.jsp?operation=reportManagedeletes&otype=<%=otype %>&typeids="+typeids;
				}, function () {}, 320, 90,true);
}

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
							window.location="/workflow/report/ReportOperation.jsp?operation=reportManagedelete&otype=<%=otype %>&id="+id;
					}, function () {}, 320, 90,true);
}	

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
		try{
		typename = encodeURI(typename);
	}catch(e){
		if(window.console)console.log(e)
	 }
	$("input[name='reportname']").val(typename);
	window.location="/workflow/report/ReportManage.jsp?reportname="+typename+"&otype=<%=otype%>";
}

function rptTypebrowser(){
	var url ="/systeminfo/BrowserMain.jsp?url=/workflow/report/ReportTypeBrowser.jsp?rightStr=WorkflowReportManage:All&isedit=1";
	return url;
}
</script>
</HTML>
<script language="javascript">
function onSearch(){
	SearchForm.submit();
}
</script>
