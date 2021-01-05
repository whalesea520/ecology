var WorkflowBase = function() {
	this.workflowid = 0;
	this.nodeBases = new Array();
	this.nodeLinks = new Array();
	this.groups = new Array();

	this.getnNodeByNodeId = function(iid) {
		for (var i = 0; i < this.nodeBases.length; i++) {
			var nb = this.nodeBases[i];
			if (nb.id == iid) {
				return nb;
			}
		}
		return null;
	};

};

var NodeBase = function() {
	this.id = -1;
	this.text = "";
	this.isNew = false;
	this.nodetype = 0;
	this.nodeattribute = 0;
	this.passNum = 0;
	this.mustPassStep = 0;
	this.shapetype = 0;
	this.width = 0;
	this.height = 0;
	this.x = 0;
	this.y = 0;
	this.zIndex = 0;
	this.nodeOptType = 0;
	this.nodeOperatorName = '';
	this.nodeViewNames = [];
	this.nodeOperatorNames = [];
	this.nodeNotOperatorNames = [];
	this.opetators = '';
	this.viewers = '';
	this.notOperators = '';

	this.width = 0;
	this.height = 0;
	this.points = [];
	this.requestid = 0;
	this.getPoints = function() {
		if (this.nodetype != 1) {
			return [];
		}

		if (this.points.length > 0)
			return this.points;
		/*
		var leftPoint = new Point(0 + this.x, this.height / 2 + this.y);
		var topPoint = new Point(this.width / 2 + this.x, 0 + y);
		var rightPoint = new Point(this.width + this.x, this.height / 2 + this.y);
		var bottomPoint = new Point(this.width / 2 + this.x, this.height + this.y);

		ctx.moveTo(leftPoint.x + 4, leftPoint.y + 3);
		ctx.bezierCurveTo(leftPoint.x + 4, leftPoint.y + 3, leftPoint.x, leftPoint.y, leftPoint.x + 4, leftPoint.y - 3);
		ctx.lineTo(topPoint.x - 4, topPoint.y + 3);
		ctx.bezierCurveTo(topPoint.x - 4, topPoint.y + 3, topPoint.x, topPoint.y, topPoint.x + 4, topPoint.y + 3);
		ctx.lineTo(rightPoint.x - 4, rightPoint.y - 3)
		ctx.bezierCurveTo(rightPoint.x - 4, rightPoint.y - 3, rightPoint.x, rightPoint.y, rightPoint.x - 4, rightPoint.y + 3);
		ctx.lineTo(bottomPoint.x + 4, bottomPoint.y - 3);
		ctx.bezierCurveTo(bottomPoint.x + 4, bottomPoint.y - 3, bottomPoint.x, bottomPoint.y, bottomPoint.x - 4, bottomPoint.y - 3);
		*/
		this.points.push({
			x: this.x - 4,
			y: this.height / 2 + this.y + 3
		});
		this.points.push({
			x: this.width / 2 + this.x,
			y: this.y - 3
		});
		this.points.push({
			x: this.width + this.x - 4,
			y: this.height / 2 + this.y - 3
		});
		this.points.push({
			x: this.width / 2 + this.x - 4,
			y: this.height + this.y + 3
		});
		return this.points;
	}

	this.fontColor = function() {
		var color = "";
		if (this.nodeOptType == 1) {
			color = "#ffffff";
		} else if (this.nodeOptType == 0) {
			color = "#ffffff";
		} else {
			color = "#ffffff";
		}

		return color;
	};
	this.bgImage = function() {
		var imgSrc = "";
		if (this.nodetype == 0) {
			if (this.nodeOptType == 1) {
				imgSrc = "/workflow/design/h5display/images/start2_wev8.png";
			} else if (this.nodeOptType == 0) {
				imgSrc = "/workflow/design/h5display/images/start3_wev8.png";
			} else {
				imgSrc = "/workflow/design/h5display/images/start_wev8.png";
			}
		} else {
			if (this.nodeOptType == 1) {
				imgSrc = "/workflow/design/h5display/images/end2_wev8.png";
			} else if (this.nodeOptType == 0) {
				imgSrc = "/workflow/design/h5display/images/end3_wev8.png";
			} else {
				imgSrc = "/workflow/design/h5display/images/end_wev8.png";
			}
		}
		return imgSrc;
	}

	this.getWHPoint = function() {
		if (this.nodetype == 0 || this.nodetype == 3) {
			this.width = 93;
			this.height = 93;
			return new Point(93, 93);
		} else if (this.nodetype == 1) {
			this.width = 110;
			this.height = 100;
			return new Point(110, 100);
		} else {
			this.width = 112;
			this.height = 72;
			return new Point(112, 72);
		}
	}

	this.getOperators = function() {
		if (this.opetators === '') {
			this.opetators = this.makeOperatorDisplayHtml(this.nodeOperatorNames);
		}
		return this.opetators;
	}

	this.getViewers = function() {
		if (this.viewers === '') {
			this.viewers = this.makeOperatorDisplayHtml(this.nodeViewNames);
		}

		return this.viewers;
	}

	this.getNotOperators = function() {
		if (this.notOperators === '') {
			this.notOperators = this.makeOperatorDisplayHtml(this.nodeNotOperatorNames);
		}
		return this.notOperators;
	}

	this.makeOperatorDisplayHtml = function(opeators) {
		var operatorDisplayHtml = '';
		for (var i = 0; i < opeators.length; i++) {
			var showhtml = '';
			var opetatorinfo = opeators[i];
			if (opetatorinfo.type === 0) {
				showhtml = '<a href="javaScript:openhrm(' + opetatorinfo.id + ');" onclick="pointerXY(event);">' + opetatorinfo.name + '</a>';
				if (opetatorinfo.hasAgent) {
					var agentOperatorInfo = opetatorinfo.agent;
					showhtml += ' -> ';
					showhtml += '<a href="javaScript:openhrm(' + agentOperatorInfo.id + ');" onclick="pointerXY(event);">' + agentOperatorInfo.name + '</a>';
				}
			} else if (opetatorinfo.type === 2) {
				showhtml = '<a href="/CRM/data/ViewCustomer.jsp?CustomerID=' + opetatorinfo.id + '&requestid="' + this.requestid + '" target="_blank">' + opetatorinfo.name + '</a>';
			} else {
				showhtml = '<a href="/workflow/workflow/editoperatorgroup.jsp?isview=1&id=' + opetatorinfo.id + '" target="_blank">' + opetatorinfo.name + '</a>';
			}
			operatorDisplayHtml += showhtml + '&nbsp;';
		}
		//console.log(operatorDisplayHtml);
		return operatorDisplayHtml;
	}

	this.getInterval4Node = function(r) {
		var interval4Node = 2;
		if (this.nodetype == 0 || this.nodetype == 3) {

		} else if (this.nodetype == 1) {

		} else {
			interval4Node = 2;
			if (r === 2) {
				interval4Node = 4;
			}
		}
		return interval4Node;
	}

	this.leftPoint = function() {
		this.getWHPoint();
		var point = new Point(this.x - this.getInterval4Node(1), this.y + this.height / 2);

		if (this.nodetype === 1) {

		}

		return point;
	}

	this.topPoint = function() {
		this.getWHPoint();
		var point = new Point(this.x + this.width / 2, this.y - this.getInterval4Node(2));
		return point;
	}

	this.rightPoint = function() {
		this.getWHPoint();
		var point = new Point(this.x + this.width + this.getInterval4Node(3), this.y + this.height / 2);
		return point;
	}
	this.bottomPoint = function() {
		this.getWHPoint();
		var point = new Point(this.x + this.width / 2, this.y + this.height + this.getInterval4Node(4));
		return point;
	}
};

