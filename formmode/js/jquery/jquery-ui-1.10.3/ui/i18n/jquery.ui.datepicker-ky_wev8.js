/* Kyrgyz (UTF-8) initialisation for the jQuery UI date picker plugin. */
/* Written by Sergey Kartashov (ebishkek@yandex.ru). */
jQuery(function($){
	$.datepicker.regional['ky'] = {
		closeText: '袞邪斜褍褍',
		prevText: '&#x3c;袦褍褉',
		nextText: '袣懈泄&#x3e;',
		currentText: '袘爷谐爷薪',
		monthNames: ['携薪胁邪褉褜','肖械胁褉邪谢褜','袦邪褉褌','袗锌褉械谢褜','袦邪泄','袠褞薪褜',
		'袠褞谢褜','袗胁谐褍褋褌','小械薪褌褟斜褉褜','袨泻褌褟斜褉褜','袧芯褟斜褉褜','袛械泻邪斜褉褜'],
		monthNamesShort: ['携薪胁','肖械胁','袦邪褉','袗锌褉','袦邪泄','袠褞薪',
		'袠褞谢','袗胁谐','小械薪','袨泻褌','袧芯褟','袛械泻'],
		dayNames: ['卸械泻褕械屑斜懈', '写爷泄褕萤屑斜爷', '褕械泄褕械屑斜懈', '褕邪褉褕械屑斜懈', '斜械泄褕械屑斜懈', '卸褍屑邪', '懈褕械屑斜懈'],
		dayNamesShort: ['卸械泻', '写爷泄', '褕械泄', '褕邪褉', '斜械泄', '卸褍屑', '懈褕械'],
		dayNamesMin: ['袞泻','袛褕','楔褕','楔褉','袘褕','袞屑','袠褕'],
		weekHeader: '袞褍屑',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''
	};
	$.datepicker.setDefaults($.datepicker.regional['ky']);
});
