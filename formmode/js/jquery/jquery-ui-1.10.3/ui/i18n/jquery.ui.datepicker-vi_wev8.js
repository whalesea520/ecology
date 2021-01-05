﻿/* Vietnamese initialisation for the jQuery UI date picker plugin. */
/* Translated by Le Thanh Huy (lthanhhuy@cit.ctu.edu.vn). */
jQuery(function($){
	$.datepicker.regional['vi'] = {
		closeText: '膼贸ng',
		prevText: '&#x3C;Tr瓢峄沜',
		nextText: 'Ti岷縫&#x3E;',
		currentText: 'H么m nay',
		monthNames: ['Th谩ng M峄檛', 'Th谩ng Hai', 'Th谩ng Ba', 'Th谩ng T瓢', 'Th谩ng N膬m', 'Th谩ng S谩u',
		'Th谩ng B岷', 'Th谩ng T谩m', 'Th谩ng Ch铆n', 'Th谩ng M瓢峄漣', 'Th谩ng M瓢峄漣 M峄檛', 'Th谩ng M瓢峄漣 Hai'],
		monthNamesShort: ['Th谩ng 1', 'Th谩ng 2', 'Th谩ng 3', 'Th谩ng 4', 'Th谩ng 5', 'Th谩ng 6',
		'Th谩ng 7', 'Th谩ng 8', 'Th谩ng 9', 'Th谩ng 10', 'Th谩ng 11', 'Th谩ng 12'],
		dayNames: ['Ch峄?Nh岷璽', 'Th峄?Hai', 'Th峄?Ba', 'Th峄?T瓢', 'Th峄?N膬m', 'Th峄?S谩u', 'Th峄?B岷'],
		dayNamesShort: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
		dayNamesMin: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
		weekHeader: 'Tu',
		dateFormat: 'dd/mm/yy',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['vi']);
});
