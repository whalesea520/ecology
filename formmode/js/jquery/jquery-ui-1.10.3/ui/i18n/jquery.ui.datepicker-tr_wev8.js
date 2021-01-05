/* Turkish initialisation for the jQuery UI date picker plugin. */
/* Written by Izzet Emre Erkan (kara@karalamalar.net). */
jQuery(function($){
	$.datepicker.regional['tr'] = {
		closeText: 'kapat',
		prevText: '&#x3C;geri',
		nextText: 'ileri&#x3e',
		currentText: 'bug眉n',
		monthNames: ['Ocak','艦ubat','Mart','Nisan','May谋s','Haziran',
		'Temmuz','A臒ustos','Eyl眉l','Ekim','Kas谋m','Aral谋k'],
		monthNamesShort: ['Oca','艦ub','Mar','Nis','May','Haz',
		'Tem','A臒u','Eyl','Eki','Kas','Ara'],
		dayNames: ['Pazar','Pazartesi','Sal谋','脟ar艧amba','Per艧embe','Cuma','Cumartesi'],
		dayNamesShort: ['Pz','Pt','Sa','脟a','Pe','Cu','Ct'],
		dayNamesMin: ['Pz','Pt','Sa','脟a','Pe','Cu','Ct'],
		weekHeader: 'Hf',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['tr']);
});
