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
String isfromProjTab = Util.null2String(request.getParameter("isfromProjTab"));
String querystr=request.getQueryString();
if(!"1".equals(isfromProjTab)){
	response.sendRedirect("/proj/data/AddProjectTab.jsp"+"?"+querystr);
	return;
}

weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("prj","PrjCardAdd");
if(CusFormSetting!=null&&CusFormSetting.getStatus()==2){//自定义布局页面
	//request.getRequestDispatcher("/proj/data/AddProject_l.jsp").forward(request, response);
	response.sendRedirect("/proj/data/AddProject_l.jsp"+"?"+querystr);
	return;
}
%>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_cus" class="weaver.conn.RecordSet" scope="page" />
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
//========================== 得到任务列表相关
String chkFields="";

boolean isOnly = Util.null2String(request.getParameter("isOnly")).equalsIgnoreCase("y") ? true : false;
String  templetName = SystemEnv.getHtmlLabelName(17907,user.getLanguage());

int templetId = Util.getIntValue(request.getParameter("templetId"));
int projTypeId = Util.getIntValue(request.getParameter("projTypeId"));   
String parentid = Util.null2String (request.getParameter("parentid"));   

    String  templetDesc = ""; 
    String  workTypeId = "";
    String  proMember = "";
    String  isMemberSee = "";
    String  proCrm = "";
    String  isCrmSee = "";
    String  parentProId = "";
    String  commentDoc = "";
    String  confirmDoc = "";
    String  adviceDoc = "";
    String  Manager = "";
    String  relationXml="";
    String  strSql = "select * from Prj_Template where id="+templetId;      
    RecordSet.executeSql(strSql);
    if (RecordSet.next()){
        templetName = Util.null2String(RecordSet.getString("templetName"));
        templetDesc = Util.null2String(RecordSet.getString("templetDesc"));
        
        if (projTypeId==-1){
            projTypeId = Util.getIntValue(RecordSet.getString("proTypeId"));
        }
        workTypeId = Util.null2String(RecordSet.getString("workTypeId"));
        proMember = Util.null2String(RecordSet.getString("proMember"));
        isMemberSee = Util.null2String(RecordSet.getString("isMemberSee"));
        proCrm = Util.null2String(RecordSet.getString("proCrm"));
        isCrmSee = Util.null2String(RecordSet.getString("isCrmSee"));
        parentProId = Util.null2String(RecordSet.getString("parentProId"));
        commentDoc = Util.null2String(RecordSet.getString("commentDoc"));
        confirmDoc = Util.null2String(RecordSet.getString("confirmDoc"));
        adviceDoc = Util.null2String(RecordSet.getString("adviceDoc"));
        Manager = Util.null2String(RecordSet.getString("Manager"));
        relationXml = Util.null2String(RecordSet.getString("relationXml"));
    }
//==========================
//==========================
String projTypeName = ProjectTypeComInfo.getProjectTypename(String.valueOf(projTypeId));
String projTypeCode = ProjectTypeComInfo.getProjectTypecode(String.valueOf(projTypeId));
String workTypeName = WorkTypeComInfo.getWorkTypename(workTypeId);
String proMemberName = ProjTempletUtil.getMemberNames(proMember);
String proCrmName = ProjTempletUtil.getCrmNames(proCrm);
String parentProName = ProjectInfoComInfo.getProjectInfoname(parentProId);
String commentDocName = DocComInfo.getDocname(commentDoc);
String confirmDocName = DocComInfo.getDocname(confirmDoc);
String adviceDocName = DocComInfo.getDocname(adviceDoc);

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

<script type="text/javascript" src="/js/projTask/TaskUtil_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<%--
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/proj/js/jquery.tablednd_wev8.js"></script>
 --%>
<script src="/js/projTask/jquery.dragsort_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskDrag_wev8.js"></script>
 

