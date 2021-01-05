/**  * textarea 自动变长  *  * @author     Akon(番茄红了) <aultoale@gmail.com>  * @copyright  Copyright (c) 2008 (http://www.tblog.com.cn)  * @license    http://www.gnu.org/licenses/gpl.html     GPL 3  *  * $('textarea').autogrow();  *  * @params {minLines, lineHeight, overflow, restore}  * minLines   : 最少显示的行数  * lineHeight : 行高  * overflow   : 超出部分的显示方式  * restore    : 失去焦点时是否恢复高度  */
$.fn.autogrow = function(params) {
	this.filter('textarea').each(function() {
		var options = {
			minLines: 10,
			lineHeight: parseInt($(this).css('lineHeight')),
			overflow: $(this).css('overflow'),
			restore: true
		};
		$.extend(options, params);
		var minHeight = options.lineHeight * options.minLines;
		if ($.browser.msie) {
			minHeight -= 1;
		}
		$(this).height(minHeight).css('overflow', options.overflow).css('lineHeight', options.lineHeight + 'px');
		var update = function() {
			var height = this.value.split('\n').length * options.lineHeight;
			if ($.browser.msie) {
				height -= 1;
			}
			$(this).height(Math.max(minHeight, height));
		};
		$(this).change(update).keyup(update).keydown(update).click(update);
		if (options.restore) {
			$(this).blur(function() {
				$(this).css('height', minHeight)
			});
		}
	});
	return this;
};