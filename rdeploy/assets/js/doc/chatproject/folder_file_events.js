jQuery(function(){
	jQuery(document).unbind("contextmenu").bind("contextmenu", function (e) { //禁用鼠标右键系统菜单
        return false;
    });
    parent.disabledOpt(false); // 防止偶尔单击事件造成的该隐藏的按钮未隐藏的情况
	jQuery(window).mousedown(function(e){ //绑定鼠标点击事件
		e = e || event;
		
		var markClick =  jQuery(e.target).hasClass("maskDiv") || jQuery(e.target).parent().hasClass("itemico") 
							? true : false; //点击的位置是否为文件夹或者文件图标
		if(e.button == "0"){
			parent.hideRightClickMenu();
			if(markClick){
				return;
			}
			if(!e.ctrlKey){
				jQuery(".item.select").removeClass("select");
				parent.disabledOpt(false);
			}
		}else if(e.button == "2"){
			if(markClick){ 
				if(!jQuery(e.target).closest(".item").hasClass("select") && !e.ctrlKey){
					jQuery(e.target).closest(".item").addClass("select").siblings(".item.select").removeClass("select");
					parent.disabledOpt(true);					
				}
			}else if(!e.ctrlKey){
				jQuery(".item.select").removeClass("select");
			}
			e.preventDefault();
            var _left = e.clientX;
            var _top = e.clientY;
			parent.showRightMenuByPosition(_left,_top);
		}
	});
	
	jQuery(".item").live({ //绑定文件夹、文件所在块事件
		mouseover : function(){
			if(!jQuery(this).find(".itemico").children("img").attr("_dataid"))
				return;
			jQuery(this).addClass("hover");
		},
		mouseout : function(){
			jQuery(this).removeClass("hover");
		}
	}).find(".maskDiv").live({ //绑定遮罩层事件
		dblclick : function(){
			jQuery(this).siblings(".itemico").find("img.canSelect").dblclick();	
			parent.disabledOpt(false);
		},
		click : function(e){
			e = e || event;
			imgClick(this,e);
		}
	}).end().find(".itemico").find("img.canSelect").live({ //绑定文件夹、文件图标
		click : function(e){
			e = e || event;
			imgClick(this,e)
		}
	});
	
	jQuery(".newFolderItem .edit-name input").live({
		keypress : function(e){e = e || event;
			if(e.keyCode == 13){
				jQuery(this).siblings(".sure").click();
			}
		}
	});
	
	//标题绑定事件
	if(loadfoldertype == "privateAll"){
		jQuery(".item .itemtitle").live({
			click : function(e){
				e = e || event;
				if(e.ctrlKey || jQuery(this).find("input").length > 0){
					return;
				}
				var _title = jQuery(this).attr("fileName");
				var $input = jQuery("<input name='aaa' class='editTitle' value='" + _title + "'/>");
				jQuery(this).html($input);
				$input.focus();
				var pos = $input.val().length;
				if($input[0].setSelectionRange){
					$input[0].setSelectionRange(pos,pos);
				}else if ($input[0].createTextRange) {
					var range = $input[0].createTextRange(); 
					range.collapse(true); 
					range.moveEnd('character', pos); 
					range.moveStart('character', pos); 
					range.select(); 
				}
				
			}
		});
		
		//绑定文件夹、文件名修改input事件
		jQuery(".item .editTitle").live({
			blur : function(){
				var _name = this.value;
				var _title = jQuery(this).parent().attr("title");
				_name = _title && _title.indexOf(".") > -1 ? (_name + _title.substring(_title.lastIndexOf("."))) : _name;
				var that = this;
				if(_name == ""){
		    		top.Dialog.alert("名称不能为空!",function(){
		    			jQuery(that).focus();
		    		});
		    		return;
		    	}else if(/[\\/:*?"<>|]/.test(_name)){
		    		top.Dialog.alert("名称不能包含下列字符：<br/>\\/:*?\"<>|",function(){
		    			jQuery(that).focus();
		    		});
		    		return;
		    	}
				
				var _type = jQuery(this).closest(".item").attr("_datatype");
				var _id = jQuery(this).closest(".item").attr("id").replace("ItemId","");
				var _uid = parent.userInfos.guid;
				var data;
				var url = "";
				if(_type == "file"){
					url = "/rdeploy/chatproject/doc/renameImageFile.jsp"
					data = {
						fileName : _name,
						imagefileid : _id,
						uid : _uid,
						categoryid : parent.getCurrentCateId()
					}
				}else if(_type == "folder"){
					url = "/rdeploy/chatproject/doc/addSeccategory.jsp"
					data = {
						foldertype : "privateAll",
						categoryname : _name,
						categoryid : _id
					}
				}else{
					return;
				}
				
				var that = this;
				
				jQuery.ajax({
					url : url,
					type : "post",
					data : data,
					dataType : "json",
					success : function(data){
						if(data["result"] == "success"){
							
							var doctitleWidth = getStrWidth(_name,14);
							var doctitle = _name;
							if(doctitleWidth/140 > 1.7)
							{
								while(doctitleWidth/140 > 1.7)
								{
									doctitle = doctitle.substring(0,doctitle.length-2);
									doctitleWidth = getStrWidth(doctitle,14);
								}
								doctitle = doctitle.substring(0,doctitle.length-3);
								doctitle = doctitle+"...";
							}
							jQuery(that).parent().html(doctitle).attr("title",_name).attr("fileName",that.value).prev(".itemico").children().attr("title",_name);
						}else if(data["result"] == "fail"){
							var $input = jQuery(that);
							$input.focus();
							var pos = $input.val().length;
							if($input[0].setSelectionRange){
								$input[0].setSelectionRange(pos,pos);
							}else if ($input[0].createTextRange) {
								var range = $input[0].createTextRange(); 
								range.collapse(true); 
								range.moveEnd('character', pos); 
								range.moveStart('character', pos); 
								range.select(); 
							}
						}else if(data["result"] == "exist"){
							top.Dialog.alert(parent.warmFont.fileNameExist);
						}
					}
				});
				
			}
		});
	}
	
	//设置层最小高度，适用内容较少无法撑满可视窗口问题
	jQuery("#itemsDiv").css("min-height",jQuery(window).height() - 53);
	
});

//点击文件夹、文件图标
function imgClick(thi,e){
	var $item = jQuery(thi).closest(".item");
	if(!$item.find(".itemico").find("img.canSelect").attr("_dataid"))
		return;
	if(e.ctrlKey){  //ctrl点击
		$item.toggleClass("select"); //当前对象选中、不选中切换
	}else{ 
		if($item.hasClass("select")){ //当前是选中状态
			if($item.siblings(".item.select").length > 0){ //还有其他选中的对象
				$item.siblings(".item.select").removeClass("select"); //其他选中对象取消选中
			}else{ 
				$item.removeClass("select"); //当前对象取消选中
			}
		}else{
			$item.addClass("select").siblings(".item.select").removeClass("select");
		}
	}
	
	if($item.parent().children(".item.select").length > 0){
		parent.disabledOpt(true);
	}else{
		parent.disabledOpt(false);
	}
	parent.hideRightClickMenu();
}

//获取选中文件夹、文件的id
function getselectIds(){
	var folderid = "";
	var fileid = "";
	var shareid = "";
	jQuery(".item.select").each(function(){
		var _type = jQuery(this).attr("_datatype");
		var _id = jQuery(this).attr("id");
		var _shareid = jQuery(this).attr("_shareid");
		if(_type == "folder"){
			folderid += _id ? ("," + _id.replace("ItemId","")) : "";
		}else if(_type == "file"){
			fileid += _id ? ("," + _id.replace("ItemId","")) : "";
		}
		shareid += _shareid ? ("," + _shareid) : ""; 
	});
	
	folderid = folderid == "" ? "" : folderid.substring(1);
	fileid = fileid == "" ? "" : fileid.substring(1);
	shareid = shareid == "" ? "" : shareid.substring(1);
	
	return {folderid : folderid,fileid : fileid,shareid : shareid};
}

//获取选中文件夹、文件
function getselectItems(){
	var folderid = "";
	var fileid = "";
	var resultMap = {};
	var folderArray = new Array();
	var fileArray = new Array();
	jQuery(".item.select").each(function(){
		var _type = jQuery(this).attr("_datatype");
		var _id = jQuery(this).attr("id");
		var _shareid = jQuery(this).attr("_shareid");
		_id = _id  ? ( _id.replace("ItemId","")) : "";
		var _title = jQuery(this).find(".itemtitle").attr("title");
		var selectItem = {};
		selectItem['id'] = _id ;
		selectItem['name'] = _title;
		selectItem['shareid'] = _shareid ? _shareid : "";
		if(_type == "folder"){
			folderArray.push(selectItem);
		}else if(_type == "file"){
			fileArray.push(selectItem);
		}
	});
	resultMap['folderArray'] = folderArray;
	resultMap['fileArray'] = fileArray;
	return resultMap;
}

//复制事件，将复制的文件夹、文件id存放到存储对象中
function saveIdByCopy(){
	return getselectItems();
}

//打开文件夹或者文件
function doOpen(){
	jQuery(".item.select .itemico img").dblclick();
}

//重命名文件夹或者文件
function doRename(){
	jQuery(".item.select .itemtitle").click();
}

//删除指定的文件、文件夹
function removeView(dataMap){
	if(dataMap && dataMap.folderid != ""){
		var ids = dataMap.folderid.split(",");
		for(var i = 0 ;i < ids.length;i++){
			jQuery("div#" + ids[i] + "ItemId[_datatype='folder']").remove();
		}
	}
	
	if(dataMap && dataMap.fileid != ""){
		var ids = dataMap.fileid.split(",");
		for(var i = 0 ;i < ids.length;i++){
			jQuery("div#" + ids[i] + "ItemId[_datatype='file']").remove();
		}
	}
}

//添加指定的文件、文件夹
function addView(dataMap){
	if(!dataMap)return;
	
	var folderArray = dataMap.folderArray;
	var fileArray = dataMap.fileArray;
	
	var emptyFlag = false;
	
	if(folderArray){
		for(var i = 0 ;i < folderArray.length;i++){
			if(jQuery("#" + folderArray[i].sid + "ItemId[_datatype='folder']").length > 0) 
				continue;
			emptyFlag = true;	
			if(parent.window.VIEW_MODEL == "disk"){
				fullPrivateFolderItem({
					sid : folderArray[i].sid,
					pid : parent.getCurrentCateId(),
					sname : folderArray[i].sname
				},"yes");
			}else if(parent.window.VIEW_MODEL == "systemDoc"){
				fullFolderItem({
					sid : folderArray[i].sid,
					pid : parent.getCurrentCateId(),
					sname : folderArray[i].sname
				},"yes");
			}
		}
	}
	
	if(fileArray){
		for(var i = 0 ;i < fileArray.length;i++){
		
			if(jQuery("div#" + fileArray[i].imagefileId + "ItemId[_datatype='file']").length > 0)
				continue;
			emptyFlag = true;
			if(parent.window.VIEW_MODEL == "disk"){
				fullPrivateDocitem(parent.getCurrentCateId(),{
					imagefileId : fileArray[i].imagefileId,
					docid : fileArray[i].docid,
					doctitle :  fileArray[i].doctitle,
					docExtendName : fileArray[i].docExtendName,
					fullName : fileArray[i].fullName,
				},parent.privateIdMap[parent.getCurrentCateId()],"yes");
			}else if(parent.window.VIEW_MODEL == "systemDoc"){
				fullDocitem(parent.getCurrentCateId(),{
					imagefileId : fileArray[i].imagefileId,
					docid : fileArray[i].docid,
					doctitle :  fileArray[i].doctitle,
					docExtendName : fileArray[i].docExtendName,
					fullName : fileArray[i].fullName,
				},parent.publicIdMap[parent.getCurrentCateId()],"yes");
			}
		}
	}
	
	if(emptyFlag)
		jQuery("#norecord").remove();
	
	
}

//取消未读标识（select-选中的文档，all-所有文档）
function removeNoReadMark(type){
	if(type == "select"){
		jQuery(".item.select[_datatype='file']").find("div[id*='newImgDiv']").remove();
	}else if(type == "all"){
		jQuery(".item[_datatype='file']").find("div[id*='newImgDiv']").remove();
	}
}

//取消选中
function cancelSelect(){
	jQuery(".item.select").removeClass("select");
}


//是否都有下载权限
function isAllDownload(docids){
	var ids = docids.split(",");
	for(var i = 0;i < ids.length;i++){
		if(jQuery("div#" + ids[i] + "ItemId[_datatype='file'][canDownload='1']").length == 0){
			return false;
		}
	}
	return true;
}
