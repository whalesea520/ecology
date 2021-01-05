/*
 * artZoom 1.0.7
 * Date: 2011-06-22
 * (c) 2009-2011 TangBin, http://www.planeArt.cn
 *
 * This is licensed under the GNU LGPL, version 2.1 or later.
 * For details, see: http://creativecommons.org/licenses/LGPL/2.1/
 */
(function (document, $, log) {

$.fn.artZoom = function (config) {
	config = $.extend({}, $.fn.artZoom.defaults, config);
	
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
		'<div class="ui-artZoom-toolbar" style="display:none">',
			'<span class="ui-artZoom-buttons" style="display:none">',
				'<a href="#" data-go="left" class="ui-artZoom-left"><span></span>',
					config.left,
				'</a>',
				'<a href="#" data-go="right" class="ui-artZoom-right"><span></span>',
					config.right,
				'</a>',
				'<a href="#" data-go="source" class="ui-artZoom-source"><span></span>',
					config.source,
				'</a>',
				'<a href="#" data-go="hide" class="ui-artZoom-hide"><span></span>',
					config.hide,
				'</a>',
			'</span>',
			'<span class="ui-artZoom-loading">',
				'<img data-live="stop" src="',
					loading,
					'" style="',
					'display:inline-block;*zoom:1;*display:inline;vertical-align:middle;',
					'width:16px;height:16px;"',
				' />',
				' <span>Loading..</span>',
			'</span>',
		'</div>',
		'<div class="ui-artZoom-box" style="display:none">',
			'<span class="ui-artZoom-photo" data-go="hide"',
			' style="display:inline-block;*display:inline;*zoom:1;overflow:hidden;position:relative;cursor:',
				min,
			'">',
				'<img data-name="thumb" data-go="hide" data-live="stop" src="',
					loading,
				'" />',
			'</span>',
		'</div>'
	].join('');
	
	// jQuery浜嬩欢浠ｇ悊
	this.live('click', function (event) {
		if (this.nodeName !== 'IMG' && this.getAttribute('data-live') === 'stop') return false;
		
		var $artZoom, buttonClick,
			that = this,
			$this = $(that),
			$parent = $this.parent(),
			src = that.src,
			show = $this.attr('data-artZoom-show') || src,
			source = $this.attr('data-artZoom-source') || show,
			maxWidth = config.maxWidth || ($parent[0].nodeName === 'A' ? $this.parent() : $this).parent().width(),
			maxHeight = config.maxHeight || 99999;
		
		maxWidth = maxWidth - config.borderWidth;
		
		// 瀵瑰寘鍚湪閾炬帴鍐呯殑鍥剧墖杩涜鐗规畩澶勭悊
		if ($parent[0].nodeName === 'A') {
			show = $parent.attr('data-artZoom-show') || $parent.attr('href');
			source = $parent.attr('data-artZoom-source') || $parent.attr('rel');
		};

		// 绗竴娆＄偣鍑?
		if (!$this.data('artZoom')) {
			var wrap = document.createElement('div'),
				$thumb, $box, $show;
			
			$artZoom = $(wrap);
			wrap.className = 'ui-artZoom ui-artZoom-noLoad';
			wrap.innerHTML = tmpl;
			
			($parent[0].nodeName === 'A' ? $this.parent() : $this).before(wrap);
			$this.data('artZoom', $artZoom);
			$box = $artZoom.find('.ui-artZoom-box');
			$thumb = $artZoom.find('[data-name=thumb]');
			
			// 蹇€熻幏鍙栧ぇ鍥惧昂瀵?
			imgReady(show, function () {
				var width = this.width,
					height = this.height,
					maxWidth2 = Math.min(maxWidth, width);
				
				height = maxWidth2 / width * height;
				width = maxWidth2;
				
				// 鎻掑叆澶у浘骞朵娇鐢ㄩ€愭笎娓呮櫚鍔犺浇鐨勬晥鏋?
				$thumb.attr('src', src).
					css(config.blur ? {
						width: width + 'px',
						height: height + 'px'
					} : {display: 'none'}).
					after([
					'<img class="ui-artZoom-show" title="',
						that.title,
						'" alt="',
						that.alt,
						'" src="',
						show,
						'" style="width:',
						width,
						'px;height:',
						height, // IE8 瓒呴暱鍥剧墖height灞炴€уけ鏁圔UG锛屾敼鐢–SS
						'px;position:absolute;left:0;top:0;background:transparent"',
					' />'
				].join(''));
				
				$show = $artZoom.find('.ui-artZoom-show');
				$thumb.attr('class', 'ui-artZoom-show');
				
				$artZoom.addClass('ui-artZoom-ready');
				$artZoom.find('.ui-artZoom-buttons').show();
				$this.data('artZoom-ready', true);
				$this.hide();
				$box.show();
				
			// 澶у浘瀹屽叏鍔犺浇瀹屾瘯
			}, function () {
				$thumb.removeAttr('class').hide();
				$show.css({
					position: 'static',
					left: 'auto',
					top: 'auto'
				});
				
				$artZoom.removeClass('ui-artZoom-noLoad');
				$artZoom.find('.ui-artZoom-loading').hide();
				$this.data('artZoom-load', true);
			
			// 鍥剧墖鍔犺浇閿欒
			}, function () {
				$artZoom.addClass('ui-artZoom-error');
				log('jQuery.fn.artZoom: Load "' + show + '" Error!');
			});
			
		} else {
			$this.hide();
		};
		
		$artZoom = $this.data('artZoom');
		buttonClick = function (event) {
			var target = this,
				go = target.getAttribute('data-go'),
				live = target.getAttribute('data-live'),
				degree = $this.data('artZoom-degree') || 0,
				elem = $artZoom.find('.ui-artZoom-show')[0];
				
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
					window.open(source || show || src);
					break;
				case 'hide':
					$this.show();
					$artZoom.find('.ui-artZoom-toolbar').hide();
					$artZoom.hide();
					$artZoom.find('[data-go]').die('click', buttonClick);
					break;
			};
			
			if ((go === 'left' || go === 'right') && $this.data('artZoom-load')) {
				imgRotate(elem, degree, maxWidth, maxHeight);
				$this.data('artZoom-degree', degree);
			};
			
			return false;
		};
		$artZoom.show().find('.ui-artZoom-toolbar').slideDown(150);
		$artZoom.find('[data-go]').live('click', buttonClick);
			
		return false;
	});
	
	// 缁欑洰鏍囩缉鐣ュ浘搴旂敤澶栭儴鎸囬拡鏍峰紡
	this.live('mouseover', function () {
		if (this.className !== 'ui-artZoom-show') this.style.cursor = max;
	});
	
	// 棰勫姞杞芥寚閽堝舰鐘跺浘鏍?
	if (this[0]) this[0].style.cursor = max;
	
	return this;
};
$.fn.artZoom.defaults = {
	path: './images',
	left: '\u5de6\u65cb\u8f6c',
	right: '\u53f3\u65cb\u8f6c',
	source: '\u770b\u539f\u56fe',
	hide: '\xd7',
	blur: true,
	preload: true,
	maxWidth: null,
	maxHeight: null,
	borderWidth: 18
};

