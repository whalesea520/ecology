/* Algerian Arabic Translation for jQuery UI date picker plugin. (can be used for Tunisia)*/
/* Mohamed Cherif BOUCHELAGHEM -- cherifbouchelaghem@yahoo.fr */

jQuery(function($){
	$.datepicker.regional['ar-DZ'] = {
		closeText: '廿睾賱丕賯',
		prevText: '&#x3C;丕賱爻丕亘賯',
		nextText: '丕賱鬲丕賱賷&#x3E;',
		currentText: '丕賱賷賵賲',
		monthNames: ['噩丕賳賮賷', '賮賷賮乇賷', '賲丕乇爻', '兀賮乇賷賱', '賲丕賷', '噩賵丕賳',
		'噩賵賷賱賷丞', '兀賵鬲', '爻亘鬲賲亘乇','兀賰鬲賵亘乇', '賳賵賮賲亘乇', '丿賷爻賲亘乇'],
		monthNamesShort: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
		dayNames: ['丕賱兀丨丿', '丕賱丕孬賳賷賳', '丕賱孬賱丕孬丕亍', '丕賱兀乇亘毓丕亍', '丕賱禺賲賷爻', '丕賱噩賲毓丞', '丕賱爻亘鬲'],
		dayNamesShort: ['丕賱兀丨丿', '丕賱丕孬賳賷賳', '丕賱孬賱丕孬丕亍', '丕賱兀乇亘毓丕亍', '丕賱禺賲賷爻', '丕賱噩賲毓丞', '丕賱爻亘鬲'],
		dayNamesMin: ['丕賱兀丨丿', '丕賱丕孬賳賷賳', '丕賱孬賱丕孬丕亍', '丕賱兀乇亘毓丕亍', '丕賱禺賲賷爻', '丕賱噩賲毓丞', '丕賱爻亘鬲'],
		weekHeader: '兀爻亘賵毓',
		dateFormat: 'dd/mm/yy',
		firstDay: 6,
  		isRTL: true,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['ar-DZ']);
});
