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
	var fileIconName = "";
	this.fileProgressID = file.id;
	this.opacity = 100;
	this.height = 0;
	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	
	if (!this.fileProgressWrapper) {
	if($("#"+this.fileProgressID+"hiddens").length <= 0)
	{
		// 列表项
		this.fileProgressWrapper = document.createElement("div");
		this.fileProgressWrapper.className = "progressWrapper";
		this.fileProgressWrapper.id = this.fileProgressID;
		// 列表元素
		this.fileProgressElement = document.createElement("div");
		this.fileProgressElement.className = "rprogressContainer";


		// 取消链接
		var progressCancela = document.createElement("div");
		progressCancela.className = "cancelDiv";
		var progressCancel = document.createElement("a");
		progressCancel.id = file.id+"CancelA";
		progressCancel.className = "rprogressCancel";
		progressCancel.href = "#";
		progressCancel.appendChild(document.createTextNode(" "));
		progressCancela.appendChild(progressCancel);
		// 文件类型图标
		var fileIconDiv = document.createElement("div");
		fileIconDiv.className = "fileIconDiv";
		var fileIcon = document.createElement("img");
		fileIcon.className = "";
		fileIcon.id = file.id+"Icon";
		
		 var iconPath="shell32_dll_icon_1_wev8.gif";  
		if($("#"+file.type).length > 0)
		{
			iconPath = $("#"+file.type).val();
		}
		fileIcon.src = "/images/filetypeicons/"+iconPath;
		fileIconDiv.appendChild(fileIcon);
		
		// 文件名称DIV
		var progressText = document.createElement("div");
		progressText.className = "rprogressName";
		progressText.id = file.id+"progressText";
		progressText.appendChild(document.createTextNode(file.name));
		
		
		// 错误提示
		var progressError = document.createElement("div");
		progressError.className = "rprogressError";
		progressError.id = file.id+"progressError"
		progressError.innerHTML = "&nbsp;";
		
		
		// 文件状态
		var progressStatus = document.createElement("div");
		progressStatus.className = "rprogressBarStatus";
		progressStatus.innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;";
		
		// 文件大小DIV
		var fileSize = document.createElement("div");
		fileSize.className = "fileSize";
		var size = "";
		var Digit = {};
			Digit.round = function(digit, length) {
		    length = length ? parseInt(length) : 0;
		    if (length <= 0) return Math.round(digit);
		    digit = Math.round(digit * Math.pow(10, length)) / Math.pow(10, length);
		    return digit;
		};
		if(file.size/1024/1024 > 1)
		{
			size = (Digit.round(file.size/1024/1024, 2))+"M";
		}
		else if(file.size/1024 > 1)
		{
			size = (Digit.round(file.size/1024, 2))+"K";
		}
		else
		{
			size = Digit.round(file.size, 2)+"B";
		}
		
		fileSize.innerHTML = size;
		
		
		// 清除浮动
		var clearBoth = document.createElement("div");
		clearBoth.className = "clearBoth";
		clearBoth.innerHTML = "";
		
		// 进度条
		var progressBar = document.createElement("div");
		progressBar.id = file.id+"progressBar";
		progressBar.className = "rprogressBarInProgress";
		
		// 进度条
		var progressBarLink = document.createElement("div");
		progressBarLink.className = "rprogressBarInProgressLine";
		
		this.fileProgressElement.appendChild(fileIconDiv);
		this.fileProgressElement.appendChild(progressText);
		
		this.fileProgressElement.appendChild(progressError);
		
		this.fileProgressElement.appendChild(fileSize);
		this.fileProgressElement.appendChild(progressStatus);
		this.fileProgressElement.appendChild(progressCancela);
		this.fileProgressElement.appendChild(clearBoth);
		this.fileProgressElement.appendChild(progressBarLink);
		this.fileProgressElement.appendChild(progressBar);

		// 添加文件进程列表
		this.fileProgressWrapper.appendChild(this.fileProgressElement);

		// 添加列表项
		document.getElementById(targetID).appendChild(this.fileProgressWrapper);
		}
	} else {
		this.fileProgressElement = this.fileProgressWrapper.firstChild;
	}
	this.height = this.fileProgressWrapper.offsetHeight;
}


FileProgress.prototype.setProgress = function (percentage) {
	if($("#"+this.fileProgressID+"hiddens").length > 0)
	{
		this.disappear();
	}
	else
	{
		this.fileProgressElement.className = "rprogressContainer rgreen";
		this.fileProgressElement.childNodes[8].className = "rprogressBarInProgress";
		this.fileProgressElement.childNodes[8].style.width = percentage + "%";
	}
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
FileProgress.prototype.setError = function () {
	// this.fileProgressElement.className = "rprogressContainer red";
	// this.fileProgressElement.childNodes[5].className = "progressBarError";
	// this.fileProgressElement.childNodes[5].style.width = "";

	var oSelf = this;
	setTimeout(function () {
	//	oSelf.disappear();
	}, 250000);
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
	this.fileProgressElement.childNodes[4].innerHTML = status;
	
};

// Show/Hide the cancel button
FileProgress.prototype.toggleCancel = function (show, swfUploadInstance) {
	this.fileProgressElement.childNodes[5].style.visibility = show ? "visible" : "hidden";
	if (swfUploadInstance) {
		var fileID = this.fileProgressID;
		this.fileProgressElement.childNodes[5].onclick = function () {
			swfUploadInstance.cancelUpload(fileID);
			return false;
		};
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
			} catch (e) {
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