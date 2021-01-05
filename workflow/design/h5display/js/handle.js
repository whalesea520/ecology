var maxWidth = 800;
var maxHeight = 600;
var widthViewPage = maxWidth;
var getCanvasHtml = function(workflowBase) {
	var nodebases = workflowBase.nodeBases;

	for (var i = 0; i < nodebases.length; i++) {
		var crtNode = nodebases[i];
		if (crtNode.x + 150 > maxWidth) {
			maxWidth = crtNode.x + 150;
		}
		if (crtNode.y + 150 > maxHeight) {
			maxHeight = crtNode.y + 150;
		}
	}

	for (var i = 0; i < workflowBase.groups.length; i++) {
		var g = workflowBase.groups[i];
		if (g.direction == 0) {
			if (g.x + g.width > maxWidth) {
				maxWidth = g.x + g.width;
			}
			if (g.y + g.height > maxHeight) {
				maxHeight = g.y + g.height;
			}
		} else if (g.direction == 1) {
			if (g.y + g.height > maxHeight) {
				maxHeight = g.y + g.height;
			}
		} else if (g.direction == 2) {
			if (g.x + g.width > maxWidth) {
				maxWidth = g.x + g.width;
			}
		}
	}
	//maxWidth += 50;

	if (maxWidth < $(document.body).width()) {
		maxWidth = $(document.body).width() - 3;
	}

	if (maxHeight < $(document.body).height()) {
		maxHeight = $(document.body).height() - 3;
	}

	//console.log($(document.body).height(), $(document.body).width());
	return '<canvas id="mainArea" width="' + maxWidth + 'px" height="' + maxHeight + 'px" style="background:#ffffff;" >您的浏览器不支持HTML5 CANCAL元素</canvas>';
}

var canvasHandle = function(canvas, workflowBase) {
	canvas.addEventListener('click', function(e) {
		popup(e, '', workflowBase);
	});

	$(canvas).mousemove(function(e) {

		showConditioncn(e, workflowBase);

	});


	$(window).resize(function() {
		if (!$('#dialog-box').is(':hidden')) popup();
	});

	$(document.body).bind("click", function() {
		$("#dialog-box, #dialog-overlay").css("display", "none");
		//e.stopPropagation();
	});

	$('#dialog-box').bind('click', function(e) {
		if (e.stopPropagation)
			e.stopPropagation();
		else
			e.cancelBubble = true;
	});
}



function popup(e, message, workflowBase) {
	if (jQuery("#dialog-box, #dialog-overlay").css("display") != "none") {
		return;
	}

	var ev = e ? e : event;
	var position = getPointerPosition(ev);

	var interY = 0; //$("#titleBlock").height();
	var message = isClickNode(new Point(position.left, position.top - interY), workflowBase.nodeBases)
	if (message == "") {
		return;
	}

	var maskHeight = $(document).height();
	var maskWidth = $(window).width();
	var dialogTop = position.top;
	var dialogLeft = position.left;

	$('#dialog-box').css({
		top: dialogTop,
		left: dialogLeft
	}).show();
	$('#dialog-message').html(message);
	e.stopPropagation();
}

function getPointerPosition(e) {
	var obj = e.currentTarget || document.activeElement;
	var position = {
		left: e.pageX || (e.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)),
		top: e.pageY || (e.clientY + (document.documentElement.scrollTop || document.body.scrollTop))
	};
	return position;
}

function isClickNode(oldPoint, nodebases) {

	for (var i = 0; i < nodebases.length; i++) {
		//console.log(nodebases[i].nodetype);
		if (nodebases[i].nodetype === 1) {
			if (windingNumber(oldPoint, nodebases[i].getPoints())) {
				messageInfoControl(false);
				return getShowMessage(nodebases[i]);
			}
			continue;
		}
		var x = nodebases[i].x;
		var y = nodebases[i].y;
		var w = nodebases[i].getWHPoint().x;
		var h = nodebases[i].getWHPoint().y;
		if (oldPoint.x >= x && oldPoint.x <= x + w && oldPoint.y >= y && oldPoint.y <= y + h) {
			messageInfoControl(false);
			return getShowMessage(nodebases[i]);
		}
	}
	return "";
}

