jQuery(function(){

    if(window.__isBrowser)return;

	//初始化未完成的上传进程
	if(uploadList.length > 0){
		var uploadSize = 0;
		var totalSize = 0;
		for(var i = 0 ;i < uploadList.length;i++){
			var data = uploadList[i];
			data.status = "stop";
			fillFileProcess(data,"upload","no");
			uploadSize = parseInt(data.uploadSize ? data.uploadSize : 0) + parseInt(uploadSize);
			totalSize = parseInt(data.fileSize ? data.fileSize : 0) + parseInt(totalSize);
			
			var filepr = getFilepr(parseInt(data.fileSize),parseInt(data.uploadSize));
			fillProgressBar(data.id,filepr);
		}
		jQuery("#upload_current").show();
		
		var fileprfull = getFilepr(parseInt(totalSize),parseInt(uploadSize));
		
		fillFullProcess(fileprfull,"upload");
		
		uploadedSizeCount = uploadSize;
		
		uploadSizeCount = totalSize;
		
		jQuery("#uploadingContent .stopAll").html(warmFont.allContinue);
	}
	
	
	//初始化未完成的下载进程
	if(downloadList.length > 0){
		
		var downloadSize = 0;
		var totalSize = 0;
		
		for(var i = 0 ;i < downloadList.length;i++){
			var data = downloadList[i];
			data.status = "stop";
			fillFileProcess(data,"download","no");
			var filetempsize = getFileTempSize(data.filePath+"\\"+data.fileName+"_"+data.id);
			
			downloadSize = parseInt(filetempsize) + parseInt(downloadSize);
			
			totalSize = parseInt(data.fileSize ? data.fileSize : 0) + parseInt(totalSize);
			
			var filepr = getFilepr(data.fileSize,parseInt(filetempsize));
			
			fillProgressBar(data.id,filepr);
		}
		jQuery("#download_current").show();
		fillFullProcess(getFilepr(totalSize,downloadSize),"download");
		
		downloadSizeCount = totalSize;
		downloadedSizeCount = downloadSize;
		
		jQuery("#downloadingContent .stopAll").html(warmFont.allContinue);
	}
	
	if(uploadLogList.length > 0){
		jQuery("#uploading").click();
	}else if(downloadLogList.length > 0){
		jQuery("#downloading").click();
	}else{
		jQuery("#sendComplete").click();
	}
	
	//初始化已完成的未清空的上传列表
	if(uploadLogList.length > 0){
		for(var i = 0 ;i < uploadLogList.length;i++){
			var data = uploadLogList[i];
			fillFileProcess(data,"upload","no");
			fillProgressBar(data.id,100,"no");
		}
	}
	//初始化已完成的未清空的下载列表
	if(downloadLogList.length > 0){
		for(var i = 0 ;i < downloadLogList.length;i++){
			var data = downloadLogList[i];
			fillFileProcess(data,"download","no");
			fillProgressBar(data.id,100,"no");
		}
	}
	//初始化已完成的未清空的同步列表
	if(syncLogList.length > 0){
		for(var i = 0 ;i < syncLogList.length;i++){
			var data = syncLogList[i];
			fillSyncFileProcess(data,"no");
		}
	}

	//tab切换
	jQuery("#fullTab .tab").live({
		click : function(){
			var _id = this.id;
			jQuery(this).addClass("select").siblings(".select").removeClass("select");
			var _msg =warmFont.noTransfer;
			if(_id == "allProcee")
				jQuery("#fullContent").children().show();
			else if(_id == "uploadComplete"){
				jQuery("#fullContent").find(".uploadComplete").closest(".fsUploadProgressannexupload").show();
				jQuery("#fullContent").find(".downloadComplete").closest(".fsUploadProgressannexupload").hide();
				_msg = warmFont.noUpload;
			}else if(_id == "downloadComplete"){
				jQuery("#fullContent").find(".downloadComplete").closest(".fsUploadProgressannexupload").show();
				jQuery("#fullContent").find(".uploadComplete").closest(".fsUploadProgressannexupload").hide();
				_msg = warmFont.noDownload;
			}
			var _num = jQuery("#" + _id + " .processNum").html();
			_num = _num == "" ? 0 : _num;
			if(_num <= 0){
				jQuery("#sendCompleteContent .clearRecord").hide();
				jQuery("#fullContent + .empty_data").show().html(_msg);
			}else{
				jQuery("#sendCompleteContent .clearRecord").show();
				jQuery("#fullContent + .empty_data").hide().html(_msg);
			}	
			
		}
	});
	
	//暂停
	jQuery(".stopFile .operateBgImage").live({
		click : function(){
			jQuery(this).parent().removeClass("stopFile").addClass("startFile").attr("title","继续");
			var _type = jQuery(this).closest(".progressWrapper").find(".SWFUpload_type").val(); 
			var _id = jQuery(this).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
			var _uid = jQuery(this).closest(".progressWrapper").attr("dataid");
			if(_type == "upload"){
				if(jQuery("#uploadingContent .stopFile").length == 0){
					jQuery("#uploadingContent .stopAll").html(warmFont.allContinue);
				}else{
					jQuery("#uploadingContent .stopAll").html(warmFont.allStop);
				}
				if(isExistUpload(_uid,2)){ //存在多个
					jQuery(".progressWrapper[dataid='" + _uid + "']").find(".cantDo").removeClass("cantDo").addClass("startFile").attr("title","继续");
				}
				pauseUpload(_id);
			}else if(_type == "download"){
				if(jQuery("#downloadingContent .stopFile").length == 0){
					jQuery("#downloadingContent .stopAll").html(warmFont.allContinue);
				}else{
					jQuery("#downloadingContent .stopAll").html(warmFont.allStop);
				}
				pauseDownload(_uid);
			}
			_stopUpload(_id);
		}
	});
	
	//继续
	jQuery(".startFile .operateBgImage").live({
		click : function(){
			jQuery(this).parent().removeClass("startFile").addClass("stopFile").attr("title","暂停");
			var _diskPath = jQuery(this).closest(".progressWrapper").find(".SWFUpload_path").val();
			var _totalSize = jQuery(this).closest(".progressWrapper").find(".SWFUpload_totalSize").val();
			var _type = jQuery(this).closest(".progressWrapper").find(".SWFUpload_type").val();
			var _uid = jQuery(this).closest(".progressWrapper").attr("dataid");
			var _id = jQuery(this).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
			_startUpload(_id);
			if(_type == "upload"){
				jQuery("#uploadingContent .stopAll").html(warmFont.allStop);
				if(isExistUpload(_uid,2)){ //存在多个
					jQuery(".progressWrapper[dataid='" + _uid + "']").find(".startFile").removeClass("startFile").addClass("cantDo")
						.parent().siblings(".rprogressBarStatus").html(warmFont.waitingUpload);
				}
				var _size = jQuery(this).closest(".progressWrapper").find(".SWFUpload_size").val();
				resumeUpload(_diskPath,_totalSize,_size,_uid,_id);
			}else if(_type == "download"){
				jQuery("#downloadingContent .stopAll").html(warmFont.allStop);
				var _name =  jQuery(this).closest(".progressWrapper").find(".rprogressName").attr("title"); 
				var item = {id:_id,uid:_uid,filename:_name,filesize:_totalSize};
				resumeDownload(item,_diskPath);
			}
		}
	});
	
	//删除
	jQuery(".cancelFile .operateBgImage").live({
		click : function(){
			var that = this;
			window.top.Dialog.confirm(warmFont.sureCancel,function(){
				var _uid = jQuery(that).closest(".progressWrapper").attr("dataid");
				var _type = jQuery(that).closest(".progressWrapper").find(".SWFUpload_type").val();
				var _id = jQuery(that).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
				deleteUploadProgess(_id);
				jQuery(".progressWrapper[dataid='" + _uid + "']").find(".cantDo").removeClass("cantDo").addClass("startFile").attr("title","继续");
				var stopNum = jQuery(".progressWrapper[dataid='" + _uid + "']").find(".startFile").length;
				var startNum = jQuery(".progressWrapper[dataid='" + _uid + "']").find(".stopFile").length;
				
				if(_type == "upload")
				{
					if(startNum > 0){
						jQuery("#uploadingContent .stopAll").html(warmFont.allStop);
					}else if(stopNum > 0){
						jQuery("#uploadingContent .stopAll").html(warmFont.allContinue);
					}
					cancelUpload(_id);
				}
				else
				{
					if(startNum > 0){
						jQuery("#downloadingContent .stopAll").html(warmFont.allStop);
					}else if(stopNum > 0){
						jQuery("#downloadingContent .stopAll").html(warmFont.allContinue);
					}
					deleteDownloadTemp(_id);
				}
			});
		}
	});
	
	//全部暂停、全部继续
	jQuery(".stopAll").click(function(){
		var _txt = jQuery(this).html();
		var _type = jQuery(this).closest("[id*='ingContent']").attr("id") == "uploadingContent" ? "upload" : "download";
		if(_txt == warmFont.allStop){
			jQuery(this).html(warmFont.allContinue);
			jQuery(this).closest(".fullProcess").next(".contentProcess").find(".stopFile").each(function(){
				jQuery(this).removeClass("stopFile").addClass("startFile").attr("title","继续");
				var _id = jQuery(this).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
				_stopUpload(_id);
			});
			if(_type == "upload"){
				pauseAllUpload();
			}else if(_type == "download"){
				pauseAllDownload();
			}
		}else if(_txt == warmFont.allContinue){
			jQuery(this).html(warmFont.allStop);
			var itemMap = {};
			jQuery(this).closest(".fullProcess").next(".contentProcess").find(".startFile").each(function(i){
				jQuery(this).removeClass("startFile").addClass("stopFile").attr("title","暂停");
				var _id = jQuery(this).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
				var _diskPath = jQuery(this).closest(".progressWrapper").find(".SWFUpload_path").val();
				var _totalSize = jQuery(this).closest(".progressWrapper").find(".SWFUpload_totalSize").val();
				var _size = jQuery(this).closest(".progressWrapper").find(".SWFUpload_size").val();
				var _uid = jQuery(this).closest(".progressWrapper").attr("dataid");
				var _uploadfileguid = jQuery(this).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
				
				var _name =  jQuery(this).closest(".progressWrapper").find(".rprogressName").attr("title"); 
				itemMap[i] = {
						diskPath : _diskPath,
						totalSize : _totalSize,
						size : _size,
						fileMd5 : _uid,
						uploadfileguid : _uploadfileguid,
						id : _id,
						filename : _name
					};
				_startUpload(_id);
			});
			if(_type == "upload"){
				resumeAllUpload(itemMap);
			}else if(_type == "download"){
				resumeAllDownload(itemMap);
			}
		}
	});
	
	//全部取消
	jQuery(".cancelAll").click(function(){
		var that = this;
		
		var itemMap = [];
		
		window.top.Dialog.confirm(warmFont.sureCancel,function(){
			var _type = jQuery(that).closest("[id*='ingContent']").attr("id") == "uploadingContent" ? "upload" : "download";
			jQuery(that).closest(".fullProcess").next(".contentProcess").find(".cancelFile").each(function(){
				var _id = jQuery(this).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
				deleteUploadProgess(_id);
				itemMap.push(_id);
			});
			
			
			if(_type == "upload"){
				cancelAllUpload(itemMap);
			}else if(_type == "download"){
				cancelAllDownload(itemMap);
			}
		});
	});
	
	
	//打开上传、下载、同步文件
	jQuery(".openFile").live({
		click : function(){
			if(jQuery(this).hasClass("downloadIcon")){ //下载
				var localPath = jQuery(this).closest(".rprogressContainer").children(".SWFUpload_path").val();
				var filename = jQuery(this).closest(".rprogressContainer").children(".rprogressName").attr("title");
				openLocalPath(localPath + (/\\$/.test(localPath) ? "" : "\\") + filename,true);
			}else{//上传、同步
				var imagefileid = jQuery(this).closest(".rprogressContainer").children(".SWFUpload_fileid").val();
				//openFullWindowForXtable("/rdeploy/chatproject/doc/imageFileView.jsp?fileid=" + imagefileid); 
				if(window.VIEW_MODEL == "disk"){
					parent.openUrl("/rdeploy/chatproject/doc/imageFileView.jsp?fileid=" + imagefileid); 
				}else{
					getDocIdByImageFileid(imagefileid,function(docid){
						 parent.openUrl("/docs/docs/DocDsp.jsp?id="+docid); 
					})
				}
			} 
		}
	});
	//打开上传、下载、同步文件所在文件夹
	jQuery(".openFolder").live({
		click : function(){
			if(jQuery(this).hasClass("downloadIcon")){ //下载
				var localPath = jQuery(this).closest(".rprogressContainer").children(".SWFUpload_path").val();
				var filename = jQuery(this).closest(".rprogressContainer").children(".rprogressName").attr("title");
				openLocalPath(localPath + (/\\$/.test(localPath) ? "" : "\\") + filename,false);
			}else{//上传、同步
				//var categoryid = jQuery(this).closest(".rprogressContainer").children(".SWFUpload_categoryid").val();
				var fileid = jQuery(this).closest(".rprogressContainer").children(".SWFUpload_fileid").val();
				jQuery.ajax({
					url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
					type : "post",
					data : {fileid : fileid,type : "cateExist",isSystemDoc : (window.VIEW_MODEL == "disk" ? 0 : 1)},
					dataType : "json",
					success : function(data){
						if(data && data.flag == "1"){
							var categoryid = data.categoryid;
							if(window.VIEW_MODEL == "disk" && privateIdMap[categoryid]){
								randerNav(categoryid);
								document.getElementById("contentFrame").contentWindow.fullPrivateItemData(categoryid,privateIdMap[categoryid]);
							}else if(window.VIEW_MODEL == "systemDoc" && publicIdMap[categoryid]){
								randerNav(categoryid);
								document.getElementById("contentFrame").contentWindow.fullItemData(categoryid,publicIdMap[categoryid]);
							}else{
								if(window.VIEW_MODEL == "disk" && (categoryid == "" || categoryid == "0")){
									document.getElementById("contentFrame").contentWindow.fullPrivateItemData(0,privateIdMap[0]);
								}else{
									getParentCategorys(categoryid,function(len,categoryid){
										randerNav(categoryid);
										if(len == 0){
											window.top.Dialog.alert(warmFont.categoryNotExist);
										}else{
											if(window.VIEW_MODEL == "disk"){
												document.getElementById("contentFrame").contentWindow.fullPrivateItemData(categoryid,privateIdMap[categoryid]);
											}else{
												document.getElementById("contentFrame").contentWindow.fullItemData(categoryid,publicIdMap[categoryid]);
											}
										}
									});
								}
							}
						}else{
							//window.top.Dialog.alert("文件已删除!");
							_prompt2Warn("文件已被删除!");
						}
					}
				})
				
			}
		}
	});
	//清空上传、下载、同步记录
	jQuery(".clearFile").live({
		click : function(){
			var _liId = jQuery(this).closest("li").attr("id");
			var id = jQuery(this).closest(".progressWrapper").find(".SWFUpload_logid").val();
			var that = this;
			showLoading();
			jQuery.ajax({
				url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
				type : "post",
				data : {id : id,type : "clearSinglefileLog",uid : userInfos.guid,isSystemDoc : (window.VIEW_MODEL == "disk" ? 0 : 1)},
				dataType : "json",
				success : function(data){
					hideLoading();
					if(data && data.flag == "1"){
						jQuery(that).closest(".fsUploadProgressannexupload").remove();
						if(_liId == "sendCompleteContent"){ //传输完成
							var _select = jQuery("#fullTab .select").attr("id");
							var _totalnum = jQuery("#fullContent .fsUploadProgressannexupload").length;
							var _uploadnum = jQuery("#fullContent .uploadComplete").length;
							var _downloadnum = jQuery("#fullContent .downloadComplete").length;
							jQuery("#sendComplete").find(".num").html(_totalnum);
							jQuery("#allProcee").find(".processNum").html(_totalnum);
							jQuery("#uploadComplete").find(".processNum").html(_uploadnum);
							jQuery("#downloadComplete").find(".processNum").html(_downloadnum);
							if(_totalnum == 0){
								jQuery("#allProcee .processSpan").hide();
								jQuery("#sendComplete .numSpan").hide();
							}
							if(_uploadnum == 0)
								jQuery("#uploadComplete .processSpan").hide();
							if(_downloadnum == 0)
								jQuery("#downloadComplete .processSpan").hide();
							
							if((_select == "allProcee" && _totalnum == 0) || 
									(_select == "uploadComplete" && _uploadnum == 0) || 
									(_select == "downloadComplete" && _downloadnum == 0)){
								jQuery("#fullTab .clearRecord").hide();
								jQuery("#sendCompleteContent .empty_data").show();	
							}
							
						}else if(_liId == "syncCompleteContent"){//同步完成
							var _totalnum = jQuery("#syncCompleteContent .fsUploadProgressannexupload").length
							jQuery("#syncComplete .numSpan .num").html(_totalnum);
							jQuery("#syncCompleteContent .syncCompleteMsg .processNum").html(_totalnum);
							if(_totalnum == 0){
								jQuery("#syncComplete .numSpan").hide();
								jQuery("#syncCompleteContent .fullProcess").hide();
								jQuery("#syncCompleteContent .empty_data").show();
							}
						}
					}else{
						window.top.Dialog.alert(warmFont.operateFail);
					}
				},
				error : function(){
					hideLoading();
					window.top.Dialog.alert(warmFont.netAnomaly);
				}
			});
		}
				
	});
	
	//清空全部上传、下载、同步记录
	jQuery(".clearRecord").click(function(){
		var _liId = jQuery(this).closest("li").attr("id");
		var _type = "";
		var $removeObj;
		if(_liId == "sendCompleteContent"){ //清空所有传输数据(当前状态:全部、上传、下载)
			var _range = jQuery("#fullTab .select").attr("id");
			if(_range == "allProcee"){ //全部
				_type = "all";
				$removeObj = jQuery("#fullContent .fsUploadProgressannexupload");
			}else if(_range == "uploadComplete"){//上传
				_type = "upload";
				$removeObj = jQuery("#fullContent .uploadComplete").closest(".fsUploadProgressannexupload");
			}else if(_range == "downloadComplete"){//下载
				_type = "download";
				$removeObj = jQuery("#fullContent .downloadComplete").closest(".fsUploadProgressannexupload");
			}
		}else if(_liId == "syncCompleteContent"){// 清空所有同步数据
			_type = "sync";
			$removeObj = jQuery("#syncCompleteContent .fsUploadProgressannexupload");
		}
		if(_type == "") return;
		var that = this;
		showLoading();
		//ajax成功之后
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			type : "post",
			data : {optype : _type,type : "clearAllfileLog",uid : userInfos.guid,isSystemDoc : (window.VIEW_MODEL == "disk" ? 0 : 1)},
			dataType : "json",
			success : function(data){
				hideLoading();
				if(data && data.flag == "1"){
					$removeObj.remove(); 
					jQuery(that).closest("li").children(".empty_data").show();
					if(_liId  == "sendCompleteContent"){
						var _totalnum = jQuery("#fullContent .fsUploadProgressannexupload").length;
						var _uploadnum = jQuery("#fullContent .uploadComplete").length;
						var _downloadnum = jQuery("#fullContent .downloadComplete").length;
						jQuery("#sendComplete").find(".num").html(_totalnum);
						jQuery("#allProcee").find(".processNum").html(_totalnum);
						jQuery("#uploadComplete").find(".processNum").html(_uploadnum);
						jQuery("#downloadComplete").find(".processNum").html(_downloadnum);
						jQuery("#fullTab .clearRecord").hide();
						if(_totalnum == 0){
							jQuery("#allProcee .processSpan").hide();
							jQuery("#sendComplete .numSpan").hide();
						}
						if(_uploadnum == 0) 
							jQuery("#uploadComplete .processSpan").hide();
						if(_downloadnum == 0) 
							jQuery("#downloadComplete .processSpan").hide();
					}else if(_liId == "syncCompleteContent"){
						jQuery("#syncComplete .numSpan").hide().find(".num").html(0);
						jQuery("#syncCompleteContent .fullProcess").hide();
						jQuery("#syncCompleteContent .syncCompleteMsg .processNum").html(0);
					}
				}else{
					window.top.Dialog.alert(warmFont.operateFail);
				}
			},
			error : function(){
				hideLoading();
				window.top.Dialog.alert(warmFont.netAnomaly);
			}
		});
	});
	
	
});

