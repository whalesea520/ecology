var dataJson = parent.dataJson;
var privateDataJson = parent.privateDataJson;
var loadfoldertype = $("#loadFolderType", window.parent.document).val();
var publicIds = parent.publicIds;
var privateIds = parent.privateIds;
var mapIds = {};
$(function() {
	jQuery("html").mousedown(function (e){
       		parent.$(".hiddensearch").animate({
				height: 0
				}, 200,null,function() {
					parent.jQuery(".hiddensearch").hide();
			}); 
       		parent.jQuery(".opensright").hide();
       		parent.jQuery(".selectstatus").hide();
			parent.jQuery(".sbPerfectBar").hide();
		});
	
    $("#swfuploadbtn", window.parent.document).hover(function() {
        $uploadFileDiv.css("background-color", "#65c3f9");
    },
    function() {
        $uploadFileDiv.css("background-color", "#4ba9df");
    });

    if (loadfoldertype == 'publicAll') {
        if (dataJson == null) {
            jQuery.ajax({
                url: "/rdeploy/chatproject/doc/dsm.jsp?foldertype=publicAll",
                type: "post",
                dataType: "json",
                success: function(data) {
                    parent.dataJson = data;
                    dataJson = data;
                    fullItemData($("#publicId", window.parent.document).val());
                }
            });
        } else {
            fullItemData($("#publicId", window.parent.document).val());
        }

        if (privateDataJson == null) {
            jQuery.ajax({
                url: "/rdeploy/chatproject/doc/dsm.jsp?foldertype=privateAll",
                type: "post",
                dataType: "json",
                success: function(data) {
                    privateDataJson = data;
                    parent.privateDataJson = data;
                }
            });
        }
    } else {
        if (privateDataJson == null) {
            jQuery.ajax({
                url: "/rdeploy/chatproject/doc/dsm.jsp?foldertype=privateAll",
                type: "post",
                dataType: "json",
                success: function(data) {
                    privateDataJson = data;
                    parent.privateDataJson = data;
                    $('#privateId').val('privateall');
                    fullItemData($("#privateId", window.parent.document).val());
                }
            });
        } else {
            fullItemData($("#privateId", window.parent.document).val());
        }
    }

    function itemHover(curItem) {
        curItem.css("border", "1px solid #F00");
    }

});

function downImageFile(docid, imageid) {
    downloadDocImgs(docid, {
        id: imageid,
        _window: parent,
        downloadBatch: 0,
        emptyMsg: "s"
    });
}

function delFolder(sid) {
    var flag = false;
    if (loadfoldertype == 'publicAll') {
        if ( !! dataJson[sid].childrenFolders) {
            if (dataJson[sid].childrenFolders.length > 0) {
                flag = true;
            }
        }
        if (!flag && !!dataJson[sid].childrenDocs) {
            if (dataJson[sid].childrenDocs.length > 0) {
                flag = true;
            }
        }
    } else {
        if ( !! privateDataJson[sid].childrenFolders) {
            if (privateDataJson[sid].childrenFolders.length > 0) {
                flag = true;
            }
        }
        if (!flag && !!privateDataJson[sid].childrenDocs) {
            if (privateDataJson[sid].childrenDocs.length > 0) {
                flag = true;
            }
        }
    }

    if (flag) {
        top.Dialog.alert("此目录包含子目录或文档");
    } else {
   	top.Dialog.confirm('确定删除此目录吗？',function(){
		       jQuery.ajax({
            url: "/rdeploy/chatproject/doc/SecCategoryOperation.jsp?isdialog=1&operation=delete&id=" + sid,
            type: "post",
            success: function(data) {
                if (loadfoldertype == 'publicAll') {
                    $.each(dataJson[dataJson[sid].pid].childrenFolders,
                    function(lid, category) {
                        if (category.sid == sid) {
                            dataJson[dataJson[sid].pid].childrenFolders.splice(lid, 1);
                            delete dataJson[sid];
                            parent.dataJson = dataJson;
                            $("#" + sid + "ItemId").remove();
                            return false;
                        }
                    });
                } else {
                    $.each(privateDataJson[privateDataJson[sid].pid].childrenFolders,
                    function(lid, category) {
                        if (category.sid == sid) {
                            privateDataJson[privateDataJson[sid].pid].childrenFolders.splice(lid, 1);
                            delete privateDataJson[sid];
                            parent.privateDataJson = privateDataJson;
                            $("#" + sid + "ItemId").remove();
                            return false;
                        }
                    });
                }
            }
        });
		       },function(){
		       	return;
		       });
    }
}

