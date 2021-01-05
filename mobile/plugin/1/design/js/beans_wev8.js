
var WorkflowBase = function () {
	this.nodeBases = new Array();
	this.nodeLinks = new Array();
	this.groups = new Array();
	
	this.getnNodeByNodeId = function (iid) {
		for ( var i= 0; i < this.nodeBases.length; i++) {
			var nb = this.nodeBases[i];
			if (nb.id == iid) {
				return nb;
			}
		}
		return null;
	};
	
};

var NodeBase = function () {
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
	this.nodeOperatorName = "";
	this.nodeViewNames = "";
	this.nodeOperatorNames = "";
	this.nodeNotOperatorNames = "";
	this.fontColor = function () {
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
	this.bgImage = function () {
		var imgSrc = "";
		if (this.nodetype == 0) {
			if (this.nodeOptType == 1) {
				imgSrc = "design/images/start2_wev8.png";
			} else if (this.nodeOptType == 0) {
				imgSrc = "design/images/start3_wev8.png";
			} else {
				imgSrc = "design/images/start_wev8.png";
			}
		} else {
			if (this.nodeOptType == 1) {
				imgSrc = "design/images/end2_wev8.png";
			} else if (this.nodeOptType == 0) {
				imgSrc = "design/images/end3_wev8.png";
			} else {
				imgSrc = "design/images/end_wev8.png";
			}
		}
		return imgSrc;
	}
	
	this.getWHPoint = function () {
		if (this.nodetype == 0 || this.nodetype == 3) {
			return new Point(113, 113);
		} else if (this.nodetype == 1) { 
			return new Point(110, 100);
		} else {
			return new Point(110, 70);
		}
	}
};

var NodeLink = function () {
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
};

var Group = function () {
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