
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.blog.BlogDao"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
  String userid=""+user.getUID();
  String title=Util.null2String(request.getParameter("title"));
  String conType=Util.null2String(request.getParameter("conType"));
  String conValue=Util.null2String(request.getParameter("conValue"));
  String chartType=Util.null2String(request.getParameter("chartType"));
  String chartName="";
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  
  int year=Util.getIntValue(request.getParameter("year"),currentYear);
  
  BlogDao blogDao=new BlogDao();
  Map monthMap=blogDao.getCompaerMonth(year);
  int startMonth=((Integer)monthMap.get("startMonth")).intValue();   //开始月份
  int endMonth=((Integer)monthMap.get("endMonth")).intValue();       //结束月份
  
  Map enbaleDate=blogDao.getEnableDate();
  int enableYear=((Integer)enbaleDate.get("year")).intValue();      //微博开始使用年
  
  int month=Util.getIntValue(request.getParameter("month"),endMonth);
  
  String monthStr=month<10?("0"+month):(""+month);
  
  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
  
  String conTypes[]=conType.split(",");
  String conValues[]=conValue.split(",");
  
  List categoriesList=new ArrayList();
  List seriesDataList=new ArrayList();
  
  double workIndex=0;
  String categorie="";
  for(int i=0;i<conTypes.length;i++){
	  String type=conTypes[i];
	  String value=conValues[i];
	  if("blog".equals(chartType)){
		  	chartName=SystemEnv.getHtmlLabelName(26929,user.getLanguage());  //工作指数
	  }else if("mood".equals(chartType)){
		  chartName=SystemEnv.getHtmlLabelName(26930,user.getLanguage());    //心情指数
	  }
	  if(type.equals("1")){
		  if("blog".equals(chartType)){
			  workIndex=Double.parseDouble(reportManager.getBlogIndexByUser(value,year,month));
		  }else if("mood".equals(chartType)){
			  workIndex=Double.parseDouble(reportManager.getMoodIndexByUser(value,year,month));
		  }
		    
		  categorie=ResourceComInfo.getLastname(value);
	  }else if(type.equals("2")||type.equals("3")){
		  
		  if("blog".equals(chartType)){
			  workIndex=reportManager.getBlogIndexByOrg(userid,value,type,year,month);
		  }else if("mood".equals(chartType)){
			  workIndex=reportManager.getMoodIndexByOrg(userid,value,type,year,month);
		  }
		  
		  categorie=type.equals("2")?SubCompanyComInfo.getSubCompanyname(value):DepartmentComInfo.getDepartmentname(value);
	  }
	  
	  categoriesList.add(categorie);	
	  seriesDataList.add(new Double(workIndex));
  }
  
  String categories=JSONArray.fromObject(categoriesList).toString();
  String seriesData=JSONArray.fromObject(seriesDataList).toString();

%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Highcharts Example</title>
		<script type="text/javascript" src="js/report/highcharts_wev8.js"></script>
		<script type="text/javascript" src="js/report/modules/exporting_wev8.js"></script>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type='text/javascript' src='js/timeline/lavalamp.min_wev8.js'></script>
        <script type='text/javascript' src='js/timeline/easing_wev8.js'></script>
        <link href="js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css">
        <LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
		    var categories=eval('(<%=categories%>)');
		    var seriesData=eval('(<%=seriesData%>)');
			var chart;
			$(document).ready(function() {
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
						x: -20,
						style: {
                           color: '#000000',
                           fontWeight: 'bold',
                           fontSize:'16'
                        }
					},
					subtitle: {
						text: '',
						x: -20
					},
					xAxis: {
						categories: categories
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
						max:5   //最大指数
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
						name: '<%=chartName%>',
						data: seriesData
				
					}
					/*
					, {
						name: '心情指数',
						data: [2.6, 2.4, 2.5]
				
					}, {
						name: '考勤指数',
						data: [4.9, 4.8, 4.3]
				
					}
					*/
					]
				});
				
				$(function(){$(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
				
			});

		 function changeMonth(compareYear,compareMonth){
		    window.location.href="compareChart.jsp?title=<%=title%>&chartType=<%=chartType%>&conType=<%=conType%>&conValue=<%=conValue%>&year="+compareYear+"&month="+compareMonth;
		 }
		 
		 function changeYear(){
		    var year=jQuery("#yearSelect").val();
		    window.location.href="compareChart.jsp?title=<%=title%>&chartType=<%=chartType%>&conType=<%=conType%>&conValue=<%=conValue%>&year="+year;
         } 
		 
		</script>
		
	</head>
	<body>
	  <table style="margin: 0px;padding: 0px;width: 100%" align="center">
	     <tr>
	         <td align="center" style="margin: 0px;padding: 0px;" >
		        <div id="container" style="width: 650px; height: 380px; margin: 0 auto"></div>
		
			    <div style="margin-bottom: 5px;" align="center">
			    	<div style="border-bottom:#b6b6b6 1px solid">
				         <div class="lavaLampHead">
				              <div style="width: 80%;float: left;">
									<ul class="lavaLamp" id="timeContent">
									  <%for(int i=startMonth;i<=endMonth;i++){ 
									      monthStr=i<10?("0"+i):("")+i;
									  %>
									     <li <%=i==month?"class='current'":""%>><a href="javascript:changeMonth(<%=year%>,<%=i%>)"><%=i%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></a></li><!-- 月 -->
									  <%}%>
									</ul>
								</div>	
							    <div class="report_yearselect" align="right">
								     <select style="width: 80px;" id="yearSelect" onchange="changeYear()">
								         <%
										   for(int i=currentYear;i>=enableYear;i--){ 
										 %>
										   <option value="<%=i%>" <%=i==year?"selected='selected'":""%>><%=i%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option><!-- 年 -->
									    <%} %>
								     </select>
						         </div>
				         </div>
				  </div>       
		    </div>
           </td>
	     </tr>
	  </table>	
	</body>
</html>
