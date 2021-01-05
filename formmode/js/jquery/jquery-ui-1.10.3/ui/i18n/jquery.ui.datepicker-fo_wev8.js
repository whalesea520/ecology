/* Faroese initialisation for the jQuery UI date picker plugin */
/* Written by Sverri Mohr Olsen, sverrimo@gmail.com */
jQuery(function($){
	$.datepicker.regional['fo'] = {
		closeText: 'Lat aftur',
		prevText: '&#x3C;Fyrra',
		nextText: 'N忙sta&#x3E;',
		currentText: '脥 dag',
		monthNames: ['Januar','Februar','Mars','Apr铆l','Mei','Juni',
		'Juli','August','September','Oktober','November','Desember'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','Mei','Jun',
		'Jul','Aug','Sep','Okt','Nov','Des'],
		dayNames: ['Sunnudagur','M谩nadagur','T媒sdagur','Mikudagur','H贸sdagur','Fr铆ggjadagur','Leyardagur'],
		dayNamesShort: ['Sun','M谩n','T媒s','Mik','H贸s','Fr铆','Ley'],
		dayNamesMin: ['Su','M谩','T媒','Mi','H贸','Fr','Le'],
		weekHeader: 'Vk',
		dateFormat: 'dd-mm-yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['fo']);
});
