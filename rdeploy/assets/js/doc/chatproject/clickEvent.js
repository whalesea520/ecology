this.ORDER_BY = "time"; //排序方式 name-名称，time-时间
this.SHOW_MODE = "view" ; //查看 view-图标视图，list-列表视图
this.VIEW_MODEL = viewType == "" ? "disk" : viewType; // disk-我的云盘，systemDoc-系统文档
this.IS_SEARCH = false; //是否是查询
this.SEARCH_PARAMS = {}; //查询对象集
window.__isBrowser = window.Electron ? false : true;
window.__uploadSize = 1024; //单位M

var paddingTop = window.__isBrowser ? 130 : 175;

var node_path = !window.__isBrowser ? window.Electron.require('path') : "";
var fs = !window.__isBrowser ? window.Electron.require('fs') : "";
var os = !window.__isBrowser ? window.Electron.require(node_path.join(__dirname, './../../app/web_contents/network_disk/osinfo.js')) : "";
// var uploadfiles_button = window.Electron.require(node_path.join(__dirname, './../../app/web_contents/network_disk/uploadfiles_button.js'));
var http = !window.__isBrowser ? window.Electron.require('http') : "";
//var syncDdownloadFile = window.Electron.require(node_path.join(__dirname, './../../app/web_contents/network_disk/downloadfile.js'));
var urlparse = !window.__isBrowser ? window.Electron.require('url').parse : "";
var dirTravel = !window.__isBrowser ? window.Electron.require(node_path.join(__dirname, './../../app/web_contents/network_disk/dirTravel')) : "";
var USER_INFOS = !window.__isBrowser ? window.Electron.ipcRenderer.sendSync('global-getUserInfos') : "";
var USER_CONFIG = !window.__isBrowser ? window.Electron.ipcRenderer.sendSync('global-getUserConifg') : "";
var userInfos = {};
	userInfos['loginId'] = USER_INFOS.loginId;
	userInfos['userName'] = USER_INFOS.userName;
	userInfos['language'] = USER_INFOS.language;
	userInfos['currentHost'] = USER_INFOS.currentHost;
	userInfos['guid'] = USER_CONFIG.guid;

