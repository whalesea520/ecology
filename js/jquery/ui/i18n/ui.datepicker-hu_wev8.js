/* Hungarian initialisation for the jQuery UI date picker plugin. */
/* Written by Istvan Karaszi (jquerycalendar@spam.raszi.hu). */
jQuery(function($){
	$.datepicker.regional['hu'] = {
		closeText: 'bez谩r谩s',
		prevText: '&laquo;&nbsp;vissza',
		nextText: 'el艖re&nbsp;&raquo;',
		currentText: 'ma',
		monthNames: ['Janu谩r', 'Febru谩r', 'M谩rcius', '脕prilis', 'M谩jus', 'J煤nius',
		'J煤lius', 'Augusztus', 'Szeptember', 'Okt贸ber', 'November', 'December'],
		monthNamesShort: ['Jan', 'Feb', 'M谩r', '脕pr', 'M谩j', 'J煤n',
		'J煤l', 'Aug', 'Szep', 'Okt', 'Nov', 'Dec'],
		dayNames: ['Vas谩map', 'H茅tf枚', 'Kedd', 'Szerda', 'Cs眉t枚rt枚k', 'P茅ntek', 'Szombat'],
		dayNamesShort: ['Vas', 'H茅t', 'Ked', 'Sze', 'Cs眉', 'P茅n', 'Szo'],
		dayNamesMin: ['V', 'H', 'K', 'Sze', 'Cs', 'P', 'Szo'],
		dateFormat: 'yy-mm-dd', firstDay: 1,
		isRTL: false};
	$.datepicker.setDefaults($.datepicker.regional['hu']);
});