function randerNav(categoryid){
	/***var sid = categoryid;
	while(sid != "" && sid != "0" && privateIdMap[sid]){
		$divNav = $("<div />");
              $divNav.attr('id', sid + "divNav");
              $divNav.addClass("e8ParentNavContent");
              $a = $("<a />");
              $a.addClass("nava");
              $a.attr({
               	'id' : privateIdMap[sid].sid,
               	'title' : privateIdMap[sid].sname
              	});
              $a.append(privateIdMap[sid].sname);
              $divNav.append($a);
              $divParentNavLine = $("<div />");
              $divParentNavLine.attr('id', privateIdMap[sid].sid + "divNavLine");
              $divParentNavLine.addClass("e8ParentNavLine");
              sid = privateIdMap[sid].pid;
              $("#privateAlldivNav").after($divNav).after($divParentNavLine); 
	}
	***/
	$("#privateId").val(categoryid);
	if(window.VIEW_MODEL == "disk"){
		fullPrivateDivNav("privateAll");
	}else{
		fullDivNav();
	}
}

//获取所有父层目录
function getParentCategorys(categoryid,fn){
	jQuery.ajax({
		url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
		type : "post",
		data : {categoryid : categoryid,type : (window.VIEW_MODEL == "disk" ? "parents" : "publicParents")},
		dataType : "json",
		success : function(data){
			if(data && data.flag == "1"){
				if(data.dataList.length == 0){
					fn(0,-1)
				}if(window.VIEW_MODEL == "disk" && data.dataList.length == 1){
					fn(1,0);
				}else{
					for(var i = 0 ;i < data.dataList.length;i++){
						var dataMap = data.dataList[i];
						if(window.VIEW_MODEL == "disk"){
							privateIdMap[dataMap.id] = {
								sid : dataMap.id,
								sname : dataMap.name,
								pid : dataMap.pid
							}
						}else{
							publicIdMap[dataMap.sid] = {
								sid : dataMap.sid,
								sname : dataMap.sname,
								pid : dataMap.pid,
								canCreateDoc : dataMap.canCreateDoc ? dataMap.canCreateDoc : "false"
							}
						}
					}
					
					fn(data.dataList.length,categoryid);
				}
			}
		}
	});
}

