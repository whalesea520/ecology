/* Polish initialisation for the jQuery UI date picker plugin. */
/* Written by Jacek Wysocki (jacek.wysocki@gmail.com). */
jQuery(function($){
	$.datepicker.regional['pl'] = {
		closeText: 'Zamknij',
		prevText: '&#x3c;Poprzedni',
		nextText: 'Nast臋pny&#x3e;',
		currentText: 'Dzi艣',
		monthNames: ['Stycze艅','Luty','Marzec','Kwiecie艅','Maj','Czerwiec',
		'Lipiec','Sierpie艅','Wrzesie艅','Pa藕dziernik','Listopad','Grudzie艅'],
		monthNamesShort: ['Sty','Lu','Mar','Kw','Maj','Cze',
		'Lip','Sie','Wrz','Pa','Lis','Gru'],
		dayNames: ['Niedziela','Poniedzialek','Wtorek','艢roda','Czwartek','Pi膮tek','Sobota'],
		dayNamesShort: ['Nie','Pn','Wt','艢r','Czw','Pt','So'],
		dayNamesMin: ['N','Pn','Wt','艢r','Cz','Pt','So'],
		dateFormat: 'yy-mm-dd', firstDay: 1,
		isRTL: false};
	$.datepicker.setDefaults($.datepicker.regional['pl']);
});
