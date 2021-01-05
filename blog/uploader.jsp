
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.DesUtil"%>
<%
  DesUtil desUtil=new DesUtil();
%>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
	
<script language="javascript">

function bindUploaderDiv(targetObj,relateaccName,editorId){

	var maxsize=targetObj.attr("maxsize");
	var mainId=targetObj.attr("mainId");
	var subId=targetObj.attr("subId");
	var secId=targetObj.attr("secId");
	
	var d=new Date();
	var indexid="index_"+d.getSeconds()+d.getMilliseconds();
	targetObj.attr("oUploaderIndex","oUploader_"+indexid);
	
	targetObj.html(
		"<input id='relateAccDocids_"+indexid+"' type='hidden' name='"+relateaccName+"'>"+
	   "<div>"+
			"<span>"+ 
				 "<span id='btnSelectedAcc_"+indexid+"'></span>"+
			"</span>"+		
		"</div>"+
		"<div class='fieldset flash' style='width:240px;position:absolute;z-index:100' id='fsUploadProgress_"+indexid+"'></div>"+
		"<div id='divStatus_"+indexid+"'></div>");
		
	   window["oUploader_"+indexid]=getUploader(indexid,maxsize,mainId,subId,secId,editorId);
	   //alert( window["oUploader_"+indexid]);
}

function getUploader(indexid,maxsize,mainId,subId,secId,editorId){
    maxsize=(maxsize==0?5:maxsize);
	var oUploader=null; 
	try{
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
		    post_params: {
				mainId:mainId,
				subId:subId,
				secId:secId,
				userid:'<%=desUtil.encrypt(""+user.getUID())%>',
				language:'<%=user.getLanguage()%>',
				logintype:'<%=user.getLogintype()%>',
				departmentid:'<%=user.getUserDepartment()%>'  
		    },        
			upload_url: "/blog/uploaderOperate.jsp",
			file_size_limit : maxsize+" MB",
			file_types : "*.*",
			file_types_description : "All Files",
			file_upload_limit : "50",
			file_queue_limit : "0",
			custom_settings : {
		    	progressTarget : "fsUploadProgress_"+indexid
			},
			debug: false,
			
			button_image_url : "/blog/images/app-attach_wev8.png",	// Relative to the SWF file
			button_placeholder_id : "btnSelectedAcc_"+indexid,
	
			button_width: 125,
			button_height: 18,
			button_text : '<span class="button">附件('+maxsize+'MB)</span>', 
			button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt;color:#1d76a4 } .buttonSmall { font-size: 10pt; }',
			button_text_top_padding: 0,
			button_text_left_padding: 18,
				
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			
			file_queued_handler : fileQueued,
			file_queue_error_handler : fileQueueError,				
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
				if (numFilesSelected > 0) {		
					//document.getElementById("btnCancel_upload_"+indexid).disabled = false;
					//fileDialogComplete	
					if(KE.g[editorId].designMode){	
					   jQuery("#fsUploadProgress_"+indexid).show();
					   this.startUpload();
					}else
					   alert("请将编辑器切换到可视化模式！");    
					//var oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];	
					//oUploader.startUpload();						
				}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,			
			upload_error_handler : uploadError,
			queue_complete_handler : queueComplete,
	
			upload_success_handler : function (file, server_data) {
				KE.insertHtml(editorId,server_data);
			},				
			upload_complete_handler : function(file){
			   if(this.getStats().files_queued==0){
			      jQuery("#fsUploadProgress_"+indexid).html(""); //清空上传进度条 
			      //jQuery("#fsUploadProgress_"+indexid).hide();
			   }  
			}
		};
		oUploader = new SWFUpload(settings);
	} catch(e){alert(e)}
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
	//alert("<%=SystemEnv.getHtmlLabelName(24495,user.getLanguage())%>!");
}

</script>

<div id="divStatus" style="display:none"></div>