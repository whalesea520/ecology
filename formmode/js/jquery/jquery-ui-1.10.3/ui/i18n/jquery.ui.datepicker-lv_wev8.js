/* Latvian (UTF-8) initialisation for the jQuery UI date picker plugin. */
/* @author Arturas Paleicikas <arturas.paleicikas@metasite.net> */
jQuery(function($){
	$.datepicker.regional['lv'] = {
		closeText: 'Aizv膿rt',
		prevText: 'Iepr',
		nextText: 'N膩ka',
		currentText: '艩odien',
		monthNames: ['Janv膩ris','Febru膩ris','Marts','Apr墨lis','Maijs','J奴nijs',
		'J奴lijs','Augusts','Septembris','Oktobris','Novembris','Decembris'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','Mai','J奴n',
		'J奴l','Aug','Sep','Okt','Nov','Dec'],
		dayNames: ['sv膿tdiena','pirmdiena','otrdiena','tre拧diena','ceturtdiena','piektdiena','sestdiena'],
		dayNamesShort: ['svt','prm','otr','tre','ctr','pkt','sst'],
		dayNamesMin: ['Sv','Pr','Ot','Tr','Ct','Pk','Ss'],
		weekHeader: 'Nav',
		dateFormat: 'dd-mm-yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['lv']);
});
