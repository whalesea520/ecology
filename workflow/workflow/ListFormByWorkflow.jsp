<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ page import="weaver.workflow.workflow.WfRightManager" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</head>
<%
	String wfid = Util.null2String(request.getParameter("wfid"));
	String rightStr = "WorkflowReportManage:All";
	if (!HrmUserVarify.checkUserRight(rightStr, user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage()) ;
	String needfav ="1";
	String needhelp ="";
	int otype = Util.getIntValue(Util.null2String(request.getParameter("otype")),0);
	int subcompanyid = Util.getIntValue(Util.null2String(request.getParameter("subcompanyid")),0);
	String reportname = Util.null2String(request.getParameter("reportname"));
	String reporttype = Util.null2String(request.getParameter("reporttype"));
	String formid = Util.null2String(request.getParameter("formid"));
	String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(wfid);
	String[] allIds = versionsIds.split(",");   // 所有版本的ids数组
	versionsIds = versionsIds.replaceAll(",","','");
	
	String isbill = Util.null2String(request.getParameter("isbill"));
	String reportid = Util.null2String(request.getParameter("reportid"));
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int operatelevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subcompanyid,user,false,rightStr);


%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<div>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deltype(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(347, user.getLanguage())+",javascript:supSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:newDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
</div>
<script type="text/javascript">
   function supSearch(){
       $("#advancedSearch").trigger("click");
   }
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id="SearchForm" name="SearchForm" action="ListFormByWorkflow.jsp" method="post">
<input type='hidden' name='wfid' value='<%=wfid%>'/>
<input type='hidden' name='formid' value='<%=formid%>'/>
<input type='hidden' id="reportid" name='reportid' value='<%=reportid%>'/>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_LISTFORMBYWORKFLOW %>"/>
<TABLE class=Shadow>
		<tr>
		<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		  	<input type="button" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>" class="e8_btn_top" onclick="newDialog()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>" class="e8_btn_top" onclick="deltype()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=reportname%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347, user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
	    <wea:group context="<%=SystemEnv.getHtmlLabelName(32905, user.getLanguage())%>">
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></wea:item>
		    <wea:item><input type="text" class="InputStyle" size="40" id="reportname" name="reportname" value='<%=reportname%>'></wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></wea:item>
		    <wea:item>
		           <span><brow:browser viewType="0" name="reporttype"
								browserValue=""
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/report/ReportTypeBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								completeUrl="/data.jsp?type=reportTypeBrowser"
								browserSpanValue=""></brow:browser>
					</span>
		    </wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>"/>
	    		<input class="e8_btn_cancel" type="reset" name="reset" onclick="resetReportForm()" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>"/>
	    		<input class="e8_btn_cancel" type="reset" name="cancel" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" onclick="supSearch()"/>
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
  			String  sqlwhere  =  " where 1=1 ";  
  			if(detachable==1)
  			{
  				if(!"".equals(reportid)){
  					sqlwhere += " and id='"+reportid+"' ";
  				}
  				if(!"".equals(reporttype))
				{
					sqlwhere += " and reporttype = "+reporttype;
				}
  				if(!"".equals(formid))
				{
					sqlwhere += " and formid = "+formid;
				}
  				if(!"".equals(isbill))
				{
					sqlwhere += " and isbill = "+isbill;
				}
  				if(!"".equals(versionsIds))
				{
  					sqlwhere += " and (reportwfid in ('" + versionsIds + "') ";
				}
  				if(allIds.length > 0){
  				    for(int i=0; i< allIds.length; i++){
  				      sqlwhere += " or reportwfid like '%," + allIds[i] + ",%' or reportwfid like '%," + allIds[i] + "%' or reportwfid like '%" + allIds[i] + ",%'";
  				    }
  				    sqlwhere += ")";
  				}
				if(!"".equals(reportname))
				{
					sqlwhere += " and reportname like '%"+reportname+"%' ";
				}
				else
				{
					if(rs.getDBType().equals("oracle"))
					{
						if(otype>0)
							sqlwhere+=" and nvl(reporttype,0) ="+otype;
					}
					else
					{
						if(otype>0)
							sqlwhere+=" and isnull(reporttype,0) ="+otype;
					}
				}
				if(user.getUID()!=1)
				{
					String hasRightSub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowReportManage:All",-1);
					if(!"".equals(hasRightSub)){
						sqlwhere+=" and subcompanyid in("+hasRightSub+")";
					}else{
						sqlwhere+=" and 1=2";
					}
				}
  			}
  			else
  			{
  				if(!"".equals(reportid)){
  					sqlwhere += "and id ='"+reportid+"' ";
  				}
  				if(!"".equals(reporttype))
				{
					sqlwhere += " and reporttype = "+reporttype;
				}
  				if(!"".equals(formid))
				{
					sqlwhere += " and formid = "+formid;
				}
  				if(!"".equals(isbill))
				{
					sqlwhere += " and isbill = "+isbill;
				}
  				if(!"".equals(versionsIds))
				{
  					sqlwhere += " and (reportwfid in ('" + versionsIds + "') ";
				}
  				if(allIds.length > 0){
  				    for(int i=0; i< allIds.length; i++){
  				      sqlwhere += " or reportwfid like '%," + allIds[i] + ",%' or reportwfid like '%," + allIds[i] + "%' or reportwfid like '%" + allIds[i] + ",%'";
  				    }
  				    sqlwhere += ")";
  				}
				if(!"".equals(reportname))
				{
					sqlwhere += " and reportname like '%"+reportname+"%' ";
				}
				else
				{
		    		
		    		if(rs.getDBType().equals("oracle"))
					{
						if(otype>0)
		    				sqlwhere+=" and nvl(reporttype,0) ="+otype;
					}
					else
					{
						if(otype>0)
							sqlwhere+=" and isnull(reporttype,0) ="+otype;
					}
				}
  			}	
		String orderby  =  "id";
  		//System.out.println("sqlwhere:---------:"+sqlwhere);
		tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_LISTFORMBYWORKFLOW,user.getUID())+"\" >"+
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
        tableString+="<operate href=\"javascript:editDialog();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>";
        tableString+="<operate href=\"javascript:editrptShare();\" text=\""+SystemEnv.getHtmlLabelName(119, user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"1\"/>";
        tableString+="<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" target=\"_self\" index=\"2\"/>";
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
    <%
      String sql="select id from workflow_report where reportwfid= '"+wfid+"' and formid='"+formid+"' and isbill='"+isbill+"'";
      RecordSet.execute(sql);
      //System.out.println(sql);
      int id=0;
	  if(RecordSet.next()){
		 id= RecordSet.getInt("id");
	  }
    %>
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.Title = '<%=SystemEnv.getHtmlLabelNames("82,20412",user.getLanguage()) %>';
	diag_vote.URL = "/workflow/report/ReportAdd.jsp?wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&dest=dest&dialog=1";
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
	diag_vote.Title = '<%=SystemEnv.getHtmlLabelNames("93,20412",user.getLanguage()) %>';
	diag_vote.URL = "/workflow/report/addDefineReport.jsp?id="+id+"&wfid=<%=wfid%>&formID=<%=formid%>&isbill=<%=isbill%>&isfrom=listform1";
	diag_vote.isIframe=false;
	diag_vote.show();
}

