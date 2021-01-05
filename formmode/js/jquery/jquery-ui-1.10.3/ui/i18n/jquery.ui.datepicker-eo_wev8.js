/* Esperanto initialisation for the jQuery UI date picker plugin. */
/* Written by Olivier M. (olivierweb@ifrance.com). */
jQuery(function($){
	$.datepicker.regional['eo'] = {
		closeText: 'Fermi',
		prevText: '&#x3C;Anta',
		nextText: 'Sekv&#x3E;',
		currentText: 'Nuna',
		monthNames: ['Januaro','Februaro','Marto','Aprilo','Majo','Junio',
		'Julio','A怒gusto','Septembro','Oktobro','Novembro','Decembro'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','Maj','Jun',
		'Jul','A怒g','Sep','Okt','Nov','Dec'],
		dayNames: ['Diman膲o','Lundo','Mardo','Merkredo','拇a怒do','Vendredo','Sabato'],
		dayNamesShort: ['Dim','Lun','Mar','Mer','拇a怒','Ven','Sab'],
		dayNamesMin: ['Di','Lu','Ma','Me','拇a','Ve','Sa'],
		weekHeader: 'Sb',
		dateFormat: 'dd/mm/yy',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['eo']);
});
