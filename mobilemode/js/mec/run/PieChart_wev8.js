if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.PieChart = {};

Mobile_NS.PieChart.onload = function(p){
	var theId = p["id"];
	this.build(p);
};

Mobile_NS.PieChart.build = function(p){
	var theId = p["id"];
	var sql = p["sql"];
	var multiLJson = p['multiLJson'];
	
	var url = "";
	var requestParam = null;
	var msgStyle = "color: #bbb;font-size: 14px;padding: 9px 5px 9px 22px;";
	var msg = "";
	var $chartContainer = $("#NMEC_" + theId).children("div");
	if($.trim(sql) == ""){
		msg = multiLJson['4205'];//图表信息设置不完整，未配置数据来源SQL
	}else{
		var _mode = p["_mode"];
		if(_mode == "0"){	//后台插件配置模式
			if(eval("/\\{(.*?)\\}/.test(sql)")){
				msg = multiLJson['4206'];//SQL中可能包含待解析的参数变量，需运行时显示
			}else{
				sql = $m_encrypt(sql);// 系统安全编码
				if(sql == ""){// 系统安全关键字验证不通过
					msg = multiLJson['4207'];//数据来源SQL未通过系统安全测试，请检查关键字
				}
			}
			url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAdminAction", "action=getDatasBySQL&datasource="+p["datasource"]+"&sql="+encodeURIComponent(sql));
			requestParam = null;
		}else{
			url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getDataForChart&mec_id="+theId);
			requestParam = Mobile_NS.pageParams;
		}
	}
	if(msg != ""){
		$chartContainer.html("<div style=\""+msgStyle+"\">"+msg+"</div>");
		return;
	}
	
	//var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getDataForChart&datasource="+datasource+"&sql="+sql);
	$.get(url, requestParam, function(responseText){
		var jObj = $.parseJSON(responseText);
		var status = jObj["status"];
		if(status == "0"){
			$chartContainer.html("<div style=\""+msgStyle+"\">"+multiLJson['4208']+"</div>");//查询数据来源SQL时出现错误，请检查SQL是否拼写正确
		}else if(status == "-1"){
			$chartContainer.html("<div style=\""+msgStyle+"\">"+multiLJson['4209']+"</div>");//加载图表时出现错误
		}else if(status == "1"){
			var datas = jObj["datas"];
			// 基于准备好的dom，初始化echarts实例
			var theChart = echarts.init($chartContainer[0]);
			
			var op_title_show = p["title"] != "" || p["subTitle"] != "";
			
			var op_legend_show = p["isShowLegend"] == "1";
			var op_legend_data = [];
			
			var op_series_label_show = p["isShowLabel"] == "1";
			var op_series_date = [];
			
			var labelFormat = p["labelFormat"];
			var _mode = p["_mode"];
			
			for(var i = 0; i < datas.length; i++){
				var da = datas[i];
				var d = {};
				
				var j = 0;
				for(var key in da){
					var value = da[key];
					if(j == 0){
						op_legend_data.push(value);
					}
					
					if(j == 0){
						d["name"] = value;
					}
					if(j == 1){
						d["value"] = value;
					}
					j++;
				}
				
				op_series_date.push(d);
			}
			var chartType = p["chartType"];
			var op_series_radius;
			var radiusMax = parseInt(p["radius"]);
			if(isNaN(radiusMax)){
				radiusMax = 55;
			}
			if(chartType == "1"){
				op_series_radius = ["0", radiusMax + "%"];
			}else{
				op_series_radius = [(radiusMax-15) + "%", radiusMax + "%"];
			}
			
			var labelPosition = p["labelPosition"] || "1";
			var labelFontSize = (p["labelFontSize"] == "" || isNaN(p["labelFontSize"])) ? 12 : Number(p["labelFontSize"]);
			var labelLineLength = (p["labelLineLength1"] == "" || isNaN(p["labelLineLength1"])) ? 5 : Number(p["labelLineLength1"]);
			var labelLineLength2 = (p["labelLineLength2"] == "" || isNaN(p["labelLineLength2"])) ? 10 : Number(p["labelLineLength2"]);
			
			var option = {
				title : {
					show : op_title_show,
			        text: p["title"],
			        subtext: p["subTitle"],
			        x: 'center',
		        	y: 0
			    },
			    tooltip : {
			        trigger: 'item',
			        formatter: function (datas) {
				    	var res = datas.name+ '：';
				    	var value = datas.value
						value = _mode == "0" ? formatNumber(value, labelFormat) : Mobile_NS.formatNumber(value, labelFormat);
						res += value + "(" + datas.percent +"%)";
					    return res;
			    	}
			        //formatter: "{b} : {c} ({d}%)"
			    },
			    legend: {
			    	show: op_legend_show,
			        data: op_legend_data, //['蒸发量','降水量'],
			        bottom: 'bottom'
			    },
			    series : [
		  	        {
	  		            type: 'pie',
	  		            radius: op_series_radius,
	  		            label: {
		  	                normal: {
		  	                    show: op_series_label_show,
		  	                    position: labelPosition == "2" ? 'inside' : 'outside',
		  	                    textStyle:{
		  	                    	fontSize:labelFontSize
		  	                    }
		  	                }
		  	            },
		  	            labelLine: {
		  	                normal: {
		  	                    show: op_series_label_show,
		  	                    length:labelLineLength,
			                    length2:labelLineLength2
		  	                }
		  	            },
	  		            data:op_series_date
	  		        }
	  		    ]
			};

			var color = p["color"];
			if(color){
				option.color = color.split(",");
			}
			
			// 使用刚指定的配置项和数据显示图表。
			theChart.setOption(option);
			
			var clickUrl = p["clickUrl"];
			if(clickUrl && p["_mode"] == "1"){
				theChart.on('click', function (params) {
					var ckUrl = clickUrl.replace(/\{_chart_name}/g, params.name).replace(/\{_chart_value}/g, params.value);
				    $u(ckUrl);
				});
			}
		}
	});
};

