if(typeof(M_Calendar) == 'undefined'){
	M_Calendar = {};
	
	var _m_isSildeMonth = true;
	var _m_upDownCalendar = true;
	var $globalCurrentDate = new Date();
	var $globalCurrentYear = $globalCurrentDate.getFullYear();
	var $globalCurrentMonth = $globalCurrentDate.getMonth() + 1;
		$globalCurrentMonth = ($globalCurrentMonth > 9 ? $globalCurrentMonth : "0" + $globalCurrentMonth);
	var $globalCurrentDay = $globalCurrentDate.getDate();
	var $globalCurrentWeekDay = $globalCurrentDate.getDay();
	var $globalCurrentYMD = $globalCurrentYear+ "-" +$globalCurrentMonth+ "-";
		$globalCurrentYMD += ($globalCurrentDay > 9 ? $globalCurrentDay : "0" + $globalCurrentDay);
	var $curMonthSelectDate = $globalCurrentYMD;
	var $recordSelectDate = $globalCurrentYMD;
	var calendarPlanArray = new Array();
	var weekDays = new Array("日","一","二","三","四","五","六");
	var weekDays_en = new Array("SUN","MON","TUE","WED","THU","FRI","SAT");
	var months_en = new Array("0","January","February","March","April","May","June","July","August","September","October","November","December");
	var _calLanguage = 7;
}

var Swipe_sildeCalendar;
M_Calendar.initCalendar = function(objContainerid, calLanguage){

	if(typeof(objContainerid)!="undefined" && objContainerid!=""){
		_calLanguage = calLanguage || 7;
		if(_calLanguage == 8){
			weekDays = weekDays_en;
		}

		var $objContainer = $("#"+objContainerid);
		$($objContainer).html(M_Calendar.createCalendarFrameWork(objContainerid));
		
		M_Calendar.changeYearMonth($globalCurrentYear, $globalCurrentDate.getMonth()+1);
		
		var swiperArray = $("div[class='swiper-slide']",$("._m_cdar_loadCalendarDay_Container"));
		$("table",swiperArray[0]).html(M_Calendar.loadCalendarData(objContainerid,"prevMonth"));
		$("table",swiperArray[1]).html(M_Calendar.loadCalendarData(objContainerid,""));
		$('div[title="'+$curMonthSelectDate+'"]',$objContainer).addClass("_m_cdar_currentSelect");
		$("table",swiperArray[2]).html(M_Calendar.loadCalendarData(objContainerid,"nextMonth"));
		
		$("#addDataByCalendarDate",$objContainer).bind("click",function(){
			M_Calendar.addData(objContainerid);
		});
		
		$("#upDownCalendar",$objContainer).bind("click",function(){
			$(this).toggleClass("_m_cdar_upDownCalendarSwitch");
			if(_m_upDownCalendar){
				var curWeekidx = 0;
				var curSelectDate = M_Calendar.getCurSelectDate(objContainerid);
				if(curSelectDate.length > 0){
					curWeekidx = $(curSelectDate[0]).parent().parent().index();
				}
				$('tr',$objContainer).removeClass("_m_cdar_currentWeek");
				$("._m_cdar_loadCalendarDay").each(function(){
					$(this).find("tr").eq(curWeekidx).addClass("_m_cdar_currentWeek");
				});
				$("._m_cdar_loadCalendarDay_Container", $objContainer).addClass("up");
				setTimeout(function(){
					$("._m_cdar_loadCalendarDay_Container", $objContainer).addClass("up2");
					setTimeout(function(){
						M_Calendar.resetCalendarSwitchWeek(objContainerid,curWeekidx); //重置Calendar切换到Week模式
					}, 10);
				}, 150);
			}else{
				$("._m_cdar_loadCalendarDay_Container", $objContainer).removeClass("up2");
				setTimeout(function(){
					$("._m_cdar_loadCalendarDay_Container", $objContainer).removeClass("up");
				}, 10);
				
				var _m_cdar_classname = M_Calendar.copyClassName(objContainerid);
				var curActiveIndex = Swipe_sildeCalendar.activeIndex;
				Swipe_sildeCalendar.removeAllSlides();
				var loadPrevMonthCalendarDay = "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"prevMonth")+"</table></div>";
				var loadDispMonthCalendarDay = "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"")+"</table></div>";
				var loadNextMonthCalendarDay = "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"nextMonth")+"</table></div>";
				var fillSilde = "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\"><tr><td colspan=\"7\"></td></tr></table></div>";
				if(curActiveIndex == 0){
					$("#_m_cdar_loadCalendarDay_Container").append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay).append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay);
				}else if(curActiveIndex == 1){
					$("#_m_cdar_loadCalendarDay_Container").append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay).append(fillSilde).append(fillSilde);
				}else if(curActiveIndex == 2){
					$("#_m_cdar_loadCalendarDay_Container").append(loadNextMonthCalendarDay).append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay).append(loadPrevMonthCalendarDay);
				}else if(curActiveIndex == 3){
					$("#_m_cdar_loadCalendarDay_Container").append(fillSilde).append(fillSilde).append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay);
				}else if(curActiveIndex == 4){
					$("#_m_cdar_loadCalendarDay_Container").append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay).append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay);
				}

			 	if(Swipe_sildeCalendar){
					Swipe_sildeCalendar.reInit(); //切换月模式重新初始化Swiper(日历滑动)
				}
				var selectDateParams = "";
				var curCalendarDate = M_Calendar.resetCalendarDate(objContainerid,"");
				if(curCalendarDate.getFullYear() == $globalCurrentYear && curCalendarDate.getMonth()+1 == $globalCurrentMonth){
					if($curMonthSelectDate != ""){
						selectDateParams = $curMonthSelectDate;
						$('div[title="'+$curMonthSelectDate+'"]',$objContainer).addClass("_m_cdar_currentSelect");
					}else{
						selectDateParams = $globalCurrentYMD;
						$('div[title="'+$globalCurrentYMD+'"]',$objContainer).addClass("_m_cdar_currentSelect");
					}
				}else{
					selectDateParams = $recordSelectDate;
					$('div[title="'+$recordSelectDate+'"]',$objContainer).addClass("_m_cdar_currentSelect");
				}
				
				var curYearMonthDate = M_Calendar.resetCalendarDate(objContainerid,"");
				var rCalendarYear = curYearMonthDate.getFullYear();
				var rCalendayMonth = curYearMonthDate.getMonth()+1;
				rCalendayMonth = rCalendayMonth > 9 ? rCalendayMonth : "0" + rCalendayMonth;
				var firstDay = rCalendarYear+"-"+rCalendayMonth+"-01";
				var LastDay = rCalendarYear+"-"+rCalendayMonth+"-"+new Date(rCalendarYear,rCalendayMonth,0).getDate();
				var curActiveSilde = $(Swipe_sildeCalendar.getSlide(curActiveIndex));
				for(var idx = 0; idx < calendarPlanArray.length; idx++){
					$("td[id='"+calendarPlanArray[idx]+"']",curActiveSilde).addClass("_m_cdar_calendarPlanDiv");
				}
				M_Calendar.monthChange(objContainerid,"","");
				//M_Calendar.dayChange(objContainerid,firstDay,LastDay);
			}
			_m_upDownCalendar = !_m_upDownCalendar;
		});
	}

	M_Calendar.initSildeCalendar(objContainerid);//初始化插件(日历滑动)
};