$(function(){

	 if(window.__isBrowser && window.VIEW_MODEL == "disk"){
	   
        jQuery("#uploadList").html(jQuery("#uploadList2").html());
    
        initFileupload('uploadButton',window.__uploadSize,1);
        var objectFlag = false;
        try{
            objectFlag = getBrowserInfo();
        }catch(e){}
        if(!objectFlag){
            initFileupload("uploadButtonLi",window.__uploadSize,2)
            initFileupload("uploadButtonAdd",window.__uploadSize,3)
        }
        
        
        jQuery("#swfuploadbtn").hover(
            function(){
                var _class = jQuery(this).parent().attr("class");
                _class = _class ? _class : "";
                if(_class.indexOf("operateDiv") > -1){
	                jQuery("#uploadFileDiv").addClass("btnHover");
                }else if(_class.indexOf("addFile") > -1){
                    jQuery(this).parent().addClass("hover");
                }
            },
            function(){
                var _class = jQuery(this).parent().attr("class");
                _class = _class ? _class : "";
                if(_class.indexOf("operateDiv") > -1){
                    jQuery("#uploadFileDiv").removeClass("btnHover");
                }else if(_class.indexOf("addFile") > -1){
                    jQuery(this).parent().removeClass("hover");
                }
            });
        jQuery("#uploadFileDiv,#uploadLi,#cancelAllDiv .addFile span").click(function(){
            jQuery("#uploadButton").click();
        });    
    }

	if(this.ORDER_BY == "name"){
		jQuery("#orderLi_N").children().first().html("√");
		jQuery("#orderLi_T").children().first().html("");
	}else{
		jQuery("#orderLi_N").children().first().html("");
		jQuery("#orderLi_T").children().first().html("√");
	}

	//云盘-分享tab切换
	jQuery(".netDiskMenu,.shareMenu").click(function(){
		jQuery(this).addClass("select").siblings(".select").removeClass("select");
		var _class = jQuery(this).attr("class");
		jQuery("#privateId").val("0");
		if(_class && _class.indexOf("netDiskMenu") > -1){
			jQuery("#requestviewselect").show();
			jQuery("#netDiskShare").hide();
		//	showmodel("privateAll",0);
			if(window.SHOW_MODE == "list"){
				showlist("privateAll");
				jQuery("#privateAlldivNav").children(".nava").html(warmFont.diskFont).parent().nextAll().remove();
			}else{
				showmark("privateAll")
			}
			if(window.__isBrowser){
			     jQuery("#operateDiv").removeClass("noupload");
			}
		}else if(_class && _class.indexOf("shareMenu") > -1){
			jQuery(".shareMenuLi li:first").addClass("select").siblings(".select").removeClass("select");
			jQuery("#requestviewselect").hide();
			jQuery("#netDiskShare,#cancelShareDiv").show();
			//showmodel("myShare",0);
			if(window.SHOW_MODE == "list"){
				showlist("myShare");
				jQuery("#privateAlldivNav").children(".nava").html(warmFont.myShare).parent().nextAll().remove();
			}else{
				showmark("myShare")
			}
			if(window.__isBrowser){
                jQuery("#operateDiv").addClass("noupload");
            }
		}
	});
	
	//我的分享-同事的分享tab切换
	jQuery(".netDiskShare .shareMenuLi li").click(function(){
		jQuery(this).addClass("select").siblings(".select").removeClass("select");
		var _index =  jQuery(this).index();
		jQuery("#privateId").val("0");
		if(_index == 0){
			jQuery("#cancelShareDiv").show();
			jQuery("#saveShareDiv").hide();
			//showmodel("myShare",0);
			if(window.SHOW_MODE == "list"){
				showlist("myShare");
				jQuery("#privateAlldivNav").children(".nava").html(warmFont.myShare).parent().nextAll().remove();
			}else{
				showmark("myShare");
			}
		}else if(_index == 1){
			jQuery("#cancelShareDiv").hide();
			jQuery("#saveShareDiv").show();
			//showmodel("shareMy",0);
			if(window.SHOW_MODE == "list"){
				showlist("shareMy");
				jQuery("#privateAlldivNav").children(".nava").html(warmFont.shareMy).parent().nextAll().remove();
			}else{
				showmark("shareMy");
			}
		}
	});
	
	//图表视图-表格视图切换
	jQuery("#listViewDiv,#imageViewDiv").click(function(){
		onViewTab(this.id);
	});
	
	jQuery("#navItem .nava").live({
		click : function(){
			
			if(this.id && (this.id == "searchaNav" || this.id == "subDivaNav")) return;
			showLoading();
			disabledOpt(false);
			document.getElementById("contentFrame").contentWindow.fullfinish = false;
			var loadFolderType = jQuery("#loadFolderType").val();
			if(this.id){
				if(loadFolderType == "publicAll"){
					document.getElementById("contentFrame").contentWindow.fullItemData(this.id,publicIdMap[this.id]);
				}else if(loadFolderType == "privateAll"){
					document.getElementById("contentFrame").contentWindow.fullPrivateItemData(this.id,privateIdMap[this.id]);
				}else if(loadFolderType == "shareMy"){
					document.getElementById("contentFrame").contentWindow.fullPrivateItemData(this.id,shareMyIdMap[this.id]);
				}else if(loadFolderType == "myShare"){
					document.getElementById("contentFrame").contentWindow.fullPrivateItemData(this.id,myShareIdMap[this.id]);
				}
			}else{
				if(loadFolderType == "publicAll"){
					document.getElementById("contentFrame").contentWindow.fullItemData(0);
				}else{
					document.getElementById("contentFrame").contentWindow.fullPrivateItemData(0);
				}
			}
		}
	});
	
	//查询
	jQuery(".searchspan").click(function(){
		var _txt = jQuery("#keyword").val();
		var _id = jQuery("#privateId").val();
		var loadFolderType = jQuery("#loadFolderType").val();
		var data = {
				txt : _txt
			};
		IS_SEARCH = true;	
		SEARCH_PARAMS = data;	
		if(loadFolderType == "publicAll"){
			jQuery("input[name=doctitle]").val(_txt);
			 doSearch();//document.getElementById("contentFrame").contentWindow.fullItemData(_id,publicIdMap[_id],data);
		}else if(loadFolderType == "privateAll"){
			document.getElementById("contentFrame").contentWindow.fullPrivateItemData(_id,privateIdMap[_id],data);
		}else if(loadFolderType == "shareMy"){
			document.getElementById("contentFrame").contentWindow.fullPrivateItemData(_id,shareMyIdMap[_id],data);
		}else if(loadFolderType == "myShare"){
			document.getElementById("contentFrame").contentWindow.fullPrivateItemData(_id,myShareIdMap[_id],data);
		}
		
	});
	jQuery("#keyword").keypress(function(e){
		e = e || event;
		if(e.keyCode == 13){
			jQuery(".searchspan").click();
		}
	})
	
	//上传
	jQuery("#uploadFileDiv").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onUpload();
	});
	
	//新建目录
	jQuery("#createrFolderDiv").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onCreate();
	});
	 //下载
	jQuery("#downloadDiv,#downloadShareDiv").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		
		onDownload();
	});
	//同步选中文档到本地
	jQuery("#syncDownloadDiv").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onSyncDownload();
	});
	//分享
	jQuery("#shareDiv").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onShare();
	});
	//发布到系统
	jQuery("#publicDiv").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onPublic();
	});
	//删除
	jQuery("#deleteDiv").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onDelete();
	});
	
	//新建文档
	jQuery("#createDoc").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onCreateDoc();	
	});
	
	//标记文档
	jQuery("#markDoc").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onMarkDoc();
	});
	
	//标记所有文档
	jQuery("#markAllDoc").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onMarkAllDoc();
	});

	//订阅无权查看的文档
	jQuery("#askNoPermission").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onSubDocscribe();
	});
	
	//附件批量下载
	jQuery("#downloadFileMul").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onDownloadBatch();
	});
	
	//保存到云盘
	jQuery("#saveShareDiv").click(function(){
		if(jQuery(this).hasClass("disabled"))
			return;
		onSave2Disk();	
	});
	//取消分享
	jQuery("#cancelShareDiv").click(function(){
	if(jQuery(this).hasClass("disabled"))
			return;
		onCancelShare();	
	});
	
	//查看系统文档、我的云盘切换
	jQuery("#systemDiv,#myDiskDiv").click(function(){
		showLoading();
		if(jQuery(this).hasClass("disabled"))
			return;
		var _href = location.href;
		_href = _href.indexOf("?") > -1 ? _href : (_href + "?timestamp=" + new Date().getTime());
		if(window.VIEW_MODEL == "disk"){
			window.VIEW_MODEL = "systemDoc";
			location.href = _href.indexOf("viewType=disk") > -1 ? _href.replace("viewType=disk","viewType=systemDoc") : (_href += "&viewType=systemDoc");
		}else{
			window.VIEW_MODEL = "disk";
			location.href = _href.indexOf("viewType=systemDoc") > -1 ? _href.replace("viewType=systemDoc","viewType=disk") : (_href += "&viewType=disk");
		}	
	});
	jQuery(".selectOption").click(function(){
		var _class = jQuery(this).attr("class");
		if(_class.indexOf("first") > -1){
			return;
		}else{
			var _href = location.href;
			_href = _href.indexOf("?") > -1 ? _href : (_href + "?timestamp=" + new Date().getTime());
			if(window.VIEW_MODEL == "disk"){
				window.VIEW_MODEL = "systemDoc";
				location.href = _href.indexOf("viewType=disk") > -1 ? _href.replace("viewType=disk","viewType=systemDoc") : (_href += "&viewType=systemDoc");
			}else{
				window.VIEW_MODEL = "disk";
				location.href = _href.indexOf("viewType=systemDoc") > -1 ? _href.replace("viewType=systemDoc","viewType=disk") : (_href += "&viewType=disk");
			}	
		}
	});
	
	//上传进程窗口tab切换
	jQuery("#uploadTab ul li").click(function(){
		jQuery(this).addClass("select").siblings(".select").removeClass("select");
		var _index = jQuery(this).index();
		jQuery("#uploadBody ul li:eq(" + _index + ")").show().siblings().hide();
	});
	
	//隐藏上传窗口
	jQuery("#uploadMImg").parent().click(function(){
		toggleUploadView();
	});
	
	//关闭上传窗口
	jQuery("#uploadCImg").click(function(){
		closeUploadView();
	});
	
	//取消上传
	jQuery(".SWFUpload_cancel").live({
		click : function(){
			cancelUpload(jQuery(this).closest(".progressWrapper").attr("dataid"));
		},
		mouseover : function(){
			jQuery(this).css("cursor","pointer");
		},
		mouseout : function(){
			jQuery(this).css("cursor","default");
		}
	});
    
    //全部取消(网页版)
    jQuery("#cancelAllDiv .cancelAllUpload span").click(function(){
        if(jQuery("#cancelAllDiv").attr("class").indexOf("nocalcelAllDiv") > -1)return;
        uploadfinish = true;
    $("#cancelAllDiv").removeClass("calcelAllDiv");
    $("#cancelAllDiv").addClass("nocalcelAllDiv");
        $("#fsUploadProgressannexupload > div").each(function(){
            var errorMes = $('#'+$(this).attr('id')+'progressError').text();
            // 上传失败，直接移除元素
            if (errorMes != null && errorMes != "")
            {
                $(this).fadeOut("slow",function(){
                   $(this).remove();
                   jQuery("#count").html(jQuery("#count").html() - 1);
                   if($("#fsUploadProgressannexupload").children().length <= 0)
                    {
                        $norecord = $("<div />");
                        $norecord.attr("id","norecord_uploadDiv");
                        $norecord.addClass("norecord_uploadDiv");
                        $recordpicture = $("<div />");
                        $recordpicture.addClass("recordpicture");
                        $recordmessage = $("<div />");
                        $recordmessage.addClass("recordmessage");
                        $recordmessage.append("暂无上传");
                        $norecord.append($recordpicture).append($recordmessage);
                        $("#fsUploadProgressannexupload").append($norecord); 
                    }
                 });
            }
            else
            {
                if($("#"+$(this).attr('id')+"rprogressBarStatus").text() != "上传成功")
                {
                    oUploadannexupload.cancelUpload($(this).attr('id'), false);
                    $(this).fadeOut("slow",function(){
                       $(this).remove();
                       jQuery("#count").html(jQuery("#count").html() - 1);
                       if($("#fsUploadProgressannexupload").children().length <= 0)
                        {
                            $norecord = $("<div />");
                            $norecord.attr("id","norecord_uploadDiv");
                            $norecord.addClass("norecord_uploadDiv");
                            $recordpicture = $("<div />");
                            $recordpicture.addClass("recordpicture");
                            $recordmessage = $("<div />");
                            $recordmessage.addClass("recordmessage");
                            $recordmessage.append("暂无上传");
                            $norecord.append($recordpicture).append($recordmessage);
                            $("#fsUploadProgressannexupload").append($norecord); 
                        }
                     });
                }   
            }
        });
    });
    
    
    //鼠标事件（右键菜单）
    jQuery(window).mousedown(function(e){
		e = e || event;
		//隐藏高级菜单
		if(!jQuery(e.target).hasClass("hiddensearch") && !jQuery(e.target).hasClass("adspan") && 
			jQuery(e.target).closest(".hiddensearch").length == 0 && 
			!jQuery(".daterangepicker").is(":visible") &&
			jQuery("div[id='e8_autocomplete_div']:visible").length == 0
			){
			jQuery(".hiddensearch").animate({
				height: 0
				}, 200,null,function() {
					jQuery(".hiddensearch").hide();
			});
		}
		if(e.button == "0"){
			if(jQuery(e.target).closest("#rightClickMenu").length > 0){
				return;
			}
			hideRightClickMenu();
		}else if(e.button == "2"){
			if(jQuery(e.target).closest("#uploadList").length > 0){
				return;
			}
			showRightClickMenuByHand(e.clientX,e.clientY);
			e.preventDefault();
		}
	});
	//屏蔽浏览器默认右键菜单
	jQuery(document).unbind("contextmenu").bind("contextmenu", function (e) {
        return false;
    });
    
    jQuery("#contentFrame").parent().height(jQuery(window).height() - paddingTop);
   // if(navigator.userAgent.indexOf("MSIE") >= 0){
		jQuery(".opBtn,.imageViewOpBtn,.listViewOpBtn,.syncSetting").hover(function(){
			jQuery(this).addClass("btnHover");
		},function(){
			jQuery(this).removeClass("btnHover");
		});
	//}
	jQuery(window).resize(function(){
		jQuery("#contentFrame").parent().height(jQuery(window).height() - paddingTop);
	})
});

function showLoading(){
	var _top = jQuery("#contentFrame").position().top;
	var _hi = jQuery("#contentFrame").height();
	_top = _top ? _top : 0;
	_hi = _hi ? _hi : 0;
	jQuery("#dataloading").css("top",(parseInt(_top) + _hi*0.2) + "px");
	jQuery("#dataloading,#dataloadingbg").show();
}

function hideLoading(){
	jQuery("#dataloading,#dataloadingbg").hide();
}

//系统设置
var settingDialog = null;
 function syncSetting(){
	 	settingDialog = new window.top.Dialog();
		settingDialog.currentWindow = window;
		var url = "/rdeploy/setting/syncSetting.jsp?guid=" + USER_CONFIG.guid + "&hostname=" + os.getHostname();
		settingDialog.Title = "";
		settingDialog.Width = 900;
		settingDialog.Height = 400;
		settingDialog.Drag = true;
		settingDialog.URL = url;
		settingDialog.show();
}

function getCurrentCateId(){
	return jQuery("#privateId").val();
}

//获取所有选中的文件夹、文件id
function getSelectIds(){
	return document.getElementById("contentFrame").contentWindow.getselectIds();
}

//获取所有选中的文件夹、文件
function getselectItems(){
	return document.getElementById("contentFrame").contentWindow.getselectItems();
}

//获取子层列表模式
function getChildModel(){
	return document.getElementById("contentFrame").contentWindow.PageModel;
}

//获取所有复制的文件夹、文件id
function getCopyIds(){
	return CopyObject;
}