<script type="text/javascript">
var oUpload;
function impProjBase(){
	with(document.frmain){
     
		$("PrjTypeSpan").html("<%=projTypeName%>");
		$("input[name=PrjType]").val('<%=projTypeId%>');
   
        if ("<%=workTypeId%>">"0"){        
        	$("#WorkTypeSpan").html('<%=workTypeName%>');
    		$("input[name=WorkType]").val('<%=workTypeId%>');
        }
        if ("<%=proMember%>"!=""){
    		//hrmids02Span.innerHTML = '<%=proMemberName%>';
    		hrmids02.value = '<%=proMember%>';		
        }
        
         if ("<%=proCrm%>"!=""){
            PrjDescspan.innerHTML = '<a href=""><%=proCrmName%></a>';
            PrjDesc.value = '<%=proCrm%>';
        }       
		//ParentIDSpan.innerHTML = '<a href="/proj/data/ViewProject.jsp?ProjID=<%=parentProId%>"><%=parentProName%></a>';
		//ParentID.value = '<%=parentProId%>';
		//EnvDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=commentDoc%>"><%=commentDocName%></a>';
		//EnvDoc.value = '<%=commentDoc%>';
		//ConDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=confirmDoc%>"><%=confirmDocName%></a>';
		//ConDoc.value = '<%=confirmDoc%>';
		//ProDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=adviceDoc%>"><%=adviceDocName%></a>';
		//ProDoc.value = '<%=adviceDoc%>';
		<%if(isMemberSee.equals("1")){%>
		MemberOnly.checked = true;
		<%}else{%>
		MemberOnly.checked = false;
		<%}%>
		<%if(isCrmSee.equals("1")){%>
		ManagerView.checked = true;
		<%}else{%>
		ManagerView.checked = false;
		<%}%>
	}
}
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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY  style="overflow: hidden;" id="myBody" onbeforeunload="protectProj(event)" >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
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
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="submitData(this)"/>
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

<FORM id=frmain name=frmain action="/proj/data/ProjectOperation.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="method" value="add">
<input type="hidden" name="accdocids" id="accdocids" value="">
<INPUT class=inputstyle maxLength=3 size=3 name="SecuLevel" value=10 type=hidden />

<!-- 项目信息 -->
<div id="nomalDiv">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<!-- baseinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=inputstyle maxLength=50 size=50 name="name" onblur="checkLength()" onchange='checkinput("name","PrjNameimage")'><SPAN id=PrjNameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN><span id="remind" style="cursor:hand" title='<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>50(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)'><img src="/images/remind_wev8.png" align="absmiddle"  /></span></wea:item>
<%

%>		
<%
String isuse=CodeUtil.getPrjCodeUse();
if("2".equals(isuse)){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(17852,user.getLanguage())%></wea:item>
		<wea:item><input type="text"   class=InputStyle style="width:200px!important;" maxLength=50 size=30 name="procode" value=""></wea:item>
	<%
}
%>
		<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="hidden" name="prjtype" value="<%=""+projTypeId%>" />
			<%=ProjectTypeComInfo.getProjectTypename(""+projTypeId)%>
<%--			
			<brow:browser viewType="0" name="PrjType" browserValue='<%=""+projTypeId%>' browserSpanValue='<%=ProjectTypeComInfo.getProjectTypename(""+projTypeId)%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=244"  />
 --%>				
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18375,user.getLanguage())%></wea:item>
		<wea:item>
				<span id="prjTempletSpan"><%=templetName%> </span>
                <input id="protemplateid" type="hidden" name="protemplateid" value="<%=templetId%>">     
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="worktype" browserValue="" browserSpanValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=245"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="description" browserValue="" browserSpanValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=7"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15263,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT type=checkbox name="managerview" value=1  <%="1".equals( isCrmSee)?"checked":"" %> >
		</wea:item>
	</wea:group>
	
	
	<!-- manageinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(27858,user.getLanguage())%>' attributes="{}">
		<wea:item><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="parentid" browserValue='<%=parentid %>' browserSpanValue='<%=ProjectInfoComInfo.getProjectInfoname(parentid) %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=8"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" browserValue='<%=""+user.getUID()%>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(""+user.getUID()),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="hrmids02" browserValue="" browserSpanValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp"  />
		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT type=checkbox name="isblock" value=1 <%="1".equals(isMemberSee)?"checked":"" %> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="envaluedoc" 
				browserValue="" 
				browserSpanValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=9"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="confirmdoc" 
				browserValue="" 
				browserSpanValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=9"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="proposedoc" 
				browserValue="" 
				browserSpanValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=9"  />
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

