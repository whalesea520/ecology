jQuery.fn.fancyZoom = function(options){
  
  var options   = options || {};
  var directory = options && options.directory ? options.directory : 'images';
  var zooming   = false;

  if ($('#zoom').length == 0) {
    var html = '<div class="round_shade_box" id="zoom" > \
					<div class="round_shade_top"> \
						<span class="round_shade_topleft"> \</span> \
						<span class="round_shade_topright"> \</span> \
					</div> \
					<div class="round_shade_centerleft"> \
						<div class="round_shade_centerright"> \
    						<div class="round_shade_both" id="zoom_both"></div>\
							<div class="round_shade_center" id="zoom_content"> \  <div class="round_shade_center1" id="zoom_content1"> \</div> \</div> \
						</div> \
					</div> \
					<div class="round_shade_bottom"> \
						<span class="round_shade_bottomleft"> \</span> \
						<span class="round_shade_bottomright"> \</span> \
					</div> \
					<a href="#close" class="round_box_close" id="zoom_close" title="关闭"></a> \
					<a class="round_box_right" href="#" id="zoom_right" title="向右转"></a> \
					<a class="round_box_left" href="#" id="zoom_left" title="向左转"></a> \
			    	<a class="round_box_add" href="#" id="zoom_add" title="放大"></a> \
			    	<a class="round_box_minus" href="#" id="zoom_minus" title="缩小"></a> \
    				<a class="round_box_1" href="#" id="zoom_1" title="1:1"></a> \
			    	<a class="zoom_save" href="#" id="zoom_save" title="保存"></a> \
				</div>';
                
    //$('body').append(html);
    parent.jQuery('body').append(html);
    //$('html').click(function(e){if($(e.target).parents('#zoom:visible').length == 0) hide();});
    parent.jQuery('html').click(function(e){if($(e.target).parents('#zoom:visible').length == 0) hide();});
    parent.jQuery(document).keyup(function(event){
        if (event.keyCode == 27 && parent.jQuery('#zoom:visible').length > 0) hide();
    });
    
    parent.jQuery('#zoom_close').click(hide);
  }
  
  var zoom          = parent.$('#zoom');
  var zoom_close    = parent.$('#zoom_close');
  var zoom_content  = parent.$('#zoom_content');
  var zoom_content1  = parent.$('#zoom_content1');
  var zoom_left = parent.$('#zoom_left');
  var zoom_right = parent.$('#zoom_right');
  var zoom_add = parent.$('#zoom_add');
  var zoom_minus = parent.$('#zoom_minus');
  var zoom_1 = parent.$('#zoom_1');
  var zoom_save = parent.$('#zoom_save');
  

  this.each(function(i) {
    $($(this).attr('pichref')).hide();
    $(this).click(show);
  });
  
  return this;
  
  function show(e) {
    if (zooming) return false;
		zooming         = true;
		//var content_div = $($(this).attr('href'));
		//var hrefvalue = $(this).attr('href');
		//var hrefhtml = e.find(hrefvalue).html();
		var hrefhtml = options.iframenames.html();
		var content_w = options.iframenames.width();
		var content_h = options.iframenames.height();
		var savesrc = jQuery(hrefhtml).attr("src");//文件保存路径
		tempWidth = content_w;
		tempHeight = content_h;
		
		var content_div_w = content_w;
		var content_div_h = content_h;
		var iframeWidth= (jQuery("iframe[name^=FCKsigniframe]").width())*0.9;
		
		//var content_w = options.iframenames.parent().parent().find(hrefvalue).width();
		//var content_h = options.iframenames.parent().parent().find(hrefvalue).height();
  		var zoom_width  = options.width;
		var zoom_height = options.height;
		var width       = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
		var height      = window.innerHeight || (window.document.documentElement.clientHeight || window.document.body.clientHeight);
		var x           = window.pageXOffset || (window.document.documentElement.scrollLeft || window.document.body.scrollLeft);
		var y           = window.pageYOffset || (window.document.documentElement.scrollTop || window.document.body.scrollTop);
		var window_size = {'width':width, 'height':height, 'x':x, 'y':y}
		
		if(iframeWidth > content_w){
			content_div_w = iframeWidth;
		}
		
		if(content_w > width*0.9){
			content_div_w = width*0.9;
		}
		//var line_div_h 
		
		if(270 > content_h){
			content_div_h = 300;
		}
		if(content_h > height*0.9){
			content_div_h = height*0.9;
		}
		
		//var width              = (zoom_width || content_w) + 40;
		//var height             = (zoom_height || content_h) + 40;
		var width              = content_w + 40;
		var height             = content_h + 40;
		var d                  = window_size;
		// ensure that newTop is at least 0 so it doesn't hide close button
		var newTop             = Math.max((d.height/2) - (height/2) + y-300, 0);
		var newLeft            = (d.width/2) - (width/2);
		var newTop_div             = Math.max((d.height/2) - (content_div_h/2), 0);
		
		//alert(d.height/2);
		//alert(content_div_h/2);
		//alert(y);
		var newLeft_div            = (d.width/2) - (content_div_w/2)-20;
		
		var imgtop = 0;
		var imgleft = 0;
		if(iframeWidth > content_w){
			imgleft = (iframeWidth-content_w)/2;
		}
		
		if(content_h < height*0.9){
			imgtop = (content_div_h - content_h)/2 + 30;
		}else{
			imgtop = 30;
		}
		//var curTop             = e.pageY;
		//var curLeft            = e.pageX;
		var curTop             = content_h;
		var curLeft            = e.pageX+100;
		
		zoom_close.attr('curTop', curTop);
		zoom_close.attr('curLeft', curLeft);
		zoom_close.attr('scaleImg', options.scaleImg ? 'true' : 'false');
		
		zoom_left.attr('curTop', curTop);
		zoom_left.attr('curLeft', curLeft-50);
		
		zoom_right.attr('curTop', curTop);
		zoom_right.attr('curLeft', curLeft+50);
		
		parent.jQuery('#zoom').hide().css({
			position	: 'absolute',
			top				: curTop + 'px',
			left			: curLeft + 'px',
			width     : '1px',
			height    : '1px'
		});
    
    if (options.closeOnClick) {
    	parent.jQuery('#zoom').click(hide);
    }
    
    divWidth = content_div_w;
    divHeight = content_div_h;
	if (options.scaleImg) {
		//zoom_content.html(content_div.html());
		//zoom_content.html(hrefhtml);
		zoom_content1.html(hrefhtml);
		parent.jQuery("#zoom_content").css({"width":content_div_w,"height":content_div_h+10,"text-align":"center","vertical-align":"middle","z-index":"9999"});
		//if(navigator.userAgent.indexOf('MSIE') >= 0) {
			//parent.jQuery("#zoom_content1").css({"left":imgleft,"top":imgtop,"text-align":"center","vertical-align":"middle","overflow":"hidden","position":"absolute","z-index":"9999"});
		//}else{
			parent.jQuery("#zoom_content1").css({"width":content_div_w,"height":content_div_h,"display":"table-cell","text-align":"center","vertical-align":"middle","z-index":"9999"});
		//}
		parent.jQuery("#zoom_content").find("img").css({"z-index":"9999","vertical-align":"middle"});
		//parent.jQuery('#zoom_content').perfectScrollbar();
	} else {
		  zoom_content.html('');
	}
	
	parent.jQuery("#zoom_content").find("img").unbind('mousedown').bind("mousedown",function(e){
		// 拖拽
		initDrag(e);
	});
	
	
	parent.jQuery("#zoom_content").find("img").unbind('mouseup').bind("mouseup",function(e){
		// 拖拽释放
		release();
	});
	
	parent.jQuery("#zoom_both").unbind('mousedown').bind("mousedown",function(e){
		// 拖拽
		initDrag(e);
	});
	
	
	parent.jQuery("#zoom_both").unbind('mouseup').bind("mouseup",function(e){
		// 拖拽释放
		release();
	});
	
	zoom_right.unbind('click').bind('click',function(e){
		// 右旋转
		var target = zoom.find('.maxImg');
		_rotate(target,'right', width);
	});
	zoom_left.unbind('click').bind('click',function(e){
		// 左旋转
		var target = zoom.find('.maxImg');
		_rotate(target,'left', width);
	});
	zoom_1.unbind('click').bind('click',function(e){
		// 1:1
		var target = zoom.find('.maxImg');
		imgToOldSize(target,content_w,content_h);
	});
	zoom_add.unbind('click').bind('click',function(e){
		// 放大
		var target = zoom.find('.maxImg');
		imgToSize(target,'add',content_w,content_h);
	});
	zoom_minus.unbind('click').bind('click',function(e){
		// 缩小
		var target = zoom.find('.maxImg');
		imgToSize(target,'minus',content_w,content_h);
	});
	zoom_save.unbind('click').bind('click',function(e){
		// 保存
		downloads_sf(savesrc);
	});
    
	//parent.jQuery("#backdiv").css("display","block");
	
	parent.jQuery('#zoom').animate({
      top     : newTop_div + 'px',
      left    : newLeft_div + 'px',
      opacity : "show",
      width   : content_div_w+50,
      height  : content_div_h+40
    }, 0, null, function() {
      if (options.scaleImg != true) {
    		//zoom_content.html(content_div.html());
    		//zoom_content.html(hrefhtml);
    		zoom_content1.html(hrefhtml);
  		}
			zoom_close.show();
			zoom_left.show();
			zoom_right.show();
			zooming = false;
    })
    return false;
  }
  
  //隐藏
  function hide() {
    if (zooming) return false;
		zooming         = true;
		parent.jQuery("#backdiv").css("display","none");
		parent.jQuery('#zoom').unbind('click');
		if (zoom_close.attr('scaleImg') != 'true') {
  		//zoom_content.html('');
  		zoom_content1.html(hrefhtml);
		}
		zoom_close.hide();
		parent.jQuery('#zoom').animate({
		  top     : zoom_close.attr('curTop') + 'px',
		  left    : zoom_close.attr('curLeft') + 'px',
		  opacity : "hide",
		  width   : '1px',
		  height  : '1px'
		}, 0, null, function() {
		destory();
		  if (zoom_close.attr('scaleImg') == 'true') {
				//zoom_content.html('');
				zoom_content1.html('');
			}
				zooming = false;
		});
		return false;
	}
}
/*
 * 图片旋转
 * @param {target,direction,width} 要旋转的元素，方向, 旋转元素的宽度
 */
