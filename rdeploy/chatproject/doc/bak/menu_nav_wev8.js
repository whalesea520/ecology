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
    }
}

function fullDivNav(sid) {
    $("#navItem", window.parent.document).empty();
    var itemData;
    if (loadfoldertype == 'publicAll') {
        for (var i = 0; i < publicIds.length; i++) {
            itemData = dataJson[publicIds[i]];
            if (publicIds[i] == '0') {
                $("#navItem").empty();
                $divNav = $("<div />");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                $a.click(function() {
                    fullItemData('0');
                });
                $a.append("公共目录");
                $divNav.append($a);
                $("#navItem", window.parent.document).append($divNav);
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
                $("#navItem", window.parent.document).append($divParentNavLine).append($divNav);
            }
        }
    } else {
    console.log(privateIds+"-----------");
        for (var i = 0; i < privateIds.length; i++) {
            if (privateIds[i] == 'privateAll') {
                $divNav = $("<div />");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                $a.click(function() {
                    fullItemData('privateAll');
                });
                $a.append("私人目录");
                $divNav.append($a);
                $("#navItem", window.parent.document).append($divNav);
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
                $("#navItem", window.parent.document).append($divParentNavLine).append($divNav);
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
        privateIds.push(sid);
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
            $itemtitle = $("<div style='margin-top: 8px;'/>");
            $itemtitle.attr('id', category.sid + "ItemTitleId");
            $itemtitle.addClass("itemtitle");
            $itemtitle.attr("title", category.sname);
            $itemtitle.append(category.sname);
            $itemDel = $("<div />");
            $itemDel.attr('id', category.sid + "ItemDelId");
            $itemDel.addClass("delDiv");
            $itemDel.attr("title", "删除");
            $delA = $("<a style='line-height: 40px;' />");
            $delA.append("删除");

            $itemDel.append($delA);
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
                $delA.click(function() {
                    delFolder(category.sid);
                });
                $item.append($itemico).append($itemtitle).append($itemDel);
                $item.hover(function() {
                    $("#" + category.sid + "ItemId").css('border', '1px solid #e4e4e4');
                    $("#" + category.sid + "ItemTitleId").hide();
                    $("#" + category.sid + "ItemDelId").show();
                },
                function() {
                    $("#" + category.sid + "ItemId").css('border', '1px solid #fff');
                    $("#" + category.sid + "ItemTitleId").show();
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
            $itemDel.addClass("delDiv");
            $itemDel.attr("title", "删除");

            $downA = $("<a style='line-height: 40px;' />");
            $downA.append("下载");
            $downA.click(function() {
                downImageFile(docShowModel.docid, docShowModel.imagefileId);
            });

            $delA = $("<a style='line-height: 40px;' />");
            $delA.append("删除");
            $delA.click(function() {
                doDocDel(docShowModel.docid, itemData.sid);
            });

            $shareA = $("<a style='line-height: 40px;' />");
            $shareA.append("分享");

            $itemDel.append($downA).append("&nbsp;&nbsp;&nbsp;").append($delA).append("&nbsp;&nbsp;&nbsp;").append($shareA);

            $itemico = $("<div />");
            $itemico.addClass("itemico");
            
    
    		$newImgDiv = $("<div />")
            $newImgDiv.css("position","absolute");
            $newImgDiv.css("right","47px");
            $newImgDiv.css("top","14px");
            
            $newImg = $("<img />");
            $newImg.attr("src", "/rdeploy/assets/img/cproj/doc/new.png");
            $newImgDiv.append($newImg);
            
            $icoimg = $("<img />");
            $icoimg.attr("title", docShowModel.doctitle);
            $icoimg.attr("src","/rdeploy/assets/img/cproj/doc/"+docShowModel.docExtendName);
            
  			$icoimg.bind("error",function(){ 
				this.src="/rdeploy/assets/img/cproj/doc/html.png"; 
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
           		 $itemico.append($newImgDiv).append($icoimg);
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
                                    $("#" + key + "TitleItemId").hide();
                                    $("#" + key + "ItemDelId").show();
                                },
                                mouseleave: function(e) {
                                    $("#" + key + "ItemId").css('border', '1px solid #fff');
                                    $("#" + key + "TitleItemId").show();
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
                                    $("#" + key + "TitleItemId").hide();
                                    $("#" + key + "ItemDelId").show();
                                },
                                mouseleave: function(e) {
                                    $("#" + key + "ItemId").css('border', '1px solid #fff');
                                    $("#" + key + "TitleItemId").show();
                                    $("#" + key + "ItemDelId").hide();
                                }
                            });
                        });
                        mapIds = {};
                        mapIds[docShowModel.docid] = docShowModel.docid;
                        $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #e4e4e4');
                        $("#" + docShowModel.docid + "TitleItemId").hide();
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
                                $("#" + docShowModel.docid + "TitleItemId").hide();
                                $("#" + docShowModel.docid + "ItemDelId").show();
                            },
                            mouseleave: function(e) {
                                $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #fff');
                                $("#" + docShowModel.docid + "TitleItemId").show();
                                $("#" + docShowModel.docid + "ItemDelId").hide();
                            }
                        });
                    } else {
                        $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #e4e4e4');
                        $("#" + docShowModel.docid + "TitleItemId").hide();
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
                    $("#" + docShowModel.docid + "TitleItemId").hide();
                    $("#" + docShowModel.docid + "ItemDelId").show();
                },
                mouseleave: function(e) {
                    $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #fff');
                    $("#" + docShowModel.docid + "TitleItemId").show();
                    $("#" + docShowModel.docid + "ItemDelId").hide();
                }
            });
            $("#itemsDiv").append($item);
        });
    }
    }
    else
    {
		 $norecord = $("<div />");
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

function getSortFun(order, sortBy) {
    var ordAlpah = (order == 'asc') ? '>' : '<';
    var sortFun = new Function('a', 'b', 'return a.' + sortBy + ordAlpah + 'b.' + sortBy + '?1:-1');
    return sortFun;
}