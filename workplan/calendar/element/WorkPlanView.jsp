
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
//获取用户信息,根据用户信息,获取有权限的公众平台
 int userid=user.getUID(); 
 boolean showLunar=user.getLanguage()==7||user.getLanguage()==9;
 
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style type="text/css">
        
        #LDay td{
            height: <%=showLunar?"40px":"30px"%>;
            text-align: center;
            font-family: "宋体";
            font-size: 12px;
        }
         
        #LDay div{
            cursor:pointer;
            width: 25px;
            line-height: 25px;
            margin:0 auto;
        }
        .title{
        	color:#5FB5FE;
        	width: 14%;
        }
		#currentDay{
			font-family: "宋体";
            font-size: 36px;
            color: #E52355;
		}
		#currentWeekDay{
            font-size: 12px;
            color: #BCB8B9;
            font-weight: bold;
		}
		
		.LeftArrow{
			float:left;
			width: 7px;
			height: 10px;
			background-image: url(./img/left_wev8.png) ;
			background-repeat:no-repeat;
			text-align: center;
			margin: 10px;
			margin-right: 8px;
			cursor:pointer;
		}
		.LeftArrow2{
			float:left;
			width: 7px;
			height: 10px;
			background-image: url(./img/left_hot_wev8.png) ;
			background-repeat:no-repeat;
			text-align: center;
			margin: 10px;
			margin-right: 8px;
			cursor:pointer;
		}
		.changeMonth{
			float:left;
			font-size: 16px;
			color: #E52355;
			height: 28px;
			line-height: 28px;
			margin-left: 10px;
			margin-right: 10px;
		}
		.RightArrow{
			float:left;
			width: 7px;
			height: 10px;
			background-image: url(./img/right_wev8.png) ;
			background-repeat:no-repeat;
			text-align: center;
			margin: 10px;
			margin-left: 8px;
			cursor:pointer;
		}
		.RightArrow2{
			float:left;
			width: 7px;
			height: 10px;
			background-image: url(./img/right_hot_wev8.png) ;
			background-repeat:no-repeat;
			text-align: center;
			margin: 10px;
			margin-left: 8px;
			cursor:pointer;
		}
		.notSelectMonthDay{
			color: #BCB8B9;
		}
		.hand{
			cursor:pointer;
		}
		.hashPlanDiv{
			background-image: url(./img/green_circle_wev8.png) ;
			background-repeat:no-repeat;
			text-align: center;
			color:#fff;
		}
		.currentCalendar{
			background-image: url(./img/blue_circle_wev8.png) ;
			background-repeat:no-repeat;
			text-align: center;
			color:#fff;
		}
		.currentSelect{
			background-image: url(./img/blue_ring_wev8.png) ;
			background-repeat:no-repeat;
			text-align: center;
			color:#000;
		}
		.planDataEvent{
			height:100px;
			width: 100%;
			overflow-y: hidden;
			position: relative;
		}
		.dataEvent{			
			line-height: 30px;
			border-width: 0px;
			border-bottom: 1px;
			border-style: solid;
			border-color: #F3F2F2;
			float: left;
			height: 30px;
			width: 100%;
		}
		.dataEvent1{			
			line-height: 30px;
			float: left;
			height: 30px;
			width: 2px;
		}
		.dataEvent2{			
			line-height: 30px;
			float: left;
			height: 30px;
			width: 80px;
			background:#F5F5F5;
		}
		.dataEvent2_1{			
			margin-left:5px;
		}
		.dataEvent3{			
			margin-left: 5px;
			height: 30px;
			display:block;
			overflow:hidden; 
			text-overflow: ellipsis;
			-o-text-overflow:ellipsis; 
	
		}
		.addWorkPlan { 	
		border:none;
		BACKGROUND: url(./img/add_wev8.png) no-repeat;
		color:#333;
		WIDTH: 24px;
		height:24px;
		text-align:left;
		cursor:pointer;
		padding-left:10px;
		padding-top:2px;
		margin-right:5px;
		background-position:50% 50%;
		}
		
		.addWorkPlan2 { 	
		border:none;BACKGROUND: url(./img/add_hot_wev8.png) no-repeat;color:#333;WIDTH: 94px;height:24px;text-align:left;cursor:pointer;padding-left:10px;padding-top:2px;margin-right:5px;
		background-position:50% 50%;
		}
		
		.solarTerm {
	    color: #666666 !important;
	    line-height: 13px !important;
	    -webkit-text-size-adjust: none;
	    font-size: 8px !important;
	    -webkit-transform: scale(0.74, 0.74);
	    width: 40px !important;
        }
 
