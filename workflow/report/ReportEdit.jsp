<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
} 
int dbordercount = 0 ;
%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />	
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />	
		<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
	</HEAD>
<%
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("Workflow_Report_SelectByID",id);
	RecordSet.next();
	
	String reportName = Util.toScreen(RecordSet.getString("reportName"),user.getLanguage()) ;
	reportName=reportName.equals("")?Util.null2String(request.getParameter("reportname")):reportName;
	String reportType = Util.null2String(RecordSet.getString("reportType"));
	reportType = (Util.getIntValue(reportType,0)<=0)?"":reportType;
	String reportWFID = Util.null2String(RecordSet.getString("reportWFID"));
	reportWFID=reportWFID.equals("")?Util.null2String(request.getParameter("wfid")):reportWFID;
	String subcompanyid= Util.null2String(RecordSet.getString("subcompanyid"));
	subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	List reportWFList = new ArrayList();
	
	if(!"".equals(reportWFID) && null != reportWFID)
	{
		reportWFList = Util.TokenizerString(reportWFID, ",");
	}
	
	String formID = Util.null2String(RecordSet.getString("formID"));
	formID=formID.equals("")?Util.null2String(request.getParameter("formID")):formID;
	String formName = "";	
	String isBill = Util.null2String(RecordSet.getString("isBill"));
	isBill=isBill.equals("")?Util.null2String(request.getParameter("isBill")):isBill;
	
	if("0".equals(isBill))
	{
	    formName = formComInfo.getFormname(formID);	    
	}
	else if("1".equals(isBill))
	{
	    formName = SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage());
	}
	String isShowOnReportOutput = Util.null2String(RecordSet.getString("isShowOnReportOutput"));
	
	int operatelevel = 0;
	if(detachable == 1){
		operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowReportManage:All", Util.getIntValue(subcompanyid,0));
	}else{
	    operatelevel = 2;
	}
    if(operatelevel < 0){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
	
%>

<BODY style="overflow-y:hidden;">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		/*if(operatelevel>0)
		{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			if(operatelevel>1)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",ReportAdd.jsp?reportType="+reportType+"&subcompanyid="+subcompanyid+",_self} " ;
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",ReportShare.jsp?id="+id+",_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",javascript:onAddField(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}*/
		if(operatelevel>0){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:cancleClose(),_self} " ;
			//RCMenuHeight += RCMenuHeightStep;
		%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div class="zDialog_div_content">
		<!-- 
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="wokflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
 -->
<FORM id=weaver name=frmMain action="ReportOperation.jsp" method=post onsubmit="return false">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(operatelevel>0){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top"  onclick="submitData()"/>
			<%} %>
			<!--<input type="text" class="searchInput" name="flowTitle"/> -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context= '<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<%if(operatelevel>0){ %>
			<wea:required id="reportnameimage" required="true" value='<%=reportName%>'>
				<input type=text class=Inputstyle size=30 name="reportName" onchange='checkinput("reportName","reportnameimage")' value="<%=reportName%>" style="width: 50%;">
			</wea:required>
			<%}else{ %>
				<input type=text class=Inputstyle readOnly="true" size=30 name="reportName" onchange='checkinput("reportname","reportnameimage")' value="<%=reportName%>" style="width: 50%;">
			<%}%>
			<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(128381,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>	
		</wea:item>
    	<% if(detachable==1){ %>
    	<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
    	<wea:item>
    		<%if(operatelevel>0){ %>
	    		<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
	             	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1&selectedids=" isMustInput="2" isSingle="true" hasInput="true"
	              	completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="50%" browserValue='<%=subcompanyid%>' browserSpanValue='<%=SubComanyComInfo.getSubCompanyname(subcompanyid) %>'/> 
    		<%}else{%>
				<span id=subcompanyspan>
				<% if(subcompanyid.equals("")){ %>
				<img src="/images/BacoError_wev8.gif" align=absMiddle>
				<%}else{
					out.print(SubComanyComInfo.getSubCompanyname(subcompanyid)); 
				}%>
				</span>
			<%}%>
    	</wea:item>
    	<%} %>		
    	<wea:item><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></wea:item>
    	<wea:item>
    		<%if(operatelevel>0){ %>
    		<brow:browser name="reportType" viewType="0" hasBrowser="true" hasAdd="false" 
                 		browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/report/ReportTypeBrowser.jsp?rightStr=WorkflowReportManage:All&isedit=1" isMustInput="2" isSingle="true" hasInput="true"
                  		completeUrl="/data.jsp?type=reportTypeBrowser"  width="50%" browserValue='<%=reportType%>' browserSpanValue='<%=Util.toScreen(ReportTypeComInfo.getReportTypename(reportType),user.getLanguage())%>'/>
         	<%}else{ %>
         	<span id=reporttypeimage><%=Util.toScreen(ReportTypeComInfo.getReportTypename(reportType),user.getLanguage())%></span> 
            <%} %>                  		
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
    	<wea:item>
      			<%= formName %>
            	<input type=hidden name=formID id=formID value=<%=formID%>>
            	<input type=hidden name=isBill id=isBill value=<%=isBill%>>
    	</wea:item>
        <%
       	if(0 != reportWFList.size()){
       	    String outputWorkFlowName = "";		      		
     			for(int i = 0; i < reportWFList.size(); i++){
     			  	outputWorkFlowName += workflowComInfo.getWorkflowname((String)reportWFList.get(i)) + "，";
     			}
        %>	
     	<wea:item><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></wea:item>
    	<wea:item>
    		<%= outputWorkFlowName.substring(0, outputWorkFlowName.length() - 1) %>
    	</wea:item>       
        <%}%>    	 
    	<wea:item><%=SystemEnv.getHtmlLabelName(20832,user.getLanguage())%></wea:item> 
    	<wea:item><input type=checkbox tzCheckbox='true' name="isShowOnReportOutput" value="1" <% if(isShowOnReportOutput.equals("1")) {%> checked <%}%> <%if(operatelevel<=0){ %>disabled<%}%>></wea:item>   	
    </wea:group>
</wea:layout>	
														
<input type="hidden" name=operation value=reportedit>
<input type="hidden" name=id value=<%=id%>>
</FORM>						
</div>
<script>
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="reportdelete";
			document.frmMain.submit();
		}
}

