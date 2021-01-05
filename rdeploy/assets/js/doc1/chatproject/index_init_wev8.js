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

    jQuery(".searchspan").on("click",
    function() {
        onSearchResult();
    });

    jQuery(".closesearch").on("click",
    function() {
        jQuery(".searchshow").css("display", "none");
    });

    jQuery(".adspan").on("click",
    function() {
        advancedSearch();
    });

    $("#doctitle")[0].focus();
    __jNiceNamespace__.beautySelect();

    $("span[id^=sbHolderSpan_]").css("max-width", "95%");

    $("#date").daterangepicker({
        separator: " - "
    },
    function(start, end, label) {
        $("#createdatefrom").val(start);
        $("#createdateto").val(end);
    });

   

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
		
		
	$("#cancelAllDiv").bind("click",function (){
	uploadfinish = true;
		$("#fsUploadProgressannexupload > div").each(function(){
			var errorMes = $('#'+$(this).attr('id')+'progressError').text();
          	// 上传失败，直接移除元素
          	if (errorMes != null && errorMes != "")
          	{
	          	$(this).fadeOut("slow");
          	}
          	else
          	{
          		if($("#"+$(this).attr('id')+"docid").val() != null && $("#"+$(this).attr('id')+"docid").val() != "")
          		{
          			var docId = $("#"+$(this).attr('id')+"docid").val();
          			jQuery.ajax({
					type: "POST",
					url: "/rdeploy/doc/DelDocInfo.jsp",
					data: {docId:docId},
					cache: false,
					async:false,
					dataType: 'json',
					success: function(msg){
					}
					});
					$(this).fadeOut("slow");
					contentFrame.window.$("#"+docId+"ItemId").fadeOut("slow");
          		}
          		else
          		{
	          		oUploadannexupload.cancelUpload($(this).attr('id'), false);
	          		$(this).fadeOut("slow");
          		}	
          	}
		});
		$("#uptitle").empty();
		$("#uptitle").append("全部取消完成");
		$("#sp").hide();
		$("#suCount").empty();
		$("#count").empty();
		$("#uploadDialogBody").slideToggle();
			$("#cancelAllDiv").slideToggle();
	});
		
		
});

        function upFolder(){
			var sid;
			publicIds = new Array();
			privateIds = new Array();
			if($("#loadFolderType").val() == "publicAll")
			{
				var itemData = dataJson[$("#fpid").val()];
				sid = itemData.pid;
				while(itemData.sid != 0)
				{
					publicIds.unshift(itemData.sid);
					itemData = dataJson[itemData.pid]
				}
				publicIds.unshift('0');
			}
			else
			{
				var itemData = privateDataJson[$("#fpid").val()];
				if(privateDataJson[itemData.pid].pid == userLoginId)
				{
					sid = "privateAll";
				}
				else
				{
					sid = itemData.pid;
					if(sid == userLoginId)
					{
						sid = "privateAll";
					}
				}
				while(itemData.sname != userLoginId)
				{
					privateIds.unshift(itemData.sid);
					itemData = privateDataJson[itemData.pid]
				}
				privateIds.unshift("privateAll");
			}
			contentFrame.window.fullItemData(sid);
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
    jQuery(".searchshow").css("display", "block");
    var doctitle = jQuery("input[name=doctitle]").val();
    var createrid = jQuery("input[name=createrid]").val();
    var departmentid = jQuery("input[name=departmentid]").val();
    var seccategory = jQuery("input[name=seccategory]").val();
    var createdatefrom = jQuery("input[name=createdatefrom]").val();
    var createdateto = jQuery("input[name=createdateto]").val();
    var iframesrc = "/rdeploy/chatproject/doc/docList.jsp?_" + new Date().getTime() + "=1&searchtype=adv&doctitle=" + doctitle + "&createrid=" + createrid + "&departmentid=" + departmentid + "&seccategory=" + seccategory + "&createdatefrom=" + createdatefrom + "&createdateto=" + createdateto;
    $("#searchFrame").attr("src", iframesrc);
}