this.cache = {
	minStep   :  0,
	maxStep   :  3
};

/*
 * 图片旋转
 */
var tempWidth,tempHeight;//图片实际宽高
var divWidth,divHeight;//图片外层div宽高
function _rotate(target,direction,width){
	var self = this,
		cache = self.cache;

	var img = $(target)[0],
		step = img.getAttribute('step');
	if(img.length <= 0) {
		return;
	}
	if (step == null) {
		step = cache.minStep;
	}
	//显示器宽度
	//var screenwidth = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
	
	//图片宽高
	var width = img.width,
		height = img.height;
	if(direction == 'left') {
		step--;
		if(step < cache.minStep) {
			step = cache.maxStep;
		}
	}else if(direction == 'right') {
		step++;
		if(step > cache.maxStep) {
			step = cache.minStep;
		}
	}
	img.setAttribute('step', step);
	// IE
	if(navigator.userAgent.indexOf('MSIE') >= 0) {
		var s = $(img).attr('step');
		//img.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + s + ')';
		///////
		if (typeof(FileReader) !== "undefined") {
			s = parseInt(s) + 1;
			switch(s){
				case 1: img.style.cssText = "-webkit-transform: rotate(0deg);-moz-transform: rotate(0deg);transform:rotate(0deg);-o-transform:rotate(0deg);";
				break;                
				case 2: img.style.cssText = "-webkit-transform: rotate(90deg);-moz-transform: rotate(90deg);transform:rotate(90deg);-o-transform:rotate(90deg);"; 
				break;                
				case 3: img.style.cssText = "-webkit-transform: rotate(180deg);-moz-transform: rotate(180deg);transform:rotate(180deg);-o-transform:rotate(180deg);"; 
				break;                
				case 4: img.style.cssText = "-webkit-transform: rotate(270deg);-moz-transform: rotate(270deg);transform:rotate(270deg);-o-transform:rotate(270deg);"; 
				break;            
			}
		}else{
			//var ieverson__ = jQuery("#ieverson").val();
			var ieversonnew = document.documentMode;
			if(ieversonnew > 8){//兼容IE8及以下版本
				s = parseInt(s) + 1;
					switch(s){
						case 1: img.style.cssText = "-ms-transform: rotate(0deg);-ms-transform-origin:50% 50%;";
						break;                
						case 2: img.style.cssText = "-ms-transform: rotate(90deg);-ms-transform-origin:50% 50%;"; 
						break;                
						case 3: img.style.cssText = "-ms-transform: rotate(180deg);-ms-transform-origin:50% 50%;"; 
						break;                
						case 4: img.style.cssText = "-ms-transform: rotate(270deg);-ms-transform-origin:50% 50%;"; 
						break;            
				}
			}else{
				var angle = 90*s;
				var scale = 1;
				var rad = angle * (Math.PI / 180);
				var m11 = Math.cos(rad) * scale, 
				m12 = -1 * Math.sin(rad) * scale, 
				m21 = Math.sin(rad) * scale, 
				m22 = m11;
				//transform-origin:50% 5px; -ms-transform: rotate(0deg); /* IE 9 */-ms-transform-origin:50% 50%; /* IE 9 */
				img.style.filter = "progid:DXImageTransform.Microsoft.Matrix(M11="+ m11 +",M12="+ m12 +",M21="+ m21 +",M22="+ m22 +",SizingMethod='auto expand')";
			}
		}
		////
		img.width = width;
		img.height = height;
		/////
		//var inwidth = parent.jQuery("#zoom_content").width();
		//var inheight = parent.jQuery("#zoom_content").height();
		/////
		var middlewidth = tempWidth;
		var middleheight = tempHeight;
		//if(s == 1 || s == 3){
			if(divWidth > tempHeight ){
				width = divWidth;
			}else{
				width = tempHeight;
			}
			if(divHeight > tempWidth){
				height = divHeight;
			}else{
				height = tempWidth;
			}
		//}
		/*else{
			if(divWidth > tempWidth){
				width = divWidth;
			}else{
				width = tempWidth;
			}
			if(divHeight > tempHeight){
				height = divHeight;
			}else{
				height = tempHeight;
			}
		}*/
		tempWidth = middleheight
		tempHeight = middlewidth;
		
		//img.style.top = ( this._clientHeight - img.offsetHeight ) / 2 + "px";
		//img.style.left = ( this._clientWidth - img.offsetWidth ) / 2 + "px";
		//parent.jQuery("#zoom_content1").css("cssText","width:"+width+"px!important;height:"+height+"px!important;display:table-cell;text-align:center;vertical-align:middle;z-index:9999");
		parent.jQuery("#zoom_content1").css({"width":width,"height":height,"display":"table-cell","text-align":"center","vertical-align":"middle","z-index":"9999"});
		//parent.jQuery("#zoom_content1").css({"width":width,"height":height,"display":"table-cell","text-align":"center","vertical-align":"middle","z-index":"9999"});
	}else {  // 对于现代浏览器 使用canvas
		 var canvas = $(img).next('canvas')[0];
		if ($(img).next('canvas').length == 0) {
			img.style.display = 'none';
			canvas = document.createElement('canvas');
			canvas.setAttribute('class', 'canvas');
			img.parentNode.appendChild(canvas);
		}
		//旋转角度以弧度值为参数
		var degree = step * 90 * Math.PI / 180;
		var ctx = canvas.getContext('2d');
		switch (step) {
			case 0:
				canvas.width = width;
				canvas.height = height;
				ctx.drawImage(img, 0, 0,width, height);
				break;
			case 1:
				canvas.width = height;
				canvas.height = width;
				ctx.rotate(degree);
				ctx.drawImage(img, 0, -height,width, height);
				break;
			case 2:
				canvas.width = width;
				canvas.height = height;
				ctx.rotate(degree);
				ctx.drawImage(img, -width, -height,width, height);
				break;
			case 3:
				canvas.width = height;
				canvas.height = width;
				ctx.rotate(degree);
				ctx.drawImage(img, -width, 0,width, height);
				break;
		}
	}
	$(target).attr("step",cache.step);
	//self.callback && $.isFunction(self.callback) && self.callback(cache.step);
}