/**
 * 鍥剧墖鏃嬭浆
 * @version	2011.05.27
 * @author	TangBin
 * @param	{HTMLElement}	鍥剧墖鍏冪礌
 * @param	{Number}		鏃嬭浆瑙掑害 (鍙敤鍊? 0, 90, 180, 270)
 * @param	{Number}		鏈€澶у搴﹂檺鍒?
 * @param	{Number}		鏈€澶ч珮搴﹂檺鍒?
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
		
		// 鍒濇杩愯
		if (!elem[eCanvas]) {
			
			// 鑾峰彇鍥惧儚鏈簲鐢ㄦ牱寮忕殑鐪熷疄澶у皬 (IE鍜孫pera鏃╂湡鐗堟湰)
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
			canvas.style.height = height + 'px';// 瑙ｅ喅IE8浣跨敤婊ら暅鍚庨珮搴︿笉鑳借嚜閫傚簲
			canvas.img.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + degree / 90 + ')';
			canvas.img.width = elem.width * resize;
			canvas.img.height = elem.height * resize;
		};
	};
}();

/**
 * 鍥剧墖澶存暟鎹姞杞藉氨缁簨浠?- 鏇村揩鑾峰彇鍥剧墖灏哄
 * @version	2011.05.27
 * @author	TangBin
 * @see		http://www.planeart.cn/?p=1121
 * @param	{String}	鍥剧墖璺緞
 * @param	{Function}	灏哄灏辩华
 * @param	{Function}	鍔犺浇瀹屾瘯 (鍙€?
 * @param	{Function}	鍔犺浇閿欒 (鍙€?
 * @example imgReady('http://www.google.com.hk/intl/zh-CN/images/logo_cn_wev8.png', function () {
		alert('size ready: width=' + this.width + '; height=' + this.height);
	});
 */