M_Calendar.initSildeCalendar = function(objContainerid){

	Swipe_sildeCalendar = new Swiper('.swiper-container', {
		initialSlide: 1,
		loop: true,
		calculateHeight: true, //Swiper根据slides内容计算容器高度
		calculateSlideHeight: false, //true给slide高度,默认false
		onSlidePrev: function(){ //右滑动
			if(!_m_upDownCalendar){
				M_Calendar.slidePrevWeek(objContainerid);//周模式(上周)
			}else{
				M_Calendar.slidePrevMonth(objContainerid,'');//月模式(上月)
			}
		},
		onSlideNext: function(){ //左滑动
			if(!_m_upDownCalendar){
				M_Calendar.slideNextWeek(objContainerid);//周模式(下周)
			}else{
				M_Calendar.slideNextMonth(objContainerid,'');//月模式(下月)
			}
		},
		onFirstInit: function(){
			
		}
	});
};

M_Calendar.createCalendarFrameWork = function(objContainerid){

	var styleStr = "";
	if(typeof(Mobile_NS) != "undefined" && typeof(Mobile_NS.isRunInMobile) == "function"){
		if(!Mobile_NS.isRunInMobile()){
			styleStr = "max-height:282px;";	
		}
	}
	
	var htm = "<div class=\"_m_cdar_calendarTop\">";
			htm += "<div class=\"_m_cdar_calendarLeft\">";
				htm += "<div id=\"_m_cdar_calendarYearMonth\" class=\"_m_cdar_calendarYearMonth_noBack\">";
					htm += "<span id=\"_m_cdar_calendarYear\" class=\"_m_cdar_calendarYear\"></span>";
					htm += "<span id=\"_m_cdar_calendarMonth\" class=\"_m_cdar_calendarMonth\"></span>";
					htm += "<input type=\"hidden\" id=\"_m_cdar_calendarMonth_num\"/>";
				htm += "</div>";
			htm += "</div>";
			
			htm += "<div class=\"_m_cdar_calendarRight\">";
				htm += "<div id=\"upDownCalendar\" class=\"_m_cdar_upDownCalendar\">";
					htm += "<div class=\"_m_cdar_divBoxContainer\"></div>";
					htm += "<div class=\"_m_cdar_divline _m_cdar_divline1\"></div>";
					htm += "<div class=\"_m_cdar_divline _m_cdar_divline2\"></div>";
				htm += "</div>";
				htm += "<div id=\"addDataByCalendarDate\" class=\"_m_cdar_calendarAddData\">";
					htm += "<div class=\"_m_cdar_line _m_cdar_line1\"></div>";
					htm += "<div class=\"_m_cdar_line _m_cdar_line2\"></div>";
				htm += "</div>";
			htm += "</div>";
			
			htm += "<div class=\"_m_cdar_calendarWeek\">";
				htm += "<table class=\"_m_cdar_calendarHead\" cellpadding=\"0\" cellspacing=\"0\">";
					htm += "<tbody>";
						htm += "<tr>";
							htm += "<td>"+weekDays[0]+"</td>";
							htm += "<td>"+weekDays[1]+"</td>";
							htm += "<td>"+weekDays[2]+"</td>";
							htm += "<td>"+weekDays[3]+"</td>";
							htm += "<td>"+weekDays[4]+"</td>";
							htm += "<td>"+weekDays[5]+"</td>";
							htm += "<td>"+weekDays[6]+"</td>";
						htm += "</tr>";
					htm += "</tbody>";
				htm += "</table>";
			htm += "</div>";	
	htm += "</div>";
	
	htm += "<div id=\"_m_sildeCalendar_Container\" class=\"swiper-container\" style=\"visibility: visible;overflow:hidden;"+styleStr+"\">";
		htm +="<div id=\"_m_cdar_loadCalendarDay_Container\" class=\"_m_cdar_loadCalendarDay_Container swiper-wrapper\">";
			htm += "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide\"></table></div>";
			htm += "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide\"></table></div>";
			htm += "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide\"></table></div>";
		htm +="</div>";
	htm += "</div>";
	
	return htm;
};

