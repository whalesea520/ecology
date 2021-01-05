
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.proj.util.PropUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="PrjTaskDwrUtil" class="weaver.proj.task.PrjTaskDwrUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />

<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String hidetitle = Util.null2String(request.getParameter("hidetitle"));
%>

<%

String types=Util.null2String(request.getParameter("types"));//PT 任务交流,PP 项目交流
String sortid=Util.null2String(request.getParameter("sortid"));

String dialogTitle="pp".equalsIgnoreCase(types)?ProjectInfoComInfo.getProjectInfoname(sortid):"pt".equalsIgnoreCase(types)?PrjTaskDwrUtil.getPrjTaskInfoMap(sortid).get("subject"):"";

String userid = user.getUID()+"";

boolean showdoc=false;
boolean showwf=false;
boolean showcrm=false;
boolean showprj=false;
boolean showtask=false;
boolean showacc=false;
int accsec=0;
int accsize=0;

boolean canview=false;
boolean canedit=false;
double ptype=0;

if("pt".equalsIgnoreCase(types)){
	showdoc=PrjSettingsComInfo.getTsk_dsc_doc();
	showwf=PrjSettingsComInfo.getTsk_dsc_wf ();
	showcrm =PrjSettingsComInfo.getTsk_dsc_crm ();
	showprj=PrjSettingsComInfo.getTsk_dsc_prj();
	showtask=PrjSettingsComInfo.getTsk_dsc_tsk();
	accsec=Util.getIntValue( PrjSettingsComInfo.getTsk_dsc_accsec(),0);
	accsize=Util.getIntValue( PrjSettingsComInfo.getTsk_accsize(),0);
	showacc=PrjSettingsComInfo.getTsk_dsc_acc()&&accsec>0&&accsize>0;
	ptype=Util.getDoubleValue ( CommonShareManager.getPrjTskPermissionType(sortid, user),0.0);
	if(ptype>=2.1){
		canedit=true;
		canview=true;
	}else if(ptype>=0.5){
		canview=true;
	}
}else if("pp".equalsIgnoreCase(types)){
	showdoc=PrjSettingsComInfo.getPrj_dsc_doc();
	showwf=PrjSettingsComInfo.getPrj_dsc_wf ();
	showcrm =PrjSettingsComInfo.getPrj_dsc_crm ();
	showprj=PrjSettingsComInfo.getPrj_dsc_prj();
	showtask=PrjSettingsComInfo.getPrj_dsc_tsk();
	accsec=Util.getIntValue( PrjSettingsComInfo.getPrj_dsc_accsec(),0);
	accsize=Util.getIntValue( PrjSettingsComInfo.getPrj_accsize(),0);
	showacc=PrjSettingsComInfo.getPrj_dsc_acc()&&accsec>0&&accsize>0;
	ptype=Util.getDoubleValue ( CommonShareManager.getPrjPermissionType(sortid, user),0.0);
	if(ptype>=2){
		canedit=true;
		canview=true;
	}else if(ptype>=0.5){
		canview=true;
	}
}

boolean showext=showdoc||showwf||showcrm||showprj||showtask||showacc;

String sql ="";
int _pagesize = 10;
int _total = 0;//总数
String userType = user.getLogintype();
char flag0=2;

rs.executeProc("ExchangeInfo_SelectBID",sortid+flag0+types);

_total=rs.getCounts();

String pageId=Util.null2String(PropUtil.getPageId("prj_viewprjdiscuss"));
%>
<html>
<head>
<LINK href="/CRM/css/Contact_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/CRM/css/Base_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
<script type="text/javascript">
var oUpload;
</script>

<style>
TABLE.ListStyle{width:96%}
TABLE.ListStyle tbody tr td {
	padding:0px;
}
TABLE.ListStyle tr.selected td {
	background-color:#fff !important;
}
TABLE.ListStyle TR.HeaderForXtalbe{
	display:none;
}
.feedbackshow{width:98%}
.feedbackrelate{border:0px;}
.paddingLeft18{padding-left:0px !important}
</style>
</head>
<body style="overflow-y:auto;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
if(canedit){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:_xtable_getAllExcel(),_top} " ;
	//RCMenuHeight += RCMenuHeightStep;
}


