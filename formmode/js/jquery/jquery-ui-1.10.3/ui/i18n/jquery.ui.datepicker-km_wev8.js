﻿/* Khmer initialisation for the jQuery calendar extension. */
/* Written by Chandara Om (chandara.teacher@gmail.com). */
jQuery(function($){
	$.datepicker.regional['km'] = {
		closeText: '釣掅煉釣溼灳鈥嬦灇釣结瀰',
		prevText: '釣樶灮釣?,
		nextText: '釣斸灀釤掅瀾釣夺灁釤?,
		currentText: '釣愥煉釣勧焹鈥嬦灀釤佱焽',
		monthNames: ['釣樶瀫釣氠灦','釣€釣会灅釤掅灄釤?,'釣樶灨釣撫灦','釣樶焷釣熱灦','釣п灍釣椺灦','釣樶灧釣愥灮釣撫灦',
		'釣€釣€釤掅瀫釣娽灦','釣熱灨釣犪灦','釣€釣夅煉釣夅灦','釣忈灮釣涐灦','釣溼灧釣呩煉釣嗎灧釣€釣?,'釣掅煉釣撫灱'],
		monthNamesShort: ['釣樶瀫釣氠灦','釣€釣会灅釤掅灄釤?,'釣樶灨釣撫灦','釣樶焷釣熱灦','釣п灍釣椺灦','釣樶灧釣愥灮釣撫灦',
		'釣€釣€釤掅瀫釣娽灦','釣熱灨釣犪灦','釣€釣夅煉釣夅灦','釣忈灮釣涐灦','釣溼灧釣呩煉釣嗎灧釣€釣?,'釣掅煉釣撫灱'],
		dayNames: ['釣⑨灦釣戓灧釣忈煉釣?, '釣呩灀釤掅瀾', '釣⑨瀯釤掅瀭釣夺灇', '釣栣灮釣?, '釣栣煉釣氠灎釣熱煉釣斸瀼釣丰煃', '釣熱灮釣€釤掅灇', '釣熱焻釣氠煃'],
		dayNamesShort: ['釣⑨灦', '釣?, '釣?, '釣栣灮', '釣栣煉釣氠灎', '釣熱灮', '釣熱焻'],
		dayNamesMin: ['釣⑨灦', '釣?, '釣?, '釣栣灮', '釣栣煉釣氠灎', '釣熱灮', '釣熱焻'],
		weekHeader: '釣熱灁釤掅瀶釣夺灎釤?,
		dateFormat: 'dd-mm-yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['km']);
});
