$(function() {
    jQuery(".divtab_menu ul li").on("click",
    function() {
        if (!$(this).find("a").hasClass("selected")) {
            var oldselectedele = $(".divtab_menu ul li a.selected");
            oldselectedele.removeClass("selected");
            $(this).find("a").addClass("selected");
            showmodel($(this).find("input[name=model]").val(), $(this).find("a").width());
        }
    });

    jQuery(".divtab_menu ul li").bind("mouseover",
    function(e) {
        $(this).find("a").css("color", "#626671");
    });

    jQuery(".divtab_menu ul li").bind("mouseout",
    function(e) {
        $(this).find("a").css("color", "#939d9e");
    });

   // jQuery(".searchspan").on("click",
   // function() {
        //onSearchResult();
  //      window.top.Dialog.alert("该功能暂未开放,敬请期待!");
  //  });

    jQuery(".closesearch").on("click",
    function() {
        jQuery(".searchshow").css("display", "none");
    });

    jQuery(".adspan").on("click",
    function() {
        advancedSearch();
      // window.top.Dialog.alert("该功能暂未开放,敬请期待!");
    });

    __jNiceNamespace__.beautySelect();

    $("span[id^=sbHolderSpan_]").css("max-width", "95%");

    $("#date").daterangepicker({
        separator: " - "
    },
    function(start, end, label) {
        $("#createdatefrom").val(start);
        $("#createdateto").val(end);
    });

   
/*
	jQuery("html").mousedown(function (e){ 
        	if(!!!jQuery(e.target).closest(".hiddensearch")[0] && !!!jQuery(e.target).closest(".adspan")[0] && !!!jQuery(e.target).closest(".opensright")[0] && !!!jQuery(e.target).closest(".ac_results")[0]){
				$(".hiddensearch").animate({ 
					height: 0
					}, 200,null,function() {
					jQuery(".hiddensearch").hide();
				}); 
			}
        });
    
    	$("#uploadMImg").bind("click",function (){
			if($("#uploadDialogBody").is(":hidden"))
			{
				$("#uploadMImg").addClass("uploadMImg");
				$('#uploadDialogBody').perfectScrollbar("show");
			}
			else
			{
				$("#uploadMImg").addClass("uploadMImg_max");
				$('#uploadDialogBody').perfectScrollbar("hide");
			}
			$("#uploadDialogBody").slideToggle();
			$("#cancelAllDiv").slideToggle();
		});
		
		$("#uploadCImg").bind("click",function (){
			if(uploadfinish)
			{
			
				$("#uploadList").hide();
				$("#fsUploadProgressannexupload").empty();
				$("#uptitle").empty();
					$("#uptitle").append("正在上传：");
					$("#suCount").empty();
					$("#suCount").append("0");
					$("#count").empty();
			}
			else
			{
				top.Dialog.confirm('列表中有未上传完成的文件，确定要放弃上传吗？',function(){
				$("#fsUploadProgressannexupload > div").each(function(){
					if($('#'+$(this).attr('id')+'rprogressBarStatus').text() != "上传完成")
	          		{
	          			oUploadannexupload.cancelUpload($(this).attr('id'), false);
	          		}
		          	$(this).remove();
				});
				$("#uploadList").hide();
				$("#uptitle").empty();
				$("#uptitle").append("正在上传：");
				$("#suCount").empty();
				$("#suCount").append("0");
				$("#count").empty();
				});
			}
		});
	**/	
		
$("#cancelAllDiv .cancelAllUpload span").bind("click",function (){
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
          		    var __id = $(this).attr('id');
          		    if(__id.indexOf("SWFUpload_0_") == 0){
          			   oUploadannexupload.cancelUpload(__id, false);
          		    }else if(__id.indexOf("SWFUpload_1_") == 0){
          		       oUploadannexuploadLi.cancelUpload(__id, false);
          		    }else if(__id.indexOf("SWFUpload_2_") == 0){
          		       oUploadannexuploadAdd.cancelUpload(__id, false);
          		    }
	          		$(this).fadeOut("slow",function(){
					   $(this).remove();
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
		
		//$("#uptitle").empty();
		//$("#uptitle").append("全部取消完成");
		//$("#sp").hide();
		//$("#suCount").empty();
		// $("#count").empty();
		// $("#uploadDialogBody").slideToggle();
		// $("#cancelAllDiv").slideToggle();
	});
});

        function upFolder(){
        	var _len = jQuery("#navItem").find(".e8ParentNavContent").length;
        	if(_len > 1){
        		jQuery("#navItem").find(".e8ParentNavContent").eq(_len - 2).find(".nava").click();
        	}else{
        		jQuery("#navItem").find(".e8ParentNavContent").find(".nava").click();
        	}
        	
        	return;
        	//disabledOpt(false);
			var sid;
			$(window.frames["contentFrame"].document).find("#loadingDiv").remove();
			if ($("#loadFolderType").val() == 'publicAll') {
				sid = $("#publicId").val();
				if(sid != "0")
				{
					sid = publicIdMap[sid].pid;
				}
				$("#publicId").val(sid);
				contentFrame.window.fullItemData(sid,publicIdMap[sid]);
			}
			else
			{
				var sid = $("#privateId").val();
				if(sid != "0")
				{
					sid = privateIdMap[sid] ? privateIdMap[sid].pid : '0';
					if(!privateIdMap[sid] || privateIdMap[sid].pid == '0')
					{
						sid = '0';
					}
				}
				$("#privateId").val(sid);
				contentFrame.window.fullPrivateItemData(sid,privateIdMap[sid]);
			}
		}

/**
	*清空搜索条件
	*/
function __resetCondtion() {
    jQuery(".advancedSearch").find("#begindate, #enddate").val("");
    jQuery(".advancedSearch").find("select").val("");
    jQuery(".advancedSearch").find("select").trigger("change");
    jQuery(".advancedSearch").find("select").selectbox('detach');
    jQuery(".advancedSearch").find("select").selectbox('attach');
    jQuery(".advancedSearch").find("span[id^=sbHolderSpan_]").css("max-width", "95%");
    //清空文本框
    jQuery(".advancedSearch").find("input[type='text']").val("");
    //清空浏览按钮及对应隐藏域
    jQuery(".advancedSearch").find(".Browser").siblings("span").html("");
    jQuery(".advancedSearch").find(".Browser").siblings("input[type='hidden']").val("");
    jQuery("#createdatefrom").val("");
    jQuery("#createdateto").val("");
    jQuery(".advancedSearch").find(".e8_os").find("input[type='hidden']").val("");
    jQuery(".advancedSearch").find(".e8_outScroll .e8_innerShow span").html("");
    jQuery(".advancedSearch").find("#doctitle")[0].focus();
}

/**
     * 根据model元素的值，变更iframe的src
     */
function showmodel(modelstr, width) {
	disabledOpt(false);
    var iframesrc = "";
    var left = 0;
    $("#loadFolderType").val(modelstr);
    switch (modelstr) {
    case "publicAll":
        iframesrc = "/rdeploy/chatproject/doc/seccategoryViewList.jsp?_" + new Date().getTime() + "=1&";
        left = 29;
        break;
    case "privateAll":
        iframesrc = "/rdeploy/chatproject/doc/seccategoryViewList.jsp?_" + new Date().getTime() + "=1&";
        $("#fpid").val("privateAll");
        left = 118;
        break;
    case "myShare" : 
    	iframesrc = "/rdeploy/chatproject/doc/seccategoryViewList.jsp?_" + new Date().getTime() + "=1&";
        left = 29;
        break;  
    case "shareMy" : 
    	iframesrc = "/rdeploy/chatproject/doc/seccategoryViewList.jsp?_" + new Date().getTime() + "=1&";
        left = 29;
        break;  
    default:
        iframesrc = "";
    }
    slideline(left, width);
    $("#contentFrame").attr("src", iframesrc);
}

/**
    * 线条跟随滑动
    ***/
function slideline(left, width) {
    jQuery(".moveline").animate({
        left: left,
        width: width + 16
    },
    5, null,
    function() {});
}

function advancedSearch() {
    jQuery(".hiddensearch").show();
    jQuery(".hiddensearch").animate({
        height: [310, 'easeInQuad']
    },
    200);
}

function doSearch() {
    $(".hiddensearch").animate({
        height: 0
    },
    10, null,
    function() {
        jQuery(".hiddensearch").hide();
    });
    var doctitle = jQuery("input[name=doctitle]").val();
    var createrid = jQuery("input[name=createrid]").val();
    var departmentid = jQuery("input[name=departmentid]").val();
    var seccategory = jQuery("input[name=seccategory]").val();
    var createdatefrom = jQuery("input[name=createdatefrom]").val();
    var createdateto = jQuery("input[name=createdateto]").val();
    
	var data = {
		txt : doctitle,
		createrid : createrid,
		departmentid : departmentid,
		seccategory : seccategory,
		createdatefrom : createdatefrom,
		createdateto : createdateto,
		searchType : 1
	};
	
	if(doctitle == "" && createrid == "" && departmentid == "" && seccategory == "" && createdatefrom == "" && createdateto == ""){
		data = undefined;
		seccategory = parent.getCurrentCateId();
		seccategory = seccategory == "" ? 0 : seccategory;
	}
	SEARCH_PARAMS = data;
	document.getElementById("contentFrame").contentWindow.fullItemData(seccategory,publicIdMap[seccategory],data);
}

function onSearchResult() {
    //jQuery(".searchshow").css("display", "block");
    //var iframesrc = "/rdeploy/chatproject/doc/docList.jsp?_" + new Date().getTime() + "=1&searchtype=keyword&doctitle=" + jQuery("#keyword").val() + "&createrid=" + jQuery("#keyword").val() + "&departmentid=" + jQuery("#keyword").val() + "&seccategory=" + //jQuery("#keyword").val();
    //$("#searchFrame").attr("src", iframesrc);
}
function createrFolder() {
	$(window.frames["contentFrame"].document).find("#norecord").remove();
    var d = new Date();
    var times = d.getTime();
    $item = $("<div style='margin-top: 10px;' />");
    $item.attr("id", times + "item");
    $item.addClass("item newFolderItem");
    $itemtitle = $("<div style='margin-top: 8px;'/>");
    $itemtitle.attr("id", times + "itemtitle");
    $itemtitle.addClass("itemtitle");

    $itemico = $("<div />")

    $itemico.addClass("itemico");
    $icoimg = $("<img />");

    $icoimg.attr("src", "/rdeploy/assets/img/cproj/doc/folder.png");

   // $icoimg.click(function() {
   //     contentFrame.window.fullItemData($(this).attr("_dataid"));
   // });
    $itemico.append($icoimg);

    $editname = $("<div />");
    $editname.attr("id", times + "editname");
    $editname.addClass("edit-name");

    $box = $("<input />");
    $box.attr("id", times + "box");
    $box.attr("placeholder", warmFont.createFolder);
    $box.addClass("box");
    $box.attr("type", "text");
	
	
    $sure = $("<span />");
    $sure.attr("title", warmFont.create);
    $sure.attr("id", times + "sure");
    $sure.addClass("sure");

    $cancel = $("<cancel />");
    $cancel.attr("title", warmFont.cancel);
    $cancel.attr("id", times + "cancel");
    $cancel.addClass("cancel");

    
    $editname.append($box).append($sure).append($cancel);

    $item.append($itemico).append($editname);

    $(window.frames["contentFrame"].document).find("#itemsDiv").prepend($item);
	
	$(window.frames["contentFrame"].document).find("#"+times + "box").focus();
	
    $(window.frames["contentFrame"].document).find("#" + times + "cancel").bind("click",
    function() {
    	
	    	var contentbox = $(window.frames["contentFrame"].document).find('div#itemsDiv .item');
				if(contentbox.length <= 1)
				{
					$norecord = $("<div />");
					$norecord.attr("id","norecord");
					$norecord.addClass("norecord");
					$recordpicture = $("<div />");
					$recordpicture.addClass("recordpicture");
					$recordmessage = $("<div />");
					$recordmessage.addClass("recordmessage");
					$recordmessage.append(warmFont.noData);
					$norecord.append($recordpicture).append($recordmessage);
					$(window.frames["contentFrame"].document).find('#itemsDiv').append($norecord); 
				}
	        $("#" + times + "item").remove();
        $(window.frames["contentFrame"].document).find("#" + times + "item").remove();
        disabledOpt(true);
    });

    $(window.frames["contentFrame"].document).find("#" + times + "sure").bind("click",
    function() {
    	var newFolderName = $(window.frames["contentFrame"].document).find("#" + times + "box").val();
    	if(newFolderName == ""){
    		top.Dialog.alert("目录名不能为空!",function(){
    			$(window.frames["contentFrame"].document).find("#" + times + "box").focus();
    		});
    		return;
    	}else if(/[\\/:*?"<>|]/.test(newFolderName)){
    		top.Dialog.alert("目录名不能包含下列字符：<br/>\\/:*?\"<>|",function(){
    			$(window.frames["contentFrame"].document).find("#" + times + "box").focus();
    		});
    		return;
    	}
        jQuery.ajax({
            url: "/rdeploy/chatproject/doc/addSeccategory.jsp",
            type: "post",
	    data : {foldertype : $("#loadFolderType").val(),parentid : $("#fpid").val(),categoryname : newFolderName},
            dataType: "json",
            success: function(data) {
            	var lft = $("#loadFolderType").val();
            	if(lft == "publicAll")
				{
					if(data.exist)
            		{
            			top.Dialog.alert(warmFont.nameExist2Change,function(){
            				$(window.frames["contentFrame"].document).find("#" + times + "box").focus();
            			});
            		}
            		else
            		{
            			$(window.frames["contentFrame"].document).find("#" + times + "item").remove();
            			contentFrame.window.fullFolderItem(data[data.id],'yes');
            		}
            	}
            	else
            	{
            		if(data.exist)
            		{
            			top.Dialog.alert(warmFont.nameExist2Change,function(){
            				$(window.frames["contentFrame"].document).find("#" + times + "box").focus();
            			});
            			
            		}
            		else
            		{
            			$(window.frames["contentFrame"].document).find("#" + times + "item").remove();
            			contentFrame.window.fullPrivateFolderItem(data,'yes');
            			disabledOpt(true);
            		}
            	}
            }
        });
    });
    disabledOpt(true);
}

function fullItemDataLink(sid,loadfoldertype)
{
	$("#loadFolderType").val(loadfoldertype);
	contentFrame.window.loadfoldertype = loadfoldertype;
	if(loadfoldertype == "publicAll")
	{
		$("#publicId").val(sid);
		contentFrame.window.fullItemData(sid,publicIdMap[sid]);
	}
	else
	{
		$("#privateId").val(sid);
		contentFrame.window.fullPrivateItemData(sid,privateIdMap[sid]);
	}
	
}