String needinputitems="";
//项目类型自定义字段
if(templetId>0){
	String  sql_cus = "select * from cus_fielddata where id='"+templetId+"' and scope='ProjCustomField' and scopeid='"+projTypeId+"' ";
	RecordSet_cus.executeSql(sql_cus);
	RecordSet_cus.next();
}

CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",projTypeId);
cfm.getCustomFields4prj();
cfm.getCustomData4prj(templetId);
while(cfm.next()){
	if(cfm.isMand()){
        needinputitems += ",customfield"+cfm.getId();
    }
	String fieldvalue = "";
    if(cfm.getHtmlType().equals("2")){
    	fieldvalue = Util.toHtmltextarea(RecordSet_cus.getString(cfm.getFieldName(""+cfm.getId())));
    }else{
    	fieldvalue = Util.toHtml(RecordSet_cus.getString(cfm.getFieldName(""+cfm.getId())));
    }
    String fieldValue=fieldvalue;
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
	<wea:item><%=cfm.getLable4prj(user.getLanguage())%></wea:item>
	<wea:item>
	<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
	</wea:item>
<%}%>	
	</wea:group>
	
	
</wea:layout>





</div>
<!-- 任务列表 -->
<div id="agendaDiv" style="display:none;margin-left:0px!important;margin-top:0px!important;">
  <%--
  <jsp:include page="/proj/data/AddProjectData.jsp">
  	<jsp:param value='<%=""+templetId %>' name="templetId"/>
  </jsp:include>
   --%>
  
  <iframe id="taskDataIframe" name="taskDataIframe" src="/proj/data/AddProjectData.jsp?templetId=<%=""+templetId %>" class="flowFrame" frameborder="0" scrolling="auto" height="500px" width="100%"></iframe>
  
  <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
   <div id="divTaskList" style="display:none;"></div>
  
  
  
  
  
  
</div>
<div id="temp_seleBeforeTask_DIV" style="display:none"><select name='temp_seleBeforeTask' class='inputStyle'><option value='0'></option></select></div>
<div style="height:100px!important;"></div>
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
		Dialog.alert(errormsg);
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



function ItemCount_KeyPress_Plus()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57))
	{
		window.event.keyCode = 0;
	}
}
</script>




<script language='javaScript'>
/**************
 * 改进列表任务加载性能  for td:9891 by cyril on 2009-01-12
 */
//初始化所有前置任务
var temp_seleBeforeTask = document.getElementById("temp_seleBeforeTask");
<%
String beforTaskStr = ProjTempletUtil.getBeforeTaskStr();                               
String outStr = "var seleBefTaskObj=temp_seleBeforeTask;"+beforTaskStr+"";
out.println(outStr);
%>
var seleBeforeTask_TD = document.getElementsByName('seleBeforeTask_TD');
var temp_seleBeforeTask_DIV = document.getElementById('temp_seleBeforeTask_DIV').innerHTML;
for(i=0; i<seleBeforeTask_TD.length; i++) {
	temp_seleBeforeTask.name = 'seleBeforeTask';
	temp_seleBeforeTask.id = 'seleBeforeTask_'+(i+1);
	seleBeforeTask_TD[i].innerHTML = replaceStr(i);
}

//拼成SELECT
function replaceStr(id) {
	id++;
	var str = temp_seleBeforeTask_DIV;
	var len = str.length;
	var spchar = 'temp_seleBeforeTask';
	var sp = str.indexOf(spchar);
	str = str.substring(0, sp)+str.substring(sp+5, len);
	str = str.substring(0, 7)+' id=seleBeforeTask_'+id+' onchange=onBeforeTaskChange(this,'+id+') '+str.substring(7, len);
	return str;
}

