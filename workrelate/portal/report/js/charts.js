/**
 * 获取颜色
 */
function getColor(num){
    var sysColors=['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4','#AFD8F8','#F6BD0E','#74A474','#DA89E1'] 
	var color = new Array();
	if(num == 1){
		color[0] = sysColors[5];
		color[1] = sysColors[6];
	}else if(num == 2){
        color[0] = sysColors[7];
        color[1] = sysColors[8];
    }else if(num == 3){
        color[0] = sysColors[3];
        color[1] = sysColors[4];
    }else if(num == 4){
        color[0] = sysColors[11];
        color[1] = sysColors[12];
    }
	return color;
}
function areaClick(){
    $('#allcontainer').children().hide();
    $('#areaContainer').show();
      
    $('#area1').html("");
    $('#area2').html("");
    $('#area3').html("");
    $('#area4').html("");
  
    showBar("area1","bar","",['西南大区', '华中大区', '苏皖大区', '浙闽大区', '北方大区', '上海大区'],getColor(1),
           getRandomData(50,100,6),getRandomData(50,100,6),"area1detail",['#058DC7','#70E1FF'],"areaspline");
    showBar("area2","column","",['西南大区', '华中大区', '苏皖大区', '浙闽大区', '北方大区', '上海大区'],getColor(2),
           getRandomData(50,100,6),getRandomData(50,100,6),"area2detail",['#74A474','#DA89E1'],["column","spline"]);
    showBar("area3","bar","",['西南大区', '华中大区', '苏皖大区', '浙闽大区', '北方大区', '上海大区'],getColor(3),
           getRandomData(50,100,6),getRandomData(50,100,6),"area3detail",['#1291A9','#D1F0EF'],"column");
    showBar("area4","column","",['西南大区', '华中大区', '苏皖大区', '浙闽大区', '北方大区', '上海大区'],getColor(4),
           getRandomData(50,100,6),getRandomData(50,100,6),"area4detail",['#43A102','#C5DA01'],"spline");
    showDetail("area1detail",'西南大区',56,getRandomData(50,100,12),getRandomData(50,100,12),['#058DC7','#70E1FF'],"areaspline");
    showDetail("area2detail",'西南大区',76,getRandomData(50,100,12),getRandomData(50,100,12),['#74A474','#DA89E1'],["column","spline"]);
    showDetail("area3detail",'西南大区',56,getRandomData(50,100,12),getRandomData(50,100,12),['#1291A9','#D1F0EF'],"column");
    showDetail("area4detail",'西南大区',36,getRandomData(50,100,12),getRandomData(50,100,12),['#43A102','#C5DA01'],"spline");
}
  /********部门对比***********/
