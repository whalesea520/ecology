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
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
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
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjCardGroupComInfo" scope="page" />
<%  
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
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>

<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>

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
<style type="text/css">
.spanSwitch{cursor:pointer;font-weight:bold}
#tblTask table td{padding:0;}
.e8_os{width:30%!important;}
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

<%
int fieldcount=0;//用来定位字段
int fieldsize=0;//用来定位字段数量
int groupcount=0;//用来定位组
String needHideField=",passnoworktime,";//用来隐藏字段

%>

<wea:layout  attributes="{'expandAllGroup':'true'}">
<%


TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(projTypeId);
CptCardGroupComInfo.setTofirstRow();
while(CptCardGroupComInfo.next()){
	String groupid=CptCardGroupComInfo.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
	groupcount++;
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
if(!openfieldMap.isEmpty()){
	fieldsize=openfieldMap.size();
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		fieldcount++;
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		//JSONObject v= (JSONObject)entry.getValue().clone() ;
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldlabel=v.getInt("fieldlabel");
		String fieldid=v.getString("id");
		int fieldhtmltype=v.getInt("fieldhtmltype");
		String fielddbtype = v.getString("fielddbtype");
		int type=v.getInt("type");
		int ismand=v.getInt("ismand");
		int issystem=v.getInt("issystem");
		String fieldName=v.getString("fieldname");
		if(!"name".equalsIgnoreCase(fieldName)){
			v.put("ismand", "0");
		}
		String fieldkind=v.getString("fieldkind");
		if("2".equals(fieldkind)){
			fieldName="customfield"+fieldid.replace("prjtype_", "");
			v.put("id", fieldid.replace("prjtype_", ""));
		}
		String fieldValue="";
		if("members".equals( fieldName)){//项目成员原有特殊逻辑,不能改原来展现的元素名
			fieldName="hrmids02";
			v.put("fieldname", "hrmids02");
		}else if("department".equals(fieldName)){//部门字段不需要
			continue;
		}else if("procode".equals(fieldName)){//项目编码字段不需要
			continue;
		}else if("status".equals(fieldName)){//项目编码字段不需要
			continue;
		}else if("protemplateid".equals(fieldName)){//项目编码字段不需要
			continue;
		}
		//System.out.println("fieldName2:"+fieldName);
		String hideField="{}";
		if(needHideField.indexOf(","+fieldName+",")!=-1){
			hideField="{'samePair':'hideField'}";
		}
		
		
		
		
	%>
	<wea:item attributes='<%=hideField %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=hideField %>'>
		<%
		if("prjtype".equals(fieldName)){
			%>
			<%=ProjectTypeComInfo.getProjectTypename(projTypeId) %>
			<input type="hidden" name=prjtype value="<%=projTypeId %>" />
			<%
		}else{		
			if(fieldhtmltype==3&&(type==161||type==162||type==256||type==257)){
				String showname = "";
				String urls= "";
				if(type==161||type==162){
					showname=PrjFieldManager.getBrowserFieldvalue(user,fieldValue, type, fielddbtype,false);
					urls=BrowserComInfo.getBrowserurl(""+type)+"?type="+fielddbtype;     // 浏览按钮弹出页面的
				}else{
					CustomTreeUtil customTreeUtil = new CustomTreeUtil();
			   	  	showname = customTreeUtil.getTreeFieldShowName(fieldValue,fielddbtype);
			   	  	urls=BrowserComInfo.getBrowserurl(""+type)+"?type="+fielddbtype+"_"+type;     // 浏览按钮弹出页面的url
				}
				String andChar="?";
				String isMustInput = "1" ; 
				String isSingleStr = "true";//单选
			    if(type==162||type==257){
			    	isSingleStr = "false";
			    }
				String showfieldname=1==issystem?fieldid:"field"+fieldid;
				if("2".equals(fieldkind)){//项目类型自定义字段的元素名
					showfieldname="customfield"+fieldid.replace("prjtype_", "");
				}
				String browserOnClick = "onShowBrowserCustom('"+showfieldname+"','"+urls+"','"+type+"','"+isMustInput+"')";
			%>
				<brow:browser viewType="0" name='<%=showfieldname%>' browserValue='<%=fieldValue%>' 
							 completeUrl='' width="500px" 
							browserOnClick="<%=browserOnClick%>" hasInput="true" isSingle="<%=isSingleStr%>" hasBrowser = "true" isMustInput="<%=isMustInput%>"
							idSplitFlag="," nameSplitFlag=","
							browserSpanValue='<%=showname%>'>
						</brow:browser>
						<input type=hidden name="<%=showfieldname%>_name" value="<%=showname%>">
			<%}else{ %>
				<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
			<%}%>
			<%
		}
		%>
		
	</wea:item>
	<%
	
	if(false&&fieldcount==fieldsize && groupcount==1 && PrjSettingsComInfo.getPrj_acc()){//附件位置
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
	
	<%
	}
}

%>
</wea:group>
	<%
}
%>

	
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
	   	
	   	$("#taskDataIframe")[0].contentWindow.reloadTaskTree();
	   	var taskinfo= $("#taskDataIframe").contents().find("#divTaskList").html();
	   	$("#divTaskList").html(taskinfo);
	   	
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

