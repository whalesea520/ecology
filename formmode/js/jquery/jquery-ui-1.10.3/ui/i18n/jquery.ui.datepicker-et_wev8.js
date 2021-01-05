/* Estonian initialisation for the jQuery UI date picker plugin. */
/* Written by Mart S玫mermaa (mrts.pydev at gmail com). */
jQuery(function($){
	$.datepicker.regional['et'] = {
		closeText: 'Sulge',
		prevText: 'Eelnev',
		nextText: 'J盲rgnev',
		currentText: 'T盲na',
		monthNames: ['Jaanuar','Veebruar','M盲rts','Aprill','Mai','Juuni',
		'Juuli','August','September','Oktoober','November','Detsember'],
		monthNamesShort: ['Jaan', 'Veebr', 'M盲rts', 'Apr', 'Mai', 'Juuni',
		'Juuli', 'Aug', 'Sept', 'Okt', 'Nov', 'Dets'],
		dayNames: ['P眉hap盲ev', 'Esmasp盲ev', 'Teisip盲ev', 'Kolmap盲ev', 'Neljap盲ev', 'Reede', 'Laup盲ev'],
		dayNamesShort: ['P眉hap', 'Esmasp', 'Teisip', 'Kolmap', 'Neljap', 'Reede', 'Laup'],
		dayNamesMin: ['P','E','T','K','N','R','L'],
		weekHeader: 'n盲d',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['et']);
});
