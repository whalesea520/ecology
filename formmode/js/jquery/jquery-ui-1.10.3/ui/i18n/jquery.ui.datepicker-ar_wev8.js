/* Arabic Translation for jQuery UI date picker plugin. */
/* Khaled Alhourani -- me@khaledalhourani.com */
/* NOTE: monthNames are the original months names and they are the Arabic names, not the new months name 賮亘乇丕賷乇 - 賷賳丕賷乇 and there isn't any Arabic roots for these months */
jQuery(function($){
	$.datepicker.regional['ar'] = {
		closeText: '廿睾賱丕賯',
		prevText: '&#x3C;丕賱爻丕亘賯',
		nextText: '丕賱鬲丕賱賷&#x3E;',
		currentText: '丕賱賷賵賲',
		monthNames: ['賰丕賳賵賳 丕賱孬丕賳賷', '卮亘丕胤', '丌匕丕乇', '賳賷爻丕賳', '賲丕賷賵', '丨夭賷乇丕賳',
		'鬲賲賵夭', '丌亘', '兀賷賱賵賱',	'鬲卮乇賷賳 丕賱兀賵賱', '鬲卮乇賷賳 丕賱孬丕賳賷', '賰丕賳賵賳 丕賱兀賵賱'],
		monthNamesShort: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
		dayNames: ['丕賱兀丨丿', '丕賱丕孬賳賷賳', '丕賱孬賱丕孬丕亍', '丕賱兀乇亘毓丕亍', '丕賱禺賲賷爻', '丕賱噩賲毓丞', '丕賱爻亘鬲'],
		dayNamesShort: ['丕賱兀丨丿', '丕賱丕孬賳賷賳', '丕賱孬賱丕孬丕亍', '丕賱兀乇亘毓丕亍', '丕賱禺賲賷爻', '丕賱噩賲毓丞', '丕賱爻亘鬲'],
		dayNamesMin: ['丨', '賳', '孬', '乇', '禺', '噩', '爻'],
		weekHeader: '兀爻亘賵毓',
		dateFormat: 'dd/mm/yy',
		firstDay: 6,
  		isRTL: true,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['ar']);
});
