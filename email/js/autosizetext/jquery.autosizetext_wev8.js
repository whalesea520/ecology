(function($) {

	$.fn.autogrow = function(options) {

		var defaults = {

			minHeight : 35,

			maxHeight : 9999

		};

		var options = $.extend(defaults, options);

		return this.each(function() {

			var element = $(this);

			// 上一次文本框内容长度和宽度

			var lastValLength, lastWidth;

			// 文本框内容长度、宽度和高度

			var valLength, width, height;

			// 验证页面元素是textarea

			if (!element.is('textarea')) {

				return;

			}

			element.css('overflow', 'hidden');// 设置超出范围的文字隐藏

			element.bind('keyup input propertychange', function() {
				doAutoGrow($(this),options)
			});
						
			
			

		});

	}
	function doAutoGrow(obj,options){
			
			var lastValLength, lastWidth;
	
			// 文本框内容长度、宽度和高度
	
			var valLength, width, height;
			// 获取文本框内容长度

			valLength = obj.val().length;

			// 获取输入框的宽度

			// 我这里使用的jquery版本是1.8，获取css属性的方法已经变成了prop

			// 如果使用1.6以下版本的jquery，以下代码要变为 width =
			// $(this).attr('offsetWidth');

			// $(this).prop('scrollHeight')也要变为：$(this).attr('scrollHeight')

			width = obj.attr('offsetWidth');

			// 有文字删除操作，或者文本框宽度变化的时候，先将文本框高度设置为0

			if (valLength < lastValLength || width != lastWidth) {

				obj.height(0);

			}

			// 计算适合的文本框高度

			height = Math.max(options.minHeight, Math.min(obj
					.attr('scrollHeight'), options.maxHeight));

			// 如果当前文本框的高度超过我们允许的最大高度的时候，隐藏多余文字；否则设置为auto

			// $(this).prop('scrollHeight') > height
			// 只有在height取得的值是options.maxHeight才有意义

			obj.css(
					'overflow',
					(obj.attr('scrollHeight') > height ? 'auto'
							: 'hidden'))

			.height(height); // 设置文本框高度

			lastValLength = valLength;

			lastWidth = width;

		
	}

})(jQuery);