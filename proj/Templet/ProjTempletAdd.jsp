<%@page import="weaver.cpt.util.html.HtmlUtil"%>
<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="java.net.URLEncoder" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<%
String isfromProjTab = Util.null2String(request.getParameter("isfromProjTab"));
String querystr=request.getQueryString();
if(!"1".equals(isfromProjTab)){
	response.sendRedirect("/proj/Templet/ProjTempletAddTab.jsp"+"?"+querystr);
	return;
}
%>



<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjCodeParaBean" class="weaver.proj.form.ProjCodeParaBean" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page"/>

<%
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("prj","PrjTmpCardAdd");
if(CusFormSetting!=null&&CusFormSetting.getStatus()==2){//自定义布局页面
	//request.getRequestDispatcher("/proj/Templet/ProjTempletAdd_l.jsp").forward(request, response);
	response.sendRedirect("/proj/Templet/ProjTempletAdd_l.jsp"+"?"+querystr);
	return;
}


String nameQuery = Util.null2String(request.getParameter("nameQuery"));
   
    String URLFrom = URLEncoder.encode(Util.null2String(request.getParameter("URLFrom")));
    
    //判断是否具有项目编码的维护权限
    if (!HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {
        response.sendRedirect("/notice/noright.jsp") ; 
    }
    

    String imagefilename = "/images/sales_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(18375,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage());
	String needfav ="1";
	String needhelp ="";//取得相应设置的值

    
    /*为了兼容项目自定义字段*/
    /**
    boolean hasFF = true;
    RecordSetFF.executeProc("Base_FreeField_Select","p1");
    if(RecordSetFF.getCounts()<=0)
        hasFF = false;
    else
        RecordSetFF.first();
    **/

    String projTypeId = Util.null2String(request.getParameter("txtPrjType"));
    int scopid = Util.getIntValue(projTypeId) ;
    String  prjid ="";
    String  crmid="";
    String  hrmid="";
    String docid="";
    String needinputitems = "";
   /*END*/
   
   String chkFields="";
%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>



<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>

<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>

<SCRIPT language="javascript"  type='text/javascript' src="/js/weaver_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTask_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/projTask/temp/prjTask_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/jquery.z4x_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/ProjectAddTaskI2_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskDrag_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskUtil_wev8.js"></script>
<script src="/js/projTask/jquery.dragsort_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<%--
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
 --%>
 
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

	.spanSwitch{cursor:pointer;font-weight:bold}
	#tblTask table td{padding:0;}
</style>

<style type="text/css">
.InputStyle{width:40%!important;}
.inputstyle{width:40%!important;}
.Inputstyle{width:40%!important;}
.inputStyle{width:40%!important;}
.e8_os{width:30%!important;}
select.InputStyle{width:10%!important;} 
select.inputstyle{width:10%!important;} 
select.inputStyle{width:10%!important;} 
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>
</HEAD>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
%>
<BODY  style="overflow: hidden;" id="myBody" >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    boolean needApproveTemplate=ProjectTransUtil.needApproveTemplate();
if(needApproveTemplate){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this,2),_self} " ;
    //RCMenuHeight += RCMenuHeightStep ;
}
    
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(320,user.getLanguage())+",javascript:location='ProjTempletList.jsp',_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;

	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 400px !important">
			<input id="taskIframeAddRowBtn" type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top middle" style="display:none;" onclick="frames['taskDataIframe'].addRow();"/>
			<input id="taskIframeDelRowBtn" type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" style="display:none;" onclick="frames['taskDataIframe'].delRows();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSave(this)"/>
<%
if(false&& needApproveTemplate){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSave(this,2)"/>
	<%
}
%>			
			<span
				title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
				class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv">
	<span style="width:10px"></span>
	<span id="hoverBtnSpan" class="hoverBtnSpan">
	</span>
</div>

<div class="zDialog_div_content" style="overflow:auto;">

<Form name="frmain" method="post" action="ProjTempletOperate.jsp">

