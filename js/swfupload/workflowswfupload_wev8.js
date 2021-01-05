var upfilesnum=0;
var uploadeErrMsg="";
var nowtarget = frmmain.target;
var nowaction = frmmain.action;
var isHaveErr=false;

var upfilesnum_dt=0;


function uploadError(file, errorCode, message) {
	var progress = new FileProgress(file, this.customSettings.progressTarget);
	 isHaveErr=true;
	try {
		
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
			progress.setStatus("Upload Error: " + message);
			this.debug("Error Code: HTTP Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
			progress.setStatus("Upload Failed.");
			this.debug("Error Code: Upload Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.IO_ERROR:
			progress.setStatus("Server (IO) Error");
			this.debug("Error Code: IO Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
			progress.setStatus("Security Error");
			this.debug("Error Code: Security Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
			progress.setStatus("Upload limit exceeded.");
			this.debug("Error Code: Upload Limit Exceeded, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
			progress.setStatus("Failed Validation.  Upload skipped.");
			this.debug("Error Code: File Validation Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
			isHaveErr=false;
			if (this.getStats().files_queued === 0) {
				var cancel_button =  jQuery("#"+this.customSettings.cancelButtonId).attr("id");
				cancel_button = cancel_button + "0000000000000";
				cancel_button = cancel_button.substr(0,17);
				if(cancel_button != "btnCancelForfield"){
					jQuery("#"+this.customSettings.cancelButtonId).attr("disabled", "disabled");
					jQuery("#"+this.customSettings.cancelButtonId).attr("style", "height:25px;text-align:center;vertical-align:middle;line-height:23px;background-color: #dfdfdf;color:#999999;padding:0 10px 0 4px;");
					jQuery("#"+this.customSettings.cancelButtonId).find("img").attr("src","/images/ecology8/workflow/fileupload/clearallenable_wev8.png");    
				}else{
					jQuery("#"+this.customSettings.cancelButtonId).attr("disabled", "disabled");
				    jQuery("#"+this.customSettings.cancelButtonId).attr("style", "color:gray;cursor:pointer");
				}
			}
			
			progress.setStatus("Cancelled");
			progress.setCancelled(this);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
			progress.setStatus("Stopped");
			break;
		default:
			progress.setStatus("Unhandled Error: " + errorCode);
			this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		}
	} catch (ex) {
        this.debug(ex);
    }

}


function fileDialogComplete_1() {
    showmustinput(this);
    if(this.getStats().files_queued>0){
    if(document.getElementById(this.customSettings.cancelButtonId)) {
    	var cancel_button =  jQuery("#"+this.customSettings.cancelButtonId).attr("id");
    	cancel_button = cancel_button + "0000000000000";
		cancel_button = cancel_button.substr(0,17);
    	if(cancel_button != "btnCancelForfield"){
    		jQuery("#"+this.customSettings.cancelButtonId).removeAttr("disabled");
    		jQuery("#"+this.customSettings.cancelButtonId).attr("style", "height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:23px;background-color: #aaaaaa;color:#ffffff;padding:0 10px 0 4px;");
    		jQuery("#"+this.customSettings.cancelButtonId).find("img").attr("src","/images/ecology8/workflow/fileupload/clearall_wev8.png");    
    		/*jQuery("#"+this.customSettings.progressTarget+" > div").each(function (){
    		$(this).bind("mouseover",function(e){
        		showMoveIcon(this);
        	});
    		});*/
    		
    		jQuery(".progressWrapper").bind("mouseover",function(e){
    			showProgressCancel(this);
    		});
    		
    		jQuery(".progressWrapper").bind("mouseout",function(e){
    			hideProgressCancel(this);
    		});
    	}else{
    		jQuery("#"+this.customSettings.cancelButtonId).removeAttr("disabled");
        	jQuery("#"+this.customSettings.cancelButtonId).attr("style", "color:black;cursor:pointer");
    	}
    }
//    upfilesnum+=this.getStats().files_queued;
    }
    fileDialogComplete
}
function fileDialogComplete_2() {
    if(this.getStats().files_queued>0){
//    upfilesnum+=this.getStats().files_queued;
    if(document.getElementById(this.customSettings.cancelButtonId)) document.getElementById(this.customSettings.cancelButtonId).disabled = false;
    }
    fileDialogComplete
}
function uploadSuccess_1(file, server_data) {
    if ($G(this.customSettings.uploadfiedid)) {
        var imageid = server_data.replace(/(^\s*)|(\s*$)/g, "");
        var tempvalue = "";
        tempvalue = $G(this.customSettings.uploadfiedid).value;
        if (tempvalue == "NULL"||tempvalue == "") {
            tempvalue = imageid;
        } else {
			if(!isNaN(imageid)){
            tempvalue += "," + imageid;
			}
        }
        try {
        	__uploadSuccess_1__(file, imageid);
        } catch (e) {}
        $G(this.customSettings.uploadfiedid).value = tempvalue;
        try {
	        var progress = new FileProgress(file, this.customSettings.progressTarget);
			//progress.setComplete();
			progress.setStatus("上传成功");
			progress.toggleCancel(false);
		} catch (e5) {}
    }
    try {
    	uploadSuccess_callbackfun(file, server_data, this.getStats().files_queued);
    } catch (e) {}
}

function uploadComplete_1() {
    try {
        upfilesnum--;
        /*  I want the next upload to continue automatically so I'll call startUpload here */
        if (this.getStats().files_queued == 0) {
            if ($G(this.customSettings.uploadfiedid)){
                if($G(this.customSettings.uploadfiedid).value=="NULL"){
                    $G(this.customSettings.uploadfiedid).value="";
                }
            }
            if(document.getElementById(this.customSettings.cancelButtonId)) document.getElementById(this.customSettings.cancelButtonId).disabled = true;
        } else {
            this.startUpload();
        }        
    } catch (ex) {
        this.debug(ex);
    }

}

function checkfilesize(uploadobj, filesize, uploaddocCategory) {
    if (uploaddocCategory != null) {
        var upldct = uploaddocCategory.split(",");
        if (upldct.length == 3) {
            uploadobj.addPostParam("mainId", upldct[0]);
            uploadobj.addPostParam("subId", upldct[1]);
            uploadobj.addPostParam("secId", upldct[2]);
        } else {
            uploadobj.addPostParam("mainId", "-1");
            uploadobj.addPostParam("subId", "-1");
            uploadobj.addPostParam("secId", uploaddocCategory);
        }
    } else {
        filesize = 0.000000001;
    }
    uploadobj.setFileSizeLimit(filesize + " MB");
    var sta = uploadobj.getStats();
    for (var i = 0; i < sta.files_queued + sta.upload_cancelled + sta.successful_uploads + sta.upload_errors + sta.queue_errors; i++) {
        var f = uploadobj.getFile(i);
        if (f.filestatus == -1) {
            if (filesize > 0 && f.size > filesize * 1024 * 1024) {
                uploadobj.cancelUpload(f.id);
            }
        }
    }
}
function showmustinput(uploadobj) {
    if (document.getElementById(uploadobj.customSettings.uploadfiedid)) {
        var fieldvalue = document.getElementById(uploadobj.customSettings.uploadfiedid).value;
        if (fieldvalue == "" || fieldvalue == "NULL") {
            var ismand = document.getElementById(uploadobj.customSettings.uploadfiedid).getAttribute('viewtype');
            if (ismand == 1) {
                var sta = uploadobj.getStats();
                if (sta.files_queued == 0) {
                	document.getElementById(uploadobj.customSettings.uploadfiedid).value = "";
					var href = window.location.href;
					var uploadspan = uploadobj.customSettings.uploadspan;
					if(href.indexOf("/formmode/view/AddFormModeIframe.jsp")!=-1){
						if(uploadspan.indexOf("field_")!=0){
							document.getElementById(uploadspan).innerHTML = "<img src='/images/BacoError_wev8.gif' align='absMiddle'>";
							uploadspan = uploadspan.replace("field","field_");
						}
					}
					document.getElementById(uploadspan).innerHTML = SystemEnv.getHtmlNoteName(97);
                    
                } else {
                	document.getElementById(uploadobj.customSettings.uploadfiedid).value = "NULL";
                    document.getElementById(uploadobj.customSettings.uploadspan).innerHTML = "";
                }
            }
        }else{
            document.getElementById(uploadobj.customSettings.uploadspan).innerHTML = "";
        }
    }
}
var oo = 0;
function StartUploadAll() {
    var oo1 = 0;
    for (var j = 0; j < SWFUpload.movieCount; j++) {
        try {
	        eval("SWFUpload.instances.SWFUpload_" + j + ".startUpload()");
	        //eval("upfilesnum+=SWFUpload.instances.SWFUpload_" + j + ".getStats().files_queued");
	        eval("oo1+=SWFUpload.instances.SWFUpload_" + j + ".getStats().files_queued");
        } catch (e_3) {}
    }
    
    if(oo==0){  //防止多次点击保存或提交导致 upfilesnum翻倍增加
    	upfilesnum+=oo1;
    	upfilesnum = upfilesnum-upfilesnum_dt; //去掉明细行附件上传
    	upfilesnum_dt = 0;
    	//alert(upfilesnum+"   "+oo1);
    }
    oo++;
}
function hiddenPrompt(){
	var showTableDiv = document.getElementById('_xTable');
	if(showTableDiv!=null){
		showTableDiv.style.display="none";
	}
}
function checkUploadeErr(){
	var languageid=readCookie("languageidweaver");
	var str=SystemEnv.getHtmlNoteName(3406,readCookie("languageidweaver"));
	/*if(languageid==8) str= "Have a err, are you confirm?";
	if(languageid==9) str = "上传附件过程中发现错误,是否继续提交?";*/
	var returnValue=true;
	
	if(isHaveErr){	
		returnValue= window.confirm(str);
	} 
	return returnValue;
}
function checkuploadcomplet(){
	enableAllmenu();
    if(upfilesnum>0){
        setTimeout("checkuploadcomplet()",1000);
    }else{
    	if(!checkUploadeErr()) {
    		hiddenPrompt()
    		
    		displayAllmenu();
    		return;
    	}
        document.frmmain.submit();
        enableAllmenu();
        frmmain.target = nowtarget;
		frmmain.action = nowaction;
    }
}

function checkfileuploadcomplet4mode() {
    if (upfilesnum > 0) {
        setTimeout("checkfileuploadcomplet4mode()", 1000);
    } else {
    	if(!checkUploadeErr()) {
    		hiddenPrompt();
    		displayAllmenu();
    		return;
    	}
    	
        document.frmmain.submit();
        frmmain.target = nowtarget;
		frmmain.action = nowaction;
    }
}

function checkfileuploadcomplet() {
    if (upfilesnum > 0) {
        setTimeout("checkfileuploadcomplet()", 1000);
    } else {
    	if(!checkUploadeErr()) {
    		hiddenPrompt();
    		displayAllmenu();
    		return;
    	}
    	
        //document.frmmain.submit();
        frmmain.target = nowtarget;
		frmmain.action = nowaction;
    }
}
function checkfileuploadcompletforremark() {
    if (upfilesnum > 0) {
        setTimeout("checkfileuploadcompletforremark()", 1000);
    } else {
    	if(!checkUploadeErr()) {
    		hiddenPrompt();
    		displayAllmenu();
    		return;
    	}
    	
      //  document.frmmain.submit();
        frmmain.target = nowtarget;
		frmmain.action = nowaction;
    }
}
function checkuploadcompletBydoc(){
    if(upfilesnum>0){
        setTimeout("checkuploadcompletBydoc()",1000);
    }else{
    	
    	if(!checkUploadeErr()) {
    		hiddenPrompt();
    		displayAllmenu();
    		return;
    	}
    	
    	try{
			parent.jQuery("#loading").show();
    	}catch(e){}
    	
        document.frmmain.submit();
        enableAllmenu();
        frmmain.target = nowtarget;
		frmmain.action = nowaction;
        if(document.getElementById("iscreate")) document.getElementById("iscreate").value = "0";
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	    parent.clicktext();//切换当前tab页到正文页面
	    if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "";//标识点正文
    }    
}

function $G(identity, _document) {
	var rtnEle = null;
	if (_document == undefined || _document == null) _document = document;
	
	rtnEle = _document.getElementById(identity);
	if (rtnEle == undefined || rtnEle == null) {
		rtnEle = _document.getElementsByName(identity);
		if (rtnEle.length > 0) rtnEle = rtnEle[0];
		else rtnEle = null;
	}
	return rtnEle;
}

var arrayUploadObj = new Array();
var arrayUploadFieldids = new Array();

function checkfilesize2(){
	for(var i=0;i<arrayUploadObj.length;i++){
		var oUpload = arrayUploadObj[i];
		try{
    		if(maxUploadImageSize==null)maxUploadImageSize=5;
    		checkfilesize(oUpload, maxUploadImageSize, uploaddocCategory)
    	}catch(e){};
	}
}

function fileuploadDetailtab(mainId,subId,secId,userid,logintype,workflowid,maxUploadImageSizetmp,picfiletypes,filetypedesc,fieldid,rowindex,needChange) {
	var _isdisabled = false;
	if(needChange==1){
		try{
			//if(maxUploadImageSize==null)maxUploadImageSize=5;
            if (typeof maxUploadImageSize == "undefined") {
				maxUploadImageSize = maxUploadImageSizetmp;
			}
		}catch(e){
			maxUploadImageSize=5;
		}

        maxUploadImageSizetmp = maxUploadImageSize;
        try{
		  if (uploaddocCategory != null) {
            var upldct = uploaddocCategory.split(",");
            if (upldct.length == 3) {
                mainId= upldct[0];
                subId = upldct[1];
                secId = upldct[2];
            }else{
                //maxUploadImageSizetmp = 0.000000001;
                if(uploaddocCategory != null && uploaddocCategory != ""){
                    mainId = "-1";
                    subId = "-1";
                    secId = uploaddocCategory;
                }else{
                    _isdisabled = true;
                }
            }
          }else{
             _isdisabled = true;
          }
	   }catch(e){
	       _isdisabled = true;
	   }
	}
	var settings = {
		flash_url:"/js/swfupload/swfupload.swf",
		upload_url:"/docs/docupload/MultiDocUploadByWorkflow.jsp",
		post_params:{
		    mainId:mainId,
		    subId:subId,
		    secId:secId,
		    userid:userid,
		    logintype:logintype,
		    workflowid:workflowid
		},
		file_size_limit :maxUploadImageSizetmp + " MB",
		file_types : picfiletypes,
		file_types_description : filetypedesc,
		file_upload_limit : 100,
		file_queue_limit : 0,
		custom_settings : { 
		    progressTarget : "fsUploadProgress" + fieldid+"_"+rowindex ,
		    cancelButtonId : "btnCancel" + fieldid+"_"+rowindex,
		    uploadspan : "field_" + fieldid+"_"+rowindex + "span",
		    uploadfiedid : "field" + fieldid+"_"+rowindex + ""
		},
		debug: false,
		button_image_url : "/images/ecology8/workflow/fileupload/begin2_wev8.png",
		button_placeholder_id : "spanButtonPlaceHolder" + fieldid + "_"+rowindex,
		button_width: 22,
		button_height: 22,
		//button_text : '<span class=\"button\">" + SystemEnv.getHtmlLabelName(21406, languageid) + "</span>',
		//button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
		button_text_top_padding: 0,
		button_text_left_padding: 18,
		button_disabled:_isdisabled,
		button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
		button_cursor: SWFUpload.CURSOR.HAND,
		file_queued_handler : fileQueued_dt,
		file_queue_error_handler : fileQueueError_dt,
		file_dialog_complete_handler : fileDialogComplete_1_dt,
		upload_start_handler : uploadStart_dt,
		upload_progress_handler : uploadProgress_dt,
		upload_error_handler : uploadError_dt,
		upload_success_handler : uploadSuccess_1_dt,
		upload_complete_handler : uploadComplete_1_dt,
		queue_complete_handler : queueComplete_dt
	};
	
	try {
	    eval("oUpload"+fieldid+"_"+rowindex+"=new SWFUpload(settings)");
	} catch(e) {
	    alert(e)
	}
	try {
	    if(needChange==1){
	    	try{
	    		if(maxUploadImageSize==null)maxUploadImageSize=5;
	    		checkfilesize(eval("oUpload"+fieldid+"_"+rowindex), maxUploadImageSize, uploaddocCategory);
	    	}catch(e){};
	    	arrayUploadObj.push(eval("oUpload"+fieldid+"_"+rowindex));
	    	arrayUploadFieldids.push(fieldid+"_"+rowindex);
	    	
	    	if(!_isdisabled){
				jQuery("#field"+fieldid+"_"+rowindex+"_remind").attr("title",SystemEnv.getHtmlNoteName(4062));
		    }else{
				jQuery("#field"+fieldid+"_"+rowindex+"_remind").attr("title","");
		    }
	    }
	} catch(e) {}
}

function uploadComplete_1_dt() {
    try {
    	//upfilesnum--; 
        /*  I want the next upload to continue automatically so I'll call startUpload here */
        if (this.getStats().files_queued == 0) {
            if ($G(this.customSettings.uploadfiedid)){
                if($G(this.customSettings.uploadfiedid).value=="NULL"){
                    $G(this.customSettings.uploadfiedid).value="";
                }
            }
            if(document.getElementById(this.customSettings.cancelButtonId)) document.getElementById(this.customSettings.cancelButtonId).disabled = true;
        } else {
            this.startUpload();
        }  
    } catch (ex) {
        this.debug(ex);
    }

}


function fileDialogComplete_1_dt() {
    showmustinput(this);
    if(this.getStats().files_queued>0){
    if(document.getElementById(this.customSettings.cancelButtonId)) {
    	var cancel_button =  jQuery("#"+this.customSettings.cancelButtonId).attr("id");
    	cancel_button = cancel_button + "0000000000000";
		cancel_button = cancel_button.substr(0,17);
    	if(cancel_button != "btnCancelForfield"){
    		jQuery("#"+this.customSettings.cancelButtonId).removeAttr("disabled");
    		jQuery("#"+this.customSettings.cancelButtonId).attr("style", "height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:23px;background-color: #aaaaaa;color:#ffffff;padding:0 10px 0 4px;");
    		jQuery("#"+this.customSettings.cancelButtonId).find("img").attr("src","/images/ecology8/workflow/fileupload/clearall_wev8.png");    
    		/*jQuery("#"+this.customSettings.progressTarget+" > div").each(function (){
    		$(this).bind("mouseover",function(e){
        		showMoveIcon(this);
        	});
    		});*/
    		
    		jQuery(".progressWrapper").bind("mouseover",function(e){
    			showProgressCancel(this);
    		});
    		
    		jQuery(".progressWrapper").bind("mouseout",function(e){
    			hideProgressCancel(this);
    		});
    	}else{
    		jQuery("#"+this.customSettings.cancelButtonId).removeAttr("disabled");
        	jQuery("#"+this.customSettings.cancelButtonId).attr("style", "color:black;cursor:pointer");
    	}
    }
    upfilesnum+=this.getStats().files_queued;
    
    upfilesnum_dt +=this.getStats().files_queued;
    }
    try{
    	this.startUpload();
    }catch(e){alert(e);}
}

function fileQueued_dt(file) {
	try {
		var progress = new FileProgressDt(file, this.customSettings.progressTarget);
		progress.setStatus("Pending...");
		progress.toggleCancel(true, this);

	} catch (ex) {
		this.debug(ex);
	}

}


function fileQueueError_dt(file, errorCode, message) {
	try {
		if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
			alert("You have attempted to queue too many files.\n" + (message === 0 ? "You have reached the upload limit." : "You may select " + (message > 1 ? "up to " + message + " files." : "one file.")));
			return;
		}

		var progress = new FileProgressDt(file, this.customSettings.progressTarget);
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
			//progress.setStatus("File is too big.");
			progress.setStatus(""+SystemEnv.getHtmlNoteName(4061));
			var fileProgressID = file.id;
			//jQuery("#"+fileProgressID).css({"height":"40px!important"});
			jQuery("#"+fileProgressID).removeClass().addClass("progressWrapper_dt2");
			jQuery("#"+fileProgressID).find(".progressBarStatus_dt").removeClass().addClass("progressBarStatus_dt2");
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
}


function uploadError_dt(file, errorCode, message) {
	var progress = new FileProgressDt(file, this.customSettings.progressTarget);
	 isHaveErr=true;
	try {
		
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
			progress.setStatus("Upload Error: " + message);
			this.debug("Error Code: HTTP Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
			progress.setStatus("Upload Failed.");
			this.debug("Error Code: Upload Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.IO_ERROR:
			progress.setStatus("Server (IO) Error");
			this.debug("Error Code: IO Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
			progress.setStatus("Security Error");
			this.debug("Error Code: Security Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
			progress.setStatus("Upload limit exceeded.");
			this.debug("Error Code: Upload Limit Exceeded, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
			progress.setStatus("Failed Validation.  Upload skipped.");
			this.debug("Error Code: File Validation Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
			isHaveErr=false;
			if (this.getStats().files_queued === 0) {
				var cancel_button =  jQuery("#"+this.customSettings.cancelButtonId).attr("id");
				cancel_button = cancel_button + "0000000000000";
				cancel_button = cancel_button.substr(0,17);
				if(cancel_button != "btnCancelForfield"){
					jQuery("#"+this.customSettings.cancelButtonId).attr("disabled", "disabled");
					jQuery("#"+this.customSettings.cancelButtonId).attr("style", "height:25px;text-align:center;vertical-align:middle;line-height:23px;background-color: #dfdfdf;color:#999999;padding:0 10px 0 4px;");
					jQuery("#"+this.customSettings.cancelButtonId).find("img").attr("src","/images/ecology8/workflow/fileupload/clearallenable_wev8.png");    
				}else{
					jQuery("#"+this.customSettings.cancelButtonId).attr("disabled", "disabled");
				    jQuery("#"+this.customSettings.cancelButtonId).attr("style", "color:gray;cursor:pointer");
				}
			}
			
			progress.setStatus("Cancelled");
			progress.setCancelled(this);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
			progress.setStatus("Stopped");
			break;
		default:
			progress.setStatus("Unhandled Error: " + errorCode);
			this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		}
	} catch (ex) {
        this.debug(ex);
    }

}

function uploadStart_dt(file) {
	try {
		/* I don't want to do any file validation or anything,  I'll just update the UI and
		return true to indicate that the upload should start.
		It's important to update the UI here because in Linux no uploadProgress events are called. The best
		we can do is say we are uploading.
		 */
		var progress = new FileProgressDt(file, this.customSettings.progressTarget);
		progress.setStatus("Uploading...");
		progress.toggleCancel(true, this);
	}
	catch (ex) {}

	return true;
}


function uploadProgress_dt(file, bytesLoaded, bytesTotal) {
	try {
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);

		var progress = new FileProgressDt(file, this.customSettings.progressTarget);
		progress.setProgress(percent);
		progress.setStatus("Uploading...");
	} catch (ex) {
		this.debug(ex);
	}
}

function uploadSuccess_1_dt(file, server_data) {
    if ($G(this.customSettings.uploadfiedid)) {
        var imageid = server_data.replace(/(^\s*)|(\s*$)/g, "");
        var tempvalue = "";
        tempvalue = $G(this.customSettings.uploadfiedid).value;
        if (tempvalue == "NULL"||tempvalue == "") {
            tempvalue = imageid;
        } else {
            tempvalue += "," + imageid;
        }
        try {
        	__uploadSuccess_1__(file, imageid);
        } catch (e) {}
        $G(this.customSettings.uploadfiedid).value = tempvalue;
        try {
	        var progress = new FileProgressDt(file, this.customSettings.progressTarget);
			//progress.setComplete();
			progress.setStatus("上传成功");
			progress.toggleCancel(false);
		} catch (e5) {}
		
		try {
	    	uploadSuccess_callbackfun_dt(this.customSettings.uploadfiedid,file, imageid);
	    } catch (e) {alert(e);}
    }
    try {
    	uploadSuccess_callbackfun(file, server_data, this.getStats().files_queued);
    } catch (e) {}
	
	
	upfilesnum--;
	upfilesnum_dt--;
    
}


function uploadSuccess_callbackfun_dt_bak(uploadfiedid,file,imageid){
	
	var fieldname = uploadfiedid;
	
	var linknum = 0;
	jQuery("input[name^='"+fieldname+"_id_']").each(function(){
		linknum++;	
	});
	
	var filename = file.name;
	var filehtml = fileHtml(fieldname,imageid,filename,linknum);
	
	jQuery("#"+file.id).remove();
	jQuery("#"+fieldname+"_tab>tbody>tr:eq(-1)").before(filehtml);
	//jQuery("#"+fieldname+"_tab tr:eq(-1)").before(filehtml);
	
	//jQuery("#fsUploadProgress"+fieldname.replace("field","")).parent().parent().parent().remove();
}

function queueComplete_dt(numFilesUploaded) {
	var fieldid = this.customSettings.uploadfiedid;
	fieldid = fieldid.replace("field","");
	//var status = document.getElementById("divStatus"+fieldid);
	//status.innerHTML = numFilesUploaded + " file" + (numFilesUploaded === 1 ? "" : "s") + " uploaded.";
	
	//jQuery("#fsUploadProgress"+fieldid).parent().parent().parent().remove();
	
	//alert(upfilesnum);
}

function uploadSuccess_callbackfun_dt(uploadfiedid,file,imageid){
	var fieldname = uploadfiedid;
	var filename = file.name;
	
	var fieldArray = fieldname.split("_");
	var fieldid = fieldArray[0];
	fieldid = fieldid.replace("field","");
	var derecorderindex = fieldArray[1];
	
	var linknum = 0;
	jQuery("input[name^='"+fieldname+"_id_']").each(function(){
		linknum++;	
	});
	
	var linknum2 = jQuery("#"+fieldname+"_idnum_1").val();
	linknum2=parseInt(linknum2)+1;
	jQuery("#"+fieldname+"_idnum_1").val(linknum2);
	
	getfilehtmlData(imageid,fieldid,derecorderindex,file,fieldname,linknum);
}

function getfilehtmlData(fieldvalue,fieldid,derecorderindex,file,fieldname,linknum){
	var isFormMode = jQuery("#isFormMode");
	var urltemp = "";
	var url = "";
	if(isFormMode.length>0&&isFormMode.val()=="1"){//来自表单建模附件上传
		var modeid = jQuery("#formmodeid").val();
		var biiiid = jQuery("#billid").val();
		var ismand = jQuery("#field"+fieldid+"_"+derecorderindex).attr("viewtype");
		var type = jQuery("#type_"+fieldid+"_"+derecorderindex).val();
		urltemp = "modeid="+modeid+"&biiiid="+biiiid+"&fieldid="+fieldid+"&derecorderindex="+derecorderindex+"&ismand="+ismand+"&type="+type+"&fieldvalue="+fieldvalue+"&linknum="+linknum;
		url = "/formmode/view/FormmodeUploadfileHtmlAjax.jsp?"+urltemp;
	}else{
		var workflowid = jQuery("input[name='workflowid']").val();
		var isbill = jQuery("input[name='isbill']").val();
		var requestid = jQuery("input[name='requestid']").val();
		var ismand = jQuery("#field"+fieldid+"_"+derecorderindex).attr("viewtype");
		var type = jQuery("#type_"+fieldid+"_"+derecorderindex).val();
		urltemp = "workflowid="+workflowid+"&isbill="+isbill+"&requestid="+requestid+"&fieldid="+fieldid+"&derecorderindex="+derecorderindex+"&ismand="+ismand+"&type="+type+"&fieldvalue="+fieldvalue+"&linknum="+linknum;
		url = '/workflow/request/getUploadfileHtmlAjax.jsp?'+urltemp;
	}
	
	//alert(urltemp);
	var result = '';
	jQuery.ajax({
	    url: url,
	    dataType: "html", 
        type:'post',
        async:true,  
	    contentType : "charset=UTF-8", 
	    error:function(ajaxrequest){}, 
	    success:function(data){
	    	result = data;
	    	jQuery("#"+file.id).remove();
	    	//jQuery("#"+fieldname+"_tab>tbody>tr:eq(-1)").before(result);
			jQuery("#"+fieldname+"_tab>tbody>tr:last").before(result);
	    }
     });	
  return result;
}

function fileHtml(fieldid,showid,docImagefilename,linknum){
	var inputStr = ""; 
	var imgSrc = "&nbsp;";
	var ismand = jQuery("#"+fieldid).attr("viewtype");
	
	fieldid = fieldid.replace("field","");
	
	inputStr += "<tr style='border-bottom:1px solid #e6e6e6;height:42px;' onmouseover='changecancleon(this)' onmouseout='changecancleout(this)'>" + "\n";
    inputStr += "	<td class='fieldvalueClass' valign='middle' colspan='3' style='word-break:normal;word-wrap:normal; padding-right: 0px; padding-left: 0px;'>" + "\n";
    inputStr += "		<div style='float:left;height:40px;line-height:38px;width:120px;' class='fieldClassChange'>" + "\n";
    inputStr += "			<div style='float:left;width:20px;height:40px;line-height:38px;'>" + "\n";
    inputStr += "				<span style='display:inline-block;vertical-align: middle;'>" + "\n";
    inputStr += 					imgSrc;
    inputStr += "				</span>" + "\n";
    inputStr += "			</div>" + "\n";
    inputStr += "			<div style='float:left;'>" + "\n";
    inputStr += "				<span style='display:inline-block;width:90px;height:30px;padding-bottom:10px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;vertical-align: middle;'>" + "\n";
	inputStr += "					<a style='cursor:pointer;color:#8b8b8b!important;margin-top:1px;' onmouseover='changefileaon(this)' onmouseout='changefileaout(this)' onclick='' title='"+docImagefilename+"'>" + docImagefilename + "</a>&nbsp;" + "\n";
	inputStr += "					<input type='hidden' id='field" + fieldid + "_id_" + linknum + "' name='field" + fieldid + "_id_" + linknum + "' value='" + showid + "'>" + "\n";
	inputStr += "					<input type='hidden' id='field" + fieldid + "_del_" + linknum + "' name='field" + fieldid + "_del_" + linknum + "' value='0' >" + "\n";
	
	if (!$G("field" + fieldid + "_idnum")) {
		inputStr += "				<input type='hidden' id='field" + fieldid + "_idnum' name='field" + fieldid + "_idnum' value='" + (linknum + 1) + "'>" + "\n";
		inputStr += "				<input type='hidden' id='field" + fieldid + "_idnum_1' name='field" + fieldid + "_idnum_1' value='" + (linknum + 1) + "'>" + "\n";
	}else{
		var fieldidnum = "field" + fieldid + "_idnum";
		var fieldidnum_1 = "field" + fieldid + "_idnum_1";
		$GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
		$GetEle(fieldidnum_1).value=parseInt($GetEle(fieldidnum_1).value)+1;
	}
    inputStr += "				</span>" + "\n";
    inputStr += "			</div>" + "\n";
    inputStr += "		</div>" + "\n";
    
    inputStr += "		<div style='float:left;height:40px; line-height:40px;width:20px;' class='fieldClassChange'>" + "\n";
	inputStr += "			<span id='selectDownload'>" + "\n";
	//inputStr += "				<a style='display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;margin-bottom:5px;background-image:url(\"/images/ecology8/workflow/fileupload/upload_wev8.png\");' onclick='' title=''></a>" + "\n";
	inputStr += "			</span>" + "\n";
	inputStr += "		</div>" + "\n";
    
    inputStr += "		<div class='fieldClassChange' id='fieldCancleChange' style='float:left;width:20px;height:40px; line-height: 40px;text-align:center;'>" + "\n";
	inputStr += "			<span id='span"+fieldid+"_id_"+linknum+"' name='span"+fieldid+"_id_"+linknum+"' style='display:none;'>" + "\n";
	inputStr += "				<a style='display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;background-image:url(\"/images/ecology8/workflow/fileupload/cancle_wev8.png\");' onclick='onChangeSharetypeNew2(this,\"span"+fieldid+"_id_"+linknum+"\",\"field"+fieldid+"_del_"+linknum+"\",\""+showid+"\",\""+docImagefilename+"\","+ismand+",eval(oUpload"+fieldid+"))' title='删除'></a>" + "\n";
	inputStr += "			</span>" + "\n";
	inputStr += "		</div>" + "\n";
    
    inputStr += 	"</td>" + "\n";
    inputStr += "</tr>" + "\n";
	return inputStr;
}


function changecancleonnew(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").css("display","inline-block");
	jQuery(obj).find("#fielddownloadChange").css("display","inline-block");
}

function changecancleoutnew(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").css("display","none");
	jQuery(obj).find("#fielddownloadChange").css("display","none");
}



function onChangeSharetypeNew2(obj,delspan,delid,showid,names,ismand,Uploadobj){
	top.Dialog.confirm("确定要删除“"+names+"”吗?", function(){
	    //jQuery(obj).parent().parent().parent().parent().css("display","none");
	    jQuery(obj).parent().parent().parent().parent().parent().css("display","none");
		
	    var fields = delid.split("_");
		var fieldid=fields[0]+"_"+fields[1];
	    var linknum=delid.substr(delid.lastIndexOf("_")+1);
		var fieldidnum=fieldid+"_idnum_1";
		var fieldidspan=fieldid+"span";
	    var delfieldid=fieldid+"_id_"+linknum;
	    if($GetEle(delspan).style.visibility=='visible'){
	      $GetEle(delspan).style.visibility='hidden';
	      $GetEle(delid).value='0';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
	        var tempvalue=$GetEle(fieldid).value;
	          if(tempvalue==""){
	              tempvalue=$GetEle(delfieldid).value;
	          }else{
	              tempvalue+=","+$GetEle(delfieldid).value;
	          }
		     $GetEle(fieldid).value=tempvalue;
	    }else{
	      $GetEle(delspan).style.visibility='visible';
	      $GetEle(delid).value='1';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
	        var tempvalue=$GetEle(fieldid).value;
	        var tempdelvalue=","+$GetEle(delfieldid).value+",";
	          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
	          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
	          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
	          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
	          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
		     $GetEle(fieldid).value=tempvalue;
	    }
		if (ismand=="1"){
			if ($GetEle(fieldidnum).value=="0"){
			    $GetEle(fieldid).value="";
			    var swfuploadid=fieldid.replace("field","");
			    var fieldidnew = "field"+swfuploadid;
			    var fieldidspannew = "field_"+swfuploadid+"span";
			    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
			    $GetEle(fieldidspannew).innerHTML="";
			    var fieldvalue = jQuery("#"+fieldidnew).val();
		        if(Uploadobj.getStats().files_queued==0 && fieldvalue==""){
					$GetEle(fieldidspannew).innerHTML=SystemEnv.getHtmlNoteName(97);
					$GetEle(fieldidspannew).style.display = "";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
		        }
		        if(linkrequired && linkrequired.value=="false"){
		        	$GetEle(fieldidspannew).innerHTML="";
		        }
		  	}else{
		  	 var swfuploadid=fieldid.replace("field","");
		  	 //alert("swfuploadid = "+swfuploadid);
		     var fieldidspannew = "field_"+swfuploadid+"span";
			 $GetEle(fieldidspannew).innerHTML="";
		  	}
		}else{//add by td78113
			var swfuploadid=fieldid.replace("field","");
		    var fieldidnew = "field"+swfuploadid;
		    var fieldidspannew = "field_"+swfuploadid+"span";
		    var fieldvalue = jQuery("#"+fieldidnew).val();
		    
			if(jQuery("#"+fieldidnew).attr("viewtype")=="1" && fieldvalue==""){
				if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML=SystemEnv.getHtmlNoteName(97);
					$GetEle(fieldidspannew).style.display = "";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
			    }
			}
		    
			try{
				displaySWFUploadError(fieldid);
			}catch(e){}
		}
		////
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
		}
	}, function () {}, 320, 90,true);
}

function onChangeSharetype2(delspan,delid,ismand,Uploadobj){
	
	var fields = delid.split("_");
	
	fieldid=fields[0]+"_"+fields[1];
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if($GetEle(delspan).style.visibility=='visible'){
    	$GetEle(delspan).style.visibility='hidden';
    	$GetEle(delid).value='0';
	    $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
        var tempvalue=$GetEle(fieldid).value;
          if(tempvalue==""){
              tempvalue=$GetEle(delfieldid).value;
          }else{
              tempvalue+=","+$GetEle(delfieldid).value;
          }
	     $GetEle(fieldid).value=tempvalue;
    }else{
    	$GetEle(delspan).style.visibility='visible';
    	$GetEle(delid).value='1';
    	$GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
        var tempvalue=$GetEle(fieldid).value;
        var tempdelvalue=","+$GetEle(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
	     $GetEle(fieldid).value=tempvalue;
    }
	//alert($GetEle(fieldidnum).value);
	if (ismand=="1")
	{
		if ($GetEle(fieldidnum).value=="0")
	    {
		    $GetEle(fieldid).value="";
		    var swfuploadid=fieldid.replace("field","");
		  //alert("swfuploadid = "+swfuploadid);
		    var fieldidspannew = "field_"+swfuploadid+"span";
		    var fieldidnew = "field"+swfuploadid;
		    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
		    $GetEle(fieldidspannew).innerHTML="";
	        if(Uploadobj.getStats().files_queued==0){
	        	$GetEle(fieldidspannew).innerHTML=SystemEnv.getHtmlNoteName(97);
				$GetEle(fieldidspannew).style.display = "";
				var checkstr_=$GetEle("needcheck").value+",";
				if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
	        }
	        if(linkrequired && linkrequired.value=="false"){
	        	$GetEle(fieldidspannew).innerHTML="";
	        }
	     }
		 else
		 {
			 var swfuploadid=fieldid.replace("field","");
		  	 //alert("swfuploadid = "+swfuploadid);
			 var fieldidspannew = "field_"+swfuploadid+"span";
			 $GetEle(fieldidspannew).innerHTML="";
	      }
	  }else{//add by td78113
		  var tempvalue=$GetEle(fieldid).value;
		  var swfuploadid=fieldid.replace("field","");
		  var fieldidnew = "field"+swfuploadid;
		  var fieldidspannew = "field_"+swfuploadid+"span";
		  if(jQuery("#"+fieldidnew).attr("viewtype")=="1"){
				if(Uploadobj.getStats().files_queued==0 && tempvalue==""){
					$GetEle(fieldidspannew).innerHTML=SystemEnv.getHtmlNoteName(97);
					$GetEle(fieldidspannew).style.display = "";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
			    }
		  }
	  	  
	  	  try{
	  		displaySWFUploadError(fieldid);
	  	  }catch(e){}
	  }
}


function attachmentDisabled(arrayobj,flag,arrayfield){
	if(arrayobj){
		for(var i=0;i<arrayobj.length;i++){
			var oUpload = arrayobj[i];
			var oUploadfieldid = arrayfield[i];
			
	    	var isfromchangeshowattr = jQuery("#oldfieldview"+oUploadfieldid);
			if(isfromchangeshowattr){
				var _readonly = isfromchangeshowattr.attr("_readonly");
				if(_readonly!="1"){
					try{
						oUpload.setButtonDisabled(flag);
			    	}catch(e){};
				}
			}else{
				try{
					oUpload.setButtonDisabled(flag);
		    	}catch(e){};
			}
		}
	}
	for(var i=0;i<arrayUploadObj.length;i++){
		var oUpload0 = arrayUploadObj[i];
		var oUpload0fieldid = arrayUploadFieldids[i];
		
		var isfromchangeshowattr = jQuery("#oldfieldview"+oUpload0fieldid);
		if(isfromchangeshowattr){
			var _readonly = isfromchangeshowattr.attr("_readonly");
			if(_readonly!="1"){
				try{
					oUpload0.setButtonDisabled(flag);
		    	}catch(e){};
			}
		}else{
			try{
				oUpload0.setButtonDisabled(flag);
	    	}catch(e){};
		}
		if(!flag){
			jQuery("#field"+oUpload0fieldid+"_remind").attr("title",SystemEnv.getHtmlNoteName(4062));
		}else{
			jQuery("#field"+oUpload0fieldid+"_remind").attr("title","");
		}
		
	}
}

