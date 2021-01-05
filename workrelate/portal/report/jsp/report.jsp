<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!doctype html>
<html lang="en">
  <head>
    <title>报表</title>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/highcharts.js"></script>
    <script type="text/javascript" src="../js/charts.js"></script>
    
    <style type="text/css">
        html,body{
            padding:0px;
            margin:0px;
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
        #menu a:hover{
            color:#fff;
            background:#2ec8e9; 
        }
        .anlyLine{
            width:96%;
            margin:0 10px;
            background:#70E1FF;
            height:24px;
            line-height:24px;
            padding-left:8px;
            font-weight:bold;
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
                <a class="modtd" onclick="companyClick()">公司整体</a>
                <a class="modtd" onclick="areaClick()">区域对比</a>
                <a class="modtd" onclick="deptClick()">部门对比</a>
                <a class="modtd" onclick="hrmClick()">人员对比</a>
            </div>
        </div>
        <!-- 图表 -->
        <div id="allcontainer" style="margin-top:10px;">
            <!-- 公司整体 -->
            <div id="companyContainer">
                <!-- 目标分析 -->
                <div class="anlyLine">目标分析</div>
                <div id="company1" style="height:300px"></div>
                <!-- 报告分析 -->
                <div class="anlyLine">报告分析</div>
                <div id="company2" style="height:300px"></div>
                <!-- 任务分析 -->
                <div class="anlyLine">任务分析</div>
                <div id="company3" style="height:300px"></div>
                <!-- 绩效分析 -->
                <div class="anlyLine">绩效分析</div>
                <div id="company4" style="height:300px"></div>
            </div>
            <!-- 区域对比 -->
            <div id="areaContainer">
                <table width="100%">
                    <colgroup>
                        <col width="40%"></col>
                        <col width="60%"></col>
                    </colgroup>
                    <!-- 目标分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">目标分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="area1" style="height:300px"></div></td>
                        <td><div id="area1detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 报告分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">报告分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="area2" style="height:300px"></div></td>
                        <td><div id="area2detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 任务分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">任务分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="area3" style="height:300px"></div></td>
                        <td><div id="area3detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 绩效分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">绩效分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="area4" style="height:300px"></div></td>
                        <td><div id="area4detail" style="height:300px"></div></td>
                    </tr>
                </table>
            </div>
            <!-- 部门对比 -->
            <div id="deptContainer">
                <table width="100%">
                    <colgroup>
                        <col width="40%"></col>
                        <col width="60%"></col>
                    </colgroup>
                    <!-- 目标分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">目标分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="dept1" style="height:300px"></div></td>
                        <td><div id="dept1detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 报告分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">报告分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="dept2" style="height:300px"></div></td>
                        <td><div id="dept2detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 任务分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">任务分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="dept3" style="height:300px"></div></td>
                        <td><div id="dept3detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 绩效分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">绩效分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="dept4" style="height:300px"></div></td>
                        <td><div id="dept4detail" style="height:300px"></div></td>
                    </tr>
                </table>
            </div>
            <!-- 人员对比 -->
            <div id="hrmContainer">
                <table width="100%">
                    <colgroup>
                        <col width="40%"></col>
                        <col width="60%"></col>
                    </colgroup>
                    <!-- 目标分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">目标分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="hrm1" style="height:300px"></div></td>
                        <td><div id="hrm1detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 报告分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">报告分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="hrm2" style="height:300px"></div></td>
                        <td><div id="hrm2detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 任务分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">任务分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="hrm3" style="height:300px"></div></td>
                        <td><div id="hrm3detail" style="height:300px"></div></td>
                    </tr>
                    <!-- 绩效分析 -->
                    <tr>
                        <td colspan="2">
                            <div class="anlyLine">绩效分析</div>
                        </td>
                    </tr>
                    <tr>
                        <td><div id="hrm4" style="height:300px"></div></td>
                        <td><div id="hrm4detail" style="height:300px"></div></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
  </body>
  <script type="text/javascript">
      Highcharts.setOptions({ 
          colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4'] 
      });
      /********公司整体***********/
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
                  max:100,
                  title: {
                      text: '完成比(%)'
                  },
                  labels: {
                      formatter: function() {
                          return this.value +'%'
                      }
                  }
              },
              tooltip: {
                  headerFormat: '<span style="font-size:10px">{point.key}</span><table width="100px">',
                  pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                      '<td style="padding:0"><b>{point.y:.1f}%</b></td></tr>',
                  footerFormat: '</table>',
                  shared: true,
                  useHTML: true
              },
              credits: {
                  enabled: false
              },
              plotOptions: {
                  column: {
                      pointPadding: 0.2,
                      borderWidth: 0
                  }
              },
              series: [{
                  name: '今年',
                  data: getRandomData(50,100,12)
              }, {
                  name: '同期',
                  data: getRandomData(50,100,12)
              }]
          });
          $('#company2').highcharts({                                          
              chart: {
              },                
              title: {
                  text: ''                                     
              },                
              xAxis: {
                  categories: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
              },
              yAxis: {
                  max:100,
                  title: {
                      text: '完成比(%)'
                  },
                  labels: {
                      formatter: function() {
                          return this.value +'%'
                      }
                  }
              },
              tooltip: {
                  headerFormat: '<span style="font-size:10px">{point.key}</span><table width="100px">',
                  pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                      '<td style="padding:0"><b>{point.y:.1f}%</b></td></tr>',
                  footerFormat: '</table>',
                  shared: true,
                  useHTML: true
              },               
              credits: {
                  enabled: false
              },
              series: [{
                  type: 'column',                                               
                  name: '今年', 
                  data: getRandomData(50,100,12)
              }, {
                  type: 'spline',                                               
                  name: '同期',                                              
                  data: getRandomData(50,100,12),
                  marker: {     
                      lineWidth: 2,                                               
                      lineColor: Highcharts.getOptions().colors[3],               
                      fillColor: 'white'                                          
                  }             
              }]                
          });                   
          $('#company3').highcharts({
              chart: {
                  type: 'spline'
              },
              title: {
                  text: ''
              },
              xAxis: {
                  categories: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
              },
              yAxis: {
                  max:100,
                  title: {
                      text: '完成比(%)'
                  },
                  labels: {
                      formatter: function() {
                          return this.value +'%'
                      }
                  }
              },
              tooltip: {
                  headerFormat: '<span style="font-size:10px">{point.key}</span><table width="100px">',
                  pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                      '<td style="padding:0"><b>{point.y:.1f}%</b></td></tr>',
                  footerFormat: '</table>',
                  shared: true,
                  useHTML: true
              }, 
              plotOptions: {
                  spline: {
                      marker: {
                          radius: 4,
                          lineColor: '#666666',
                          lineWidth: 1
                      }
                  }
              },
              credits: {
                  enabled: false
              },
              series: [{
                  name: '今年',
                  marker: {
                      symbol: 'square'
                  },
                  data:  getRandomData(50,100,12)
              }, {
                  name: '同期',
                  marker: {
                      symbol: 'diamond'
                  },
                  data:  getRandomData(50,100,12)
              }]
          });
          $('#company4').highcharts({
              chart: {
                  type: 'areaspline'
              },
              title: {
                  text: ''
              },
              legend: {
                  layout: 'vertical',
                  align: 'left',
                  verticalAlign: 'top',
                  x: 150,
                  y: 100,
                  floating: true,
                  borderWidth: 1,
                  backgroundColor: '#FFFFFF'
              },
              xAxis: {
                  categories: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
              },
              yAxis: {
                  max:100,
                  title: {
                      text: '完成比(%)'
                  },
                  labels: {
                      formatter: function() {
                          return this.value +'%'
                      }
                  }
              },
              tooltip: {
                  headerFormat: '<span style="font-size:10px">{point.key}</span><table width="100px">',
                  pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                      '<td style="padding:0"><b>{point.y:.1f}%</b></td></tr>',
                  footerFormat: '</table>',
                  shared: true,
                  useHTML: true
              }, 
              credits: {
                  enabled: false
              },
              plotOptions: {
                  areaspline: {
                      fillOpacity: 0.5
                  }
              },
              series: [{
                  name: '今年',
                  data:  getRandomData(50,100,12)
              }, {
                  name: '同期',
                  data:  getRandomData(50,100,12)
              }]
          });
      }
      /********公司整体end***********/
      
    $("#menu a").bind("mouseover",function(){
        $(this).css({"color":"#fff","background":"#2ec8e9"});
    }).bind("mouseout",function(){
        $(this).css({"color":"#8FAADC","background":"#DEEBF7"});
    }).bind("click",function(){
        $("#menu a").css({"color":"#8FAADC","background":"#DEEBF7"})
        $("#menu a").mouseover(function(){
            $(this).css({"color":"#fff","background":"#2ec8e9"});
        }).mouseout(function(){
            $(this).css({"color":"#8FAADC","background":"#DEEBF7"});
        });
        $(this).css({"color":"#fff","background":"#049ff1","font-weight":"bold"}).unbind("mouseover mouseout");;
    });
    $("#menu a:first").click();
  </script>
</html>
