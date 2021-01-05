function fullDivNav(searchItem) {
    parent.fullDivNav(searchItem,SUBSCRITBE);
}

function onSubscritbe(){
	SUBSCRITBE = true;
	pageSize = 1;
	fullfinish = true;
	$("#itemsDiv").empty();
	parent.showLoading();
	fullDivNav();
	ajaxFullDocs()
}
function fullItemData(sid,itemData,searchItem) {
	canLoadScroll = false;
	SUBSCRITBE = false;//是否来至订阅无权限查看的文档
	$("#loadingDiv").remove();
			try{
				if(parent.currentAjax) {
	  				parent.currentAjax.abort();
	  			}
	  			if(parent.currentFolderAjax) {
  				parent.currentFolderAjax.abort();
  				} 
			}
			catch(Exception){}
  			
		$("#itemsDiv").empty();
		//$("#dataloading").show();
		parent.showLoading();
		if(sid != "" && sid !=0){
				parent.jQuery("#askNoPermission,#markAllDoc").removeClass("disabled");
			}else{
				parent.jQuery("#askNoPermission,#markAllDoc").addClass("disabled");
			}
		if(itemData && itemData.canCreateDoc == "true"){
			parent.jQuery("#createDoc").removeClass("disabled");
		}else{
			parent.jQuery("#createDoc").addClass("disabled");
		}
		var dscurl = "/docs/networkdisk/DocSecCategoryById.jsp?categoryid="+ (searchItem ? "" : sid);
		if(searchItem)
		{
			SEARCH_PARAMS = searchItem;
			dscurl = dscurl + "&categoryname="+searchItem.txt;
		}
		
		getAllParents(sid,searchItem,function(){
			parent.currentFolderAjax = jQuery.ajax({
                url: dscurl,
                type: "post",
                dataType: "json",
                success: function(data) {
					canLoadScroll = true;
                    if (loadfoldertype == 'publicAll') {
                    	$("#privateId", window.parent.document).val(sid);
                    	$("#fpid", window.parent.document).val(sid);
                    	if(sid != '0')
						{
							if(typeof(itemData) != 'undefined')
							{
								parent.publicIdMap[sid] = itemData;
							}
						}
						else
						{
							parent.publicIdMap[sid] = itemData;
						}
					   // updateOpBtn(sid);
                    }
				    $.each(data,
				        function(sid, category) {
				        	fullFolderItem(category);
				        });
						
				        if(!getCheck())
				        {
				        	// $("#dataloading").hide();
				        	parent.hideLoading();
				        }
				        fullDivNav(searchItem);
				        	fullfinish = true;
							pageSize = 1;
				        	while(getCheck()){
						  		ajaxFullDocs(searchItem);
						  		if(getCheck())
						  		{
						  			break;
						  		}
						  		if(!fullfinish)
						  		{
						  			break;
						  		}
						  	} 	
                }
            });
		});
}

function getAllParents(categoryid,searchItem,fn){
	if(searchItem){
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			type : "post",
			data : {categoryid : categoryid,type : "publicParents"},
			dataType : "json",
			success : function(data){
				if(data && data.flag == "1"){
					for(var i = 0;i < data.dataList.length;i++){
						parent.publicIdMap[data.dataList[i].sid] = data.dataList[i];
					}
					if(parent.publicIdMap[categoryid] && parent.publicIdMap[categoryid].canCreateDoc == "true"){
						parent.jQuery("#createDoc").removeClass("disabled");
					}else{
						parent.jQuery("#createDoc").addClass("disabled");
					}
				}
			},
			complete : function(){
				fn();
			}
		});
	}else{
		fn();
	}
}


