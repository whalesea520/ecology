/* Lithuanian (UTF-8) initialisation for the jQuery UI date picker plugin. */
/* @author Arturas Paleicikas <arturas@avalon.lt> */
jQuery(function($){
	$.datepicker.regional['lt'] = {
		closeText: 'U啪daryti',
		prevText: '&#x3C;Atgal',
		nextText: 'Pirmyn&#x3E;',
		currentText: '艩iandien',
		monthNames: ['Sausis','Vasaris','Kovas','Balandis','Gegu啪臈','Bir啪elis',
		'Liepa','Rugpj奴tis','Rugs臈jis','Spalis','Lapkritis','Gruodis'],
		monthNamesShort: ['Sau','Vas','Kov','Bal','Geg','Bir',
		'Lie','Rugp','Rugs','Spa','Lap','Gru'],
		dayNames: ['sekmadienis','pirmadienis','antradienis','tre膷iadienis','ketvirtadienis','penktadienis','拧e拧tadienis'],
		dayNamesShort: ['sek','pir','ant','tre','ket','pen','拧e拧'],
		dayNamesMin: ['Se','Pr','An','Tr','Ke','Pe','艩e'],
		weekHeader: 'Wk',
		dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['lt']);
});