drag = 0
move = 0

// 拖拽对象
// 参见：http://blog.sina.com.cn/u/4702ecbe010007pe
var ie=document.all;
var nn6=document.getElementById&&!document.all;
var isdrag=false;
var y,x;
var oDragObj;

/*
 * 销毁
 */
function destory(){
	
		//cfg = self.options;
	//var curParent = $this.closest(cfg.parentCls),
		var canvas = parent.jQuery('.canvas'),
		maxImg = parent.jQuery('.maxImg');
		indexi = 0;
	if(navigator.userAgent.indexOf('MSIE') >= 0) {
		// IE
		//parent.jQuery(maxImg)[0].style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=0)';
		parent.jQuery(maxImg).attr('step',0);
	}else{
		if(canvas.length > 0) {
			canvas.remove();
			//maxImg.show();
			//$(maxImg).attr("step",1);
		}
	}
}

/*
 * 图片按10%缩放
 */
var indexi = 0;
function imgToSize(target,obj,hWidth,hHeight) {
	var self = this,
	cache = self.cache;

	var img = $(target)[0],
	step = img.getAttribute('step');
	if (step == null) {
		step = cache.minStep;
	}
	step = parseInt(step);
	var oWidth = img.width,//取得图片的实际宽度
	oHeight = img.height;//取得图片的实际高度
	parent.jQuery("#zoom_1").bind('click',function(e){
		// 1:1
		var target = parent.jQuery("#zoom").find('.maxImg');
		imgToOldSize(target,hWidth,hHeight);
	});
    //图片放大10%
	if(obj == "add"){
		indexi++;
		if(indexi > 13){
    		indexi--;
    		return false;
    	}
		if(indexi == 0){
			parent.jQuery("#zoom_1").unbind();
    		parent.jQuery("#zoom_1").css("background","#FFFFFF url(/images/preview/noash_wev8.png) no-repeat");
    	}else{
    		parent.jQuery("#zoom_1").css("background","#FFFFFF url(/images/preview/contrast_wev8.png) no-repeat");
    	}
    	//img.width=oWidth + oWidth*0.1;
    	var addwidth = oWidth + hWidth/10,
    	addheight = oHeight + hHeight/10;
    	//var addwidth = oWidth + oWidth*0.1,
    	//addheight = oHeight + oHeight*0.1;
    	if(navigator.userAgent.indexOf('MSIE') >= 0) {
    		var s = $(img).attr('step');
    		img.width=addwidth;
        	img.height=addheight;
        	$(img).css({"width":addwidth,"height":addheight,"z-index":"9999","vertical-align":"middle"});
    		if(s == 1 || s == 3){
    			tempWidth = addheight;
    			tempHeight = addwidth;
    		}else{
    			tempWidth = addwidth;
    			tempHeight = addheight;
    		}
    			
    			/*if(divWidth > tempWidth){
    				addwidth = divWidth;
    			}else{
    				addwidth = tempWidth;
    			}
    			if(divHeight > tempHeight){
    				addheight = divHeight;
    			}else{
    				addheight = tempHeight;
    			}*/
    		if(divWidth > tempWidth){
    			addwidth = divWidth;
    		}else{
    			addwidth = tempWidth;
    		}
    		if(divHeight > tempHeight){
    			addheight = divHeight;
    		}else{
    			addheight = tempHeight;
    		}
    		parent.jQuery("#zoom_content1").css({"width":addwidth,"height":addheight,"text-align":"center","vertical-align":"middle","z-index":"9999","display":"table-cell"});
    	}else {  // 对于现代浏览器 使用canvas
    		img.width=addwidth;
        	img.height=addheight;
        	$(img).css({"width":addwidth,"height":addheight,"z-index":"9999","vertical-align":"middle"});
	   		var canvas = $(img).next('canvas')[0];
	   		var degree = step * 90 * Math.PI / 180;
	   		if ($(img).next('canvas').length != 0) {
		   		var ctx = canvas.getContext('2d');
		   		switch (step) {
				case 0:
					canvas.width = addwidth;
					canvas.height = addheight;
					ctx.drawImage(img, 0, 0,addwidth, addheight);
					break;
				case 1:
					canvas.width = addheight;
					canvas.height = addwidth;
					ctx.rotate(degree);
					ctx.drawImage(img, 0, -addheight,addwidth, addheight);
					break;
				case 2:
					canvas.width = addwidth;
					canvas.height = addheight;
					ctx.rotate(degree);
					ctx.drawImage(img, -addwidth, -addheight,addwidth, addheight);
					break;
				case 3:
					canvas.width = addheight;
					canvas.height = addwidth;
					ctx.rotate(degree);
					ctx.drawImage(img, -addwidth, 0,addwidth, addheight);
					break;
		   		}
	   		}
    	}
    }
	//图片缩小10%
    if(obj == "minus"){
    	indexi--;
    	if(indexi < -7){
    		indexi++;
    		return false;
    	}
    	if(indexi == 0){
    		parent.jQuery("#zoom_1").unbind();
    		parent.jQuery("#zoom_1").css("background","#FFFFFF url(/images/preview/noash_wev8.png) no-repeat");
    	}else{
    		parent.jQuery("#zoom_1").css("background","#FFFFFF url(/images/preview/contrast_wev8.png) no-repeat");
    	}
    	var minuswidth = oWidth - hWidth/10,
    	minusheight = oHeight - hHeight/10;
    	if(navigator.userAgent.indexOf('MSIE') >= 0) {
        	var s = $(img).attr('step');
    		
    		img.width=minuswidth;
        	img.height=minusheight;
        	$(img).css({"width":minuswidth,"height":minusheight,"z-index":"9999","vertical-align":"middle"});
    		if(s == 1 || s == 3){
    			tempWidth = minusheight;
    			tempHeight = minuswidth;
    		}else{
    			tempWidth = minuswidth;
    			tempHeight = minusheight;
    		}
    			/*if(divWidth > tempWidth){
    				minuswidth = divWidth;
    			}else{
    				minuswidth = tempWidth;
    			}
    			if(divHeight > tempHeight){
    				minusheight = divHeight;
    			}else{
    				minusheight = tempHeight;
    			}*/
    		if(divWidth > tempWidth){
    			minuswidth = divWidth;
    		}else{
    			minuswidth = tempWidth;
    		}
    		if(divHeight > tempHeight){
    			minusheight = divHeight;
    		}else{
    			minusheight = tempHeight;
    		}
    		parent.jQuery("#zoom_content1").css({"width":minuswidth,"height":minusheight,"text-align":"center","vertical-align":"middle","z-index":"9999","display":"table-cell"});
    	}else {  // 对于现代浏览器 使用canvas
    		img.width=minuswidth;
        	img.height=minusheight;
        	$(img).css({"width":minuswidth,"height":minusheight,"z-index":"9999","vertical-align":"middle"});
   		 	var canvas = $(img).next('canvas')[0];
   		 	var degree = step * 90 * Math.PI / 180;
	   		if ($(img).next('canvas').length != 0) {
		   		var ctx = canvas.getContext('2d');
		   		switch (step) {
				case 0:
					canvas.width = minuswidth;
					canvas.height = minusheight;
					ctx.drawImage(img, 0, 0,minuswidth, minusheight);
					break;
				case 1:
					canvas.width = minusheight;
					canvas.height = minuswidth;
					ctx.rotate(degree);
					ctx.drawImage(img, 0, -minusheight,minuswidth, minusheight);
					break;
				case 2:
					canvas.width = minuswidth;
					canvas.height = minusheight;
					ctx.rotate(degree);
					ctx.drawImage(img, -minuswidth, -minusheight,minuswidth, minusheight);
					break;
				case 3:
					canvas.width = minusheight;
					canvas.height = minuswidth;
					ctx.rotate(degree);
					ctx.drawImage(img, -minuswidth, 0,minuswidth, minusheight);
					break;
		   		}
	   		}
    	}
    }
}

