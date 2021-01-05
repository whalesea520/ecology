var $lang={errAlertMsg: "\u4E0D\u5408\u6CD5\u7684\u65E5\u671F\u683C\u5F0F\u6216\u8005\u65E5\u671F\u8D85\u51FA\u9650\u5B9A\u7BC4\u570D,\u9700\u8981\u64A4\u92B7\u55CE?",
			aWeekStr: ["\u5468","\u65E5","\u4E00","\u4E8C","\u4E09","\u56DB","\u4E94","\u516D"],
			aLongWeekStr:["\u5468","\u661F\u671F\u65E5","\u661F\u671F\u4E00","\u661F\u671F\u4E8C","\u661F\u671F\u4E09","\u661F\u671F\u56DB","\u661F\u671F\u4E94","\u661F\u671F\u516D"],
			aMonStr: ["\u4E00\u6708","\u4E8C\u6708","\u4E09\u6708","\u56DB\u6708","\u4E94\u6708","\u516D\u6708","\u4E03\u6708","\u516B\u6708","\u4E5D\u6708","\u5341\u6708","\u5341\u4E00","\u5341\u4E8C"],
			aLongMonStr: ["\u4E00\u6708","\u4E8C\u6708","\u4E09\u6708","\u56DB\u6708","\u4E94\u6708","\u516D\u6708","\u4E03\u6708","\u516B\u6708","\u4E5D\u6708","\u5341\u6708","\u5341\u4E00\u6708","\u5341\u4E8C\u6708"],
			clearStr: "\u6E05\u7A7A",
			todayStr: "\u4ECA\u5929",
			okStr: "\u78BA\u5B9A",
			updateStr: "\u78BA\u5B9A",
			timeStr: "\u6642\u9593",
			quickStr: "\u5FEB\u901F\u9078\u64C7",
			err_1: '\u6700\u5C0F\u65E5\u671F\u4E0D\u80FD\u5927\u65BC\u6700\u5927\u65E5\u671F!'
};
function __initDatePickerLang__(){
	try{
		$lang = {
			errAlertMsg: SystemEnv.getHtmlNoteName(3671),
			aWeekStr: [SystemEnv.getHtmlNoteName(3675), SystemEnv.getHtmlNoteName(3676), SystemEnv.getHtmlNoteName(3677), SystemEnv.getHtmlNoteName(3678), SystemEnv.getHtmlNoteName(3679), SystemEnv.getHtmlNoteName(3680), SystemEnv.getHtmlNoteName(3681),SystemEnv.getHtmlNoteName(3682)],
			aLongWeekStr:[SystemEnv.getHtmlNoteName(3675),SystemEnv.getHtmlNoteName(3683),SystemEnv.getHtmlNoteName(3685),SystemEnv.getHtmlNoteName(3686),SystemEnv.getHtmlNoteName(3687),SystemEnv.getHtmlNoteName(3688),SystemEnv.getHtmlNoteName(3689),SystemEnv.getHtmlNoteName(3690),SystemEnv.getHtmlNoteName(3683)],
			aMonStr: [SystemEnv.getHtmlNoteName(3691), SystemEnv.getHtmlNoteName(3692), SystemEnv.getHtmlNoteName(3693), SystemEnv.getHtmlNoteName(3694), SystemEnv.getHtmlNoteName(3695), SystemEnv.getHtmlNoteName(3696), SystemEnv.getHtmlNoteName(3697), SystemEnv.getHtmlNoteName(3698), SystemEnv.getHtmlNoteName(3699), SystemEnv.getHtmlNoteName(3700), SystemEnv.getHtmlNoteName(3701), SystemEnv.getHtmlNoteName(3702)],
			aLongMonStr: [SystemEnv.getHtmlNoteName(3723),SystemEnv.getHtmlNoteName(3724),SystemEnv.getHtmlNoteName(3725),SystemEnv.getHtmlNoteName(3727),SystemEnv.getHtmlNoteName(3695),SystemEnv.getHtmlNoteName(3728),SystemEnv.getHtmlNoteName(3729),SystemEnv.getHtmlNoteName(3730),SystemEnv.getHtmlNoteName(3731),SystemEnv.getHtmlNoteName(3732),SystemEnv.getHtmlNoteName(3733),SystemEnv.getHtmlNoteName(3734)],
			clearStr: SystemEnv.getHtmlNoteName(3704),
			todayStr: SystemEnv.getHtmlNoteName(3708),
			okStr: SystemEnv.getHtmlNoteName(3451),
			updateStr: SystemEnv.getHtmlNoteName(3451),
			timeStr: SystemEnv.getHtmlNoteName(3706),
			quickStr: SystemEnv.getHtmlNoteName(3707),
			err_1: SystemEnv.getHtmlNoteName(54)
		}
	}catch(e){
		setTimeout(function(){
			__initDatePickerLang__();
		},500);
	}
}


__initDatePickerLang__();