//总进度
function fillFullProcess(precent,type){
	if(type != "upload" && type != "download"){
		return;
	}
	jQuery("#" + type + "ingContent .fullProcessBarDiv .fullProcessBar").css("width",precent + "%");
	jQuery("#" + type + "ingContent .fullProcessBarDiv .fullPrecent").html(precent + "%");
	if(precent == 100){
		jQuery("#" + type + "ingContent .fullProcess").slideUp();
	}else{
		jQuery("#" + type + "ingContent .fullProcess").show();
	}
	jQuery("#" + type + "_current .precent_current").html(precent + "%"); //最小化视图下的进程显示 
}

//填充上传、下载文件进程到上传、下载窗口
function fillFileProcess(data,type,showViewList){
	type = type ? type : "upload";
	if(type != "upload" && type != "download"){
		return;
	}
	
	if(showViewList != "no"){
	 	var currentView = jQuery("#uploadTab .select").attr("id");
	 	if(currentView == "sendComplete"){
	 		if(type == "upload"){
	 			jQuery("#uploading").click();
	 		}else if(type == "download"){
	 			jQuery("#downloading").click();
	 		}
	 	}
		showUploadView();
	}
	
	var _msg = "";
	var btnClass = "stopFile";
	var _size = 0;
	if(type == "download"){
		_msg = warmFont.downloading;
		if(data.status == "stop"){
			_msg = warmFont.paused;
			btnClass = "startFile";
			_size = data.downloadSize ? data.downloadSize : _size;
		}
	}else if(type == "upload"){
		if(isExistUpload(data.uid,1)){
			_msg = warmFont.waitingUpload;
			if(jQuery("#uploadingContent .progressWrapper[dataid='" + data.uid + "']").find(".stopFile").length > 0){
				btnClass = "cantDo";
			}else{
				btnClass = "startFile";
			}
		}else{
			_msg = warmFont.uploading;
			if(data.status == "stop"){
				_msg = warmFont.paused;
				btnClass = "startFile";
				_size = data.uploadSize ? data.uploadSize : _size;
			}
		}
	}
	
	if(showViewList != "no" && btnClass == "stopFile"){
		if(type == "upload"){
			jQuery("#uploadingContent .stopAll").html(warmFont.allStop);
		}else{
			jQuery("#downloadingContent .stopAll").html(warmFont.allStop);
		}
	}
	
	jQuery("#" + type + "ingContent .contentProcess + .empty_data").hide();
	var $div = 
		'<div style="width: 100%;" class="fsUploadProgressannexupload waitingProcess">' +
		'	<div class="progressWrapper" id="SWFUpload_' + data.id + '" dataid="' + data.uid + '">' +
		'		<div class="rprogressContainer rgreen" style="background: none 0px 0px repeat scroll rgb(255, 255, 255);">' +
		'		<div class="fileIconDiv">' +
		'			<img class="SWFUpload_Icon" onerror="this.src=\'/rdeploy/assets/img/cproj/doc/fileicon/small/general_icon.png\'"' +
		'				src="/rdeploy/assets/img/cproj/doc/fileicon/small/' + getMarkByExtName(data.fileType) + '" />' +
		'		</div>' +
		'		<div class="rprogressName" title="' + data.fileName + '">' + data.fileName +  '</div>' +
		'		<div class="rprogressError"></div>' +
		'		<div class="fileSize">' +bytesToSize(data.fileSize) + '</div>' +
		'		<div class="rprogressBarStatus" style="color: #3597F1">' + _msg + '</div>' +
		'		<div style="float: left; padding-top: 15px;" class="statusIcon">' +
		'			<div title="' + (btnClass == "startFile" ? "继续" : "暂停") + '" class="' + btnClass + '"><span class="operateBgImage"></span></div>' +
		'			<div title="取消" class="cancelFile"><span class="operateBgImage"></span></div>' +
		'		</div>' +
		'		<div class="rprogressBarInProgressLine"></div>' +
		'		<div class="rprogressBarInProgress" style="width: 100%; display: none;"></div>' +
		'		<div class="clearBoth"></div>' +
		'		<input class="SWFUpload_fileid" type="hidden" value="' + (data.imagefileid ? data.imagefileid : "") + '">' +
		'		<input class="SWFUpload_uploadtype" type="hidden" value="' + data.uploadtype + '">' +
		'		<input class="SWFUpload_type" type="hidden" value="' + type + '">' +
		'		<input class="SWFUpload_path" type="hidden" value="' + (data.filePath ? data.filePath : "") + '">' +
		'		<input class="SWFUpload_size" type="hidden" value="' + _size + '">' +
		'		<input class="SWFUpload_totalSize" type="hidden" value="' + (data.fileSize ? data.fileSize : 0) + '">' +
		'		<input class="SWFUpload_categoryid" type="hidden" value="' + (data.categoryid ? data.categoryid : "") + '">' +
		'		<input class="SWFUpload_logid" type="hidden" value="' + (data.networklogid ? data.networklogid : "") + '">' +
		'	</div></div>' +
		'</div>';
	jQuery("#" + type + "ingContent .contentProcess").append($div);	
	//jQuery("#count").html(parseInt(jQuery("#count").html() == "" ? 0 : jQuery("#count").html()) + 1);
	var _num = jQuery("#" + type + "ingContent .contentProcess").children(".waitingProcess").length;
	jQuery("#" + type + "ing .num").html(_num).parent().show();
	jQuery("#" + type + "_current .num_current").html(_num);
}

