/* Slovak initialisation for the jQuery UI date picker plugin. */
/* Written by Vojtech Rinik (vojto@hmm.sk). */
jQuery(function($){
	$.datepicker.regional['sk'] = {
		closeText: 'Zavrie钮',
		prevText: '&#x3c;Predch谩dzaj煤ci',
		nextText: 'Nasleduj煤ci&#x3e;',
		currentText: 'Dnes',
		monthNames: ['Janu谩r','Febru谩r','Marec','Apr铆l','M谩j','J煤n',
		'J煤l','August','September','Okt贸ber','November','December'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','M谩j','J煤n',
		'J煤l','Aug','Sep','Okt','Nov','Dec'],
		dayNames: ['Nedel\'a','Pondelok','Utorok','Streda','艩tvrtok','Piatok','Sobota'],
		dayNamesShort: ['Ned','Pon','Uto','Str','艩tv','Pia','Sob'],
		dayNamesMin: ['Ne','Po','Ut','St','艩t','Pia','So'],
		dateFormat: 'dd.mm.yy', firstDay: 0,
		isRTL: false};
	$.datepicker.setDefaults($.datepicker.regional['sk']);
});