//操作按钮是否可操作
function disabledOpt(type){
	if(type){
		jQuery(".operateDiv .opBtn.selectBtn").removeClass("disabled");
		var dataMap = getSelectIds();
		if(window.VIEW_MODEL == "systemDoc"){
			if(!dataMap || dataMap.fileid == ""){ //选中的只有文件夹没有文件，标记文档按钮、批量下载按钮不可点击
				jQuery("#markDoc,#downloadFileMul").addClass("disabled");
			} 
			if(jQuery("#subDivNav").length > 0){ //订阅无权查看的文档，不可下载
				jQuery("#downloadFileMul,#markDoc,#markAllDoc,#createDoc").addClass("disabled");
			}
			
			if(!dataMap || dataMap.folderid != ""){ 
				jQuery("#downloadFileMul").addClass("disabled");
			}else if(dataMap && dataMap.fileid != ""){
				if(!document.getElementById("contentFrame").contentWindow.isAllDownload(dataMap.fileid)){
					jQuery("#downloadFileMul").addClass("disabled");
				}
			}
			
			//var currentId = getCurrentCateId()
			//if(currentId == "" || currentId == 0){ //根目录下，批量下载、订阅无权限、标记所有，即使选中文件也不可点击
			//	jQuery("#downloadFileMul,#askNoPermission,#markAllDoc").addClass("disabled");
			//}
		}else if(jQuery("#loadFolderType").val() == "myShare"){
			if(jQuery("#navItem .e8ParentNavContent").length > 1){ //我的分享，分享文件夹下的文件或者文件夹，不可取消分享
				jQuery("#cancelShareDiv").addClass("disabled");
			}
		}
		
		if(window.__isBrowser && window.VIEW_MODEL == "disk"){
		    if(!dataMap || dataMap.fileid == "" || dataMap.folderid != "" || dataMap.fileid.indexOf(",") > -1){ 
		        jQuery("#downloadDiv,#downloadShareDiv").addClass("disabled");
		    }
		}
		
		if(document.getElementById("contentFrame").contentWindow.document.getElementsByClassName("newFolderItem").length > 0){ //已存在新建目录，不可再新建
			jQuery("#createrFolderDiv").addClass("disabled");
		}else{
			jQuery("#createrFolderDiv").removeClass("disabled");
		}
	}else{
		jQuery(".operateDiv .opBtn.selectBtn").addClass("disabled");
	}
}


//判断当前显示窗口：net-云盘，shareMy-我的分享，shareOther-同事的分享
function getViewType(){
	var _class = jQuery(".netDiskMenu.select,.shareMenu.select").attr("class");
	if(_class && _class.indexOf("shareMenu") > -1){
		var _class2 = jQuery("#netDiskShare .select .shareSelectLine").attr("class");
		if(_class2 && _class2.indexOf("myShare") > -1){ //我的分享
			return "myShare";
		}else{ //同事的分享
			return "shareMy";
		}
	}else{
		return "net";
	}
}

//子层右键显示右键菜单
function showRightMenuByPosition(left,top){
	var _left = jQuery("#contentFrame").position().left;
	var _top = jQuery("#contentFrame").position().top;
	_left = parseInt(_left) + parseInt(left);
	_top = parseInt(_top) + parseInt(top);
	showRightClickMenuByHand(_left,_top);
}

var hasTimeOut = false;
//右键菜单显示
function showRightClickMenuByHand(left,top){
	var loadFolderType = jQuery("#loadFolderType").val();
	if(loadFolderType == "publicAll" && getCurrentCateId() == 0)  //系统文档根目录，屏蔽右键菜单
		return;
	hideRightClickMenu();
	changePageMenuDiaplay();
	jQuery("#rightClickMenu").css({
		left : left,
		top : top
	}).show();
	
	if(jQuery("#swfuploadbtnLi object").length == 0) return;  //谷歌高版本，不采用flash上传
	var _top = jQuery("#uploadLi").position().top;
	if(hasTimeOut){
	   setTimeout(function(){
	       jQuery("#swfuploadbtnLi").css({
		       left : parseInt(left) + 1,
		       top : parseInt(top) + parseInt(_top) - 1
		    });
	   },150);
	}else{
	   jQuery("#swfuploadbtnLi").css({
          left : parseInt(left) + 1,
          top : parseInt(top) + parseInt(_top) - 1
       });
	}
	

}

//隐藏右键菜单
function hideRightClickMenu(){
	jQuery("#rightClickMenu,#rightClickMenu ul").hide();
	if(jQuery("#swfuploadbtnLi").position().left > 0){ 
	   hasTimeOut = true;
	   setTimeout(function(){
        jQuery("#swfuploadbtnLi").css("left","-200px");
        hasTimeOut = false;
	   },150);
    }
}

//改变右键菜单中菜单项的显示隐藏
function changePageMenuDiaplay(){
	var selectMap = getSelectIds();
	var folderNum = selectMap.folderid == "" ? 0 : selectMap.folderid.split(",").length;
	var fileNum = selectMap.fileid == "" ? 0 : selectMap.fileid.split(",").length;
	var totalNum = parseInt(folderNum) + parseInt(fileNum);
	
	var loadFolderType = jQuery("#loadFolderType").val();
	
	jQuery("#rightClickMenu > li").hide();
	
	if(loadFolderType == "publicAll"){
		jQuery("#subDocscribeLi").show();
		if(jQuery("#subDivNav").length > 0){//订阅无权限查看列表
			if(fileNum > 0){
				jQuery("#askLi").show();
			}
		}else{
			jQuery("#importAllLi").show();		
			if(fileNum > 0){
				jQuery("#importSelectLi").show();
				if(folderNum == 0 && document.getElementById("contentFrame").contentWindow.isAllDownload(selectMap.fileid)){
					jQuery("#downloadBatchLi").show();
				}
			}
		}
	}else if(loadFolderType == "privateAll"){
		if(totalNum == 0){//未选中文件夹或者文件
			jQuery("#uploadLi,#createLi,#syncDownloadLi,#viewLi,#refreshLi,#orderLi").show();
			jQuery("#createLi + .lineLi").show();
		}else if(totalNum == 1){//选中一个文件夹或者一个文件
			jQuery("#openLi,#downloadLi,#shareLi,#publicLi,#moveLi,#copyLi,#renameLi,#deleteLi").show();
			jQuery("#publicLi + .lineLi,#pasteLi + .lineLi").show();
		}else {//选中多个文件夹（文件）
			jQuery("#downloadLi,#shareLi,#publicLi,#moveLi,#copyLi,#deleteLi").show();
			jQuery("#publicLi + .lineLi,#pasteLi + .lineLi").show();
		}
		
		var copyMap = getCopyIds();
		if(copyMap.folderid == "" &&  copyMap.fileid == ""){
		}else{
			if(copyMap.currentId == getCurrentCateId()){
				jQuery("#pasteLi").addClass("disabled"); 
			}else{
				jQuery("#pasteLi").removeClass("disabled"); 
			}
			jQuery("#pasteLi,#pasteLi + .lineLi").show(); 
		}
		
		if(document.getElementById("contentFrame").contentWindow.document.getElementsByClassName("newFolderItem").length > 0){ //已存在新建目录，不可再新建
			jQuery("#createLi").hide();
		}
	}else if(loadFolderType == "myShare" || loadFolderType == "shareMy"){
		if(totalNum == 0){//未选中文件夹或者文件
			jQuery("#viewLi,#refreshLi,#orderLi").show();
		}else if(totalNum == 1){//选中一个文件夹或者一个文件
			jQuery("#openLi,#downloadLi").show();
			if(loadFolderType == "myShare"){
				if(jQuery("#privateAlldivNav").nextAll().length == 0){
					jQuery("#cancelShareLi,#shareObjLi").show();
				}
			}else{
				jQuery("#save2DistLi").show();
			}
		}else {//选中多个文件夹（文件）
			jQuery("#downloadLi").show();
			if(loadFolderType == "myShare"){
				if(jQuery("#privateAlldivNav").nextAll().length == 0){
					jQuery("#cancelShareLi").show();
				}
			}else{
				jQuery("#save2DistLi").show();
			}
		}
		
	}
	
	if(window.__isBrowser && (fileNum == 0 || folderNum != 0 || fileNum > 1)){
        jQuery("#downloadLi").hide();
    }
	
	
}

//显示二级菜单
jQuery(function(){
	jQuery(".rightMenu2").closest("li").hover(function(){
		jQuery(this).find(".rightMenu2").show();	
	},function(){
		jQuery(this).find(".rightMenu2").hide();
	});
});


//存放复制的文件夹、文件id
var CopyObject = {
	folderid : "",
	fileid : "",
	currentId : "0"
};
 
//复制操作
function onCopy(){
	hideRightClickMenu();
	CopyObject = document.getElementById("contentFrame").contentWindow.saveIdByCopy();
	CopyObject.currentId = getCurrentCateId();
	copySuccess();
}
function copySuccess(){
	_prompt2Success("复制成功");
}

//轻提示（警告）
function _prompt2Warn(msg){
	jQuery("#toaskInfo").show().find(".msg").addClass("warn").html(msg);
	setTimeout(function(){
		jQuery("#toaskInfo").hide();
	},1000)
}
//轻提示（成功）
function _prompt2Success(msg){
	jQuery("#toaskInfo").show().find(".msg").removeClass("warn").html(msg);
	setTimeout(function(){
		jQuery("#toaskInfo").hide();
	},1000)
}

