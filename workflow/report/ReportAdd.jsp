<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo"></jsp:useBean>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage()) + SystemEnv.getHtmlLabelName(33665,user.getLanguage());
String needfav ="1";
String needhelp ="";
String reportType = Util.null2String(request.getParameter("reportType"));
reportType = (Util.getIntValue(reportType,0)<=0)?"":reportType;
String reportTypeName="";
if(!"".equals(reportType)){
	rs.executeSql("select typename from Workflow_ReportType where id="+reportType);
	if(rs.next())
		reportTypeName=rs.getString("typename");
}
String subcompanyid= Util.null2String(session.getAttribute("reportmanage_subcompanyid"));
subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;
if("".equals(subcompanyid)){
    //系统管理员
    if(user.getUID() == 1 ){
         rs.executeProc("SystemSet_Select","");
         if(rs.next()){
             subcompanyid = rs.getString("wfdftsubcomid");
         }
   }else{					
	   String hasRightSub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",0);
	   if(!"".equals(hasRightSub)){
	       subcompanyid = hasRightSub.split(",")[0];
	   }
   }
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
String id = Util.null2String(request.getParameter("id"));
String formid = Util.null2String(request.getParameter("formid"));
String wfid = Util.null2String(request.getParameter("wfid"));
String isbill = Util.null2String(request.getParameter("isbill"));
String dest = Util.null2String(request.getParameter("dest"));
String formname=formComInfo.getFormname(formid);
if(formname.length()<=0){
	formname=billComInfo.getBillLabel(formid);
	formname=SystemEnv.getHtmlLabelName(Util.getIntValue(formname),user.getLanguage());
}
%>
<BODY style="overflow-y:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(dest.equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData2(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:submitData(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData3(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="workFlowIFrame" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id=weaver name=frmMain action="ReportOperation.jsp" method=post onsubmit="return false">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    <%if(dest.equals("")){%>
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit2" class="e8_btn_top" onclick="submitData2(this)">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData(this)">
	    	<%}else{%>
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit2" class="e8_btn_top" onclick="submitData3(this)">
	    	<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	    <wea:item>
			<wea:required id="reportNameimage" required="true">
				<input type=text style="width: 50%;" class=Inputstyle size=30 name="reportName" onchange='checkinput("reportName","reportNameimage")'>
				<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(128381,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>	
			</wea:required>
		</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></wea:item>
    	<wea:item>
    		<brow:browser name="reportType" viewType="0" hasBrowser="true" hasAdd="true"
				getBrowserUrlFn="rptTypebrowser" isMustInput="2" isSingle="true" hasInput="true" 
          		addUrl="/workflow/report/ReportTypeAdd.jsp?dialog=1&isfrom=1" _callback="formSelectCallback"
           		completeUrl="/data.jsp?type=reportTypeBrowser"  width="50%" browserValue='<%=reportType %>' browserSpanValue='<%=reportTypeName %>'/>
    	</wea:item>
    	<% if(detachable==1){ %>
    	<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
    	<wea:item>
    		<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
             	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowReportManage:All&isedit=1&selectedids=" isMustInput="2" isSingle="true" hasInput="true"
              	completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="50%" browserValue='<%=subcompanyid%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid) %>'/> 
    	</wea:item>
    	<%} %>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
    	<wea:item>
    	    <%if(dest.equals("")){%>
	         <brow:browser name="formID" viewType="0" hasBrowser="true" hasAdd="false" 
	                  	browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp?from=report" 
	                  	_callback="showFlowDiv" isMustInput="2" isSingle="true" hasInput="true"
	                  	completeUrl="/data.jsp?type=wfFormBrowser&_exclude=6"  width="50%" browserValue='<%=formid%>' browserSpanValue='<%=formname%>' />
	       <%}else{%>
	       <brow:browser name="formID" viewType="0"  width="50%" browserValue='<%=formid%>' browserSpanValue='<%=formname%>'/>
	       <%} %>
	        <input type="hidden" id="isBill" name="isBill" value="<%=isbill%>">
    	</wea:item>
    	<%if(dest.equals("")){%>
    	<wea:item attributes="{'samePair':'sameP_workflowID','display':'none'}"><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></wea:item>
    	<wea:item attributes="{'samePair':'sameP_workflowID','display':'none'}">
			<brow:browser name="workflowID" viewType="0" hasBrowser="true" hasAdd="false" 
								getBrowserUrlFn="onShowWorkFlow"
			             		isMustInput="2" isSingle="false" hasInput="true"
			              		completeUrl="javascript:getWfUrl();"  width="50%" browserValue="" browserSpanValue=""/>
    	</wea:item> 
    	<%}else{%>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></wea:item>
    	<wea:item>
			<brow:browser name="workflowID" viewType="0"  width="50%" browserValue='<%=wfid%>' browserSpanValue='<%=WorkflowComInfo.getWorkflowname(wfid)%>'/>
    	</wea:item>
    	<% }%>
    </wea:group>
</wea:layout>
<input type="hidden" name=operation value=reportadd>
<input type="hidden" name="dialog" id="dialog" value="<%=dialog%>">
</form>
 <%if("1".equals(dialog)){ %>
 <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
<SCRIPT LANGUAGE="javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
function showFlowDiv(event,datas,name,paras){
	if($("#formIDspan").html()!=""){
		var billid = datas.isBill;
		if(billid == null || billid == undefined || billid == ""){
			billid = datas.isbill;
		}
		$("#isBill").val(billid);
		showDiv("1");
	}else{
		showDiv("0")
	}
}
function _userDelCallback(text,name){
	if(name=="formID"){
		showDiv("0");
	}
}

function rptTypebrowser(){
	var url ="/systeminfo/BrowserMain.jsp?url=/workflow/report/ReportTypeBrowser.jsp?rightStr=WorkflowReportManage:All&isedit=1";
	return url;
}

function btn_cancle(){
	parentWin.closeDialog();
}

if("<%=isclose%>"==1){
	//var parentWin = parent.getParentWindow(window);
	if("<%=dialog%>"==2){
		parentWin.location="/workflow/report/ReportManage.jsp?otype=<%=reportType%>";
		parentWin.closeDialog();	
	}else if("<%=dialog%>"==3){
		parentWin.location="/workflow/workflow/ListFormByWorkflow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
		parentWin.closeDialog();	
	}else{
		//parentWin.location="/workflow/report/ReportEdit.jsp?id=";
		//openInEdit("<%=id%>");
		parentWin.editDialog("<%=id%>", dialog);
	}	
}

function openInEdit(id){
	var diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 900;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.Title =  "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" + "<%=SystemEnv.getHtmlLabelName(33665,user.getLanguage())%>";
	diag_vote.URL = "/workflow/report/addDefineReport.jsp?id="+id;
	diag_vote.isIframe=false;
	diag_vote.show();
}

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
function onShowWorkFlow(){
	var isBill = $("#isBill").val();
	var formID = $("#formID").val();
	var workflowID = $("#workflowID").val();
	var url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp?value="+isBill+"_"+formID+"_"+workflowID;
	return url;
}
function getWfUrl(){
	var isBill = $("#isBill").val();
	var formID = $("#formID").val();
	var url = "/data.jsp?type=reportform&formid="+formID+"&isbill="+isBill;
	return url;
}

function onShowFormOrBill(isBill, inputName, spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp?from=report");
	if (datas){
		if (datas.id!=""){
			$(isBill).val(datas.isBill);
			$(inputName).val(datas.id);
			$(spanName).html(datas.name);
			showDiv("1");
			$("#workflowID").val("");
			$("#workflowIDSpan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			
		}else{
			$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(isBill).val( "");
			$(inputName).val( "");
			showDiv("0");
		}
	}
}

function WorkFlowBeforeShow(opts,e){
	isBill = document.all("isBill").value
	formID = document.all("formID").value
	workflowID = document.all("workflowID").value
	opts._url=opts._url+"?value="+isBill+"_"+formID+"_"+workflowID;
}

function afterDoWhenLoaded(){
	jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   jQuery(this).tzCheckbox({labels:['','']});
	  }
	 });
}

function submitData(obj)
{	enableAllmenu();
	jQuery(obj,parent.document).attr('disabled','true');
	var checkfields = "";
	<%if(detachable==1){%>
        checkfields = 'reportName,reportType,formID,workflowID,subcompanyid';
    <%}else{%>
    	checkfields = 'reportName,reportType,formID,workflowID';
    <%}%>
	if (check_form(frmMain,checkfields)){
		var checkreportName = jQuery("input[name=reportName]").val();
		if(checkreportName.indexOf("'") > -1 || checkreportName.indexOf('"') > -1){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128381,user.getLanguage()) %>");
			displayAllmenu();
			jQuery(obj,parent.document).removeAttr('disabled');
			return false;
		}
		frmMain.submit();
	}else{
		displayAllmenu();
		jQuery(obj,parent.document).removeAttr('disabled');
	}
}

