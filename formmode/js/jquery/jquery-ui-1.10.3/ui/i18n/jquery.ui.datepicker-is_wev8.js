/* Icelandic initialisation for the jQuery UI date picker plugin. */
/* Written by Haukur H. Thorsson (haukur@eskill.is). */
jQuery(function($){
	$.datepicker.regional['is'] = {
		closeText: 'Loka',
		prevText: '&#x3C; Fyrri',
		nextText: 'N忙sti &#x3E;',
		currentText: '脥 dag',
		monthNames: ['Jan煤ar','Febr煤ar','Mars','Apr铆l','Ma铆','J煤n铆',
		'J煤l铆','脕g煤st','September','Okt贸ber','N贸vember','Desember'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','Ma铆','J煤n',
		'J煤l','脕g煤','Sep','Okt','N贸v','Des'],
		dayNames: ['Sunnudagur','M谩nudagur','脼ri冒judagur','Mi冒vikudagur','Fimmtudagur','F枚studagur','Laugardagur'],
		dayNamesShort: ['Sun','M谩n','脼ri','Mi冒','Fim','F枚s','Lau'],
		dayNamesMin: ['Su','M谩','脼r','Mi','Fi','F枚','La'],
		weekHeader: 'Vika',
		dateFormat: 'dd/mm/yy',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['is']);
});