//填充同步完成文件进程到同步完成窗口
function fillSyncFileProcess(data){
	jQuery("#syncCompleteContent .contentProcess + .empty_data").hide();
	var $div = 
		'<div style="width: 100%;" class="fsUploadProgressannexupload waitingProcess">' +
		'	<div class="progressWrapper" id="SWFUpload_' + data.id + '" dataid="' + data.imagefileid + '">' +
		'		<div class="rprogressContainer rgreen" style="background: none 0px 0px repeat scroll rgb(255, 255, 255);">' +
		'		<div class="fileIconDiv">' +
		'			<img class="SWFUpload_Icon" onerror="this.src=\'/rdeploy/assets/img/cproj/doc/fileicon/small/general_icon.png\'"' +
		'				src="/rdeploy/assets/img/cproj/doc/fileicon/small/' + getMarkByExtName(data.fileType) + '" />' +
		'		</div>' +
		'		<div class="rprogressName" title="' + data.fileName + '">' + data.fileName +  '</div>' +
		'		<div class="rprogressError"></div>' +
		'		<div class="fileSize">' +bytesToSize(data.fileSize) + '</div>' +
		'		<div class="rprogressBarStatus" style="color: #3597F1">' + warmFont.syncComplete + '</div>' +
		'		<div style="float: left; padding-top: 15px;" class="statusIcon">' +
		'			<div title="打开文件" class="openFile"><span class="operateBgImage"></span></div>' +
		'			<div title="打开所在目录" class="openFolder"><span class="operateBgImage"></span></div>' +
		'			<div title="清除记录" class="clearFile"><span class="operateBgImage"></span></div>' +
		'		</div>' +
		'		<div class="rprogressBarInProgressLine"></div>' +
		'		<div class="rprogressBarInProgress" style="width: 100%; display: none;"></div>' +
		'		<div class="clearBoth"></div>' +
		'		<input class="SWFUpload_fileid" type="hidden" value="' + (data.imagefileid ? data.imagefileid : "") + '">' +
		'		<input class="SWFUpload_categoryid" type="hidden" value="' + (data.categoryid ? data.categoryid : "") + '">' +
		'		<input class="SWFUpload_logid" type="hidden" value="' + (data.networklogid ? data.networklogid : "") + '">' +
		'	</div></div>' +
		'</div>';
		jQuery("#syncCompleteContent .contentProcess").prepend($div);	
		var _num = jQuery("#syncCompleteContent .contentProcess").children().length;
		jQuery("#syncComplete .num").html(_num).parent().show();
		jQuery("#syncCompleteContent .fullProcess").show().find(".processNum").html(_num);
		jQuery("#syncCompleteContent .clearRecord").show();
}