function submitData2(obj){
	$("#dialog").val("2");
	submitData(obj);
}
function submitData3(obj){
	$("#dialog").val("3");
	submitData(obj);
}

function submitIFrame()
{
	document.all("workFlowIFrame").src = "WorkFlowofFormIFrame.jsp?isBill=" + document.all("isBill").value + "&formID=" + document.all("formID").value;
}

function showDiv(isShow)
{
	if("1" == isShow)	
	{
		showEle("sameP_workflowID");
	}
	else
	{
		hideEle("sameP_workflowID");
	}
}
function onShowSubcompany(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowReportManage:All&isedit=1&selectedids="+$("input[name=subcompanyid").val());
	
	issame = false
	if (data){
		if (data.id!="0"&&data.id){
			if(data.id== $("input[name=subcompanyid").val()){
				issame = true;
			}
			$("#subcompanyspan").html(data.name);
			$("input[name=subcompanyid]").val(data.id);
		}else{
			$("#subcompanyspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$("input[name=subcompanyid]").val(data.id);
		}
	}
	}
	
$("#zd_btn_submit").hover(function(){
  $(this).addClass("zd_btn_submit_hover");
},function(){
  $(this).removeClass("zd_btn_submit_hover");
});

$("#zd_btn_cancle").hover(function(){
  $(this).addClass("zd_btn_cancleHover");
},function(){
  $(this).removeClass("zd_btn_cancleHover");
});	

$("#zd_btn_submit2").hover(function(){
  $(this).addClass("zd_btn_submit2_hover");
},function(){
  $(this).removeClass("zd_btn_submit2_hover");
});	

function formSelectCallback(event,datas,name,_callbackParams){
	//var isbill = $("select[name=isbill]").val();
	//var endaffirmances,endShowCharts,affpos,showpos;
	//endaffirmances=$("#endaffirmances").val();
	//endShowCharts=$("#endShowCharts").val();

	if (datas){
	    if(datas.id!=""){
	        	
	    }
	} 
}
</SCRIPT>
</BODY></HTML>
