function draw(context, workflowBase, p) {

	/*
	var canvas = $("#mainArea")[0];
	var _callBack = function() {
		draw();
	};
	if (canvas == null || canvas == undefined) {
		setTimeout(_callBack, 500);
		return;
	}
	var context = canvas.getContext("2d");
	*/
	for (var i = 0; i < workflowBase.nodeBases.length; i++) {
		var crtNode = workflowBase.nodeBases[i];
		drawNode(context, crtNode);
	}

	for (var i = 0; i < workflowBase.nodeLinks.length; i++) {
		drawLine(context, workflowBase.nodeLinks[i]);
	}

	for (var i = 0; i < workflowBase.groups.length; i++) {
		var g = workflowBase.groups[i];
		//alert(g.direction);
		//console.log(g);
		if (g.direction == 0) {
			//alert("x=" + g.x + ", y=" + g.y + ", width=" + g.width + ", height=" + g.height);
			dashRect(g.x, g.y, g.width, g.height, g.groupName, context);
		} else if (g.direction == 1) {
			drawBlock(0, g.x, g.y, maxWidth, g.height, g.groupName, context);
		} else if (g.direction == 2) {
			drawBlock(1, g.x, g.y, g.width, maxHeight, g.groupName, context);
		}
		//var maxWidth = 800;
		//var maxHeight = 600;
	}
}

/**
 * 初始化节点
 */