/*
 * 图片还原1:1
 */
function imgToOldSize(target,oWidth,oHeight){
	var self = this,
	cache = self.cache;

	var img = $(target)[0],
	step = img.getAttribute('step');
	if (step == null) {
		step = cache.minStep;
	}
	step = parseInt(step);
	indexi = 0;
	//parent.jQuery("#zoom_1").width();
	var nowWidth = img.width;//取得图片的实际宽度
	parent.jQuery("#zoom_1").css("background","#FFFFFF url(/images/preview/noash_wev8.png) no-repeat");
	parent.jQuery("#zoom_1").unbind();
	if(nowWidth != oWidth){
		img.width=oWidth-15;
		img.height=oHeight-15;
		$(img).css({"width":oWidth-15,"height":oHeight-15,"z-index":"9999","vertical-align":"middle"});
		if(navigator.userAgent.indexOf('MSIE') >= 0) {
			var s = $(img).attr('step');
    		
			img.width=oWidth;
			img.height=oHeight;
    		if(s == 1 || s == 3){
    			tempWidth = oHeight;
    			tempHeight = oWidth;
    			var middlewidth = oHeight;
    			var middleheight = oWidth;
    			if(divWidth > middlewidth ){
    				oWidth = divWidth;
    			}else{
    				oWidth = middleheight;
    			}
    			if(divHeight > middleheight){
    				oHeight = divHeight;
    			}else{
    				oHeight = middleheight
    			}
    		}else{
    			tempWidth = oWidth;
    			tempHeight = oHeight;
    			if(divWidth > oWidth){
    				oWidth = divWidth;
    			}
    			if(divHeight > oHeight){
    				oHeight = divHeight;
    			}
    		}
			parent.jQuery("#zoom_content1").css({"width":oWidth,"height":oHeight,"text-align":"center","vertical-align":"middle","position":"absolute;","z-index":"9999","display":"table-cell"});
		}else {  // 对于现代浏览器 使用canvas
			img.width=oWidth;
			img.height=oHeight;
			$(img).css({"width":oWidth,"height":oHeight,"z-index":"9999","vertical-align":"middle"});
			var canvas = $(img).next('canvas')[0];
			var degree = step * 90 * Math.PI / 180;
			if ($(img).next('canvas').length != 0) {
				var ctx = canvas.getContext('2d');
				switch (step) {
				case 0:
					canvas.width = oWidth;
					canvas.height = oHeight;
					ctx.drawImage(img, 0, 0,oWidth, oHeight);
					break;
				case 1:
					canvas.width = oHeight;
					canvas.height = oWidth;
					ctx.rotate(degree);
					ctx.drawImage(img, 0, -oHeight,oWidth, oHeight);
					break;
				case 2:
					canvas.width = oWidth;
					canvas.height = oHeight;
					ctx.rotate(degree);
					ctx.drawImage(img, -oWidth, -oHeight,oWidth, oHeight);
					break;
				case 3:
					canvas.width = oHeight;
					canvas.height = oWidth;
					ctx.rotate(degree);
					ctx.drawImage(img, -oWidth, 0,oWidth, oHeight);
					break;
				}
			}
		}
	}
}