function deptClick(){
    $('#allcontainer').children().hide();
    $('#deptContainer').show();
      
    $('#dept1').html("");
    $('#dept2').html("");
    $('#dept3').html("");
    $('#dept4').html("");
  
    showBar("dept1","bar","",['技术部', '产品部', '品质部', '行政部', '人事部', '财务部'],getColor(1),
           getRandomData(50,100,6),getRandomData(50,100,6),"dept1detail",['#049FF1','#70E1FF'],"areaspline");
    showBar("dept2","column","",['技术部', '产品部', '品质部', '行政部', '人事部', '财务部'],getColor(2),
           getRandomData(50,100,6),getRandomData(50,100,6),"dept2detail",['#6AF9C4','#D64646'],["column","spline"]);
    showBar("dept3","bar","",['技术部', '产品部', '品质部', '行政部', '人事部', '财务部'],getColor(3),
           getRandomData(50,100,6),getRandomData(50,100,6),"dept3detail",['#FCFC8A','#FFA500'],"column");
    showBar("dept4","column","",['技术部', '产品部', '品质部', '行政部', '人事部', '财务部'],getColor(4),
           getRandomData(50,100,6),getRandomData(50,100,6),"dept4detail",['#55A255','#F6BF1C'],"spline");
    showDetail("dept1detail",'技术部',56,getRandomData(50,100,12),getRandomData(50,100,12),['#049FF1','#70E1FF'],"areaspline");
    showDetail("dept2detail",'技术部',76,getRandomData(50,100,12),getRandomData(50,100,12),['#6AF9C4','#D64646'],["column","spline"]);
    showDetail("dept3detail",'技术部',56,getRandomData(50,100,12),getRandomData(50,100,12),['#FCFC8A','#FFA500'],"column");
    showDetail("dept4detail",'技术部',36,getRandomData(50,100,12),getRandomData(50,100,12),['#55A255','#F6BF1C'],"spline");
}
/********人员对比***********/
function hrmClick(){
    $('#allcontainer').children().hide();
    $('#hrmContainer').show();
      
    $('#hrm1').html("");
    $('#hrm2').html("");
    $('#hrm3').html("");
    $('#hrm4').html("");
  
    showBar("hrm1","bar","",['李波', '王龙', '罗峰', '石瑞', '张诚', '秦方'],getColor(1),
           getRandomData(50,100,6),getRandomData(50,100,6),"hrm1detail",['#058DC7', '#AFD8F8'],"areaspline");
    showBar("hrm2","column","",['李波', '王龙', '罗峰', '石瑞', '张诚', '秦方'],getColor(2),
           getRandomData(50,100,6),getRandomData(50,100,6),"hrm2detail",['#ED561B', '#DDDF00'],["column","spline"]);
    showBar("hrm3","bar","",['李波', '王龙', '罗峰', '石瑞', '张诚', '秦方'],getColor(3),
           getRandomData(50,100,6),getRandomData(50,100,6),"hrm3detail",['#24CBE5', '#64E572'],"column");
    showBar("hrm4","column","",['李波', '王龙', '罗峰', '石瑞', '张诚', '秦方'],getColor(4),
           getRandomData(50,100,6),getRandomData(50,100,6),"hrm4detail",['#FF9655', '#FFF263'],"spline");
    showDetail("hrm1detail",'李波',56,getRandomData(50,100,12),getRandomData(50,100,12),['#058DC7', '#AFD8F8'],"areaspline");
    showDetail("hrm2detail",'李波',76,getRandomData(50,100,12),getRandomData(50,100,12),['#ED561B', '#DDDF00'],["column","spline"]);
    showDetail("hrm3detail",'李波',56,getRandomData(50,100,12),getRandomData(50,100,12),['#24CBE5', '#64E572'],"column");
    showDetail("hrm4detail",'李波',36,getRandomData(50,100,12),getRandomData(50,100,12),['#FF9655', '#FFF263'],"spline");
}
    /**
     * 得到随机数据
     */
    function getRandomData(min,max,num){
        var data = new Array();
        for(var i=0; i<num; i++){
            data[i]=parseInt(Math.random()*(max-min)+min);
        }
        return data;
    }
  /**
   * 添加条形图
   */
  function showBar(id,type,title,gategories,sefColor,data1,data2,areadetail,color,chartType){
      $('#' + id).highcharts({
      chart: {type: type},                 
      title: {text: title}, 
      xAxis: {           
          categories: gategories
      },                 
      yAxis: {           
          min: 0,
		  max:100,
          title: {       
              text: '完成比(%)',                             
              align: 'high'                                              
          },             
          labels: {      
              overflow: 'justify'                                        
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
      colors:sefColor,
      plotOptions: {
          bar: {         
              dataLabels: {                                              
                  enabled: true                                          
              }          
          },
          series: {
              cursor: 'pointer',
              events: {
                  click: function(e) {
                      var category = e.point.category;
                      var y = e.point.y;
                      var data1 = getRandomData(50,100,12);
                      var data2 = getRandomData(50,100,12);
                      showDetail(areadetail,category,y,data1,data2,color,chartType);
                  }  
              }
          }
      },                 
      credits: { 
          enabled: false 
      },                 
      series: [{         
          name: '今年',
          data: data1 
      }, {               
          name: '同期',
              data: data2
          }]                 
      });
  }

/**
 * 显示子表信息
 */
function showDetail(obj,category,y,data1,data2,colors,chartType){
    if( typeof chartType == 'object'){
      $('#' + obj).highcharts({                                          
          chart: {
          },                
          title: {
              text: category
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
              type: chartType[0],                                               
              name: '今年', 
              data: data1
          }, {
              type: chartType[1],                                               
              name: '同期',                                              
              data: data2,
              marker: {     
                  lineWidth: 2,                                               
                  lineColor: Highcharts.getOptions().colors[3],               
                  fillColor: 'white'                                          
              }             
          }]                
      }); 
    }else{
      $('#' + obj).highcharts({
          chart: {type: chartType},
          title: {text: category},
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
              '<td style="padding:0"><b>{point.y:.1f} %</b></td></tr>',
              footerFormat: '</table>',
              shared: true,
              useHTML: true
          },
          credits: {
              enabled: false
          },
          colors:colors,
          plotOptions: {
              column: {
                  pointPadding: 0.2,
                  borderWidth: 0
              }
          },
          series: [{
              name: '今年',
              data: data1
        
          }, {
              name: '同期',
              data: data2
              }]
      });
    }
}
 