function fullDivNav(sid) {
    $("#navItem", window.parent.document).empty();
    var itemData;
    var widthItemDiv = 0;
    if (loadfoldertype == 'publicAll') {
        for (var i = 0; i < publicIds.length; i++) {
            itemData = dataJson[publicIds[i]];
            if (publicIds[i] == '0') {
                $("#navItem").empty();
                $divNav = $("<div />");
                $divNav.attr('id', itemData.sid + "divNav");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                $a.click(function() {
                    fullItemData('0');
                });
                $a.append("公共目录");
                $divNav.append($a);
                
                $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', itemData.sid + "divNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
                
                $("#navItem", window.parent.document).append($divNav).append($divParentNavLine);
                widthItemDiv += $("#"+itemData.sid + "divNav", window.parent.document).outerWidth();
                widthItemDiv += $("#"+itemData.sid + "divNavLine", window.parent.document).outerWidth();
            } else {
                $("#" + sid + "divNavLine").nextAll().remove();
                $("#" + sid + "divNavLine").remove();
                $divNav = $("<div />");
                $divNav.attr('id', itemData.sid + "divNav");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                $a.attr('id', itemData.sid);
                $a.click(function() {
                    fullItemData(this.id);
                });
                $a.append(itemData.sname);
                $divNav.append($a);
                $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', itemData.sid + "divNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
                
                $("#navItem", window.parent.document).append($divNav).append($divParentNavLine);
                 widthItemDiv += $("#"+itemData.sid + "divNav", window.parent.document).outerWidth()+$("#"+itemData.sid + "divNavLine", window.parent.document).outerWidth();
                 
            }
            
            var lastId = publicIds[publicIds.length-1];
            widthItemDiv = widthItemDiv - $("#"+lastId+"divNavLine", window.parent.document).outerWidth();
            $("#"+lastId+"divNavLine", window.parent.document).remove();
             if($("#navItem", window.parent.document).outerWidth()-100 < widthItemDiv)
                {
                 	 for (var j = 0; j < publicIds.length; j++) {
                 	 	var itemData = dataJson[publicIds[j]];
	                 	 	if($("#navItem", window.parent.document).outerWidth() -100 < widthItemDiv)
	                 	 	{
	                 	 		if($("#"+itemData.sid+"divNav", window.parent.document).css("display") == "block")
	                 	 		{
	                 	 			var wid = $("#"+itemData.sid+"divNav", window.parent.document).outerWidth();
                 	 				var widl = $("#"+itemData.sid+"divNavLine", window.parent.document).outerWidth();
	                 	 			widthItemDiv = widthItemDiv - wid;
	                 	 			widthItemDiv = widthItemDiv - widl;
	                 	 			$("#"+itemData.sid+"divNavLine", window.parent.document).hide();
	                 	 			$("#"+itemData.sid+"divNav", window.parent.document).hide();
	                 	 		}
	                 	 	}
                 }
                 }
            
        }
    } else {
    
        for (var i = 0; i < privateIds.length; i++) {
        
            if (privateIds[i] == 'privateAll') {
                $divNav = $("<div />");
                $divNav.attr('id', "privateAlldivNav");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                $a.click(function() {
                    fullItemData('privateAll');
                });
                $a.append("私人目录");
                $divNav.append($a);
                
                $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', "privateAlldivNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
                
                $("#navItem", window.parent.document).append($divNav).append($divParentNavLine);
                widthItemDiv += $("#privateAlldivNav", window.parent.document).outerWidth();
                widthItemDiv += $("#privateAlldivNavLine", window.parent.document).outerWidth();
            } else {
                itemData = privateDataJson[privateIds[i]];
                $divNav = $("<div />");
                $divNav.attr('id', itemData.sid + "divNav");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                $a.attr('id', itemData.sid);
                $a.click(function() {
                    fullItemData(this.id);
                });
                $a.append(itemData.sname);
                $divNav.append($a);
                $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', itemData.sid + "divNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
                $("#navItem", window.parent.document).append($divNav).append($divParentNavLine);
                widthItemDiv += $("#"+itemData.sid + "divNav", window.parent.document).outerWidth()+$("#"+itemData.sid + "divNavLine", window.parent.document).outerWidth();
            }
            
            var lastId = privateIds[privateIds.length-1];
            widthItemDiv = widthItemDiv - $("#"+lastId+"divNavLine", window.parent.document).outerWidth();
            $("#"+lastId+"divNavLine", window.parent.document).remove();
             if($("#navItem", window.parent.document).outerWidth() - 100 < widthItemDiv)
                {
                 	 for (var k = 0; k < privateIds.length; k++) {
                 	 	var sid='';
                 	 	 if (privateIds[k] == 'privateAll') {
                 	 	 	sid = 'privateAll';
                 	 	 }
                 	 	 else
                 	 	 {
                 	 	 	sid = privateIds[k];
                 	 	 }
	                 	 	if($("#navItem", window.parent.document).outerWidth() -100    < widthItemDiv)
	                 	 	{
	                 	 	
	                 	 		if($("#"+sid+"divNav", window.parent.document).css("display") == "block")
	                 	 		{
	                 	 			var wid = $("#"+itemData.sid+"divNav", window.parent.document).outerWidth();
                 	 				var widl = $("#"+itemData.sid+"divNavLine", window.parent.document).outerWidth();
	                 	 			widthItemDiv = widthItemDiv - wid;
	                 	 			widthItemDiv = widthItemDiv - widl;
	                 	 			$("#"+sid+"divNavLine", window.parent.document).hide();
	                 	 			$("#"+sid+"divNav", window.parent.document).hide();
	                 	 		}
	                 	 	}
                 }
                 }
            
        }
    }
}