<script type="text/javascript">
jQuery(function(){
	hideEle('hideField');
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

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowBrowserCustom(id, url, type1,isMustInput) {
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle(id).value;
		url = url + "&selectedids=" + tmpids;
		url+="&iscustom=1";
	}else{
		tmpids = $GetEle(id).value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		url+="&iscustom=1";
	}
	var dialogurl = url;
	var prjdialog = new window.top.Dialog();
	prjdialog.currentWindow = window;
	prjdialog.URL = dialogurl;
	prjdialog.callbackfun = function (paramobj, id1) {
	
		if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				$G(id + "span").innerHTML = wrapshowhtml("<a title='" + names + "'>" + names + "</a>&nbsp",ids,1);
				$G(id).value = ids;
				$G(id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split(",");
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}

					sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
				}

				$G(id + "span").innerHTML = sHtml;
				$G(id).value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G(id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			if (type1 == 256||type1 == 257) {
				$G(id + "span").innerHTML =  names ;
				$G(id).value = ids;
				$G(id + "_name").value = names;
			}
			if (isMustInput == 2) {
				jQuery("#"+id+"spanimg").html("");
			}
		} else {
			$G(id + "span").innerHTML = "";
			$G(id).value = "";
			$G(id + "_name").value = "";
			if(isMustInput == 2){
				jQuery("#"+id+"spanimg").html("<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
			}
		}
	}
		
	hoverShowNameSpan(".e8_showNameClass");
	   
	};
	
	prjdialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	prjdialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		prjdialog.Width=648; 
	}
	prjdialog.Height = 600;
	prjdialog.Drag = true;
	prjdialog.show();

}

function wrapshowhtml(ahtml, id,ismast) {
	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	var mastinput = 1;//2：必须输入 ；1：可编辑
	if(ismast){
		mastinput = ismast;
	}
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this,"+mastinput+",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function openHrefWithChinese(url){
    url = dealChineseOfFieldParams(url);
    window.open(url);
}

//encodeURIComponent
function dealChineseOfFieldParams(url){
	if(url.indexOf("/workflow/request/AddRequest.jsp")==-1 && url.indexOf("/formmode/view/AddFormMode.jsp") != 0) {
		return url;
	}
	var params = "";
	var path = url.substring(0,url.indexOf("?")+1);
	var filedparams = url.substring(url.indexOf("?")+1);
	var fieldparam = filedparams.split("&");
	 for(var i=0;i<fieldparam.length;i++) {
		var tmpindex = fieldparam[i].indexOf("=");
		if(tmpindex != -1) {
			var key = fieldparam[i].substring(0, tmpindex);
			var value = encodeURIComponent(fieldparam[i].substring(tmpindex+1));
			params+="&"+key+"="+value
		}
	} 
	return path+params.substring(1);
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
<script type="text/javascript">
function onShowTime(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	/*var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}*/
	
	var th = $ele4p(spanname);
	var ttop  = $ele4p(spanname).offsetTop; 
	var thei  = $ele4p(spanname).clientHeight;
	var tleft = $ele4p(spanname).offsetLeft; 
	var ttyp  = $ele4p(spanname).type;    
	while (spanname = $ele4p(spanname).offsetParent){
		ttop += $ele4p(spanname).offsetTop; 
		tleft += $ele4p(spanname).offsetLeft;
	}
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei - 50)+"px";
	dads.top = (jQuery(th).offset().top+8)+"px";
	//dads.left = (tleft - 5)+"px";
	dads.left = jQuery(th).offset().left+"px";
	
	
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei + 22)+"px";
	//dads.left = tleft+"px";
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}
</script>
<script language=javascript src="/proj/js/common_wev8.js"></script>
