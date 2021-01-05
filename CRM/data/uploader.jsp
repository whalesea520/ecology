
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- 人力资源模块之附件上传 -->
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
	
<script type="text/javascript">

/**
*** primaryKeyId 对应的主键值,为空则为添加，不为空，则为编辑
**/
function bindUploaderDiv(targetObj,primaryKeyId){
	var maxsize=targetObj.attr("maxsize");
	var uploadLimit=targetObj.attr("uploadLimit");
	var usetable=targetObj.attr("usetable");
	var fieldName = targetObj.attr("fieldName");
	var fieldNameSpan = targetObj.attr("fieldNameSpan");
	
	var d=new Date();
	var indexid="index_"+d.getSeconds()+d.getMilliseconds();
	targetObj.attr("oUploaderIndex","oUploader_"+indexid);
	targetObj.html(
	   "<input type='hidden' name="+fieldName+" id="+fieldName+">"+
	   "<div>"+
			"<span>"+ 
				 "<span id='btnSelectedAcc_"+indexid+"'></span>"+
			"</span>"+		
			"<SPAN id=uploadspan style='height: 19px'></SPAN>"+
		"</div>"+
		"<div class='fieldset flash' id='fsUploadProgress_"+indexid+"'></div>"+
		"<div id='divStatus_"+indexid+"'></div>");
	  
	  	if(primaryKeyId==null || primaryKeyId == ""){
	  		window["oUploader_"+indexid]=getUploaderAdd(fieldName ,fieldNameSpan, indexid,maxsize,uploadLimit);
	  	}else{
	  		window["oUploader_"+indexid]=getUploaderEdit(usetable,fieldName,fieldNameSpan,primaryKeyId,indexid,maxsize,uploadLimit);
	  	}
	  	
}
/**
** 添加时候调用
**/

function getUploaderAdd(fieldName , fieldNameSpan,indexid,maxsize,uploadLimit){
	var oUploader=null;
	try{  
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
		    post_params: {
				method:"add"
		    },        
			upload_url: "/CRM/data/uploaderOperate.jsp",
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
	
			button_width: 50,
			button_height: 18,
			button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%></span>',
			button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
			button_text_top_padding: 0, 
			button_text_left_padding: 18,
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			
			file_queued_handler : fileQueued,
			file_queue_error_handler : fileQueueError,				
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
				
				if (numFilesSelected > 0) {	
					jQuery("#"+fieldNameSpan).html("");	
					document.getElementById("btnCancel_upload_"+indexid).disabled = false;
					fileDialogComplete;
					//this.startUpload();							
				}
				 
				try{
					 afterChooseFile(jQuery("#divStatus_"+indexid).parents(".uploadfield")[0],this.getStats().files_queued);
					
				}catch(e){}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,			
			upload_error_handler : uploadError,
			queue_complete_handler : queueComplete,
	
			upload_success_handler : function (file, server_data) {	
				var o=jQuery("input[name='"+fieldName+"']");
				if(jQuery.trim(o.val()) != ""){
					o.val(o.val()+","+jQuery.trim(server_data));
				}else{
					o.val(jQuery.trim(server_data));
				}
				
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

function getUploaderEdit(usetable,fieldName,fieldNameSpan,primaryKeyId,indexid,maxsize,uploadLimit){
	var oUploader=null;
	try{
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
		    post_params: {
				usetable:usetable,
				fieldName:fieldName,
				primaryKeyId:primaryKeyId,
				method:"edit"
		    },        
			upload_url: "/CRM/data/uploaderOperate.jsp",
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
			
			file_queued_handler : fileQueued,
			file_queue_error_handler : fileQueueError,				
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){
				jQuery("#"+fieldNameSpan).html("");	
				if (numFilesSelected > 0) {		
					jQuery("#fsUploadProgress_"+indexid).show();
					this.startUpload();		
				}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,			
			upload_error_handler : uploadError,
			queue_complete_handler : queueComplete,
	
			upload_success_handler : function (file, server_data) {	
			
				var docid = jQuery.trim(server_data);
				var filename = file.name;
				var filesize = (file.size/1024).toFixed(2);
				var info ="<div class='txtlink txtlink"+docid+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
				info+="<div style='float: left;'>"
				info+=filename+"&nbsp;<a href='/weaver/weaver.file.FileDownload?fileid="+docid+"&download=1'><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>("+filesize+"K)</a>";
				info+="</div>";
				info+="<div class='btn_del' onclick=exeUpdate('"+fieldName+"','','attachment',"+docid+")></div>";
				info+="<div class='btn_wh'></div>";
				info+="</div>";
				$("div[fieldName='"+fieldName+"']").children("div:eq(0)").append($.trim(info));
				$("#fsUploadProgress_"+indexid).remove();
				setLastUpdate();
				
			},				
			upload_complete_handler : function(file){				 
				if(this.getStats().files_queued==0){
				
				}  
			}
		};
		oUploader = new SWFUpload(settings);
	} catch(e){}
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
	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24495,user.getLanguage())%>!");
}

</script>

<div id="divStatus" style="display:none"></div>