%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="weaver" name="weaver" action="" method=post  >
<input type="hidden" name="accdocids" id="accdocids" value="">
<input type="hidden" name="types" id="types" value="<%=types %>">
<input type="hidden" name="sortid" id="sortid" value="<%=sortid %>">
<input type="hidden" name="isdialog" id="isdialog" value="<%=isDialog %>">

<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" name="flowTitle"  value="<%=nameQuery %>" />
<%
if(canedit){
	%>
			<!--<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%> " class="e8_btn_top" onclick="_xtable_getAllExcel()" style="display:none"/>-->
	<%
}
%>			
			<span id="advancedSearch" class="advancedSearch" style=""><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" style="display:none;" id="advancedSearchDiv">

<%
String creater = Util.null2String(request.getParameter("creater"));
String dept = Util.null2String(request.getParameter("dept"));
String subcom = Util.null2String(request.getParameter("subcom"));
String searchcontent = Util.null2String(request.getParameter("searchcontent"));
String createdate = Util.null2String(request.getParameter("createdate"));
String createdate1 = Util.null2String(request.getParameter("createdate1"));

%>


<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("616",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="creater" 
				browserValue='<%=creater %>' 
				browserSpanValue='<%=ResourceComInfo.getResourcename (""+creater) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="dept" 
				browserValue='<%=dept %>' 
				browserSpanValue='<%=DepartmentComInfo.getDepartmentname(""+dept ) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=4"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("141",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="subcom" 
				browserValue='<%=subcom %>' 
				browserSpanValue='<%=SubCompanyComInfo .getSubCompanyname (""+subcom ) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=164"  />
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelNames("345",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="searchcontent" id="searchcontent" value='<%=searchcontent %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("15175",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="begindate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="createdate" value="<%=createdate%>">
				  <input class=wuiDateSel  type="hidden" name="createdate1" value="<%=createdate1%>">
			</span>
		</wea:item>
		
	</wea:group>
	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
    	</wea:item>
    </wea:group>
    
</wea:layout>


</div>


<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div id="fbmain" style="width: 100%;overflow: hidden;background: #fff;top:0px;z-index: 100;">
		<table style="width: 100%;height: auto;margin-top:5px;overflow: hidden;" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="*" align="center">
				<div style="width: 96%;font-weight: bold;text-align: left;"><%=SystemEnv.getHtmlLabelNames("15153",user.getLanguage())%></div>
				<div style="width: 96%;height:2px;background-color:rgb(135, 157, 178);margin-bottom:5px;margin-top: 3px;"></div>
			</td>
		</tr>
		<tr>
			<td width="*" valign="top" align="center">
				<textarea id="ContactInfo" style="width: 96%;margin-top:0px;height:80px;overflow: auto;outline:none;"></textarea>
			</td>
		</tr>
		<tr>
			<td width="*" valign="top" align="center">
				<div style="width: 96%;overflow: hidden;margin-bottom: 5px;margin-top: 5px;">
				
					<wea:layout type="1col">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								<wea:item>
									<div id="btn_feedback" class="e8_btn_top" style="margin-left: 0px;float: left;">
										<span onclick="doFeedback()" class=""  style="display:block;"><%=SystemEnv.getHtmlLabelNames("615",user.getLanguage())%></span>
									</div>
									<div id="submitload" style="float:left;margin-top: 6px;margin-bottom: 0px;margin-left: 20px;display: none;"><img src='/proj/img/loading2_wev8.gif' align=absMiddle /></div>
<%
if(showext){
	%>
									<div onclick="" id="fbrelatebtn" _status="0" style="background:url('/cowork/images/blue/down_wev8.png') no-repeat right center;padding-right:8px;cursor: pointer;vertical-align: middle;"><%=SystemEnv.getHtmlLabelNames("83273",user.getLanguage())%></div>
	<%
}
%>									
								</wea:item>
							</wea:group>
					</wea:layout>
					
					<wea:layout type="2col" attributes="{'layoutTableId':'extendtable','layoutTableDisplay':'none'}">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
<%
if(showdoc){
	%>
								<wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage()) %></wea:item>
								<wea:item>
									<brow:browser viewType="0" name="_docids" browserValue="" browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=#id#" completeUrl="/data.jsp?type=9" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="40%" browserSpanValue="" />
								</wea:item>
	<%
}
%>							
<%
if(showwf){
	%>
								<wea:item><%=SystemEnv.getHtmlLabelName(1044, user.getLanguage()) %></wea:item>
								<wea:item>
									<brow:browser viewType="0" name="_wfids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids=#id#"  completeUrl="/data.jsp?type=152" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="40%" browserSpanValue="" />
								</wea:item>
	<%
}
%>							
<%
if(showcrm){
	%>
								<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage()) %></wea:item>
								<wea:item>
									<brow:browser viewType="0" name="_crmids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=#id#"  completeUrl="/data.jsp?type=7" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="40%" browserSpanValue="" />
								</wea:item>
	<%
}
%>							
<%
if(showprj){
	%>
								<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage()) %></wea:item>
								<wea:item>
									<brow:browser viewType="0" name="_prjids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids=#id#"  completeUrl="/data.jsp?type=8" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="40%" browserSpanValue="" />
								</wea:item>
	<%
}
%>							
<%
if(showtask){
	%>
								<wea:item><%=SystemEnv.getHtmlLabelName(33414, user.getLanguage()) %></wea:item>
								<wea:item>
									<brow:browser viewType="0" name="_tskids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids=#id#" completeUrl="/data.jsp?type=prjtsk" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="40%" browserSpanValue="" />
								</wea:item>
	<%
}
%>							
<%
if(showacc){//附件
	%>
								<wea:item><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></wea:item>
					          <wea:item>
					          	<script type="text/javascript">
									var oUpload;
									
									window.onload = function() {
									  var settings = {
											flash_url : "/js/swfupload/swfupload.swf",
											upload_url: "/proj/data/uploadPrjAcc.jsp",	// Relative to the SWF file
											post_params: {"method" : "uploadPrjAcc","secid":"<%=accsec %>"},
											file_size_limit : "<%=accsize %> MB",
											file_types : "*.*",
											file_types_description : "All Files",
											file_upload_limit : 100,
											file_queue_limit : 0,
											custom_settings : {
												progressTarget : "fsUploadProgress",
												cancelButtonId : "btnCancel"
											},
											debug: false,
											 
					
											// Button settings
											
											button_image_url : "/js/swfupload/add_wev8.png",	// Relative to the SWF file
											button_placeholder_id : "spanButtonPlaceHolder",
							
											button_width: 100,
											button_height: 18,
											button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
											button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
											button_text_top_padding: 0,
											button_text_left_padding: 18,
												
											button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
											button_cursor: SWFUpload.CURSOR.HAND,
											
											// The event handler functions are defined in handlers.js
											file_queued_handler : fileQueued,
											file_queue_error_handler : fileQueueError,
											file_dialog_complete_handler : fileDialogComplete_1,
											upload_start_handler : uploadStart,
											upload_progress_handler : uploadProgress,
											upload_error_handler : uploadError,
											upload_success_handler : uploadSuccess,
											upload_complete_handler : uploadComplete,
											queue_complete_handler : queueComplete	// Queue plugin event
										};
					
										
										
										try{
											oUpload = new SWFUpload(settings);
										} catch(e){alert(e)}
									}
							
									function fileDialogComplete_1(){
										document.getElementById("btnCancel1").disabled = false;
										fileDialogComplete
									}
									function uploadSuccess(fileObj,serverdata){
										var data=eval(serverdata);
										//alert(data);
										if(data){
											var a=data;
											if(a>0){
												jQuery("#accdocids").val(jQuery("#accdocids").val()+","+a);
											}
										}
									}
							
									function uploadComplete(fileObj) {
										try {
											/*  I want the next upload to continue automatically so I'll call startUpload here */
											if (this.getStats().files_queued === 0) {
												exeFeedback();
												document.getElementById(this.customSettings.cancelButtonId).disabled = true;
											} else {	
												this.startUpload();
											}
										} catch (ex) { this.debug(ex); }
							
									}
								</script>
								<div>
									<span> 
										<span id="spanButtonPlaceHolder"></span><!--选取多个文件-->
									</span>
									&nbsp;&nbsp;
									<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload.cancelQueue();" id="btnCancel1">
										<span><img src="/js/swfupload/delete_wev8.gif"  border="0"></span>
										<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
									</span>
								</div>
								<div class="fieldset flash" id="fsUploadProgress"></div>
								<div id="divStatus"></div>
								
					            <input class=inputstyle style="display:none;" type=file name="accessory1" onchange='accesoryChanage(this)' style="width:100%">
							    <span id="shfj_span"></span>
							    (<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=accsize%>M)
							    <input type=hidden name=accessory_num value="1">
					            
					          </wea:item>
					        
	
	<%
}