/*
 * 图片下载
 */
function downloads_sf(files){
	document.location.href=files+"&download=1";
}

//parent.document.onmousedown=initDrag;
//parent.document.onmouseup=new Function("isdrag=false");



function release(){
	isdrag=false;
}


function moveMouse(e) {
	 if (isdrag) {
	 oDragObj.style.top  =  (nn6 ? nTY + e.clientY - y : nTY + parent.event.clientY - y)+"px";
	 oDragObj.style.left  =  (nn6 ? nTX + e.clientX - x : nTX + parent.event.clientX - x)+"px";
	 return false;
	 }
}

function initDrag(e) {
 var oDragHandle = nn6 ? e.target : parent.event.srcElement;
 var topElement = "HTML";
 while (oDragHandle.tagName != topElement && oDragHandle.className != "round_shade_box") {
 oDragHandle = nn6 ? oDragHandle.parentNode : oDragHandle.parentElement;
 }
 if (oDragHandle.className=="round_shade_box") {
 isdrag = true;
 oDragObj = oDragHandle;
 nTY = parseInt(oDragObj.style.top+0);
 y = nn6 ? e.clientY : parent.event.clientY;
 nTX = parseInt(oDragObj.style.left+0);
 x = nn6 ? e.clientX : parent.event.clientX;
 parent.document.onmousemove=moveMouse;
 return false;
 }
}


//滚轮缩放
function onWheelZoom(obj){  
	zoom = parseFloat(obj.style.zoom);
	tZoom = zoom + (event.wheelDelta>0 ? 0.05 : -0.05);
	if(tZoom<0.1 ) return true;
	obj.style.zoom=tZoom;
	return false;
}