/* Korean initialisation for the jQuery calendar extension. */
/* Written by DaeKwon Kang (ncrash.dk@gmail.com), Edited by Genie. */
jQuery(function($){
	$.datepicker.regional['ko'] = {
		closeText: '雼赴',
		prevText: '鞚挫爠雼?,
		nextText: '雼れ潓雼?,
		currentText: '鞓る姌',
		monthNames: ['1鞗?,'2鞗?,'3鞗?,'4鞗?,'5鞗?,'6鞗?,
		'7鞗?,'8鞗?,'9鞗?,'10鞗?,'11鞗?,'12鞗?],
		monthNamesShort: ['1鞗?,'2鞗?,'3鞗?,'4鞗?,'5鞗?,'6鞗?,
		'7鞗?,'8鞗?,'9鞗?,'10鞗?,'11鞗?,'12鞗?],
		dayNames: ['鞚检殧鞚?,'鞗旍殧鞚?,'頇旍殧鞚?,'靾橃殧鞚?,'氇╈殧鞚?,'旮堨殧鞚?,'韱犾殧鞚?],
		dayNamesShort: ['鞚?,'鞗?,'頇?,'靾?,'氇?,'旮?,'韱?],
		dayNamesMin: ['鞚?,'鞗?,'頇?,'靾?,'氇?,'旮?,'韱?],
		weekHeader: 'Wk',
		dateFormat: 'yy-mm-dd',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: true,
		yearSuffix: '雲?};
	$.datepicker.setDefaults($.datepicker.regional['ko']);
});
