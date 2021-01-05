/* Swedish initialisation for the jQuery UI date picker plugin. */
/* Written by Anders Ekdahl ( anders@nomadiz.se). */
jQuery(function($){
	$.datepicker.regional['sv'] = {
		closeText: 'St盲ng',
		prevText: '&#xAB;F枚rra',
		nextText: 'N盲sta&#xBB;',
		currentText: 'Idag',
		monthNames: ['Januari','Februari','Mars','April','Maj','Juni',
		'Juli','Augusti','September','Oktober','November','December'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','Maj','Jun',
		'Jul','Aug','Sep','Okt','Nov','Dec'],
		dayNamesShort: ['S枚n','M氓n','Tis','Ons','Tor','Fre','L枚r'],
		dayNames: ['S枚ndag','M氓ndag','Tisdag','Onsdag','Torsdag','Fredag','L枚rdag'],
		dayNamesMin: ['S枚','M氓','Ti','On','To','Fr','L枚'],
		weekHeader: 'Ve',
		dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['sv']);
});
