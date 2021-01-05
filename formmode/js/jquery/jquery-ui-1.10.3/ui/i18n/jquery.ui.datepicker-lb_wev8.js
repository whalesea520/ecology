/* Luxembourgish initialisation for the jQuery UI date picker plugin. */
/* Written by Michel Weimerskirch <michel@weimerskirch.net> */
jQuery(function($){
	$.datepicker.regional['lb'] = {
		closeText: 'F盲erdeg',
		prevText: 'Zr茅ck',
		nextText: 'Weider',
		currentText: 'Haut',
		monthNames: ['Januar','Februar','M盲erz','Abr毛ll','Mee','Juni',
		'Juli','August','September','Oktober','November','Dezember'],
		monthNamesShort: ['Jan', 'Feb', 'M盲e', 'Abr', 'Mee', 'Jun',
		'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'],
		dayNames: ['Sonndeg', 'M茅indeg', 'D毛nschdeg', 'M毛ttwoch', 'Donneschdeg', 'Freideg', 'Samschdeg'],
		dayNamesShort: ['Son', 'M茅i', 'D毛n', 'M毛t', 'Don', 'Fre', 'Sam'],
		dayNamesMin: ['So','M茅','D毛','M毛','Do','Fr','Sa'],
		weekHeader: 'W',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['lb']);
});