function doDocDel(docid, sid) {
    var url = "/docs/docs/DocOperate.jsp?operation=delete&docid=" + docid;
    jQuery.ajax({
        url: url,
        type: 'post',
        success: function(data) {
        	var lft = $("#loadFolderType", window.parent.document).val();
           if(lft == "publicAll")
           {
           		$.each(dataJson[sid].childrenDocs,
	            function(lid, docShowModel) {
	                if (docShowModel.docid == docid) {
	                    dataJson[sid].childrenDocs.splice(lid, 1);
	                    parent.dataJson = dataJson;
	                    $("#" + docid + "ItemId").remove();
	                    return false;
	                }
	            });
           }
           else
           {
           		$.each(privateDataJson[sid].childrenDocs,
	            function(lid, docShowModel) {
	                if (docShowModel.docid == docid) {
	                    privateDataJson[sid].childrenDocs.splice(lid, 1);
	                    parent.privateDataJson = privateDataJson;
	                    $("#" + docid + "ItemId").remove();
	                    return false;
	                }
	            });
           }
           
    	if($("#itemsDiv").children().length <= 0 )
	{
		$norecord = $("<div />");
		 $norecord.attr("id","norecord");
		 $norecord.addClass("norecord");
		 $recordpicture = $("<div />");
		 $recordpicture.addClass("recordpicture");
		 $recordmessage = $("<div />");
		 $recordmessage.addClass("recordmessage");
		 $recordmessage.append("暂无记录");
		 $norecord.append($recordpicture).append($recordmessage);
		 $("#itemsDiv").append($norecord); 
	}
        }
    });
}

