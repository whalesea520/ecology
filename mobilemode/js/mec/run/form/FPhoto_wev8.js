Mobile_NS.FPhoto = {};

var isUseFile = 1;//是否是使用input file标签
Mobile_NS.FPhoto.onload = function(p){
	var that = this;
	var mecid = p["id"];
	isUseFile = 1;
	if(_top && typeof(_top.isRunInEmobile) == "function" && _top.isRunInEmobile()){	
		$("#file"+mecid).remove();
		$("#entryBtn"+mecid).click(function(e){
			var params = JSON.stringify(p).replace(/:/g, '=>');
			var photoType = p["photoType"] || 1;
			if(photoType == "2"){//仅拍照
				_p_addPhoto(e, params, 1);
			}else if(photoType == "3"){//仅选择照片
				_p_addPhoto(e, params, 2);
			}else{
				var menuText = p["menuText"].split(",");
				var menu = [
						{id : "a", menuText : menuText[0], icon : "/mobilemode/images/mec/photograph_wev8.png", callback : function(){_p_addPhoto(e, params, 1);}},
						{id : "d", menuText : menuText[1], icon : "/mobilemode/images/mec/photochoose_wev8.png", callback : function(){_p_addPhoto(e, params, 2);}},
					];
				_top.addDialogCover(menu);
			}
			
			e.stopPropagation();
		});
	}else if((_top && _top.eb_chooseImage) || (typeof(eb_chooseImage) == "function")){
		$("#file"+mecid).remove();
		$("#entryBtn"+mecid).click(function(e){

			var params = JSON.stringify(p).replace(/:/g, '=>');
			var photoType = p["photoType"] || 0;
			photoType = eval(photoType) - 1;//微信1:拍照 2:相册
			_p_uploadWxImage(photoType,params);
			e.stopPropagation();
		});
		
	}else{
		isUseFile = 0;
		var file = document.getElementById("file"+mecid);
		if(file != null){
			file.onchange = function(){
				that.preview(p);
			};
		}
	}
	
};

function _p_uploadWxImage(ptype,params){
	if(_top && typeof(_top.registMPCWindow) == "function"){
		_top.registMPCWindow(window);
	}

	if(_top && _top.eb_Scan){
		_top.eb_chooseImage(ptype,"_p_addPhoto_uploaded",params);
	}else if(typeof(eb_Scan) == "function"){
		eb_chooseImage(ptype,"_p_addPhoto_uploaded",params);
	}
};


function _p_addPhoto(e, params, type){
	if(_top && typeof(_top.registMPCWindow) == "function"){
		_top.registMPCWindow(window);
	}
	if(type == 1){
		location = "emobile:photograph:_p_addPhoto_uploaded:"+params+":"+e.clientY+":_p_addPhoto_clear";
	}else if(type == 2){
		location = "emobile:photochoose:_p_addPhoto_uploaded:"+params+":"+e.clientY+":_p_addPhoto_clear";
	}
}

function _p_addPhoto_uploaded(imgtype,data,params){
	try{
		if(typeof(params) == "undefined"){//此处处理云桥回调，方法名重名，参数1-imgtype对应图片base64，参数2-data对应params
			var mecObj = JSON.parse(decodeURIComponent(data).replace(/=>/g, ':'));
			if(!!imgtype){
				var base64PicData = "data:image/jpeg;base64,"+imgtype;
				Mobile_NS.FPhoto.picHandler(base64PicData, mecObj);
			}
		}else{//emobile回调
			var mecObj = JSON.parse(decodeURIComponent(params).replace(/=>/g, ':'));
			if(!!data){
				var base64PicData = "data:image/jpeg;base64,"+data;
				Mobile_NS.FPhoto.picHandler(base64PicData, mecObj);
			}
		}
		
	}catch(e){
		alert("拍照插件异常 >> " + e.message);
	}
}
function delFphoto(obj, mecid, docid){
	var $this = $(obj);
	
	var $field = $("#photoField"+mecid);
	var fieldValue = $field.val();
	
	var tmpArr = fieldValue.split(";;");
	var newValue = "";
	for(var i = 0; i < tmpArr.length; i++){
		var oneValue = tmpArr[i];
		if(oneValue.indexOf("base64") == -1){	//id
			oneValue = oneValue.replace(docid+",","");
			oneValue = oneValue.replace(","+docid,"");
			oneValue = oneValue.replace(docid,"");
		}else if(oneValue == docid){ //base64
			continue;
		}
		
		if(i == 0){
			newValue = oneValue;
		}else{
			newValue = newValue + ";;" + oneValue;
		}
	}
	$field[0].value = newValue;
	
	$this.parent().remove();
}

