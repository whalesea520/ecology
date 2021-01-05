/* Canadian-French initialisation for the jQuery UI date picker plugin. */
jQuery(function ($) {
	$.datepicker.regional['fr-CA'] = {
		closeText: 'Fermer',
		prevText: 'Pr茅c茅dent',
		nextText: 'Suivant',
		currentText: 'Aujourd\'hui',
		monthNames: ['janvier', 'f茅vrier', 'mars', 'avril', 'mai', 'juin',
			'juillet', 'ao没t', 'septembre', 'octobre', 'novembre', 'd茅cembre'],
		monthNamesShort: ['janv.', 'f茅vr.', 'mars', 'avril', 'mai', 'juin',
			'juil.', 'ao没t', 'sept.', 'oct.', 'nov.', 'd茅c.'],
		dayNames: ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'],
		dayNamesShort: ['dim.', 'lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.'],
		dayNamesMin: ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
		weekHeader: 'Sem.',
		dateFormat: 'yy-mm-dd',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''
	};
	$.datepicker.setDefaults($.datepicker.regional['fr-CA']);
});