M_Calendar.loadCalendarData = function($objContainer,optMonth){
	
	var m_calendar_pageDate = new Date();
	$objContainer = $("#"+$objContainer);
	
	if((typeof(optMonth) !="undefined" && optMonth !="") || (!_m_upDownCalendar)){
		m_calendar_pageDate = M_Calendar.resetCalendarDate($objContainer,optMonth);
	}

	var $pageYear = m_calendar_pageDate.getFullYear();      
    var $pageMonth = m_calendar_pageDate.getMonth() + 1;    
    var $pageDay = m_calendar_pageDate.getDate();           
    
 	//选中月第一天是星期几（距星期日离开的天数）
    var startDay = new Date($pageYear, $pageMonth - 1, 1).getDay();
 	var firstdate = new Date($pageYear, $pageMonth-1, 1);//选中月第一天
 	var lastMonth = new Date($pageYear, $pageMonth-2, 1);//选中月上个月第一天
	var nextMonth = new Date($pageYear, $pageMonth, 1);//选中月下月第一天
		
	var lastStr = lastMonth.getFullYear()+"-"+((lastMonth.getMonth() + 1)>9?(lastMonth.getMonth() + 1):"0"+(lastMonth.getMonth() + 1)); 
	var currentStr=$pageYear+"-"+($pageMonth>9?$pageMonth:"0"+$pageMonth);
 	var nextStr = nextMonth.getFullYear()+"-"+((nextMonth.getMonth() + 1)>9?(nextMonth.getMonth() + 1):"0"+(nextMonth.getMonth() + 1));   
		
 	var lastMothStart = M_Calendar.dateAdd("d", -startDay, firstdate).getDate();//日期第一天
 	var lastMothend = M_Calendar.dateAdd("d", -1, firstdate).getDate();//上月的最后一天

    //本月有多少天(即最后一天的getDate(),但是最后一天不知道，我们可以用"上个月的0来表示本月的最后一天")
    var nDays = new Date($pageYear, $pageMonth, 0).getDate();
    var numCol = 0;  //记录列的个数，到达7的时候创建tr
    var totalRow=1;
    var $Calendaridx; //日期
    var htm = '<tr>';
    for ($Calendaridx = lastMothStart; startDay!=0 && $Calendaridx <= lastMothend; $Calendaridx ++) {
        htm += "<td id='"+lastStr+"-"+$Calendaridx+"' onclick=\"M_Calendar.prevMonth('"+$objContainer.attr("id")+"',this)\">";
        	htm += '<div class="_m_cdar_wrap _m_cdar_notSelectMonthDay" title="'+lastStr+'-'+$Calendaridx+'">';
        		htm += '<div class="_m_cdar_date">'+$Calendaridx+'</div>';
        		htm += '<div class="_m_cdar_rainyDate">'+Rx_calendar.gDateToLunar($pageYear,$pageMonth-1,$Calendaridx)+'</div>';
        	htm += '</div>';
        htm += '</td>';
        numCol++;
    }
    for (var $jdx = 1; $jdx <= nDays; $jdx++) {
    	htm += "<td id='"+currentStr+"-"+($jdx > 9 ? $jdx : "0"+$jdx)+"' onclick=\"M_Calendar.clickDate('"+$objContainer.attr("id")+"',this)\">";
    	var dateStr = currentStr+'-'+($jdx>9?$jdx:"0"+$jdx);
    	if ($pageYear == $globalCurrentYear && $pageMonth == $globalCurrentMonth && $jdx == $globalCurrentDay) {
    		htm += '<div class="_m_cdar_wrap _m_cdar_currentCalendar" title="'+dateStr+'">';
    	}else {
            htm += '<div class="_m_cdar_wrap" title="'+dateStr+'">';
        }
        htm += '<div class="_m_cdar_date">'+$jdx+'</div>';
        htm += '<div class="_m_cdar_rainyDate">'+Rx_calendar.gDateToLunar($pageYear,$pageMonth,$jdx)+'</div></div>';
        htm += '</td>';
        if (++numCol == 7) {  
            numCol = 0;
            totalRow++;
            htm += '</tr><tr>';
        }
    }
    if(numCol==0){
    	htm = htm.substring(0,htm.length-4);
    }
    var lastNumCol = 14-numCol;
   	if(totalRow == 6){
   		lastNumCol = 7-numCol;
   	}
   	for(var $jdx = 1; $jdx<=lastNumCol; $jdx++){
   		if(numCol == 0){
   			htm += "<tr>";
   		}
       	htm += "<td  id='"+nextStr+"-"+($jdx > 9 ? $jdx : "0"+$jdx)+"' onclick=\"M_Calendar.nextMonth('"+$objContainer.attr("id")+"',this)\">";
       		htm += '<div class="_m_cdar_wrap _m_cdar_notSelectMonthDay" title="'+nextStr+'-'+($jdx>9?$jdx:"0"+$jdx)+'">';
       		htm += '<div class="_m_cdar_date">'+$jdx+'</div>';
       		htm += '<div class="_m_cdar_rainyDate">'+Rx_calendar.gDateToLunar($pageYear,$pageMonth+1,$jdx)+'</div></div>';
       	htm += '</td>';
       	if (++numCol == 7) {  
            numCol = 0;
            totalRow++;
            htm += '</tr>';
        }
   	}
    return htm;
};

