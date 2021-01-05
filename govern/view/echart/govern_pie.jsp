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

var categoryPieList = [];
var categoryList = [];

$(function () {

    $.ajax({
        type: "post",
        dataType: "json",
        url: "/govern/interfaces/governTaskAction.jsp?action=category",
        success: function (data) {           
            categoryPieList = data.categoryPieList;
            categoryList = data.categoryList;
            initEchart(categoryList,categoryPieList);
        }
      });
      $("#tablecontainer").css("height" ,"<%=height%>px");

});


function  initEchart(categoryList ,categoryPieList){
    var myChart = echarts.init(document.getElementById('tablecontainer'),"macarons");
    var option = {
        title : {
            text: '督办类型占比',
            subtext: '',
            x:'center'
        },
        tooltip : {
            trigger: 'item',
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },
        legend: {
            orient : 'vertical',
            x : 'left',
            data:categoryList,
            show: false, 
        },
        toolbox: {
            show : true,
            feature : {
                mark : {show: true},
                dataView : {show: false, readOnly: false},
                magicType : {
                    show: false, 
                    type: ['pie', 'funnel'],
                    option: {
                        funnel: {
                            x: '25%',
                            width: '50%',
                            funnelAlign: 'left',
                            max: 1548
                        }
                    }
                },
                restore : {show: false},
                saveAsImage : {show: false}
            }
        },
        calculable : true,
        series : [
            {
                name:'督办类型',
                type:'pie',
                radius : '55%',
                center: ['50%', '60%'],
                data:categoryPieList
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