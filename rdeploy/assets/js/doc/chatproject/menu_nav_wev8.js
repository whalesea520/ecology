
var dataJson = parent.dataJson;
var privateDataJson = parent.privateDataJson;
var loadfoldertype = $("#loadFolderType", window.parent.document).val();
var mapIds = {};
var SEARCH_PARAMS = {};
var SUBSCRITBE = false;
var pageSize = 1;
var fullfinish = true;
var loadImg = true;
var canLoadScroll = true;
$(function() {
	jQuery("html").mousedown(function (e){
       		parent.$(".hiddensearch").animate({
				height: 0
				}, 200,null,function() {
					parent.jQuery(".hiddensearch").hide();
			}); 
			parent.hideUploadView();
       		parent.jQuery(".opensright").hide();
       		parent.jQuery(".selectstatus").hide();
			parent.jQuery(".sbPerfectBar").hide();
		});
	
   // $("#swfuploadbtn", window.parent.document).hover(function() {
     //  $uploadFileDiv.css("background-color", "#65c3f9");
  //    parent.jQuery("#uploadFileDiv").addClass("btnHover");
  //  },
   // function() {
        try
        {
      //  $uploadFileDiv.css("background-color", "#4ba9df");
      //      parent.jQuery("#uploadFileDiv").removeClass("btnHover");
        }
        catch(Exception)
        {}
    //});
	//$("#dataloading").show();
	//parent.privateIdMap = [];
    if (loadfoldertype == 'publicAll') {
    	if(parent.jQuery("#subDivNav").length > 0){//订阅无权限查看的文档
    		onSubscritbe();
    	}else{
	        fullItemData($("#privateId", window.parent.document).val(),parent.publicIdMap[$("#privateId", window.parent.document).val()],parent.IS_SEARCH ? parent.SEARCH_PARAMS : undefined);
    	}
    } else if(loadfoldertype == 'privateAll'){
        fullPrivateItemData($("#privateId", window.parent.document).val(),parent.privateIdMap[$("#privateId", window.parent.document).val()],parent.IS_SEARCH ? parent.SEARCH_PARAMS : undefined);
    }else if(loadfoldertype == 'myShare'){
    	fullPrivateItemData($("#privateId", window.parent.document).val(),parent.myShareIdMap[$("#privateId", window.parent.document).val()],parent.IS_SEARCH ? parent.SEARCH_PARAMS : undefined);
    }else if(loadfoldertype == 'shareMy'){
    	fullPrivateItemData($("#privateId", window.parent.document).val(),parent.shareMyIdMap[$("#privateId", window.parent.document).val()],parent.IS_SEARCH ? parent.SEARCH_PARAMS : undefined);
    }
	
    function itemHover(curItem) {
        curItem.css("border", "1px solid #F00");
    }
    fullfinish = true;
    
  	//设置滚动加载
  	window.onscroll = function(){
  			//校验数据请求
  			if(canLoadScroll && getCheck()){
  				if(fullfinish)
  				 {
	  				/*** if($("#loadingDiv").length <= 0)
	  				 {
	  				 	$loadingDiv = $("<div />");
	  					$loadingDiv.css("float","left");
	  					$loadingDiv.css("width","94%");
	  					$loadingDiv.css("height","20px");
	  					$loadingDiv.css("line-height","20px");
	  					$loadingDiv.css("text-align","center");
	  					$loadingDiv.attr("id","loadingDiv");
	  					$loadImg = $("<img />");
	  					$loadImg.attr("src","/rdeploy/assets/img/doc/loading.gif");
	  					$loadingDiv.append($loadImg);
	  					$("#itemsDiv").append($loadingDiv);
	  				 }***/
	  				 parent.showLoading();
	  				 if (loadfoldertype == 'publicAll') {
	  				 	ajaxFullDocs(SEARCH_PARAMS);
	  				 }
	  				 else
	  				 {
	  				 	ajaxFullPrivateDocs(SEARCH_PARAMS);
	  				 }
	  			}
  			}
  		}
});

function downImageFile(docid, imageid) {
	if(imageid == '-100')
	{
		jQuery.ajax({
            url: "/rdeploy/chatproject/doc/SetSession.jsp?docid=" + docid,
            type: "post",
            dataType: "json",
            success: function(data) {
            	var dialog = new window.top.Dialog();
		  		dialog.currentWindow = window;
		  		dialog.URL = "/docs/docs/DocAcc.jsp?canDownload=true&language=7&&mode=view&bacthDownloadFlag=0&docid="+docid;
		  		dialog.Title = "附件列表";    //84075:新建目录
				dialog.Width = 1000;
		  		dialog.Height = 400;
		  		dialog.normalDialog = true;
		  		dialog.Drag = true;
				dialog.show();
            }
        });
	}
	else
	{
	    downloadDocImgs(docid, {
	        id: imageid,
	        _window: parent,
	        downloadBatch: 0,
	        emptyMsg: "s"
	    });
	}
}

