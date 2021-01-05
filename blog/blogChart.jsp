
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

String userid=""+user.getUID();

String title=request.getParameter("title");
int year=Util.getIntValue(request.getParameter("year"),0);
String value=Util.null2String(request.getParameter("value"));
String chartType=Util.null2String(request.getParameter("chartType"));
String type=Util.null2String(request.getParameter("type"));
BlogReportManager reportManager=new BlogReportManager();
reportManager.setUser(user);

Map map=new HashMap();
if(chartType.equals("blog")){
	if(type.equals("1"))
		  map=reportManager.getBlogChartReportByUser(value,year);
	else if(type.equals("2")||type.equals("3"))  
		  map=reportManager.getBlogChartReportByOrg(userid,value,type,year);
}else if(chartType.equals("mood")){
	if(type.equals("1"))
		  map=reportManager.getMoodChartReportByUser(value,year);
	else if(type.equals("2")||type.equals("3")) 
	     map=reportManager.getMoodChartReportByOrg(userid,value,type,year);
}else if(chartType.equals("schedule")){
	if(type.equals("1"))
		  map=reportManager.getScheduleChartReportByUser(value,year);
}


List categoriesList=(List)map.get("categoriesList");
List blogSeriesList=(List)map.get("SeriesList");

String blogSeriesName=(String)map.get("SeriesName");
String categories=JSONArray.fromObject(categoriesList).toString();
String blogSeries=JSONArray.fromObject(blogSeriesList).toString();

Calendar calendar=Calendar.getInstance();
int currentYear=calendar.get(Calendar.YEAR);

BlogDao blogDao=new BlogDao();
Map enbaleDate=blogDao.getEnableDate();
int enableYear=((Integer)enbaleDate.get("year")).intValue();  //微博开始使用年

%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Highcharts Example</title>
		<script src="../js/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="js/report/highcharts_wev8.js"></script>
		<script type="text/javascript" src="js/report/modules/exporting_wev8.js"></script>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type='text/javascript' src='js/timeline/lavalamp.min_wev8.js'></script>
        <script type='text/javascript' src='js/timeline/easing_wev8.js'></script>
        <link href="js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css">
		<script type="text/javascript">
		
			var chart;
			$(document).ready(function() {
			    var categories=eval('(<%=categories%>)');
			    var blogSeriesData=eval('(<%=blogSeries%>)');
			    
				chart = new Highcharts.Chart({
					chart: {
						renderTo: 'container',
						defaultSeriesType: 'column'
					},
					credits:{
					 enabled:false
					},
					title: {
						text: '<%=title%>',
						x: -20 //center
					},
					subtitle: {
						text: '',
						x: -20
					},
					xAxis: {
					    categories:categories
					},
					yAxis: {
						title: {
							text: ''
						},
						plotLines: [{
							value: 0,
							width: 1,
							color: '#808080'
						}],
						max:5
					},
					//指数提示
					tooltip: {
					    style:{
					       padding: 5
					    },
				        formatter: function() {
				            var s = '<b>'+ this.x +'</b>';
				            
				            $.each(this.points, function(i, point) {
				                s += '<br/><span style="color:#3e576f;font-weight:bold">'+ point.series.name +'</span>: '+
				                    point.y; 
				            });
				            
				            return s;
				        },
				        shared: true
                    },
                    exporting: {
                        enabled: false
                    },
					series: [{
						name: '<%=blogSeriesName%>',
						//data: [3.5, 2.5, 3.4, 4.2, 3.8, 4.2, 3.8, 3.9, 3.5, 3.1, 2.6, 2.4]
						data:blogSeriesData
				
					}
					/*, {
						name: '心情指数',
						data: [2.6, 2.4, 2.5, 4.4, 4.0, 3.5, 3.0, 4.3, 4.0, 4.3, 4.6, 3.0]
				
					}, {
						name: '考勤指数',
						data: [4.9, 4.8, 4.3, 4.4, 3.0, 4.3, 4.0, 4.6, 4.4, 4.4,4, 4.2]
				
					}
					*/
					]
				});
				
				$(function(){$(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
				
			});
		 
		 function changeYear(year){
		    window.location.href="blogChart.jsp?title=<%=title%>&type=<%=type%>&value=<%=value%>&chartType=<%=chartType%>&year="+year;
		 }	
		</script>
		
	</head>
	<body style="text-align: center;overflow: auto;">
		<div id="container" style="width: 650px; height: 380px; margin: 0 auto"></div>
		
	    <div style="margin-bottom: 5px;">
	    <div style="border-bottom:#b6b6b6 1px solid">
         <div class="lavaLampHead">
			 <ul class="lavaLamp" id="timeContent">
			 <%
			   for(int i=enableYear;i<=currentYear;i++){
			 %>
				 <li <%=i==year?"class='current'":""%>><a href="javascript:changeYear('<%=i%>')"><%=i%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></a></li><!-- 年 -->
		    <%} %>		 
			 </ul>
         </div>
         </div>
    </div>		
	</body>
</html>