var NodeLink = function() {
	this.id = 0;
	this.text = "";
	this.isNew = false;
	this.from = 0;
	this.to = 0;
	this.remindMsg = "";
	this.isBuildCode = false;
	this.isreject = false;
	this.ismustpass = 0;
	this.directionfrom = 0;
	this.directionto = 0;
	this.startDirection = -90;
	this.endDirection = 90;
	this.points = "";
	this.shapetype = "";
	this.zIndex = 0;
	this.fromRelX = 0;
	this.fromRelY = 0;
	this.toRelX = 0;
	this.toRelY = 0;
	this.hasRole = false;
	this.hasCondition = false;
	this.ispass = false;
	this.drawPoints = [];
	this.conditoncn = '';
	this.startNode = null;
	this.endNode = null;
	this.xFrom = 0;
	this.xTo = 0;
	this.yFrom = 0;
	this.yTo = 0;

};
NodeLink.prototype.pushDrawPoint = function(p) {
	//console.log(this.text, p);
	if (this.drawPoints.length === 0) {
		this.drawPoints.push(p);
		return;
	}

	var lastPoint = this.drawPoints[this.drawPoints.length - 1];
	if (lastPoint.x != p.x || lastPoint.y != p.y) {
		this.drawPoints.push(p);
	}
}

var Group = function() {
	this.id = 0;
	this.workflowid = 0;
	this.groupName = "";
	this.direction = 0;
	this.x = 0;
	this.y = 0;
	this.width = 0;
	this.height = 0;
	this.isNew = false;;
};

var Point = function(x, y) {
	this.x = parseInt(x);
	this.y = parseInt(y);
}
Point.prototype.toString = function() {
	return "[x:" + this.x + ", y:" + this.y + "]";
};