%>
							</wea:group>	
					</wea:layout>					
				
				</div>
			</td>
		</tr>
		</table>
				
  	</div>
	<div id="maininfo" style="width:100%;height: auto;" class="scroll1" align="center">
		  <%
		    String tableString = "";
			int perpage=10;                                 
			String backfields = " id,creater,createdate,createtime,remark,docids,crmids,projectids,requestids,tskids,accessory ";
			String fromSql  = " Exchange_Info " ;
			String sqlWhere = " sortid = "+sortid+" AND type_n='"+types+"' ";
			
			if(!"".equals(nameQuery)){
				if("sqlserver".equalsIgnoreCase( rs.getDBType())){
					sqlWhere+=" and convert(varchar(4000),remark) like '%"+nameQuery+"%' ";
				}else{
					sqlWhere+=" and remark like '%"+nameQuery+"%' ";
				}
			}else if(!"".equals(searchcontent)){
				if("sqlserver".equalsIgnoreCase( rs.getDBType())){
					sqlWhere+=" and convert(varchar(4000),remark) like '%"+searchcontent+"%' ";
				}else{
					sqlWhere+=" and remark like '%"+searchcontent+"%' ";
				}
			}
			
			if(!"".equals(creater)){
				sqlWhere+=" and creater='"+creater+"' ";
			}
			if(!"".equals(dept)){
				sqlWhere+=" and exists (select 1 from hrmresource where hrmresource.id=Exchange_Info.creater and hrmresource.departmentid='"+dept+"' ) ";
			}
			if(!"".equals(subcom)){
				sqlWhere+=" and exists (select 1 from hrmresource where hrmresource.id=Exchange_Info.creater and hrmresource.subcompanyid1='"+subcom+"' ) ";
			}
			if(!"".equals(createdate)){
				sqlWhere+=" and createdate>='"+createdate+"' ";
			}
			if(!"".equals(createdate1)){
				sqlWhere+=" and createdate<='"+createdate1+"' ";
			}
			
			
			String orderby = "";
			 			  
			 tableString=""+
			        "<table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"none\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  >"+
			        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"id\" sqlorderby=\""+orderby+"\" sqlsortway=\"desc\" sqldistinct=\"false\" excelFileName=\""+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"\" />"+
			        "<head>"+                             
			              "<col width=\"15%\"  text=\"\" column=\"id\" otherpara='column:creater+column:createdate+column:createtime+column:id+column:docids+column:crmids+column:projectids+column:requestids+column:accessory+column:tskids+"+user.getLanguage()+"' transmethod=\"weaver.proj.util.ProjectTransUtil.getMessageContent\"    />"+
			        "</head>"+
			        "</table>"; 
		  
		  %>	
		  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
	</div>