M_Calendar.prevMonth = function(objContainerid,dateObj){

	if(Swipe_sildeCalendar){
		_m_isSildeMonth = false;
		Swipe_sildeCalendar.swipePrev();
		_m_isSildeMonth = true;
	}

	var $dateValue = "";
 	if(dateObj!=""){
 		$dateValue = $(dateObj).attr("id");
 	}
 	var $objContainer = M_Calendar.stringToObj(objContainerid);
 	var currentCalendarDateObj = M_Calendar.resetCalendarDate(objContainerid,"");
 	var rCalendarYear = currentCalendarDateObj.getFullYear();
 	var rCalendayMonth = currentCalendarDateObj.getMonth()+1;
	rCalendayMonth = rCalendayMonth > 9 ? rCalendayMonth : "0" + rCalendayMonth;
	
	$('div',$objContainer).removeClass("_m_cdar_currentSelect");
	var curActiveSilde = $(Swipe_sildeCalendar.getSlide(Swipe_sildeCalendar.activeIndex));
	if($dateValue != ""){
		$recordSelectDate = $dateValue;
 		$('div[title="'+$dateValue+'"]',curActiveSilde).addClass("_m_cdar_currentSelect");
 		if(rCalendarYear == $globalCurrentYear && rCalendayMonth == $globalCurrentMonth){
	 		$curMonthSelectDate = $dateValue;
 		}
 	}
 	if(rCalendarYear == $globalCurrentYear && rCalendayMonth == $globalCurrentMonth){
 		if($curMonthSelectDate != ""){
			$('div[title="'+$curMonthSelectDate+'"]',curActiveSilde).addClass("_m_cdar_currentSelect");
		}else{
			$('div[title="'+$globalCurrentYMD+'"]',curActiveSilde).addClass("_m_cdar_currentSelect");
		}
 	}
 	M_Calendar.monthChange(objContainerid,$dateValue,$dateValue);
 	M_Calendar.dayChange(objContainerid,$dateValue,$dateValue);
};

M_Calendar.slidePrevMonth = function(objContainerid,dateObj){

	var _m_cdar_classname = M_Calendar.copyClassName(objContainerid);
 	var $objContainer = M_Calendar.stringToObj(objContainerid);
	var currentCalendarDateObj = M_Calendar.resetCalendarDate(objContainerid,"prevMonth");
	var rCalendarYear = currentCalendarDateObj.getFullYear();
 	var rCalendayMonth = currentCalendarDateObj.getMonth()+1;
	rCalendayMonth = rCalendayMonth > 9 ? rCalendayMonth : "0" + rCalendayMonth;
	
	M_Calendar.changeYearMonth(rCalendarYear, currentCalendarDateObj.getMonth()+1);
	
	var monthHtml = "";
	if(Swipe_sildeCalendar.activeIndex == 0){ //silde活动索引为0时,需要重新计算上个月和下个月
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"prevMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(2)).html(monthHtml);
		$(Swipe_sildeCalendar.getSlide(3)).html($(Swipe_sildeCalendar.getSlide(0)).html());//当前滑动的月份
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"nextMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(4)).html(monthHtml);
	}else if(Swipe_sildeCalendar.activeIndex == 1){
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"prevMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(0)).html(monthHtml);
	}else if(Swipe_sildeCalendar.activeIndex == 2){ //silde活动索引为2时,需要重新计算上个月和下个月
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"prevMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(1)).html(monthHtml); //上月
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"nextMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(3)).html(monthHtml); //下月
	}

	if(_m_isSildeMonth){ //滑动月份
		if(rCalendarYear == $globalCurrentYear && rCalendayMonth == $globalCurrentMonth){
	 		if($curMonthSelectDate != ""){
				$('div[title="'+$curMonthSelectDate+'"]',$objContainer).addClass("_m_cdar_currentSelect");
			}else{
				$('div[title="'+$globalCurrentYMD+'"]',$objContainer).addClass("_m_cdar_currentSelect");
			}
	 	}
	 	var firstDay = rCalendarYear+"-"+rCalendayMonth+"-01";
	 	var LastDay = rCalendarYear+"-"+rCalendayMonth+"-"+new Date(rCalendarYear,currentCalendarDateObj.getMonth()+1,0).getDate();
	 	M_Calendar.monthChange(objContainerid,firstDay,LastDay);
 		M_Calendar.dayChange(objContainerid,firstDay,LastDay);
	}
};

M_Calendar.nextMonth = function(objContainerid,dateObj){

	if(Swipe_sildeCalendar){
		_m_isSildeMonth = false;
		Swipe_sildeCalendar.swipeNext();
		_m_isSildeMonth = true;
	}

	var $dateValue = "";
 	if(dateObj!=""){
 		$dateValue = $(dateObj).attr("id");
 	}
 	var $objContainer = M_Calendar.stringToObj(objContainerid);
 	var currentCalendarDateObj = M_Calendar.resetCalendarDate(objContainerid,"");
 	var rCalendarYear = currentCalendarDateObj.getFullYear();
 	var rCalendayMonth = currentCalendarDateObj.getMonth()+1;
	rCalendayMonth = rCalendayMonth > 9 ? rCalendayMonth : "0" + rCalendayMonth;
	
	$('div',$objContainer).removeClass("_m_cdar_currentSelect");
	var curActiveSilde = $(Swipe_sildeCalendar.getSlide(Swipe_sildeCalendar.activeIndex));
	if($dateValue != ""){
		$recordSelectDate = $dateValue;
 		$('div[title="'+$dateValue+'"]',curActiveSilde).addClass("_m_cdar_currentSelect");
 		if(rCalendarYear == $globalCurrentYear && rCalendayMonth == $globalCurrentMonth){
	 		$curMonthSelectDate = $dateValue;
 		}
 	}
 	if(rCalendarYear == $globalCurrentYear && rCalendayMonth == $globalCurrentMonth){
 		if($curMonthSelectDate != ""){
			$('div[title="'+$curMonthSelectDate+'"]',curActiveSilde).addClass("_m_cdar_currentSelect");
		}else{
			$('div[title="'+$globalCurrentYMD+'"]',curActiveSilde).addClass("_m_cdar_currentSelect");
		}
 	}
 	M_Calendar.monthChange(objContainerid,$dateValue,$dateValue);
 	M_Calendar.dayChange(objContainerid,$dateValue,$dateValue);
};

