function draw(workflowBase) {
	var canvas = $("#mainArea")[0];
	var _callBack = function () {
		draw();
	};
	if (canvas == null || canvas == undefined) {
		setTimeout(_callBack, 500);
		return ;
	} 
	var context = canvas.getContext("2d");	
	for (var i=0; i<workflowBase.nodeBases.length; i++) {
		var crtNode = workflowBase.nodeBases[i];
		drawNode(context, crtNode);
	}
	
	for (var i=0; i<workflowBase.nodeLinks.length; i++) {
		drawLine(context, workflowBase.nodeLinks[i]);
	}

	for (var i=0; i<workflowBase.groups.length; i++) {
		var g =  workflowBase.groups[i];
		//alert(g.direction);
		if (g.direction == 0) {
			//alert("x=" + g.x + ", y=" + g.y + ", width=" + g.width + ", height=" + g.height);
			dashRect(g.x, g.y, g.width, g.height, g.groupName, context);
		} else if (g.direction == 1) {
			drawBlock(0, g.x, g.y, g.width, g.height, g.groupName, context);
		} else if (g.direction == 2) {
			drawBlock(1, g.x, g.y, g.width, g.height, g.groupName, context);
		}
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
		loadImage(imgSrc, function(){
			content.drawImage(this, node.x, node.y);
			content.fillStyle = node.fontColor();
			drawText(content, node.text, 'normal 13px Microsoft YaHei', parseInt(node.x) + (113 - 70)/2 - 10, parseInt(node.y) + 113/2 - 12, 70);
			drawText(content, node.nodeOperatorName, 'normal 13px Microsoft YaHei', parseInt(node.x) + (113 - 70)/2 - 10, parseInt(node.y) + 113/2 + 5, 70);
			content.stroke();
		});
	} else if (node.nodetype == 1) {
		if (node.nodeOptType == 1) {
			diamond(content, parseInt(node.x), parseInt(node.y), 110, 100, 5, "#BD9F82", "#F1AF0A", "#E59C07" ,"#A96F05", "/mobile/plugin/1/design/images/node_bg2_wev8.png", "/mobile/plugin/1/design/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		} else if (node.nodeOptType == 0) {
			diamond(content, parseInt(node.x), parseInt(node.y), 110, 100, 5, "#16A0CE", "#72D8F9", "#26B2E0" ,"#3A8DAA", "/mobile/plugin/1/design/images/node_bg3_wev8.png", "/mobile/plugin/1/design/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		} else {
			diamond(content, parseInt(node.x), parseInt(node.y), 110, 100, 5, "#367819", "#A2E087", "#7FBF64", "#367819", "/mobile/plugin/1/design/images/node_bg_wev8.png", "/mobile/plugin/1/design/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		}
		
	} else {
		if (node.nodeOptType == 1) {
			roundRect(content, parseInt(node.x), parseInt(node.y), 110, 70, 5, "#BD9F82", "#F1AF0A", "#E59C07" ,"#A96F05", "/mobile/plugin/1/design/images/node_bg2_wev8.png", "/mobile/plugin/1/design/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		} else if (node.nodeOptType == 0) {
			roundRect(content, parseInt(node.x), parseInt(node.y), 110, 70, 5, "#16A0CE", "#72D8F9", "#26B2E0" ,"#3A8DAA", "/mobile/plugin/1/design/images/node_bg3_wev8.png", "/mobile/plugin/1/design/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		} else {
			roundRect(content, parseInt(node.x), parseInt(node.y), 110, 70, 5, "#367819", "#A2E087", "#7FBF64", "#367819", "/mobile/plugin/1/design/images/node_bg_wev8.png", "/mobile/plugin/1/design/images/line_wev8.png", node.text, node.nodeOperatorName, node.fontColor());
		}
	}
	this.fillStyle = "#ffffff";
    this.strokeStyle = "#000000";
    this.lineWidth = 1;
}

function drawLine(ctx, nl) {
	if (nl == null || nl == undefined || nl.points == null || nl.points == "") return;
	
	ctx.beginPath();
	
	ctx.lineWidth = 2; 
	if (nl.ispass == "true" || nl.ispass == true) {
		ctx.strokeStyle = '#E90B0A';
	} else {
		ctx.strokeStyle = '#8c8c8c'; 
	}
	
	var pointAry = new Array();
	var tempArray = nl.points.split(",");
	for (var i=0; i<tempArray.length; i+=2) {
		if (i + 1 < tempArray.length) {
			var point = new Point(tempArray[i], tempArray[i + 1]);
			pointAry.push(point);
		}
	}
	
	if (pointAry.length <= 0) return;
	ctx.moveTo(pointAry[0].x, pointAry[0].y);
	
	var sPoint = null;
	var ePoint = null;
	for (var i=0; i<pointAry.length; i++) {
		var p = pointAry[i];
		if (i == 0) {
			if (parseInt(nl.startDirection) == 90) {
				p.x += 10;
			} else if (parseInt(nl.startDirection) == 180) {
				p.y += 10;
			} else if (parseInt(nl.startDirection) == -90) {
				p.x -= 10;
			} else if (parseInt(nl.startDirection) == 0) {
				p.y -= 10;
			} 
		}
		
		if (i == pointAry.length - 1) {
			if (parseInt(nl.endDirection) == 90) {
				p.x += 10;
			} else if (parseInt(nl.endDirection) == 180) {
				p.y += 10;
			} else if (parseInt(nl.endDirection) == -90) {
				p.x -= 10;
			} else if (parseInt(nl.endDirection) == 0) {
				p.y -= 10;
			} 
		}
		
		//如果不是最后一个点，即线的结尾节点 && 不是第一个节点
		if (sPoint != null && (i+1) < pointAry.length) {
			ePoint = pointAry[i + 1];
			//如果3点不在一个坐标轴内，则画曲线
			if (!(sPoint.x == p.x && p.x == ePoint.x) 
				&& !(sPoint.y == p.y && p.y == ePoint.y)
			) {
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