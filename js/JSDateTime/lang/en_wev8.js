var $lang={
		errAlertMsg: "Invalid date or the date out of range,redo or not?",
		aWeekStr: ["wk", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
		aLongWeekStr:["wk","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
		aMonStr: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
		aLongMonStr: ["January","February","March","April","May","June","July","August","September","October","November","December"],
		clearStr: "Clear",
		todayStr: "Today",
		okStr: "OK",
		updateStr: "OK",
		timeStr: "Time",
		quickStr: "Quick Selection",
		err_1: 'MinDate Cannot be bigger than MaxDate!'
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