</div>
<div style="display:none;">
<input id="resetbtn" type=reset>
</div>
</form>
<div style="height:35px!important;">
</div>
<script language="javascript">

	jQuery(function(){
		if(parent.crmExchange_1){
			parent.crmExchange_1.innerHTML = '';
		}
	});
	var tempval = "";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var keyword = "";
	var begindate = "<%=TimeUtil.getCurrentDateString()%>";
	$(document).ready(function(){

		$("#maininfo").height($(window).height()-$("#fbmain").height());

		//反馈附加信息按钮事件绑定
		$("#fbrelatebtn").bind("click",function(){
			var _status = $(this).attr("_status");
			if(_status==0){
				$("#extendtable").show();
				$(this).attr("_status",1).css("background", "url('../img/btn_up_wev8.png') right no-repeat");
			}else{
				$("#extendtable").hide();
				$(this).attr("_status",0).css("background", "url('../img/btn_down_wev8.png') right no-repeat");
			}
			$("#maininfo").height($(window).height()-$("#fbmain").height());
			//layzyFunctionLoad();
		});
		
		//bindUploaderDiv($("#fbUploadDiv"),"relateddoc","");

		<%if(_total>0){ %>$("#listmore2").click();<%}%>
		<%if(hidetitle.equals("1")){%>$("#contacttitle").height(0);$("#fbmain").css("top",0);$("#maininfo").css("top",$("#fbmain").height());<%} %>
	});

	document.onkeydown=keyListener;
	function keyListener(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){
	    	//var target=$.event.fix(e).target;
	    	//ctrl+enter 直接提交反馈
			if(event.ctrlKey){
				doFeedback();
			}
	    	 
	    }    
	}
	var ContactInfo;
	function doFeedback(){
		ContactInfo = $.trim($("#ContactInfo").val());
		if(ContactInfo==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83900",user.getLanguage())%>");
			return;
		}
		if(ContactInfo==keyword){
			$("#ContactInfo").focus();
			return;
		}
	  	exeFeedback();
	}
	
	function doSubmit(){
		var relateddoc = $("#_docids").val();
		var relatedwf = $("#_wfids").val();
		var relatedcrm = $("#_crmids").val();
		var relatedprj = $("#_prjids").val();
		var relatedtsk = $("#_tskids").val();
		var relatedacc = $("#accdocids").val();
		
		$.ajax({
			type: "post",
			url: "/proj/process/ViewPrjDiscussOperation.jsp",
			contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			data:{"operation":"add",
				"ContactInfo":ContactInfo,
				"customerid":<%=sortid %>,
				"discusstype":"<%=types %>",
				"relateddoc":relateddoc,
				"relatedwf":relatedwf,
				"relatedcrm":relatedcrm,
				"relatedprj":relatedprj,
				"relatedtsk":relatedtsk,
				"relatedacc":relatedacc
				}, 
			complete: function(data){
				$("#noinfo").remove();
				$("#submitload").hide();
				$("div[id=btn_feedback]").show();
				$("#ContactInfo").val("");
				$("#extendtable").hide();
				_table. reLoad();
				//$("#resetbtn").trigger("click");
				window.location.href=window.location.href;
				
			}
		});
	}
	
	function exeFeedback(){
		
		$("#submitload").show();
		$("div[id=btn_feedback]").hide();
    	if(oUpload ){
    		try {
    			if(oUpload.getStats().files_queued === 0){
    				doSubmit();
    			}else{
    				oUpload.startUpload();
    			}
			} catch (e) {
				doSubmit();
			}
    		
   	    }else{
   	    	doSubmit();
   	    }
	}
	
	function cutval(val){
		if(val==",") val = "";
		if(val!="") val = val.substring(1,val.length-1);
		return val;
	}
	function cancelFeedback(){
		var obj = $("#ContactInfo")
		obj.val(keyword);
		obj.addClass("blur_text");
		$("div[id=btn_feedback]").hide();
		var _status = $("#fbrelatebtn").attr("_status");
		if(_status==1) $("#fbrelatebtn").click();
		$("#fbrelatebtn").hide();
		$("#maininfo").css("top",$("#fbmain").height()+$("#contacttitle").height());

		$("#_docids_val").val(",");$("#_wfids_val").val(",");$("#_projectids_val").val(",");
		$("table.feedrelate").find("div.txtlink").remove();

		$("input[name=relateddoc]").val("");
	}

	//显示删除按钮
	function showdel(obj){
		$(obj).find("div.btn_del").show();
		$(obj).find("div.btn_wh").hide();
	}
	//隐藏删除按钮
	function hidedel(obj){
		$(obj).find("div.btn_del").hide();
		$(obj).find("div.btn_wh").show();
	}
	//回车事件方法
	function keyListener2(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){    
	    	$(foucsobj2).blur();   
	    }    
	}
	function showFeedback(){
		$("#content").focus();
	}
	
	function showop(obj,classname,txt){
		$(obj).removeClass(classname).html(txt);
	}
	function hideop(obj,classname,txt){
		$(obj).addClass(classname).html(txt);
	}
	
</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>
<script type="text/javascript">
$(function(){
	var dialogTitle='<%=dialogTitle %>';
	try{
		parent.setTabObjName(dialogTitle);
	}catch(e){}
});

$(function(){//更新tab数值
	getDiscussNum("updatenum",'<%=types %>','<%=sortid %>');
});
function getDiscussNum(src,type,sortid){
	jQuery.ajax({
		url : "/proj/process/PrjGetDiscussNumAjax.jsp",
		type : "post",
		async : true,
		processData : true,
		data : {src:src,type:type,sortid:sortid},
		dataType : "json",
		success: function do4Success(data){
			if(data){
				if(data.count&&data.count>0){
					$("#discussNum_span",parent.document).html(data.count).show();
				}else{
					$("#discussNum_span",parent.document).hide();
				}
			}
		}
	});
}

function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	if("<%=isDialog %>"=="1"){
		$("#topTitle").hide();
	}
});
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