</style>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32642,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<div style="border:#F3F2F2 1px solid;">
			<table id="Calendar" width="100%" border=0>
		        <tr>
		            <td>
			                <table height="80" width="100%">
		                        <tr align="center">
		                        	<td  class="hand" align="center" width="33%" onclick="todayClick()" title="<%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%>">
		                        		<span id="currentDay"></span>
		                        		<br>
		                        		<span id="currentWeekDay" ></span>
		                        	</td>
		                            <td align="center" style="border-left:#E4E1E1 1px solid;">
		                            	<div style="display: inline-block;">
			                                <div class="LeftArrow" id="prevbtn" title="<%=SystemEnv.getHtmlLabelName(82899, user.getLanguage())%>" onclick="prev(this)"></div>
			                                <div class="changeMonth " id="showDate"></div>
			                                <div class="RightArrow" id="nextbtn" title="<%=SystemEnv.getHtmlLabelName(82898, user.getLanguage())%>" onclick="next(this)"></div>
		                                </div>
		                            </td>
		                        </tr>
		                        <tr style="height:1px!important;" class="Spacing">
									<td class="paddingLeft0" colspan="2">
										<div class="intervalDivClass">
									</div></td>
								</tr>
			                </table>
			                <table id="LDay"  width="100%">
							        
							</table>
						
		            </td>
		        </tr>
		        <tr style="height:1px!important;" class="Spacing">
					<td class="paddingLeft0">
						<div class="intervalDivClass">
					</div></td>
				</tr>
				<tr>
		            <td>
		            	 <div id="planDataEvent" class="planDataEvent">
	           				<div id="planDataEventchd"></div>
		            	</div>
		            </td>
		        </tr>
				<tr>
					<td style="text-align: center;height:30px;">
						<input class="addWorkPlan" type="button" onMouseOut="" onclick="doAdd()" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>">
					</td>
				</tr>
		    </table>
		    </div>
	</td>	 
 </td>
</tr>
</table>

