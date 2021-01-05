function BuildChart2WhenDataGet(p, isruntime, fn){
	var theId = p["id"];
	var datasource = p["datasource"];
	var sql = p["sql"];
	var charttype = p["charttype"];
	var multiLJson = p['multiLJson'];
	var $chart2Container = $("#NMEC_" + theId);
	if($.trim(sql) == ""){
		var tipHtm = "<div class=\"Design_Chart2_Tip\">"+multiLJson['4205']+"</div>";//图表信息设置不完整，未配置数据来源SQL
		$chart2Container.html(tipHtm);
		return;
	}else{
		var regexp = /\{(.*)\}/;
		if(!isruntime && regexp.test(sql)){
			var tipHtm = "<div class=\"Design_Chart2_Tip\">"+multiLJson['4206']+"</div>";//SQL中可能包含待解析的参数变量，需运行时显示
			$chart2Container.html(tipHtm);
			return;
		}
		sql = $m_encrypt(sql);
		if(sql == ""){
			var tipHtm = "<div class=\"Design_Chart2_Tip\">"+multiLJson['4207']+"</div>";//数据来源SQL未通过系统安全测试，请检查关键字
			$chart2Container.html(tipHtm);
			return;
		}
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getDataBySQLWithChart2&datasource="+datasource+"&sql="+encodeURIComponent(sql)+"&charttype="+charttype);
	$.get(url, null, function(data){
		var jObj = $.parseJSON(data);
		var status = jObj["status"];
		if(status == "0"){
			var tipHtm = "<div class=\"Design_Chart2_Tip\">"+multiLJson['4208']+"</div>";//查询数据来源SQL时出现错误，请检查SQL是否拼写正确
			$chart2Container.html(tipHtm);
		}else if(status == "-1"){
			var tipHtm = "<div class=\"Design_Chart2_Tip\">"+multiLJson['4209']+"</div>";//加载图表时出现错误
			$chart2Container.html(tipHtm);
		}else if(status == "1"){
			if(isIE()){
				var tipHtm = "<div class=\"Design_Chart2_Tip\">"+multiLJson['5201']+"</div>";//此插件不支持IE浏览器，请换其他浏览器预览(chrome, safari)
				$chart2Container.html(tipHtm);
				return;
			}
			var datas = jObj["datas"];
			fn.call(this, datas);
		}
	});
	
}

function isIE(){
	var ua = navigator.userAgent;
	if(/MSIE ([^;]+)/.test(ua)){
		return true;
	}else{
		return false;
	}
}

function BuildChart2_LineGraph(p, runtime){
	initHtmlContent(p);
	BuildChart2WhenDataGet(p, runtime, function(datas){
		var theId = p["id"];
		var linesize = p["linesize"] == "" ? "1.5" : p["linesize"];
		drawGrid("#chart_" + theId);
		drawLineGraph("#chart_" + theId, datas, "#container_" + theId, theId, linesize);
	});
}

function BuildChart2_Circle(p, runtime){
	initHtmlContent(p);
	BuildChart2WhenDataGet(p, runtime, function(datas){
		var theId    = p["id"];
		var count    = datas["count"];
		var item     = datas["item"];
		var	value    = parseInt(item*100/count);
		var linesize = p["linesize"] == "" ? "5" : p["linesize"];
		drawCircle('#chart_' + theId, value, "#container_" + theId, theId, linesize);
	});
}

function initHtmlContent(p){
	var theId           = p["id"];
	var $chartContainer = $("#NMEC_" + theId);
	var charttype       = p["charttype"];
	var width           = p["width"];
	var height          = p["height"] == "" ? 175 : p["height"];
	var style           = "width:" + width + "px;height:" + height + "px;";
	var lineGradient    = p["line_gradient"];
	var shadowGradient  = p["shadow_gradient"];
	
	if(charttype == "LineGraph"){
		var contentHtml = "<div class=\"charts-container\" id=\"container_" + theId + "\" >";
				contentHtml += "<svg class=\"chart-line\" id=\"chart_" + theId + "\" style=\"${style};\" viewBox=\"0 0 80 40\">";
					contentHtml += "<linearGradient id=\"gradient_" + theId + "\">";
					if(lineGradient.length == 0){
						contentHtml += "<stop offset=\"0\" stop-color=\"#954ce9\" />";
						contentHtml += "<stop offset=\"1\" stop-color=\"#24c1ed\" />";
					}else{
						for(var i = 0; i < lineGradient.length; i++){
							item = lineGradient[i];
							contentHtml += "<stop offset=\"" + item["offset"] + "\" stop-color=\"" + item["stop-color"] + "\" />";
						}
					}
					contentHtml += "</linearGradient>";
					contentHtml += "<linearGradient id=\"gradient2_" + theId + "\" x1=\"0%\" y1=\"0%\" x2=\"0%\" y2=\"100%\">"
					if(shadowGradient.length == 0){
						contentHtml += "<stop offset=\"0\" stop-color=\"rgba(149, 76, 233, 1)\" stop-opacity=\"0.07\"/>"
						contentHtml += "<stop offset=\"0.5\" stop-color=\"rgba(149, 76, 233, 1)\" stop-opacity=\"0.13\"/>"
						contentHtml += "<stop offset=\"1\" stop-color=\"rgba(149, 76, 233, 1)\" stop-opacity=\"0\"/>"
					}else{
						for(var i = 0; i < shadowGradient.length; i++){
							item = shadowGradient[i];
							contentHtml += "<stop offset=\"" + item["offset"] + "\" stop-color=\"" + item["stop-color"] + "\"  stop-opacity=\"" + item["stop-opacity"] + "\"/>";
						}
					}
					contentHtml += "</linearGradient>"
				contentHtml += "</svg>"
			contentHtml += "</div>";
	}else{
		var linebgcolor     = p["linebgcolor"] == "" ? "#24303a" : p["linebgcolor"];
		var linesize        = p["linesize"] == "" ? "5" : p["linesize"];
		var title_font      = p["title_font"];
		var title_color     = p["title_color"];
		var title_fontsize  = p["title_fontsize"];
		var title_fontweight= p["title_fontweight"];
		var titleStyle = "font-family:" + title_font + ";color:" + title_color + ";font-size:" + title_fontsize + "px;font-weight:" + title_fontweight + ";";
		
		var contentHtml = "<div class=\"charts-container\" id=\"container_"+theId+"\">";
				contentHtml += "<h2 class=\"circle-percentage\" style=\"" + titleStyle + "\"></h2>";
				contentHtml += "<svg class=\"chart-circle\" id=\"chart_" + theId + "\" width=\"60%\" style=\"${style}\" viewBox=\"0 0 100 100\">";
					contentHtml += "<linearGradient id=\"gradient_" + theId + "\">";
					if(lineGradient.length == 0){
						contentHtml += "<stop offset=\"0\" stop-color=\"#954ce9\" />";
						contentHtml += "<stop offset=\"100\" stop-color=\"#24c1ed\" />";
					}else{
						for(var i = 0; i < lineGradient.length; i++){
							item = lineGradient[i];
							contentHtml += "<stop offset=\"" + item["offset"] + "\" stop-color=\"" + item["stop-color"] + "\" />";
						}
					}
					contentHtml += "</linearGradient>";
					contentHtml += "<path class=\"underlay\" style=\"stroke: " + linebgcolor + ";stroke-width:"+linesize+"\" d=\"M5,50 A45,45,0 1 1 95,50 A45,45,0 1 1 5,50\"/>";
				contentHtml += "</svg>";
			contentHtml += "</div>";
	}
	contentHtml = contentHtml.replace("${style}", style);
	$chartContainer.append(contentHtml);
}

/**
 * 画网格
 * @param graph
 */
function drawGrid(graph) {
	var stepX = 77 / 14;
	var graph = Snap(graph);
	var g = graph.g();
	g.attr('id', 'grid');
	for (i = 0; i <= stepX + 2; i++) {
		var horizontalLine = graph.path("M" + 0 + "," + stepX * i + " " + "L"
				+ 77 + "," + stepX * i);
		horizontalLine.attr('class', 'horizontal');
		g.add(horizontalLine);
	}
	;
	for (i = 0; i <= 14; i++) {
		var horizontalLine = graph.path("M" + stepX * i + "," + 38.7 + " "
				+ "L" + stepX * i + "," + 0)
		horizontalLine.attr('class', 'vertical');
		g.add(horizontalLine);
	}
}

function drawLineGraph(graph, points, container, mecId, linesize) {
	
	var graph = Snap(graph);

	/* PARSE POINTS */
	var myPoints = [];
	var shadowPoints = [];

	function point(x, y) {
		x: 0;
		y: 0;
	}

	function parseData(points) {
		var maxPoint = 0;
		for(var j = 0; j < points.length; j++){
			if(points[j] > maxPoint){
				maxPoint = points[j];
			}
		}
		maxPoint = maxPoint / 0.8;
		for (i = 0; i < points.length; i++) {
			var p = new point();
			var pv = points[i] / maxPoint * 38.7;
			p.x = 83.7 / points.length * i + 1;
			p.y = 38.7 - pv;
			if (p.x > 78) {
				p.x = 78;
			}
			myPoints.push(p);
		}
	}

	var segments = [];

	function createSegments(p_array) {
		for (i = 0; i < p_array.length; i++) {
			var seg = "L" + p_array[i].x + "," + p_array[i].y;
			if (i === 0) {
				seg = "M" + p_array[i].x + "," + p_array[i].y;
			}
			segments.push(seg);
		}
	}

	function joinLine(segments_array) {
		var line = segments_array.join(" ");
		var line = graph.path(line);
		line.attr('class', 'lineGraph');
		var lineLength = line.getTotalLength();
		var url = 'url(#gradient_' + mecId + ')';
		line.attr({
			'stroke-dasharray'  : lineLength,
			'stroke-dashoffset' : lineLength,
			'stroke-width'      : linesize,
			'stroke'            : url
		});
	}

	function calculatePercentage(points, graph) {
		var initValue = points[0];
		var endValue = points[points.length - 1];
		var sum = endValue - initValue;
		var prefix;
		var percentageGain;
		var stepCount = 1300 / sum;

		function findPrefix() {
			if (sum > 0) {
				prefix = "+";
			} else {
				prefix = "";
			}
		}

		var percentagePrefix = "";

		function percentageChange() {
			percentageGain = initValue / endValue * 100;

			if (percentageGain > 100) {
				percentageGain = Math.round(percentageGain * 100 * 10) / 100;
			} else if (percentageGain < 100) {
				percentageGain = Math.round(percentageGain * 10) / 10;
			}
			if (initValue > endValue) {

				percentageGain = endValue / initValue * 100 - 100;
				percentageGain = percentageGain.toFixed(2);

				percentagePrefix = "";
				$(graph).find('.percentage-value').addClass('negative');
			} else {
				percentagePrefix = "+";
			}
			if (endValue > initValue) {
				percentageGain = endValue / initValue * 100;
				percentageGain = Math.round(percentageGain);
			}
		}
		;
		percentageChange();
		findPrefix();

		var percentage = $(graph).find('.percentage-value');
		var totalGain = $(graph).find('.total-gain');
		var hVal = $(graph).find('.h-value');

		function count(graph, sum) {
			var totalGain = $(graph).find('.total-gain');
			var i = 0;
			var time = 1300;
			var intervalTime = Math.abs(time / sum);
			var timerID = 0;
			if (sum > 0) {
				var timerID = setInterval(function() {
					i++;
					totalGain.text(percentagePrefix + i);
					if (i === sum)
						clearInterval(timerID);
				}, intervalTime);
			} else if (sum < 0) {
				var timerID = setInterval(function() {
					i--;
					totalGain.text(percentagePrefix + i);
					if (i === sum)
						clearInterval(timerID);
				}, intervalTime);
			}
		}
		count(graph, sum);

		percentage.text(percentagePrefix + percentageGain + "%");
		totalGain.text("0%");
		setTimeout(function() {
			percentage.addClass('visible');
			hVal.addClass('visible');
		}, 1300);

	}

	function showValues() {
		var val1 = $(graph).find('.h-value');
		var val2 = $(graph).find('.percentage-value');
		val1.addClass('visible');
		val2.addClass('visible');
	}

	function drawPolygon(segments) {
		var lastel = segments[segments.length - 1];
		var polySeg = segments.slice();
		polySeg.push([ 78, 38.4 ], [ 1, 38.4 ]);
		var polyLine = polySeg.join(' ').toString();
		var replacedString = polyLine.replace(/L/g, '').replace(/M/g, "");
		var url = 'url(#gradient2_' + mecId + ')';
		var poly = graph.polygon(replacedString);
		var clip = graph.rect(-80, 0, 80, 40);
		poly.attr({
			/*'clipPath':'url(#clip)'*/
			'clipPath' : clip,
			'fill' : url
		});
		clip.animate({
			transform : 't80,0'
		}, 1300, mina.linear);
	}

	parseData(points);

	createSegments(myPoints);
	calculatePercentage(points, container);
	joinLine(segments);
	drawPolygon(segments);
}

function drawCircle(container, progress, parent, mecId, linesize) {
	if(progress == 0){
		progress = 1;
	}
	var paper = Snap(container);
	var prog = paper.path("M5,50 A45,45,0 1 1 95,50 A45,45,0 1 1 5,50");
	var lineL = prog.getTotalLength();
	var url = 'url(#gradient_' + mecId + ')';
	var oneUnit = lineL / 100;
	var toOffset = lineL - oneUnit * progress;
	var className = 'circleGraph';
	prog.attr({
		'stroke'           : url,
		'stroke-dashoffset': lineL,
		'stroke-dasharray' : lineL,
		'stroke-width'     : linesize,
		'class'            : className
	});

	var animTime = 1300/*progress / 100*/

	prog.animate({
		'stroke-dashoffset' : toOffset
	}, animTime, mina.easein);

	function countCircle(animtime, parent, progress) {
		var textContainer = $(parent).find('.circle-percentage');
		var i = 0;
		var time = 1300;
		var intervalTime = Math.abs(time / progress);
		var timerID = setInterval(function() {
			i++;
			textContainer.text(i + "%");
			if (i === progress)
				clearInterval(timerID);
		}, intervalTime);
	}
	countCircle(animTime, parent, progress);
}