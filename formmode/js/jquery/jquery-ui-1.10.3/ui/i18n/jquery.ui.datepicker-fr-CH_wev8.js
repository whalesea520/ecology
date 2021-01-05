/* Swiss-French initialisation for the jQuery UI date picker plugin. */
/* Written Martin Voelkle (martin.voelkle@e-tc.ch). */
jQuery(function($){
	$.datepicker.regional['fr-CH'] = {
		closeText: 'Fermer',
		prevText: '&#x3C;Pr茅c',
		nextText: 'Suiv&#x3E;',
		currentText: 'Courant',
		monthNames: ['Janvier','F茅vrier','Mars','Avril','Mai','Juin',
		'Juillet','Ao没t','Septembre','Octobre','Novembre','D茅cembre'],
		monthNamesShort: ['Jan','F茅v','Mar','Avr','Mai','Jun',
		'Jul','Ao没','Sep','Oct','Nov','D茅c'],
		dayNames: ['Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi'],
		dayNamesShort: ['Dim','Lun','Mar','Mer','Jeu','Ven','Sam'],
		dayNamesMin: ['Di','Lu','Ma','Me','Je','Ve','Sa'],
		weekHeader: 'Sm',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['fr-CH']);
});
