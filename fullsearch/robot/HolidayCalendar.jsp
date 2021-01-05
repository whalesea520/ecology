
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//获取用户信息,根据用户信息,获取有权限的公众平台
 	int userid=user.getUID(); 

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style type="text/css">
		table,tr,td{
			border:0px;
			cellspacing:0px;
			border-collapse:collapse;
			margin:0px;
			padding:0px;
		}
        div{text-align:center}
        #LDay td{
            height: 44px;
            width:44px;
            text-align: center;
            font-family: "宋体";
            font-size: 12px;
        }
         
        #LDay div{
            cursor:pointer;
            line-height: 30px;
            margin:0 auto;
        }
        #LDay2 td{
            height: 44px;
            width:44px;
            text-align: center;
            font-family: "宋体";
            font-size: 12px;
        }
         
        #LDay2 div{
            cursor:pointer;
            line-height: 30px;
            margin:0 auto;
        }
        .title{
        	width: 44px;
        	text-align: center;
        	color: #bfbfbf;
			font-size: 12px;
			height: 30px;
        }
        .arrowDiv{
        	background-repeat:no-repeat;
			text-align: center;
			cursor:pointer;
			width: 25px;
			margin: 5px;
			height: 25px;
        }
		.LeftArrow{
			float:left;
			background-image: url(/fullsearch/img/left_wev8.png) ;
		}
		.LeftArrow1{
			float:left;
			background-image: url(/fullsearch/img/left_hot_wev8.png) ;
		}
		.RightArrow{
			float:right;
			background-image: url(/fullsearch/img/right_wev8.png) ;
		}
		.RightArrow1{
			float:right;
			background-image: url(/fullsearch/img/right_hot_wev8.png) ;
		}
		.changeMonth{
			float:left;
			font-size: 14px;
			color: #2b8098;
			line-height: 30px;
		}
		.dateTerm{
			font-size: 16px;
			width:28px;
			height:28px;
		}
		.solarTerm{
			color:#bfbfbf !important;
			line-height:10px !important;
			-webkit-text-size-adjust: none;
			font-size : 8px !important;
			-webkit-transform : scale(0.74,0.74) ;
			*font-size:10px !important;
		}
		.notSelectMonthDay{
			color: #BCB8B9;
		}
		.holidayDiv{
			background-repeat:no-repeat;
			text-align: center;
			color:#F00;
		}
		.weekEnd{
			background-repeat:no-repeat;
			text-align: center;
			color:#848484 !important;
		}
		.currentCalendar{
			background-image: url(/fullsearch/img/blue_circle_wev8.png) ;
			background-repeat:no-repeat;
			text-align: center;
			color:#fff;
		}
		.xsup{
			-webkit-text-size-adjust: none;
			color:#1b9b12 !important;
			line-height:13px !important;
			font-size : 8px !important;
			-webkit-transform : scale(0.74,0.74) ;
		}
		.bsup{
			-webkit-text-size-adjust: none;
			color:#ff1004 !important;
			line-height:13px !important;
			font-size : 8px !important;
			-webkit-transform : scale(0.74,0.74) ;
		}
		.borderLeft{
			border-left:#DFDFDF 1px solid !important;
		}
		.borderRight{
			border-right:#DFDFDF 1px solid !important;
		}
		.borderBottom{
			border-bottom:#DFDFDF 1px solid !important;
		} 
		.fixHeight{
			height:35px !important;
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
		<div style="margin-left: 10px;margin-top:10px;">
			<table id="Calendar" width="630" height="333" border=0>
				<tr class="fixHeight" align="center" style="height:35px">
					<td class="fixHeight" style="background:#9added;border-right:#fff 1px solid;">
                       	<div class="arrowDiv LeftArrow" id="prevbtn" onclick="prev(this)"></div>
                       	<div class="changeMonth " id="showDate1" style="margin-left: 94px;"></div>
					</td>
					
					<td class="fixHeight" style="background:#9added;border-right:#9added 1px solid;">
                         <div class="changeMonth " id="showDate2" style="margin-left: 114px;"></div>
                         <div class="arrowDiv RightArrow" id="nextbtn" onclick="next(this)"></div>
					</td>
				</tr>
				<tr align="center" style="height:33px">
					<td class="borderLeft borderRight">
						<table border=0 width="100%">
							<tr><td class="title"><%=SystemEnv.getHtmlLabelName(82920, user.getLanguage())%></td>
						        <td class="title"><%=SystemEnv.getHtmlLabelName(82914, user.getLanguage())%></td>
						        <td class="title"><%=SystemEnv.getHtmlLabelName(82915, user.getLanguage())%></td>
						        <td class="title"><%=SystemEnv.getHtmlLabelName(82916, user.getLanguage())%></td>
			        			<td class="title"><%=SystemEnv.getHtmlLabelName(82917, user.getLanguage())%></td>
			        			<td class="title"><%=SystemEnv.getHtmlLabelName(82918, user.getLanguage())%></td>
			        			<td class="title"><%=SystemEnv.getHtmlLabelName(82919, user.getLanguage())%></td></tr>
						</table>
                        	 
					</td>
					 
					<td class="borderLeft borderRight fixHeight" >
						<table width="100%">
							<tr><td class="title"><%=SystemEnv.getHtmlLabelName(82920, user.getLanguage())%></td>
						        <td class="title"><%=SystemEnv.getHtmlLabelName(82914, user.getLanguage())%></td>
						        <td class="title"><%=SystemEnv.getHtmlLabelName(82915, user.getLanguage())%></td>
						        <td class="title"><%=SystemEnv.getHtmlLabelName(82916, user.getLanguage())%></td>
			        			<td class="title"><%=SystemEnv.getHtmlLabelName(82917, user.getLanguage())%></td>
			        			<td class="title"><%=SystemEnv.getHtmlLabelName(82918, user.getLanguage())%></td>
			        			<td class="title"><%=SystemEnv.getHtmlLabelName(82919, user.getLanguage())%></td></tr>
						</table>
                        	 
					</td>
				</tr>
				<tr align="center" style="height:265px" >
					<td class="borderLeft borderRight borderBottom"  valign="top">
						<table id="LDay"  width="100%" height="100%">
								         
						</table>
					</td>
					<td class="borderLeft borderRight borderBottom"  valign="top">
						<table id="LDay2"  width="100%" height="100%">
								     
						</table>
					</td>
				</tr>
				
			</table>
		</div>
	</td>	 
 </td>
</tr>
</table>

<script language="javascript">
	var tdH=264;
	var showChineseDay="<%=user.getLanguage()%>"==7||"<%=user.getLanguage()%>"==9;
	var tY,cal,tM;
	var initHeight=380;
	var currentToday1=new Date();
	var currentToday2=new Date();
	currentToday2.setMonth(currentToday2.getMonth()+1);
	var pageDate1=new Date();
	var pageDate2=new Date();
	pageDate1.setDate(1);
	pageDate2.setDate(1);
	pageDate2.setMonth(pageDate2.getMonth()+1);
	var today="";
	var begindate="";
	var enddate="";
	var row1=5;
	var row2=5;
    //实现日历
    function calendar1() {
    	var tmpcld=new calendar(pageDate1.getFullYear()+'',pageDate1.getMonth()+'');
        var year = pageDate1.getFullYear();      //选中年
        var month = pageDate1.getMonth()+1;    //选中月
        var day = pageDate1.getDate();           //选中日
		var todayY=currentToday1.getFullYear();//本年
		var todayM=currentToday1.getMonth()+1;//本月
		var todayD=currentToday1.getDate();//今天
		var todayStr=todayY+"-"+(todayM>9?todayM:"0"+todayM)+"-"+(todayD>9?todayD:"0"+todayD);
		today=todayStr;
		var selectDate=year+"-"+(month>9?month:"0"+month)+"-"+(day>9?day:"0"+day);
		if(showChineseDay){
			$("#showDate1").html(year+"年"+(month>9?month:"0"+month)+"月");
		}else{
			$("#showDate1").html(year+"/"+(month>9?month:"0"+month));
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
        //第一行       			
        var html = '<tr  class="ltd1">';
        for (i = lastMothStart; startDay!=0&&i<=lastMothend; i++) {
            html += '<td  id="last'+lastStr+'-'+i+'" data="" >';
            html+='<div class="notSelectMonthDay" >';
            html+='</div></td>';
            numRow++;
        }
        var str='';
        for (var j = 1; j <= nDays; j++) {

        	var t=tmpcld[j-1];
           	var d=t.lDay;
           	var s=cDay(d);

        	if(j==1){
        		begindate=currentStr+'-'+(j>9?j:'0'+j);
        	}
        	//对当天做标记
            if (year==todayY&&month==todayM&&j == todayD) {
                html += '<td id="'+currentStr+'-'+(j>9?j:'0'+j)+'" data=""  wd="'+numRow+'">';  
                html += '<div ><div class="dateTerm currentCalendar">'+j;
            }
            else {
                html += '<td id="'+currentStr+'-'+(j>9?j:'0'+j)+'" data=""  wd="'+numRow+'">';
                html += '<div';
                if(numRow==0||numRow==6){
            		html+=' class="weekEnd"';
            	}
            	html += '><div class="dateTerm">'+j;
            }
       		 html += '</div>';
           if(showChineseDay){
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
            html +='</div></td>';
            numRow++;
            if (numRow == 7) {  //如果已经到一行（一周）了，重新创建tr
                numRow = 0;
                totalRow++;
                html += '</tr><tr  class="ltd1">';
            }
        }
		//补充后一个月
        if(numRow>0){
        	for(var j=1;j<=7;j++){
	        	html += '<td  id="next'+nextStr+'-0'+j+'" data="" wd="'+numRow+'">';
	        	html+='<div class="notSelectMonthDay" ></div></td>';
	            numRow++;
	        	if (numRow == 7) {  //如果已经到一行（一周）了，重新创建tr
	                numRow = 0;
	                html += '</tr>';
	                break;
	            }
        	}
        }
        
    	row1=totalRow;
   		return html;
    }

    function calendar2() {
    	var tmpcld=new calendar(pageDate2.getFullYear()+'',pageDate2.getMonth()+'');
        var year = pageDate2.getFullYear();      //选中年
        var month = pageDate2.getMonth()+1;    //选中月
        var day = pageDate2.getDate();           //选中日
        var todayY=currentToday1.getFullYear();//本年
		var todayM=currentToday1.getMonth()+1;//本月
		var todayD=currentToday1.getDate();//今天
		var selectDate=year+"-"+(month>9?month:"0"+month)+"-"+(day>9?day:"0"+day);
		if(showChineseDay){
			$("#showDate2").html(year+"年"+(month>9?month:"0"+month)+"月");
		}else{
			$("#showDate2").html(year+"/"+(month>9?month:"0"+month));
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
        //第一行
        var html = '<tr  class="ltd2">';
        for (i = lastMothStart; startDay!=0&&i<=lastMothend; i++) {
            html += '<td  id="last'+lastStr+'-'+i+'" data="" wd="'+numRow+'">';
            html+='<div class="notSelectMonthDay">';
            html+='</div></td>';
            numRow++;
        }
        for (var j = 1; j <= nDays; j++) {
        	var t=tmpcld[j-1];
            var d=t.lDay;
            var s=cDay(d);
        	if(j==nDays){
        		enddate=currentStr+'-'+(j>9?j:'0'+j);
        	}
        	//对当天做标记
            if (year==todayY&&month==todayM&&j == todayD) {
                html += '<td id="'+currentStr+'-'+(j>9?j:'0'+j)+'" data=""  wd="'+numRow+'">';  
                html += '<div ><div class="dateTerm currentCalendar">'+j;
            }
            else {
                html += '<td id="'+currentStr+'-'+(j>9?j:'0'+j)+'"  data=""  wd="'+numRow+'">';
                html += '<div ';
                if(numRow==0||numRow==6){
            		html+=' class="weekEnd" ';
            	}
            	html += '><div class="dateTerm">'+j;
            }
            html += '</div>';
            if(showChineseDay){
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
            html+='</div></td>';
            numRow++;
            if (numRow == 7) {  //如果已经到一行（一周）了，重新创建tr
                numRow = 0;
                totalRow++;
                html += '</tr><tr  class="ltd2">';
            }
        }
		//补充后一个月
        if(numRow>0){
        	for(var j=1;j<=7;j++){
	        	html += '<td  id="next'+nextStr+'-0'+j+'" data="" wd="'+numRow+'">';
	        	html+='<div class="notSelectMonthDay" ></div></td>';
	            numRow++;
	        	if (numRow == 7) {  //如果已经到一行（一周）了，重新创建tr
	                numRow = 0;
	                html += '</tr>';
	                break;
	            }
        	}
        }
        row2=totalRow;
   		return html;
    }

    function getHoliday(){
    	 $.post("GetHoliday.jsp", 
			{"begindate":begindate,"enddate":enddate},
	   	function(data){
	   		var wds=data.workdays;
	   		var hds=data.holidays;
	   		var holidayRemarks=data.holidayRemarks; 
	   		for (var k=0;k<wds.length;k++) {
	   			var key=wds[k];
	   			var re=$('#'+key).attr("wd");
	   			
	   			if(re=='0'||re=='6'){
					var tmp=key.split('-');
	   				tmp=tmp[2].replace('0','');
   					var html='<div class="bsup" style="float:right;">'+(showChineseDay?'班':'<img src="/fullsearch/img/ban_wev8.png">')+'</div>';
	   				if(key==today){//如果当天为串休修改字体颜色为白色
	   					 //var html='<div class="bsup" style="float:right;">班</div>';
	   					 //$('#'+key).children('div').eq(0).prepend(html);
	   				}else{
	   					//var html='<SUP class="bsup">班</SUP>';
	   					//$('#'+key).children('div').eq(0).children('div').eq(0).append(html);
	   				}
					$('#'+key).children('div').eq(0).prepend(html);
	   			}
	   		};
	   		for (var k=0;k<hds.length;k++) {
	   			var key=hds[k];
	   			
	   			var re=$('#'+key).attr("wd");
	   			//if(re!='0'&&re!='6'){
	   				var tmp=key.split('-');
	   				tmp=tmp[2].replace('0','');
   					var html='<div class="xsup" style="float:right;">'+(showChineseDay?'休':'<img src="/fullsearch/img/xiu_wev8.png">')+'</div>';
	   				if(key==today){//如果当天为假期修改字体颜色为白色
	   					//var html='<div class="xsup" style="float:right;">休</div>';
	   					//$('#'+key).children('div').eq(0).prepend(html);
	   				}else{
	   					//var html='<SUP class="xsup">休</SUP>';
	   					//$('#'+key).children('div').eq(0).children('div').eq(0).append(html);
	   					
	   				}
					$('#'+key).children('div').eq(0).prepend(html);
	   			//}
	   		}; 
	   		//休假备注
	   		for(var date in holidayRemarks){
	   			$('#'+date).attr('title',holidayRemarks[date]);
	   		}
	   	});
    }
 
 function next(obj){
 	pageDate1.setDate(1);//设置本月第一天
 	 pageDate1.setMonth(pageDate1.getMonth() + 1);
 	 pageDate2.setDate(1);//设置本月第一天
 	 pageDate2.setMonth(pageDate2.getMonth() + 1);
 	$('#LDay').html(calendar1());
	$('#LDay2').html(calendar2());
 	//$('.ltd1').height((tdH/row1));
	//$('.ltd2').height((tdH/row2));
	getHoliday();
 }
 
 function prev(obj){
 	pageDate1.setDate(1);//设置本月第一天
 	 pageDate1.setMonth(pageDate1.getMonth() - 1);
 	 pageDate2.setDate(1);//设置本月第一天
 	 pageDate2.setMonth(pageDate2.getMonth() - 1);
 	$('#LDay').html(calendar1());;
	$('#LDay2').html(calendar2());
	//$('.ltd1').height((tdH/row1));
	//$('.ltd2').height((tdH/row2));
 	getHoliday();
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
// --------农历部分代码

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
function calendar(y,m) {
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


$(document).ready(function() {
	jQuery(".LeftArrow").hover(function(){
		jQuery(this).addClass("LeftArrow1");
	},function(){
		jQuery(this).removeClass("LeftArrow1");
	});
	jQuery(".RightArrow").hover(function(){
		jQuery(this).addClass("RightArrow1");
	},function(){
		jQuery(this).removeClass("RightArrow1");
	});
	 
	 $('#LDay').html(calendar1());
	 $('#LDay2').html(calendar2());
	//$('.ltd1').height((tdH/row1));
	//$('.ltd2').height((tdH/row2));
	
	 getHoliday();
});




</script>

</HTML>