//打开操作
function onOpen(){
	hideRightClickMenu();
	document.getElementById("contentFrame").contentWindow.doOpen();
}

//刷新操作
function onRefresh(){
	hideRightClickMenu();
	jQuery("#navItem").children().last().find(".nava").click();
}

//重命名操作
function onRename(){
	hideRightClickMenu();
	document.getElementById("contentFrame").contentWindow.doRename();
}

//删除操作
function onDelete(dataMap){
	hideRightClickMenu();
	dataMap = dataMap ? dataMap : getSelectIds();
	if(dataMap.folderid == "" && dataMap.fileid == "")
		return;
	var folderids = dataMap.folderid;
	if(dataMap.folderid != "")
	{
		window.top.Dialog.confirm(warmFont.deleteConfirm,function(){
			jQuery.ajax({
				url : "/docs/networkdisk/checkFolderCanDelete.jsp",
				data : {
					'folderids' : folderids
				},
				type : "post",
				dataType : "json",
				success : function(data){
						var folderid = ',';
						var foldername = '';
						for(var index in data)
						{
							for(var key in data[index])
							{
								folderid += key + ",";
								foldername += data[index][key]+",";
							}
						}
						folderids = ("," + folderids+",").replace(folderid,',');
						if(folderids == ",")
						{
							folderids = "";
						}
						else
						{	
							folderids = folderids.substring(1,folderids.length-1);
						}
						dataMap.folderid = folderids;
					if(foldername.length > 0)
					{
						window.top.Dialog.alert(warmFont.category + " 【"+foldername.substring(0,foldername.length-1)+"】 " + warmFont.notEmpty2Delete  + "！",function(){
						if(dataMap.folderid == "" && dataMap.fileid == "")
						return;
						dataMap.type = "delete";
						jQuery.ajax({
						url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
						data : dataMap,
						type : "post",
						dataType : "json",
						success : function(data){
							if(data && data.flag == "1"){
									if(getChildModel() == "tableList"){
										document.getElementById("contentFrame").contentWindow.reload();
									}else{
										document.getElementById("contentFrame").contentWindow.removeView(dataMap);
									}
									disabledOpt();
								}else{
									window.top.Dialog.alert(warmFont.deleteFail + "!");
								}
							}
						});
						});
					}
					else
					{
						dataMap.type = "delete";
						showLoading();
						jQuery.ajax({
						url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
						data : dataMap,
						type : "post",
						dataType : "json",
						success : function(data){
							if(data && data.flag == "1"){
									if(getChildModel() == "tableList"){
										document.getElementById("contentFrame").contentWindow.reload();
									}else{
											document.getElementById("contentFrame").contentWindow.removeView(dataMap);
									}
									disabledOpt();
								}else{
									window.top.Dialog.alert(warmFont.deleteFail + "!");
								}
							},
							complete : function(){
								hideLoading();
							}
						});
					}
				}
			});
	});
		
	}
	else
	{
		window.top.Dialog.confirm(warmFont.deleteConfirm,function(){
		dataMap.type = "delete";
		showLoading();
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			data : dataMap,
			type : "post",
			dataType : "json",
			success : function(data){
				if(data && data.flag == "1"){
					if(getChildModel() == "tableList"){
						document.getElementById("contentFrame").contentWindow.reload();
					}else{
						document.getElementById("contentFrame").contentWindow.removeView(dataMap);
					}
					disabledOpt();
				}else{
					window.top.Dialog.alert(warmFont.deleteFail);
				}
			},
			complete : function(){
				hideLoading();
			}
		});
	});
	}
	
}

//移动到
var moveDialog = null;
function onMove(dataMap){
	hideRightClickMenu();
	dataMap = dataMap ? dataMap : getSelectIds();
	if(dataMap.folderid == "" && dataMap.fileid == "")
		return;
	
	moveDialog = new window.top.Dialog();
	moveDialog.currentWindow = window;
	var curentCateid = getCurrentCateId();
	var url = "/systeminfo/BrowserMain.jsp?mouldID=networkdisk&url=/rdeploy/setting/MultiCategorySingleBrowser.jsp&hasClear=0&hasCancel=1&hasWarm=1&type=1&categoryid=" + curentCateid + "&folderid=" + dataMap.folderid;
	moveDialog.Title = warmFont.choose;
	moveDialog.Width = 700;
	moveDialog.Height = 500;
	moveDialog.Drag = true;
	moveDialog.URL = url;
	moveDialog.callback = function(data){
		dataMap.type = "move";
		dataMap.categoryid = data.id;
		showLoading();
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			data : dataMap,
			type : "post",
			dataType : "json",
			success : function(data){
				if(data && data.flag == "1"){
					if(data.folders != "" || data.files != ""){
						if(getChildModel() == "tableList"){
							document.getElementById("contentFrame").contentWindow.reload();
						}else{
							dataMap.folderid = data.folders;
							dataMap.fileid = data.files;
							document.getElementById("contentFrame").contentWindow.removeView(dataMap);
						}
					}else{
						window.top.Dialog.alert("所选文件、文件夹重名，" + warmFont.moveFail);
					}
				}else{
					window.top.Dialog.alert(warmFont.moveFail);
				}
			},
			complete : function(){
				hideLoading();
			}
		});
	}
	moveDialog.show();
}

//保存到云盘
var privateDiaog = null;
function onSave2Disk(dataMap){
	hideRightClickMenu();
	var dataMap = dataMap ? dataMap : getSelectIds();
	if(dataMap.folderid == "" && dataMap.fileid == "" && dataMap.shareid == "")
		return;
		
	privateDiaog = new window.top.Dialog();
	privateDiaog.currentWindow = window;
	var url = "/systeminfo/BrowserMain.jsp?mouldID=networkdisk&url=/rdeploy/setting/MultiCategorySingleBrowser.jsp&hasClear=0&hasCancel=1&hasWarm=1&type=2";
	privateDiaog.Title = warmFont.choose;
	privateDiaog.Width = 700;
	privateDiaog.Height = 500;
	privateDiaog.Drag = true;
	privateDiaog.URL = url;
	privateDiaog.callback = function(data){
		if(data && data.id != ""){
			showLoading();
			dataMap.categoryid = data.id;
			dataMap.type = "save2Disk";
			jQuery.ajax({
				url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
				type : "post",
				data : dataMap,
				dataType : "json",
				success : function(data){
					hideLoading();
					if(data && data.flag == "1"){
						window.top.Dialog.alert(warmFont.saveSuccess);
					}else{
						window.top.Dialog.alert(warmFont.saveFail);
					}
				},
				error : function(){
					hideLoading();
				}
			});
		}
	}
	privateDiaog.show();
}

//查看分享对象
var ShareObjDialog = null;
function onShowShareObj(dataMap){
	hideRightClickMenu();
	var dataMap = dataMap ?  dataMap : getSelectIds();
	if(dataMap.folderid == "" && dataMap.fileid == "")
		return;
	ShareObjDialog = new window.top.Dialog();
	ShareObjDialog.currentWindow = window;
	var url = "/rdeploy/chatproject/doc/shareObj.jsp?folderid=" + dataMap.folderid + "&fileid=" + dataMap.fileid;
	ShareObjDialog.Title = "分享对象";
	ShareObjDialog.Width = 700;
	ShareObjDialog.Height = 500;
	ShareObjDialog.Drag = true;
	ShareObjDialog.sendCancel2Msg = function(mesList){
	    if(!window.__isBrowser){
		  sendCancel2Msg(mesList);
		}
	}
	ShareObjDialog.URL = url;	
	ShareObjDialog.show();
}

//取消分享
function onCancelShare(dataMap){
	hideRightClickMenu();
	var dataMap = dataMap ?  dataMap : getSelectIds();
	if(dataMap.folderid == "" && dataMap.fileid == "")
		return;
	
	window.top.Dialog.confirm("确定要取消吗?",function(){
		showLoading();
		dataMap.type = "cancelShare";
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			type : "post",
			data : dataMap,
			dataType : "json",
			success : function(data){
				hideLoading();
				if(data && data.flag == "1"){
					window.top.Dialog.alert(warmFont.cancelSuccess);
					if(getChildModel() == "tableList"){
						document.getElementById("contentFrame").contentWindow.reload();
					}else{
						document.getElementById("contentFrame").contentWindow.removeView(dataMap);
					}
					sendCancel2Msg(data.mesList);
				}else{
					window.top.Dialog.alert(warmFont.cancelFail);
				}
			},
			error : function(){
				hideLoading();
			}
		});
	});
	
}

