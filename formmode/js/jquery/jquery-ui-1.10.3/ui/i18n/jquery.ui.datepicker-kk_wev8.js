/* Kazakh (UTF-8) initialisation for the jQuery UI date picker plugin. */
/* Written by Dmitriy Karasyov (dmitriy.karasyov@gmail.com). */
jQuery(function($){
	$.datepicker.regional['kk'] = {
		closeText: '袞邪斜褍',
		prevText: '&#x3C;袗谢写褘遥覔褘',
		nextText: '袣械谢械褋褨&#x3E;',
		currentText: '袘爷谐褨薪',
		monthNames: ['覛邪遥褌邪褉','袗覜锌邪薪','袧邪褍褉褘蟹','小訖褍褨褉','袦邪屑褘褉','袦邪褍褋褘屑',
		'楔褨谢写械','孝邪屑褘蟹','覛褘褉泻爷泄械泻','覛邪蟹邪薪','覛邪褉邪褕邪','袞械谢褌芯覜褋邪薪'],
		monthNamesShort: ['覛邪遥','袗覜锌','袧邪褍','小訖褍','袦邪屑','袦邪褍',
		'楔褨谢','孝邪屑','覛褘褉','覛邪蟹','覛邪褉','袞械谢'],
		dayNames: ['袞械泻褋械薪斜褨','袛爷泄褋械薪斜褨','小械泄褋械薪斜褨','小訖褉褋械薪斜褨','袘械泄褋械薪斜褨','袞冶屑邪','小械薪斜褨'],
		dayNamesShort: ['卸泻褋','写褋薪','褋褋薪','褋褉褋','斜褋薪','卸屑邪','褋薪斜'],
		dayNamesMin: ['袞泻','袛褋','小褋','小褉','袘褋','袞屑','小薪'],
		weekHeader: '袧械',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['kk']);
});
