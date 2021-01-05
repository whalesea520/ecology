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