//已上传大小
function uploadedSize(uid,size){
	jQuery("#SWFUpload_" + uid + " .SWFUpload_size").val(parseInt(size) + 1);
}
//渲染上传、下载进度条
function fillProgressBar(uid,percent,review){
	var type = jQuery("#SWFUpload_" + uid).closest("li[id*='ingContent']").attr("id") == "uploadingContent" ? "upload" : "download";
	
	jQuery("#SWFUpload_" + uid + " .rprogressBarInProgress").css("width",percent + "%").show();
	if(percent == 100){
		var _msg = type == "upload" ? warmFont.uploadComplete : warmFont.downloadComplete;
		var _dataid = jQuery("#SWFUpload_" + uid).attr("dataid");
		if(type == "upload"){
			jQuery("#uploadingContent .progressWrapper[dataid='" + _dataid + "']").parent().removeClass("waitingProcess");
		}else{
			jQuery("#SWFUpload_" + uid).parent().removeClass("waitingProcess");
		}
		jQuery("#SWFUpload_" + uid + " .rprogressBarInProgress").hide();
		jQuery("#SWFUpload_" + uid + " .rprogressBarStatus").html(_msg).css("color","#3597F1");
		jQuery("#SWFUpload_" + uid + " .rprogressBarInProgressLine").css("background","#dadada").show();
		jQuery("#SWFUpload_" + uid + " .statusIcon").html("");
		//jQuery("#suCount").html(parseInt(jQuery("#suCount").html() == "" ? 0 : jQuery("#suCount").html()) + 1);
		var _num = jQuery("#" + type + "ingContent .contentProcess").children(".waitingProcess").length;
		if(_num <= 0){
			jQuery("#" + type + "ing .num").html("").parent().hide();
			fillFullProcess(100,type);
			jQuery("#" + type + "_current .num_current").html(0);
			jQuery("#" + type + "ingContent .contentProcess + .empty_data").show();
		}else{
			jQuery("#" + type + "ing .num").html(_num).parent().show();
			jQuery("#" + type + "_current .num_current").html(_num);
		}
		
		
		fillCompleteProcess(uid,type,review);
		
		if(type == "upload"){
			
			jQuery("#uploadingContent .progressWrapper[dataid='" + _dataid + "']").each(function(){
				fillCompleteProcess(this.id.replace("SWFUpload_",""),type,review);
			});
		}
	}
}

