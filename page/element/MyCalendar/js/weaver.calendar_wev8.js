/**
* Created by HuangGuanGuan on 2017/06/22.
* 
*/
; (function($) {
    var currentToday=new Date();
    
    var lunarInfo=new Array(
		0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
		0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
		0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
		0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
		0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
		0x06ca0,0x0b550,0x15355,0x04da0,0x0a5d0,0x14573,0x052d0,0x0a9a8,0x0e950,0x06aa0,
		0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
		0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b5a0,0x195a6,
		0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
		0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
		0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
		0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
		0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
		0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
		0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0)
		 
		var solarMonth=new Array(31,28,31,30,31,30,31,31,30,31,30,31);
		var Animals=new Array("鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪");
		var solarTerm = new Array("小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至");
		var sTermInfo = new Array(0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,462224,483532,504758);
		var nStr1 = new Array('日','一','二','三','四','五','六','七','八','九','十');
		var nStr2 = new Array('初','十','廿','卅');
		var nStr3 = new Array('','正','二','三','四','五','六','七','八','九','十','冬','腊');
		//公历节日
		var sFtv = new Array(
		"0101 元旦",
		"0214 情人节",
		"0308 妇女节",
		"0312 植树节",
		"0401 愚人节",
		"0501 劳动节",
		"0504 青年节",
		"0512 护士节",
		"0601 儿童节",
		"0701 建党节",
		"0801 建军节",
		"0910 教师节",
		"1001 国庆",
		"1224 平安夜",
		"1225 圣诞节")
		//农历节日
		var lFtv = new Array(
		"0101 春节",
		"0115 元宵",
		"0505 端午",
		"0707 七夕",
		"0715 中元",
		"0815 中秋",
		"0909 重阳",
		"1208 腊八",
		"1224 小年")
	
	var i18n_7 = {
        sun: "日",
        mon: "一",
        tue: "二",
        wed: "三",
        thu: "四",
        fri: "五",
        sat: "六",
        Sunday: "星期日",
        Monday: "星期一",
        Tuesday: "星期二",
        Wednesday: "星期三",
        Thursday: "星期四",
        Friday: "星期五",
        Saturday: "星期六",
        today: "今天",
        prev_month_title:"上一个月",
        next_month_title:"下一个月"
    	};
    	
    var i18n_8 = {
        sun: "Sun",
        mon: "Mon",
        tue: "Tues",
        wed: "Wed",
        thu: "Thur",
        fri: "Fri",
        sat: "Sat",
        Sunday: "Sunday",
        Monday: "Monday",
        Tuesday: "Tuesday",
        Wednesday: "Wednesday",
        Thursday: "Thursday",
        Friday: "Friday",
        Saturday: "Saturday",
        today: "Today",
        prev_month_title:"Last Month",
        next_month_title:"Next Month"
    	};
    	
    var i18n_9 = {
        sun: "日",
        mon: "一",
        tue: "二",
        wed: "三",
        thu: "四",
        fri: "五",
        sat: "六",
        Sunday: "星期日",
        Monday: "星期一",
        Tuesday: "星期二",
        Wednesday: "星期三",
        Thursday: "星期四",
        Friday: "星期五",
        Saturday: "星期六",
        today: "今天",
        prev_month_title:"上一個月",
        next_month_title:"下一個月"
    	};

		
	//插件扩展方法
	$.fn.weaverCalendar = function(options){
        //插件默认属性
        var defaults = {
        	//语言,默认 7 简体中文
        	langId:7,
        	//点击日期自定义处理事件
            CusClickDate:null,
            //获取日历数据,给有数据的日期增加背景色
            getDataUrl:"",
            //显示农历.默认不显示. 如果显示会根据语言. 默认只要简体中文和繁体时显示
            showChineseDay:false,
            //星期天颜色 推荐 red;
            SundayColor:"#000",
            //星期六颜色 推荐 #F045E8
            SaturdayColor:"#000",
            //一周第一天. 0 for Sun, 1 for Mon, 2 for Tue
            weekstartday:0
        }
		//合并自定义扩展属性
        var options = $.extend(defaults,options);
        var i18n={};
        //根据语言合并资源
        if(options.langId==7){
        	i18n=$.extend(i18n,i18n_7);
        }else if(options.langId==9){
        	i18n=$.extend(i18n,i18n_9);
        }else{
        	i18n=$.extend(i18n,i18n_8);
        }
        options.i18n=i18n;
        //检查 weekstartday有效性
        if(options.weekstartday>6||options.weekstartday<0) options.weekstartday=0;
        
        var lastOpt;
        var lastOptCss="";
        var pageDate=new Date();
        var currentSelectDate="";

        this.each(function(){
			if((options.langId==7||options.langId==9)&&options.showChineseDay){

			}else{
				options.showChineseDay=false;
			}
            var _this = $(this);
            var html='<table class="CalendarTable" width="100%" border=0>'+
				        '<tr>'+
				            '<td>'+
				                '<table height="80" width="100%">'+
				                       '<tr align="center">'+
				                       	'<td  class="hand todayClick" align="center" width="33%" title="'+options.i18n.today+'">'+
				                       		'<span class="currentDay">'+currentToday.getDate()+'</span>'+
				                       		'<br>'+
				                       		'<span class="currentWeekDay" >'+getWeekDay(currentToday.getDay(),options)+'</span>'+
				                       	'</td>'+
				                           '<td align="center" style="border-left:#E4E1E1 1px solid;">'+
				                           	'<div style="display: inline-block;">'+
				                                '<div class="LeftArrow " target="prevbtn" title="'+options.i18n.prev_month_title+'"></div>'+
				                                '<div class="changeMonth showDate"></div>'+
				                                '<div class="RightArrow " target="nextbtn" title="'+options.i18n.next_month_title+'"></div>'+
				                                '</div>'+
				                           '</td>'+
				                       '</tr>'+
				                       '<tr style="height:1px!important;" class="Spacing">'+
										'<td class="paddingLeft0" colspan="2">'+
											'<div class="intervalDivClass">'+
										'</div></td>'+
									'</tr>'+
				                '</table>'+
				                '<table class="LDay ';
				                if(options.showChineseDay){
				                	html+='ChineseDay';
				                }
				                html+='"  width="100%">'+
								      
								'</table>'+
				            '</td>'+
				        '</tr>'+
				    '</table>';
    		$(_this).html(html);
    		
    		jQuery(".LeftArrow").hover(function(){
				jQuery(this).addClass("LeftArrow2");
			},function(){
				jQuery(this).removeClass("LeftArrow2");
			});
			jQuery(".RightArrow").hover(function(){
				jQuery(this).addClass("RightArrow2");
			},function(){
				jQuery(this).removeClass("RightArrow2");
			});
			
    		$(_this).find('.LeftArrow').click(function(){
    			prev(this,options,_this);
    		});
    		$(_this).find('.RightArrow').click(function(){
    			next(this,options,_this);
    		});
    		$(_this).find('.todayClick').click(function(){
				pageDate=new Date(currentToday.getFullYear(),currentToday.getMonth(),currentToday.getDate());
				calendar(_this,options);
    		});
    		calendar(_this,options);
        });
		
		
		
	    //实现日历
	    function calendar(_this,options,showObj) {
	        var lastPageDate=new Date(pageDate.getFullYear(),pageDate.getMonth(),1);
	    	var nextPageDate=new Date(pageDate.getFullYear(),pageDate.getMonth(),1);
	    	lastPageDate.setDate(1);//设置本月第一天
	 		lastPageDate.setMonth(pageDate.getMonth() - 1);
	 		
	 		nextPageDate.setDate(1);//设置本月第一天
	 		nextPageDate.setMonth(pageDate.getMonth() + 1);
	 	
	    	var lastLunarCalendar=new LunarCalendar(lastPageDate.getFullYear()+'',lastPageDate.getMonth()+''); 
	    	var currentLunarCalendar=new LunarCalendar(pageDate.getFullYear()+'',pageDate.getMonth()+''); 
	    	var nextLunarCalendar=new LunarCalendar(nextPageDate.getFullYear()+'',nextPageDate.getMonth()+'');
    		
	        var year = pageDate.getFullYear();      //选中年
	        var month = pageDate.getMonth() + 1;    //选中月
	        var day = pageDate.getDate();           //选中日
			var todayY=currentToday.getFullYear();//本年
			var todayM=currentToday.getMonth()+1;//本月
			var todayD=currentToday.getDate();//今天
			var todayStr=todayY+"-"+(todayM>9?todayM:"0"+todayM)+"-"+(todayD>9?todayD:"0"+todayD);
			var selectDate=year+"-"+(month>9?month:"0"+month)+"-"+(day>9?day:"0"+day);
			if(options.langId==7||options.langId==9){
	 			$(_this).find(".showDate").html(year+"年"+(month>9?month:"0"+month)+"月");
	 		}else{
	 			$(_this).find(".showDate").html(year+"/"+(month>9?month:"0"+month));
	 		}
	 		//要求星期几开始
	 		var weekstartday=options.weekstartday;
	 		//计算出vStart,vEnd具体时间
	 		//选中月第一天是星期几（距星期日离开的天数）
	        var startDay = new Date(year, month - 1, 1).getDay();
	        var difday=startDay-weekstartday;//月首第一天与要求第一天的日期差.
	        if(difday<0) difday+=7;
	        
	 		var firstdate = new Date(year, month-1, 1);//选中月第一天
	 		var lastMonth = new Date(year, month-2, 1);//选中月上个月第一天
			var nextMonth = new Date(year, month, 1);//选中月下月第一天
			
			var lastStr = lastMonth.getFullYear()+"-"+((lastMonth.getMonth() + 1)>9?(lastMonth.getMonth() + 1):"0"+(lastMonth.getMonth() + 1)); 
			var currentStr=year+"-"+(month>9?month:"0"+month);
	 		var nextStr = nextMonth.getFullYear()+"-"+((nextMonth.getMonth() + 1)>9?(nextMonth.getMonth() + 1):"0"+(nextMonth.getMonth() + 1));   
			
	 		var lastMothStart = DateAdd("d", -difday, firstdate).getDate();//日期第一天
	 		var lastMothend = DateAdd("d", -1, firstdate).getDate();//上月的最后一天
	        
	        //本月有多少天(即最后一天的getDate()，但是最后一天不知道，我们可以用“上个月的0来表示本月的最后一天”)
	        var nDays = new Date(year, month, 0).getDate();
			if(difday==0){
				options.startDate=currentStr+"-01";
			}else{
				options.startDate=lastStr+"-"+lastMothStart;
			}
			options.endDate=currentStr+"-"+nDays;
	 
	        //开始画日历
	        var numRow = 0;  //记录行的个数，到达7的时候创建tr
	        var totalRow=1;
	        var i;        //日期
	        var html ='<tr>';
	        for(var week=weekstartday;week<7;week++){
	        	html+='<td class="title">'+getWeekStr(week,options)+'</td>';
	        }
	        for(var week=0;week<weekstartday;week++){
	        	html+='<td class="title">'+getWeekStr(week,options)+'</td>';
	        }
	       	html +='</tr>';
	        //第一行
	        html+='<tr style="height:1px!important;" class="Spacing"><td class="paddingLeft0" colspan="7"><div class="intervalDivClass" style="width:100%"></div></td></tr>';
	        html += '<tr>';
	        for (i = lastMothStart; difday!=0&&i<=lastMothend; i++) {
	        	var t=lastLunarCalendar[i-1];
           		var d=t.lDay;
           		var s=cDay(d);
           	
	            html += '<td  date="'+lastStr+'-'+i+'" class="prevMonth" data="">';
	            html+='<div class="dateTerm notSelectMonthDay " title="'+lastStr+'-'+i+'" date="'+lastStr+'-'+i+'">';
	            html+=i;
	            html+='</div>';
	            if(options.showChineseDay){
		            //显示农历开始
		            html +='<div class="solarTerm">';
		            
					var hn=holidayName(''+(t.lMonth>9?t.lMonth:'0'+t.lMonth)+(t.lDay>9?t.lDay:'0'+t.lDay),''+(t.sMonth>9?t.sMonth:'0'+t.sMonth)+(t.sDay>9?t.sDay:'0'+t.sDay));
					 if(hn!=0){
					 	html+=hn;
					 }else if(t.solarTerms!=''){
		            	html+=t.solarTerms;
	            	 }else{
	            		if(d==1){
							html+='<b>'+(t.isLeap?'闰':'') + nStr3[t.lMonth] + '月' +'</b>';
			             }else{
				            html+=s;
			            }
	            	 }
		            	
		             
		            html+='</div>';
		            //显示农历结束
	            }
	            
	            html+='</td>';
	            numRow++;
	        }
	        for (var j = 1; j <= nDays; j++) {
	        	var t=currentLunarCalendar[j-1];
           		var d=t.lDay;
           		var s=cDay(d);
           	
	            if (year==todayY&&month==todayM&&j == todayD) {
	                html += '<td date="'+currentStr+'-'+(j>9?j:'0'+j)+'" class="currentMonth" data="" >';  
	                html += '<div class="dateTerm currentCalendar "';
	                if(numRow==0){
	            		html+=' style="color:'+options.SundayColor+'"';
	            	}else if(numRow==6){
	            		html+=' style="color:'+options.SaturdayColor+'"';
	            	}
	                html += ' title="'+currentStr+'-'+(j>9?j:"0"+j)+'" date="'+currentStr+'-'+(j>9?j:"0"+j)+'">';
	            }
	            else {
	                html += '<td date="'+currentStr+'-'+(j>9?j:'0'+j)+'" class="currentMonth" data="">';
	                html += '<div class="dateTerm" ';
	                if(numRow==0){
	            		html+=' style="color:'+options.SundayColor+'"';
	            	}else if(numRow==6){
	            		html+=' style="color:'+options.SaturdayColor+'"';
	            	}
	                html += '" title="'+currentStr+'-'+(j>9?j:"0"+j)+'" date="'+currentStr+'-'+(j>9?j:"0"+j)+'">';
	            }
	            html += j; 
	            html += '</div>';
	            
	            if(options.showChineseDay){
		            //显示农历开始
		            html +='<div class="solarTerm">';
		            
					var hn=holidayName(''+(t.lMonth>9?t.lMonth:'0'+t.lMonth)+(t.lDay>9?t.lDay:'0'+t.lDay),''+(t.sMonth>9?t.sMonth:'0'+t.sMonth)+(t.sDay>9?t.sDay:'0'+t.sDay));
					 if(hn!=0){
					 	html+=hn;
					 }else if(t.solarTerms!=''){
		            	html+=t.solarTerms;
	            	 }else{
	            		if(d==1){
							html+='<b>'+(t.isLeap?'闰':'') + nStr3[t.lMonth] + '月' +'</b>';
			             }else{
				            html+=s;
			            }
	            	 }
		            	
		             
		            html+='</div>';
		            //显示农历结束
	            }
	            
	            html+='</td>';
	            numRow++;
	            if (numRow == 7) {  //如果已经到一行（一周）了，重新创建tr
	                numRow = 0;
	                totalRow++;
	                html += '</tr><tr>';
	            }
	        }
			//补充后一个月
	        if(numRow>0){
	        	for(var j=1;j<=7;j++){
	        		var t=nextLunarCalendar[j-1];
	           		var d=t.lDay;
	           		var s=cDay(d);
		        	html += '<td  date="'+nextStr+'-0'+j+'" class="nextMonth" data="">';
		        	html+='<div class="dateTerm notSelectMonthDay " title="'+nextStr+'-0'+j+'" date="'+nextStr+'-0'+j+'">'+j+'</div>';
		        	
		        	if(options.showChineseDay){
			            //显示农历开始
			            html +='<div class="solarTerm">';
			            
						var hn=holidayName(''+(t.lMonth>9?t.lMonth:'0'+t.lMonth)+(t.lDay>9?t.lDay:'0'+t.lDay),''+(t.sMonth>9?t.sMonth:'0'+t.sMonth)+(t.sDay>9?t.sDay:'0'+t.sDay));
						 if(hn!=0){
						 	html+=hn;
						 }else if(t.solarTerms!=''){
			            	html+=t.solarTerms;
		            	 }else{
		            		if(d==1){
								html+='<b>'+(t.isLeap?'闰':'') + nStr3[t.lMonth] + '月' +'</b>';
				             }else{
					            html+=s;
				            }
		            	 }
			            	
			             
			            html+='</div>';
			            //显示农历结束
		            }
		        	
		        	html+='</td>';
		            numRow++;
		        	if (numRow == 7) {  //如果已经到一行（一周）了，重新创建tr
		                numRow = 0;
		                html += '</tr>';
		                options.endDate=nextStr+'-0'+j;
		                break;
		            }
	        	}
	        }
	        $(_this).find('.LDay').html(html);
			//对所有的td增加点击事件
			$(_this).find('.currentMonth').click(function(){
    			clickDate(this,options,_this);
    		});
    		$(_this).find('.prevMonth').click(function(){
    			prev(this,options,_this);
    		});
    		$(_this).find('.nextMonth').click(function(){
    			next(this,options,_this);
    		});
    		
	        //标记选中日期
	        if(showObj!='undefined'&&showObj!=undefined){
	        	$(_this).find('div[date="'+showObj+'"]').addClass("currentSelect");
	        	clickDate($(_this).find('td[date="'+showObj+'"]'),options,_this);
	        	getData(_this,options,showObj);
	        }else{
	        	if(selectDate!=todayStr){
		        	$(_this).find('div[date="'+selectDate+'"]').addClass("currentSelect");
	        	}
	        	clickDate($(_this).find('td[date="'+selectDate+'"]'),options,_this);
	        	getData(_this,options,selectDate);
	        }
	        
	        
	    }
    	//标识哪天有数据 返回json数据格式
    	//{"dateevents":{"2017-06-07":"","2017-06-06":""}}
    	function getData(_this,options,selectDate){
    		if (options.getDataUrl && options.getDataUrl != "") {
    		 	//ajax获取数据
		        $.post(options.getDataUrl,{"selectdate":selectDate,"startDate":options.startDate,"endDate":options.endDate},
			   	function(data){
			   		var datas=data.dateevents;
			   		for(var key in datas){
			   			$(_this).find('td[date="'+key+'"]').children('div').eq(0).addClass("hashPlanDiv"); 
			   		}
		   		});
		   		
		   	}
    	}
    	
    	function DateAdd(interval, number, idate) {
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
	    }
	   
	    //点击日期
	    function clickDate(obj,options,_this){
	 		if(lastOpt==undefined||lastOpt=='undefined'){
	
	    	}else{
	    	   $(lastOpt).children('div').eq(0).addClass(lastOptCss);	
	    	}
	    	
	    	$(_this).find('div').removeClass("currentSelect");
	    	var divObj=$(obj).children('div').eq(0);
	    	
	    	lastOpt=obj;
	    	lastOptCss=$(divObj).attr("class");
	    	$(divObj).removeClass(lastOptCss);
	    	$(divObj).addClass("dateTerm currentSelect");
	    	currentSelectDate=$(divObj).attr("date");
	    	//alert(currentSelectDate);
	 		//左侧展示结果
	 		try{
		 		if(!!options.CusClickDate){
		 			options.CusClickDate(currentSelectDate);
		 		}
	 		}catch(e){}
	 	}
	 	
	 	//获取星期简写,用于日历头部
	 	 function getWeekStr(day,options){
		 	var weekDay="";
		    if(day==0){
		  		weekDay=options.i18n.sun;
		    }else if(day==1){
		    	weekDay=options.i18n.mon;
		    }else if(day==2){
		    	weekDay=options.i18n.tue;
		    }else if(day==3){
		    	weekDay=options.i18n.wed;
		    }else if(day==4){
		    	weekDay=options.i18n.thu;
		    }else if(day==5){
		    	weekDay=options.i18n.fri;
		    }else if(day==6){
		    	weekDay=options.i18n.sat;
		    }
		 	return weekDay;
		 }
		 
	 	 //获取星期几
	 	 function getWeekDay(day,options){
		 	var weekDay="";
		    if(day==0){
		  		weekDay=options.i18n.Sunday;
		    }else if(day==1){
		    	weekDay=options.i18n.Monday;
		    }else if(day==2){
		    	weekDay=options.i18n.Tuesday;
		    }else if(day==3){
		    	weekDay=options.i18n.Wednesday;
		    }else if(day==4){
		    	weekDay=options.i18n.Thursday;
		    }else if(day==5){
		    	weekDay=options.i18n.Friday;
		    }else if(day==6){
		    	weekDay=options.i18n.Saturday;
		    }
		 	return weekDay;
		 }
		 
		 function next(obj,options,_this){
		 	pageDate.setDate(1);//设置本月第一天
		 	pageDate.setMonth(pageDate.getMonth() + 1);
		 	var idv=$(obj).attr("target");
		 	if(idv!='prevbtn'&&idv!='nextbtn'){
		 		calendar(_this,options,idv);
		 	}else{
		 		calendar(_this,options);
		 	}
		 }
		 
		 function prev(obj,options,_this){
		 	pageDate.setDate(1);//设置本月第一天
		 	pageDate.setMonth(pageDate.getMonth() - 1);
		 	var idv=$(obj).attr("target");
		 	if(idv!='prevbtn'&&idv!='nextbtn'){
		 		calendar(_this,options,idv);
		 	}else{
		 		calendar(_this,options);
		 	}
		 	
		 }
		 
		 
		 
		//ndate:农历日期；
		//gdate:公历日期
		function holidayName(ndate,gdate){
			for (var ipp=0;ipp<lFtv.length;ipp++){    //农历节日
		            if (lFtv[ipp].substr(0,4)==ndate){
		                    return lFtv[ipp].substr(5);
		            }
		            if (12==(ndate.substr(0,2))){    //判断是否为除夕
		                 if (eve==(ndate.substr(2,2))) return "除夕";
		            }
		        }
		        for (var ipp=0;ipp<sFtv.length;ipp++){    //公历节日
		            if (sFtv[ipp].substr(0,4)==gdate){
		                
		                    return sFtv[ipp].substr(5);
		                
		            }
		        }
		        return 0;
		}
		
		//返回农历y年的总天数
		function lYearDays(y) {
		   var i, sum = 348;
		   for(i=0x8000; i>0x8; i>>=1)sum+=(lunarInfo[y-1900]&i)?1:0;
		   return(sum+leapDays(y));
		}
		//返回农历y年闰月的天数
		function leapDays(y) {
		   if(leapMonth(y))  return((lunarInfo[y-1900] & 0x10000)? 30: 29);
		   else return(0);
		}
		//判断y年的农历中那个月是闰月,不是闰月返回0
		function leapMonth(y){
		   return(lunarInfo[y-1900]&0xf);
		}
		//返回农历y年m月的总天数
		function monthDays(y,m){
		   return((lunarInfo[y-1900]&(0x10000>>m))?30:29);
		}
		//算出当前月第一天的农历日期和当前农历日期下一个月农历的第一天日期
		function Dianaday(objDate) {
		   var i, leap=0, temp=0;
		   var baseDate = new Date(1900,0,31);
		   var offset   = (objDate - baseDate)/86400000;
		   this.dayCyl = offset+40;
		   this.monCyl = 14;
		   for(i=1900; i<2050 && offset>0; i++) {
		      temp = lYearDays(i)
		      offset -= temp;
		      this.monCyl += 12;
		   }
		   if(offset<0) {
		      offset += temp;
		      i--;
		      this.monCyl -= 12;
		   }
		   this.year = i;
		   this.yearCyl=i-1864;
		   leap = leapMonth(i); //闰哪个月
		   this.isLeap = false;
		   for(i=1; i<13 && offset>0; i++) {
		      if(leap>0 && i==(leap+1) && this.isLeap==false){    //闰月
		          --i; this.isLeap = true; temp = leapDays(this.year);}
		      else{
		         temp = monthDays(this.year, i);}
		      if(this.isLeap==true && i==(leap+1)) this.isLeap = false;    //解除闰月
		      offset -= temp;
		      if(this.isLeap == false) this.monCyl++;
		   }
		   if(offset==0 && leap>0 && i==leap+1)
		      if(this.isLeap){ this.isLeap = false;}
		      else{this.isLeap=true;--i;--this.monCyl;}
		   if(offset<0){offset+=temp;--i;--this.monCyl;}
		   this.month=i;
		   this.day=offset+1;
		}
		
		
		//记录公历和农历某天的日期
		function calElement(sYear,sMonth,sDay,week,lYear,lMonth,lDay,isLeap) {
		      this.isToday = false;
		      //公历
		      this.sYear = sYear;
		      this.sMonth = sMonth;
		      this.sDay = sDay;
		      this.week = week;
		      //农历
		      this.lYear = lYear;
		      this.lMonth = lMonth;
		      this.lDay = lDay;
		      this.isLeap = isLeap;
		      //节日记录
		      this.lunarFestival = ''; //农历节日
		      this.solarFestival = ''; //公历节日
		      this.solarTerms = ''; //节气
		}
		
		//返回公历y年m+1月的天数
		function solarDays(y,m){
		   if(m==1)
		      return(((y%4==0)&&(y%100!=0)||(y%400==0))?29:28);
		   else
		      return(solarMonth[m]);
		}
		
		//返回某年的第n个节气为几日(从0小寒起算)
		function sTerm(y,n) {
		   var offDate = new Date((31556925974.7*(y-1900)+sTermInfo[n]*60000)+Date.UTC(1900,0,6,2,5));
		   return(offDate.getUTCDate())
		}
		//保存y年m+1月的相关信息
		var fat=mat=9;
		var eve=0;
		function LunarCalendar(y,m) {
		   fat=mat=0;
		   var sDObj,lDObj,lY,lM,lD=1,lL,lX=0,tmp1,tmp2;
		   var lDPOS = new Array(3);
		   var n = 0;
		   var firstLM = 0;
		   sDObj = new Date(y,m,1);    //当月第一天的日期
		   this.length = solarDays(y,m);    //公历当月天数
		   this.firstWeek = sDObj.getDay();    //公历当月1日星期几
		   if ((m+1)==5){fat=sDObj.getDay()}
		   if ((m+1)==6){mat=sDObj.getDay()}
		   for(var i=0;i<this.length;i++) {
		      if(lD>lX) {
		         sDObj = new Date(y,m,i+1);    //当月第一天的日期
		         lDObj = new Dianaday(sDObj);     //农历
		         lY = lDObj.year;           //农历年
		         lM = lDObj.month;          //农历月
		         lD = lDObj.day;            //农历日
		         lL = lDObj.isLeap;         //农历是否闰月
		         lX = lL? leapDays(lY): monthDays(lY,lM); //农历当月最後一天
		         if (lM==12){eve=lX}
		         if(n==0) firstLM = lM;
		         lDPOS[n++] = i-lD+1;
		      }
		      this[i] = new calElement(y,parseInt(m)+1,i+1,nStr1[(i+this.firstWeek)%7],lY,lM,lD++,lL);
		      if((i+this.firstWeek)%7==0){
		         this[i].color = 'red';  //周日颜色
		      }
		   }
		   //节气
		   tmp1=sTerm(y,m*2)-1;
		   tmp2=sTerm(y,m*2+1)-1;
		   //对冬至单独计算
		   //公式解读：Y=年数后2位，D=0.2422，L=闰年数，21世纪C=21.94，20世纪=22.60。
		   //举例说明：2088年冬至日期=[88×0.2422+21.94]-[88/4]=43-22=21，12月21日冬至。
		   //例外：1918年和2021年的计算结果减1日。
		   if(m==11){
		   		y1=parseInt(y.substring(2,4));
		   		tmp2=parseInt(y1*0.2422+21.94)-parseInt(y1/4)-1
		   		if(y==1918||y==2021){
		   			tmp2-=1;
		   		}
		   }

		   this[tmp1].solarTerms = solarTerm[m*2];
		   this[tmp2].solarTerms = solarTerm[m*2+1];
		   if((this.firstWeek+12)%7==5)    //黑色星期五
		      this[12].solarFestival += '黑色星期五';
		}
		//用中文显示农历的日期
		function cDay(d){
		   var s;
		   switch (d) {
		      case 10:
		         s = '初十'; break;
		      case 20:
		         s = '廿'; break;
		         break;
		      case 30:
		         s = '卅'; break;
		         break;
		      default :
		         s = nStr2[Math.floor(d/10)];
		         s += nStr1[d%10];
		   }
		   return(s);
		}
		
		var cld;
		function drawCld(SY,SM) {
		   var TF=true;
		   var p1=p2="";
		   var i,sD,s,size;
		   cld = new calendar(SY,SM);
		   GZ.innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;【'+Animals[(SY-4)%12]+'】';    //生肖
		   for(i=0;i<42;i++) {
		      sObj=eval('SD'+ i);
		      lObj=eval('LD'+ i);
		      sObj.className = '';
		      sD = i - cld.firstWeek;
		      if(sD>-1 && sD<cld.length) { //日期内
		         sObj.innerHTML = sD+1;
		         if(cld[sD].isToday){ sObj.style.color = '#9900FF';} //今日颜色
		         else{sObj.style.color = '';}
		         if(cld[sD].lDay==1){ //显示农历月
		           lObj.innerHTML = '<b>'+(cld[sD].isLeap?'闰':'') + cld[sD].lMonth + '月' + (monthDays(cld[sD].lYear,cld[sD].lMonth)==29?'小':'大')+'</b>';
		         }
		         else{lObj.innerHTML = cDay(cld[sD].lDay);}    //显示农历日
		        var Slfw=Ssfw=null;
		        s=cld[sD].solarFestival;
		        for (var ipp=0;ipp<lFtv.length;ipp++){    //农历节日
		            if (parseInt(lFtv[ipp].substr(0,2))==(cld[sD].lMonth)){
		                if (parseInt(lFtv[ipp].substr(2,4))==(cld[sD].lDay)){
		                    lObj.innerHTML=lFtv[ipp].substr(5);
		                    Slfw=lFtv[ipp].substr(5);
		                }
		            }
		            if (12==(cld[sD].lMonth)){    //判断是否为除夕
		                if (eve==(cld[sD].lDay)){lObj.innerHTML="除夕";Slfw="除夕";}
		            }
		        }
		        for (var ipp=0;ipp<sFtv.length;ipp++){    //公历节日
		            if (parseInt(sFtv[ipp].substr(0,2))==(SM+1)){
		                if (parseInt(sFtv[ipp].substr(2,4))==(sD+1)){
		                    lObj.innerHTML=sFtv[ipp].substr(5);
		                    Ssfw=sFtv[ipp].substr(5);
		                }
		            }
		        }
		        if ((SM+1)==5){    //母亲节
		            if (fat==0){
		                if ((sD+1)==7){Ssfw="母亲节";lObj.innerHTML="母亲节"}
		            }
		            else if (fat<9){
		                if ((sD+1)==((7-fat)+8)){Ssfw="母亲节";lObj.innerHTML="母亲节"}
		            }
		        }
		        if ((SM+1)==6){    //父亲节
		            if (mat==0){
		                if ((sD+1)==14){Ssfw="父亲节";lObj.innerHTML="父亲节"}
		            }
		            else if (mat<9){
		                if ((sD+1)==((7-mat)+15)){Ssfw="父亲节";lObj.innerHTML="父亲节"}
		            }
		         }
		         if (s.length<=0){    //设置节气的颜色
		            s=cld[sD].solarTerms;
		            if(s.length>0) s = s.fontcolor('limegreen');        
		         }
		         if(s.length>0) {lObj.innerHTML=s;Slfw=s;}    //节气
		         if ((Slfw!=null)&&(Ssfw!=null)){
		            lObj.innerHTML=Slfw+"/"+Ssfw;
		         }                        
		      }
		      else { //非日期
		         sObj.innerHTML = '';
		         lObj.innerHTML = '';
		      }
		   }
		}
	   
        return this;
    }
    
    
})(jQuery);