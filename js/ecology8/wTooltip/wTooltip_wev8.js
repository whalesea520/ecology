/******************************************
 * Websanova.com
 *
 * Resources for web entrepreneurs
 *
 * @author          Websanova
 * @copyright       Copyright (c) 2012 Websanova.
 * @license         This wTooltip jQuery plug-in is dual licensed under the MIT and GPL licenses.
 * @link            http://www.websanova.com
 * @github			http://github.com/websanova/wTooltip
 * @version         Version 1.8.0
 *
 ******************************************/
(function($)
{
	$.fn.wTooltip = function(option)
	{
		if(typeof option === "string"){
			jQuery(this).poshytip(option);
			return;
		}
		option = jQuery.extend({
			className: 'tip-yellowsimple',
			showTimeout: 1,
			alignTo: 'target',
			alignX: 'center',
			alignY: 'bottom',
			offsetY: 0,
			offsetX: 0,
			allowTipHover: true,
			fade: true,
			slide: true
		},option);
		jQuery(this).poshytip(option);
	}
})(jQuery);