function drawNode(content, node) {
	if (node == null || node == undefined) {
		return;
	}
	if (node.nodetype == 0 || node.nodetype == 3) {
		var imgSrc = node.bgImage();
		loadImage(imgSrc, function() {
			content.drawImage(this, node.x, node.y);
			//console.log(content.isPointInPath(90, 90));
			content.fillStyle = node.fontColor();
			//console.log(content.isPointInPath(90, 90));
			drawText(content, node.text, 'normal 12px Microsoft YaHei', parseInt(node.x) + (113 - 70) / 2 - 10, parseInt(node.y) + 113 / 2 - 12, 70);
			//console.log(content.isPointInPath(90, 90));
			drawText(content, node.nodeOperatorName, 'normal 13px Microsoft YaHei', parseInt(node.x) + (113 - 70) / 2 - 10, parseInt(node.y) + 113 / 2 + 5, 70);
			//console.log(content.isPointInPath(90, 90));
			content.stroke();
			//console.log(content.isPointInPath(90, 90));
		});
	} else if (node.nodetype == 1) {
		if (node.nodeOptType == 1) {
			diamond(content, parseInt(node.x), parseInt(node.y), 110, 100, 5, "#BD9F82", "#F1AF0A", "#E59C07", "#A96F05", "/workflow/design/h5display/images/node_bg2_wev8.png", "/workflow/design/h5display/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		} else if (node.nodeOptType == 0) {
			diamond(content, parseInt(node.x), parseInt(node.y), 110, 100, 5, "#16A0CE", "#72D8F9", "#26B2E0", "#3A8DAA", "/workflow/design/h5display/images/node_bg3_wev8.png", "/workflow/design/h5display/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		} else {
			diamond(content, parseInt(node.x), parseInt(node.y), 110, 100, 5, "#367819", "#A2E087", "#7FBF64", "#367819", "/workflow/design/h5display/images/node_bg_wev8.png", "/workflow/design/h5display/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		}

	} else {
		if (node.nodeOptType == 1) {
			roundRect(content, parseInt(node.x + 2), parseInt(node.y), 108, 70, 5, "#BD9F82", "#F1AF0A", "#E59C07", "#A96F05", "/workflow/design/h5display/images/node_bg2_wev8.png", "/workflow/design/h5display/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		} else if (node.nodeOptType == 0) {
			roundRect(content, parseInt(node.x + 2), parseInt(node.y), 108, 70, 5, "#16A0CE", "#72D8F9", "#26B2E0", "#3A8DAA", "/workflow/design/h5display/images/node_bg3_wev8.png", "/workflow/design/h5display/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		} else {
			roundRect(content, parseInt(node.x + 2), parseInt(node.y), 108, 70, 5, "#367819", "#A2E087", "#7FBF64", "#367819", "/workflow/design/h5display/images/node_bg_wev8.png", "/workflow/design/h5display/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		}
	}
	this.fillStyle = "#ffffff";
	this.strokeStyle = "#000000";
	this.lineWidth = 1;
}

function drawLine(ctx, nl) {

	//console.log(nl);
	if (nl == null || nl == undefined || nl.points == null || nl.points == "") return;

	ctx.beginPath();

	ctx.lineWidth = 2;
	if (nl.ispass == "true" || nl.ispass == true) {
		ctx.strokeStyle = '#E90B0A';
	} else {
		ctx.strokeStyle = '#8c8c8c';
	}

	var pointAry = new Array();
	//var tempArray = nl.points.split(",");
	for (var i = 0; i < nl.points.length; i++) {
		var point = new Point(nl.points[i].x, nl.points[i].y);
		pointAry.push(point);

	}



	if (pointAry.length <= 0) return;
	ctx.moveTo(pointAry[0].x, pointAry[0].y);
	//记录划线的记录
	nl.pushDrawPoint(pointAry[0]);

	var sPoint = null;
	var ePoint = null;
	//console.log(nl.text + ":" + nl.points);
	var interval = 8;
	for (var i = 0; i < pointAry.length; i++) {
		var p = pointAry[i];

		if (i == 0) {
			if (parseInt(nl.startDirection) == 90) {
				//p.x += interval - 1;
				p.x = nl.startNode.leftPoint().x;
			} else if (parseInt(nl.startDirection) == 180) {
				//p.y += interval;
				p.y = nl.startNode.topPoint().y;
			} else if (parseInt(nl.startDirection) == -90) {
				//p.x -= interval;
				p.x = nl.startNode.rightPoint().x;
			} else if (parseInt(nl.startDirection) == 0) {
				//p.y -= interval;
				p.y = nl.startNode.bottomPoint().y;
			}
		}

		if (i == pointAry.length - 1) {
			if (parseInt(nl.endDirection) == 90) {
				//x += interval;
				p.x = nl.endNode.leftPoint().x;
			} else if (parseInt(nl.endDirection) == 180) {
				//p.y += interval;
				p.y = nl.endNode.topPoint().y;
			} else if (parseInt(nl.endDirection) == -90) {
				//p.x -= interval - 3;
				p.x = nl.endNode.rightPoint().x;
			} else if (parseInt(nl.endDirection) == 0) {
				//p.y -= interval;
				p.y = nl.endNode.bottomPoint().y;
			}
		}

		//记录划线的记录
		nl.pushDrawPoint(p);
		//如果不是最后一个点，即线的结尾节点 && 不是第一个节点
		if (sPoint != null && (i + 1) < pointAry.length) {
			ePoint = pointAry[i + 1];
			//如果3点不在一个坐标轴内，则画曲线
			if (!(sPoint.x == p.x && p.x == ePoint.x) && !(sPoint.y == p.y && p.y == ePoint.y)) {
				//console.log(nl.text + ":" + sPoint.toString() + ", " + p.toString() + "," + ePoint.toString());
				var aPoint = calCenterPoint(sPoint, p);
				var bPoint = calCenterPoint(ePoint, p);
				ctx.arcTo(p.x, p.y, bPoint.x, bPoint.y, 5);
				//ctx.lineTo(p.x, p.y);
			} else {
				ctx.lineTo(p.x, p.y);
			}
		} else {
			ctx.lineTo(p.x, p.y);
		}


		sPoint = p;
	}

	//nl.pushDrawPoint(ePoint);

	//画箭头 
	drawArrow(ctx, pointAry[pointAry.length - 2], pointAry[pointAry.length - 1]);
	ctx.closePath();
	ctx.stroke();
}

function drawGroup(ctx, g) {
	if (g == null || g == undefined) {


		return;
	}
}

function drawBlock(ctx, g) {

}