//处理前置任务
var befTaskObj = document.getElementsByName('seleBeforeTask');
<%
ArrayList befTaskSeleList =  ProjTempletUtil.getBefTaskSeleList();
for (int k=0;k<befTaskSeleList.size();k++){
    String[] paras = (String[])befTaskSeleList.get(k);
    String rowIndex = paras[0];
    String befTaskValue = paras[1];
    String outStr2 = "befTaskObj["+k+"].value='"+befTaskValue+"'";
    out.println(outStr2);
}
%>
//初始化任务负责人多选框
var objManagers = document.getElementsByName("txtManager");
for (i=0;i<objManagers.length;i++){
	var objManager=objManagers[i];
<%
    String[]  members = Util.TokenizerString2(proMember,",");
    for (int h=0;h<members.length;h++) {
        String member = members[h];
         String outStr3 = "objManager.options.add(new Option('"+ResourceComInfo.getLastname(member)+"','"+member+"'))";
         out.println(outStr3);
    }
%>
}
//处理负责人数据
var taskObj = document.getElementsByName("txtManager");
<%	
    ArrayList taskManagerList =  ProjTempletUtil.getTaskManagerList();
  
    for (int j=0;j<taskManagerList.size();j++){
        String[] paras = (String[])taskManagerList.get(j);
        String rowIndex = paras[0];
        String taskManagerValue = paras[1];
        String outStr4 = "taskObj["+j+"].value='"+taskManagerValue+"'";
         out.println(outStr4);
    }
%>
</script>


<script language="javaScript">
//此处为合并时需要注意的地方
var ptu = null;
var iRowIndex = null;
var RowindexNum = null;

function init_ptu() {
    //初始化input框 的宽度
    iRowIndex = document.getElementById("task_iRowIndex").value;
    RowindexNum = document.getElementById("task_RowindexNum").value;
} 
   
function checkLength(){
	tmpvalue = $("input[name=PrjName]").val();
	if(realLength(tmpvalue)>50){
		while(true){
			tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
			if(realLength(tmpvalue)<=50){
				$("input[name=PrjName]").val(tmpvalue);
				return;
			}
		}
	}
}


function submitData(obj){
    if(!check_form(frmain,'name,prjtype,hrmids02,manager')) return false;
    var chkFields = '<%=chkFields %>';
   	if(chkFields!=null && chkFields!=''){
   		var str = chkFields.split(",");
   		for(var j=0; j<str.length; j++){
   			var strValue = str[j];
   			if(!checkFields(strValue)) return false;
   		}
   	}
   	
   	$("#taskDataIframe")[0].contentWindow.reloadTaskTree();
   	var taskinfo= $("#taskDataIframe").contents().find("#divTaskList").html();
   	$("#divTaskList").html(taskinfo);
   	//console.log(taskinfo);
   	
   	
    obj.disabled = true;
 	/**var xmlDoc=document.createElement("rootTask");
 	var docDom=generaDomJson();
 	$.toXml(docDom,xmlDoc);
    document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";
    **/
    myBody.onbeforeunload=null;
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



//初始化前置任务值
function init_beforTaskStr() {
	var taskArr = new Array();
	var txtTaskNames = document.getElementsByName("txtTaskName");
	for (i=1;i<=txtTaskNames.length;i++){
		taskArr[i-1] = txtTaskNames[i-1].value;
	}
	var seleBeforeTasks = document.getElementsByName("seleBeforeTask");
	for (i=1;i<=seleBeforeTasks.length;i++){
		try {
			if(seleBeforeTasks[i-1].value!=""&&seleBeforeTasks[i-1].value!="0") {

				document.getElementById('seleBeforeTaskSpan_'+i).innerHTML = taskArr[$('input[name=templetTaskId_'+seleBeforeTasks[i-1].value+"]").val()];
	   			seleBeforeTasks[i-1].value = $('input[name=templetTaskId_'+seleBeforeTasks[i-1].value+"]").val()*1+1;
	   			
			}
		}catch(e){
		}
	}
}
$(function(){
	//impProjBase();
});
</script>





</body>
</html>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(){
    var ajax=ajaxinit();
    ajax.open("POST", "AddProjectData.jsp?templetId=<%=templetId%>", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send(null);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.getElementById('TaskDataDIV').innerHTML = ajax.responseText;
                initPrjTaskObj();
                init_beforTaskStr();
                init_ptu();
                taskDragSort();
            }catch(e){
                return false;
            }
        }
    }
}

$(document).ready(function(){
	/**
	$(".itemtr").live("mouseover",function(){
		$(this).addClass("tr_hover");
	}).live("mouseout",function(){
		$(this).removeClass("tr_hover");
	});;
	**/
});

//showdata();

</script>

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