//发布到系统
var publicDialog = null;
function onPublic(dataMap){
	hideRightClickMenu();
	
	dataMap = dataMap ? dataMap : getSelectIds();
	
	publicDialog = new window.top.Dialog();
	publicDialog.currentWindow = window;
	var url = "/systeminfo/BrowserMain.jsp?mouldID=networkdisk&url=/docs/category/MultiCategorySingleBrowser.jsp&hasClear=0&hasCancel=1&hasWarm=1&operationcode=0";
	publicDialog.Title = warmFont.choose;
	publicDialog.Width = 700;
	publicDialog.Height = 500;
	publicDialog.Drag = true;
	publicDialog.URL = url;
	publicDialog.callback = function(data){
		showLoading();
		dataMap.categoryid = data.id;
		dataMap.type = "public";
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			data : dataMap,
			type : "post",
			dataType : "json",
			success : function(data){
				if(data && data.flag == "1"){
					if(data.needShare){ //是否需要打开 设置共享
						hideLoading();
						docShare(data.dataList);
					}else{
						var ids = "";
						for(var i = 0 ;i < data.dataList.length;i++){
							if(data.dataList[i].status == "1" && data.dataList[i].docid != ""){
								ids += "," + data.dataList[i].docid;
							}
						}
						if(ids == ""){
							hideLoading();
							window.top.Dialog.alert(warmFont.publicFail);
							return;
						}
						ids = ids.substring(1);
						jQuery.ajax({
							url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
							data : {docids : ids,"type" : "share"},
							type : "post",
							dataType : "json",
							success : function(data){
								if(data && data.flag == "1"){
									window.top.Dialog.alert(warmFont.publicSuccess);
								}else{
									window.top.Dialog.alert(warmFont.publicFail);
								}
								hideLoading();
							}
						});
					}
				}
			},
			error : function(){
				hideLoading();
			}
		});
	}
	publicDialog.show();
}

//设置共享
var docShareDialog = null;
function docShare(dataList){
	if(!dataList || dataList.length == 0)
		return;
	var ids = "";
	for(var i = 0 ;i < dataList.length;i++){
		if(dataList[i].status == "1" && dataList[i].docid != ""){
			ids += "," + dataList[i].docid;
		}
	}	
	if(ids == "")
		return;
		
	ids = ids.substring(1);
	docShareDialog = new window.top.Dialog();
	docShareDialog.currentWindow = window;
	//var url = "/systeminfo/BrowserMain.jsp?url=/rdeploy/chatproject/doc/DocShareConfirm.jsp?docids=" + ids;
	var url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocShareConfirm.jsp?isdialog=1&datasourceid=" + ids + "&actionid=netdisk";
	docShareDialog.Title = warmFont.choose;
	docShareDialog.Width = 700;
	docShareDialog.Height = 500;
	docShareDialog.Drag = true;
	docShareDialog.URL = url;
	docShareDialog.callback = function(){
		window.top.Dialog.alert(warmFont.publicSuccess);
		docShareDialog.close();
	};
	docShareDialog.show();
}

//粘贴
function onPaste(dataMap){
	if(jQuery("#pasteLi.disabled").length > 0)
		return;
	hideRightClickMenu();
	dataMap = dataMap ? dataMap : CopyObject;
	
	var _folderArray = dataMap.folderArray;
	var _fileArray = dataMap.fileArray;
	var _folderids = '';
	var _fileids = '';
	if(_folderArray)
	{
		for(var i = 0 ;i < _folderArray.length ; i ++)
		{
			_folderids += "," + _folderArray[i].id;
		}
		_folderids = _folderids.substring(1);
	}
	
	if(_fileArray)
	{
		for(var i = 0 ;i < _fileArray.length ; i ++)
		{
			_fileids += "," + _fileArray[i].id;
		}
		_fileids = _fileids.substring(1);
	}
	
	var _dataMap = {};
	_dataMap['folderid'] = _folderids;
	_dataMap['fileid'] = _fileids;
	
	if(_dataMap.folderid == "" && _dataMap.fileid == "")
		return;
	_dataMap['type'] = "paste";
	_dataMap['categoryid'] = getCurrentCateId();
	
	
	showLoading();
	jQuery.ajax({
		url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
		data : _dataMap,
		type : "post",
		dataType : "json",
		success : function(data){
			hideLoading();
			if(data && data.flag == "1"){
				if(data.existList){
					var existNames = "";
					for(var i = 0 ;i < data.existList.length;i++){
						existNames += "、【" + data.existList[i].name + "】";
					}
					existNames = "该目录下已存在：" + existNames.substring(1);
					window.top.Dialog.alert(existNames);
				}
				if(getChildModel() == "tableList"){
					document.getElementById("contentFrame").contentWindow.reload();
				}else{
					pasteItem(dataMap,data.result,data.existList);
				}
			}else if(data && data.flag == "2"){
				window.top.Dialog.alert(warmFont.pasteSubCategory);
			}else{
				window.top.Dialog.alert(warmFont.pasteFail);
			}
		}
	});	
}

function pasteItem(dataMap,data,existList)
{
	var folderItem = [];
	var fileItem = [];
	
	var _folderArray = dataMap.folderArray;
	var _fileArray = dataMap.fileArray;
	
	if(_folderArray)
	{
		
		for(var i = 0 ;i < _folderArray.length ; i ++)
		{
			if(existList){
				var _exist = false;
				for(var j = 0;j < existList.length;j++){
					if(existList[j].type == "folder"){
						if(existList[j].id == _folderArray[i].id){
							_exist = true;
							break;
						}
					}
				}
				if(_exist) continue;
			}
			folderItem.push({
				sid : data.folder[_folderArray[i].id],
				sname : _folderArray[i].name
			});
		}
	}
	
	if(_fileArray)
	{
		for(var i = 0 ;i < _fileArray.length ; i ++)
		{
			if(existList){
				var _exist = false;
				for(var j = 0;j < existList.length;j++){
					if(existList[j].type == "file"){
						if(existList[j].id == _fileArray[i].id){
							_exist = true;
							break;
						}
					}
				}
				if(_exist) continue;
			}
			var _extname = _fileArray[i].name;
			_extname = _extname.indexOf(".") > -1 ? _extname.substring(_extname.lastIndexOf(".") + 1) : _extname;
			_extname = getMarkByExtName(_extname);
			fileItem.push({
				imagefileId :  data.fileid[_fileArray[i].id],
				docid : data.fileid[_fileArray[i].id],
				doctitle : _fileArray[i].name,
				docExtendName : _extname,
				fullName : _fileArray[i].name
			});
		}
	}
	document.getElementById("contentFrame").contentWindow.addView({
		folderArray : folderItem,
		fileArray : fileItem
	});
}

//查看->图标视图、列表视图
function onViewTab(viewId){
	var loadFolderType = jQuery("#loadFolderType").val();
	if(viewId == "imageViewDiv"){
		window.SHOW_MODE = "view";
		showmark(loadFolderType);
	}else{
		window.SHOW_MODE = "list";
		showlist(loadFolderType);
	}
}

function showlist(loadFolderType){
	showLoading();
	if(loadFolderType != jQuery("#loadFolderType").val()){
		jQuery("#loadFolderType").val(loadFolderType);
	}
	hideRightClickMenu();
	disabledOpt(false);
	jQuery("#listViewDiv").hide();
	jQuery("#imageViewDiv").show();
	jQuery("#viewLi_M").children().first().html("");
	jQuery("#viewLi_L").children().first().html("√");
	var cateid = getCurrentCateId();
	
	var para = "";
	if(cateid != 0){
		if(loadFolderType == "myShare"){
			para = "&sharetime=" + myShareIdMap[cateid].sharetime;
		}else if(loadFolderType == "shareMy"){
			para = "&sharetime=" + shareMyIdMap[cateid].sharetime + "&username=" + shareMyIdMap[cateid].username + "&shareid=" + shareMyIdMap[cateid].shareid;
		}
	}
	
	var params = getSearchParams(loadFolderType);
	params = (params.length > 0 ? "&bySearch=1&" : "") + params; 
	if(jQuery("#subDivNav").length > 0){ //订阅无权限查看的文档
		params += "&subDocscribe=1";
	}
	
	$("#contentFrame").attr("src", "/rdeploy/chatproject/doc/seccategoryTableList.jsp?categoryid=" + cateid + 
		"&orderby=" + (this.ORDER_BY ? this.ORDER_BY : "") + "&loadFolderType=" + loadFolderType + para + params);
}
function showmark(viewtype){
	showLoading();
	hideRightClickMenu();
	disabledOpt(false);
    jQuery("#imageViewDiv").hide();
	jQuery("#listViewDiv").show();
	jQuery("#viewLi_M").children().first().html("√");
	jQuery("#viewLi_L").children().first().html("");
    showmodel(viewtype,0);
}

function getSearchParams(loadFolderType){
	var params = "";
	if(IS_SEARCH){
		if(SEARCH_PARAMS){
			for(var key in SEARCH_PARAMS){
				params += "&" + key + "=" + SEARCH_PARAMS[key];
			}
			params = params.length > 0 ? params.substring(1) : "";
		}
	}
	return params;
}

//排序方式->文件名、修改时间
function onOrder(orderby){
	this.ORDER_BY = orderby;
	var loadFolderType = jQuery("#loadFolderType").val();
	if(orderby == "name"){
		jQuery("#orderLi_N").children().first().html("√");
		jQuery("#orderLi_T").children().first().html("");
	}else{
		jQuery("#orderLi_N").children().first().html("");
		jQuery("#orderLi_T").children().first().html("√");
	}
	if(getChildModel() == "tableList"){
		showlist(loadFolderType);	
	}else{
		showmark(loadFolderType);
	}
}
var shareDialog = null;
var _shareDataMap;
//分享
function onShare(dataMap){
	hideRightClickMenu();
	
	_shareDataMap = dataMap ? dataMap : getselectItems();
	
	shareDialog = new window.top.Dialog();
	shareDialog.currentWindow = window;
	var url = "/docs/networkdisk/SocialHrmBrowser.jsp";
	shareDialog.Title = warmFont.diskShare;
	shareDialog.Width = 400;
	shareDialog.Height = 510;
	shareDialog.Drag = true;
	shareDialog.URL = url;
	shareDialog.show();
}