M_Calendar.slideNextMonth = function(objContainerid,dateObj){

	var _m_cdar_classname = M_Calendar.copyClassName(objContainerid);
 	var $objContainer = M_Calendar.stringToObj(objContainerid);
	var currentCalendarDateObj = M_Calendar.resetCalendarDate(objContainerid,"nextMonth");
	var rCalendarYear = currentCalendarDateObj.getFullYear();
 	var rCalendayMonth = currentCalendarDateObj.getMonth()+1;
	rCalendayMonth = rCalendayMonth > 9 ? rCalendayMonth : "0" + rCalendayMonth;
	
	M_Calendar.changeYearMonth(rCalendarYear, currentCalendarDateObj.getMonth()+1);
	
	var monthHtml = "";
	if(Swipe_sildeCalendar.activeIndex == 2){ //silde活动索引为2时,需要重新计算上个月和下个月
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"prevMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(1)).html(monthHtml);
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"nextMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(3)).html(monthHtml);
	}else if(Swipe_sildeCalendar.activeIndex == 3){
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"nextMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(4)).html(monthHtml);
	}else if(Swipe_sildeCalendar.activeIndex == 4){ //silde活动索引为4时,需要重新计算上个月和下个月
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"prevMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(0)).html(monthHtml); //上月
		$(Swipe_sildeCalendar.getSlide(1)).html($(Swipe_sildeCalendar.getSlide(4)).html());//当前滑动的月份
		monthHtml = "<table class=\"_m_cdar_loadCalendarDay"+_m_cdar_classname+"\">"+M_Calendar.loadCalendarData(objContainerid,"nextMonth")+"</table>";
		$(Swipe_sildeCalendar.getSlide(2)).html(monthHtml); //下月
	}
	
	if(_m_isSildeMonth){ //滑动月份
		//$('div',$objContainer).removeClass("_m_cdar_currentSelect");
	 	if(rCalendarYear == $globalCurrentYear && rCalendayMonth == $globalCurrentMonth){
	 		if($curMonthSelectDate != ""){
				$('div[title="'+$curMonthSelectDate+'"]',$objContainer).addClass("_m_cdar_currentSelect");
			}else{
				$('div[title="'+$globalCurrentYMD+'"]',$objContainer).addClass("_m_cdar_currentSelect");
			}
	 	}
	 	var firstDay = rCalendarYear+"-"+rCalendayMonth+"-01";
	 	var LastDay = rCalendarYear+"-"+rCalendayMonth+"-"+new Date(rCalendarYear,currentCalendarDateObj.getMonth()+1,0).getDate();
	 	M_Calendar.monthChange(objContainerid,firstDay,LastDay);
 		M_Calendar.dayChange(objContainerid,firstDay,LastDay);
	}
};

M_Calendar.resetCalendarSwitchWeek = function(objContainerid,curWeekidx){

	var curActiveIndex = Swipe_sildeCalendar.activeIndex;
	var curActiveSilde = $(Swipe_sildeCalendar.getSlide(curActiveIndex));
	var _m_cdar_classname = M_Calendar.copyClassName(objContainerid);
	var loadDispMonthCalendarDay = curActiveSilde.find("table");
	$("td[class='_m_cdar_calendarPlanDiv']",loadDispMonthCalendarDay).each(function(idx){
		calendarPlanArray[idx] = $(this).attr("id");
	});
	var curWeekSundayDateV = loadDispMonthCalendarDay.find("tr").eq(curWeekidx).find("td").eq(0).attr("id");
 	var prevWeekHtml = M_Calendar.prevWeek(objContainerid,curWeekSundayDateV);
 	var copyCurrWeekHtml = loadDispMonthCalendarDay.find("tr").eq(curWeekidx).html();
 	copyCurrWeekHtml = copyCurrWeekHtml.replaceAll("prevMonth","clickDate");
 	copyCurrWeekHtml = copyCurrWeekHtml.replaceAll("nextMonth","clickDate");
	var currWeekHtml = "<tr>"+copyCurrWeekHtml+"</tr>";
	var curWeekSaturDateV = loadDispMonthCalendarDay.find("tr").eq(curWeekidx).find("td").eq(6).attr("id");
	var nextWeekHtml = M_Calendar.nextWeek(objContainerid,curWeekSaturDateV);
	
	Swipe_sildeCalendar.removeAllSlides();
	var loadPrevMonthCalendarDay = "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+prevWeekHtml+"</table></div>";
	var loadDispMonthCalendarDay = "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+currWeekHtml+"</table></div>";
	var loadNextMonthCalendarDay = "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\">"+nextWeekHtml+"</table></div>";
	var fillSilde = "<div class=\"swiper-slide\"><table class=\"_m_cdar_loadCalendarDay swiper-slide"+_m_cdar_classname+"\"><tr><td colspan=\"7\"></td></tr></table></div>";
	
	if(curActiveIndex == 0){
		$("#_m_cdar_loadCalendarDay_Container").append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay).append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay);
	}else if(curActiveIndex == 1){
		$("#_m_cdar_loadCalendarDay_Container").append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay).append(fillSilde).append(fillSilde);
	}else if(curActiveIndex == 2){
		$("#_m_cdar_loadCalendarDay_Container").append(loadNextMonthCalendarDay).append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay).append(loadPrevMonthCalendarDay);
	}else if(curActiveIndex == 3){
		$("#_m_cdar_loadCalendarDay_Container").append(fillSilde).append(fillSilde).append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay);
	}else if(curActiveIndex == 4){
		$("#_m_cdar_loadCalendarDay_Container").append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay).append(loadNextMonthCalendarDay).append(loadPrevMonthCalendarDay).append(loadDispMonthCalendarDay);
	}
	$("._m_cdar_loadCalendarDay").each(function(){
		$(this).find("tr").addClass("_m_cdar_currentWeek");
	});
	
	if(Swipe_sildeCalendar){
		Swipe_sildeCalendar.reInit(); //切换周模式重新初始化Swiper(日历滑动)
	}
	M_Calendar.monthChange(objContainerid,"","");
	//M_Calendar.dayChange(objContainerid,curWeekSundayDateV,curWeekSaturDateV);
};

