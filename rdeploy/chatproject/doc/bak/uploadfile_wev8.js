var currentFileID = "";
var delannexids = "";
var numFilesQ = 0;
var numFilesS = 0;
var numUploadFiles = 0;
var oUploadannexupload;
var cancelNum = 0;
var failNum = 0;

function initFileupload(btnid, fileSizelimit) {

    var settings = {
        flash_url: "/js/swfupload/swfupload.swf",
        upload_url: "/rdeploy/doc/MultiDocUpload.jsp",

        file_size_limit: fileSizelimit + "MB",
        file_types: "*.*",
        file_types_description: "All Files",
        file_upload_limit: 100,
        file_queue_limit: 0,
        custom_settings: {
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
            initBtnAndShowProgressList(numFilesSelected, numFilesQueued);
        },
        upload_start_handler: uploadStart,
        upload_progress_handler: uploadProgress,
        upload_error_handler: uploadError,
        upload_success_handler: function(file, serverData) {
            progressUplouder(file, serverData);
        },
        upload_complete_handler: uploadComplete_1,
        queue_complete_handler: queueComplete // Queue plugin event
    };

    try {
        oUploadannexupload = new SWFUpload(settings);
    } catch(e) {
        alert(e)
    }
}
// 初始化按钮并显示队列列表
function initBtnAndShowProgressList(numFilesSelected, numFilesQueued) {
    oUploadannexupload.startUpload();
}

// 显示成功列表信息，并创建文档
function progressUplouder(file, serverData) {
    try {
        var jsonobj = eval('(' + serverData + ')');
        
        var progress = new FileProgress(file, oUploadannexupload.customSettings.progressTarget);
        progress.toggleCancel(true);
        jQuery.ajax({
            type: "POST",
            url: "/rdeploy/doc/MultiDocMaintOpration.jsp?foldertype=" + $("#loadFolderType").val(),
            data: {
                imgFileId: jsonobj.imageid,
                seccategory: $("#fpid").val(),
                ownerid: $("#ownerid").val(),
                doclangurage: $("#doclangurage").val(),
                docdepartmentid: $("#docdepartmentid").val(),
                fileSize: file.size
            },
            cache: false,
            async: false,
            dataType: 'json',
            success: function(data) {
                if ($("#loadFolderType").val() == 'publicAll') {
                    dataJson[$("#fpid").val()].childrenDocs.push(data);
                } else {
                    privateDataJson[$("#fpid").val()].childrenDocs.push(data);
                }
              //  $(window.frames["contentFrame"].document).find("#" + file.id + "progressText").nextAll().remove();
                contentFrame.window.fullItemData($("#fpid").val());
            }
        });
    } catch(ex) {
        oUploadannexupload.debug(ex);
    }
}

function firstButtonLoad() {
    initFileupload('uploadButton', "800");
}

if (window.addEventListener) {
    window.addEventListener("load", firstButtonLoad, false);
} else if (window.attachEvent) {
    window.attachEvent("onload", firstButtonLoad);
} else {
    window.onload = firstButtonLoad;
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