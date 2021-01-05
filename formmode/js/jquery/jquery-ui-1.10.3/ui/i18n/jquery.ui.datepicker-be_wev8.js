﻿/* Belarusian initialisation for the jQuery UI date picker plugin. */
/* Written by Pavel Selitskas <p.selitskas@gmail.com> */
jQuery(function($){
	$.datepicker.regional['be'] = {
		closeText: '袟邪褔褘薪褨褑褜',
		prevText: '&larr;袩邪锌褟褉.',
		nextText: '袧邪褋褌.&rarr;',
		currentText: '小褢薪褜薪褟',
		monthNames: ['小褌褍写蟹械薪褜','袥褞褌褘','小邪泻邪胁褨泻','袣褉邪褋邪胁褨泻','孝褉邪胁械薪褜','效褝褉胁械薪褜',
		'袥褨锌械薪褜','袞薪褨胁械薪褜','袙械褉邪褋械薪褜','袣邪褋褌褉褘褔薪褨泻','袥褨褋褌邪锌邪写','小褜薪械卸邪薪褜'],
		monthNamesShort: ['小褌褍','袥褞褌','小邪泻','袣褉邪','孝褉邪','效褝褉',
		'袥褨锌','袞薪褨','袙械褉','袣邪褋','袥褨褋','小褜薪'],
		dayNames: ['薪褟写蟹械谢褟','锌邪薪褟写蟹械谢邪泻','邪褳褌芯褉邪泻','褋械褉邪写邪','褔邪褑褜胁械褉','锌褟褌薪褨褑邪','褋褍斜芯褌邪'],
		dayNamesShort: ['薪写蟹','锌薪写','邪褳褌','褋褉写','褔褑胁','锌褌薪','褋斜褌'],
		dayNamesMin: ['袧写','袩薪','袗褳','小褉','效褑','袩褌','小斜'],
		weekHeader: '孝写',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['be']);
});