function fullItemData(sid) {
	loadfoldertype = $("#loadFolderType", window.parent.document).val();
	publicIds = parent.publicIds;
	privateIds = parent.privateIds;
 	$("#itemsDiv").empty();
    $createrFolderDiv = $("<div />");
    $createrFolderDiv.attr("id", "createrFolderDiv");
    $createrFolderDiv.attr("name", "createrFolderDiv");
    $createrFolderDiv.addClass("opBtn newFolder");
    $fimg = $("<div />");
    $fimg.addClass("fimg");
    $img = $("<img />");
    $img.attr("id", "createrFolderDivImg");
    $img.attr("name", "createrFolderDivImg");
    $img.attr("src", "/rdeploy/assets/img/cproj/doc/creater_no.png");
    $fimg.append($img);
    $ftext = $("<div />");
    $ftext.addClass("ftext");
    $font = $("<font />");
    $font.append("新建目录");
    $ftext.append($font);
    $createrFolderDiv.append($fimg).append($ftext);

    $uploadFileDiv = $("<div />");
    $uploadFileDiv.attr("id", "uploadFileDiv");
    $uploadFileDiv.attr("name", "uploadFileDiv");
    $uploadFileDiv.addClass("opBtn uploadOpBtn");

    $uimgDiv = $("<div />");
    $uimgDiv.addClass("uimg");
    $uimgDiv.attr("id", "uploadFileDivImg");
    $uimgDiv.attr("name", "uploadFileDivImg");

    $uimg = $("<img />");
    $uimg.addClass("uploadImg");
    $uimg.attr("id", "uploadFileDivImg");
    $uimg.attr("name", "uploadFileDivImg");
    $uimg.attr("src", "/rdeploy/assets/img/cproj/doc/upload_no.png");
    $uimgDiv.append($uimg);
    $utext = $("<div />");
    $utext.addClass("utext");
    $utext.append("上传");
    $uploadFileDiv.append($uimg).append($utext);

    $downloadDiv = $("<div />");
    $downloadDiv.attr("id", "downloadDiv");
    $downloadDiv.attr("name", "downloadDiv");
    $downloadDiv.addClass("opBtn downloadOpBtn");

    $dimgDiv = $("<div />");
    $dimgDiv.addClass("dimg");

    $dimg = $("<img />");
    $dimg.addClass("downloadImg");
    $dimg.attr("id", "downloadDivImg");
    $dimg.attr("name", "downloadDivImg");
    $dimg.attr("src", "/rdeploy/assets/img/cproj/doc/download_no.png");
    $dimgDiv.append($dimg);
    $dtext = $("<div />");
    $dtext.addClass("dtext");
    $dtext.append("下载");

    $downloadDiv.append($dimgDiv).append($dtext);
    var itemData;
    if (loadfoldertype == 'publicAll') {
        for (var i = 0; i < publicIds.length; i++) {
            if (publicIds[i] == sid) {
                publicIds.length = i;
                break;
            }
        }
        publicIds.push(sid);
        parent.publicIds = publicIds;
        $('#publicId', window.parent.document).val(sid);
        itemData = dataJson[sid];
    } else {
    	
        for (var i = 0; i < privateIds.length; i++) {
            if (privateIds[i] == sid) {
                privateIds.length = i;
                break;
            }
        }
      
        if(sid == "privateAll")
    	{
    		 privateIds.push(sid);
    	}
    	else
    	{
    		if(privateDataJson[sid].sname != parent.userLoginId)
    		{
    			privateIds.push(sid);
    		}
    	}
        parent.privateIds = privateIds;
        $('#privateId', window.parent.document).val(sid);
        if (sid == 'privateAll') {
            itemData = privateDataJson[privateDataJson[parent.userLoginId].sid];
        } else {
            itemData = privateDataJson[sid];
        }
    }
    // 有创建目录的权限
    if (itemData.canCreateFolder) {
        $createrFolderDiv.css("background-color", "#4ba9df");
        $img.attr("src", "/rdeploy/assets/img/cproj/doc/creater_folder_hot.png");
        $createrFolderDiv.css("color", "#fff");
        $createrFolderDiv.hover(function() {
            $createrFolderDiv.css("background-color", "#65c3f9");
        },
        function() {
            $createrFolderDiv.css("background-color", "#4ba9df");
        });

        $("#createrFolderDiv", window.parent.document).remove();
        $("#requestviewselect", window.parent.document).append($createrFolderDiv);
        $createrFolderDiv.click(function() {
            parent.createrFolder();
        });
    } else {
        $("#createrFolderDiv", window.parent.document).remove();
        $("#requestviewselect", window.parent.document).append($createrFolderDiv);
    }

    if (itemData.canCreateDoc) {

        $uploadFileDiv.css("background-color", "#4ba9df");
        $uimg.attr("src", "/rdeploy/assets/img/cproj/doc/upload_hot.png");
        $uploadFileDiv.css("color", "#fff");
        $("#swfuploadbtn", window.parent.document).show();
        $("#uploadFileDiv", window.parent.document).remove();
        $("#requestviewselect", window.parent.document).append($uploadFileDiv);
    } else {
        $("#swfuploadbtn", window.parent.document).hide();
        $("#uploadFileDiv", window.parent.document).remove();
        $("#requestviewselect", window.parent.document).append($uploadFileDiv);
    }

    fullDivNav(sid);
    
    $("#fpid", window.parent.document).val(itemData.sid);
    if(itemData.maxUploadFileSize == null || itemData.maxUploadFileSize == "")
    {
    	$("#fsize", window.parent.document).val("10");
    }
    else
    {
    	$("#fsize", window.parent.document).val(itemData.maxUploadFileSize);
    }
    
    
     $("#swfuploadbtn", window.parent.document).empty();
				var span = $("<span />");
				span.attr("id","uploadButton");
				$("#swfuploadbtn", window.parent.document).append(span);
		
		
	parent.initFileupload('uploadButton',$("#fsize", window.parent.document).val());
    if(itemData.childrenFolders.length > 0 ||  itemData.childrenDocs.length > 0)
    {
    	
    if (itemData.childrenFolders.length > 0) {
    	var cfs = itemData.childrenFolders;
    	cfs.sort(getSortFun('asc', 'orderCol'));
        $.each(cfs,
        function(sid, category) {
        
            $item = $("<div style='margin-top: 10px;' />");
            $item.attr('id', category.sid + "ItemId");

            $item.addClass("item");
            $itemtitle = $("<div style='margin-top: 0px;display:block;'/>");
            $itemtitle.attr('id', category.sid + "ItemTitleId");
            $itemtitle.addClass("itemtitle");
            $itemtitle.attr("title", category.sname);
            $itemtitle.append(category.sname);
            $itemDel = $("<div />");
            $itemDel.attr('id', category.sid + "ItemDelId");
            $itemDel.addClass("folderOpDiv");
            $itemDel.attr("title", "删除");
            
            $imgDel = $("<img />");
            $imgDel.attr("id",category.sid+"imgDel");
            $imgDel.attr("src","/rdeploy/assets/img/cproj/doc/op/del.png");
			$imgDel.hover(function(){
				$("#"+category.sid+"imgDel").attr("src","/rdeploy/assets/img/cproj/doc/op/del_hot.png");
			},function(){
				$("#"+category.sid+"imgDel").attr("src","/rdeploy/assets/img/cproj/doc/op/del.png");
			});
			
            $itemDel.append($imgDel);
            $itemico = $("<div />");
            $itemico.attr('id', category.sid + "ItemIcoId");
            $itemico.addClass("itemico");
            $icoimg = $("<img />");
            $icoimg.attr('id', category.sid + "ItemIcoimgId");
            $icoimg.attr("title", category.sname);
            $icoimg.attr("src", "/rdeploy/assets/img/cproj/doc/folder.png");
            $icoimg.attr("_dataid", category.sid);
            $icoimg.click(function() {
                fullItemData($(this).attr("_dataid"));
            });
            $itemico.append($icoimg);
            if (category.canDelete) {
                $imgDel.click(function() {
                    delFolder(category.sid);
                });
                $item.append($itemico).append($itemtitle).append($itemDel);
                $item.hover(function() {
                    $("#" + category.sid + "ItemId").css('border', '1px solid #e4e4e4');
                    $("#" + category.sid + "ItemDelId").show();
                },
                function() {
                    $("#" + category.sid + "ItemId").css('border', '1px solid #fff');
                    $("#" + category.sid + "ItemDelId").hide();
                });
            } else {
                $item.append($itemico).append($itemtitle);
                $item.hover(function() {
                    $("#" + category.sid + "ItemId").css('border', '1px solid #e4e4e4');
                },
                function() {
                    $("#" + category.sid + "ItemId").css('border', '1px solid #fff');
                });
            }
            $("#itemsDiv").append($item);
        });
    }
    if ( itemData.childrenDocs.length > 0) {
    var cds = itemData.childrenDocs;
    	cds.sort(getSortFun('desc', 'docid'));
        $.each(cds,
        function(sid, docShowModel) {
            fullDocitem(sid, docShowModel,itemData,"no","");
        });
    }
    }
    else
    {
		 $norecord = $("<div />");
		 $norecord.attr("id","norecord");
		 $norecord.addClass("norecord");
		 $recordpicture = $("<div />");
		 $recordpicture.addClass("recordpicture");
		 $recordmessage = $("<div />");
		 $recordmessage.addClass("recordmessage");
		 $recordmessage.append("暂无记录");
		 $norecord.append($recordpicture).append($recordmessage);
		 $("#itemsDiv").append($norecord); 
    }
}



