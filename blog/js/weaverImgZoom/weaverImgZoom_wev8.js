/************************
 *   图片选择处理开始    *
 * **********************/
(function (document, $, log) {

	$.fn.coomixPic = function (config) {
		config = $.extend({}, $.fn.coomixPic.defaults, config);
		
		var tmpl, viewport,
			$this = this,
			loadImg = {},
			path = config.path,
			loading = path + '/loading_wev8.gif',
			max = path + '/zoomin.cur',
			min = path + '/zoomout.cur';
		
		new Image().src = loading;
		
		max = 'url(\'' + max + '\'), pointer';
		min = 'url(\'' + min + '\'), pointer';
		
		tmpl = [
			'<div class="ui-coomixPic-toolbar" style="display:none">',
				'<span class="ui-coomixPic-buttons" style="display:none">',
				//'<a href="#" data-go="details" class="ui-coomixPic-details"><span></span>',
				//config.details, 
			//'</a>',
				'<a href="#" data-go="hide" class="ui-coomixPic-hide" style="font-weight:normal !important;font-size:9pt !important"><span></span>',
				    config.hide,
			'</a>',
			'<a href="#" data-go="source" class="ui-coomixPic-source" style="font-weight:normal !important;font-size:9pt !important"><span></span>',
			        config.source,
		'</a>',
			
				'<a href="#" data-go="left" class="ui-coomixPic-left" style="font-weight:normal !important;font-size:9pt !important"><span></span>',
					config.left,
				'</a>',
				'<a href="#" data-go="right" class="ui-coomixPic-right" style="font-weight:normal !important;font-size:9pt !important"><span></span>',
					config.right,
				'</a>',
				'</span>',
				'<span class="ui-coomixPic-loading">',
					'<img data-live="stop" src="',
						loading,
						'" style="',
						'display:inline-block;*zoom:1;*display:inline;vertical-align:middle;',
						'width:16px;height:16px;"',
					' />',
					' <span>Loading..</span>',
				'</span>',
			'</div>',
			'<div class="ui-coomixPic-box" style="display:none">',
				'<span class="ui-coomixPic-photo" data-go="hide"',
				' style="display:inline-block;*display:inline;*zoom:1;overflow:hidden;position:relative;cursor:',
					min,
				'">',
					'<img data-name="thumb" data-go="hide" data-live="stop" src="',
						loading,
					'" />',
				'</span>',
			'</div>'
		].join('');
		
		// jQuery事件代理
		this.bind('click', function (event) {
			if (this.nodeName !== 'IMG' && this.getAttribute('data-live') === 'stop') return false;
			
			var $coomixPic, buttonClick,
				that = this,
				$this = $(that),
				$parent = $this.parent(),
				src = that.src,
				bigPath = $this.attr('rel'),
				show = $this.attr('data-coomixPic-show') || src,
				source = $this.attr('data-coomixPic-source') || show,
				maxWidth = config.maxWidth || ($parent[0].nodeName === 'A' ? $this.parent() : $this).parent().width(),
				maxHeight = config.maxHeight || 99999;
			
			maxWidth = maxWidth - config.borderWidth;
			
			// 对包含在链接内的图片进行特殊处理
			if ($parent[0].nodeName === 'A') {
				show = $parent.attr('data-coomixPic-show') || $parent.attr('href');
				source = $parent.attr('data-coomixPic-source') || $parent.attr('rel');
			};

			// 第一次点击
			if (!$this.data('coomixPic')) {
				var wrap = document.createElement('div'),
					$thumb, $box, $show;
				
				$coomixPic = $(wrap);
				wrap.className = 'ui-coomixPic ui-coomixPic-noLoad';
				wrap.innerHTML = tmpl;
				
				($parent[0].nodeName === 'A' ? $this.parent() : $this).before(wrap);
				$this.data('coomixPic', $coomixPic);
				$box = $coomixPic.find('.ui-coomixPic-box');
				$thumb = $coomixPic.find('[data-name=thumb]');
				
				// 快速获取大图尺寸
				imgReady(show, function () {
					var width = this.width,
						height = this.height,
						maxWidth2 = Math.min(maxWidth, width);
					
					height = maxWidth2 / width * height;
					width = maxWidth2;
					
					// 插入大图并使用逐渐清晰加载的效果
					$thumb.attr('src', src).
						css(config.blur ? {
							width: width + 'px',
							height: height + 'px'
						} : {display: 'none'}).
						after([
						'<img class="ui-coomixPic-show" title="',
							that.title,
							'" alt="',
							that.alt,
							'" src="',
							show,
							'" style="width:',
							width,
							'px;height:',
							height, // IE8 超长图片height属性失效BUG，改用CSS
							'px;position:absolute;left:0;top:0;background:transparent"',
						' />'
					].join(''));
					
					$show = $coomixPic.find('.ui-coomixPic-show');
					$thumb.attr('class', 'ui-coomixPic-show');
					$coomixPic.addClass('ui-coomixPic-ready');
					$coomixPic.find('.ui-coomixPic-buttons').show();
					$this.data('coomixPic-ready', true);
					$this.hide();
					$box.show();
					
				// 大图完全加载完毕
				}, function () {
					$thumb.removeAttr('class').hide();
					$show.css({
						position: 'static',
						left: 'auto',
						top: 'auto'
					});
					
					$coomixPic.removeClass('ui-coomixPic-noLoad');
					$coomixPic.find('.ui-coomixPic-loading').hide();
					$this.data('coomixPic-load', true);
				
				// 图片加载错误
				}, function () {
					$coomixPic.addClass('ui-coomixPic-error');
					log('jQuery.fn.coomixPic: Load "' + show + '" Error!');
				});
				
			} else {
				$this.hide();
			};
			
			$coomixPic = $this.data('coomixPic');
			buttonClick = function (event) {
				var target = this,
					go = target.getAttribute('data-go'),
					live = target.getAttribute('data-live'),
					degree = $this.data('coomixPic-degree') || 0,
					elem = $coomixPic.find('.ui-coomixPic-show')[0];
					
				if (live === 'stop') return false;
				if (/img|canvas$/i.test(target.nodeName)) go = 'hide';
				
				switch (go) {
					case 'left':
						degree -= 90;
						degree = degree === -90 ? 270 : degree;
						break;
					case 'right':
						degree += 90;
						degree = degree === 360 ? 0 : degree;
						break;
					case 'source':
						window.open(bigPath || show ||  src || source);
						break;
					case 'details':
						window.open(source || show || src);
						break;
					case 'hide':
						$this.show();
						$coomixPic.find('.ui-coomixPic-toolbar').hide();
						$coomixPic.hide();
						$coomixPic.find('[data-go]').die('click', buttonClick);
						break;
				};
				
				if ((go === 'left' || go === 'right') && $this.data('coomixPic-load')) {
					imgRotate(elem, degree, maxWidth, maxHeight);
					$this.data('coomixPic-degree', degree);
				};
				
				return false;
			};
			$coomixPic.show().find('.ui-coomixPic-toolbar').slideDown(150);
			$coomixPic.find('[data-go]').live('click', buttonClick);
				
			return false;
		});
		
		// 给目标缩略图应用外部指针样式
		this.bind('mouseover', function () {
			//if (this.className !== 'ui-coomixPic-show'&&this.style.cursor!='') this.style.cursor = max;
			if (this.className !== 'ui-coomixPic-show') this.style.cursor = max;
		});
		
		// 预加载指针形状图标
		if (this[0]) this[0].style.cursor = max;
		
		return this;
	};
	$.fn.coomixPic.defaults = {
		path: './images',
		left: '\u5de6\u65cb\u8f6c',
		right: '\u53f3\u65cb\u8f6c',
		source: '\u770b\u539f\u56fe',
		hide: '\xd7',
		details:'more',
		blur: true,
		preload: true,
		maxWidth: null,
		maxHeight: null,
		borderWidth: 18
	};

	/**
	 * 图片旋转
	 * @version	2011.05.27
	 * @author	TangBin
	 * @param	{HTMLElement}	图片元素
	 * @param	{Number}		旋转角度 (可用值: 0, 90, 180, 270)
	 * @param	{Number}		最大宽度限制
	 * @param	{Number}		最大高度限制
	 */
	var imgRotate = $.imgRotate = function () {
		var eCanvas = '{$canvas}',
			isCanvas = !!document.createElement('canvas').getContext;
			
		return function (elem, degree, maxWidth, maxHeight) {
			var x, y, getContext,
				resize = 1,
				width = elem.naturalWidth,
				height = elem.naturalHeight,
				canvas = elem[eCanvas];
			
			// 初次运行
			if (!elem[eCanvas]) {
				
				// 获取图像未应用样式的真实大小 (IE和Opera早期版本)
				if (!('naturalWidth' in elem)) {
					var run = elem.runtimeStyle, w = run.width, h = run.height;
					run.width  = run.height = 'auto';
					elem.naturalWidth = width = elem.width;
					elem.naturalHeight = height = elem.height;
					run.width  = w;
					run.height = h;
				};
			
				elem[eCanvas] = canvas = document.createElement(isCanvas ? 'canvas' : 'span');
				elem.parentNode.insertBefore(canvas, elem.nextSibling);
				elem.style.display = 'none';
				canvas.className = elem.className;
				canvas.title = elem.title;
				if (!isCanvas) {
					canvas.img = document.createElement('img');
					canvas.img.src = elem.src;
					canvas.appendChild(canvas.img);
					canvas.style.cssText = 'display:inline-block;*zoom:1;*display:inline;' +
						// css reset
						'padding:0;margin:0;border:none 0;position:static;float:none;overflow:hidden;width:auto;height:auto';
				};
			};
			
			var size = function (isSwap) {
				if (isSwap) width = [height, height = width][0];
				if (width > maxWidth) {
					resize = maxWidth / width;
					height =  resize * height;
					width = maxWidth;
				};
				if (height > maxHeight) {
					resize = resize * maxHeight / height;
					width = maxHeight / height * width;
					height = maxHeight;
				};
				if (isCanvas) (isSwap ? height : width) / elem.naturalWidth;
			};
			
			switch (degree) {
				case 0:
					x = 0;
					y = 0;
					size();
					break;
				case 90:
					x = 0;
					y = -elem.naturalHeight;
					size(true);
					break;
				case 180:
					x = -elem.naturalWidth;
					y = -elem.naturalHeight
					size();
					break;
				case 270:
					x = -elem.naturalWidth;
					y = 0;
					size(true);
					break;
			};
			
			if (isCanvas) {
				canvas.setAttribute('width', width);
				canvas.setAttribute('height', height);
				getContext = canvas.getContext('2d');
				getContext.rotate(degree * Math.PI / 180);
				getContext.scale(resize, resize);
				getContext.drawImage(elem, x, y);	
			} else {
				canvas.style.width = width + 'px';
				canvas.style.height = height + 'px';// 解决IE8使用滤镜后高度不能自适应
				canvas.img.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + degree / 90 + ')';
				canvas.img.width = elem.width * resize;
				canvas.img.height = elem.height * resize;
			};
		};
	}();

	/**
	 * 图片头数据加载就绪事件 - 更快获取图片尺寸
	 * @param	{String}	图片路径
	 * @param	{Function}	尺寸就绪
	 * @param	{Function}	加载完毕 (可选)
	 * @param	{Function}	加载错误 (可选)
	 * @example imgReady('http://www.google.com.hk/intl/zh-CN/images/logo_cn_wev8.png', function () {
			alert('size ready: width=' + this.width + '; height=' + this.height);
		});
	 */
	var imgReady = (function () {
		var list = [], intervalId = null,

		// 用来执行队列
		tick = function () {
			var i = 0;
			for (; i < list.length; i++) {
				list[i].end ? list.splice(i--, 1) : list[i]();
			};
			!list.length && stop();
		},

		// 停止所有定时器队列
		stop = function () {
			clearInterval(intervalId);
			intervalId = null;
		};

		return function (url, ready, load, error) {
			var onready, width, height, newWidth, newHeight,
				img = new Image();
			
			img.src = url;

			// 如果图片被缓存，则直接返回缓存数据
			if (img.complete) {
				ready.call(img);
				load && load.call(img);
				return;
			};
			
			width = img.width;
			height = img.height;
			
			// 加载错误后的事件
			img.onerror = function () {
				error && error.call(img);
				onready.end = true;
				img = img.onload = img.onerror = null;
			};
			
			// 图片尺寸就绪
			onready = function () {
				newWidth = img.width;
				newHeight = img.height;
				if (newWidth !== width || newHeight !== height ||
					// 如果图片已经在其他地方加载可使用面积检测
					newWidth * newHeight > 1024
				) {
					ready.call(img);
					onready.end = true;
				};
			};
			onready();
			
			// 完全加载完毕的事件
			img.onload = function () {
				// onload在定时器时间差范围内可能比onready快
				// 这里进行检查并保证onready优先执行
				!onready.end && onready();
			
				load && load.call(img);
				
				// IE gif动画会循环执行onload，置空onload即可
				img = img.onload = img.onerror = null;
			};

			// 加入队列中定期执行
			if (!onready.end) {
				list.push(onready);
				// 无论何时只允许出现一个定时器，减少浏览器性能损耗
				if (intervalId === null) intervalId = setInterval(tick, 40);
			};
		};
	})();

	}(document, jQuery, function (msg) {window.console && console.log(msg)}));
