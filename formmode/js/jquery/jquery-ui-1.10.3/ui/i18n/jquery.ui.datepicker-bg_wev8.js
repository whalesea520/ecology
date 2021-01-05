/* Bulgarian initialisation for the jQuery UI date picker plugin. */
/* Written by Stoyan Kyosev (http://svest.org). */
jQuery(function($){
	$.datepicker.regional['bg'] = {
		closeText: '蟹邪褌胁芯褉懈',
		prevText: '&#x3C;薪邪蟹邪写',
		nextText: '薪邪锌褉械写&#x3E;',
		nextBigText: '&#x3E;&#x3E;',
		currentText: '写薪械褋',
		monthNames: ['携薪褍邪褉懈','肖械胁褉褍邪褉懈','袦邪褉褌','袗锌褉懈谢','袦邪泄','挟薪懈',
		'挟谢懈','袗胁谐褍褋褌','小械锌褌械屑胁褉懈','袨泻褌芯屑胁褉懈','袧芯械屑胁褉懈','袛械泻械屑胁褉懈'],
		monthNamesShort: ['携薪褍','肖械胁','袦邪褉','袗锌褉','袦邪泄','挟薪懈',
		'挟谢懈','袗胁谐','小械锌','袨泻褌','袧芯胁','袛械泻'],
		dayNames: ['袧械写械谢褟','袩芯薪械写械谢薪懈泻','袙褌芯褉薪懈泻','小褉褟写邪','效械褌胁褗褉褌褗泻','袩械褌褗泻','小褗斜芯褌邪'],
		dayNamesShort: ['袧械写','袩芯薪','袙褌芯','小褉褟','效械褌','袩械褌','小褗斜'],
		dayNamesMin: ['袧械','袩芯','袙褌','小褉','效械','袩械','小褗'],
		weekHeader: 'Wk',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['bg']);
});