function reviewFn(logid){
	var fullName = jQuery("#SWFUpload_" + logid + "_complate .rprogressName").html();
	var fileName = fullName.indexOf(".") > -1 ? fullName.substring(0,fullName.lastIndexOf(".")) : "";
	var docExtendName = fullName.indexOf(".") > -1 ? fullName.substring(fullName.lastIndexOf(".") + 1) : "";
	
	var imagefileid = jQuery("#SWFUpload_" + logid + "_complate .SWFUpload_fileid").val();
	
	getDocIdByImageFileid(imagefileid,function(id){
		document.getElementById("contentFrame").contentWindow.addView({
			folderArray : [],
			fileArray : [{
				imagefileId : id,
				docid : id,
				doctitle :  fileName,
				docExtendName : window.VIEW_MODEL == "systemDoc" ? "html.png" : getMarkByExtName(docExtendName),
				fullName : window.VIEW_MODEL == "disk" ? fullName : fileName,
			}]
		});
	});
}

function getDocIdByImageFileid(imagefileid,fn){
	if(window.VIEW_MODEL == "systemDoc"){
		showLoading();
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			type : "post",
			data : {imagefileid : imagefileid,type : "getDocIdByFileid"},
			dataType : "json",
			success : function(data){
				if(data && data.flag == "1"){
					fn(data.docid);
				}
			},
			complete : function(){
				hideLoading();
			}
		})
	}else{
		fn(imagefileid);
	}
}

function getMarkByExtName(extName){
	if(extName == "doc" || extName == "docx"){
		return "doc.png";
	}else if(extName == "xlsx" || extName == "xls"){
		return "xls.png";
	}else if(extName == "pptx" || extName == "ppt"){
		return "ppt.png";
	}else if(extName == "rar" || extName == "zip"){
		return "zip.png";
	}else if(extName == "txt"){
		return "txt.png";
	}else if(extName == "pdf"){
		return "pdf.png";
	}else if(extName == "htm" || extName == "htmlx" || extName == "html"){
		return "html.png";
	}else if(extName == "png" || extName == "bpm" || extName == "gif" || extName == "jpg" || extName == "jpeg"){
		return "jpg.png";
	}
	return "general_icon.png";
}


