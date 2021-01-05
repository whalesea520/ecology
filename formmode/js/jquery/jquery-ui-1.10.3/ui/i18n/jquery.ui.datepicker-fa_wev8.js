/* Persian (Farsi) Translation for the jQuery UI date picker plugin. */
/* Javad Mowlanezhad -- jmowla@gmail.com */
/* Jalali calendar should supported soon! (Its implemented but I have to test it) */
jQuery(function($) {
	$.datepicker.regional['fa'] = {
		closeText: '亘爻鬲賳',
		prevText: '&#x3C;賯亘賱蹖',
		nextText: '亘毓丿蹖&#x3E;',
		currentText: '丕賲乇賵夭',
		monthNames: [
			'賮乇賵乇丿賷賳',
			'丕乇丿賷亘賴卮鬲',
			'禺乇丿丕丿',
			'鬲賷乇',
			'賲乇丿丕丿',
			'卮賴乇賷賵乇',
			'賲賴乇',
			'丌亘丕賳',
			'丌匕乇',
			'丿蹖',
			'亘賴賲賳',
			'丕爻賮賳丿'
		],
		monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
		dayNames: [
			'賷讴卮賳亘賴',
			'丿賵卮賳亘賴',
			'爻賴鈥屫促嗀ㄙ?,
			'趩賴丕乇卮賳亘賴',
			'倬賳噩卮賳亘賴',
			'噩賲毓賴',
			'卮賳亘賴'
		],
		dayNamesShort: [
			'蹖',
			'丿',
			'爻',
			'趩',
			'倬',
			'噩',
			'卮'
		],
		dayNamesMin: [
			'蹖',
			'丿',
			'爻',
			'趩',
			'倬',
			'噩',
			'卮'
		],
		weekHeader: '賴賮',
		dateFormat: 'yy/mm/dd',
		firstDay: 6,
		isRTL: true,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['fa']);
});
