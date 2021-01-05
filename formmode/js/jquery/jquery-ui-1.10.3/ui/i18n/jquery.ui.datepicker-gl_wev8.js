/* Galician localization for 'UI date picker' jQuery extension. */
/* Translated by Jorge Barreiro <yortx.barry@gmail.com>. */
jQuery(function($){
	$.datepicker.regional['gl'] = {
		closeText: 'Pechar',
		prevText: '&#x3C;Ant',
		nextText: 'Seg&#x3E;',
		currentText: 'Hoxe',
		monthNames: ['Xaneiro','Febreiro','Marzo','Abril','Maio','Xu帽o',
		'Xullo','Agosto','Setembro','Outubro','Novembro','Decembro'],
		monthNamesShort: ['Xan','Feb','Mar','Abr','Mai','Xu帽',
		'Xul','Ago','Set','Out','Nov','Dec'],
		dayNames: ['Domingo','Luns','Martes','M茅rcores','Xoves','Venres','S谩bado'],
		dayNamesShort: ['Dom','Lun','Mar','M茅r','Xov','Ven','S谩b'],
		dayNamesMin: ['Do','Lu','Ma','M茅','Xo','Ve','S谩'],
		weekHeader: 'Sm',
		dateFormat: 'dd/mm/yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['gl']);
});
