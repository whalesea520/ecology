/* Hungarian initialisation for the jQuery UI date picker plugin. */
/* Written by Istvan Karaszi (jquery@spam.raszi.hu). */
jQuery(function($){
	$.datepicker.regional['hu'] = {
		closeText: 'bez谩r',
		prevText: 'vissza',
		nextText: 'el艖re',
		currentText: 'ma',
		monthNames: ['Janu谩r', 'Febru谩r', 'M谩rcius', '脕prilis', 'M谩jus', 'J煤nius',
		'J煤lius', 'Augusztus', 'Szeptember', 'Okt贸ber', 'November', 'December'],
		monthNamesShort: ['Jan', 'Feb', 'M谩r', '脕pr', 'M谩j', 'J煤n',
		'J煤l', 'Aug', 'Szep', 'Okt', 'Nov', 'Dec'],
		dayNames: ['Vas谩rnap', 'H茅tf艖', 'Kedd', 'Szerda', 'Cs眉t枚rt枚k', 'P茅ntek', 'Szombat'],
		dayNamesShort: ['Vas', 'H茅t', 'Ked', 'Sze', 'Cs眉', 'P茅n', 'Szo'],
		dayNamesMin: ['V', 'H', 'K', 'Sze', 'Cs', 'P', 'Szo'],
		weekHeader: 'H茅t',
		dateFormat: 'yy.mm.dd.',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: true,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['hu']);
});