function onSearchResult() {
    jQuery(".searchshow").css("display", "block");
    var iframesrc = "/rdeploy/chatproject/doc/docList.jsp?_" + new Date().getTime() + "=1&searchtype=keyword&doctitle=" + jQuery("#keyword").val() + "&createrid=" + jQuery("#keyword").val() + "&departmentid=" + jQuery("#keyword").val() + "&seccategory=" + jQuery("#keyword").val();
    $("#searchFrame").attr("src", iframesrc);
}
function createrFolder() {
    var d = new Date();
    var times = d.getTime();
    $item = $("<div style='margin-top: 10px;' />");
    $item.attr("id", times + "item");
    $item.addClass("item");
    $itemtitle = $("<div style='margin-top: 8px;'/>");
    $itemtitle.attr("id", times + "itemtitle");
    $itemtitle.addClass("itemtitle");

    $itemico = $("<div />")

    $itemico.addClass("itemico");
    $icoimg = $("<img />");

    $icoimg.attr("src", "/rdeploy/assets/img/cproj/doc/folder.png");

    $icoimg.click(function() {
        contentFrame.window.fullItemData($(this).attr("_dataid"));
    });
    $itemico.append($icoimg);

    $editname = $("<div />");
    $editname.attr("id", times + "editname");
    $editname.addClass("edit-name");

    $box = $("<input />");
    $box.attr("id", times + "box");
    $box.attr("placeholder", "新建文件夹");
    $box.addClass("box");
    $box.attr("type", "text");

    $sure = $("<span />");
    $sure.attr("id", times + "sure");
    $sure.addClass("sure");

    $cancel = $("<cancel />");
    $cancel.attr("id", times + "cancel");
    $cancel.addClass("cancel");

    $("#" + times + "cancel").bind("click",
    function() {
        $("#" + times + "item").remove();
    });

    $editname.append($box).append($sure).append($cancel);

    $item.append($itemico).append($editname);

    $(window.frames["contentFrame"].document).find("#itemsDiv").prepend($item);

    $(window.frames["contentFrame"].document).find("#" + times + "cancel").bind("click",
    function() {
        $(window.frames["contentFrame"].document).find("#" + times + "item").remove();
    });

    $(window.frames["contentFrame"].document).find("#" + times + "sure").bind("click",
    function() {
        jQuery.ajax({
            url: "/rdeploy/chatproject/doc/addSeccategory.jsp?foldertype=" + $("#loadFolderType").val() + "&parentid=" + $("#fpid").val() + "&categoryname=" + $(window.frames["contentFrame"].document).find("#" + times + "box").val(),
            type: "post",
            dataType: "json",
            success: function(data) {
                var id = data.id;
                if ($("#loadFolderType").val() == 'publicAll') {
                    dataJson[data[id].pid].childrenFolders.push(data[id]);
                    dataJson[data.id] = data[id];
                } else {
                    privateDataJson[data[id].pid].childrenFolders.push(data[id]);
                    privateDataJson[data.id] = data[id];
                }
				contentFrame.window.fullItemData($("#fpid").val());
				/**
                $(window.frames["contentFrame"].document).find("#" + times + "editname").remove();
8813-E823-4240-7B52
                $item.attr('id', id + "ItemId");
                $(window.frames["contentFrame"].document).find("#" + times + "itemtitle").attr('id', id + "ItemTitleId");
                $itemDel.attr('id', id + "ItemDelId");
                $itemico.attr('id', id + "ItemIcoId");
                $icoimg.attr('id', id + "ItemIcoimgId");

                //$(window.frames["contentFrame"].document).find("#"+id+"ItemTitleId").attr("title",data[id].sname);
                //$(window.frames["contentFrame"].document).find("#"+id+"ItemTitleId").append("222222222222222222222222");
                $itemtitle.append(data[id].sname);

                $icoimg.attr("title", data[id].sname);
                $icoimg.attr("_dataid", id);

                $delA.click(function() {
                    jQuery.ajax({
                        url: "/rdeploy/chatproject/doc/SecCategoryOperation.jsp?isdialog=1&operation=delete&id=" + id,
                        type: "post",
                        success: function(data) {
                            if ($("#loadFolderType").val() == 'publicAll') {
                                $.each(dataJson[dataJson[id].pid].childrenFolders,
                                function(lid, category) {
                                    if (category.sid == id) {
                                        dataJson[dataJson[id].pid].childrenFolders.splice(lid, 1);
                                        delete dataJson[id];
                                        return false;
                                    }
                                });
                            } else {
                                $.each(privateDataJson[privateDataJson[id].pid].childrenFolders,
                                function(lid, category) {
                                    if (category.sid == id) {
                                        privateDataJson[privateDataJson[id].pid].childrenFolders.splice(lid, 1);
                                        delete privateDataJson[id];
                                        return false;
                                    }
                                });
                            }
                        }
                    });
                    $item.remove();
                });
                $item.append($itemico).append($itemtitle).append($itemDel);

                $item.hover(function() {
                    $item.css('border', '1px solid #e4e4e4');
                    $itemDel.show();
                    $itemtitle.hide();
                },
                function() {
                    $item.css('border', '1px solid #fff');
                    $itemDel.hide();
                    $itemtitle.show();
                });
                */
            }
        });
    });
}

function fullItemDataLink(sid,loadfoldertype)
{
	$("#loadFolderType").val(loadfoldertype);
	$("#fpid").val(sid);
	publicIds = new Array();
	privateIds = new Array();
	if(loadfoldertype == "publicAll")
	{
		var itemData = dataJson[sid];
		while(itemData.sid != 0)
		{
			publicIds.unshift(itemData.sid);
			itemData = dataJson[itemData.pid]
		}
		publicIds.unshift('0');
	}
	else
	{
		if(sid != "privateAll")
		{
			var itemData = privateDataJson[sid];
			while(itemData.sname != userLoginId)
			{
				privateIds.unshift(itemData.sid);
				itemData = privateDataJson[itemData.pid]
			}
		}
		privateIds.unshift("privateAll");
	}
	contentFrame.window.fullItemData(sid);
}