function closeDialog(){
	diag_vote.close();
}

function resetReportForm() {
	//document.SearchForm.reset();
	var isselected = "#SearchForm";
	jQuery(isselected).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(isselected).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(isselected).find(".e8_os").find("input[type='hidden']").val("");
	//清空下拉框
	//jQuery(isselected).find("select").selectbox("detach");
	jQuery(isselected).find("select").val("");
	jQuery(isselected).find("select").trigger("change");
	//beautySelect(jQuery(isselected).find("select"));
	//清空日期
	jQuery(isselected).find(".calendar").siblings("span").html("");
	jQuery(isselected).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(isselected).find("input[type='checkbox']").each(function(){
		jQuery(this).attr("checked",false);
		//changeCheckboxStatus(this,false);
	});
	
}

function deltype(){
	var typeids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		typeids = typeids +$(this).attr("checkboxId")+",";
	});
	if(typeids=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/report/ReportOperation.jsp?operation=reportdeletes&typeids="+typeids+"&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
				}, function () {}, 320, 90,true);
}

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
							window.location="/workflow/report/ReportOperation.jsp?operation=reportdelete&id="+id+"&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
					}, function () {}, 320, 90,true);
}	

function editrptShare(id){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 900;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.Title =  "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" + "<%=SystemEnv.getHtmlLabelName(33665,user.getLanguage())%>";
	diag_vote.URL = "/workflow/report/addDefineReport.jsp?id="+id+"&wfid=<%=wfid%>&formID=<%=formid%>&isbill=<%=isbill%>&isfrom=listform";
	diag_vote.isIframe=false;
	diag_vote.show();
}

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	$("input[name='reportname']").val(typename);
	window.location="/workflow/workflow/ListFormByWorkflow.jsp?reportname="+typename;
}
</script>
</HTML>
<script language="javascript">
function onSearch(){
	SearchForm.submit();
}
</script>