//上传、下载失败
function uploadError(uid,msg){
	var type = jQuery("#SWFUpload_" + uid).closest("li[id*='ingContent']").attr("id") == "uploadingContent" ? "upload" : "download";
	
	var _msg = type == "upload" ? warmFont.uploadFail : warmFont.downloadFail;
	_msg = msg ? msg : _msg;
	jQuery("#SWFUpload_" + uid + " .rprogressBarStatus").html(_msg).css("color","red");
	jQuery("#SWFUpload_" + uid + " .rprogressBarInProgressLine").css("background","red").show();
	jQuery("#SWFUpload_" + uid + " .rprogressBarInProgress").hide();
	if(msg == '不能为空' || msg == "不能超过2G")
	{	
		jQuery("#SWFUpload_" + uid + " .statusIcon .stopFile").remove();
	}
	else
	{
	jQuery("#SWFUpload_" + uid + " .statusIcon .stopFile").removeClass("stopFile").addClass("startFile").attr("title","继续");
	}
}



//删除上传、下载进程
function deleteUploadProgess(uid){
	var type = jQuery("#SWFUpload_" + uid).closest("li[id*='ingContent']").attr("id") == "uploadingContent" ? "upload" : "download";
	
	jQuery("#SWFUpload_" + uid).parent().remove();
	//jQuery("#count").html(parseInt(jQuery("#count").html() == "" ? 0 : jQuery("#count").html()) - 1);
	var _num = jQuery("#" + type + "ingContent .contentProcess").children(".waitingProcess").length;
	if(_num <= 0){
		jQuery("#" + type + "ing .num").html("").parent().hide();
		jQuery("#" + type + "_current .num_current").html(0);
		jQuery("#" + type + "ingContent .contentProcess + .empty_data").show();
		jQuery("#" + type + "ingContent .fullProcess").hide().find(".fullProcessBar").width("0%").siblings(".fullPrecent").html("0%");
		jQuery("#" + type + "_current").hide().find(".precent_current").html("100%");
	}else{
		jQuery("#" + type + "ing .num").html(_num).parent().show();
		jQuery("#" + type + "_current .num_current").html(_num);
	}
}

//暂停上传、下载
function _stopUpload(uid){
	if(!uid ||jQuery("#SWFUpload_" + uid).length == 0)
		return;
	jQuery("#SWFUpload_" + uid + " .rprogressBarStatus").html(warmFont.paused);
}

//继续上传、下载
function _startUpload(uid){
	if(!uid ||jQuery("#SWFUpload_" + uid).length == 0)
		return;
	var type = jQuery("#SWFUpload_" + uid).closest("li[id*='ingContent']").attr("id") == "uploadingContent" ? "upload" : "download";
		
	var _msg = type == "upload" ? warmFont.uploading :warmFont.downloading;	
	jQuery("#SWFUpload_" + uid + " .rprogressBarStatus").html(_msg).css("color","#3597F1");
	jQuery("#SWFUpload_" + uid + " .rprogressBarInProgressLine").css("background","#dadada").show();
}


//已存在
function hasExist(uid){
	jQuery("#SWFUpload_" + uid + " .rprogressBarStatus").html(warmFont.exist).css("color","red");
	jQuery("#SWFUpload_" + uid + " .rprogressBarInProgressLine").css("background","red").show();
	jQuery("#SWFUpload_" + uid + " .rprogressBarInProgress").hide();
	jQuery("#SWFUpload_" + uid + " .statusIcon").html("");
	if(jQuery("#uploadingContent .stopFile").length == 0){
		jQuery("#uploadingContent .stopAll").html(warmFont.allContinue);
	}
}

//填充完成进程到上传、下载窗口
function fillCompleteProcess(uid,processType,review){
	
	processType = processType ? processType : "upload";
	if(processType != "upload" && processType != "download"){
		return;
	}
	var _msg = processType == "upload" ? warmFont.uploadComplete : warmFont.downloadComplete;
	
	var currentView = jQuery("#fullTab .select");
	var _id = currentView.attr("id");
	var showFlag = false;
	if(_id == "allProcee")
		showFlag = true;
	else if(_id == "uploadComplete" && processType == "upload")
		showFlag = true;
	else if(_id == "downloadComplete" && processType != "upload")
		showFlag = true;	
	if(showFlag){
		jQuery("#fullContent + .empty_data").hide();
		jQuery("#sendCompleteContent .clearRecord").show();
	}	
	
	var _logid = jQuery("#SWFUpload_" + uid).find(".SWFUpload_logid").val();

	var uploadtype = jQuery("#SWFUpload_" + uid).find(".SWFUpload_uploadtype").val();
	if(uploadtype == 'sync'){
		_msg = warmFont.syncComplete;
	}
	var $div = jQuery("#SWFUpload_" + uid).clone().attr("id","SWFUpload_" + _logid + "_complate");
	$div.find(".rprogressBarStatus").html('<div class="' + processType + 'Complete\"><span class=\"operateBgImage\"></span>' + _msg + '</div>');
	
	var $icons = jQuery("<div title='打开文件' class='openFile " + processType + "Icon'><span class=\"operateBgImage\"></span></div>" +
						"<div title='打开所在目录' class='openFolder " + processType + "Icon'><span class=\"operateBgImage\"></span></div>" +
						"<div title='清除记录' class='clearFile " + processType + "Icon'><span class=\"operateBgImage\"></span></div>");
	
	$div.find(".statusIcon").html("").append($icons);  //图标
	
	var $divP = jQuery('<div style="width: 100%;' + (showFlag ? "" : "display:none") + '" class="fsUploadProgressannexupload"></div>');
	
	
	if(uploadtype == 'sync')
	{
		jQuery("#syncCompleteContent").find(".empty_data").hide();
		//jQuery("#syncCompleteContent").append($divP.append($div));
		$div.find(".uploadComplete").css("color","#3597F1").find(".operateBgImage").remove();
		
		jQuery("#syncCompleteContent .contentProcess").prepend($divP.append($div));	
		
		var _num = jQuery("#syncCompleteContent .contentProcess").children().length;
		jQuery("#syncComplete .num").html(_num).parent().show();
		jQuery("#syncCompleteContent .fullProcess").show().find(".processNum").html(_num);
		jQuery("#syncCompleteContent .clearRecord").show();
	}
	else{
		jQuery("#fullContent").prepend($divP.append($div));
		var totalNum = jQuery("#fullContent").children().length;
		jQuery("#allProcee .processSpan").show().children(".processNum").html(totalNum);
		jQuery("#sendComplete .numSpan").show().children(".num").html(totalNum);
		jQuery("#" + processType + "Complete .processSpan").show().children(".processNum").html(jQuery("#fullContent").find("." + processType + "Complete").length);
	}
	var currentCid = getCurrentCateId();
	currentCid = currentCid == "" ? "0" : currentCid;
	var cid = jQuery("#SWFUpload_" + uid + " .SWFUpload_categoryid").val();
	cid = cid == "" ? "0" : cid;
	if(processType == 'upload' && review != "no" && currentCid == cid){
		reviewFn(_logid);
	}
	
	jQuery("#SWFUpload_" + uid).parent().remove();
	
	if(review != "no"){
		var currentTab = jQuery("#uploadTab .select").attr("id");
		if(processType == "upload" && currentTab == "uploading"){
			if(jQuery("#uploadingContent .empty_data").is(":visible")){
				if(uploadtype == 'sync'){
					jQuery("#syncComplete").click();
				}else{
					jQuery("#sendComplete").click();
				}
			}
			jQuery("#upload_over .num_current").html(parseInt(jQuery("#upload_over .num_current").html()) + 1);
		}else if(processType == "download" && currentTab == "downloading"){
			if(jQuery("#downloadingContent .empty_data").is(":visible")){
				jQuery("#sendComplete").click();
			}
			jQuery("#download_over .num_current").html(parseInt(jQuery("#upload_over .num_current").html()) + 1);
		}
		
		if(jQuery("#uploadingContent .stopFile").length == 0){
			jQuery("#uploadingContent .stopAll").html(warmFont.allContinue);
		}
	}
}

