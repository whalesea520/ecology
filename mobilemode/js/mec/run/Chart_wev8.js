var _MEC_ChartWidth;
var chart_run_mode;

function BuildChartWhenDataGet(p, fn){
	var theId = p["id"];
	var datasource = p["datasource"];
	var sql = p["sql"];
	var charttype = p["charttype"];
	var multiLJson = p['multiLJson'];
	
	var $ChartContainer = $("#ChartContainer_" + theId);
	if($.trim(sql) == ""){
		var tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4205']+"</div>";//图表信息设置不完整，未配置数据来源SQL
		$ChartContainer.html(tipHtm);
		return;
	}else{
		
		var tipHtm;
		if(chart_run_mode == 0 && eval("/\\{(.*?)\\}/.test(sql)")){
			tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4206']+"</div>";//SQL中可能包含待解析的参数变量，需运行时显示
			$ChartContainer.html(tipHtm);
			return;
		}
		
		sql = $m_encrypt(sql);// 系统安全编码
		if(sql == ""){// 系统安全关键字验证不通过
			tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4207']+"</div>";//数据来源SQL未通过系统安全测试，请检查关键字
			$ChartContainer.html(tipHtm);
			return;
		}
		
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getDataBySQLWithChart&datasource="+datasource+"&sql="+encodeURIComponent(sql)+"&charttype="+charttype);
	$.get(url, null, function(responseText){
		var jObj = $.parseJSON(responseText);
		var status = jObj["status"];
		if(status == "0"){
			var tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4208']+"</div>";//查询数据来源SQL时出现错误，请检查SQL是否拼写正确
			$ChartContainer.html(tipHtm);
		}else if(status == "-1"){
			var tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4209']+"</div>";//加载图表时出现错误
			$ChartContainer.html(tipHtm);
		}else if(status == "1"){
			var datas = jObj["datas"];
			fn.call(this, datas);
		}
	});
}

function BuildChart_Column2D(p){
	
	BuildChartWhenDataGet(p, function(datas){
		var theId = p["id"];
		var labelFormat = p["labelFormat"];
		
		new iChart.Column2D({
			render : 'ChartContainer_'+theId,
			data: datas,
			title : {
				text : p["title"],
				font : p["title_font"],
				color : p["title_color"],
				fontsize: p["title_fontsize"],
				fontweight : p["title_fontweight"]
			},
			animation : true,//开启过渡动画
			animation_duration:800,//800ms完成动画
			height : p["height"],
			width : p["width"] || _MEC_ChartWidth,
			align:'center',
			border: false,
			background_color: null,
			turn_off_touchmove: true,
			sub_option : {
				label:{
					color:'#111111'
				},
				listeners : {
					parseText : function(r, t) {
						return chart_run_mode == "0" ? formatNumber(t, labelFormat) : Mobile_NS.formatNumber(t, labelFormat);
					}
				}
			},
			coordinate:{
				background_color:'#fefefe',
				scale:[{
					 position:'left'	
					 /*
					 ,listeners:{
						parseText:function(t,x,y){
							return {text:t+p["valuesuffix"]}
						}
					}*/
				}]
			}
		}).draw();
		
	});
}

function BuildChart_Column3D(p){
	
	BuildChartWhenDataGet(p, function(datas){
		var theId = p["id"];
		var labelFormat = p["labelFormat"];
		
		new iChart.Column3D({
			render : 'ChartContainer_'+theId,
			data: datas,
			title : {
				text : p["title"],
				font : p["title_font"],
				color : p["title_color"],
				fontsize: p["title_fontsize"],
				fontweight : p["title_fontweight"]
			},
			animation : true,//开启过渡动画
			animation_duration:800,//800ms完成动画
			width : p["width"] || _MEC_ChartWidth,
			height : p["height"],
			align:'center',
			border: false,
			background_color: null,
			turn_off_touchmove: true,
			sub_option:{
				label:{
					color:'#111111'
				},
				listeners : {
					parseText : function(r, t) {
						return chart_run_mode == "0" ? formatNumber(t, labelFormat) : Mobile_NS.formatNumber(t, labelFormat);
					}
				}
			},
			coordinate:{
				scale:[{
					 position:'left'
				}]
			}
		}).draw();
	});
}

function BuildChart_Pie2D(p){
	
	BuildChartWhenDataGet(p, function(datas){
		var theId = p["id"];
		var labelFormat = p["labelFormat"];
		
		new iChart.Pie2D({
			render : 'ChartContainer_'+theId,
			data: datas,
			title : {
				text : p["title"],
				font : p["title_font"],
				color : p["title_color"],
				fontsize: p["title_fontsize"],
				fontweight : p["title_fontweight"]
			},
			animation : true,//开启过渡动画
			animation_duration:800,//800ms完成动画
			width : p["width"] || _MEC_ChartWidth,
			height : p["height"],
			align:'center',
			border: false,
			background_color: null,
			radius:'90%',
			turn_off_touchmove: true,
			sub_option:{
				listeners : {
					parseText : function(r, t) {
						var varr = t.split(/\s+/);
						var res = varr[0] + "：";
						res += chart_run_mode == "0" ? formatNumber(varr[1], labelFormat) : Mobile_NS.formatNumber(varr[1], labelFormat);
						return res;
					}
				},
				label : {
					background_color:null,
					sign:false,//设置禁用label的小图标
					padding:'0 4',
					border:{
						enable:false,
						color:'#666666'
					},
					fontsize:11,
					fontweight:600,
					color : '#4572a7'
				}
			}
		}).draw();
	});
}

function BuildChart_Pie3D(p){
	
	BuildChartWhenDataGet(p, function(datas){
		var theId = p["id"];
		var labelFormat = p["labelFormat"];
		
		new iChart.Pie3D({
			render : 'ChartContainer_'+theId,
			data: datas,
			title : {
				text : p["title"],
				font : p["title_font"],
				color : p["title_color"],
				fontsize: p["title_fontsize"],
				fontweight : p["title_fontweight"]
			},
			animation : true,//开启过渡动画
			animation_duration:800,//800ms完成动画
			width : p["width"] || _MEC_ChartWidth,
			height : p["height"],
			align:'center',
			border: false,
			background_color: null,
			radius:'90%',
			turn_off_touchmove: true,
			sub_option:{
				listeners : {
					parseText : function(r, t) {
						var varr = t.split(/\s+/);
						var res = varr[0] + "：";
						res += chart_run_mode == "0" ? formatNumber(varr[1], labelFormat) : Mobile_NS.formatNumber(varr[1], labelFormat);
						return res;
					}
				},
				label : {
					background_color:null,
					sign:false,//设置禁用label的小图标
					padding:'0 4',
					border:{
						enable:false,
						color:'#666666'
					},
					fontsize:11,
					fontweight:600,
					color : '#4572a7'
				}
			}
		}).draw();
	});
};

function BuildChart_Donut2D(p){
	
	BuildChartWhenDataGet(p, function(datas){
		var theId = p["id"];
		var labelFormat = p["labelFormat"];
		
		new iChart.Donut2D({
			render : 'ChartContainer_'+theId,
			data: datas,
			title : {
				text : p["title"],
				font : p["title_font"],
				color : p["title_color"],
				fontsize: p["title_fontsize"],
				fontweight : p["title_fontweight"]
			},
			sub_option : {
				listeners : {
					parseText : function(r, t) {
						var varr = t.split(/\s+/);
						var res = varr[0] + "：";
						res += chart_run_mode == "0" ? formatNumber(varr[1], labelFormat) : Mobile_NS.formatNumber(varr[1], labelFormat);
						return res;
					}
				},
				label : {
					background_color:null,
					sign:false,//设置禁用label的小图标
					padding:'0 4',
					border:{
						enable:false,
						color:'#666666'
					},
					fontsize:11,
					fontweight:600,
					color : '#4572a7'
				}
			},
			background_color: null,
			animation : true,//开启过渡动画
			animation_duration:800,//800ms完成动画
			width : p["width"] || _MEC_ChartWidth,
			height : p["height"],
			align:'center',
			border: false,
			turn_off_touchmove: true,
			radius: '90%'
		}).draw();
	});
}

function BuildChart_Line2D(p){
	BuildChartWhenDataGet(p, function(datas){
		var theId = p["id"];
		var labelFormat = p["labelFormat"];
		
		var flow = [];
		var labels = [];
		for(var i=0; i<datas.length; i++){
			labels.push(datas[i].name);
			flow.push(datas[i].value);
		}
		
		var data = [
			{
				name : "line",
				value : flow,
				color:p["linecolor"],
			    line_width:2
			}
		];
		
		var chart = new iChart.LineBasic2D({
			render : 'ChartContainer_'+theId,
			data: data,
			labels:labels,
			title : {
				text : p["title"],
				font : p["title_font"],
				color : p["title_color"],
				fontsize: p["title_fontsize"],
				fontweight : p["title_fontweight"]
			},sub_option : {
				hollow_inside:false,
				point_size:10,
				listeners : {
					parseText : function(r, t) {
						return chart_run_mode == "0" ? formatNumber(t, labelFormat) : Mobile_NS.formatNumber(t, labelFormat);
					}
				},
				label : {
					background_color:null,
					sign:false,//设置禁用label的小图标
					padding:'0 4',
					border:{
						enable:false,
						color:'#666666'
					},
					fontsize:11,
					fontweight:600,
					color : '#4572a7'
				}
			},
			width : p["width"] || _MEC_ChartWidth,
			height : p["height"],
			background_color: null,
			animation : true,//开启过渡动画
			animation_duration:800,//800ms完成动画
			align:'center',
			border: false,
			turn_off_touchmove: true,
			radius: '90%'
		});
		chart.draw();
	});
}

function BuildChart_Area2D(p){
	BuildChartWhenDataGet(p, function(datas){
		var theId = p["id"];
		var labelFormat = p["labelFormat"];
		
		var flow = [];
		var labels = [];
		for(var i=0; i<datas.length; i++){
			labels.push(datas[i].name);
			flow.push(datas[i].value);
		}
		
		var data = [
			{
				name : "line",
				value : flow,
				color:p["linecolor"],
			    line_width:2
			}
		];
		
		var chart = new iChart.Area2D({
			render : 'ChartContainer_'+theId,
			data: data,
			labels:labels,
			title : {
				text : p["title"],
				font : p["title_font"],
				color : p["title_color"],
				fontsize: p["title_fontsize"],
				fontweight : p["title_fontweight"]
			},sub_option : {
				hollow_inside:false,
				point_size:10,
				listeners : {
					parseText : function(r, t) {
						return chart_run_mode == "0" ? formatNumber(t, labelFormat) : Mobile_NS.formatNumber(t, labelFormat);
					}
				},
				label : {
					background_color:null,
					sign:false,//设置禁用label的小图标
					padding:'0 4',
					border:{
						enable:false,
						color:'#666666'
					},
					fontsize:11,
					fontweight:600,
					color : '#4572a7'
				}
			},
			width : p["width"] || _MEC_ChartWidth,
			height : p["height"],
			background_color: null,
			animation : true,//开启过渡动画
			animation_duration:800,//800ms完成动画
			align:'center',
			border: false,
			turn_off_touchmove: true,
			radius: '90%'
		});
		chart.draw();
	});
}