function getPostUrl(url){
	return url;
}


function getSocialDialog(title,width,height,closeHandler){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.URL = "/docs/networkdisk/SocialHrmBrowser.jsp";
	diag.Width =width?width:680;	
	diag.Height =height?height:420;
	diag.ShowButtonRow=false;
	diag.Title = title;
	diag.closeHandle = function(){
		if(typeof closeHandler == 'function'){
			closeHandler(diag);
		}
		//pc端关闭时恢复拖动绑定
		if(typeof from != 'undefined' && from == 'pc'){
			DragUtils.restoreDrags();
		}
	}
	if(typeof from != 'undefined' && from == 'pc'){
		DragUtils.closeDrags();
	}
	return diag;
}


//新建目录
function onCreate(){
	disabledOpt(false);
	cancelSelect();
	hideRightClickMenu();
	if(getChildModel() == "tableList"){
		openCreateDialog();
	}else{
		createrFolder();
	}
}

//标记文档
function onMarkDoc(dataMap){
	dataMap = dataMap ? dataMap : getSelectIds();
	hideRightClickMenu();
	if(dataMap.fileid == "")
		return;
	dataMap.type = "doview";
	showLoading();
	jQuery.ajax({
		url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
		data : dataMap,
		type : "post",
		dataType : "json",
		success : function(data){
			hideLoading();
			try{
				document.getElementById("contentFrame").contentWindow.removeNoReadMark("select");
			}catch(e){}
		},
		error : function(){
			hideLoading();
		}
	});
}

//标记所有文档
function onMarkAllDoc(){
	var categoryid =getCurrentCateId();
	hideRightClickMenu();
	if(categoryid == "" || categoryid == 0)
		return;
	showLoading();
	
	jQuery.ajax({
		url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
		data : {categoryid : categoryid,type : "doview"},
		type : "post",
		dataType : "json",
		success : function(data){
			try{
				document.getElementById("contentFrame").contentWindow.removeNoReadMark("all");
			}catch(e){}
			hideLoading();
		},
		error : function(){
			hideLoading();
		}
	});
}

//订阅无权查看的文档
function onSubDocscribe(){
	var categoryid =getCurrentCateId();
	hideRightClickMenu();
	if(categoryid == "" || categoryid == 0)
		return;
	showLoading();
	
	document.getElementById("contentFrame").contentWindow.onSubscritbe();
	
	/**
	jQuery.ajax({
		url : "/rdeploy/chatproject/doc/getDocsBySecid.jsp",
		data : {categoryid : categoryid,pageSize:1,pageCount:10,type : "2"},
		type : "post",
		dataType : "json",
		success : function(data){
			hideLoading();
		},
		error : function(){
			hideLoading();
		}
	});***/
}
	
//附件批量下载
function onDownloadBatch(dataMap){
	dataMap = dataMap ? dataMap : getSelectIds();
	hideRightClickMenu();
	if(window.__isBrowser){
	   return;
	}
	onDownload();
	return;
	if(dataMap.fileid == "")
		return;
	showLoading();
	jQuery.ajax({
		url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
		data : {fileid : dataMap.fileid,type : "doDownloadBatch"},
		type : "post",
		dataType : "json",
		success : function(data){
			hideLoading();
			if(data.flag=="1"){
			window.location="/weaver/weaver.file.FileDownload?download=1&downloadBatch=1&fieldvalue="+dataMap.fileid;
			}else{
				window.top.Dialog.alert(warmFont.selectWithoutFile);
			}
		},
		error : function(){
			hideLoading();
		}
	});
}

//重命名
function reName(id,newname,type){
	hideRightClickMenu();
}


//列表模式下，新建目录
var createDialog = null;
function openCreateDialog(){
	
	publicDialog = new window.top.Dialog();
	publicDialog.currentWindow = window;
	var url = "/rdeploy/chatproject/doc/createCategory.jsp?pid=" + getCurrentCateId();
	publicDialog.Title = warmFont.createFolder;
	publicDialog.Width = 600;
	publicDialog.Height = 150;
	publicDialog.Drag = true;
	publicDialog.normalDialog = false;
	publicDialog.URL = url;
	publicDialog.callback = function(data){
	}
	publicDialog.OKEvent = function(){
		publicDialog.innerWin.doSave();
	};
	publicDialog.show();
	publicDialog.okButton.value=warmFont.save;
}

var allSize = 0;
//上传
function onUpload(){
	hideRightClickMenu();
	if(window.__isBrowser){
	   return;
	}
	var categoryid = getCurrentCateId();
	var e_dialog = window.Electron.remote.dialog;
	e_dialog.showOpenDialog(window.Electron.currentWindow, {properties : ['multiSelections']}, function(choosed){
	    if(choosed) {
			// 打开上传进度框
			openUploadView();
			for(var i = 0 ; i < choosed.length ; i ++)
			{
				// 文件路径
				var path = choosed[i];
				// 文件信息
				var fileStat = getFilefileStat(path);
				// 添加到临时表
				addchoosedFileToTemptable(categoryid,path,fileStat,1,'upload');	
			}
	    }
	});
}

/**
* 添加到临时表，为断点续传提供临时文件
*/
function addchoosedFileToTemptable(categoryid,path,fileStat,comefrom,uploadtype)
{
	var crypto = window.Electron.require('crypto');
	// 文件路径md5值
	var md5 = crypto.createHash('md5');
	var filemd5 = path+userInfos.guid+moment(fileStat.mtime).format('YYYY-MM-DD')+moment(fileStat.mtime).format('HH:mm:ss');
	md5.update(filemd5);
	var filemd5 = md5.digest('hex');
	filemd5 = filemd5;
	
	allSize += fileStat.size;
	// 文件路径base64编码，解决中文乱码，/问题。
	var buffer_uploadfile = new Buffer(path);
	var uploadfilepath = buffer_uploadfile.toString('base64');
	jQuery.ajax({
		url : "/docs/networkdisk/addChoosedFiles.jsp",
		data : {
			'filePath': uploadfilepath,
			'uploadtype': uploadtype,
			'fileSize': fileStat.size,
			'clientguid': userInfos.guid,
			'cdate': moment(fileStat.ctime).format('YYYY-MM-DD'),
			'ctime': moment(fileStat.ctime).format('HH:mm:ss'),
			'mdate': moment(fileStat.mtime).format('YYYY-MM-DD'),
			'mtime': moment(fileStat.mtime).format('HH:mm:ss'),
			'fileMd5': filemd5,
			'categoryid': categoryid,
			'isSystemDoc' : window.VIEW_MODEL == "disk" ? 0 : 1,
			'comefrom':comefrom
		},
		type : "post",
		dataType : "json",
		success : function(data){
			var fileData = {};
			fileData = {
					id:data.uploadfileguid,
					uid:filemd5,
					categoryid:categoryid,
					imagefileid:data.imageFileId,
					fileName:path.substring(path.lastIndexOf("\\")+1),
					fileSize:fileStat.size,
					fileType:path.substring(path.lastIndexOf(".")+1),
					filePath:path,
					networklogid:data.networklogid,
					isSystemDoc : window.VIEW_MODEL == "disk" ? 0 : 1,
					uploadtype: uploadtype
				};
			
			if(data.fileuploadstatus && data.fileuploadstatus != 2)
			{
				if(data.fileuploadstatus != 3){
					fillFileProcess(fileData);
					if(data.fileuploadstatus == 0)
					{
						hasExist(data.uploadfileguid);
					}
					else if(data.fileuploadstatus == 1){
						fillProgressBar(data.uploadfileguid,100);
					}
				}
			}
			else
			{
				fillFileProcess(fileData);
				if(!isExistUpload(filemd5,2))
				{
					doUploadFile(path,fileStat,filemd5,data.uploadfileguid,comefrom);
				}
			}
			//document.getElementById("contentFrame").contentWindow.Norecord("del");
		}
	});
}

//开始上传
function doUploadFile(path,fileStat,filemd5,uploadfileguid,comefrom){
	uploadFile(path,fileStat,filemd5,uploadfileguid,comefrom);
}

//上传弹出选择文件前（右键上传点击隐藏右键菜单）
function openFileView(){
	hideRightClickMenu();
}

//显示、隐藏上传进程窗口
function toggleUploadView(){
	if(jQuery("#uploadList:visible").length > 0){
		if(jQuery("#uploadDialogBody").is(":visible")){
			jQuery("#uploadMImg").addClass("uploadMImg_max").removeClass("uploadMImg");
			if(jQuery("#upload_current .num_current").html() > 0){
				jQuery("#upload_current").show();
			}
			if(jQuery("#download_current .num_current").html() > 0){
				jQuery("#download_current").show();
			}
			if(jQuery("#upload_over .num_current").html() > 0){
				jQuery("#upload_over").show();
			}
			if(jQuery("#download_over .num_current").html() > 0){
				jQuery("#download_over").show();
			}
		}else{
			jQuery("#uploadMImg").addClass("uploadMImg").removeClass("uploadMImg_max");
			jQuery("#upload_current,#download_current,#upload_over,#download_over").hide();
		}
		jQuery("#uploadDialogBody").slideToggle();
		jQuery("#cancelAllDiv").slideToggle();
		jQuery("#uploadList").toggleClass("hideBody");
	}else{
		jQuery("#uploadList").show();
	}
}

