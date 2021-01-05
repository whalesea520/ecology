/* Czech initialisation for the jQuery UI date picker plugin. */
/* Written by Tomas Muller (tomas@tomas-muller.net). */
jQuery(function($){
	$.datepicker.regional['cs'] = {
		closeText: 'Zav艡铆t',
		prevText: '&#x3C;D艡铆ve',
		nextText: 'Pozd臎ji&#x3E;',
		currentText: 'Nyn铆',
		monthNames: ['leden','煤nor','b艡ezen','duben','kv臎ten','膷erven',
		'膷ervenec','srpen','z谩艡铆','艡铆jen','listopad','prosinec'],
		monthNamesShort: ['led','煤no','b艡e','dub','kv臎','膷er',
		'膷vc','srp','z谩艡','艡铆j','lis','pro'],
		dayNames: ['ned臎le', 'pond臎l铆', '煤ter媒', 'st艡eda', '膷tvrtek', 'p谩tek', 'sobota'],
		dayNamesShort: ['ne', 'po', '煤t', 'st', '膷t', 'p谩', 'so'],
		dayNamesMin: ['ne','po','煤t','st','膷t','p谩','so'],
		weekHeader: 'T媒d',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['cs']);
});
