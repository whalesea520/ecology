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
	this.fileProgressID = file.id;

	this.opacity = 100;
	this.height = 0;

	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	if (!this.fileProgressWrapper) {
		this.fileProgressWrapper = document.createElement("div");
		this.fileProgressWrapper.className = "progressWrapper";
		this.fileProgressWrapper.id = this.fileProgressID;

		this.fileProgressElement = document.createElement("div");
		this.fileProgressElement.className = "progressContainer";

		var progressCancel = document.createElement("span");
		progressCancel.className = "progressCancel";
		//progressCancel.href = "#";
		progressCancel.style.visibility = "hidden";
		progressCancel.appendChild(document.createTextNode(" "));



		var progressText = document.createElement("div");
		progressText.className = "progressName";
		progressText.appendChild(document.createTextNode(decodeURIComponent(file.name)));

		var progressBar = document.createElement("div");
		progressBar.className = "progressBarInProgress";

		var progressStatus = document.createElement("div");
		progressStatus.className = "progressBarStatus";
		progressStatus.innerHTML = "&nbsp;";

		this.fileProgressElement.appendChild(progressCancel);
		this.fileProgressElement.appendChild(progressText);
		this.fileProgressElement.appendChild(progressStatus);
		this.fileProgressElement.appendChild(progressBar);

		this.fileProgressWrapper.appendChild(this.fileProgressElement);

		document.getElementById(targetID).appendChild(this.fileProgressWrapper);
	} else {
		this.fileProgressElement = this.fileProgressWrapper.firstChild;
	}

	this.height = this.fileProgressWrapper.offsetHeight;

}
FileProgress.prototype.setProgress = function (percentage) {
	this.fileProgressElement.className = "progressContainer green";
	this.fileProgressElement.childNodes[3].className = "progressBarInProgress";
	this.fileProgressElement.childNodes[3].style.width = percentage + "%";
};
FileProgress.prototype.setComplete = function () {
	this.fileProgressElement.className = "progressContainer blue";
	this.fileProgressElement.childNodes[3].className = "progressBarComplete";
	this.fileProgressElement.childNodes[3].style.width = "";

	var oSelf = this;
	setTimeout(function () {
		oSelf.disappear();
	}, 5000);
};
FileProgress.prototype.setError = function () {
	this.fileProgressElement.className = "progressContainer red";
	this.fileProgressElement.childNodes[3].className = "progressBarError";
	this.fileProgressElement.childNodes[3].style.width = "";

	var oSelf = this;
	setTimeout(function () {
		oSelf.disappear();
	}, 2500);
};
FileProgress.prototype.setCancelled = function (swfUploadInstance) {
	this.fileProgressElement.className = "progressContainer";
	this.fileProgressElement.childNodes[3].className = "progressBarError";
	this.fileProgressElement.childNodes[3].style.width = "";
    //upfilesnum--;
    showmustinput(swfUploadInstance);
	var oSelf = this;
	setTimeout(function () {
		oSelf.disappear();
	}, 500);
};
FileProgress.prototype.setStatus = function (status) {
	this.fileProgressElement.childNodes[2].innerHTML = status;
};

// Show/Hide the cancel button
FileProgress.prototype.toggleCancel = function (show, swfUploadInstance) {
	this.fileProgressElement.childNodes[0].style.visibility = show ? "visible" : "hidden";
	if (swfUploadInstance) {
		var fileID = this.fileProgressID;
		//流程测试情况下，第一个元素变成具体链接了，所以换种方式绑定a标签
		
		jQuery("#"+fileID).find(".progressCancel").bind("click",function(e){
			swfUploadInstance.cancelUpload(fileID);
			return false;
		});
		//this.fileProgressElement.childNodes[0].onclick = function () {
		//	swfUploadInstance.cancelUpload(fileID);
		//	return false;
		//};
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


function FileProgressDt(file, targetID) {
	this.fileProgressID = file.id;

	this.opacity = 100;
	this.height = 0;

	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	if (!this.fileProgressWrapper) {
		this.fileProgressWrapper = document.createElement("div");
		this.fileProgressWrapper.className = "progressWrapper_dt";
		this.fileProgressWrapper.id = this.fileProgressID;

		this.fileProgressElement = document.createElement("div");
		this.fileProgressElement.className = "progressContainer_dt";

		var progressCancel = document.createElement("a");
		progressCancel.className = "progressCancel_dt";
		progressCancel.href = "#";
		progressCancel.style.visibility = "hidden";
		progressCancel.appendChild(document.createTextNode(" "));



		var progressText = document.createElement("div");
		progressText.className = "progressName_dt";
		progressText.appendChild(document.createTextNode(decodeURIComponent(file.name)));

		var progressBar = document.createElement("div");
		progressBar.className = "progressBarInProgress_dt";

		var progressStatus = document.createElement("div");
		progressStatus.className = "progressBarStatus_dt";
		progressStatus.innerHTML = "&nbsp;";

		this.fileProgressElement.appendChild(progressCancel);
		this.fileProgressElement.appendChild(progressText);
		this.fileProgressElement.appendChild(progressStatus);
		this.fileProgressElement.appendChild(progressBar);

		this.fileProgressWrapper.appendChild(this.fileProgressElement);

		document.getElementById(targetID).appendChild(this.fileProgressWrapper);
	} else {
		this.fileProgressElement = this.fileProgressWrapper.firstChild;
	}

	this.height = this.fileProgressWrapper.offsetHeight;

}
FileProgressDt.prototype.setProgress = function (percentage) {
	this.fileProgressElement.className = "progressContainer_dt green";
	this.fileProgressElement.childNodes[3].className = "progressBarInProgress_dt";
	this.fileProgressElement.childNodes[3].style.width = percentage + "%";
};
FileProgressDt.prototype.setComplete = function () {
	this.fileProgressElement.className = "progressContainer_dt blue";
	this.fileProgressElement.childNodes[3].className = "progressBarComplete_dt";
	this.fileProgressElement.childNodes[3].style.width = "";

	var oSelf = this;
	setTimeout(function () {
		oSelf.disappear();
	}, 5000);
};
FileProgressDt.prototype.setError = function () {
	this.fileProgressElement.className = "progressContainer_dt red";
	this.fileProgressElement.childNodes[3].className = "progressBarError_dt";
	this.fileProgressElement.childNodes[3].style.width = "";

	var oSelf = this;
	setTimeout(function () {
		oSelf.disappear();
	}, 2500);
};
FileProgressDt.prototype.setCancelled = function (swfUploadInstance) {
	this.fileProgressElement.className = "progressContainer_dt";
	this.fileProgressElement.childNodes[3].className = "progressBarError_dt";
	this.fileProgressElement.childNodes[3].style.width = "";
    //upfilesnum--;
    showmustinput(swfUploadInstance);
	var oSelf = this;
	setTimeout(function () {
		oSelf.disappear();
	}, 500);
};
FileProgressDt.prototype.setStatus = function (status) {
	this.fileProgressElement.childNodes[2].innerHTML = status;
};

// Show/Hide the cancel button
FileProgressDt.prototype.toggleCancel = function (show, swfUploadInstance) {
	this.fileProgressElement.childNodes[0].style.visibility = show ? "visible" : "hidden";
	if (swfUploadInstance) {
		var fileID = this.fileProgressID;
		this.fileProgressElement.childNodes[0].onclick = function () {
			//jQuery("#"+fileID).css("display","none");
			swfUploadInstance.cancelUpload(fileID);
			return false;
		};
	}
};

// Fades out and clips away the FileProgress box.
FileProgressDt.prototype.disappear = function () {

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