var dialog = null;
var parentWin = null;
try{
	dialog = parent.parent.getDialog(parent.window);
	parentWin = parent.parent.getParentWindow(parent.window);
}catch(e){}

function onAddField(){
    location.href="ReportFieldAdd.jsp?id=<%=id%>&isBill=<%= isBill %>&formID=<%= formID %>&dbordercount=<%=dbordercount%>" ;
}

</script>

<script language="javascript">
function onShowReportType(inputName,spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/report/ReportTypeBrowser.jsp?rightStr=WorkflowReportManage:All&isedit=1");
	if (datas){
		if (datas.id!=""){
			$(inputName).val(datas.id);
			$(spanName).html(datas.name);			
		}else{
			$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputName).val( "");
		}
	}
}
function submitData()
{
	var checkfields = "";
	<%if(detachable==1){%>
        checkfields = 'reportName,reportType,reportWFID,subcompanyid';
    <%}else{%>
    	checkfields = 'reportName,reportType,reportWFID';
    <%}%>
	if (check_form(frmMain,checkfields)){
		var checkreportName = jQuery("input[name=reportName]").val();
		if(checkreportName.indexOf("'") > -1 || checkreportName.indexOf('"') > -1){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128381,user.getLanguage()) %>");
			return false;
		}
		frmMain.submit();
	}
}
</script>
</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});
function newDialog(){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 700;
	diag_vote.Height = 224;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82260,user.getLanguage())%>";
	diag_vote.URL = "/workflow/report/ReportAdd.jsp?dialog=1";
	diag_vote.show();
}

function afterDoWhenLoaded(){
	jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   jQuery(this).tzCheckbox({labels:['','']});
	  }
	 });
}

function closeDialog(){
	diag_vote.close();
}

function cancleClose(){
	parentWin.location="/workflow/report/ReportManage.jsp?otype=<%=reportType%>";
	dialog.close();
}

function onchange(obj1,obj2){
	var requestname = jQuery(obj1).val();
	if(requestname != null && requestname != ""){
		jQuery("#reportnameimage").css("display","none");
	}else{
		jQuery(obj1).css("display","inline-block");
	}
}

function spanOver(obj){
    $(obj).addClass("rightMenuHover");
}

function spanOut(obj){
    $(obj).removeClass("rightMenuHover");
}
		
function mnToggleleft(){
	var f = window.parent.document.getElementById("oTd1").style.display;

	if (f != null) {
		if (f==''){
			window.parent.document.getElementById("oTd1").style.display='none'; 			
		}else{ 
			window.parent.document.getElementById("oTd1").style.display=''; 
		}
	}
}

if("<%=reportName %>"!=""){
try{
	parent.setTabObjName("<%=Util.toScreenToEdit(reportName,user.getLanguage()) %>");
}catch(e){}
}
</script>
</HTML>
