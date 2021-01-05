/* Macedonian i18n for the jQuery UI date picker plugin. */
/* Written by Stojce Slavkovski. */
jQuery(function($){
	$.datepicker.regional['mk'] = {
		closeText: '袟邪褌胁芯褉懈',
		prevText: '&#x3C;',
		nextText: '&#x3E;',
		currentText: '袛械薪械褋',
		monthNames: ['袌邪薪褍邪褉懈','肖械胁褉褍邪褉懈','袦邪褉褌','袗锌褉懈谢','袦邪褬','袌褍薪懈',
		'袌褍谢懈','袗胁谐褍褋褌','小械锌褌械屑胁褉懈','袨泻褌芯屑胁褉懈','袧芯械屑胁褉懈','袛械泻械屑胁褉懈'],
		monthNamesShort: ['袌邪薪','肖械胁','袦邪褉','袗锌褉','袦邪褬','袌褍薪',
		'袌褍谢','袗胁谐','小械锌','袨泻褌','袧芯械','袛械泻'],
		dayNames: ['袧械写械谢邪','袩芯薪械写械谢薪懈泻','袙褌芯褉薪懈泻','小褉械写邪','效械褌胁褉褌芯泻','袩械褌芯泻','小邪斜芯褌邪'],
		dayNamesShort: ['袧械写','袩芯薪','袙褌芯','小褉械','效械褌','袩械褌','小邪斜'],
		dayNamesMin: ['袧械','袩芯','袙褌','小褉','效械','袩械','小邪'],
		weekHeader: '小械写',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['mk']);
});