//判断SecuLevel 和LabourP input框中是否输入的是数字
//added by hubo, 2005/08/31
//edit by zfh,20111212
function onShowPrjTemplet(){
	var currentProjType = document.getElementById("PrjType");
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Templet/TempletBrowser.jsp?projTypeID="+$(currentProjType).val(),"dialogArguments=342342");
	if (datas){
		if(datas.id!=""){
			templetID = datas.id;
			templetName = datas.name;
			location.href = "/proj/data/AddProject.jsp?projTypeId="+$(currentProjType).val()+"&templetId="+templetID;
		}
	}
}
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
</script>

<script language="javascript">


function onShowMProj(spanname,inputname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (datas){
	if(datas.id){
		$($GetEle(spanname)).html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"' target=_blank>"+datas.name+"</A>");
		$GetEle(inputname).value=datas.id;
	}else {
		$($GetEle(spanname)).empty();
		$GetEle(inputname).value="0"
	}}
}

function onShowHrm(spanname,inputename,needinput){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (datas){
		if(datas.id){
			$($GetEle(spanname)).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"' target=_blank>"+datas.name+"</A>");
			$GetEle(inputename).value=datas.id;
		}else{ 
			if(needinput == "1"){
				$($GetEle(spanname)).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
				$($GetEle(spanname)).html("");
			}
		
			$GetEle(inputename).value=""
		}
	}
}
function onShowProjectID(objval){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (datas){
		if(datas.id){
			$("#projectidspan").html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"' target=_blank>"+datas.name+"</A>");
			frmain.projectid.value=datas.id;
		}else{ 
			if(objval=="2"){
				$("#projectidspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
				$("#projectidspan").html("");
			}
			frmain.projectid.value="0";
		}
	}
}


function onShowMeetingHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
	    if(datas){
	        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
		         	Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
					return;
			 }else if(datas.id){
				resourceids = datas.id;
				resourcename =datas.name;
				sHtml = "";
				resourceids=resourceids.substr(1);
				resourceids =resourceids.split(",");
				$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr(1):resourceids;
				resourcename =resourcename.substr(1);
				resourcename =resourcename.split(",");
				for(var i=0;i<resourceids.length;i++){
					if(resourceids[i]&&resourcename[i]){
						sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
					}
				}
				$("#"+spanname).html(sHtml);
	        }else{
				$GetEle(inputename).value="";
				$($GetEle(spanname)).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	        }
	    }
}
function onShowMHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
    if(datas){
        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
	         	Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
				return;
		 }else if(datas.id){
			resourceids = datas.id;
			resourcename =datas.name;
			sHtml = "";
			resourceids =resourceids.split(",");
			$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr("1"):resourceids;
			resourcename =resourcename.split(",");
			for(var i=0;i<resourceids.length;i++){
				if(resourceids[i]&&resourcename[i]){
					sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
				}
			}
			$("#"+spanname).html(sHtml);
        }else{
			$GetEle(inputename).value="";
			$($GetEle(spanname)).html("");
        }
    }
 }

function onShowMCrm(spanname,inputename){
			tmpids = $GetEle(inputename).value;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+tmpids);
		    if(datas){
		        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
			         	Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
						return;
				 }else if(datas.id!=""){
					resourceids = datas.id.substr(1);
					resourcename =datas.name.substr(1);
					sHtml = "";
					$GetEle(inputename).value= resourceids;
					//$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr(1):resourceids;
					resourceids =resourceids.split(",");
					resourcename =resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]&&resourcename[i]){
							sHtml = sHtml+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+resourceids[i]+" target=_blank>"+resourcename[i]+"</a>&nbsp"
						}
					}
					$("#"+spanname).html(sHtml);
		        }else{
					$GetEle(inputename).value="";
					$($GetEle(spanname)).html("");
		        }
		    }
}


function onShowMHrm(spanname,inputename){
			tmpids = $GetEle(inputename).value;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
		    if(datas){
		        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
			         	Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
						return;
				 }else if(datas.id){
					resourceids = datas.id;
					resourcename =datas.name;
					sHtml = "";
					resourceids =resourceids.split(",");
					$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr("1"):resourceids;
					resourcename =resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]&&resourcename[i]){
							sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
						}
					}
					$("#"+spanname).html(sHtml);
		        }else{
					$GetEle(inputename).value="";
					$($GetEle(spanname)).html("");
		        }
		    }
}




function btn_cancle(){
		window.parent.closeDialog();
	}
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