function getShowMessage(nodebase) {
	var rhtml = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
	if (nodebase.nodeOptType == 1) {
		rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
		rhtml += "<img src=\"/workflow/design/h5display/images/imgPersonHead_wev8.png\" title=\"" + operatorMsg + "\">";
		rhtml += "&nbsp;" + nodebase.getNotOperators();
		rhtml += "</td></tr>";

		rhtml += '<tr><td style="height:10px;"></td></tr>'

		rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
		rhtml += "<img src=\"/workflow/design/h5display/images/icon_resource_wev8.png\" title=\"" + viewerMsg + "\">";
		rhtml += "&nbsp;" + nodebase.getViewers();
		rhtml += "</td></tr>";
		rhtml += '<tr><td style="height:10px;"></td></tr>'
		rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
		rhtml += "<img src=\"/workflow/design/h5display/images/iconemp_wev8.png\" title=\"" + operatorMsg + "\">";
		rhtml += "&nbsp;" + nodebase.getOperators();
		rhtml += "</td></tr>";
	} else if (nodebase.nodeOptType == 0) {
		rhtml += '<tr><td style="height:10px;"></td></tr>';
		rhtml += "<tr><td style='word-break : break-all; overflow:hidden;'>";
		rhtml += "<img src=\"/workflow/design/h5display/images/iconemp_wev8.png\" title=\"" + operatorMsg + "\">";
		rhtml += "&nbsp;" + nodebase.getOperators();
		rhtml += "</td></tr>";
		rhtml += '<tr><td style="height:10px;"></td></tr>';
	} else if (nodebase.nodeOptType == 2) {
		rhtml += '<tr><td style="height:10px;"></td></tr>';
		rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
		rhtml += "<img src=\"/workflow/design/h5display/images/imgPersonHead_wev8.png\" title=\"" + operatorMsg + "\" >";
		rhtml += "&nbsp;" + nodebase.getOperators();
		rhtml += "</td></tr>";
		rhtml += '<tr><td style="height:10px;"></td></tr>';
	}
	rhtml += "</table>";
	return rhtml;
}

function showConditioncn(e, workflowBase) {
	var ev = e ? e : event;
	var position = getPointerPosition(ev);
	var p = {
		x: position.left,
		y: position.top
	};
	clearTimeout(timeoutObj);

	//console.log(p)
	for (var i = 0; i < workflowBase.nodeLinks.length; i++) {
		var nl = workflowBase.nodeLinks[i];
		//console.log(nl.drawPoints, nl.points, nl.text);
		for (var j = 0; j < nl.drawPoints.length - 1; j++) {
			var ispointOnSegment = ptOnLine(nl.drawPoints[j].x, nl.drawPoints[j].y, nl.drawPoints[j + 1].x, nl.drawPoints[j + 1].y, p.x, p.y);
			//console.log(isPointOnSegment(p, nl.drawPoints[j], nl.drawPoints[j + 1]));
			if (ispointOnSegment) {
				//console.log(nl.conditoncn);
				if (nl.conditoncn != '') {
					messageInfoControl(true, nl.conditoncn, p);
					return;
				}
				//console.log('point ：' + nl.text);
				timeoutObj = setTimeout(function() {
					//显示出口信息
					var ajaxUrl = '/workflow/design/wfQueryConditions.jsp?nodelinkid=' + nl.id + '&workflowid=' + workflowBase.workflowid;
					jQuery.ajax({
						url: ajaxUrl,
						dataType: "text",
						contentType: "charset=UTF-8",
						cache: false,
						error: function(ajaxrequest) {},
						success: function(data) {
							//alert(data);
							var msg = nl.text;

							if (jQuery.trim(data) != '') {
								msg += '[' + jQuery.trim(data) + ']';
							}
							nl.conditoncn = msg;
							messageInfoControl(true, msg, p);
						}
					});

				}, 500);
				return;
			}
		}
	}

	var nodebases = workflowBase.nodeBases;
	for (var i = 0; i < nodebases.length; i++) {
		//console.log(nodebases[i].nodetype);
		var x = nodebases[i].x;
		var y = nodebases[i].y;
		var w = nodebases[i].getWHPoint().x;
		var h = nodebases[i].getWHPoint().y;

		if (p.x >= x + 20 && p.x <= x + w - 20 && p.y >= y + h / 2 - 20 && p.y <= y + h / 2) {
			messageInfoControl(true, nodebases[i].text, p);
			return;
		}

		if (p.x >= x + 20 && p.x <= x + w - 20 && p.y >= y + h / 2 && p.y <= y + h / 2 + 20) {
			messageInfoControl(true, nodebases[i].nodeOperatorName, p);
			return;
		}
	}
	messageInfoControl(false);
}

