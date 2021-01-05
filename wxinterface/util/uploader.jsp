<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="DesUtil" class="weaver.general.DesUtil" scope="page" />
<link href="/wxinterface/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/wxinterface/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/wxinterface/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/wxinterface/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/wxinterface/js/swfupload/handlers_wev8.js"></script>
<script language="javascript">
function bindUploaderDiv(targetObj,relateaccName,docid){
	var maxsize=targetObj.attr("maxsize");
	var d=new Date();
	var indexid="index_"+d.getSeconds()+d.getMilliseconds();
	targetObj.attr("oUploaderIndex","oUploader_"+indexid).attr("oUploaderIndexId",indexid);
	targetObj.html(
	   "<input id='image_"+docid+"' type='hidden' name='"+relateaccName+"'>"+
	   "<div style='margin-top:0px;'>"+
			"<span>"+ 
				 "<span id='btnSelectedAcc_"+indexid+"'></span>"+
			"</span>"+		
		 	//"<span style='display:none;color: #262626; cursor: hand; TEXT-DECORATION: none' disabled id='btnCancel_upload_"+indexid+"' onClick='oUploader_"+indexid+".cancelQueue()'>"+
			// 	 "<span>"+
			// 	 	"<img src='/js/swfupload/delete_wev8.gif' border='0'>清除"+
			// 	 "</span>"+
				 //"<span style='height: 19px'><font style='margin: 0 0 0 -1;font-size:12px'>清除</font></span>"+
			//"</span>"+
		"</div>"+
		"<div class='fieldset flash' id='fsUploadProgress_"+indexid+"'></div>"+
		"<div id='divStatus_"+indexid+"'></div>");
	   window["oUploader_"+indexid]=getUploader(indexid,maxsize,docid);
}

function getUploader(indexid,maxsize,docid){
	var oUploader=null;
	try{
		var settings = {
			flash_url : "/wxinterface/js/swfupload/swfupload.swf",
		    post_params: {
				userid:'<%=DesUtil.encrypt(""+user.getUID())%>',
				language:'<%=user.getLanguage()%>',
				logintype:'<%=user.getLogintype()%>',
				departmentid:'<%=user.getUserDepartment()%>',
				docid:docid
		    },        
			upload_url: "/wxinterface/util/uploaderOperate.jsp",
			file_size_limit : maxsize+" MB",
			file_types : "*.jpg;*.png;*.jpeg;",
			file_types_description :"Web Image Files",
			file_upload_limit : "1",
			file_queue_limit : "1",
			custom_settings : {
		    	progressTarget : "fsUploadProgress_"+indexid,
				cancelButtonId : "btnCancel_upload_"+indexid		
			},
			debug: false,
			button_image_url : "/wxinterface/js/swfupload/add_wev8.png",	// Relative to the SWF file
			button_placeholder_id : "btnSelectedAcc_"+indexid,
			button_width: 125,
			button_height: 18,
			button_text : '<span class="button">上传('+maxsize+' MB)</span>',
			button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
			button_text_top_padding: 0,
			button_text_left_padding: 18,
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			file_queued_handler : fileQueued,
			file_queue_error_handler : fileQueueError,				
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
				if (numFilesSelected > 0) {		
					//document.getElementById("btnCancel_upload_"+indexid).disabled = false;
					//jQuery("#fsUploadProgress_"+indexid).show();
					//this.startUpload();							
				}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,			
			upload_error_handler : uploadError,
			queue_complete_handler : queueComplete,
			upload_success_handler : function (file, server_data) {	
				jQuery("#image_"+docid).val(jQuery.trim(server_data));
			},				
			upload_complete_handler : function(file){	 
				try {
					if (this.getStats().files_queued == 0) {									
						uploadImage(imageIndex);
						jQuery("#fsUploadProgress_"+indexid).html(""); //清空上传进度条 
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
	alert("Flash版本不对,不能传送文件!");
}

</script>

<div id="divStatus" style="display:none"></div>