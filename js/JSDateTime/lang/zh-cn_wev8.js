var $lang=null;
function  readCookie2(name){
	var  cookieValue  =  "7";
	var  search  =  name  +  "=";
	try{
		if(document.cookie.length  >  0) {
			offset  =  document.cookie.indexOf(search);
			if  (offset  !=  -1)
			{
				offset  +=  search.length;
				end  =  document.cookie.indexOf(";",  offset);
				if  (end  ==  -1)  end  =  document.cookie.length;
				cookieValue  =  unescape(document.cookie.substring(offset,  end))
			}
		}
	}catch(exception){
	}
	return  cookieValue;
}
if (typeof SystemEnvDatePicker == "undefined") { 
	var SystemEnvDatePicker = (function(){
	var __weaverDatePickerLanguageLabelDefine = {
		54:{7:"结束日期必须大于开始日期！",8:"The end date must be larger than the start date!",9:"結束日期必須大于開始日期！"},
		3408:{7:"今天",8:"Today",9:"今天"},
		3451:{7:"确定",8:"Confirm",9:"确定"},
		3671:{7:"无效的日期或日期超出范围，是否撤销？",8:"Invalid date or the date out of range,redo or not?",9:"無效的日期或日期超出範圍，是否撤銷？"},
		3675:{7:"星期",8:"wk",9:"星期"},
		3676:{7:"日",8:"Sun",9:"日"},
		3677:{7:"一",8:"Mon",9:"一"},
		3678:{7:"二",8:"Tue",9:"二"},
		3679:{7:"三",8:"Wed",9:"三"},
		3680:{7:"四",8:"Thu",9:"四"},
		3681:{7:"五",8:"Fri",9:"五"},
		3682:{7:"六",8:"Sat",9:"六"},
		3683:{7:"星期日",8:"Sunday",9:"星期日"},
		3685:{7:"星期一",8:"Monday",9:"星期一"},
		3686:{7:"星期二",8:"Tuesday",9:"星期二"},
		3687:{7:"星期三",8:"Wednesday",9:"星期三"},
		3688:{7:"星期四",8:"Thursday",9:"星期四"},
		3689:{7:"星期五",8:"Friday",9:"星期五"},
		3690:{7:"星期六",8:"Saturday",9:"星期六"},
		3691:{7:"一月",8:"Jan",9:"一月"},
		3692:{7:"二月",8:"Feb",9:"二月"},
		3693:{7:"三月",8:"Mar",9:"三月"},
		3694:{7:"四月",8:"Apr",9:"四月"},
		3695:{7:"五月",8:"May",9:"五月"},
		3696:{7:"六月",8:"Jun",9:"六月"},
		3697:{7:"七月",8:"Jul",9:"七月"},
		3698:{7:"八月",8:"Aug",9:"八月"},
		3699:{7:"九月",8:"Sep",9:"九月"},
		3700:{7:"十月",8:"Oct",9:"十月"},
		3701:{7:"十一",8:"Nov",9:"十一"},
		3702:{7:"十二",8:"Dec",9:"十二"},
		3704:{7:"清除",8:"Clear",9:"清除"},
		3706:{7:"时间",8:"Time",9:"時間"},
		3707:{7:"快速选择",8:"Quick Selection",9:"快速選擇"},
		3723:{7:"一月",8:"January",9:"一月"},
		3724:{7:"二月",8:"February",9:"二月"},
		3725:{7:"三月",8:"March",9:"三月"},
		3726:{7:"拆分成列",8:"Splittocols",9:"拆分成列"},
		3727:{7:"四月",8:"April",9:"四月"},
		3728:{7:"六月",8:"June",9:"六月"},
		3729:{7:"七月",8:"July",9:"七月"},
		3730:{7:"八月",8:"August",9:"八月"},
		3731:{7:"九月",8:"September",9:"九月"},
		3732:{7:"十月",8:"October",9:"十月"},
		3733:{7:"十一",8:"November",9:"十一"},
		3734:{7:"十二月",8:"December",9:"十二月"}
	};
	return {
		getHtmlNoteName:function(labelid,languageid){
			var labelJSON = null;
			var label = null;
			var multiLabel = false;
			try{
				multiLabel = labelid.indexOf(",")>-1;
				}catch(e){}
			if(!multiLabel){
				labelJSON = __weaverDatePickerLanguageLabelDefine[labelid];
			if(labelJSON){
			label = labelJSON[languageid];
			}
			
			}else{
				var labelids = labelid.split(",");
				for(var i=0;i<labelids.length;i++){
					if(label){
					label+=__weaverDatePickerLanguageLabelDefine[labelids[i]];
			}else{
				label = __weaverDatePickerLanguageLabelDefine[labelids[i]];
			}
				}
			}
	return label?label:null;
		}
}
})();
}function __initDatePickerLang__(){
	try{
		$lang = {
			errAlertMsg: SystemEnvDatePicker.getHtmlNoteName(3671,langId),
			aWeekStr: [SystemEnvDatePicker.getHtmlNoteName(3675,langId), SystemEnvDatePicker.getHtmlNoteName(3676,langId), SystemEnvDatePicker.getHtmlNoteName(3677,langId), SystemEnvDatePicker.getHtmlNoteName(3678,langId), SystemEnvDatePicker.getHtmlNoteName(3679,langId), SystemEnvDatePicker.getHtmlNoteName(3680,langId), SystemEnvDatePicker.getHtmlNoteName(3681,langId),SystemEnvDatePicker.getHtmlNoteName(3682,langId)],
			aLongWeekStr:[SystemEnvDatePicker.getHtmlNoteName(3675,langId),SystemEnvDatePicker.getHtmlNoteName(3683,langId),SystemEnvDatePicker.getHtmlNoteName(3685,langId),SystemEnvDatePicker.getHtmlNoteName(3686,langId),SystemEnvDatePicker.getHtmlNoteName(3687,langId),SystemEnvDatePicker.getHtmlNoteName(3688,langId),SystemEnvDatePicker.getHtmlNoteName(3689,langId),SystemEnvDatePicker.getHtmlNoteName(3690,langId),SystemEnvDatePicker.getHtmlNoteName(3683,langId)],
			aMonStr: [SystemEnvDatePicker.getHtmlNoteName(3691,langId), SystemEnvDatePicker.getHtmlNoteName(3692,langId), SystemEnvDatePicker.getHtmlNoteName(3693,langId), SystemEnvDatePicker.getHtmlNoteName(3694,langId), SystemEnvDatePicker.getHtmlNoteName(3695,langId), SystemEnvDatePicker.getHtmlNoteName(3696,langId), SystemEnvDatePicker.getHtmlNoteName(3697,langId), SystemEnvDatePicker.getHtmlNoteName(3698,langId), SystemEnvDatePicker.getHtmlNoteName(3699,langId), SystemEnvDatePicker.getHtmlNoteName(3700,langId), SystemEnvDatePicker.getHtmlNoteName(3701,langId), SystemEnvDatePicker.getHtmlNoteName(3702,langId)],
			aLongMonStr: [SystemEnvDatePicker.getHtmlNoteName(3723,langId),SystemEnvDatePicker.getHtmlNoteName(3724,langId),SystemEnvDatePicker.getHtmlNoteName(3725,langId),SystemEnvDatePicker.getHtmlNoteName(3727,langId),SystemEnvDatePicker.getHtmlNoteName(3695,langId),SystemEnvDatePicker.getHtmlNoteName(3728,langId),SystemEnvDatePicker.getHtmlNoteName(3729,langId),SystemEnvDatePicker.getHtmlNoteName(3730,langId),SystemEnvDatePicker.getHtmlNoteName(3731,langId),SystemEnvDatePicker.getHtmlNoteName(3732,langId),SystemEnvDatePicker.getHtmlNoteName(3733,langId),SystemEnvDatePicker.getHtmlNoteName(3734,langId)],
			clearStr: SystemEnvDatePicker.getHtmlNoteName(3704,langId),
			todayStr: SystemEnvDatePicker.getHtmlNoteName(3408,langId),
			okStr: SystemEnvDatePicker.getHtmlNoteName(3451,langId),
			updateStr: SystemEnvDatePicker.getHtmlNoteName(3451,langId),
			timeStr: SystemEnvDatePicker.getHtmlNoteName(3706,langId),
			quickStr: SystemEnvDatePicker.getHtmlNoteName(3707,langId),
			err_1: SystemEnvDatePicker.getHtmlNoteName(54,langId)
		}
	}catch(e){
	}
}
var langId=readCookie2("languageidweaver");
__initDatePickerLang__();