<input type="hidden" name="submittype" id="submittype" value="">
<input type="hidden" name="method" value="add">
<input type="hidden" name="URLFrom" value="<%=URLFrom%>">        
<input type="hidden" name="accdocids" id="accdocids" value="">
<input type="hidden" name="isdialog" id="isdialog" value="<%=isDialog %>">

<!-- 项目信息 -->
<div id="nomalDiv">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<!-- baseinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT TYPE="text" NAME="name" class="InputStyle" onchange="checkinput('name','spanTempletName')"> 
                                        <span id=spanTempletName><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT TYPE="text" NAME="txtTempletDesc" class="InputStyle">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
		<wea:item>
			<%=ProjectTypeComInfo.getProjectTypename(projTypeId) %>
			<input type="hidden" name=prjtype value="<%=projTypeId %>" />
			
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="worktype" 
					browserValue="" browserSpanValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=245" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="description" 
					browserValue="" browserSpanValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=7" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15263,user.getLanguage())%></wea:item>
		<wea:item>
			<input class="InputStyle" type="checkbox" name="managerview" value="1">
		</wea:item>
	</wea:group>
	
	
	<!-- manageinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(27858,user.getLanguage())%>' attributes="{}">
		<wea:item><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="parentid" 
					browserValue="" browserSpanValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=8" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16573,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" 
					browserValue="" browserSpanValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18628,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="hrmids02" 
					browserValue="" browserSpanValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></wea:item>
		<wea:item>
			<input class="InputStyle" type="checkbox" name="isblock" value="1">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="envaluedoc" 
					browserValue="" browserSpanValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=9" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="confirmdoc" 
					browserValue="" browserSpanValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=9" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="proposedoc"
					browserValue="" browserSpanValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=9" />
		</wea:item>

<%
if(PrjSettingsComInfo.getPrj_acc()){//项目卡片附件
	String accsec=PrjSettingsComInfo.getPrj_accsec();
	String accsize=PrjSettingsComInfo.getPrj_accsize();
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
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
							frmain.submit();
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
		    (<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=accsize %>M)
		    <button type="button" class=AddDoc style="display:none;" name="addacc" onclick="addannexRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
		    <input type=hidden name=accessory_num value="1">
			
		</wea:item>
	
	<%
}

%>		
		
		
	</wea:group>
	
	
	<!-- otherinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%>'>
<%
//cusfield
TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v= entry.getValue();
	
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage())%></wea:item>
	<wea:item>
		<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString("", v, user) %>
	</wea:item>
	
	<%
	}
}

%>
	


<%                                       
//项目类型自定义字段
CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",scopid);
cfm.getCustomFields4prj();
while(cfm.next()){
    if(cfm.isMand()){
        needinputitems += ",customfield"+cfm.getId();
    }
    String fieldValue="";
    JSONObject v=new JSONObject();
    v.put("fieldkind", "2");
    v.put("groupid", "3");
    v.put("id", ""+cfm.getId());
    v.put("fieldname", "customfield"+cfm.getId());
    v.put("fieldlabel", cfm.getLable4prj(user.getLanguage()));
    v.put("fielddbtype", cfm.getFieldDbType());
    v.put("fieldhtmltype", cfm.getHtmlType());
    v.put("ismand", cfm.isMand()?"1":"0");
    v.put("type", ""+cfm.getType());
    v.put("eleclazzname", HtmlUtil.getHtmlClassName(cfm.getHtmlType()));
    v.put("seltype", "prjtype");
    v.put("issystem", "0");
    
%>
<wea:item><%=cfm.getLable4prj(user.getLanguage()) %></wea:item>
<wea:item> 
<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
</wea:item>
   <%
}
   %> 
	</wea:group>
	
	
</wea:layout>





