/* Chinese initialisation for the jQuery UI date picker plugin. */
/* Written by Cloudream (cloudream@gmail.com). */
jQuery(function($){
	$.datepicker.regional['zh-CN'] = {
		closeText: '鍏抽棴',
		prevText: '&#x3C;涓婃湀',
		nextText: '涓嬫湀&#x3E;',
		currentText: '浠婂ぉ',
		monthNames: ['涓€鏈?,'浜屾湀','涓夋湀','鍥涙湀','浜旀湀','鍏湀',
		'涓冩湀','鍏湀','涔濇湀','鍗佹湀','鍗佷竴鏈?,'鍗佷簩鏈?],
		monthNamesShort: ['涓€鏈?,'浜屾湀','涓夋湀','鍥涙湀','浜旀湀','鍏湀',
		'涓冩湀','鍏湀','涔濇湀','鍗佹湀','鍗佷竴鏈?,'鍗佷簩鏈?],
		dayNames: ['鏄熸湡鏃?,'鏄熸湡涓€','鏄熸湡浜?,'鏄熸湡涓?,'鏄熸湡鍥?,'鏄熸湡浜?,'鏄熸湡鍏?],
		dayNamesShort: ['鍛ㄦ棩','鍛ㄤ竴','鍛ㄤ簩','鍛ㄤ笁','鍛ㄥ洓','鍛ㄤ簲','鍛ㄥ叚'],
		dayNamesMin: ['鏃?,'涓€','浜?,'涓?,'鍥?,'浜?,'鍏?],
		weekHeader: '鍛?,
		dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: true,
		yearSuffix: '骞?};
	$.datepicker.setDefaults($.datepicker.regional['zh-CN']);
});
