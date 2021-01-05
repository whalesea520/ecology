function fullPrivateDivNav(params) {
   parent.fullPrivateDivNav(loadfoldertype,params);
}

function fullPrivateItemData(sid,itemData,params) {
	canLoadScroll = false;
		SEARCH_PARAMS = params;
		parent.disabledOpt(false); 
		$("#loadingDiv").remove();
		// 判断是否有加载文档的异步请求，如果有异步请求，终止请求
		try
		{
			if(parent.currentAjax) {
	  				parent.currentAjax.abort();
	  		}
		}
		catch(Exception)
		{
			
		}
  		// 判断是否有加载目录的异步请求，如果有异步请求，终止请求
  		try
  		{
			if(parent.currentFolderAjax) {
	  				parent.currentFolderAjax.abort();
	  		} 
  		}
		catch(Exception)
		{
			
		}
		
		var data = {foldertype : loadfoldertype,categoryid : sid,orderby : parent.ORDER_BY};
		if(params && params.txt){
			data.txt = params.txt;
			parent.IS_SEARCH = true;
			pageSize= 1;
			data.pagesize = pageSize;
			data.pagecount = 50;
		}else{
			parent.IS_SEARCH = false;
		}
		
  		// 加载目录时清空列表
  		$("#itemsDiv").empty();
  		// 显示加载动画
		//$("#dataloading").show();
		parent.showLoading();
		// 设置不加载文档加载动画效果
		
  		parent.currentFolderAjax = jQuery.ajax({
                url: "/rdeploy/chatproject/doc/dsm.jsp?",
                type: "post",
                data : data,
                dataType: "json",
                success: function(data) {
					canLoadScroll = true;
                    	$("#privateId", window.parent.document).val(sid);
                    	$("#fpid", window.parent.document).val(sid);
                    	if(loadfoldertype == "privateAll"){
                    		parent.privateIdMap[sid] = itemData;
				    	}else if(loadfoldertype == "myShare"){
                    		parent.myShareIdMap[sid] = itemData;
				    	}else if(loadfoldertype == "shareMy"){
	                    	parent.shareMyIdMap[sid] = itemData;
				    	}
				        for(var i = 0 ;i < data.length;i++){
			        		if(itemData && itemData.sharetime){
			        			data[i].sharetime = itemData.sharetime;
			        		}
			        		if(itemData && itemData.username){
			        			data[i].username = itemData.username;
			        		}
			        		if(itemData && itemData.shareid){
			        			data[i].shareid = itemData.shareid;
			        		} 
				        	if(data[i].type == "folder"){
				        		fullPrivateFolderItem(data[i]);
				        	}else{
				        		fullPrivateDocitem(sid, data[i],itemData ,"no");
				        	}
				        }
				        	parent.hideLoading();
				        fullPrivateDivNav(params);
				        	if(parent.IS_SEARCH && data.length == 50){
					        	fullfinish = true;
				        	}else{
				        		fullfinish = false;
				        	}
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
                }
            });
}


function fullPrivateFolderItem(category,isNew)
{
	if(isNew != "yes"){
		category.sid = category.id;
		category.sname = category.categoryname;
		category.pid = category.parentid;
	}

	$item = $("<div style='margin-top: 10px;' _datatype='folder'/>");
	$item.attr('id', category.sid + "ItemId");
	if(category.shareid){
		$item.attr("_shareid", category.shareid);
	}
	$item.addClass("item");
	$itemtitle = $("<div style='margin-top: 0px;display:block;padding-left:5%;padding-right:5%;'/>");
	$itemtitle.attr('id', category.sid + "ItemTitleId");
	$itemtitle.addClass("itemtitle");
	$itemtitle.attr("title", category.sname);
	$itemtitle.attr("fileName", category.sname);
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
	if(loadfoldertype == "privateAll"){
  		$icoimg.attr("title", category.sname);
   	}else if(loadfoldertype == "myShare"){
  		$icoimg.attr("title", "名称：" + category.sname + "\n分享时间：" + category.sharetime);
   	}else if(loadfoldertype == "shareMy"){
  		$icoimg.attr("title", "名称：" + category.sname + "\n分享人：" + category.username + "\n分享时间：" + category.sharetime);
   	}
	$icoimg.attr("src", "/rdeploy/assets/img/cproj/doc/folder.png");
	$icoimg.attr("_dataid", category.sid);
	$icoimg.attr("class", "canSelect");
	$icoimg.dblclick(function() {
		if(loadfoldertype == "privateAll"){ 
			var _currentTitle = $(this).attr("title");
			if(_currentTitle && _currentTitle != category.sname){ //解决重命名，导航名称不变的问题
				category.sname = _currentTitle;
			}
		}
	    fullPrivateItemData($(this).attr("_dataid"),category);
	})
	$itemico.append($icoimg);
	  //  $imgDel.click(function() {
	  //      delFolder(category.sid);
	  //  });
	  //  $item.append($itemDel).append($itemico).append($itemtitle);
	  
	  var $maskDiv = "<div class='maskDiv'></div>";
	  
	    $item.append($itemico).append($itemtitle).append($maskDiv);
	//    $item.hover(function() {
	//        $("#" + category.sid + "ItemId").css('border', '1px solid #e4e4e4');
	//        $("#" + category.sid + "ItemDelId").show();
	//    },
	//    function() {
	//        $("#" + category.sid + "ItemId").css('border', '1px solid #fff');
	//        $("#" + category.sid + "ItemDelId").hide();
	//    });
	if(isNew == "yes")
           {
           		$("#itemsDiv").prepend($item);
           }
           else
           {
           		$("#itemsDiv").append($item);
           }
	
}