function fullFolderItem(category,isNew)
{
	$item = $("<div style='margin-top: 10px;' _datatype='folder'/>");
	$item.attr('id', category.sid + "ItemId");
	$item.addClass("item");
	$itemtitle = $("<div style='margin-top: 0px;display:block;padding:5%'/>");
	$itemtitle.attr('id', category.sid + "ItemTitleId");
	$itemtitle.addClass("itemtitle");
	$itemtitle.attr("title", category.sname);
	//$itemtitle.append(category.sname);
	var categorynameWidth = getStrWidth(category.sname,14);
	if(categorynameWidth/140 > 1.7)
	{
		var categoryname = category.sname;
		while(categorynameWidth/140 > 1.7)
		{
			categoryname = categoryname.substring(0,categoryname.length-2);
			categorynameWidth = getStrWidth(categoryname,14);
		}
		categoryname = categoryname.substring(0,categoryname.length-3);
		categoryname = categoryname+"...";
		$itemtitle.append(categoryname);
		
	}
	else
	{
		$itemtitle.append(category.sname);
	}
	//$itemDel = $("<div />");
	//$itemDel.attr('id', category.sid + "ItemDelId");
	//$itemDel.addClass("folderOpDiv");
	//$itemDel.attr("title", "删除");
	
	//$imgDel = $("<img />");
	//$imgDel.attr("id",category.sid+"imgDel");
	//$imgDel.attr("src","/rdeploy/assets/img/cproj/doc/op/del.png");
	//						$imgDel.hover(function(){
	//							$("#"+category.sid+"imgDel").attr("src","/rdeploy/assets/img/cproj/doc/op/del_hot.png");
	//						},function(){
	//							$("#"+category.sid+"imgDel").attr("src","/rdeploy/assets/img/cproj/doc/op/del.png");
	//						});
							
	//$itemDel.append($imgDel);
	$itemico = $("<div />");
	$itemico.attr('id', category.sid + "ItemIcoId");
	$itemico.addClass("itemico");
	$icoimg = $("<img />");
	$icoimg.attr('id', category.sid + "ItemIcoimgId");
	$icoimg.attr("title", category.sname);
	$icoimg.attr("src", "/rdeploy/assets/img/cproj/doc/folder.png");
	$icoimg.attr("_dataid", category.sid);
	$icoimg.attr("class", "canSelect");
	$icoimg.dblclick(function() {
	    fullItemData($(this).attr("_dataid"),category);
	});
	$itemico.append($icoimg);
	 var $maskDiv = "<div class='maskDiv'></div>";
	  
	    $item.append($itemico).append($itemtitle).append($maskDiv);
	/***
	if (category.canDelete) {
	    $imgDel.click(function() {
	        delFolder(category.sid);
	    });
	    $item.append($itemDel).append($itemico).append($itemtitle);
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
	***/
	
	if(isNew == "yes")
           {
           		$("#itemsDiv").prepend($item);
           }
           else
           {
           		$("#itemsDiv").append($item);
           }
}

