<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<% 
int height = Util.getIntValue(request.getParameter("height"),100);
%>
<!DOCTYPE html>
<html>
<head>	
<meta charset='utf-8'> 
<style type='text/css'> 
body {  
    overflow:hidden;  
} 
* { 
    font-size: 12px; 
    font-family: '微软雅黑'; 
} 
#tablecontainer{ 
    width: 100%; 
	height: 100%; 
	margin: 0 auto; 
} 

</style> 
</head>
<body>
<div id='tablecontainer'></div>
<script src='echarts.min.js'></script>
<script src='jquey.1.7.2.js'></script>
<script src='macarons.js'></script>
<script type='text/javascript'>

var sumList = [];
var statusList = [];

$(function () {

    $.ajax({
        type: "post",
        dataType: "json",
        url: "/govern/interfaces/governTaskAction.jsp?action=status",
        success: function (data) {
            sumList = data.sumList;
            statusList = data.statusList;
            initEchart(statusList,sumList);
        }
      });
    $("#tablecontainer").css("height" ,"<%=height%>px");
      
});

function  initEchart(statusList ,sumList){
    var myChart = echarts.init(document.getElementById('tablecontainer'),"macarons");
    var option = {
        color: ['#8EC9EB'],
        title : {
            text: '任务状态占比',
            subtext: '',
            x:'center'
        },
        tooltip: {
            trigger: 'axis',
            formatter: ""
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            axisLine: {onZero: false},
            axisLabel: {
                formatter: '{value}'
            },
            boundaryGap: true,
            data: statusList,
        },
        yAxis: {
            type: 'value',
            splitLine: {
                show: false
            },
            minInterval : 1,
            boundaryGap : [ 0, 0.1 ],
            axisLabel: {
                formatter: '{value}'
            }
        },
        graphic: [
            {
                type: 'image',
                id: 'logo',
                right: 20,
                top: 20,
                z: -10,
                bounding: 'raw',
                origin: [75, 75],
                style: {
                    image: '',
                    width: 150,
                    height: 150,
                    opacity: 0.4
                }
            },
            {
                type: 'group',
                rotation: Math.PI / 4,
                bounding: 'raw',
                right: 110,
                bottom: 110,
                z: 100,
                children: [
                    {
                        type: 'rect',
                        left: 'center',
                        top: 'center',
                        z: 100,
                        shape: {
                            width: 0,
                            height: 0
                        },
                        style: {
                            fill: 'rgba(0,0,0,0.3)'
                        }
                    },
                    {
                        type: 'text',
                        left: 'center',
                        top: 'center',
                        z: 100,
                        style: {
                            fill: '#fff',
                            text: '',
                            font: 'bold 26px Microsoft YaHei'
                        }
                    }
                ]
            },
        ],
        series: [
            {
                name: '',
                type: 'bar',
                smooth: true,
                barCategoryGap: 10,
                lineStyle: {
                    normal: {
                        width: 3,
                        shadowColor: 'rgba(0,0,0,0.4)',
                        shadowBlur: 10,
                        shadowOffsetY: 10
                    }
                },
                data:sumList
            }
        ]
    };

    myChart.setOption(option);

    var tablecontainer = document.getElementById('tablecontainer');  
    //用于使chart自适应高度和宽度,通过窗体高宽计算容器高宽
    var resizeTablecontainer = function () {
        tablecontainer.style.width = window.innerWidth+'px';
        tablecontainer.style.height = window.innerHeight+'px';
    };
    //设置容器高宽
    resizeTablecontainer();
    //用于使chart自适应高度和宽度
    window.onresize = function () {
        //重置容器高宽
        resizeTablecontainer();
        myChart.resize();
    };

}
</script>
</body>
</html> 