function messageInfoControl(isshow, msg, p) {
	//console.log(isshow, msg, p);
	if (isshow) {

		if ($("#tipdiv").is(':visible')) {
			if ($("#tipContent").html() === msg) {
				//console.log($("#tipdiv").is(':visible'), $("#tipdiv").is(':hidden'));
				return;
			}
		}
		$("#tipContent").html(msg);
		//console.log($("#tipdiv").height(), $("#tipdiv").width())
		$("#tipdiv").css({
			top: p.y + 20,
			left: p.x + 10
		});
		$("#tipdiv").show();
	} else {
		$("#tipContent").html('');
		$("#tipdiv").hide();
	}
}

var offsetVal = 5;

/** 
 * 判断鼠标的点是否在线段上 
 * @param p1x 
 * @param p1y 
 * @param p2x 
 * @param p2y 
 * @param x 
 * @param y 
 * @return 
 */
function onSegment(p1x, p1y, p2x, p2y, x, y) {
	if (x >= min(p1x, p2x) && x <= max(p1x, p2x) && y >= min(p1y, p2y) && y <= max(p1y, p2y))
		return true;
	else
		return false;
}

/** 
 * 判断两点的最小值 
 * @param x1 
 * @param x2 
 * @return 
 */
function min(x1, x2) {
	if (x1 > x2)
		return x2 - offsetVal;
	else
		return x1 - offsetVal;
}
/** 
 * 判断连点的最大值 
 * @param x1 
 * @param x2 
 * @return 
 */
function max(x1, x2) {
	if (x1 < x2)
		return x2 + offsetVal;
	else
		return x1 + offsetVal;
}

/** 
 * 计算点到直线的距离 
 * @param x1 线段上的一个端点 
 * @param y1 
 * @param x2 线段上的一个端点 
 * @param y2 
 * @param x3 待测点 
 * @param y3 
 * @return 
 */
function ptOnLine(x1, y1, x2, y2,
	x3, y3) {
	if (!onSegment(x1, y1, x2, y2, x3,
			y3))
		return false;
	var distance = (Math.sqrt(quadratic(x2, x3) + quadratic(y2, y3)) + Math
		.sqrt(quadratic(x1, x3) + quadratic(y1, y3)));
	var p2pDist = Math.sqrt(quadratic(x2, x1) + quadratic(y2, y1));
	//console.log(distance - p2pDist);
	if (distance - p2pDist < 1 * offsetVal && distance - p2pDist > -1 * offsetVal)
		return true;
	else
		return false;
}

function quadratic(x, y) {
	return (y - x) * (y - x);
}

/**
 * @description 回转数法判断点是否在多边形内部
 * @param {Object} p 待判断的点，格式：{ x: X坐标, y: Y坐标 }
 * @param {Array} poly 多边形顶点，数组成员的格式同 p
 * @return {String} 点 p 和多边形 poly 的几何关系
 */
function windingNumber(p, poly) {
	var px = p.x,
		py = p.y,
		sum = 0
		//console.log(p, poly);
	for (var i = 0, l = poly.length, j = l - 1; i < l; j = i, i++) {
		var sx = poly[i].x,
			sy = poly[i].y,
			tx = poly[j].x,
			ty = poly[j].y

		// 点与多边形顶点重合或在多边形的边上
		if ((sx - px) * (px - tx) >= 0 && (sy - py) * (py - ty) >= 0 && (px - sx) * (ty - sy) === (py - sy) * (tx - sx)) {
			return 'on'
		}

		// 点与相邻顶点连线的夹角
		var angle = Math.atan2(sy - py, sx - px) - Math.atan2(ty - py, tx - px)

		// 确保夹角不超出取值范围（-π 到 π）
		if (angle >= Math.PI) {
			angle = angle - Math.PI * 2
		} else if (angle <= -Math.PI) {
			angle = angle + Math.PI * 2
		}

		sum += angle
	}
	//console.log(Math.round(sum / Math.PI), p, poly);
	// 计算回转数并判断点和多边形的几何关系
	//return Math.round(sum / Math.PI) === 0 ? 'out' : 'in'
	return Math.round(sum / Math.PI) != 0;
}

function hideLoadding() {
	$('#submitloaddingdiv_out').hide();
	$('#submitloaddingdiv').hide();
}