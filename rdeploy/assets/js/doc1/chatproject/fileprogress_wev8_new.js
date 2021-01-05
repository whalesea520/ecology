
/*
	A simple class for displaying file information and progress
	Note: This is a demonstration only and not part of SWFUpload.
	Note: Some have had problems adapting this class in IE7. It may not be suitable for your application.
*/

// Constructor
// file is a SWFUpload file object
// targetID is the HTML element id attribute that the FileProgress HTML structure will be added to.
// Instantiating a new FileProgress object with an existing file will reuse/update the existing DOM elements
function FileProgress(file, targetID) {
	try {
		var fileIconName = "";
		this.fileProgressID = file.id;
		this.opacity = 100;
		this.height = 0;
		this.fileProgressWrapper = document.getElementById(this.fileProgressID);
		if (!this.fileProgressWrapper) {
	
		// 列表项
			this.fileProgressWrapper = $("<div />");
			this.fileProgressWrapper.addClass("progressWrapper");
			this.fileProgressWrapper.attr("id", this.fileProgressID);
		
		// 列表元素
			this.fileProgressElement = $("<div />");
			this.fileProgressElement.addClass("rprogressContainer rgreen");
		
		// 文件类型图标
			var fileIconDiv = $("<div />");
			fileIconDiv.addClass("fileIconDiv");
			var fileIcon = $("<img />");
			fileIcon.attr("id", this.fileProgressID + "Icon");
			fileIcon.attr("src", "/images/filetypeicons/shell32_dll_icon_1_wev8.gif");
			fileIconDiv.append(fileIcon);
		// 文件名称DIV
			var progressText = $("<div />");
			progressText.attr("id", this.fileProgressID + "progressText");
			progressText.addClass("rprogressName");
			progressText.append(file.name);
		
		// 错误提示
			var progressError = $("<div />");
			progressError.addClass("rprogressError");
			progressError.attr("id", this.fileProgressID + "progressError");
		
		// 文件大小
			var progressFileSize = $("<div />");
			progressFileSize.addClass("fileSize");
			var size = "";
			var Digit = {};
			Digit.round = function (digit, length) {
				length = length ? parseInt(length) : 0;
				if (length <= 0) {
					return Math.round(digit);
				}
				digit = Math.round(digit * Math.pow(10, length)) / Math.pow(10, length);
				return digit;
			};
			if (file.size / 1024 / 1024 > 1) {
				size = (Digit.round(file.size / 1024 / 1024, 2)) + "M";
			} else {
				if (file.size / 1024 > 1) {
					size = (Digit.round(file.size / 1024, 2)) + "K";
				} else {
					size = Digit.round(file.size, 2) + "B";
				}
			}
			progressFileSize.append(size);
		
		// 文件状态
			var progressStatus = $("<div />");
			progressStatus.attr("id", this.fileProgressID + "rprogressBarStatus");
			progressStatus.addClass("rprogressBarStatus");
		
		// 取消链接
			var progressCancela = $("<div />");
			progressCancela.attr("id", this.fileProgressID + "cancelDiv");
			progressCancela.addClass("cancelDiv");
			progressCancela.bind("click", function () {
				cancelUploadFile($(this).parent().parent().attr("id"));
			});
		
		// 清除浮动
			var clearBoth = $("<div />");
			clearBoth.addClass("clearBoth");
		
		// 分隔线
			var rprogressBarInProgressLine = $("<div />");
			rprogressBarInProgressLine.addClass("rprogressBarInProgressLine");
		
		// 进度条
			var progressBarLink = $("<div />");
			progressBarLink.attr("id", this.fileProgressID + "progressBar");
			progressBarLink.addClass("rprogressBarInProgress");
		
		// 隐藏域，保存文档ID
			var docidInput = $("<input />");
			docidInput.attr("id", this.fileProgressID + "docid");
			docidInput.attr("type", "hidden");
			
			
			this.fileProgressElement.append(fileIconDiv);
			this.fileProgressElement.append(progressText);
			this.fileProgressElement.append(progressError);
			this.fileProgressElement.append(progressFileSize);
			this.fileProgressElement.append(progressStatus);
			this.fileProgressElement.append(progressCancela);
			this.fileProgressElement.append(clearBoth);
			this.fileProgressElement.append(rprogressBarInProgressLine);
			this.fileProgressElement.append(progressBarLink);
			this.fileProgressElement.append(docidInput);
			
			this.fileProgressElement.bind({
                mouseenter: function(e) {
                    $(this).css('background', '#fffdf3 none repeat scroll 0 0');
                    console.log($("#" + $(this).parent().attr("id") + "cancelDiv"));
                    $("#" + $(this).parent().attr("id") + "cancelDiv").show();
                },
                mouseleave: function(e) {
                   $(this).css('background', '#fff none repeat scroll 0 0');
                   $("#" + $(this).parent().attr("id") + "cancelDiv").hide();
                }
            });
		
		// 添加文件进程列表
			this.fileProgressWrapper.append(this.fileProgressElement);
		// 添加列表项
			$("#" + targetID).prepend(this.fileProgressWrapper);
		} else {
			this.fileProgressElement = this.fileProgressWrapper.firstChild;
		}
		this.height = this.fileProgressWrapper.offsetHeight;
	}
	catch (ex) {
		console.log(ex);
	}
}
function cancelUploadFile(file_id) {
	var docid = $("#" + file_id + "docid").val();
	if (docid != null && docid != "") {
		jQuery.ajax({type:"POST", url:"/rdeploy/doc/DelDocInfo.jsp", data:{docId:docid}, cache:false, async:false, dataType:"json", success:function (msg) {
		}});
		$("#" + file_id).fadeOut("slow");
		contentFrame.window.$("#" + docid + "ItemId").fadeOut("slow");
		
		var sucount = parseInt(jQuery("#suCount").text());
                	$("#suCount").empty();
                	$("#suCount").append(sucount-1);
	} else {
		oUploadannexupload.cancelUpload(file_id, false);
		$("#" + file_id).fadeOut("slow");
	}
	 var count = parseInt(jQuery("#count").text());
                	$("#count").empty();
                	$("#count").append(count-1);
}
FileProgress.prototype.setProgress = function (percentage) {
	this.fileProgressElement.className = "rprogressContainer rgreen";
	this.fileProgressElement.childNodes[8].className = "rprogressBarInProgress";
	this.fileProgressElement.childNodes[8].style.width = percentage + "%";
};
FileProgress.prototype.setComplete = function () {
	this.fileProgressElement.className = "rprogressContainer blue";
	this.fileProgressElement.childNodes[6].className = "progressBarComplete";
	this.fileProgressElement.childNodes[6].style.width = "";
	var oSelf = this;
	setTimeout(function () {
		oSelf.disappear();
	}, 5000);
};
FileProgress.prototype.setError = function (errorCode) {
	$("#" + this.fileProgressID + "progressError").append(errorCode);
};
FileProgress.prototype.setCancelled = function () {
	this.fileProgressElement.className = "rprogressContainer";
	this.fileProgressElement.childNodes[6].className = "progressBarError";
	this.fileProgressElement.childNodes[6].style.width = "";
	var oSelf = this;
	setTimeout(function () {
		oSelf.disappear();
	}, 500);
};
FileProgress.prototype.setStatus = function (status) {
	try {
		if (status == "\u4e0a\u4f20\u6210\u529f") {
			$("#" + this.fileProgressID + "rprogressBarStatus").css("color", "#3fca6a");
			$("#" + this.fileProgressID + "progressBar").hide();
		} else {
			$("#" + this.fileProgressID + "rprogressBarStatus").css("color", "#fd7474");
		}
		$("#" + this.fileProgressID + "rprogressBarStatus").empty();
		$("#" + this.fileProgressID + "rprogressBarStatus").append(status);
	}
	catch (ex) {
		console.log(ex);
	}
};

