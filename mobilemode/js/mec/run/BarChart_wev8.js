if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.BarChart = {};

Mobile_NS.BarChart.onload = function(p){
	var theId = p["id"];
	this.build(p);
};

Mobile_NS.BarChart.build = function(p){
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
			
			var op_category_data = [];
			
			var op_series_meta = [];
			
			for(var i = 0; i < datas.length; i++){
				var da = datas[i];
				
				var j = 0;
				for(var key in da){
					var value = da[key];
					if(i == 0 && j > 0){
						op_legend_data.push(key);
					}
					if(j == 0){
						op_category_data.push(value);
					}
					if(j > 0){
						var op_series_one = op_series_meta[j - 1];
						if(!op_series_one){
							op_series_one = {};
							op_series_meta[j - 1] = op_series_one;
						}
						if(i == 0){
							op_series_one["name"] = key;
						}
						var op_series_one_data = op_series_one["data"];
						if(!op_series_one_data){
							op_series_one_data = [];
							op_series_one["data"] = op_series_one_data;
						}
						op_series_one_data.push(value);
					}
					j++;
				}
			}
			
			var op_markPoint_show = p["isShowMarkPoint"] == "1";
			var op_markLine_show = p["isShowMarkLine"] == "1";
			
			var labelFormat = p["labelFormat"];
			var _mode = p["_mode"];
		
			var op_series = [];
			for(var i = 0; i < op_series_meta.length; i++){
				var op_series_one = {
			            name: op_series_meta[i]["name"],
			            type: 'bar',
			            data: op_series_meta[i]["data"]
				};
				if(op_markPoint_show){
					op_series_one.markPoint = {
		                data : [
		                    {type : 'max', name: multiLJson['4611']},//最大值
		                    {type : 'min', name: multiLJson['4610']}//最小值
			            ],
		                symbolSize : function(value, params){
		                	var l = value.toString().length;
		                	var result = l * 10;
		                	if(result < 50){
		                		result = 50;
		                	}
		                	return result;
		                },
		                 itemStyle: {
				                normal: {
				                    label: {
				                        show: true,
				                        formatter:function(obj){
						                    	var value = obj['value'];
						                        value = _mode == "0" ? formatNumber(value, labelFormat) : Mobile_NS.formatNumber(value, labelFormat);
						                        return value;
						                        }
				                        	}
		                				}
		                }
		            };
				}
				if(op_markLine_show){
					op_series_one.markLine = {
		                data : [
		                    {type : 'average', name: multiLJson['5200']}//平均值
		                ],
		                itemStyle: {
				              normal: {
				                  label: {
				                      show: true,
				                      formatter:function(obj){
						                   var value = obj['value'];
						                   value = _mode == "0" ? formatNumber(value, labelFormat) : Mobile_NS.formatNumber(value, labelFormat);
						                   return value;
						                   }
				                        }
		                			}
		                }
					};
				}

				op_series.push(op_series_one);
			}
			
			var chartType = p["chartType"];
			
			var axisLabelInterval = p["axisLabelInterval"] == "1" ? 0 : 'auto';
			var axisLabelRotate = (p["axisLabelRotate"] == "" || isNaN(p["axisLabelRotate"])) ? 0 : Number(p["axisLabelRotate"]);
			var axisLabelFontSize = (p["axisLabelFontSize"] == "" || isNaN(p["axisLabelFontSize"])) ? 12 : Number(p["axisLabelFontSize"]);
			
			var axisLabel = {
					interval : axisLabelInterval,
					rotate	 : axisLabelRotate,
					textStyle: {
						fontSize : axisLabelFontSize
					}
			};
			
			
			var categoryAxis = [{
						            type : 'category',
						            data : op_category_data,
						            axisLabel : axisLabel
						       }];
			var valueAxis = [{
						            type : 'value'
						    }];
			var grid = {};
			var gridleft = p['gridleft'];
			if(gridleft){
				grid.left = gridleft;
			}
			var gridright = p['gridright'];
			if(gridright){
				grid.right = gridright;
			}
			//在最大和最小柱状上显示具体的数值时调整标题高度
			if(op_markPoint_show){
				grid.top = 80;
			}
			
			if(!op_title_show){
				grid.top = 30;
			}
			var option = {
				title : {
					show : op_title_show,
			        text: p["title"],
			        subtext: p["subTitle"],
			        x: 'center',
		        	y: 0
			    },
			    tooltip : {
			        trigger: 'axis',
					formatter: function (datas) {
				    	var res = "";
				    	if(datas.componentType == "markLine"){
				    		res += datas.seriesName+ '<br/>';
				    		res += datas.name+ '：';
				    		var value = datas.value
						    value = _mode == "0" ? formatNumber(value, labelFormat) : Mobile_NS.formatNumber(value, labelFormat);
						    res += value;
				    	}else{
					        res = datas[0].name + '<br/>';
					        for (var i = 0, length = datas.length; i < length; i++) {
					           res += datas[i].seriesName + '：';
					           var value = datas[i].value
					           value = _mode == "0" ? formatNumber(value, labelFormat) : Mobile_NS.formatNumber(value, labelFormat);
							   res += value + '<br/>';
					         }
					     }
					         return res;
			    	}
			    },
			    grid : grid,
			    legend: {
			    	show: op_legend_show,
			        data: op_legend_data, //['蒸发量','降水量'],
			        bottom : 0
			    },
			    calculable : true,
			    xAxis : (chartType == "1") ? categoryAxis : valueAxis,
			    yAxis : (chartType == "1") ? valueAxis : categoryAxis,
			    series : op_series
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
					var ckUrl = clickUrl.replace(/\{_chart_name}/g, params.name).replace(/\{_chart_seriesName}/g, params.seriesName).replace(/\{_chart_value}/g, params.value);
				    $u(ckUrl);
				});
			}
		}
	});
};