function hideUploadView(e){
	if(!e || (jQuery(e.target).closest("#uploadList").length == 0 && jQuery(e.target).closest("#uploadFileDiv").length == 0)){
		var _class = jQuery("#uploadMImg").attr("class");
		if(_class && _class.indexOf("uploadMImg") > -1){
			jQuery("#uploadMImg").addClass("uploadMImg_max").removeClass("uploadMImg");
			jQuery("#uploadDialogBody").slideUp();
			jQuery("#cancelAllDiv").slideUp();
			jQuery("#uploadList").addClass("hideBody");
		}
	}
}
function showUploadView(){
	if(!jQuery("#uploadDialogBody").is(":visible")){
		toggleUploadView();
	}
}


//同步本地文件到系统
function onSyncDownload(id){
	window.top.Dialog.confirm("完成后请到相应目录查看，确认同步？",function(){
		jQuery.ajax({
		url : "/docs/networkdisk/getnetdisksyncsetting.jsp",
		data : {
			'id' : id
		},
		type : "post",
		dataType : "json",
		success : function(data){
			for (var key = 0 ; key < data.length ; key ++) {
				var rootpath = data[key].localPath;
				var categoryid = data[key].targetPath;
				var _filePathArray = '';
				// 递归遍历syncdirpath文件夹
				dirTravel.travel(rootpath,function (filename,pathname,fileStat) {
					_filePathArray += '&&&&&&&' + pathname ;
				});
				_filePathArray = _filePathArray.substring(7);
				
				// 文件路径base64编码，解决中文乱码，/问题。
				var buffer_rootpath = new Buffer(rootpath);
				var buffer_rootpath_path = buffer_rootpath.toString('base64');	
				
				// 文件路径base64编码，解决中文乱码，/问题。
				var buffer_filePathArray = new Buffer(_filePathArray);
				var buffer_filePathArray_path = buffer_filePathArray.toString('base64');
				createrSyncFolder(categoryid,buffer_filePathArray_path,buffer_rootpath_path);
			}
		}
	});
	});
}

function createrSyncFolder(categoryid,filePathArray,rootPath)
{
	jQuery.ajax({
		url : "/docs/networkdisk/createSyncFolder.jsp",
		data : {
			'filePathArray': filePathArray,
			'rootPath': rootPath,
			'categoryid': categoryid
		},
		type : "post",
		dataType : "json",
		success : function(data){
			var folderMap = data[0].folderMap;
			var folderItem = [];
			for(var key in  folderMap)
			{
				var pid = folderMap[key].substring(0,folderMap[key].indexOf('_'));
				var name = folderMap[key].substring(folderMap[key].indexOf('_')+1);
				if(pid == getCurrentCateId())
				{
					folderItem.push({
						sid : key,
						sname : name
					});
				}
			}
			document.getElementById("contentFrame").contentWindow.addView({
				folderArray : folderItem
			});
			
			var fileData = data[0].filepathMap;
			
			
			for(var key in  fileData)
			{
				var fileStat = getFilefileStat(key);
				
				addchoosedFileToTemptable(fileData[key],key,fileStat,1,'sync');
			}
		}
	});
}

//打开上传进程窗口
function openUploadView(){
	jQuery("#uploadList").show();
}

//关闭上传进程窗口
function closeUploadView(){
	jQuery("#uploadList").hide();
}

//取消选中
function cancelSelect(){
	document.getElementById("contentFrame").contentWindow.cancelSelect();
}

//新建文档
function onCreateDoc(){

	onUpload();
	//openFullWindowForXtable("/docs/docs/DocAdd.jsp?secid=" + getCurrentCateId() + "&hasTab=1&_fromURL=4"); 
	//parent.openUrl("/docs/docs/DocAdd.jsp?secid=" + getCurrentCateId() + "&hasTab=1&_fromURL=4"); 
	//http://localhost:9921/docs/docs/DocAddForCK.jsp?secid=193&hasTab=1&_fromURL=4&e71473817365702=&f_weaver_belongto_userid=undefined&f_weaver_belongto_usertype=undefined&docmodule=23
}

//下载
function onDownload(dataMap){
	hideRightClickMenu();
	if(window.__isBrowser){
	   dataMap = dataMap ? dataMap : getSelectIds();
	   if(dataMap.fileid.indexOf(",") > - 1){
	       top.window.alert("暂不支持批量下载!");
	       return;
	   }   
	   location = "/weaver/weaver.file.FileDownload?download=1&fileid=" + dataMap.fileid;
	   return;
	}
	var e_dialog = window.Electron.remote.dialog;
	e_dialog.showOpenDialog(window.Electron.currentWindow, {properties : ['openDirectory']}, function(choosed){
	    if(choosed) {
			// 文件路径base64编码，解决中文乱码，/问题。
			var buffer_choosed = new Buffer(choosed[0]);
			var choosedBuffer = buffer_choosed.toString('base64');
			saveDLFileTemp(choosedBuffer,dataMap);
	    }
	});
}

function openLocalPath(filepath,openFile)
{
        fs.exists(filepath, function (exists) {
            if(exists) {
                var shell = window.Electron.remote.shell;
                if(openFile) {
                    shell.openItem(filepath);
                } else {
                    shell.showItemInFolder(filepath);
                }
            } else {
                window.top.Dialog.alert(warmFont.downloadWithoutFile);
            }
        });
}


function saveDLFileTemp(choosed,dataMap)
{
	var dataMap = dataMap ? dataMap : getSelectIds();
	if(dataMap.folderid == "" && dataMap.fileid == "")
		return;
	
	// 文件路径base64编码，解决中文乱码，/问题。
	var buffer_choosed = new Buffer(choosed);
	var buffer_choosed_path = buffer_choosed.toString('base64');	
	jQuery.ajax({
		url : "/docs/networkdisk/addDownloadFileTemp.jsp",
		data : {
			'folderIds': dataMap.folderid,
			'fileids' : dataMap.fileid,
			'downloadpath' : choosed,
			'clientguid': userInfos.guid,
			'isSystemDoc' : window.VIEW_MODEL == "disk" ? 0 : 1
		},
		type : "post",
		dataType : "json",
		success : function(data){
			
			for(var i = 0 ; i < data.length ; i ++)
			{
				var item = data[i];
				var fileDataProcess = {
					id:item.id,
					uid:item.uid,
					fileType:item.filetype,
					fileName:item.filename,
					fileSize:item.filesize,
					filePath:item.localpath,
					networklogid:item.logid
				};
				
				var filepathStr = item.localpath.split('\\');
				for(var j = 0 ;j < filepathStr.length ; j ++)
				{
					var filepathTemp = '';
					for(var k = 0 ;k <= j ; k ++)
					{
						filepathTemp += filepathStr[k] + "\\"; 
					}
					if(!fs.existsSync(filepathTemp))
					{
						fs.mkdirSync(filepathTemp);
					}
				}
				fillFileProcess(fileDataProcess,'download');
				
			}
			for(var h = 0 ; h < data.length ; h ++)
			{
				var _item = data[h];
				syncdownfiles(_item,_item.localpath);
			}
		}
	});
}

//导入选中文档到虚拟目录
function onImportSelect(){
	hideRightClickMenu();
	var dataMap = getSelectIds();
	showDummy(dataMap);
}

//导入全部文档到虚拟目录
function onImportAll(){
	hideRightClickMenu();
	showDummy({categoryid : getCurrentCateId()});
}

function showDummy(dataMap){
	if(dataMap.fileid == "" && (!dataMap.categoryid || dataMap.categoryid == "")) 
		return;
	var dialog = new top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = warmFont.dummy; 
	dialog.Height = 600;
	dialog.Width = 600;
	dialog.URL = "/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para=_1";
	dialog.callback = function(data){
		if(data && data.id && data.id != ""){
			showLoading();
			dataMap.dummyIds = data.id;
			dataMap.type = "importDummy";
			jQuery.ajax({
				url : "/rdeploy/chatproject/doc/eventForAjax.jsp", 
				type : "post",
				data : dataMap,
				dataType : "json",
				success : function(data){
					hideLoading();
					if(data && data.flag == "1"){
						window.top.Dialog.alert(warmFont.importSuccess);
					}else{
						window.top.Dialog.alert(warmFont.importFail);
					}
				}
			});
		}
	}
	dialog.show();
}

//提交订阅
function onAsk(){
	var dataMap = getSelectIds();
	var dialog = new top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = warmFont.submitScription; 
	dialog.Height = 600;
	dialog.Width = 600;
	dialog.URL = "/docs/docsubscribe/DocSubscribeAdd.jsp?subscribeDocId=" + dataMap.fileid + "&isdialog=1";
	dialog.callback = function(data){
		if(data && data == "1"){
			window.top.Dialog.alert(warmFont.applySuccess,function(){
				onSubDocscribe();
			});
		}
	}
	dialog.show();
	
}

