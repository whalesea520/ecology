var _MEC_ChartWidth;
function BuildChartWhenDataGet(p, fn){
	var theId = p["id"];
	var datasource = p["datasource"];
	var sql = p["sql"];
	var charttype = p["charttype"];
	
	var $ChartContainer = $("#ChartContainer_" + theId);
	if($.trim(sql) == ""){
		var tipHtm = "<div class=\"Design_Chart_Tip\">图表信息设置不完整，未配置数据来源SQL</div>";
		$ChartContainer.html(tipHtm);
		return;
	}
	
	sql = encodeURIComponent(sql);
	var url = "/weaver/com.weaver.formmodel.mobile.mec.servlet.MECAction?action=getDataBySQLWithChart&datasource="+datasource+"&sql="+sql+"&charttype="+charttype;
	$.post(url, null, function(responseText){
		var jObj = $.parseJSON(responseText);
		var status = jObj["status"];
		if(status == "0"){
			var tipHtm = "<div class=\"Design_Chart_Tip\">查询数据来源SQL时出现错误，请检查SQL是否拼写正确</div>";
			$ChartContainer.html(tipHtm);
		}else if(status == "-1"){
			var tipHtm = "<div class=\"Design_Chart_Tip\">加载图表时出现错误</div>";
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
			width : _MEC_ChartWidth,
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
						return t + p["valuesuffix"];
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
			width : _MEC_ChartWidth,
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
						return t + p["valuesuffix"];
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
			width : _MEC_ChartWidth,
			height : p["height"],
			align:'center',
			border: false,
			background_color: null,
			radius:'90%',
			turn_off_touchmove: true,
			sub_option:{
				listeners : {
					parseText : function(r, t) {
						return t + p["valuesuffix"];
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
			width : _MEC_ChartWidth,
			height : p["height"],
			align:'center',
			border: false,
			background_color: null,
			radius:'90%',
			turn_off_touchmove: true,
			sub_option:{
				listeners : {
					parseText : function(r, t) {
						return t + p["valuesuffix"];
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
						return t + p["valuesuffix"];
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
			width : _MEC_ChartWidth,
			height : p["height"],
			align:'center',
			border: false,
			turn_off_touchmove: true,
			radius: '90%'
		}).draw();
	});
}