//是否存在正在上传的该文件
function isExistUpload(uid,len){
	return jQuery("#uploadingContent .progressWrapper[dataid='" + uid + "']").length - len >= 0 ? true : false;
}

//获取上传文件
function getUploadFiles(uid){
	var dataMap = {};
	jQuery("#uploadingContent .progressWrapper[dataid='" + uid + "']").each(function(){
		var _id = this.id;
		if(_id){
			_id = _id.replace("SWFUpload_","");
			dataMap["'" + _id + "'"] = jQuery(this).find(".SWFUpload_categoryid").val();
		}
	})
	return dataMap;
}

function getFilepr(totalSize,size)
{
	var filepr =  Math.round(size / (totalSize) * 10000) / 100.00;
	if(filepr > 99)
	{
		filepr = 99;
	}
	return filepr;
}


function bytesToSize(bytes) {
	if(!/^\d+$/.test(bytes))
		return bytes;
    if (bytes === 0) return '0 B';  
       var k = 1024;
       sizes = ['B','KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];  
      var i = Math.floor(Math.log(bytes) / Math.log(k));  
    var sizeNum = (bytes / Math.pow(k, i));   
    return (sizeNum.toPrecision(3).toString().indexOf("+") > -1 ? sizeNum : sizeNum.toPrecision(3)) + sizes[i];
}  


var NET_CONNECT = true;
function cycleRun(){
	var uploadList = jQuery("#uploadingContent .stopFile").length;
	var downloadList = jQuery("#downloadingContent .stopFile").length;
	
	if(uploadList == 0 && downloadList == 0){
		return;
	}
	
	jQuery.ajax({
		url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
		type : "get",
		success : function(){
			if(!NET_CONNECT){
				console.info("^^^^^^^^^^^^重新连接成功^^^^^^^^^^^^");
				NET_CONNECT = true;
				//重新上传
				jQuery("#uploadingContent .stopFile").each(function(){
					var _diskPath = jQuery(this).closest(".progressWrapper").find(".SWFUpload_path").val();
					var _totalSize = jQuery(this).closest(".progressWrapper").find(".SWFUpload_totalSize").val();
					var _uid = jQuery(this).closest(".progressWrapper").attr("dataid");
					var _id = jQuery(this).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
					var _size = jQuery(this).closest(".progressWrapper").find(".SWFUpload_size").val();
					console.info("^^^^^^^^^^^^重新上传^^^^^^^^^^^^");
					console.info("_diskPath=" + _diskPath);
					console.info("_totalSize=" + _totalSize);
					console.info("_uid=" + _uid);
					console.info("_id=" + _id);
					console.info("_size=" + _size);
					resumeUpload(_diskPath,_totalSize,_size,_uid,_id);  
					
				});
				
				//重新下载
				jQuery("#downloadingContent .stopFile").each(function(){
					var _diskPath = jQuery(this).closest(".progressWrapper").find(".SWFUpload_path").val();
					var _totalSize = jQuery(this).closest(".progressWrapper").find(".SWFUpload_totalSize").val();
					var _uid = jQuery(this).closest(".progressWrapper").attr("dataid");
					var _id = jQuery(this).closest(".progressWrapper").attr("id").replace("SWFUpload_","");
					var _name =  jQuery(this).closest(".progressWrapper").find(".rprogressName").attr("title"); 
					var item = {id:_id,uid:_uid,filename:_name,filesize:_totalSize};
					console.info("^^^^^^^^^^^^重新下载^^^^^^^^^^^^");
					console.info("item=" + item);
					resumeDownload(item,_diskPath);
				})
			}
		},
		error : function(){
			if(NET_CONNECT){
				console.info("^^^^^^^^^^^^网络断开连接^^^^^^^^^^^^");
				NET_CONNECT = false;
			}
		}
	})
	
}

if(!window.__isBrowser){
	setInterval(function(){
		cycleRun();
    },5000);
}
