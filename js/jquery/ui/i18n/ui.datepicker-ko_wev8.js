/* Korean initialisation for the jQuery calendar extension. */
/* Written by DaeKwon Kang (ncrash.dk@gmail.com). */
jQuery(function($){
	$.datepicker.regional['ko'] = {
		closeText: '雼赴',
		prevText: '鞚挫爠雼?,
		nextText: '雼れ潓雼?,
		currentText: '鞓る姌',
		monthNames: ['1鞗?JAN)','2鞗?FEB)','3鞗?MAR)','4鞗?APR)','5鞗?MAY)','6鞗?JUN)',
		'7鞗?JUL)','8鞗?AUG)','9鞗?SEP)','10鞗?OCT)','11鞗?NOV)','12鞗?DEC)'],
		monthNamesShort: ['1鞗?JAN)','2鞗?FEB)','3鞗?MAR)','4鞗?APR)','5鞗?MAY)','6鞗?JUN)',
		'7鞗?JUL)','8鞗?AUG)','9鞗?SEP)','10鞗?OCT)','11鞗?NOV)','12鞗?DEC)'],
		dayNames: ['鞚?,'鞗?,'頇?,'靾?,'氇?,'旮?,'韱?],
		dayNamesShort: ['鞚?,'鞗?,'頇?,'靾?,'氇?,'旮?,'韱?],
		dayNamesMin: ['鞚?,'鞗?,'頇?,'靾?,'氇?,'旮?,'韱?],
		dateFormat: 'yy-mm-dd', firstDay: 0,
		isRTL: false};
	$.datepicker.setDefaults($.datepicker.regional['ko']);
});