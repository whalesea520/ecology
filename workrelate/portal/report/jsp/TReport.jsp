<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!doctype html>
<html lang="en">
  <head>
    <title>任务分析</title>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/highcharts.js"></script>
    <script type="text/javascript" src="../js/exporting.js"></script>
    
    <style type="text/css">
        body{
            font-family: '微软雅黑';
            font-size:12px;
            padding: 0px;
            margin: 0px;
        }
        .modtd{
            padding:0 5px 0 5px;
            font-size:12px;
            height:30px;
            line-height:30px;
            cursor:pointer;
            color:#8FAADC;
            width:64px;
            display:inline-block;
            text-align:center;
        }
        .modtdHover{
            padding:0 5px 0 5px;
            font-size:12px;
            height:30px;
            line-height:30px;
            cursor:pointer;
            width:64px;
            color:#fff;
            background:#2ec8e9; 
            text-align:center;
            display:inline-block;
        }
        .anlyLine{
            width:96%;margin:0 10px;background:#f6bf1c;height:24px;line-height:24px;padding-left:8px;
        }
    </style>
  <%@ include file="/secondwev/common/head.jsp" %>
	</head>
  
  <body>
  	<div id="company1" style="width:100%;height:250px;margin-top: 10px;"></div>
  </body>
  <script type="text/javascript" src="../js/charts.js"></script>
  <script type="text/javascript">
      
  function companyClick(){
      $('#allcontainer').children().hide();
      $('#companyContainer').show();
      
      $('#company1').html("");
      $('#company2').html("");
      $('#company3').html("");
      $('#company4').html("");
      
      $('#company1').highcharts({
          chart: {type: 'column'},
          title: {text: ''},
          xAxis: {
              categories: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
          },
          yAxis: {
              min: 0,
              title: {text: '完成比(%)'}
          },
          tooltip: {
              headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
              pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                  '<td style="padding:0"><b>{point.y:.1f} %</b></td></tr>',
              footerFormat: '</table>',
              shared: true,
              useHTML: true
          },
          plotOptions: {
              column: {
                  pointPadding: 0.2,
                  borderWidth: 0
              }
          },
          credits: { 
              enabled: false 
          },  
          series: [{
              name: '今年',
              data: [49.9, 71.5, 90.4, 80.2, 94.0, 76.0, 35.6, 48.5, 96.4, 94.1, 75.6, 54.4]

          }, {
              name: '同期',
              data: [83.6, 78.8, 98.5, 93.4, 86.0, 84.5, 75.0, 54.3, 91.2, 83.5, 76.6, 92.3]

          }]
      });
  }
      
      
      companyClick();
  </script>
</html>