// Show/Hide the cancel button
FileProgress.prototype.toggleCancel = function (show, swfUploadInstance) {
	$("#" + this.fileProgressID + "cancelDiv").css("visibility", show ? "visible" : "hidden");
	if (swfUploadInstance) {
		var fileID = this.fileProgressID;
		$("#" + fileID + "cancelDiv").bind("click", function () {
			swfUploadInstance.cancelUpload(fileID);
			return false;
		});
	}
};

// Fades out and clips away the FileProgress box.
FileProgress.prototype.disappear = function () {
	var reduceOpacityBy = 15;
	var reduceHeightBy = 4;
	var rate = 30;	// 15 fps
	if (this.opacity > 0) {
		this.opacity -= reduceOpacityBy;
		if (this.opacity < 0) {
			this.opacity = 0;
		}
		if (this.fileProgressWrapper.filters) {
			try {
				this.fileProgressWrapper.filters.item("DXImageTransform.Microsoft.Alpha").opacity = this.opacity;
			}
			catch (e) {
				// If it is not set initially, the browser will throw an error.  This will set it if it is not set yet.
				this.fileProgressWrapper.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=" + this.opacity + ")";
			}
		} else {
			this.fileProgressWrapper.style.opacity = this.opacity / 100;
		}
	}
	if (this.height > 0) {
		this.height -= reduceHeightBy;
		if (this.height < 0) {
			this.height = 0;
		}
		this.fileProgressWrapper.style.height = this.height + "px";
	}
	if (this.height > 0 || this.opacity > 0) {
		var oSelf = this;
		setTimeout(function () {
			oSelf.disappear();
		}, rate);
	} else {
		this.fileProgressWrapper.style.display = "none";
	}
};