function updatePrivateOpBtn(sid)
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
	
	
						// 有创建目录的权限
		if (true) {
		  //  $createrFolderDiv.css("background-color", "#4ba9df");
		    $img.attr("src", "/rdeploy/assets/img/cproj/doc/creater_folder_hot.png");
		  //  $createrFolderDiv.css("color", "#fff");
		    $createrFolderDiv.hover(function() {
		 //       $createrFolderDiv.css("background-color", "#65c3f9");
		 		$createrFolderDiv.addClass("btnHover");
		    },
		    function() {
		  //      $createrFolderDiv.css("background-color", "#4ba9df");
		  		$createrFolderDiv.removeClass("btnHover");
		    });
					
		    $("#createrFolderDiv", window.parent.document).remove();
		    $("#requestviewselect", window.parent.document).prepend($createrFolderDiv);
		    $createrFolderDiv.click(function() {
		        parent.createrFolder();
		    });
		} 		
		if (true) {
			//				$uploadFileDiv.css("background-color", "#4ba9df");
		    $uimg.attr("src", "/rdeploy/assets/img/cproj/doc/upload_hot.png");
		  //  $uploadFileDiv.css("color", "#fff");
		  	$("#swfuploadbtn").hover(function() {
		  		$uploadFileDiv.addClass("btnHover");
		    },
		    function() {
		  		$uploadFileDiv.removeClass("btnHover");
		    });
		  
		    $("#swfuploadbtn", window.parent.document).show();
		    $("#uploadFileDiv", window.parent.document).remove();
		    $("#requestviewselect", window.parent.document).prepend($uploadFileDiv);
		    $("#fpid", window.parent.document).val(sid);
			$("#fsize", window.parent.document).val(maxUploadFileSize);
			
			     			//$("#swfuploadbtn", window.parent.document).empty();
			     			$("#swfuploadbtn", window.parent.document)[0].innerHTML = "";  //解决IE下 Object没有empty()方法的问题。
							var span = $("<span />");
							span.attr("id","uploadButton");
							$("#swfuploadbtn", window.parent.document).append(span);
							parent.initFileupload('uploadButton',$("#fsize", window.parent.document).val());
		} 
}

	function ajaxFullPrivateDocs(params)
	{
		var categoryid = -1;
		var itemData;
		categoryid = $("#privateId", window.parent.document).val();
		if(loadfoldertype == "privateAll"){
			itemData = parent.privateIdMap[categoryid];
    	}else if(loadfoldertype == "myShare"){
			itemData = parent.myShareIdMap[categoryid];
    	}else if(loadfoldertype == "shareMy"){
			itemData = parent.shareMyIdMap[categoryid];
    	}
    	
    	pageSize++;
    	var data = {foldertype : loadfoldertype,categoryid : categoryid,orderby : parent.ORDER_BY};
		data.txt = params.txt;
		data.pagesize = pageSize;
		data.pagecount = 50;
    	
		var showModelType = parent.SHOW_MODEL_TYPE;
		searchtype = 1;
  				if(fullfinish)
  				{
  					fullfinish = false;
  					// 判断是否有加载文档的异步请求，如果有终止请求
  					try
  					{
	  					if(parent.currentAjax) {
	  						parent.currentAjax.abort();
	  					}  
  					}
					catch(Exception)
					{
						
					}
  					parent.currentAjax = jQuery.ajax({
		                url: "/rdeploy/chatproject/doc/dsm.jsp",
		                type: "post",
		                data:data,
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
						    for(var i = 0 ;i < data.length;i++){
					        	fullPrivateDocitem(categoryid, data[i],itemData ,"no");
					        }
		     				
		     				$("#loadingDiv").remove();
					  		// $("#dataloading").hide();
					  		parent.hideLoading();
		                }
           			 }); 
  			}
	}
  
