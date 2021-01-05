var currentFileID = "";
var delannexids = "";
var numFilesQ = 0;
var numFilesS = 0;
var numUploadFiles = 0;
var oUploadannexupload;
var oUploadannexuploadLi;
var oUploadannexuploadAdd;
var cancelNum = 0;
var failNum = 0;

function initFileupload(btnid, fileSizelimit,flag) {
    var settings = {
        flash_url: "/js/swfupload/swfupload.swf",
        upload_url: "/rdeploy/doc/MultiDocUpload.jsp",

        file_size_limit: fileSizelimit + "MB",
        file_types: "*.*",
        file_types_description: "All Files",
        file_upload_limit: 100,
        file_queue_limit: 0,
        custom_settings: {
            btnFlag : flag,
            progressTarget: "fsUploadProgressannexupload",
            cancelButtonId: "btnCancelannexupload",
            uploadfiedid: "field-annexupload"
        },
        debug: false,
        button_placeholder_id: btnid,
        button_width: 60,
        button_height: 25,
        button_text_top_padding: 5,
        button_text_left_padding: 12,
        button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
        button_cursor: SWFUpload.CURSOR.HAND,
        file_queued_handler: fileQueued,
        file_queue_error_handler: fileQueueError,
        file_dialog_complete_handler: function(numFilesSelected, numFilesQueued) {
            initBtnAndShowProgressList(numFilesSelected, numFilesQueued,flag);
        },
        upload_start_handler: uploadStart,
        upload_progress_handler: uploadProgress,
        upload_error_handler: uploadError,
        upload_success_handler: function(file, serverData) {
            progressUplouder(file, serverData,flag);
        },
        upload_complete_handler: uploadComplete_1,
        queue_complete_handler: queueComplete // Queue plugin event
    };

    try {
        switch(flag) {
            case 1 :
            	 oUploadannexupload = new SWFUpload(settings);
            	 break;
            case 2 :
                 oUploadannexuploadLi = new SWFUpload(settings);
                 break;
            case 3 :	
                 oUploadannexuploadAdd = new SWFUpload(settings);
                 break; 
        
        }
    } catch(e) {
        alert(e)
    }
}
// 初始化按钮并显示队列列表
function initBtnAndShowProgressList(numFilesSelected, numFilesQueued,flag) {
	if (numFilesSelected > 0) {
		$("#norecord_uploadDiv").remove();
		contentFrame.window.$("#norecord").remove();
		$("#uptitle").empty();
		$("#uptitle").append("正在上传：");
	    if(!$("#count").text())
          {
            $("#count").empty();
            $("#count").append(numFilesSelected);
          }
          else
          {
            var count = parseInt(jQuery("#count").text());
            $("#count").empty();
            $("#count").append(count+numFilesSelected);
          }
		$("#uploadList").show();
		$("#sp").show();
	
		if($("#uploadDialogBody").is(":hidden"))
		{
				$("#uploadDialogBody").slideToggle();
				$("#cancelAllDiv").slideToggle();
                jQuery("#uploadList").toggleClass("hideBody");
				$("#uploadMImg").removeClass("uploadMImg_max");
				$("#uploadMImg").addClass("uploadMImg");
				$('#uploadDialogBody').perfectScrollbar("show");
			}
		$("#cancelAllDiv").removeClass("nocalcelAllDiv");
    	$("#cancelAllDiv").addClass("calcelAllDiv");
		
		uploadfinish = false;
		 switch(flag) {
            case 1 :
                 oUploadannexupload.startUpload();
                 break;
            case 2 :
                 oUploadannexuploadLi.startUpload();
                 break;
            case 3 :    
                 oUploadannexuploadAdd.startUpload();
                 break; 
        }
    }
}



// 显示成功列表信息，并创建文档
function progressUplouder(file, serverData,flag) {
     var __obj = oUploadannexupload;
     if(flag == 2){
         __obj = oUploadannexuploadLi;
     }else if(flag == 3){
         __obj = oUploadannexuploadAdd;
     }
    try {
        var jsonobj = eval('(' + serverData + ')');
        var progress = new FileProgress(file, __obj.customSettings.progressTarget);
        progress.setStatus("上传成功");
        
        var successImgDiv = $("<div />");
		successImgDiv.css("float","left");
		successImgDiv.css("padding-top","15px");
		var successImg = $("<img />");
		successImg.attr("src","/rdeploy/assets/img/doc/upload_sucess.png");
		successImgDiv.append(successImg);
		
        $("#"+file.id+"rprogressBarStatus").after(successImgDiv);
        $("#"+file.id+"cancelDiv").remove();
        
        var sucount = parseInt(jQuery("#suCount").text());
            $("#suCount").empty();
            $("#suCount").append(sucount+1);
        var filesecid ;
        if($("#loadFolderType").val() == 'publicAll')
        {
        	var filesecid = $("#fpid").val();
        }
        else
        {
        	filesecid = parseInt($("#privateId").val());
        }
        progress.toggleCancel(true);
        jQuery.ajax({
            type: "POST",
            url: "/rdeploy/doc/MultiDocMaintOpration.jsp?foldertype=" + $("#loadFolderType").val(),
            data: {
                imgFileId: jsonobj.imageid,
                seccategory: filesecid,
                ownerid: $("#ownerid").val(),
                doclangurage: $("#doclangurage").val(),
                docdepartmentid: $("#docdepartmentid").val(),
                fileSize: file.size
            },
            cache: false,
            async: false,
            dataType: 'json',
            success: function(data) {
            	var itemData;
                contentFrame.window.fullPrivateDocitem(filesecid, data,itemData,"yes",file.id);
            }
        });
    } catch(ex) {
        __obj.debug(ex);
    }
}



var plen = 0;
var rtvids = "";
var rtvnames = "";
var rtvsizes = "";
String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {
    if (!RegExp.prototype.isPrototypeOf(reallyDo)) {
        return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);
    } else {
        return this.replace(reallyDo, replaceWith);
    }
}