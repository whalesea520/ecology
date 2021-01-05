var upfilesnum=0;
var uploadeErrMsg="";
var nowtarget = frmmain.target;
var nowaction = frmmain.action;
var isHaveErr=false;


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
					 jQuery("#"+this.customSettings.cancelButtonId).attr("disabled", "disabled");
				      jQuery("#"+this.customSettings.cancelButtonId).attr("style", "color:gray;cursor:pointer");	 
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
        jQuery("#"+this.customSettings.cancelButtonId).removeAttr("disabled");
    	jQuery("#"+this.customSettings.cancelButtonId).attr("style", "color:black;cursor:pointer");
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
            tempvalue += "," + imageid;
        }
        $G(this.customSettings.uploadfiedid).value = tempvalue;
    }
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
            filesize = 0.000000001;
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
                    document.getElementById(uploadobj.customSettings.uploadspan).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absMiddle>";
                    document.getElementById(uploadobj.customSettings.uploadfiedid).value = "";
                } else {
                    document.getElementById(uploadobj.customSettings.uploadspan).innerHTML = "";
                    document.getElementById(uploadobj.customSettings.uploadfiedid).value = "NULL";
                }
            }
        }
    }
}
function StartUploadAll() {
    for (var j = 0; j < SWFUpload.movieCount; j++) {
        eval("SWFUpload.instances.SWFUpload_" + j + ".startUpload()");
        eval("upfilesnum+=SWFUpload.instances.SWFUpload_" + j + ".getStats().files_queued");
    }
}
function hiddenPrompt(){
	var showTableDiv = document.getElementById('_xTable');
	if(showTableDiv!=null){
		showTableDiv.style.display="none";
	}
}
function checkUploadeErr(){
	var languageid=readCookie("languageidweaver");
	var str=SystemEnv.getNoteHtml(3406,languageid);
	/*if(languageid==8) str= "Have a err, are you confirm?";
	if(languageid==9) str = "上传附件过程中发现错误,是否继续提交?";
	*/
	var returnValue=true;
	
	if(isHaveErr){	
		returnValue= window.confirm(str);
	} 
	return returnValue;
}
function checkuploadcomplet(){
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