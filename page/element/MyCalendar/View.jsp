
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
 
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style type="text/css">
        
        #LDay td{
            height: 30px;
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
            html+='</div></td>';
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
            html += '</div></td>';
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
	        	html+='<div class="notSelectMonthDay " title="'+nextStr+'-0'+j+'">'+j+'</div></td>';
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
 		if(html=='') html="<%=SystemEnv.getHtmlLabelName(83506,user.getLanguage())%>";
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



</script>

</HTML>
