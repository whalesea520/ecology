function initChart(title,items){
jQuery('#container').highcharts({
        title: {
            text: title,
            x: -20 //center
        },
        xAxis: {
           categories: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
        },
        yAxis: {
         		min: 0,
         		allowDecimals:false,
            title: {
                text: ''
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            valueSuffix: '人'
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        credits: {
              enabled: false
          },
      	legend:{
          	enabled: false
          },
        series: [{
            name: '人数',
            data: jQuery.parseJSON(items)
        }]
    });
}

function initChart1(title,items){
 $('#container1').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: title
        },
        xAxis: {
            categories: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
        },
        yAxis: {
         		min: 0,
         		allowDecimals:false,
            title: {
                text: ''
            }
        },
        tooltip: {
      			valueSuffix: '人'
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
      	legend:{
          	enabled: false
        },
        series: [{
            name: '人数',
            data: jQuery.parseJSON(items)

        }]
    });
}