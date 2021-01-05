(function(root, factory) {
	if (document.IMGDRAWLOADED) { return; }
	// Set up ImgDrawing appropriately for the environment.
	if (typeof define === 'function' && (define.amd || define.cmd)) {
		define('imgdrawing', function(exports) {
			return factory(root, exports);
		});
	// Finally, as a browser global.
	} else {
		root.ImgDrawing = factory(root, {});
	}
})(this, function(root, ImgDrawing) {
	
	function isUrl(data){
		if(Object.prototype.toString.call(data) != "[object String]"){
			return false;
		}
		data = data.toLowerCase();
		return (data.indexOf("http:") == 0 || data.indexOf("https:") == 0 || data.indexOf("/") == 0);
	}
	
	function isBase64(data){
		if(Object.prototype.toString.call(data) != "[object String]"){
			return false;
		}
		data = data.toLowerCase();
		return data.indexOf("base64,") != -1;
	}
	
	// Is it webkit
	var isWebkit = 'WebkitAppearance' in document.documentElement.style || typeof document.webkitHidden != "undefined";
	var _lineWidth = 5, _color = "red", _drawGraph = "line", _imageStack = new Array(), _blankImg = "", _continuousUndo = true, 
		_op = "draw", type = "imgdrawing", _emptyImg = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAANSURBVBhXY/j///9/AAn7A/0FQ0XKAAAAAElFTkSuQmCC";//_op draw eraser, type imgdrawing handwriting
	var $drawWin;
	var $drawHeader;
	var $drawContent;
	var $drawConfig;
	var $eraserConfig;
	
	var csvW = $(window).width();
	var csvH = $(window).height() - 36;
	var csvTop = 0;
	var csvLeft = 0;
	
	function getCanvas(){
		if($("#canvas", $drawContent).length == 0){
			var canvas = '<canvas id="canvas" width="'+(csvW*2)+'" height="'+(csvH*2)+'" style="margin-top:'+csvTop+'px;margin-left:'+csvLeft+'px;width:'+(csvW)+'px;height:'+(csvH)+'px;"></canvas>';
			$drawContent.append(canvas);
			// setup to trigger drawing on mouse or touch
		    drawTouch();
			drawMouse();
		}
		return $("#canvas", $drawContent)[0];
	}
	
	function getCvsContext(){
		var cvs = getCanvas();
		return cvs.getContext("2d");
	}
	
	function closeWin(callbackFn){
		$drawWin.removeClass("slideup-in");
		$drawWin.addClass("slideup-out");
		
		setTimeout(function(){
			if(typeof(callbackFn) == "function"){
				callbackFn.call(this);
			}
		}, 250);
	}
	
	function fillImg(src){
		var tImg = new Image();
		tImg.onload = function(){
			$drawContent.removeClass("_loading");
			if(type == "imgdrawing"){
				$drawConfig.hide();
			}
			// setup canvas
			var cvs = getCanvas();
			var ctx = cvs.getContext("2d");
			ctx.drawImage(tImg,0,0,(csvW*2),(csvH*2));
			ctx.strokeStyle = _color;
			ctx.lineWidth = _lineWidth;
		};
		tImg.src = src;
	}
	
	function paramEllipse(context, x, y, a, b){
		//step equals 1 divide the larger between a and b
		//i added by step, express the increase of the degree
		var step = (a > b) ? 1 / a : 1 / b;
		context.beginPath();
		context.moveTo(x + a, y); // drawing from the left point of ellipse
		for (var i = 0; i < 2 * Math.PI; i += step){
			// parameter equation is: x = a * cos(i), y = b * sin(i)，
			context.lineTo(x + a * Math.cos(i), y + b * Math.sin(i));
		}
		context.closePath();
		context.stroke();
		if(_op == "eraser"){
			context.fill();
		}
	}
	
	function drawImg(data){
		if(isUrl(data)){
			fillImg(data);
		}else if(isBase64(data)){
			if (!(navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i))) {// 此处仅修复iphone
				fillImg(data);
			}else{
				ImageOrientationFix({  
		            image: data,
		            imgType: "base64",
		            onFix:function(base64_str){
		            	fillImg(base64_str);
		            }
				});
			}
		}
	}
	
	function addHistory(){
		var imgData = getCanvas().toDataURL();
		_imageStack.push(imgData);
		_continuousUndo = false;
	}
	
	function initConfig(){
		$eraserConfig.hide();
		_op = "draw";
		_color = "red";
		_lineWidth = 5;
		_drawGraph = "line";
		var ctx = getCvsContext();
		ctx.beginPath();
		ctx.strokeStyle = _color;
		ctx.lineWidth = _lineWidth;
		
		var $drawingColor = $(".wev-drawing-color[data-color='red']", $drawWin);
		$drawingColor.addClass("selected").siblings(".wev-drawing-color").removeClass("selected");
		
		var $drawingPoint = $(".wev-drawing-point[data-lineWidth='5']", $drawWin);
		$drawingPoint.addClass("selected").siblings(".wev-drawing-point").removeClass("selected");
		
		var $drawingGraph = $(".wev-drawing-graph[data-type='line']", $drawWin);
		$drawingGraph.addClass("selected").siblings(".wev-drawing-graph").removeClass("selected");
		
		var $eraserPoint = $(".wev-eraser-point[data-lineWidth='30']", $drawWin);
		$eraserPoint.addClass("selected").siblings(".wev-eraser-point").removeClass("selected");
		
		$("a.pen-btn", $drawWin).addClass("selected").siblings("a[class*='-btn']").removeClass("selected");
		
	}
	
	function hideConfig(){
		$drawConfig.hide();
		$eraserConfig.hide();
	}
	
	//prototype to	start drawing on touch using canvas moveTo and lineTo
	var drawTouch = function() {
		var cvs = getCanvas();
		var ctx = cvs.getContext("2d");
		var start = function(e) {
			x = e.changedTouches[0].pageX;
			if(type == "handwriting"){
				y = e.changedTouches[0].pageY - 36 - csvH/2;
			}else{
				$drawConfig.hide();
				y = e.changedTouches[0].pageY-36-csvTop;
				x = x - csvLeft;
			}
			x = x * 2;
			y = y * 2;
			x1 = x;
			y1 = y;
			if(_drawGraph == "line"){
				ctx.beginPath();
				ctx.moveTo(x,y);
			}
		};
		var move = function(e) {
			e.preventDefault();
			x1 = e.changedTouches[0].pageX;
			if(type == "handwriting"){
				y1 = e.changedTouches[0].pageY - 36 - csvH/2;
			}else{
				y1 = e.changedTouches[0].pageY-36-csvTop;
				x1 = x1 - csvLeft;
			}
			x1 = x1 * 2;
			y1 = y1 * 2;
			if(_drawGraph == "line"){
				ctx.lineTo(x1,y1);
				ctx.stroke();
			}
		};
		var end = function(e){
			if(x1-x != 0 && y1-y != 0){
				if(_drawGraph == "rectangle"){
					if(_op == "eraser"){
						ctx.fillRect(x < x1 ? x : x1 , y < y1 ? y : y1, Math.abs(x1-x), Math.abs(y1-y));
					}else{
						ctx.strokeRect(x < x1 ? x : x1 , y < y1 ? y : y1, Math.abs(x1-x), Math.abs(y1-y));
					}
				}
				
				if(_drawGraph == "circle"){
					paramEllipse(ctx, (x1-x)/2 + x, (y1-y)/2 + y, Math.abs((x1-x)/2), Math.abs((y1-y)/2));
				}
			}
			addHistory();
		}
		cvs.addEventListener("touchstart", start, false);
		cvs.addEventListener("touchmove", move, false);
		cvs.addEventListener("touchend", end, false);
	}; 
	    
	// prototype to	start drawing on mouse using canvas moveTo and lineTo
	var drawMouse = function() {
		var cvs = getCanvas();
		var ctx = cvs.getContext("2d");
		var clicked = 0;
		var start = function(e) {
			clicked = 1;
			x = e.pageX;
			if(type == "handwriting"){
				y = e.pageY - 36 - csvH/2;
			}else{
				y = e.pageY-36-csvTop;
				x = x - csvLeft;
				$drawConfig.hide();
			}
			
			x = x * 2;
			y = y * 2;
			x1 = x;
			y1 = y;
			if(_drawGraph == "line"){
				ctx.beginPath();
				ctx.moveTo(x,y);
			}
			
		};
		var move = function(e) {
			if(clicked){
				x1 = e.pageX;
				if(type == "handwriting"){
					y1 = e.pageY - 36 - csvH/2;
				}else{
					y1 = e.pageY-36-csvTop;
					x1 = x1 - csvLeft;
				}
				x1 = x1 * 2;
				y1 = y1 * 2;
				if(_drawGraph == "line"){
					ctx.lineTo(x1,y1);
					ctx.stroke();
				}
			}
		};
		var stop = function(e) {
			if(clicked && x1-x != 0 && y1-y != 0){
				if(_drawGraph == "rectangle"){
					if(_op == "eraser"){
						ctx.fillRect(x < x1 ? x : x1 , y < y1 ? y : y1, Math.abs(x1-x), Math.abs(y1-y));
					}else{
						ctx.strokeRect(x < x1 ? x : x1 , y < y1 ? y : y1, Math.abs(x1-x), Math.abs(y1-y));
					}
				}
				if(_drawGraph == "circle"){
					paramEllipse(ctx, (x1-x)/2 + x, (y1-y)/2 + y, Math.abs((x1-x)/2), Math.abs((y1-y)/2));
				}
			}
			if(clicked){
				addHistory();
			}
			clicked = 0;
		};
		cvs.addEventListener("mousedown", start, false);
		cvs.addEventListener("mousemove", move, false);
		document.addEventListener("mouseup", stop, false);
	};
	
	var _params = {};
	
	ImgDrawing.draw = function(params){
		_params["type"] = "";
		$.extend(_params, params);
		_blankImg = _params["data"];
		_imageStack = new Array();
		$drawWin = $(".wev-drawing-win");
		
		if($drawWin.length == 0){	//create
			var htm=[
				'<div class="wev-drawing-win">',
					'<div class="wev-drawing-header">',
						'<a href="javascript:void(0);" class="save-btn"></a>',
						'<a href="javascript:void(0);" class="close-btn"></a>',
						'<a href="javascript:void(0);" class="pen-btn selected"></a>',
						'<a href="javascript:void(0);" class="eraser-btn"></a>',
						'<a href="javascript:void(0);" class="undo-btn"></a>',
						'<a href="javascript:void(0);" class="refresh-btn"></a>',
					'</div>',
					'<div class="wev-drawing-content">',
					'</div>',
					'<div class="wev-drawing-config">',
						'<div class="wev-drawing-graph" data-type="rectangle"></div>',
						'<div class="wev-drawing-graph" data-type="circle"></div>',
						'<div class="wev-drawing-graph selected" data-type="line"></div>',
						'<div class="wev-drawing-point" data-lineWidth="2"></div>',
						'<div class="wev-drawing-point selected" data-lineWidth="5"></div>',
						'<div class="wev-drawing-point" data-lineWidth="10"></div>',
						'<div class="wev-drawing-color selected" data-color="red"></div>',
						'<div class="wev-drawing-color" data-color="#000"></div>',
						'<div class="wev-drawing-color" data-color="#fff"></div>',
						'<div class="wev-drawing-color" data-color="green"></div>',
						'<div class="wev-drawing-color" data-color="#ffff00"></div>',
						'<div class="wev-drawing-color" data-color="#f31bf3"></div>',
					'</div>',
					'<div class="wev-eraser-config">',
						'<div class="wev-eraser-point" data-lineWidth="15"></div>',
						'<div class="wev-eraser-point" data-lineWidth="20"></div>',
						'<div class="wev-eraser-point" data-lineWidth="25"></div>',
						'<div class="wev-eraser-point selected" data-lineWidth="30"></div>',
						'<div class="wev-eraser-point" data-lineWidth="35"></div>',
						'<div class="wev-eraser-point" data-lineWidth="40"></div>',
						'<div class="wev-eraser-point" data-lineWidth="45"></div>',
						'<a class="wev-eraser-clean"></a>',
					'</div>',
				'</div>'
			].join('\n');
			
			$drawWin = $(htm);
			var $wrapper = $("#page_view");
			if($wrapper.length == 0){
				$wrapper = $(document.body);
			}
			$wrapper.append($drawWin);
			$drawHeader = $(".wev-drawing-header .title", $drawWin);
			$drawContent = $(".wev-drawing-content", $drawWin);
			$drawConfig = $(".wev-drawing-config", $drawWin);
			$eraserConfig = $(".wev-eraser-config", $drawWin);
			
			var animateEventName = isWebkit? "webkitAnimationEnd": "animationend";
			$drawWin[0].addEventListener(animateEventName, function() {
				if($(this).hasClass("slideup-out")){
					$drawWin.hide();
					$drawWin.removeClass("slideup-out");
				}
			});
			
			$(".close-btn", $drawWin).click(function(){
				_imageStack = new Array();
				hideConfig();
				closeWin(function(){
					$drawContent.html("");
					var callback = _params.callback || {};
					if(typeof(callback.close) == "function"){
						callback.close.call(this);
					}
				});
			});
			$(".refresh-btn", $drawWin).click(function(){
				if(type == "imgdrawing"){
					hideConfig();
				}
				$drawContent.html("");
				$drawContent.addClass("_loading");
				_op = "draw";
				_imageStack = new Array();
				drawImg(_blankImg);
			});
			
			$(".pen-btn", $drawWin).click(function(){
				$(this).addClass("selected").siblings("a[class*='-btn']").removeClass("selected");
				$(".wev-eraser-config", $drawWin).hide();
				$(".wev-drawing-config", $drawWin).toggle();
				_op = "draw";
				_color = $(".wev-drawing-color.selected", $drawWin).attr("data-color") || "red";
				_lineWidth = parseInt($(".wev-drawing-point.selected", $drawWin).attr("data-lineWidth"));
				_drawGraph = $(".wev-drawing-graph.selected", $drawWin).attr("data-type") || "line";
				
				var ctx = getCvsContext();
				ctx.beginPath();
				ctx.strokeStyle = _color;
				ctx.lineWidth = _lineWidth;
			});
			
			$(".undo-btn", $drawWin).click(function(e){
				if(type == "imgdrawing"){
					hideConfig();
				}
				if(!_continuousUndo){
					_imageStack.pop();
					_continuousUndo = true;
				}
				var preData = _imageStack.pop();
				drawImg(preData || _blankImg);
			});
			
			$(".eraser-btn", $drawWin).click(function(){
				$(this).addClass("selected").siblings("a[class*='-btn']").removeClass("selected");
				$(".wev-drawing-config", $drawWin).hide();
				$(".wev-eraser-config", $drawWin).toggle();
				_op = "eraser";
				_color = "#fff";
				_lineWidth = parseInt($(".wev-eraser-point.selected", $drawWin).attr("data-lineWidth"));
				_drawGraph = "line";
				
				var ctx = getCvsContext();
				ctx.beginPath();
				ctx.lineWidth = _lineWidth;
				ctx.strokeStyle = _color;
			});
			
			$(".save-btn", $drawWin).click(function(){
				_imageStack = new Array();
				hideConfig();
				closeWin(function(){
					var result = getCanvas().toDataURL();
					$drawContent.html("");
					var callback = _params.callback || {};
					if(typeof(callback.done) == "function"){
						callback.done.call(this, result);
					}
				});
			});
			
			$(".wev-drawing-graph", $drawWin).click(function(){
				if(!$(this).hasClass("selected")){
					$(this).siblings(".wev-drawing-graph").removeClass("selected");
					$(this).addClass("selected");
					_drawGraph = $(this).attr("data-type");
				}
			});
			
			$(".wev-drawing-point", $drawWin).click(function(){
				if(!$(this).hasClass("selected")){
					$(this).siblings(".wev-drawing-point").removeClass("selected");
					$(this).addClass("selected");
					_lineWidth = parseInt($(this).attr("data-lineWidth"));
					var ctx = getCvsContext();
					ctx.beginPath();
					ctx.lineWidth = _lineWidth;
				}
			});
			
			$(".wev-eraser-point", $drawWin).click(function(){
				if(!$(this).hasClass("selected")){
					$(this).siblings(".wev-eraser-point").removeClass("selected");
					$(this).addClass("selected");
					_lineWidth = parseInt($(this).attr("data-lineWidth"));
					var ctx = getCvsContext();
					ctx.beginPath();
					ctx.lineWidth = _lineWidth;
				}
			});
			
			$(".wev-drawing-color", $drawWin).click(function(){
				if(!$(this).hasClass("selected")){
					$(this).siblings(".wev-drawing-color").removeClass("selected");
					$(this).addClass("selected");
					_color = $(this).attr("data-color");
					var ctx = getCvsContext();
					ctx.beginPath();
					ctx.strokeStyle = _color;
				}
			});
			
			$(".wev-eraser-clean", $drawWin).click(function(){
				addHistory();
				drawImg(_emptyImg);
			});
			
		}
		
		type = _params["type"] || "imgdrawing";
		csvTop = 0;
		csvLeft = 0;
		if(type == "handwriting"){
			$(".eraser-btn", $drawWin).show();
			csvW = $(window).width() - 10;
			csvH = ($(window).height() - 36)/2;
			$drawContent.addClass("handwriting");
			$drawContent.removeClass("imgdrawing");
			$drawConfig.show();
		}else{
			winW = $(window).width();
			winH = $(window).height() - 36;
			var imgW = _params["width"] || winW;
			var imgH = _params["height"] || winH;
			$(".eraser-btn", $drawWin).hide();
			if(winW < winH){
				csvW = winW;
				csvH = parseInt(csvW*(imgH/imgW));
			}else{
				csvH = winH;
				csvW = parseInt(csvH*(imgW/imgH));
			}
			
			
			if(csvH < winH){
				csvTop = (winH - csvH)/2;
			}
			if(csvW < winW){
				csvLeft = (winW - csvW)/2;
			}
			$drawContent.addClass("imgdrawing");
			$drawContent.removeClass("handwriting");
		}
		
		//show win
		$drawHeader.html(_params["title"] || "");
		$drawContent.addClass("_loading");
		$drawWin.css("visibility", "hidden");
		$drawWin.show();
		initConfig();
   		setTimeout(function(){
   			$drawWin.addClass("slideup-in");
   			$drawWin.css("visibility", "visible");
   		}, 1);
   		
   		var waitTime = 0;
		if (!(navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i))) {// 修复android加载image时页面阻塞导致动画失效
			waitTime = 300;
		}
		
		setTimeout(function(){
			drawImg(_params["data"]);
		}, waitTime);
   		
	};
	
	document.IMGDRAWLOADED = true;
	
	return ImgDrawing;
});