<script language="javascript">
	var initHeight=380;
	var planData=null;
	var currentToday=new Date();
	var pageDate=new Date();
	var lastOpt;
	var lastOptCss="";
	var calendarDialog;
	var currentSelectDate="";
	function initToday(){
        var todayD=currentToday.getDate();//本日
        var todayWD=currentToday.getDay();//本周几
        $("#currentDay").html(todayD);
 		$("#currentWeekDay").html(getWeekDay(todayWD));
	}
    //实现日历
    function calendar(showObj) {
    	clearData();
        var year = pageDate.getFullYear();      //选中年
        var month = pageDate.getMonth() + 1;    //选中月
        var day = pageDate.getDate();           //选中日
        var todayY=currentToday.getFullYear();//本年
		var todayM=currentToday.getMonth()+1;//本月
		var todayD=currentToday.getDate();//今天
		var todayStr=todayY+"-"+(todayM>9?todayM:"0"+todayM)+"-"+(todayD>9?todayD:"0"+todayD);
		var selectDate=year+"-"+(month>9?month:"0"+month)+"-"+(day>9?day:"0"+day);
		if("<%=user.getLanguage()%>"=="7"||"<%=user.getLanguage()%>"=="9"){
 			$("#showDate").html(year+"年"+(month>9?month:"0"+month)+"月");
 		}else{
 			$("#showDate").html(year+"/"+(month>9?month:"0"+month));
 		}
 		//计算出vStart,vEnd具体时间
 		//选中月第一天是星期几（距星期日离开的天数）
        var startDay = new Date(year, month - 1, 1).getDay();
 		var firstdate = new Date(year, month-1, 1);//选中月第一天
 		var lastMonth = new Date(year, month-2, 1);//选中月上个月第一天
		var nextMonth = new Date(year, month, 1);//选中月下月第一天
		
		var lastStr = lastMonth.getFullYear()+"-"+((lastMonth.getMonth() + 1)>9?(lastMonth.getMonth() + 1):"0"+(lastMonth.getMonth() + 1)); 
		var currentStr=year+"-"+(month>9?month:"0"+month);
 		var nextStr = nextMonth.getFullYear()+"-"+((nextMonth.getMonth() + 1)>9?(nextMonth.getMonth() + 1):"0"+(nextMonth.getMonth() + 1));   
		
 		var lastMothStart = DateAdd("d", -startDay, firstdate).getDate();//日期第一天
 		var lastMothend = DateAdd("d", -1, firstdate).getDate();//上月的最后一天

        //本月有多少天(即最后一天的getDate()，但是最后一天不知道，我们可以用“上个月的0来表示本月的最后一天”)
        var nDays = new Date(year, month, 0).getDate();
 		
        var showChineseDay="<%=showLunar%>"=="true";
        var lastPageDate=new Date(pageDate.getFullYear(),pageDate.getMonth(),1);
    	var nextPageDate=new Date(pageDate.getFullYear(),pageDate.getMonth(),1);
    	lastPageDate.setDate(1);//设置本月第一天
 		lastPageDate.setMonth(pageDate.getMonth() - 1);
 		nextPageDate.setDate(1);//设置本月第一天
 		nextPageDate.setMonth(pageDate.getMonth() + 1);
    	var lastLunarCalendar=new LunarCalendar(lastPageDate.getFullYear()+'',lastPageDate.getMonth()+''); 
    	var currentLunarCalendar=new LunarCalendar(pageDate.getFullYear()+'',pageDate.getMonth()+''); 
    	var nextLunarCalendar=new LunarCalendar(nextPageDate.getFullYear()+'',nextPageDate.getMonth()+'');
 		
        //开始画日历
        var numRow = 0;  //记录行的个数，到达7的时候创建tr
        var totalRow=1;
        var i;        //日期
        var html = '<tr><td class="title"><%=SystemEnv.getHtmlLabelName(82920, user.getLanguage())%></td>'+
			        '<td class="title"><%=SystemEnv.getHtmlLabelName(82914, user.getLanguage())%></td>'+
			        '<td class="title"><%=SystemEnv.getHtmlLabelName(82915, user.getLanguage())%></td>'+
			        '<td class="title"><%=SystemEnv.getHtmlLabelName(82916, user.getLanguage())%></td>'+
        			'<td class="title"><%=SystemEnv.getHtmlLabelName(82917, user.getLanguage())%></td>'+
        			'<td class="title"><%=SystemEnv.getHtmlLabelName(82918, user.getLanguage())%></td>'+
        			'<td class="title"><%=SystemEnv.getHtmlLabelName(82919, user.getLanguage())%></td></tr>';
        //第一行
        html+='<tr style="height:1px!important;" class="Spacing"><td class="paddingLeft0" colspan="7"><div class="intervalDivClass" style="width:100%"></div></td></tr>';
        html += '<tr>';
        for (i = lastMothStart; startDay!=0&&i<=lastMothend; i++) {
            html += '<td  id="'+lastStr+'-'+i+'" onclick="prev(this)" data="">';
            html+='<div class="notSelectMonthDay " title="'+lastStr+'-'+i+'">';
            html+=i;
            html+='</div>';
            //显示日历
            var t=lastLunarCalendar[i-1];
           	var d=t.lDay;
           	var s=cDay(d);
           	if(showChineseDay){
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
            }
            //显示农历结束
            html+='</td>';
            numRow++;
        }
        for (var j = 1; j <= nDays; j++) {
            if (year==todayY&&month==todayM&&j == todayD) {
                html += '<td id="'+currentStr+'-'+(j>9?j:'0'+j)+'" onclick="clickDate(this)" data="" >';  
                html += '<div class="currentCalendar" title="'+currentStr+'-'+(j>9?j:"0"+j)+'">';
            }
            else {
                html += '<td id="'+currentStr+'-'+(j>9?j:'0'+j)+'" onclick="clickDate(this)" data="">';
                html += '<div title="'+currentStr+'-'+(j>9?j:"0"+j)+'">';
            }
            html += j; 
            html += '</div>';
            //显示农历
            var t=currentLunarCalendar[j-1];
           	var d=t.lDay;
           	var s=cDay(d);
           	if(showChineseDay){
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
            }
            //显示农历结束
            html +='</td>';
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
	        	html += '<td  id="'+nextStr+'-0'+j+'" onclick="next(this)" data="">';
	        	html+='<div class="notSelectMonthDay " title="'+nextStr+'-0'+j+'">'+j+'</div>';
	        	//显示农历
	        	var t=nextLunarCalendar[j-1];
	           	var d=t.lDay;
	           	var s=cDay(d);
	           	if(showChineseDay){
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
	            }
	            //显示农历结束
	            html+='</td>';
	            numRow++;
	        	if (numRow == 7) {  //如果已经到一行（一周）了，重新创建tr
	                numRow = 0;
	                html += '</tr>';
	                break;
	            }
        	}
        }
        $('#LDay').html(html);
        initHeight=parseInt($('#LDay').height())+80+40+10+15;
        if(window.name&&window.name!=''){
    		parent.document.getElementsByName(window.name)[0].height=initHeight;
    	}
        //标记选中日期
        if(showObj!='undefined'&&showObj!=undefined){
        	$('div[title="'+showObj+'"]').addClass("currentSelect");
        }else{
        	if(selectDate!=todayStr){
	        	$('div[title="'+selectDate+'"]').addClass("currentSelect");
        	}
        }
        //ajax获取数据
        $.post("WorkPlanViewOperation.jsp", 
        	{"selectdate":selectDate},
	   	function(data){
			var sd=$(".currentSelect").attr("title");
		 	if(sd==undefined||selectDate=='undefined'){
		 		sd=$(".currentCalendar").attr("title");
		 	}
	   		var datas=data.dateevents;
	   		planData=data.events;
	   		for(var key in datas){
	   			//$('#'+key).addClass("hashPlanTD");
	   			$('#'+key).children('div').eq(0).addClass("hashPlanDiv"); 
	   			$('#'+key).attr("data",datas[key]);
	   			if(key==sd){
	   				//clickDate($('#'+key));
	   				showData($('#'+sd));
	   			}
	   		}
   		});
    }
    function clearData(){
    	if(window.name&&window.name!=''){
    		parent.document.getElementsByName(window.name)[0].height=initHeight;
    	}
    	$('#planDataEventchd').html("");
    	$('#planDataEvent').height(10);
    	$('#planDataEventchd').height(9);
    	//$('#planDataEvent').removeClass("planDataEvent");
    	jQuery("#planDataEvent").perfectScrollbar("update");
    }

    //点击日期
    function clickDate(obj){
 		showData(obj);
 		reGetDate();
 	}
 	
 	function showData(obj){
 		if(window.name&&window.name!=''){
	    	parent.document.getElementsByName(window.name)[0].height=initHeight;
	    }
 		if(lastOpt==undefined||lastOpt=='undefined'){

    	}else{
    	   $(lastOpt).children('div').eq(0).addClass(lastOptCss);	
    	}
    	
    	$('div').removeClass("currentSelect");
    	var divObj=$(obj).children('div').eq(0);
    	
    	lastOpt=obj;
    	lastOptCss=$(divObj).attr("class");
    	$(divObj).removeClass(lastOptCss);
    	$(divObj).addClass("currentSelect");
    	currentSelectDate=$(divObj).attr("title");
    	clearData();
 		var data=$(obj).attr("data");
 		if(data=='') return false;
 		var datas;
 		if (typeof (data) == "string") {
            datas=data.split(",");
        }

        if (typeof (data) == "object") {
            datas = data;
        }
		//$('#planDataEvent').addClass("planDataEvent");
		
 		var html='';
 		var cnt = 0;
 		for(var key in datas){
 			if(isNaN(key)) continue;
 			var c=tc(planData[datas[key]][5]);
 			html+='<div class="hand dataEvent" onclick="clickData(\''+datas[key]+'\')" title="'+planData[datas[key]][6]+'\n'+planData[datas[key]][1]+'">';
		    html+='<div class="dataEvent1" style="background:'+c+';"></div>';
		    html+='<div class="dataEvent2" ><div class="dataEvent2_1">'+planData[datas[key]][3]+'&nbsp;&nbsp;'+planData[datas[key]][4]+'</div></div>';
		    html+='<div class="dataEvent3">'+planData[datas[key]][1]+'</div>';
		    html+='</div>';
		    cnt = cnt + 1;
 		}
 		if(html=='') html="<%=SystemEnv.getHtmlLabelName(83503,user.getLanguage())%>";
 		//html = '<div>'+html+'</div>';
 		$('#planDataEventchd').html(html);
 		$('#planDataEventchd').height(cnt * 33);
 		if(cnt>2){
	 		if(window.name&&window.name!=''){
	    		parent.document.getElementsByName(window.name)[0].height=initHeight+100;
	    	}
 			$('#planDataEvent').height(100);
 			jQuery("#planDataEvent").perfectScrollbar("update");
 		}else{
 			if(window.name&&window.name!=''){
	    		parent.document.getElementsByName(window.name)[0].height=initHeight+(cnt * 33)+1;
	    	}
 			$('#planDataEvent').height((cnt * 33)+1);
 		} 		
 	}
 	
 	var hasRfdh = false;
 	//点击数据
 	function clickData(id){
 		var url='/workplan/data/WorkPlanDetail.jsp?from=1&workid='+id;
 		//openFullWindowHaveBar(url);
 		if(window.top.Dialog){
			calendarDialog = new window.top.Dialog();
		} else {
			calendarDialog = new Dialog();
		};
		hasRfdh = true;
	  	calendarDialog.URL =url;
	  	calendarDialog.Width = 600;
		calendarDialog.Height = 600;
	  	calendarDialog.checkDataChange = false;
	    calendarDialog.Title="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
	    calendarDialog.show();
 	}
 function tc(d) {
      function zc(c, i) {
          var d = "666666888888aaaaaabbbbbbdddddda32929cc3333d96666e69999f0c2c2b1365fdd4477e67399eea2bbf5c7d67a367a994499b373b3cca2cce1c7e15229a36633cc8c66d9b399e6d1c2f029527a336699668cb399b3ccc2d1e12952a33366cc668cd999b3e6c2d1f01b887a22aa9959bfb391d5ccbde6e128754e32926265ad8999c9b1c2dfd00d78131096184cb05288cb8cb8e0ba52880066aa008cbf40b3d580d1e6b388880eaaaa11bfbf4dd5d588e6e6b8ab8b00d6ae00e0c240ebd780f3e7b3be6d00ee8800f2a640f7c480fadcb3b1440edd5511e6804deeaa88f5ccb8865a5aa87070be9494d4b8b8e5d4d47057708c6d8ca992a9c6b6c6ddd3dd4e5d6c6274878997a5b1bac3d0d6db5a69867083a894a2beb8c1d4d4dae54a716c5c8d8785aaa5aec6c3cedddb6e6e41898951a7a77dc4c4a8dcdccb8d6f47b08b59c4a883d8c5ace7dcce";
          return "#" + d.substring(c * 30 + i * 6, c * 30 + (i + 1) * 6);
      }
      return zc(d, 0);
  }
  
  
  function doAdd(){
  	var date=new Date();
 	var year = date.getFullYear();
	var month = date.getMonth() + 1;
	var day = date.getDate();
	var hours = date.getHours();
	var minutes = date.getMinutes();
           
	var selectDate=year+"-"+(month>9?month:"0"+month)+"-"+(day>9?day:"0"+day);
	if(currentSelectDate!=''){
		selectDate=currentSelectDate;
	}
	var beginTime=(hours>9?hours:"0"+hours)+":"+(minutes>9?minutes:"0"+minutes);
	var url='/workplan/data/WorkPlanEdit.jsp?from=1&selectUser=<%=userid%>&planName=&beginDate='+selectDate+'&beginTime='+beginTime+'&endDate='+selectDate+'&endTime=';
  	//openFullWindowHaveBar(url);
	
  	if(window.top.Dialog){
		calendarDialog = new window.top.Dialog();
	} else {
		calendarDialog = new Dialog();
	};
  	calendarDialog.URL =url;
  	calendarDialog.Width = 600;
	calendarDialog.Height = 600;
  	calendarDialog.checkDataChange = false;
    calendarDialog.Title="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
    hasRfdh = true;
    calendarDialog.show();
  }
  
 
 function refashDate(){
 	if(calendarDialog &&calendarDialog.closed && hasRfdh ){
 		hasRfdh = false;
   		reGetDate();
 	}
 }
 
 function reGetDate(){
 	var selectDate=$(".currentSelect").attr("title");
 	if(selectDate==undefined||selectDate=='undefined'){
 		selectDate=$(".currentCalendar").attr("title");
 	}
 	
	$.post("WorkPlanViewOperation.jsp", 
    {"selectdate":selectDate},
  	function(data){
  		var datas=data.dateevents;
  		planData=data.events;
  		$(".hashPlanDiv").parent("TD").attr("data","");
  		$(".hashPlanDiv").removeClass("hashPlanDiv");
  		clearData();
  		var sd=$(".currentSelect").attr("title");
	 	if(sd==undefined||sd=='undefined'){
	 		sd=$(".currentCalendar").attr("title");
	 	}
  		for(var key in datas){
  			//$('#'+key).addClass("hashPlanTD");
  			$('#'+key).children('div').eq(0).addClass("hashPlanDiv"); 
  			$('#'+key).attr("data",datas[key]);
  			if(key==sd){
  				//clickDate($('#'+key));
  				showData($('#'+key));
  			}
  			
  		}
 	});
 }
 
  
  function closeByHand(){
  	calendarDialog.close();	
  }
  
  function refreshCal(){
  	calendar();
	calendarDialog.close();	
	
}
        
 function getWeekDay(day){
 	var weekDay="";
    if(day==0){
  		weekDay="<%=SystemEnv.getHtmlLabelName(398, user.getLanguage())%>";
    }else if(day==1){
    	weekDay="<%=SystemEnv.getHtmlLabelName(392, user.getLanguage())%>";
    }else if(day==2){
    	weekDay="<%=SystemEnv.getHtmlLabelName(393, user.getLanguage())%>";
    }else if(day==3){
    	weekDay="<%=SystemEnv.getHtmlLabelName(394, user.getLanguage())%>";
    }else if(day==4){
    	weekDay="<%=SystemEnv.getHtmlLabelName(395, user.getLanguage())%>";
    }else if(day==5){
    	weekDay="<%=SystemEnv.getHtmlLabelName(396, user.getLanguage())%>";
    }else if(day==6){
    	weekDay="<%=SystemEnv.getHtmlLabelName(397, user.getLanguage())%>";
    }
 	return weekDay;
 }
 function next(obj){
 	pageDate.setDate(1);//设置本月第一天
 	pageDate.setMonth(pageDate.getMonth() + 1);
 	var idv=$(obj).attr("id");
 	if(idv!='prevbtn'&&idv!='nextbtn'){
 		calendar(idv);
 	}else{
 		calendar();
 	}
 }
 
 function prev(obj){
 	 pageDate.setDate(1);//设置本月第一天
 	 pageDate.setMonth(pageDate.getMonth() - 1);
 	var idv=$(obj).attr("id");
 	if(idv!='prevbtn'&&idv!='nextbtn'){
 		calendar(idv);
 	}else{
 		calendar();
 	}
 	
 }
 
 function todayClick(){
	pageDate=new Date(currentToday.getFullYear(),currentToday.getMonth(),currentToday.getDate());
	calendar();
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
        
var isSubmit=false;

$(document).ready(function() {
	jQuery(".addWorkPlan").hover(function(){
		jQuery(this).addClass("addWorkPlan2");
	},function(){
		jQuery(this).removeClass("addWorkPlan2");
	});
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
	 initToday();
	 calendar();
	 window.setInterval("refashDate()",100);
	 jQuery("#planDataEvent").perfectScrollbar();
});

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
//--------农历部分代码

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
		0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0);

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
		"1225 圣诞节");
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
		"1224 小年");
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
		temp = lYearDays(i);
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
			temp = monthDays(this.year, i);
		}
		if(this.isLeap==true && i==(leap+1)) this.isLeap = false;    //解除闰月
		offset -= temp;
		if(this.isLeap == false) this.monCyl++;
	}
	if(offset==0 && leap>0 && i==leap+1){
		if(this.isLeap){ 
			this.isLeap = false;
		}
		else{
			this.isLeap=true;
			--i;
			--this.monCyl;
		}
	}
	if(offset<0){
		offset+=temp;
		--i;
		--this.monCyl;
	}
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
		case 30:
			s = '卅'; break;
		default :
			s = nStr2[Math.floor(d/10)];
			s += nStr1[d%10];
	}
	return(s);
}

</script>

</HTML>