M_Calendar.slidePrevWeek = function(objContainerid){

	var curActiveIndex = Swipe_sildeCalendar.activeIndex;
	var curActiveSilde = $(Swipe_sildeCalendar.getSlide(curActiveIndex));
	var _m_cdar_classname = M_Calendar.copyClassName(objContainerid);
	var curWeekObj = curActiveSilde.find("table").find("tr").eq(0).find("td");
	var curWeekSundayDateV = curWeekObj.eq(0).attr("id");
	var curWeekLastDay = curWeekObj.eq(6).attr("id");
	var prevWeekHtml = "<table class=\"_m_cdar_loadCalendarDay"+_m_cdar_classname+"\">"+M_Calendar.prevWeek(objContainerid,curWeekSundayDateV)+"</table>";
	if(curActiveIndex == 0){ //silde活动索引为0时,需要重新计算上个星期和下个星期
		$(Swipe_sildeCalendar.getSlide(2)).html(prevWeekHtml); //上个星期
		$(Swipe_sildeCalendar.getSlide(3)).html($(Swipe_sildeCalendar.getSlide(0)).html()); //当前滑动的星期
		$(Swipe_sildeCalendar.getSlide(4)).html($(Swipe_sildeCalendar.getSlide(1)).html()); //下个星期
	}else if(curActiveIndex == 1){
		$(Swipe_sildeCalendar.getSlide(0)).html(prevWeekHtml);
	}else if(curActiveIndex == 2){ //silde活动索引为2时,需要重新计算上个星期和下个星期
		$(Swipe_sildeCalendar.getSlide(1)).html(prevWeekHtml); //上个星期
		$(Swipe_sildeCalendar.getSlide(3)).html($(Swipe_sildeCalendar.getSlide(0)).html()); //下个星期
	}
	
	curWeekLastDayArray = curWeekLastDay.split("-");
	var rCalendarYear = curWeekLastDayArray[0];
 	var rCalendayMonth = curWeekLastDayArray[1];
 	if(rCalendayMonth < 10){
 		rCalendayMonth = curWeekLastDayArray[1].replace("0","");
 	}
	M_Calendar.changeYearMonth(rCalendarYear, rCalendayMonth);
	
	$("._m_cdar_loadCalendarDay").each(function(){
		$(this).find("tr").addClass("_m_cdar_currentWeek");
	});
	
	M_Calendar.monthChange(objContainerid,curWeekSundayDateV,curWeekLastDay);
	M_Calendar.dayChange(objContainerid,curWeekSundayDateV,curWeekLastDay);
};

M_Calendar.prevWeek = function(objContainerid,curWeekSundayDateV){

	var prevWeekHtml = "<tr>";
	var curWeekSundayDateArray = curWeekSundayDateV.split("-");
	var curWeekSundayYear = curWeekSundayDateArray[0];
	var curWeekSundayMonth = curWeekSundayDateArray[1];
	var curWeekSunday = curWeekSundayDateArray[2];
	var curWeekSundayDate = new Date(curWeekSundayYear,curWeekSundayMonth,0);
	var curWeekSundayNum = curWeekSundayDate.getDate();
	var difnum = curWeekSundayNum-(curWeekSundayNum-curWeekSunday+1);
	var numCol = 0;
	if(difnum < 7){
		var startDay = new Date(curWeekSundayYear, curWeekSundayMonth - 1, 1).getDay();
	 	var firstdate = new Date(curWeekSundayYear, curWeekSundayMonth-1, 1);//选中月第一天
	 	var lastMonth = new Date(curWeekSundayYear, curWeekSundayMonth-2, 1);//选中月上个月第一天
		var lastStr = lastMonth.getFullYear()+"-"+((lastMonth.getMonth() + 1)>9?(lastMonth.getMonth() + 1):"0"+(lastMonth.getMonth() + 1)); 
		var currentStr=curWeekSundayYear+"-"+(curWeekSundayMonth>9?curWeekSundayMonth:"0"+curWeekSundayMonth);
	 	var lastMothStart = M_Calendar.dateAdd("d", -startDay, firstdate).getDate();//日期第一天
	 	var lastMothend = M_Calendar.dateAdd("d", -1, firstdate).getDate();//上月的最后一天
	 	var Calendaridx; //日期
	    for (Calendaridx = lastMothStart; startDay!=0 && Calendaridx <= lastMothend; Calendaridx ++) {
	    	 prevWeekHtml += "<td id='"+lastStr+"-"+Calendaridx+"' onclick=\"M_Calendar.clickDate('"+objContainerid+"',this)\">";
	        	prevWeekHtml += '<div class="_m_cdar_wrap" title="'+lastStr+'-'+Calendaridx+'">';
	        		prevWeekHtml += '<div class="_m_cdar_date">'+Calendaridx+'</div>';
	        		prevWeekHtml += '<div class="_m_cdar_rainyDate">'+Rx_calendar.gDateToLunar(curWeekSundayYear,curWeekSundayMonth-1,Calendaridx)+'</div>';
	        	prevWeekHtml += '</div>';
	        prevWeekHtml += '</td>';
	        numCol++;
	    }
	}
	for(var idx = (7-numCol); idx > 0; idx--){
		var nextWeekDate = M_Calendar.dateAdd("d", -idx, new Date(curWeekSundayYear,(parseInt(curWeekSundayMonth)-1),curWeekSunday));
		var nextWeekCorYear = nextWeekDate.getFullYear();
		var nextWeekCorMonth = nextWeekDate.getMonth()+1 > 9 ? nextWeekDate.getMonth()+1 : "0" +(nextWeekDate.getMonth()+1);
		var nextWeekCorDay = (nextWeekDate.getDate() > 9 ? nextWeekDate.getDate() : "0" + nextWeekDate.getDate());
		var nextWeekCorDate = nextWeekCorYear+"-"+nextWeekCorMonth+"-"+nextWeekCorDay;
		prevWeekHtml += "<td id='"+nextWeekCorDate+"' onclick=\"M_Calendar.clickDate('"+objContainerid+"',this)\">";  
        if (nextWeekCorYear == $globalCurrentYear && nextWeekCorMonth== $globalCurrentMonth && nextWeekCorDay == $globalCurrentDay) {
            prevWeekHtml += '<div class="_m_cdar_wrap _m_cdar_currentCalendar" title="'+nextWeekCorDate+'">';
        }else {
            prevWeekHtml += '<div class="_m_cdar_wrap" title="'+nextWeekCorDate+'">';
        }
        prevWeekHtml += '<div class="_m_cdar_date">'+nextWeekDate.getDate()+'</div>';
        prevWeekHtml += '<div class="_m_cdar_rainyDate">'+Rx_calendar.gDateToLunar(nextWeekCorYear,nextWeekCorMonth,nextWeekCorDay)+'</div></div>';
        prevWeekHtml += '</td>';
	}
	prevWeekHtml += "</tr>";
	return prevWeekHtml;
};