function updateOpBtn(sid)
{
	var itemData = parent.publicIdMap[sid];
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
	$font.append(parent.warmFont.createFolder);
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
	var canDoc = false;
	var canManager = false;
	var maxUploadFileSize = 10;
	if (loadfoldertype == 'publicAll') 
	{
		if(typeof(itemData) != "undefined")
		{
			maxUploadFileSize = itemData.maxUploadFileSize;
			canDoc = itemData.canCreateDoc;
		}
		if(isAdmin)
		{
			canManager = true;
		}
		else
		{
			if(sid == '0')
			{
				canDoc = false;
				canManager = false;
			}
			else
			{
				canManager = itemData.canCreateFolder;
				canDoc = itemData.canCreateDoc;
			}
		}
	}
	
						// 有创建目录的权限
		if (canManager) {
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
					
		if (canDoc) {
							$uploadFileDiv.css("background-color", "#4ba9df");
		    $uimg.attr("src", "/rdeploy/assets/img/cproj/doc/upload_hot.png");
		    $uploadFileDiv.css("color", "#fff");
		    $("#swfuploadbtn", window.parent.document).show();
		    $("#uploadFileDiv", window.parent.document).remove();
		    $("#requestviewselect", window.parent.document).append($uploadFileDiv);
		    $("#fpid", window.parent.document).val(sid);
			$("#fsize", window.parent.document).val(maxUploadFileSize);
			
			     			$("#swfuploadbtn", window.parent.document).empty();
							var span = $("<span />");
							span.attr("id","uploadButton");
							$("#swfuploadbtn", window.parent.document).append(span);
							parent.initFileupload('uploadButton',$("#fsize", window.parent.document).val());
		} else {
		    $("#swfuploadbtn", window.parent.document).hide();
		    $("#uploadFileDiv", window.parent.document).remove();
		    $("#requestviewselect", window.parent.document).append($uploadFileDiv);
		}
}

	function ajaxFullDocs(searchItem)
	{
		var categoryid = -1;
		var itemData;
		if (loadfoldertype == 'publicAll') {
			categoryid = $("#privateId", window.parent.document).val();
			itemData = parent.publicIdMap[categoryid];
			searchtype = SUBSCRITBE ? 2 : 0; //是否为订阅无权限查看的文档
		}
  				if(fullfinish)
  				{
  					fullfinish = false;
  					try{
	  					if(parent.currentAjax) {
	  						parent.currentAjax.abort();
	  					}
  					}
					catch(Exception){}
					var docurl = "/rdeploy/chatproject/doc/getDocsBySecid.jsp";
					
  					parent.currentAjax = jQuery.ajax({
		                url: docurl,
		                type: "post",
		                data: {
							categoryid : categoryid,
							txt : searchItem ? searchItem.txt : '',
							createrid : searchItem ? searchItem.createrid : '',
							departmentid : searchItem ? searchItem.departmentid : '',
							seccategory : searchItem ? searchItem.seccategory : '',
							createdatefrom : searchItem ? searchItem.createdatefrom : '',
							createdateto : searchItem ? searchItem.createdateto : '',
							searchType :searchItem ? searchItem.searchType : '',
							
							
							pageCount : 50,
							pageSize : pageSize,
							type : searchtype
		                },
						dataType: 'json',
		                success: function(data) {
		                	if(data.length < 50)
		                	{
		                		fullfinish=false;
		                	}
		                	else
		                	{
		                		fullfinish = true;
		                	}
						    $.each(data,
						    function(sid, docShowModel) {
						        fullDocitem(categoryid, docShowModel,itemData ,"no",searchtype);
						        
						    });
		     				pageSize ++;
		     				if(data.length <= 0 )
		     				{
		     					var contentbox = document.getElementById('itemsDiv');
						  		var boxs = getClass(contentbox,'item');
						  		if(boxs.length <= 0)
						  		{
									$norecord = $("<div />");
									 $norecord.attr("id","norecord");
									 $norecord.addClass("norecord");
									 $recordpicture = $("<div />");
									 $recordpicture.addClass("recordpicture");
									 $recordmessage = $("<div />");
									 $recordmessage.addClass("recordmessage");
									 $recordmessage.append(parent.warmFont.noData);
									 $norecord.append($recordpicture).append($recordmessage);
									 $("#itemsDiv").append($norecord); 
						  		}
		     				}
					  		 //$("#dataloading").hide();
					  		 parent.hideLoading();
					  		 $("#loadingDiv").remove();
		                }
           			 }); 
  			}
	}
  
 function getSortFun(order, sortBy) {
    var ordAlpah = (order == 'asc') ? '>' : '<';
    var sortFun = new Function('a', 'b', 'return a.' + sortBy + ordAlpah + 'b.' + sortBy + '?1:-1');
    return sortFun;
}

function fullDocitem(sid, docShowModel,itemData,isNew,fileid)
{
	$("#norecord").remove();
			$item = $("<div _datatype='file'/>");
            $item.attr('id', docShowModel.docid + "ItemId");
            $item.addClass("item");
            $item.attr("canDownload",docShowModel.isdownload ? "1" : "0");
            $itemtitle = $("<div />");
            $itemtitle.addClass("itemtitle itemtitleW");
            $itemtitle.attr("title", docShowModel.doctitle);
            $itemtitle.attr("id", docShowModel.docid + "TitleItemId");
           var doctitleWidth = getStrWidth(docShowModel.doctitle,14);
			if(doctitleWidth/140 > 1.7)
			{
				var doctitle = docShowModel.doctitle;
				while(doctitleWidth/140 > 1.7)
				{
					doctitle = doctitle.substring(0,doctitle.length-2);
					doctitleWidth = getStrWidth(doctitle,14);
				}
				doctitle = doctitle.substring(0,doctitle.length-3);
				doctitle = doctitle+"...";
				$itemtitle.append(doctitle);
				
			}
			else
			{
				$itemtitle.append(docShowModel.doctitle);
			}

            $itemDel = $("<div />");
            $itemDel.attr('id', docShowModel.docid + "ItemDelId");
            if(getStrWidth(docShowModel.doctitle,14)/140 > 1)
			{
				 $itemDel.addClass("docOpDivMoreRow");
			}
			else
			{
				$itemDel.addClass("docOpDiv");
			}
            
            
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
                doDocDel(docShowModel.docid, docShowModel.categoryid);
            });
            
            $imgDelDiv.append($imgDel);
            
            
            
            $imgDownloadDiv = $("<div />");
            $imgDownloadDiv.addClass("downloadDocDiv");
             $imgDownload = $("<img />");
             $imgDownload.attr("id",docShowModel.docid+"imgDownload");
             $imgDownload.attr("title","下载");
             $imgDownload.attr("_docid",docShowModel.docid);
             $imgDownload.attr("_imagefileId",docShowModel.imagefileId);
            $imgDownload.attr("src","/rdeploy/assets/img/cproj/doc/op/download.png");
            
            $imgDownload.hover(function(){
				$("#"+docShowModel.docid+"imgDownload").attr("src","/rdeploy/assets/img/cproj/doc/op/download_hot.png");
			},function(){
				$("#"+docShowModel.docid+"imgDownload").attr("src","/rdeploy/assets/img/cproj/doc/op/download.png");
			});
            
            $imgDownload.click(function() {
                downImageFile($(this).attr("_docid"), $(this).attr("_imagefileId"));
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

            if(isNew == "yes")
           {
            	$itemDel.append($imgDownloadDiv).append($imgShareDiv).append($imgDelDiv);
            }
            else
            {
            	if(docShowModel.isdownload)
            	{
            		$itemDel.append($imgDownloadDiv);
            	}
            	
            	
            	$itemDel.append($imgShareDiv)
            	
            	if(docShowModel.isdelete)
            	{
            		$itemDel.append($imgDelDiv)
            	}
            	
            	if(docShowModel.isdownload && !docShowModel.isdelete)
            	{
            		$itemDel.css("margin-left","97px");
            		$itemDel.css("width","60px");
            	}
            	else if(!docShowModel.isdownload && docShowModel.isdelete)
            	{
            		$itemDel.css("margin-left","121px");
            		$itemDel.css("width","35px");
            	}
            	else if(!docShowModel.isdownload && !docShowModel.isdelete)
            	{
            		$itemDel.css("margin-left","121px");
            		$itemDel.css("width","35px");
            	}
            	
            }

            $itemico = $("<div />");
            $itemico.addClass("itemico");
            
    
    		$newImgDiv = $("<div />")
    		$newImgDiv.attr("id",docShowModel.docid+"newImgDiv");
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
            $icoimg.attr("class", "canSelect");
            $icoimg.dblclick(function() {
            	$("#"+$(this).attr("_dataid")+"newImgDiv").remove();
                // openFullWindowForXtable("/docs/docs/DocDsp.jsp?id="+$(this).attr("_dataid"));
				 parent.openUrl("/docs/docs/DocDsp.jsp?id="+$(this).attr("_dataid")); 
                 
            });
           if(docShowModel.readCount > 0  || docShowModel.createrid == loginid)
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
           
          //  $item.append($itemico).append($itemtitle).append($itemDel);
            var $maskDiv = "<div class='maskDiv'></div>";
           
            $item.append($itemico).append($itemtitle).append($maskDiv);
			
			/***
            $itemico.click(function(e) {
                e = e || event;
                // 隐藏了批量下载功能，所以多选功能也需要隐藏
                // if (!e.ctrlKey) {
                if (false) {
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
                        mapIds[docShowModel.docid] = docShowModel.imagefileId;
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
                        mapIds[docShowModel.docid] = docShowModel.imagefileId;
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
                    var imgids = '';
                    $("#downloadDiv", window.parent.document).unbind("click");
                    $("#downloadDiv", window.parent.document).bind('click',
	                    function() {
	                        $.each(mapIds,
	                        function(key, value) {
	                        	ids += key +",";
	                            imgids += value + ",";
	                        });
	                        ids = ids.substring(0, ids.length - 1);
	                        imgids = imgids.substring(0, imgids.length - 1);
							if(ids.indexOf(",") <= 0)
							{
								downImageFile(ids,imgids);
							}
							else
							{
								var btdocids = "";
								btdocids = ids;
						    	if(btdocids==null ||btdocids==''){
						     		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(27694,user.getLanguage())%>");
						     		return false;
						    	}else{
						     		window.location="/weaver/weaver.file.FileDownload?fieldvalue="+btdocids+"&displayUsage=1&download=1&downloadBatch=1&docSearchFlag=1&urlType=<%=urlType%>&requestid=";
						    	}
							}        				
			            
	                   });

                } else {
                    $("#downloadDiv", window.parent.document).css("background-color", "#f2f2f2");
                    $("#downloadDiv", window.parent.document).css("color", "#cdcdcd");
                    $("#downloadDivImg", window.parent.document).attr("src", "/rdeploy/assets/img/cproj/doc/download_no.png");
                    $("#downloadDiv", window.parent.document).unbind('mouseenter');
                    $("#downloadDiv", window.parent.document).unbind('mouseleave');
                }
            });
            ***/
			/***
            $item.bind({
                mouseenter: function(e) {
                    $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #e4e4e4');
                    $("#" + docShowModel.docid + "ItemDelId").show();
                },
                mouseleave: function(e) {
                    $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #fff');
                    $("#" + docShowModel.docid + "ItemDelId").hide();
                }
            });***/
           if(isNew == "yes")
           {
           		$("#itemsDiv").prepend($item);
           }
           else
           {
           		$("#itemsDiv").append($item);
           }
}
