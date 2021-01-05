
<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>

<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/messager/resource-cn_wev8.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/messager/resource-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/messager/resource-tw_wev8.js'></script>
<%}%>

<style>
.progressContainer,.red,.green,.blue  {
	
	border-left:0px;
	border-right:0px;
	border-top:0px;
}</style>
<script language="javascript">

FileProgress.prototype.setComplete = function () {
	this.fileProgressElement.className = "progressContainer blue";
	this.fileProgressElement.childNodes[3].className = "progressBarComplete";
	this.fileProgressElement.childNodes[3].style.width = "";
};

function getUploader(objWindow,windowid,sendTo){
	var oUploader=null;
	try{
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
		    post_params: {
		        "isNeedCreateDoc": "0",
		        sendTo:sendTo
		    },        
			upload_url: "/messager/DocUploader.jsp",
			file_size_limit : Config.MaxUploadImageSize+" MB",
			file_types : "*.*",
			file_types_description : "All Files",
			file_upload_limit : "50",
			file_queue_limit : "0",
			custom_settings : {
				index:1
				//progressTarget : "fsUploadProgress_"+windowid				
			},
			debug: false,
			
			button_image_url : "/messager/images/add_wev8.png",	// Relative to the SWF file
			button_placeholder_id : "btnSelectedAcc_"+windowid,
	
			button_width: 125,
			button_height: 18,
			button_text : '<span class="button">'+rMsg.sendAccs+'('+Config.MaxUploadImageSize+' MB)</span>',
			button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
			button_text_top_padding: 0,
			button_text_left_padding: 18,
				
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			
			//file_queued_handler : fileQueued,
			file_queued_handler : function(file) {
				try {
					var roundNum=new Date().getTime();
					var divUploadId="fsUploadProgress_"+windowid+"_"+roundNum;
					objWindow.setCusData("divUploadId",divUploadId);
					var divUploaderShow="<div class='fieldset flash' id='"+divUploadId+"' style='width:220px;overflow:auto;'/>" ;					
					objWindow.showMessage(divUploaderShow,"me");
					
					
					var progress = new FileProgress(file,divUploadId);
					progress.setStatus("Pending...");
					progress.toggleCancel(true, this);
					
				} catch (ex) {
					this.debug(ex);
				}

			},
			file_queue_error_handler : function(file, errorCode, message) {
				try {
					if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
						alert("You have attempted to queue too many files.\n" + (message === 0 ? "You have reached the upload limit." : "You may select " + (message > 1 ? "up to " + message + " files." : "one file.")));
						return;
					}


					var roundNum=new Date().getTime();
					var divUploadId="fsUploadProgress_"+windowid+"_"+roundNum;
					objWindow.setCusData("divUploadId",divUploadId);
					var divUploaderShow="<div class='fieldset flash' id='"+divUploadId+"' style='width:220px;overflow:auto;'/>" ;					
					objWindow.showMessage(divUploaderShow,"me");

					var progress = new FileProgress(file, divUploadId);
					progress.setError();
					progress.toggleCancel(false);

					switch (errorCode) {
					case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
						progress.setStatus("File is too big.");
						this.debug("Error Code: File too big, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
						break;
					case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
						progress.setStatus("Cannot upload Zero Byte files.");
						this.debug("Error Code: Zero byte file, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
						break;
					case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
						progress.setStatus("Invalid File Type.");
						this.debug("Error Code: Invalid File Type, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
						break;
					default:
						if (file !== null) {
							progress.setStatus("Unhandled Error");
						}
						this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
						break;
					}
				} catch (ex) {
			        this.debug(ex);
			    }
			},
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
				if (numFilesSelected > 0) {		
					/*if(window.confirm("是否同时保存为文档附件?")){
						this.settings.post_params.isNeedCreateDoc="1";
						alert(this.settings.post_params.isNeedCreateDoc)
					}	*/					
					
					this.startUpload();						
				}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,			
			upload_error_handler : uploadError,
			queue_complete_handler : queueComplete,
	
			upload_success_handler : function (file, server_data) {				
				eval("var data="+$.trim(server_data))		
				var strSend="";
				if(data.type=="docid"){
					strSend="<div style='border-bottom:1px solid #CEE2F2;margin:3;padding:3;background:#F0F5FF;width:220px;word-break:break-all' class='messagerA'>"+rMsg.sendFile+
					file.name+"<br><a href='void(0)' onClick='window.open(\"/docs/docs/DocDsp.jsp?id="+data.value
					+"&download=1&isOpenFirstAss=1\");return false'>"+rMsg.clickDownload+"</a><br>("+rMsg.fileShareToYou+")</div>";
				} else {
					strSend="<div style='border-bottom:1px solid #CEE2F2;margin:3;padding:3;background:#F0F5FF;width:220px;word-break:break-all' class='messagerA'>"+rMsg.sendFile+
					file.name+"<br><a href='void(0)' onClick='window.open(\"/weaver/weaver.file.FileDownload?fileid="+data.value
					+"&download=1\");return false'>"+rMsg.clickDownload+"</a><br>("+rMsg.onlySaveOneDay+")</div>";
				}	

				ControlWindow.getWindow(sendTo).send(strSend,false);
				//sendMessage(sendTo,strSend);				 

				var divUploadId=objWindow.getCusData("divUploadId");
				var progress = new FileProgress(file, divUploadId);
				progress.setComplete();
				progress.setStatus("Complete.");
				progress.toggleCancel(false);
			},				
			upload_complete_handler : function(file){			
				try {
					if (this.getStats().files_queued == 0) {									
						//alert('done')	
						//$("#fsUploadProgress_"+windowid).fadeOut("slow");
					} else {	
						this.startUpload();
					}
				} catch (ex) { alert(ex); }
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
	alert("<%=SystemEnv.getHtmlLabelName(24495,user.getLanguage())%>！")
}
</script>
<div id="divStatus" style="display:none"></div>