//保存分享业务
function addNetWorkFileShare(_fileid,_targetId,_sharetype,_filetype,_extra){
	var extra = eval("(" + _extra + ")");
	jQuery.ajax({
		url : "/docs/networkdisk/addNetWorkFileShare.jsp",
		data : {
			'tosharerid':_targetId,
			'fileid':_fileid,
			'sharetype': parseInt(_sharetype)+1,
			'filetype': _filetype,
			'msgid' : extra.msg_id
		},
		type : "post",
		dataType : "json",
		success : function(data){
			//console.log(data);
		}
	});
}


function sendCancel2Msg(mesList){
	if(mesList){
		for(var i = 0;i < mesList.length;i++){
			var args = {
				event : 'cancelShare-Message',
				args : {
					cancelType : "disk",
					msgid : mesList[i].msgid,
					targettype : mesList[i].type - 1,
					targetid : mesList[i].targetid
				}
			}; 
			window.Electron.ipcRenderer.send('send-to-mainChatWin', args);
		}
	}
}

function removeChildView(dataMap){
	if(getChildModel() == "tableList"){
		document.getElementById("contentFrame").contentWindow.reload();
	}else{
		document.getElementById("contentFrame").contentWindow.removeView(dataMap);
	}
}


function fullPrivateDivNav(loadfoldertype,params) {
    $("#navItem").empty();
    var itemData;
    var widthItemDiv = 0;
    	var sid = $("#privateId").val();
    	if(loadfoldertype == "privateAll"){
    		itemData = privateIdMap[sid];
    	}else if(loadfoldertype == "myShare"){
    		itemData = myShareIdMap[sid];
    	}else if(loadfoldertype == "shareMy"){
    		itemData = shareMyIdMap[sid];
    	}
    	while(sid != '0' && (!params || !params.txt || params.txt == ""))
    	{
    			if(typeof(itemData) != 'undefined')
                {
	               	if(itemData.pid == '0')
	               	{
	               		break;
	               	}
                }
                else
                {
                	break;
                }
                $divNav = $("<div />");
                $divNav.attr('id', itemData.sid + "divNav");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                $a.attr({
	                	'id' : itemData.sid,
	                	'title' : itemData.sname
                	});
                $a.append(itemData.sname);
                $divNav.append($a);
                $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', itemData.sid + "divNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
                $("#navItem").prepend($divNav).prepend($divParentNavLine);
                widthItemDiv += $("#"+itemData.sid + "divNav").outerWidth()+$("#"+itemData.sid + "divNavLine").outerWidth();
                if(loadfoldertype == "privateAll"){
		    		itemData = privateIdMap[itemData.pid];
		    	}else if(loadfoldertype == "myShare"){
		    		itemData = myShareIdMap[itemData.pid];
		    	}else if(loadfoldertype == "shareMy"){
		    		itemData = shareMyIdMap[itemData.pid];
		    	}
    	}
    
    	$divNav = $("<div />");
                $divNav.attr('id', "privateAlldivNav");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                var tabShowName = warmFont.diskFont;
                if(loadfoldertype == "myShare"){
                	tabShowName = warmFont.myShare;
                }else if(loadfoldertype == "shareMy"){
                	tabShowName = warmFont.shareMy;
                }
                $a.attr("title",tabShowName).append(tabShowName);
                $divNav.append($a);
                
                $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', "privateAlldivNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
                
                $("#navItem").prepend($divNav);
                widthItemDiv += $("#privateAlldivNav").outerWidth();
                widthItemDiv += $("#privateAlldivNavLine").outerWidth();
      
      if(params && params.txt && params.txt != ""){
	      var $searchNav = $("<div/>");
	            $searchNav.attr('id', "searchdivNav"); 
	            $searchNav.addClass("e8ParentNavContent");    
	            $a = $("<a />");
	            $a.addClass("nava");
	            var aname = "\"" + params.txt + "\" " + warmFont.searchResult;
	            $a.attr({
		            	'id': "searchaNav",
		            	'title' : aname	
		            }); 
	            $a.append(aname);
	            $searchNav.append($a);
	            
	            $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', "searchdivNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
	            
	            $("#navItem").append($divParentNavLine).append($searchNav);
	            widthItemDiv += $("#privateAlldivNav").outerWidth();
	            widthItemDiv += $("#privateAlldivNavLine").outerWidth();
	    }
    
     if($("#navItem").outerWidth()-100 < widthItemDiv)
     {
           $(".e8ParentNavContent").each(function()
			{
			    if($("#navItem").outerWidth() -100 < widthItemDiv)
		       	{
		       		if($(this).css("display") == "block")
		       		{
		       			var wid = $(this).outerWidth();
	       				var widl = $(this).next().outerWidth();
		       			widthItemDiv = widthItemDiv - wid;
		       			widthItemDiv = widthItemDiv - widl;
		       			$(this).hide();
		       			$(this).next().hide();
		       		}
		       	}
			});      
                 
	}
}


function fullDivNav(searchItem,subscritbe) {
    $("#navItem").empty();
    var itemData;
    var widthItemDiv = 0;
	var sid = $("#privateId").val();
   	itemData = publicIdMap[sid];
   			while(true)
   			{
                if(typeof(itemData) == "undefined")
                {
                	$divNav = $("<div />");
	                $divNav.attr('id', "0divNav");
	                $divNav.addClass("e8ParentNavContent");
	                $a = $("<a />");
	                $a.addClass("nava");
	                $a.append(warmFont.systemCategory);
	                $a.attr("title",warmFont.systemCategory);
	                $divNav.append($a);
	                
	                $divParentNavLine = $("<div />");
	                $divParentNavLine.attr('id', "0divNavLine");
	                $divParentNavLine.addClass("e8ParentNavLine");
	                
	                $("#navItem").prepend($divNav);
	                widthItemDiv += $("#0divNav").outerWidth();
	                widthItemDiv += $("#0divNavLine").outerWidth();
                	break;
                }
                else
                {
                	//$("#" + sid + "divNavLine").nextAll().remove();
	                //$("#" + sid + "divNavLine").remove();
	                $divNav = $("<div />");
	                $divNav.attr('id', itemData.sid + "divNav");
	                $divNav.addClass("e8ParentNavContent");
	                $a = $("<a />");
	                $a.addClass("nava");
	                $a.attr('id', itemData.sid);
	                $a.append(itemData.sname);
	                $a.attr("title",itemData.sname);
	                $divNav.append($a);
	                $divParentNavLine = $("<div />");
	                $divParentNavLine.attr('id', itemData.sid + "divNavLine");
	                $divParentNavLine.addClass("e8ParentNavLine");
	                
	                $("#navItem").prepend($divNav).prepend($divParentNavLine);
	                 widthItemDiv += $("#"+itemData.sid + "divNav").outerWidth()+$("#"+itemData.sid + "divNavLine").outerWidth();
	                 itemData = publicIdMap[itemData.pid];
                }
   			}
    if(subscritbe){
	    $divNav = $("<div />");
	    $divNav.attr('id', "subDivNav");
	    $divNav.addClass("e8ParentNavContent");
	    $a = $("<a />");
	    $a.addClass("nava");
	    $a.attr("id","subDivaNav");
	    $a.append(warmFont.subscribeDoc);
	    $a.attr("title",warmFont.subscribeDoc);
	    $divNav.append($a);
	    
	    $divParentNavLine = $("<div />");
	    $divParentNavLine.attr('id', "subDivNavLine");
	    $divParentNavLine.addClass("e8ParentNavLine");
	    
	    $("#navItem").append($divParentNavLine).append($divNav);
	    widthItemDiv += $("#0divNav").outerWidth();
	    widthItemDiv += $("#0divNavLine").outerWidth();
	    disabledOpt(true);
    }
    
    if(searchItem && searchItem.txt && searchItem.txt != ""){
    	var $searchNav = $("<div/>");
        $searchNav.attr('id', "searchdivNav"); 
        $searchNav.addClass("e8ParentNavContent");    
        $a = $("<a />");
        $a.addClass("nava");
        var aname = "\"" + searchItem.txt + "\" " + warmFont.searchResult;
        $a.attr({
         	'id': "searchaNav",
         	'title' : aname	
         }); 
        $a.append(aname);
        $searchNav.append($a);
        
        $divParentNavLine = $("<div />");
           $divParentNavLine.attr('id', "searchdivNavLine");
           $divParentNavLine.addClass("e8ParentNavLine");
        
        $("#navItem").append($divParentNavLine).append($searchNav);
        widthItemDiv += $("#privateAlldivNav").outerWidth();
        widthItemDiv += $("#privateAlldivNavLine").outerWidth();
    }
    
     if($("#navItem").outerWidth()-100 < widthItemDiv)
     {
           $(".e8ParentNavContent").each(function()
			{
			    if($("#navItem").outerWidth() -100 < widthItemDiv)
		       	{
		       		if($(this).css("display") == "block")
		       		{
		       			var wid = $(this).outerWidth();
	       				var widl = $(this).next().outerWidth();
		       			widthItemDiv = widthItemDiv - wid;
		       			widthItemDiv = widthItemDiv - widl;
		       			$(this).hide();
		       			$(this).next().hide();
		       		}
		       	}
			});      
                 
	}
}