M_Calendar.slideNextWeek = function(objContainerid){

	var curActiveIndex = Swipe_sildeCalendar.activeIndex;
	var curActiveSilde = $(Swipe_sildeCalendar.getSlide(curActiveIndex));
	var _m_cdar_classname = M_Calendar.copyClassName(objContainerid);
	var curWeekObj = curActiveSilde.find("table").find("tr").eq(0).find("td");
	var curWeekFirstDay = curWeekObj.eq(0).attr("id");
	var curWeekLastDay = curWeekObj.eq(6).attr("id");
	var nextWeekSaturDateV = curWeekLastDay;
	var nextWeekHtml = "<table class=\"_m_cdar_loadCalendarDay"+_m_cdar_classname+"\">"+M_Calendar.nextWeek(objContainerid,nextWeekSaturDateV)+"</table>";
	if(curActiveIndex == 2){ //silde活动索引为2时,需要重新计算上个星期和下个星期
		$(Swipe_sildeCalendar.getSlide(1)).html($(Swipe_sildeCalendar.getSlide(4)).html());
		$(Swipe_sildeCalendar.getSlide(3)).html(nextWeekHtml);
	}else if(curActiveIndex == 3){
		$(Swipe_sildeCalendar.getSlide(4)).html(nextWeekHtml);
	}else if(curActiveIndex == 4){ //silde活动索引为4时,需要重新计算上个星期和下个星期
		$(Swipe_sildeCalendar.getSlide(0)).html($(Swipe_sildeCalendar.getSlide(3)).html()); //上个星期
		$(Swipe_sildeCalendar.getSlide(1)).html($(Swipe_sildeCalendar.getSlide(4)).html());//当前滑动的星期
		$(Swipe_sildeCalendar.getSlide(2)).html(nextWeekHtml); //下个星期
	}
	curWeekLastDayArray = curWeekLastDay.split("-");
	var rCalendarYear = curWeekLastDayArray[0];
 	var rCalendayMonth = curWeekLastDayArray[1];
 	if(rCalendayMonth < 10){
 		rCalendayMonth = rCalendayMonth.replace("0","");
 	}
	M_Calendar.changeYearMonth(rCalendarYear, rCalendayMonth);
	
	$("._m_cdar_loadCalendarDay").each(function(){
		$(this).find("tr").addClass("_m_cdar_currentWeek");
	});
	
	M_Calendar.monthChange(objContainerid,curWeekFirstDay,curWeekLastDay);
	M_Calendar.dayChange(objContainerid,curWeekFirstDay,curWeekLastDay);
};

M_Calendar.nextWeek = function(objContainerid,curWeekSaturDateV){
	
	var nextWeekHtml = "<tr>";
	var curWeekSaturdayDateArray = curWeekSaturDateV.split("-");
	var curWeekSaturdayCorYear = curWeekSaturdayDateArray[0];
	var curWeekSaturdayCorMonth = parseInt(curWeekSaturdayDateArray[1])-1;
	var curWeekSaturdayCorDay = curWeekSaturdayDateArray[2];
	for(var idx = 1; idx <= 7; idx++){
		var nextWeekDate = M_Calendar.dateAdd("d", idx, new Date(curWeekSaturdayCorYear,curWeekSaturdayCorMonth,curWeekSaturdayCorDay));
		var nextWeekCorYear = nextWeekDate.getFullYear();
		var nextWeekCorMonth = (nextWeekDate.getMonth()+1 > 9 ? nextWeekDate.getMonth()+1 : "0" + (nextWeekDate.getMonth()+1));
		var nextWeekCorDay = (nextWeekDate.getDate() > 9 ? nextWeekDate.getDate() : "0" + nextWeekDate.getDate());
		var nextWeekCorDate = nextWeekCorYear+"-"+nextWeekCorMonth+"-"+nextWeekCorDay;
		nextWeekHtml += "<td id='"+nextWeekCorDate+"' onclick=\"M_Calendar.clickDate('"+objContainerid+"',this)\">";  
        if (nextWeekCorYear == $globalCurrentYear && nextWeekCorMonth== $globalCurrentMonth && nextWeekCorDay == $globalCurrentDay) {
            nextWeekHtml += '<div class="_m_cdar_wrap _m_cdar_currentCalendar" title="'+nextWeekCorDate+'">';
        }else {
            nextWeekHtml += '<div class="_m_cdar_wrap" title="'+nextWeekCorDate+'">';
        }
        nextWeekHtml += '<div class="_m_cdar_date">'+nextWeekDate.getDate()+'</div>';
        nextWeekHtml += '<div class="_m_cdar_rainyDate">'+Rx_calendar.gDateToLunar(nextWeekCorYear,nextWeekCorMonth,nextWeekCorDay)+'</div></div>';
        nextWeekHtml += '</td>';
	}
	nextWeekHtml += "</tr>";
	return nextWeekHtml;
};

