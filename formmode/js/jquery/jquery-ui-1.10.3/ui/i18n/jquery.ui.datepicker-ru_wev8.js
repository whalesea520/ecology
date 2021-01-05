/* Russian (UTF-8) initialisation for the jQuery UI date picker plugin. */
/* Written by Andrew Stromnov (stromnov@gmail.com). */
jQuery(function($){
	$.datepicker.regional['ru'] = {
		closeText: '袟邪泻褉褘褌褜',
		prevText: '&#x3C;袩褉械写',
		nextText: '小谢械写&#x3E;',
		currentText: '小械谐芯写薪褟',
		monthNames: ['携薪胁邪褉褜','肖械胁褉邪谢褜','袦邪褉褌','袗锌褉械谢褜','袦邪泄','袠褞薪褜',
		'袠褞谢褜','袗胁谐褍褋褌','小械薪褌褟斜褉褜','袨泻褌褟斜褉褜','袧芯褟斜褉褜','袛械泻邪斜褉褜'],
		monthNamesShort: ['携薪胁','肖械胁','袦邪褉','袗锌褉','袦邪泄','袠褞薪',
		'袠褞谢','袗胁谐','小械薪','袨泻褌','袧芯褟','袛械泻'],
		dayNames: ['胁芯褋泻褉械褋械薪褜械','锌芯薪械写械谢褜薪懈泻','胁褌芯褉薪懈泻','褋褉械写邪','褔械褌胁械褉谐','锌褟褌薪懈褑邪','褋褍斜斜芯褌邪'],
		dayNamesShort: ['胁褋泻','锌薪写','胁褌褉','褋褉写','褔褌胁','锌褌薪','褋斜褌'],
		dayNamesMin: ['袙褋','袩薪','袙褌','小褉','效褌','袩褌','小斜'],
		weekHeader: '袧械写',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['ru']);
});