function fullDocitem(sid, docShowModel,itemData,isNew,fileid)
{
			$item = $("<div />");
            $item.attr('id', docShowModel.docid + "ItemId");
            $item.addClass("item");
            $itemtitle = $("<div />");
            $itemtitle.addClass("itemtitle itemtitleW");
            $itemtitle.attr("title", docShowModel.doctitle);
            $itemtitle.attr("id", docShowModel.docid + "TitleItemId");
            $itemtitle.append(docShowModel.doctitle);

            $itemDel = $("<div />");
            $itemDel.attr('id', docShowModel.docid + "ItemDelId");
            $itemDel.addClass("docOpDiv");
            
           	 $imgDelDiv = $("<div />");
           	 $imgDelDiv.addClass("delDocDiv");
           	 $imgDel = $("<img />");
           	 $imgDel.attr("id",docShowModel.docid+"ImgDel");
           	  $imgDel.attr("title","删除");
            $imgDel.attr("src","/rdeploy/assets/img/cproj/doc/op/del.png");
            
            $imgDel.hover(function(){
				$("#"+docShowModel.docid+"ImgDel").attr("src","/rdeploy/assets/img/cproj/doc/op/del_hot.png");
			},function(){
				$("#"+docShowModel.docid+"ImgDel").attr("src","/rdeploy/assets/img/cproj/doc/op/del.png");
			});
            
            $imgDel.click(function() {
                doDocDel(docShowModel.docid, itemData.sid);
            });
            $imgDelDiv.append($imgDel);
            
            
            
            $imgDownloadDiv = $("<div />");
            $imgDownloadDiv.addClass("downloadDocDiv");
             $imgDownload = $("<img />");
             $imgDownload.attr("id",docShowModel.docid+"imgDownload");
             $imgDownload.attr("title","下载");
            $imgDownload.attr("src","/rdeploy/assets/img/cproj/doc/op/download.png");
            
            $imgDownload.hover(function(){
				$("#"+docShowModel.docid+"imgDownload").attr("src","/rdeploy/assets/img/cproj/doc/op/download_hot.png");
			},function(){
				$("#"+docShowModel.docid+"imgDownload").attr("src","/rdeploy/assets/img/cproj/doc/op/download.png");
			});
            
            $imgDownload.click(function() {
                downImageFile(docShowModel.docid, docShowModel.imagefileId);
            });
            $imgDownloadDiv.append($imgDownload);
            
             $imgShareDiv = $("<div />");
              $imgShareDiv.addClass("shareDocDiv");
             $imgShare = $("<img />");
              $imgShare.attr("id",docShowModel.docid+"imgShare");
               $imgShare.attr("title","分享");
            $imgShare.attr("src","/rdeploy/assets/img/cproj/doc/op/share.png");
            $imgShare.hover(function(){
				$("#"+docShowModel.docid+"imgShare").attr("src","/rdeploy/assets/img/cproj/doc/op/share_hot.png");
			},function(){
				$("#"+docShowModel.docid+"imgShare").attr("src","/rdeploy/assets/img/cproj/doc/op/share.png");
			});
			$imgShareDiv.append($imgShare);

            $itemDel.append($imgDownloadDiv).append($imgShareDiv).append($imgDelDiv);

            $itemico = $("<div />");
            $itemico.addClass("itemico");
            
    
    		$newImgDiv = $("<div />")
            $newImgDiv.css("position","absolute");
            $newImgDiv.css("right","47px");
            $newImgDiv.css("top","35px");
            
            $newImg = $("<img />");
            $newImg.attr("src", "/rdeploy/assets/img/cproj/doc/new.png");
            $newImgDiv.append($newImg);
            
            $icoimg = $("<img />");
            $icoimg.attr("title", docShowModel.doctitle);
            $icoimg.attr("src","/rdeploy/assets/img/cproj/doc/fileicon/"+docShowModel.docExtendName);
            
  			$icoimg.bind("error",function(){ 
				this.src="/rdeploy/assets/img/cproj/doc/fileicon/general_icon.png"; 
			}); 
  	
            
            
            $icoimg.attr("_dataid", docShowModel.docid);
            $icoimg.click(function() {
                // openFullWindowForXtable("/docs/docs/DocDsp.jsp?id="+$(this).attr("_dataid"));
            });
           if(docShowModel.readCount > 0)
           {
           		 $itemico.append($icoimg);
           }
           else
           {
           		 if(isNew == "yes")
           		{
           			$itemico.append($icoimg);
           		}
           		else
           		{
           			$itemico.append($newImgDiv).append($icoimg);
           		}
           		 
           }
           
            $item.append($itemico).append($itemtitle).append($itemDel);

            $itemico.click(function(e) {
                e = e || event;
                if (!e.ctrlKey) {
                    if (docShowModel.docid in mapIds) {
                        $.each(mapIds,
                        function(key, value) {
                            $("#" + key + "ItemId").css('border', '1px solid #fff');
                            $("#" + key + "TitleItemId").show();
                            $("#" + key + "ItemDelId").hide();

                            $("#" + key + "ItemId").bind({
                                mouseenter: function(e) {
                                    $("#" + key + "ItemId").css('border', '1px solid #e4e4e4');
                                    $("#" + key + "ItemDelId").show();
                                },
                                mouseleave: function(e) {
                                    $("#" + key + "ItemId").css('border', '1px solid #fff');
                                    $("#" + key + "ItemDelId").hide();
                                }
                            });
                        });
                        mapIds = {};
                    } else {
                        $.each(mapIds,
                        function(key, value) {
                            $("#" + key + "ItemId").css('border', '1px solid #fff');
                            $("#" + key + "TitleItemId").show();
                            $("#" + key + "ItemDelId").hide();

                            $("#" + key + "ItemId").bind({
                                mouseenter: function(e) {
                                    $("#" + key + "ItemId").css('border', '1px solid #e4e4e4');
                                    $("#" + key + "ItemDelId").show();
                                },
                                mouseleave: function(e) {
                                    $("#" + key + "ItemId").css('border', '1px solid #fff');
                                    $("#" + key + "ItemDelId").hide();
                                }
                            });
                        });
                        mapIds = {};
                        mapIds[docShowModel.docid] = docShowModel.docid;
                        $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #e4e4e4');
                        $("#" + docShowModel.docid + "ItemDelId").show();
                        $("#" + docShowModel.docid + "ItemId").unbind('mouseenter');
                        $("#" + docShowModel.docid + "ItemId").unbind('mouseleave');
                    }
                } else {
                    if (docShowModel.docid in mapIds) {
                        delete mapIds[docShowModel.docid];
                        $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #fff');
                        $("#" + docShowModel.docid + "TitleItemId").show();
                        $("#" + docShowModel.docid + "ItemDelId").hide();

                        $("#" + docShowModel.docid + "ItemId").bind({
                            mouseenter: function(e) {
                                $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #e4e4e4');
                                $("#" + docShowModel.docid + "ItemDelId").show();
                            },
                            mouseleave: function(e) {
                                $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #fff');
                                $("#" + docShowModel.docid + "ItemDelId").hide();
                            }
                        });
                    } else {
                        $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #e4e4e4');
                        $("#" + docShowModel.docid + "ItemDelId").show();
                        $("#" + docShowModel.docid + "ItemId").unbind('mouseenter');
                        $("#" + docShowModel.docid + "ItemId").unbind('mouseleave');
                        mapIds[docShowModel.docid] = docShowModel.docid;
                    }
                }

                if (Object.keys(mapIds).length > 0) {
                    $("#downloadDiv", window.parent.document).css("background-color", "#4ba9df");
                    $("#downloadDiv", window.parent.document).css("color", "#fff");
                    $("#downloadDivImg", window.parent.document).attr("src", "/rdeploy/assets/img/cproj/doc/download_hot.png");

                    $("#downloadDiv", window.parent.document).bind({
                        mouseenter: function(e) {
                            $("#downloadDiv", window.parent.document).css("background-color", "#65c3f9");
                        },
                        mouseleave: function(e) {
                            $("#downloadDiv", window.parent.document).css("background-color", "#4ba9df");
                        }
                    });
                    var ids = '';
                    $("#downloadDiv", window.parent.document).bind('click',
                    function() {
                        $.each(mapIds,
                        function(key, value) {
                            ids += key + ",";
                        });
                        ids = ids.substring(0, ids.length - 1);
                        downloadDocImgs('', {
                            id: ids,
                            _window: parent,
                            downloadBatch: 1,
                            docSearchFlag: 1,
                            emptyMsg: "s"
                        });
                    });

                } else {
                    $("#downloadDiv", window.parent.document).css("background-color", "#f2f2f2");
                    $("#downloadDiv", window.parent.document).css("color", "#cdcdcd");
                    $("#downloadDivImg", window.parent.document).attr("src", "/rdeploy/assets/img/cproj/doc/download_no.png");
                    $("#downloadDiv", window.parent.document).unbind('mouseenter');
                    $("#downloadDiv", window.parent.document).unbind('mouseleave');
                }
            });

            $item.bind({
                mouseenter: function(e) {
                    $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #e4e4e4');
                    $("#" + docShowModel.docid + "ItemDelId").show();
                },
                mouseleave: function(e) {
                    $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #fff');
                    $("#" + docShowModel.docid + "ItemDelId").hide();
                }
            });
           if(isNew == "yes")
           {
           		$("#itemsDiv").prepend($item);
           }
           else
           {
           		$("#itemsDiv").append($item);
           }
            
}




function getSortFun(order, sortBy) {
    var ordAlpah = (order == 'asc') ? '>' : '<';
    var sortFun = new Function('a', 'b', 'return a.' + sortBy + ordAlpah + 'b.' + sortBy + '?1:-1');
    return sortFun;
}