var imgReady = (function () {
	var list = [], intervalId = null,

	// 鐢ㄦ潵鎵ц闃熷垪
	tick = function () {
		var i = 0;
		for (; i < list.length; i++) {
			list[i].end ? list.splice(i--, 1) : list[i]();
		};
		!list.length && stop();
	},

	// 鍋滄鎵€鏈夊畾鏃跺櫒闃熷垪
	stop = function () {
		clearInterval(intervalId);
		intervalId = null;
	};

	return function (url, ready, load, error) {
		var onready, width, height, newWidth, newHeight,
			img = new Image();
		
		img.src = url;

		// 濡傛灉鍥剧墖琚紦瀛橈紝鍒欑洿鎺ヨ繑鍥炵紦瀛樻暟鎹?
		if (img.complete) {
			ready.call(img);
			load && load.call(img);
			return;
		};
		
		width = img.width;
		height = img.height;
		
		// 鍔犺浇閿欒鍚庣殑浜嬩欢
		img.onerror = function () {
			error && error.call(img);
			onready.end = true;
			img = img.onload = img.onerror = null;
		};
		
		// 鍥剧墖灏哄灏辩华
		onready = function () {
			newWidth = img.width;
			newHeight = img.height;
			if (newWidth !== width || newHeight !== height ||
				// 濡傛灉鍥剧墖宸茬粡鍦ㄥ叾浠栧湴鏂瑰姞杞藉彲浣跨敤闈㈢Н妫€娴?
				newWidth * newHeight > 1024
			) {
				ready.call(img);
				onready.end = true;
			};
		};
		onready();
		
		// 瀹屽叏鍔犺浇瀹屾瘯鐨勪簨浠?
		img.onload = function () {
			// onload鍦ㄥ畾鏃跺櫒鏃堕棿宸寖鍥村唴鍙兘姣攐nready蹇?
			// 杩欓噷杩涜妫€鏌ュ苟淇濊瘉onready浼樺厛鎵ц
			!onready.end && onready();
		
			load && load.call(img);
			
			// IE gif鍔ㄧ敾浼氬惊鐜墽琛宱nload锛岀疆绌簅nload鍗冲彲
			img = img.onload = img.onerror = null;
		};

		// 鍔犲叆闃熷垪涓畾鏈熸墽琛?
		if (!onready.end) {
			list.push(onready);
			// 鏃犺浣曟椂鍙厑璁稿嚭鐜颁竴涓畾鏃跺櫒锛屽噺灏戞祻瑙堝櫒鎬ц兘鎹熻€?
			if (intervalId === null) intervalId = setInterval(tick, 40);
		};
	};
})();

}(document, jQuery, function (msg) {window.console && console.log(msg)}));
