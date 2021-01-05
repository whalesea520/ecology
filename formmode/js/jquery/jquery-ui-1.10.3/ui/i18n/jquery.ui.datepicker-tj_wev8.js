/* Tajiki (UTF-8) initialisation for the jQuery UI date picker plugin. */
/* Written by Abdurahmon Saidov (saidovab@gmail.com). */
jQuery(function($){
	$.datepicker.regional['tj'] = {
		closeText: '袠写芯屑邪',
		prevText: '&#x3c;覛邪褎芯',
		nextText: '袩械褕&#x3e;',
		currentText: '袠屑褉盈蟹',
		monthNames: ['携薪胁邪褉','肖械胁褉邪谢','袦邪褉褌','袗锌褉械谢','袦邪泄','袠褞薪',
		'袠褞谢','袗胁谐褍褋褌','小械薪褌褟斜褉','袨泻褌褟斜褉','袧芯褟斜褉','袛械泻邪斜褉'],
		monthNamesShort: ['携薪胁','肖械胁','袦邪褉','袗锌褉','袦邪泄','袠褞薪',
		'袠褞谢','袗胁谐','小械薪','袨泻褌','袧芯褟','袛械泻'],
		dayNames: ['褟泻褕邪薪斜械','写褍褕邪薪斜械','褋械褕邪薪斜械','褔芯褉褕邪薪斜械','锌邪薪曳褕邪薪斜械','曳褍屑褗邪','褕邪薪斜械'],
		dayNamesShort: ['褟泻褕','写褍褕','褋械褕','褔芯褉','锌邪薪','曳褍屑','褕邪薪'],
		dayNamesMin: ['携泻','袛褕','小褕','效褕','袩褕','叶屑','楔薪'],
		weekHeader: '啸褎',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['tj']);
});
