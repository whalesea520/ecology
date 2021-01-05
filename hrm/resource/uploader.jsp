
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.DesUtil"%>
<%
  DesUtil desUtil=new DesUtil();
%>
<!-- 人力资源模块之附件上传 -->
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
	
<script type="text/javascript">
function bindUploaderDiv(targetObj,relateaccName){
	var maxsize=targetObj.attr("maxsize")||0;
	var resourceId=targetObj.attr("resourceId")||0;
	var scopeId=targetObj.attr("scopeId")||0;
	var fieldId=targetObj.attr("fieldId")||0
	var uploadLimit=targetObj.attr("uploadLimit")||50;
	if(resourceId=="")
	{
		window.top.Dialog.alert("resourceId<%=SystemEnv.getHtmlLabelName(83811,user.getLanguage())%>");
		return;
	} 
	var needDel = true;
	if(relateaccName=="birthdaySetting")needDel=false;
	var d=new Date();
	var indexid="index_"+d.getSeconds()+d.getMilliseconds()+fieldId;
	targetObj.attr("oUploaderIndex","oUploader_"+indexid);
	var html="<input id='relateAccDocids_"+indexid+"' type='hidden' name='"+relateaccName+"'>"+
	   "<div>"+
			"<span>"+ 
				 "<span id='btnSelectedAcc_"+indexid+"'></span>"+
			"</span>";		
			if(needDel){
				html+="<span class='btnCancel_upload' style='color: #262626; cursor: hand; TEXT-DECORATION: none' disabled id='btnCancel_upload_"+indexid+"' onClick='oUploader_"+indexid+".cancelQueue()'>"+
			 	 "<span>"+
			 	 	"<img src='/cowork/images/delete_wev8.gif' border='0'>"+
			 	 "</span>"+
				 "<span style='height: 19px'><font style='margin: 0 0 0 -1;font-size:12px'><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font></span>"+
			"</span>";
			}
		html+="<SPAN id=uploadspan style='height: 19px'>(<%=SystemEnv.getHtmlLabelName(83076,user.getLanguage())%>="+maxsize+" <%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%> " ;
		if(relateaccName=="birthdaySetting"){
			html+=" <%=SystemEnv.getHtmlLabelName(83814,user.getLanguage())%>:475px, <%=SystemEnv.getHtmlLabelName(83817,user.getLanguage())%>:500px";
		}
		html+= ")</SPAN>"+
		"</div>"+
		"<div class='fieldset flash' id='fsUploadProgress_"+indexid+"'></div>"+
		"<div id='divStatus_"+indexid+"'></div>";
	  	targetObj.html(html);
	  	window["oUploader_"+indexid]=getUploader(indexid,maxsize,resourceId,scopeId,fieldId,uploadLimit);
}

function getUploader(indexid,maxsize,resourceId,scopeId,fieldId,uploadLimit){
    maxsize=(maxsize==0?5:maxsize);
	var oUploader=null;
	try{  
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
		    post_params: {
		    cmd:"save",
	    	resourceId:resourceId,
	    	scopeId:scopeId,
	    	fieldId:fieldId,
				userid:'<%=desUtil.encrypt(""+user.getUID())%>',
				language:'<%=user.getLanguage()%>',
				logintype:'<%=user.getLogintype()%>',
				departmentid:'<%=user.getUserDepartment()%>'
		    },        
			upload_url: "/hrm/resource/uploaderOperate.jsp",
			file_size_limit : maxsize+" MB",
			file_types : "*.*",
			file_types_description : "All Files",
			file_upload_limit : uploadLimit,
			file_queue_limit : "0",
			custom_settings : {
		    	progressTarget : "fsUploadProgress_"+indexid,
				cancelButtonId : "btnCancel_upload_"+indexid		
			},
			debug: false,
			
			button_image_url : "/cowork/images/add_wev8.png",	// Relative to the SWF file
			button_placeholder_id : "btnSelectedAcc_"+indexid,
	
			button_width: 100,
			button_height: 18,
			button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
			button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
			button_text_top_padding: 0, 
			button_text_left_padding: 18,
				
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			
			file_queued_handler : function(file){
				try {
					var progress = new FileProgress(file, this.customSettings.progressTarget);
					progress.setStatus("文件已选择");
					progress.toggleCancel(true, this);
				} catch (ex) {
					this.debug(ex);
				}
			},
			file_queue_error_handler : fileQueueError,				
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){	
				if (numFilesSelected > 0) {
					var uploadobj = document.getElementById("btnCancel_upload_"+indexid);
					if(uploadobj != null){
						uploadobj.disabled = false;
					}
					//document.getElementById("btnCancel_upload_"+indexid).disabled = false;
					fileDialogComplete;
					//this.startUpload();							
				}
				
				try{
					 if(this.getStats().files_queued>0){
					 	jQuery("#customfield"+fieldId).val(this.getStats().files_queued);
					 }else{
					 	jQuery("#customfield"+fieldId).val("");
					 }
					 checkinput("customfield"+fieldId,"customfield"+fieldId+"span");
				}catch(e){}
				try{
					 afterChooseFile(jQuery("#divStatus_"+indexid).parents(".uploadfield")[0],this.getStats().files_queued);
				}catch(e){}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,			
			upload_error_handler : uploadError,
			queue_complete_handler : queueComplete,
	
			upload_success_handler : function (file, server_data) {	
				//var o=jQuery("#relateAccDocids_"+indexid);
				//o.val(o.val()+jQuery.trim(server_data)+",")
			},				
			upload_complete_handler : function(file){
				upfilesnum--;
				try {
					if (upfilesnum == 0) {	
						doSaveAfterAccUpload();
					} else {	
						this.startUpload();
					}
				} catch (ex) { window.top.Dialog.alert(ex); }
			}
		};
			oUploader = new SWFUpload(settings);
	} catch(e){window.top.Dialog.alert(e)}
	return oUploader;
}




function flashChecker() {
	var hasFlash = 0; //是否安装了flash
	var flashVersion = 0; //flash版本
	var isIE = /*@cc_on!@*/0; //是否IE浏览器

	if (isIE) {
		var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
		if (swf) {
			hasFlash = 1;
			VSwf = swf.GetVariable("$version");
			flashVersion = parseInt(VSwf.split(" ")[1].split(",")[0]);
		}
	} else {
		if (navigator.plugins && navigator.plugins.length > 0) {
			var swf = navigator.plugins["Shockwave Flash"];
			if (swf) {
				hasFlash = 1;
				var words = swf.description.split(" ");
				for ( var i = 0; i < words.length; ++i) {
					if (isNaN(parseInt(words[i])))
						continue;
					flashVersion = parseInt(words[i]);
				}
			}
		}
	}
	return {
		f :hasFlash,
		v :flashVersion
	};
}
var fls = flashChecker();
var flashversion = 0;
if (fls.f) {
	flashversion = fls.v;
}
if (flashversion < 9){
	//window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24495,user.getLanguage())%>!");
}

</script>

<div id="divStatus" style="display:none"></div>