Mobile_NS.FPhoto.preview = function(p){
	var that = this;
	var mecid = p["id"];
	
	var file = document.getElementById("file"+mecid);
	if(file.files && file.files[0]){
		var reader = new FileReader();
	   	reader.onload = function(evt){
	   		var result = evt.target.result;
	   		that.picHandler(result, p);
	   	}
	   	reader.readAsDataURL(file.files[0]);
	}
};

Mobile_NS.FPhoto.picHandler = function(picData, p){
	var that = this;
	function createInner(imgData){
		var isCompress = p["isCompress"] || "1";
      	if(isCompress == "1"){	//压缩
      		var quality = p["quality"] || "0.5";
      		if(quality == "" || isNaN(quality)){
      			quality = 1;
      		}else{
      			quality = parseFloat(quality);
      			if(quality < 0 || quality > 1){
      				quality = 1;
      			}
      		}
      		var zoom = p["zoom"] || "0.5";
      		if(zoom == "" || isNaN(zoom)){
      			zoom = 1;
      		}else{
      			zoom = parseFloat(zoom);
      			if(zoom < 0 || zoom > 1){
      				zoom = 1;
      			}
      		}
      		that.scaleImgData(imgData, quality, zoom, true, function(newResult){
            	that.createAPic(p, newResult);
            });
      	}else{
      		that.createAPic(p, imgData);
      	}
	}
	
	var isDrawing = p["isDrawing"];
	if(isDrawing == "1"){
		var tImg = new Image();
		tImg.onload = function(){
			//naturalWidth真实图片的宽度
			var w = tImg.naturalWidth;
			var h = tImg.naturalHeight;
			ImgDrawing.draw({
				data : picData,
				width: w,
				height: h,
				callback : {
					done : function(base64Data){
						//draw done
						createInner(base64Data);
					}
				}
			});
		};
		tImg.src = picData;
	}else{
		createInner(picData);
	}
}

Mobile_NS.FPhoto.createAPic = function(p, pic64){
	var that = this;
	var mecid = p["id"];
	var $field = $("#photoField"+mecid);
	
	var $file = $("#file"+mecid);
	$file.remove();
	var $entryImg = $("<div class=\"Design_FPhoto_Entry\"><img src=\"\"></img></div>");
	var $entryDelete = $("<div class=\"Design_FPhoto_DeleteBtn\" onclick=\"delFphoto(this, '"+mecid+"', '"+pic64+"');\"></div>");
	var $entryBorder = $("<div class=\"Design_FPhoto_EntryBorder\"></div>");
	$entryBorder.append($entryImg).append($entryDelete);
	$("#photoBorder"+mecid).before($entryBorder);
	
	setTimeout(function(){
		$("img", $entryImg).attr("src", pic64);
		$entryImg.css("background", "none");
	}, 100);
	
	var fieldValue = $field.val();
	if(fieldValue == ""){
		fieldValue = pic64;
	}else{
		fieldValue = fieldValue + ";;" + pic64;
	}
	$field[0].value = fieldValue;
	
	if(isUseFile == 0){
		var $originalFile = $("<input id=\"file"+mecid+"\" type=\"file\" name=\"file\" fileNum=\"0\" class=\"upLoadFile\" accept=\"image/*\" single=\"single\"  onchange=\"preview('"+mecid+"');\" data-role=\"none\"/>");
		$originalFile[0].onchange = function(){
			that.preview(p);
		};
		$("#entryBtn"+mecid).append($originalFile);
	}
	refreshIScroll();
};

Mobile_NS.FPhoto.scaleImgData = function(imgData, quality, zoom, alsoUseJpeg, callbackFn){

	var mime_type = "image/jpeg";
	if(imgData && !alsoUseJpeg){
		var st = imgData.indexOf("data:");
     	var en = imgData.indexOf(";");
     	if(st == 0 && en > st){
     		try{
     			mime_type = imgData.substring("data:".length, en);
     		}catch(e){
     			mime_type = "image/jpeg";
     		}
		}
	}
     
	var tImg = new Image();
	tImg.onload = function(){
		var cvs = document.createElement('canvas');
		//naturalWidth真实图片的宽度
		var w = tImg.naturalWidth;
		var h = tImg.naturalHeight;
		
		var imageWidth = parseInt(w * zoom);
        var imageHeight = parseInt(h * zoom);
                        
		cvs.width = imageWidth;
		cvs.height = imageHeight;
		
		var con = cvs.getContext('2d');
		con.clearRect(0,0,cvs.width,cvs.height);
		con.drawImage(tImg,0,0,imageWidth,imageHeight);
                    
		//var ctx = com.drawImage(tImg, 0, 0);
		var newImageData = cvs.toDataURL(mime_type, quality);
		callbackFn.call(this, newImageData);
	};
	tImg.src = imgData;
};