function delFolder(sid) {
   	top.Dialog.confirm('确定删除此目录吗？',function(){
		if (loadfoldertype == 'publicAll') 
		{
			 jQuery.ajax({
            url: "/rdeploy/chatproject/doc/SecCategoryOperation.jsp?isdialog=1&operation=delete&id=" + sid,
            type: "post",
            dataType: "json",
            success: function(data) {
		            	if(data.error == "87")
		            	{
		            		top.Dialog.alert("此目录包含子目录或文档");
		            	}
		                else
		                {
		                	$("#"+sid+"ItemId").remove();
		                }
		            }
		        });
		}
		else
		{
			 jQuery.ajax({
            url: "/rdeploy/chatproject/doc/PrivateSecCategoryOperation.jsp?categoryid=" + sid,
            type: "post",
            dataType: "json",
            success: function(data) {
		            	if(data.error == "87")
		            	{
		            		top.Dialog.alert("此目录包含子目录或文档");
		            	}
		                else
		                {
		                	$("#"+sid+"ItemId").remove();
		                }
		            }
		        });
		}	      
	},function(){
		return;
	});
}


function doDocDel(docid, sid) {
    var url = "/docs/docs/DocOperate.jsp?operation=delete&docid=" + docid;
    jQuery.ajax({
        url: url,
        type: 'post',
        success: function(data) {
        	var lft = $("#loadFolderType", window.parent.document).val();
        	$("#" + docid + "ItemId").remove();
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



  
  	/**
  	* 瀑布流主函数
  	* @param  contentbox	[Str] 外层元素的ID
  	* @param  box 	[Str] 每一个box的类名
  	*/
  	function waterfall(contentbox,box){
  		//1.获得外层以及每一个box
  		var contentbox = document.getElementById(contentbox);
  		var boxs  = getClass(contentbox,box);
  		//2.获得屏幕可显示的列数
  		var boxW = boxs[0].offsetWidth;
  		var colsNum = Math.floor(document.documentElement.clientWidth/boxW);
  		contentbox.style.width = boxW*colsNum+'px';//为外层赋值宽度
  		//3.循环出所有的box并按照瀑布流排列
  		var everyH = [];//定义一个数组存储每一列的高度
  		for (var i = 0; i < boxs.length; i++) {
  			if(i<colsNum){
  				everyH[i] = boxs[i].offsetHeight;
  			}else{
  				var minH = Math.min.apply(null,everyH);//获得最小的列的高度
  				var minIndex = getIndex(minH,everyH); //获得最小列的索引
  				getStyle(boxs[i],minH,boxs[minIndex].offsetLeft,i);
  				everyH[minIndex] += boxs[i].offsetHeight;//更新最小列的高度
  			}
  		}
  	}
  	/**
  	* 获取类元素
  	* @param  warp		[Obj] 外层
  	* @param  className	[Str] 类名
  	*/
  	function getClass(contentbox,className){
  		var obj = contentbox.getElementsByTagName('*');
  		var arr = [];
  		for(var i=0;i<obj.length;i++){
  			if(obj[i].className == className){
  				arr.push(obj[i]);
  			}
  		}
  		return arr;
  	}
  	/**
  	* 获取最小列的索引
  	* @param  minH	 [Num] 最小高度
  	* @param  everyH [Arr] 所有列高度的数组
  	*/
  	function getIndex(minH,everyH){
  		for(index in everyH){
  			if (everyH[index] == minH ) return index;
  		}
  	}
  	/**
  	* 数据请求检验
  	*/
  	function getCheck(){
  		var documentH = document.documentElement.clientHeight;
  		var scrollH = document.documentElement.scrollTop || document.body.scrollTop;
  		return documentH+scrollH+40 >= getLastH() ?true:false;
  	}
  	/**
  	* 获得最后一个box所在列的高度
  	*/
  	function getLastH(){
  		var contentbox = document.getElementById('itemsDiv');
  		var boxs = getClass(contentbox,'item');
  		if(boxs.length > 0)
  		{
			return boxs[boxs.length-1].offsetTop+boxs[boxs.length-1].offsetHeight;  			
  		}
  		else
  		{
  			return 0;
  		}
  	}
  	/**
  	* 设置加载样式
  	* @param  box 	[obj] 设置的Box
  	* @param  top 	[Num] box的top值
  	* @param  left 	[Num] box的left值
  	* @param  index [Num] box的第几个
  	*/
  	var getStartNum = 0;//设置请求加载的条数的位置
  	function getStyle(box,top,left,index){
  	    if (getStartNum>=index) return;
  	    $(box).css({
  	    	'position':'absolute',
  	        'top':top,
  	        "left":left,
  	        "opacity":"0"
  	    });
  	    $(box).stop().animate({
  	        "opacity":"1"
  	    },999);
  	    getStartNum = index;//更新请求数据的条数位置
  	}


function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width - 10;
  var height = screen.height - 100;
  var szFeatures = "top=0," ; 
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}


function getStrWidth(str,fontSize)
{
    var span = document.getElementById("__getwidth");
    if (span == null) {
        span = document.createElement("span");
        span.id = "__getwidth";
        document.body.appendChild(span);
        span.style.visibility = "hidden";
        span.style.whiteSpace = "nowrap";
    }
    span.innerText = str;
    span.style.fontSize = fontSize + "px";
    return span.offsetWidth;
}
