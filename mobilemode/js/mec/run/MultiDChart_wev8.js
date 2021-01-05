var _MEC_ChartWidth;
var chart_run_mode;

function BuildChartWhenDataGet(p, fn){
	var theId = p["id"];
	var $multiDChartContainer = $("#multiDChartContainer_" + theId);
	var tabSourceMaps = p["tabSourceMaps"];
	var multiLJson = p['multiLJson'];
	var checkFlag = true;
	if(typeof(tabSourceMaps) == "undefined" || tabSourceMaps.length == 0){
		var tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4205']+"</div>";//图表信息设置不完整，未配置数据来源SQL
		$multiDChartContainer.html(tipHtm);
		return;
	}else{
		var tipHtm;
		var name = "";
		var datasource = "";
		var datasql = "";
		for(var i = 0; tabSourceMaps && i < tabSourceMaps.length; i++){
		
			var tabSourceMap = tabSourceMaps[i];
			var sql = tabSourceMap["datasql"];
			
			if(tabSourceMap["tabName"] == ""){
				tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['5202']+"</div>";//数据来源(输入名称)不能为空
				$multiDChartContainer.html(tipHtm);
				checkFlag = !checkFlag;
				break;
			}
			if(sql == ""){
				tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4205']+"</div>";//图表信息设置不完整，未配置数据来源SQL
				$multiDChartContainer.html(tipHtm);
				checkFlag = !checkFlag;
				break;
			}else{
				if($m_encrypt(sql) == ""){// 系统安全关键字验证不通过
					tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4207']+"</div>";//数据来源SQL未通过系统安全测试，请检查关键字
					$multiDChartContainer.html(tipHtm);
					checkFlag = !checkFlag;
					break;
				}
			}
			if(chart_run_mode == 0 && eval("/\\{(.*?)\\}/.test(sql)")){
				tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4206']+"</div>";//SQL中可能包含待解析的参数变量，需运行时显示
				$multiDChartContainer.html(tipHtm);
				checkFlag = !checkFlag;
				break;
			}
			name += tabSourceMap["tabName"]+";";
			datasource += tabSourceMap["datasource"]+";";
			datasql += sql+";";
		}
		if(!checkFlag){
			return;
		}
		if(name != ""){
			name = name.substring(0,name.length-1);
		}
		if(datasource != ""){
			datasource = datasource.substring(0,datasource.length-1);
		}
		if(datasql != ""){
			datasql = datasql.substring(0,datasql.length-1);
		}
		var requestParam = {};
		requestParam["name"] = name;
		requestParam["datasource"] = datasource;
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getMultiDDataBySQLWithChart&datasql="+$m_encrypt(datasql));
	$.get(url, requestParam, function(responseText){
		var jObj = $.parseJSON(responseText);
		var status = jObj["status"];
		if(status == "0"){
			var tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4208']+"</div>";//查询数据来源SQL时出现错误，请检查SQL是否拼写正确
			$multiDChartContainer.html(tipHtm);
		}else if(status == "-1"){
			var tipHtm = "<div class=\"Design_Chart_Tip\">"+multiLJson['4209']+"</div>";//加载图表时出现错误
			$multiDChartContainer.html(tipHtm);
		}else if(status == "1"){
			var labels = jObj["labelName"];
			var datas = jObj["datas"];
			fn.call(this, labels, datas);
		}
	});
}

/**
 * 当超过手机窗口的最大高度和宽度时，需要进行缩放
 * @param {Object} width
 * @param {Object} height
 * @return {TypeName} 
 */
function getMaxSize(width,height,type){
	var maxWidth = $(window).width();
	var maxHeight = $(window).height();
	var w = 10;
	if(type&&type==2){
		maxWidth = $("#MEC_Design_Container").width();
		maxHeight = $("#MEC_Design_Container").height();
	}else{
		w =20;
	}
	
	var f1 = false;
	var f2 = false;
	if(width<=0){
		f1 = true;
	}
	if(height<=0){
		f2 = true;
	}
	if(!width){
		width = maxWidth;
	}
	if(!height){
		height = maxHeight;
	}
	
	//按照宽度等比例缩放
	if(width>maxWidth){
		var p = maxWidth/width;
		width = maxWidth;
		height = height*p;
	}
	//按照高度进行等比例缩放
	if(height>maxHeight){
		var p = maxHeight/height;
		height = maxHeight;
		width = width*p;
	}
	if(f1){
		width = maxWidth;
	}
	if(f2){
		height = "";
	}
	var result = new Object();
	result.width = width;
	result.height = height;
	return result;
}

function BuildChart_ColumnMulti3D(p){
	BuildChartWhenDataGet(p,function(labels, datas){
		var theId = p["id"];
		var chartWidth = p["width"] || _MEC_ChartWidth;
		var chartHeight = p["height"];
		if(typeof(chartHeight) == "undefined" || chartHeight == "" || parseFloat(chartHeight) <= 0){
			chartHeight = 350;
		}
		var resetWidth = chartWidth+10;
		var resetHeight = chartHeight-160;
		var chart = new iChart.ColumnMulti3D({
			render : 'multiDChartContainer_'+theId,
			data: datas,
			labels: labels,
			title : {
				text : p["title"],
				font : p["title_font"],
				color : p["title_color"],
				fontsize: p["title_fontsize"],
				fontweight : p["title_fontweight"]
			},
			width : chartWidth,
			height : chartHeight,
			background_color : null,
			animation : true,//开启过渡动画
			animation_duration:800,//800ms完成动画
			align:'center',
			turn_off_touchmove: true,
			radius: '90%',
			offsetx:10,
			legend:{
				enable:true,
				background_color : null,
				align : 'center',
				valign : 'bottom',
				legend_space:5,
				row:1,
				column:'max',
				offsety:-20,
				line_height:15,
				padding:'0 0 0 0',
				border : {
					enable : false
				}
			},
			column_width : 8,//柱形宽度
			zScale:8,//z轴深度倍数
			xAngle : 50,
			bottom_scale:1.1,
			label:{
				color:'#4c4f48'
			},
			sub_option:{
				label :false
			},
			tip:{
				enable :true
			},
			text_space : 16,//坐标系下方的label距离坐标系的距离。
			coordinate:{
				background_color : '#d7d7d5',
				grid_color : '#a4a4a2',
				color_factor : 0.24,
				board_deep:10,
				offsety:-20,
				pedestal_height:10,
				left_board:false,//取消左侧面板
				width:resetWidth,
				height:resetHeight,
				scale:[{
					 position:'left',	
					 start_scale:0,
					 end_scale:1000,
					 scale_space:200,
					 scale_enable : false,
					 label:{
						color:'#4c4f48'
					 }
				}]
			}
		});
		chart.draw();
	});
}