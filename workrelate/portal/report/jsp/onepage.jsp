<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!doctype html>
<html lang="en">
  <head>
    <title>报表</title>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/highcharts.js"></script>
    <script type="text/javascript" src="../js/exporting.js"></script>
    
    <style type="text/css">
        body{
            font-family: '微软雅黑';
            font-size:12px;
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
    <!-- 主体 -->
    <div>
        <!-- 菜单 -->
        <div>
            <div id="menu" style="padding:3px;background:#DEEBF7;">
                <span class="modtd" onclick="companyClick()">公司整体</span>
                <span class="modtd" onclick="areaClick()">区域对比</span>
                <span class="modtd" onclick="deptClick()">部门对比</span>
                <span class="modtd" onclick="hrmClick()">人员对比</span>
            </div>
        </div>
        <script type="text/javascript">
        $("#menu span").bind("mouseover",function(){
            $(this).removeClass("modtd");
            $(this).addClass("modtdHover");
        }).bind("mouseout",function(){
            $(this).addClass("modtd");
            $(this).removeClass("modtdHover");
        });
    </script>
        <!-- 图表 -->
        <div id="allcontainer">
            <!-- 公司整体 -->
            <div id="companyContainer">
                <!-- 目标分析 -->
                <div id="company1" style="min-width:700px;height:300px"></div>
                <!-- 报告分析 -->
                <div id="company2" style="min-width:700px;height:300px"></div>
                <!-- 任务分析 -->
                <div id="company3" style="min-width:700px;height:300px"></div>
                <!-- 绩效分析 -->
                <div id="company4" style="min-width:700px;height:300px"></div>
            </div>
        </div>
    </div>
  </body>
  <script type="text/javascript" src="../js/charts.js"></script>
  <script type="text/javascript">
      
      /********公司整体***********/
      function companyClick(){        
          $('#company1').html("");

          
          $('#company1').highcharts({
              chart: {type: 'column'},
              title: {text: '目标分析'},
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
              series: [{
                  name: '今年',
                  data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
    
              }, {
                  name: '同期',
                  data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
              }]
          });
          
      }
      /********公司整体end***********/
      
      
      companyClick();
  </script>
</html>