function fullPrivateDocitem(sid, docShowModel,itemData,isNew,fileid)
{
			$item = $("<div _datatype='file'/>");
            //$item.attr('id', docShowModel.docid + "ItemId");
            $item.attr('id', docShowModel.imagefileId + "ItemId");
            if(docShowModel.shareid){
	            $item.attr('_shareid', docShowModel.shareid);
            }
            $item.addClass("item");
            $itemtitle = $("<div />");
            $itemtitle.addClass("itemtitle itemtitleW");
           
            $itemtitle.attr("title", docShowModel.fullName);
			$itemtitle.attr("fileName", docShowModel.doctitle);
            $itemtitle.attr("id", docShowModel.docid + "TitleItemId");
			var doctitleWidth = getStrWidth(docShowModel.fullName,14);
			if(doctitleWidth/140 > 1.7)
			{
				var doctitle = docShowModel.fullName;
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
				$itemtitle.append(docShowModel.fullName);
			}
			
            $itemDel = $("<div />");
            $itemDel.attr('id', docShowModel.docid + "ItemDelId");
           	if(getStrWidth(docShowModel.fullName,14)/140 >= 1)
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
            	top.Dialog.alert("是否还需要再次同步？",function(){
            		doDocDel(docShowModel.docid);
            	});
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
            
    		
            
            $icoimg = $("<img />");
            if(loadfoldertype == "privateAll"){
	            $icoimg.attr("title", docShowModel.doctitle);
		   	}else if(loadfoldertype == "myShare"){
		  		$icoimg.attr("title", "名称：" + docShowModel.fullName + "\n大小：" + docShowModel.fileSize + "\n分享时间：" + (docShowModel.sharetime ? docShowModel.sharetime : itemData.sharetime));
		   	}else if(loadfoldertype == "shareMy"){
		  		$icoimg.attr("title", "名称：" + docShowModel.fullName + "\n大小：" + docShowModel.fileSize + "\n分享人：" + (docShowModel.username ? docShowModel.username : itemData.username) + "\n分享时间：" + (docShowModel.sharetime ? docShowModel.sharetime : itemData.sharetime));
		   	}
            $icoimg.attr("src","/rdeploy/assets/img/cproj/doc/fileicon/"+docShowModel.docExtendName);
            
  			$icoimg.bind("error",function(){ 
				this.src="/rdeploy/assets/img/cproj/doc/fileicon/general_icon.png"; 
			}); 
  	
          //  $icoimg.attr("_dataid", docShowModel.docid);
            $icoimg.attr("_dataid", docShowModel.imagefileId);
            $icoimg.attr("class", "canSelect");
            $icoimg.dblclick(function() {
                if(parent.window.__isBrowser){
                   openFullWindowForXtable("/rdeploy/chatproject/doc/imageFileView.jsp?fileid="+$(this).attr("_dataid") + (loadfoldertype == "shareMy" ? ("&shareid=" + docShowModel.shareid) : "")); 
                }else{
                  parent.openUrl("/rdeploy/chatproject/doc/imageFileView.jsp?fileid="+$(this).attr("_dataid") + (loadfoldertype == "shareMy" ? ("&shareid=" + docShowModel.shareid) : "")); 
                }
            });
           $itemico.append($icoimg);
           
           var $maskDiv = "<div class='maskDiv'></div>";
           
            $item.append($itemico).append($itemtitle).append($itemDel).append($maskDiv);
            /**
             $itemico.click(function(e) {
                e = e || event;
                // 隐藏了批量下载功能，所以多选功能也需要隐藏
                 if (!e.ctrlKey) {
               // if (true) {
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
            
            */
           // $item.bind({
           //     mouseenter: function(e) {
           //         $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #e4e4e4');
           //         $("#" + docShowModel.docid + "ItemDelId").show();
           //     },
           //     mouseleave: function(e) {
           //         $("#" + docShowModel.docid + "ItemId").css('border', '1px solid #fff');
           //         $("#" + docShowModel.docid + "ItemDelId").hide();
            //    }
           // });
           if(isNew == "yes")
           {
           		$("#itemsDiv").prepend($item);
           }
           else
           {
           		$("#itemsDiv").append($item);
           }
           
            
}
