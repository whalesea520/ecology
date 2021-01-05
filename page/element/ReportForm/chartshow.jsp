
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%
User _user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
int _language = 7;
if (_user != null) {
	_language = _user.getLanguage();
}
%>
<html>
  <head>
        <script src="/page/layoutdesign/js/jquery_wev8.js"></script>
        <script src="/page/layoutdesign/js/jquery-ui_wev8.js"></script>
		<script src="/js/highcharts/highcharts_wev8.js"></script>
		<script src="/js/highcharts/highcharts-more_wev8.js"></script>
        <script src="/js/highcharts/highcharts-3d_wev8.js"></script>

		
		<style>

		    body{
		         margin:0px;
		    }
           .chartarea{
				 width:100%;
				 height:100%;
		   }
		   .remindicon{
		        font-family: '微软雅黑';
				font-size: 12px;
				display: table-cell;
				vertical-align: middle;
				text-align: center;
		   }
		</style>
  </head>
  <body>
      <div class='chartarea'>
	     
	  </div>
	  <script>
	     	//生成图表
    function  generatorSimpechart(charttype,chartdatas,dot){
		       
			   if((chartdatas.categorys!==undefined && chartdatas.categorys.length===0)  || (chartdatas.data!==undefined && chartdatas.data.length===0) || (charttype==='11'  && chartdatas.data!==undefined  && chartdatas.data.startval===undefined)){
			       var remindinfo=$("<div class='remindicon'><%=SystemEnv.getHtmlLabelName(83553,_language)%>!</div>");
                   remindinfo.css("height",$(".chartarea").height()+'px');
				   remindinfo.css("width",$(".chartarea").width()+'px');
				   $(".chartarea").append(remindinfo);
				   return;
			   }
			   if(charttype==='11'){
			        generatorGauge(charttype,chartdatas,dot); 
			        return;
			   }
			   if(charttype==='6' || charttype==='7' || charttype==='8'){
			      generatorPieChart(charttype,chartdatas,dot); 
				  return;
			   }
		       var categorys = chartdatas.categorys;
			   var series = chartdatas.series;
               var seriearray=[];
			   var ctype='column',serieitem,dataarray,is3d=false;
			   switch(charttype){
			    case "1":ctype='column';break;
				case "2":ctype='column';is3d=true;break;
				case "3":ctype='line';break;
                case "4":ctype='area';break;
				case "5":ctype='bar';break;
			   }
               for(var item in series){
			      serieitem=series[item];
				  dataarray=serieitem["data"];
				  for(var i=0;i<dataarray.length;i++){
				     dataarray[i]=parseFloat(dataarray[i]);
				  }
				  seriearray.push(serieitem);
			   }

	           var chartitem=$(".chartarea").highcharts({
					chart: {
						type: ctype,
						options3d: {
							enabled:is3d,
							alpha: 15,
							beta: 15,
							viewDistance: 25,
							depth: 40
						}
					},
					title: {
						text: ''
					},
					subtitle: {
						text: ''
					},
					xAxis: {
						categories: categorys,
						labels: {
								style: {
									font: '12px 微软雅黑'
								}
                         }
					},
					yAxis: {
						min: 0,
						title: {
							text: ''
						}
					},
				    legend: {
						itemStyle: {
							fontFamily: "微软雅黑",
							fontSize: "12px"
						}
                    },
					tooltip: {
						style: {
                            fontFamily: '微软雅黑',
							fontSize: "12px"
                        },
						pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
							'<td style="padding:0"><b>{point.y:.'+dot+'f}</b></td></tr>'
					},
					plotOptions: {
						series: {
							   dataLabels: {
								   enabled: false,
								   formatter: function () {
                                       return  Highcharts.numberFormat(this.point.y,~~(dot||"0"));
                                   }
							   }
						},							 
 						column: {
							pointPadding: 0.2,
							borderWidth: 0,
								depth: 25
						}
					},
					series: seriearray
				}).highcharts();	
			   if(is3d){
			     chartitem.options.chart.options3d.beta=15; chartitem.redraw(false);
			   }

	     }
      
	  //生成饼图
	  function  generatorPieChart(charttype,chartdatas,dot){
            var is3d=false;
			var innerSizeValue = 0;
			if(charttype==='7')
				 is3d=true;
			if(charttype==='8')
				innerSizeValue = 40;
			var datas=chartdatas.data;
			var dataitem;
			for(var i=0;i<datas.length;i++){
			    dataitem=datas[i];
				dataitem[1]=parseFloat(dataitem[1]);
			}
	        $('.chartarea').highcharts({
				chart: {
					type: 'pie',
					options3d: {
						enabled: is3d,
						alpha: 45,
						beta: 0
					}
				},
				title: {
					text: ''
				},
				tooltip: {
					pointFormat: '{series.name}: <b>{point.percentage:.'+dot+'f}%</b>',
					style: {
						fontFamily: "微软雅黑",
						fontSize: "10px",
						lineHeight: "12px"
                    }
				},
				plotOptions: {
					pie: {
						allowPointSelect: true,
						cursor: 'pointer',
						depth: 35,
						dataLabels: {
							enabled: true,
							format: '{point.y}'
						},
						style: {
                            lineHeight: "12px",
                            fontSize: "12px",
                            fontFamily: "微软雅黑"
                        },
						innerSize:innerSizeValue
					}
				},
				series: [{
					type: 'pie',
					name:chartdatas.seriename,
					data:chartdatas.data
				}]
			});
	  
	  }
    
	      //生成仪表盘
      function generatorGauge(charttype,chartdatas,dot){
	   
	     
	        var cdata=chartdatas.data;

			cdata.startval = parseFloat(Highcharts.numberFormat(cdata.startval, ~~dot , '.'));
			cdata.endval = parseFloat(Highcharts.numberFormat(cdata.endval, ~~dot , '.'));
			cdata.middleval = parseFloat(Highcharts.numberFormat(cdata.middleval, ~~dot , '.'));
			cdata.realval = parseFloat(Highcharts.numberFormat(cdata.realval, ~~dot , '.'));

	        $('.chartarea').highcharts({

				chart: {
					type: 'gauge',
					plotBackgroundColor: null,
					plotBackgroundImage: null,
					plotBorderWidth: 0,
					plotShadow: false
				},

				title: {
					text:''
				},

				pane: {
					startAngle: -150,
					endAngle: 150,
					background: [{
						backgroundColor: {
							linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
							stops: [
								[0, '#FFF'],
								[1, '#333']
							]
						},
						borderWidth: 0,
						outerRadius: '109%'
					}, {
						backgroundColor: {
							linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
							stops: [
								[0, '#333'],
								[1, '#FFF']
							]
						},
						borderWidth: 1,
						outerRadius: '107%'
					}, {
						// default background
					}, {
						backgroundColor: '#DDD',
						borderWidth: 0,
						outerRadius: '105%',
						innerRadius: '103%'
					}]
				},

				// the value axis
				yAxis: {
					min: cdata.startval,
					max: cdata.endval,

					minorTickInterval: 'auto',
					minorTickWidth: 1,
					minorTickLength: 10,
					minorTickPosition: 'inside',
					minorTickColor: '#666',

					tickPixelInterval: 30,
					tickWidth: 2,
					tickPosition: 'inside',
					tickLength: 10,
					tickColor: '#666',
					labels: {
						step: 2,
						rotation: 'auto'
					},
					title: {
					},
					plotBands: [{
						from: cdata.startval,
						to: cdata.middleval,
						color: '#55BF3B' // green
					}, {
						from: cdata.middleval,
						to: cdata.endval,
						color: '#DF5353' // red
					}]
				},

				series: [{
					data: [cdata.realval],
					tooltip: {
						valueSuffix: ' ',
						style: {
                            fontFamily: '微软雅黑',
							fontSize: "12px"
                        }
					}
				}]

			});
	  
	  
	  }

	  </script>
  </body>
</html>