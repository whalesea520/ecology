/* Slovak initialisation for the jQuery UI date picker plugin. */
/* Written by Vojtech Rinik (vojto@hmm.sk). */
jQuery(function($){
	$.datepicker.regional['sk'] = {
		closeText: 'Zavrie钮',
		prevText: '&#x3C;Predch谩dzaj煤ci',
		nextText: 'Nasleduj煤ci&#x3E;',
		currentText: 'Dnes',
		monthNames: ['janu谩r','febru谩r','marec','apr铆l','m谩j','j煤n',
		'j煤l','august','september','okt贸ber','november','december'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','M谩j','J煤n',
		'J煤l','Aug','Sep','Okt','Nov','Dec'],
		dayNames: ['nede木a','pondelok','utorok','streda','拧tvrtok','piatok','sobota'],
		dayNamesShort: ['Ned','Pon','Uto','Str','艩tv','Pia','Sob'],
		dayNamesMin: ['Ne','Po','Ut','St','艩t','Pia','So'],
		weekHeader: 'Ty',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['sk']);
});
