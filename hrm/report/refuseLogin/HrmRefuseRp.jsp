
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-08-07 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("LogView:View", user))  {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(31337,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String chartType = Util.null2String(request.getParameter("chartType"));
	
	LN ckLicense = new LN();
	ckLicense.CkHrmnum();
	String concurrentFlag = Util.null2String(ckLicense.getConcurrentFlag());
	int hrmnumber = Util.getIntValue(ckLicense.getHrmnum());
	Calendar calendar=Calendar.getInstance();
	int currentYear=calendar.get(Calendar.YEAR);
	int currentMonth=calendar.get(Calendar.MONTH)+1;
	String begindate=TimeUtil.getYearMonthFirstDay(currentYear, currentMonth);
	String enddate=TimeUtil.getYearMonthEndDay(currentYear, currentMonth);
%>
<html>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/blog/css/blog_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript" src="/blog/js/report/highcharts_wev8.js"></script>
		<script type="text/javascript" src="/blog/js/report/modules/exporting_wev8.js"></script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div>
			<DIV id=bg></DIV>
			<div id="loading">
				<div style=" position: absolute;top: 35%;left: 25%" align="center">
					<img src="/images/loading2_wev8.gif" style="vertical-align: middle"><label id="loadingMsg"><%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%></label>
				</div>
			</div>
		</div>
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item attributes="{'samePair':'rang_tr'}"><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'rang_tr'}">
					<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
						<input class=wuiDateSel type="hidden" name="begindate" value="<%=begindate%>">
						<input class=wuiDateSel type="hidden" name="enddate" value="<%=enddate%>">
					</span>
					<span style="margin-left:50px;">
						<input type=button class="e8_btn_top" onclick="OnSearch();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					</span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(31316,user.getLanguage())%></wea:item>
				<wea:item>
					<label id="maxNum"></label>
					<label id="tips" style="display: none;color: red;">&nbsp;&nbsp;(<%=SystemEnv.getHtmlLabelName(129083, user.getLanguage())%>)</label>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(31301,user.getLanguage())%></wea:item>
				<wea:item>
					<label id="maxDate"></label>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(31317,user.getLanguage())%></wea:item>
				<wea:item>
					<label id="maxTime"></label>
				</wea:item>
			</wea:group>
		</wea:layout>
		<!-- 折线图报表 -->
		<div id="containerdiv" style="width: 98%;border: 1px solid #666666;margin-left: 10px;">
			<div id="container" style="height: 250px;width:100%" align="center"></div>
		</div>
		<!-- 柱状图报表 -->
		<div id="containerdiv2" style="width: 98%;border: 1px solid #666666;margin-left: 10px;margin-top: 10px;display: none;">
			<div id="container2" style="height:250px;width:100%"></div>
		</div>
		<script>
			window.onresize=function(){
				jQuery(".highcharts-container").width(jQuery("#table1").width());
			}
			jQuery(document).ready(function(){
				var itemType="<%=chartType%>";
				if(itemType== "self_time"){
					showEle("rang_tr");
					$("#containerdiv").hide();
				}else{
					hideEle("rang_tr");
					$("#containerdiv").show();
				}
				if(itemType=="day")
					$("#containerdiv2").hide();
				else
					$("#containerdiv2").show();
				doPost(itemType);
				
			});

			function doPost(itemType){
				var begindate=$GetEle("begindate").value;
				var enddate=$GetEle("enddate").value;
				if(itemType=="self_time"){
					if(begindate==""||enddate==""){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
						return;
					}	
				}
				displayLoading(1,"data");
				$.post("HrmRefuseData.jsp?operation="+itemType+"&begindate="+begindate+"&enddate="+enddate,function(data){
						
					data = $.trim(data);
					data=eval("("+data+")");
					
					setMaxInfo(data.maxNum,data.maxDate,data.maxTime,data.maxWeek);
					if(itemType == "week"){
						checkLineReport(data.splineData,"<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())+SystemEnv.getHtmlLabelName(31323,user.getLanguage())%>","spline",itemType);
						checkLineReport(data.columnData,"","column",itemType); 
					}else if (itemType == "month"){
						checkLineReport(data.splineData,"<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())+SystemEnv.getHtmlLabelName(31323,user.getLanguage())%>","spline",itemType);
						checkLineReport(data.columnData,"","column",itemType);
					}else if(itemType == "day"){
						checkLineReport(data.splineData,"<%=SystemEnv.getHtmlLabelName(31299,user.getLanguage())+SystemEnv.getHtmlLabelName(31319,user.getLanguage())%>","spline",itemType);
						checkLineReport(data.columnData,"","column",itemType);
					}else if(itemType == "year"){
						checkLineReport(data.splineData,"<%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())+SystemEnv.getHtmlLabelName(31323,user.getLanguage())%>","spline",itemType);
						checkLineReport(data.columnData,"","column",itemType);
					}else if(itemType == "quarter"){
						checkLineReport(data.splineData,"<%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())+SystemEnv.getHtmlLabelName(31323,user.getLanguage())%>","spline",itemType);
						checkLineReport(data.columnData,"","column",itemType);
					}else
						checkLineReport(data.columnData,"","column",itemType);
					displayLoading(0);
				 });
			}
			   
			//获取折线报表
			function checkLineReport(data,title,chartType,itemType){  
				
				var categoriesData=data.categoriesData;
				var seriesData=data.seriesData;
				title=chartType=="spline"?title:"<%=SystemEnv.getHtmlLabelName(31321,user.getLanguage())%>";
				var seriesName=itemType=="day"?"<%=SystemEnv.getHtmlLabelName(31320,user.getLanguage())%>":"<%=SystemEnv.getHtmlLabelName(31316,user.getLanguage())%>";	 	
				chart = new Highcharts.Chart({
					chart: {
						renderTo: chartType=="spline"?"container":"container2",
						type: chartType,
						ignoreHiddenSeries:true
						//marginRight: 130,
						//marginBottom: 25
					},
					credits:{
						 enabled:false
					},
					title: {
						text: title,
						x: -20 //center
					},
					subtitle: {
						//text: 'Source: WorldClimate.com',
						//x: -20
					},
					xAxis: {
						/*
						categories: ['00:00','01:00', '02:00', '03:00', '04:00', '05:00', '06:00',
							'07:00', '08:00', '9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00'
							, '22:00', '23:00']
						*/
						categories:categoriesData
					},
					yAxis: {
						title: {
							text: ''
						}
					},
					tooltip: {
						valueSuffix: '°C'
					},
					exporting: {
						enabled: false
					},
					series: [{
						name: seriesName, //登录被限人数
						//data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6, 13.9]
						data:seriesData
					}]
				});
			}

			function setMaxInfo(maxNum,maxDate,maxTime,maxWeek){
				
				jQuery("#maxNum").html(maxNum);
				jQuery("#maxDate").html(maxDate==""?"":(maxDate+"("+(maxWeek==-1?"":getWeekDayByDay(maxWeek))+")"));
				jQuery("#maxTime").html(maxTime);
				
				var hrmnumber =<%=hrmnumber%>;
				var licenseType="<%=concurrentFlag%>";
				licenseType="1";
				if(licenseType=="1"&&parseInt(maxNum) > parseInt(hrmnumber * 0.1)){
					$("#tips").show();
					$("#maxNum").css("color","red");
				}else{
					$("#tips").hide();
					$("#maxNum").css("color","#000");
				}
					
			}

			//通过日期获得星期
			function getWeekDayByDay(day){
				var weekArray = new Array(
						"<%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%>", 
						"<%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%>", 
						"<%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%>", 
						"<%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%>", 
						"<%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%>", 
						"<%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%>", 
						"<%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%>");
				return weekArray[day];
			}

			function OnSearch(){
				doPost("self_time");
			}


			function displayLoading(state,flag){
			 if(state==1){
				   //遮照打开
				   var bgHeight=document.body.scrollHeight; 
				   var bgWidth=window.parent.document.body.offsetWidth;
				   jQuery("#bg").css("height",bgHeight,"width",bgWidth);
				   jQuery("#bg").show();
				   //alert(1);
				   if(flag=="save")
					  jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>");   //正在保存，请稍等...
				   else if(flag=="page")
					  jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%>");   //页面加载中，请稍候...
				   else if(flag=="data")
					  jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");   //正在获取数据,请稍等...  
						 
				   //显示loading
					var loadingHeight=jQuery("#loading").height();
					var loadingWidth=jQuery("#loading").width();
					jQuery("#loading").css({"top":'40%',"left":'30%'});
					jQuery("#loading").show();
			   }else{
				   jQuery("#loading").hide();
				   jQuery("#bg").hide(); //遮照关闭
			   }
			}
		</script>
	</body>
</html>