M_Calendar.clickDate = function(objContainerid,obj){
	var $objContainer = M_Calendar.stringToObj(objContainerid);
	$('div',$objContainer).removeClass("_m_cdar_currentSelect");
	var divObj = $(obj,$objContainer).children('div').eq(0);
	$(divObj).addClass("_m_cdar_currentSelect");
	var selectDate = $(obj).attr("id");
	var currentCalendarDateObj = new Date(selectDate.replaceAll("-","/"));
	var rCalendarYear = currentCalendarDateObj.getFullYear();
 	var rCalendayMonth = currentCalendarDateObj.getMonth()+1;
	M_Calendar.changeYearMonth(rCalendarYear, rCalendayMonth);
	$recordSelectDate = selectDate;
	if(selectDate.split("-")[0] == $globalCurrentYear && selectDate.split("-")[1] == $globalCurrentMonth){
		$curMonthSelectDate = selectDate;
	}
	M_Calendar.dayChange(objContainerid,selectDate,selectDate);
};

M_Calendar.dateAdd = function(interval, number, idate) {
   var date=new Date(idate.getFullYear(),idate.getMonth(),idate.getDate());
   number = parseInt(number);
   switch (interval) {
       case "y": date.setFullYear(date.getFullYear() + number); break;
       case "m": date.setMonth(date.getMonth() + number); break;
       case "d": date.setDate(date.getDate() + number); break;
       case "w": date.setDate(date.getDate() + 7 * number); break;
       case "h": date.setHours(date.getHours() + number); break;
       case "n": date.setMinutes(date.getMinutes() + number); break;
       case "s": date.setSeconds(date.getSeconds() + number); break;
       case "l": date.setMilliseconds(date.getMilliseconds() + number); break;
   }
   return date;
};

M_Calendar.stringToObj = function(objContainerid){
	if(typeof(objContainerid) == "string"){
		return $("#"+objContainerid);
	}
	return objContainerid;
};

M_Calendar.resetCalendarDate = function(objContainerid,optMonth){
	
	var curSelectYear = $("#_m_cdar_calendarYear",M_Calendar.stringToObj(objContainerid)).text().substring(0,4);
	var curSelectMonth = $("#_m_cdar_calendarMonth_num",M_Calendar.stringToObj(objContainerid)).val();
		//curSelectMonth = curSelectMonth.substring(0,curSelectMonth.length-1);
	var reset_calendar_pageDate = new Date(curSelectYear,curSelectMonth-1); //此种参数传递需要减一月
	if("prevMonth"==optMonth){
 		reset_calendar_pageDate.setMonth(reset_calendar_pageDate.getMonth()-1);
	}else if("nextMonth"==optMonth){
 		reset_calendar_pageDate.setMonth(reset_calendar_pageDate.getMonth()+1);
	}
	if(reset_calendar_pageDate.getFullYear() == $globalCurrentYear && reset_calendar_pageDate.getMonth() + 1 == $globalCurrentMonth){
		reset_calendar_pageDate.setDate($globalCurrentDay);
	}
	return reset_calendar_pageDate;
};

M_Calendar.getCurSelectDate = function(objContainerid){

	var curActiveSilde = $(Swipe_sildeCalendar.getSlide(Swipe_sildeCalendar.activeIndex));
	var curSelectDate = $("div[class='_m_cdar_wrap _m_cdar_currentSelect']",curActiveSilde);
	if(curSelectDate.length == 0){
		curSelectDate = $("div[class='_m_cdar_wrap _m_cdar_currentCalendar _m_cdar_currentSelect']",curActiveSilde);
	}
	return curSelectDate;
};

M_Calendar.copyClassName = function(objContainerid){
	
	var curActiveSilde = $(Swipe_sildeCalendar.getSlide(Swipe_sildeCalendar.activeIndex));
	var $loadDispMonthCalendarDay = curActiveSilde.find("table");
 	var _m_cdar_classname = "";
 	if($loadDispMonthCalendarDay.hasClass("_m_cdar_noneLunar")){
 		_m_cdar_classname = " _m_cdar_noneLunar";
 	}
 	return _m_cdar_classname;
};

M_Calendar.monthChange = function(objContainerid,dateV1,dateV2){

	if(typeof(Mobile_NS) != "undefined" && typeof(Mobile_NS.Calendar) != "undefined"){
		Mobile_NS.Calendar.monthChange(objContainerid,dateV1,dateV2);
	}
};

M_Calendar.dayChange = function(objContainerid,dateV1,dateV2){

	if(typeof(Mobile_NS) != "undefined" && typeof(Mobile_NS.Calendar) != "undefined" && dateV1 != "" && dateV2 != ""){
		Mobile_NS.Calendar.dayChange(objContainerid, dateV1, dateV2);
	}
};

M_Calendar.addData = function(objContainerid){
	
	var $objContainer = M_Calendar.stringToObj(objContainerid);
	if(typeof(Mobile_NS) != "undefined" && typeof(Mobile_NS.Calendar) != "undefined"){
		var dateV = $("div[class='_m_cdar_wrap _m_cdar_currentSelect']",$objContainer).attr("title");
		if(typeof(dateV) == "undefined"){
			dateV = $("div[class='_m_cdar_wrap _m_cdar_currentCalendar _m_cdar_currentSelect']",$objContainer).attr("title");
		}
		if(typeof(dateV) == "undefined"){
			dateV = "";
		}
		Mobile_NS.Calendar.addData(objContainerid,dateV);
	}
};

M_Calendar.changeYearMonth = function(calYear, calMonth){
	if(_calLanguage == 8){
		$("#_m_cdar_calendarYear").html(calYear + " ");	
		$("#_m_cdar_calendarMonth").html(months_en[calMonth]);
		$("#_m_cdar_calendarMonth_num").val(calMonth);
	}else{
		$("#_m_cdar_calendarYear").html(calYear+"年");	
		$("#_m_cdar_calendarMonth").html(calMonth+"月");
		$("#_m_cdar_calendarMonth_num").val(calMonth);
	}
};

String.prototype.replaceAll = function(s1,s2) { 
	if(typeof(s1) != "undefined" && typeof(s2) != "undefined"){
		 return this.replace(new RegExp(s1,"gm"),s2); 
	} 
}
