/* Thai initialisation for the jQuery UI date picker plugin. */
/* Written by pipo (pipo@sixhead.com). */
jQuery(function($){
	$.datepicker.regional['th'] = {
		closeText: '喔涏复喔?,
		prevText: '&#xAB;&#xA0;喔⑧箟喔笝',
		nextText: '喔栢副喔斷箘喔?#xA0;&#xBB;',
		currentText: '喔о副喔權笝喔掂箟',
		monthNames: ['喔∴竵喔｀覆喔勦浮','喔佮父喔∴笭喔侧笧喔编笝喔樴箤','喔∴傅喔權覆喔勦浮','喙€喔∴俯喔侧涪喔?,'喔炧袱喔┼笭喔侧竸喔?,'喔∴复喔栢父喔權覆喔⑧笝',
		'喔佮福喔佮笌喔侧竸喔?,'喔复喔囙斧喔侧竸喔?,'喔佮副喔權涪喔侧涪喔?,'喔曕父喔ム覆喔勦浮','喔炧袱喔ㄠ笀喔脆竵喔侧涪喔?,'喔樴副喔權抚喔侧竸喔?],
		monthNamesShort: ['喔?喔?','喔?喔?','喔∴傅.喔?','喙€喔?喔?','喔?喔?','喔∴复.喔?',
		'喔?喔?','喔?喔?','喔?喔?','喔?喔?','喔?喔?','喔?喔?'],
		dayNames: ['喔覆喔椸复喔曕涪喙?,'喔堗副喔權笚喔｀箤','喔副喔囙竸喔侧福','喔炧父喔?,'喔炧袱喔副喔笟喔斷傅','喔ㄠ父喔佮福喙?,'喙€喔覆喔｀箤'],
		dayNamesShort: ['喔覆.','喔?','喔?','喔?','喔炧袱.','喔?','喔?'],
		dayNamesMin: ['喔覆.','喔?','喔?','喔?','喔炧袱.','喔?','喔?'],
		weekHeader: 'Wk',
		dateFormat: 'dd/mm/yy',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['th']);
});
