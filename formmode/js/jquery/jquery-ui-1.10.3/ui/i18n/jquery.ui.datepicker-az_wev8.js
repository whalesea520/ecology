/* Azerbaijani (UTF-8) initialisation for the jQuery UI date picker plugin. */
/* Written by Jamil Najafov (necefov33@gmail.com). */
jQuery(function($) {
	$.datepicker.regional['az'] = {
		closeText: 'Ba臒la',
		prevText: '&#x3C;Geri',
		nextText: '陌r蓹li&#x3E;',
		currentText: 'Bug眉n',
		monthNames: ['Yanvar','Fevral','Mart','Aprel','May','陌yun',
		'陌yul','Avqust','Sentyabr','Oktyabr','Noyabr','Dekabr'],
		monthNamesShort: ['Yan','Fev','Mar','Apr','May','陌yun',
		'陌yul','Avq','Sen','Okt','Noy','Dek'],
		dayNames: ['Bazar','Bazar ert蓹si','脟蓹r艧蓹nb蓹 ax艧am谋','脟蓹r艧蓹nb蓹','C眉m蓹 ax艧am谋','C眉m蓹','艦蓹nb蓹'],
		dayNamesShort: ['B','Be','脟a','脟','Ca','C','艦'],
		dayNamesMin: ['B','B','脟','小','脟','C','艦'],
		weekHeader: 'Hf',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['az']);
});