</div>
<!-- 任务列表 -->
<div id="agendaDiv" style="display:none;">
  
  <iframe id="taskDataIframe" name="taskDataIframe" src="/proj/Templet/ProjTempletAddData.jsp" class="flowFrame" frameborder="0" scrolling="auto" height="500px" width="100%"></iframe>
  
  <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
   <div id="divTaskList" style="display:none;"></div>
  
  
  
  
  
  
</div>
<div id="temp_seleBeforeTask_DIV" style="display:none"><select name='temp_seleBeforeTask' class='inputStyle'><option value='0'></option></select></div>
</FORM>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">

				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language=javascript>

function checkDateValidity(begindate,begintime,enddate,endtime,errormsg){
	var isValid = true;
	if(compareDate(begindate,begintime,enddate,endtime) == 1){
		window.top.Dialog.alert(errormsg);
		isValid = false;
	}
	return isValid;
}


/*Check Date */
function compareDate(date1,time1,date2,time2){

	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0] + " " +time1;
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0] + " " +time2;

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}



</script>




<script type="text/javaScript">
  //  var ptu = new ProjTaskUtil(); 
  	prjTaskObj={rootTask:{task:[]}};
    var iRowIndex = 0 ;    
    var RowindexNum=0;
    function doSave(obj,submittype){
     	if(!check_form(frmain,'name,prjtype')) return false;
     	var strValue="";
     	var chkFields = '<%=chkFields %>';
	   	if(chkFields!=null && chkFields!=''){
	   		str = chkFields.split(",");
	   		for(var j=0; j<str.length; j++){
	   			strValue = str[j];
	   			if(!check_form(frmain,'name,prjtype,'+strValue)) return false;
	   		}
	   	}
	   	
	   	$("#taskDataIframe")[0].contentWindow.reloadTaskTree();
	   	var taskinfo= $("#taskDataIframe").contents().find("#divTaskList").html();
	   	$("#divTaskList").html(taskinfo);
	   	//console.log(taskinfo);
	   	
		myBody.onbeforeunload=null;
   		obj.disabled = true;
   		/**var xmlDoc=document.createElement("rootTask");
   		var docDom=generaDomJson();
	 	$.toXml(docDom,xmlDoc);
   	    document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";
   	    **/
   	 if(submittype&&submittype==2){//提交
   		 $("#submittype").val("2");
   	 }else{
   		$("#submittype").val("");
   	 }
   	    
   	 if(!oUpload){
   		frmain.submit();
      }else{
      	try {
      		if(oUpload.getStats().files_queued === 0){
      			frmain.submit();
              }else {
              	oUpload.startUpload();
              }
 		} catch (e) {
 			frmain.submit();
 		}
      }
   	    
     }     
    window.onbeforeunload=function(e){
    	protectProjTemplet(e);
    }
</script>



<script type="text/javascript">
$(function(){
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(18375,user.getLanguage())%>");
	}catch(e){}
});
</script>

</body>
</html>
<script type="text/javascript">

//选择负责人
function onSelectManager(spanname,inputename){
	tmpids = $("input[name=hrmids02]").val();
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectManagerBrowser.jsp?Members="+tmpids);
	if (datas){
		if(datas.id!=""){
			$(spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$(inputename).val(datas.id);
		}else {
			$(spanname).html( "");
			$(inputename).val("");
		}
	}
}

$(document).ready(function(){
	
	$(".itemtr").live("mouseover",function(){
		$(this).addClass("tr_hover");
	}).live("mouseout",function(){
		$(this).removeClass("tr_hover");
	});;
	
});

function showdata(){
    //init_ptu();
    taskDragSort();
};

//showdata();
</script>

<script type="text/javascript">
function ItemCount_KeyPress_SandL()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
  {
     window.event.keyCode=0;
  }
}

function checknumber_SandL(objectname)
{	
	valuechar = document.all(objectname).value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	if(isnumber) document.all(objectname).value = "" ;
}



function btn_cancle(){
		//window.parent.closeDialog();
		try{
			window.parent.closeDialog();
		}catch(e){}
		
}
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
