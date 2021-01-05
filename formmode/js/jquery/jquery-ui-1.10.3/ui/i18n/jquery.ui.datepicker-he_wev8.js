﻿/* Hebrew initialisation for the UI Datepicker extension. */
/* Written by Amir Hardon (ahardon at gmail dot com). */
jQuery(function($){
	$.datepicker.regional['he'] = {
		closeText: '住讙讜专',
		prevText: '&#x3C;讛拽讜讚诐',
		nextText: '讛讘讗&#x3E;',
		currentText: '讛讬讜诐',
		monthNames: ['讬谞讜讗专','驻讘专讜讗专','诪专抓','讗驻专讬诇','诪讗讬','讬讜谞讬',
		'讬讜诇讬','讗讜讙讜住讟','住驻讟诪讘专','讗讜拽讟讜讘专','谞讜讘诪讘专','讚爪诪讘专'],
		monthNamesShort: ['讬谞讜','驻讘专','诪专抓','讗驻专','诪讗讬','讬讜谞讬',
		'讬讜诇讬','讗讜讙','住驻讟','讗讜拽','谞讜讘','讚爪诪'],
		dayNames: ['专讗砖讜谉','砖谞讬','砖诇讬砖讬','专讘讬注讬','讞诪讬砖讬','砖讬砖讬','砖讘转'],
		dayNamesShort: ['讗\'','讘\'','讙\'','讚\'','讛\'','讜\'','砖讘转'],
		dayNamesMin: ['讗\'','讘\'','讙\'','讚\'','讛\'','讜\'','砖讘转'],
		weekHeader: 'Wk',
		dateFormat: 'dd/mm/yy',
		firstDay: 0,
		isRTL: true,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['he']);
});
