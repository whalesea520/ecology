var DataParse = function() {
	this.parse = function(data) {
		var workflowBase = new WorkflowBase();
		workflowBase.workflowid = data.workflowid;
		//xml = "<xml>" + xml + "</xml>";
		$(data.nodes).each(function() {
			//var $bpxml = $(this).children('BaseProperties');
			//var $vmlpxml = $(this).children('VMLProperties');
			var node = new NodeBase();

			node.id = this.id;
			node.text = this.name;
			//node.procType = $bpxml.attr("procType");
			node.nodetype = this.nodeType; //$bpxml.attr("nodetype");
			//node.nodeattribute = this.nodeAttrbute; //$vmlpxml.attr("nodeattribute");
			//node.passNum = $bpxml.attr("passNum");
			node.nodeOptType = this.status; //$bpxml.attr("optType");
			node.nodeOperatorName = this.operator; // $bpxml.attr("nodeOperatorName");
			try {
				var operatorArray = this.operator.split('->');
				if (operatorArray.length > 1) {
					node.nodeOperatorName = operatorArray[0].split("_#WFSPSTR_OPTTP#_")[2];
					node.nodeOperatorName = '->';
					node.nodeOperatorName += operatorArray[1].split("_#WFSPSTR_OPTTP#_")[2];
				} else {
					//qc326887 
					if(node.nodeOperatorName.split("_#WFSPSTR_OPTTP#_").length>2){
						node.nodeOperatorName = node.nodeOperatorName.split("_#WFSPSTR_OPTTP#_")[2];
					}			
				}
			} catch (e) {}

			node.nodeOperatorNames = this.operators; //$bpxml.attr("nodeOperatorNames");
			node.nodeViewNames = this.viewers; //$bpxml.attr("nodeViewNames");
			node.nodeNotOperatorNames = this.notOperators; //$bpxml.attr("nodeNotOperatorNames");

			if (node.nodeNotOperatorNames == "" || node.nodeNotOperatorNames == null) {
				node.nodeNotOperatorNames = node.nodeOperatorName;
			}
			node.shapetype = this.shapeType; //$vmlpxml.attr("shapetype");
			node.width = this.width; //$vmlpxml.attr("width");
			node.height = this.height; //$vmlpxml.attr("height");
			node.x = this.point.x - 48; // parseInt($vmlpxml.attr("x")) - 48 + 60;
			node.y = this.point.y - 30; // parseInt($vmlpxml.attr("y")) - 30 + 40;
			node.zIndex = this.zIndex; //$vmlpxml.attr("zIndex");
			workflowBase.nodeBases.push(node);
		});
		var newLineCount = 0;
		$(data.links).each(function() {
			//var $bpxml = $(this).children('BaseProperties');
			//var $vmlpxml = $(this).children('VMLProperties');

			var nl = new NodeLink();

			nl.id = this.id; //$bpxml.attr("id");
			nl.text = this.text; //$bpxml.attr("text");
			nl.isNew = false;
			nl.from = this.from; //$bpxml.attr("from");
			nl.to = this.to; //$bpxml.attr("to");
			nl.remindMsg = this.remindMsg; //$bpxml.attr("remindMsg");
			nl.isreject = this.isreject; //$bpxml.attr("isreject");
			//nl.ismustpass = $bpxml.attr("ismustpass");
			nl.directionfrom = this.directionfrom; // $bpxml.attr("directionfrom");
			nl.directionto = this.directionto; //$bpxml.attr("directionto");
			var startDirection = this.startDirection; // $bpxml.attr("startDirection");
			var endDirection = this.endDirection; //$bpxml.attr("endDirection");
			nl.startDirection = startDirection;
			nl.endDirection = endDirection;

			nl.hasRole = this.hasRole; //$bpxml.attr("hasRole");
			nl.hasCondition = this.hasCondition; //$bpxml.attr("hasCondition");
			nl.ispass = this.ispass; //$bpxml.attr("ispass");

			nl.points = this.points; //this.$vmlpxml.attr("newPoints");
			//console.log(nl.points);
			nl.startNode = workflowBase.getnNodeByNodeId(nl.from);
			nl.endNode = workflowBase.getnNodeByNodeId(nl.to);


			var isdrawlineflag = false;
			var ishorizontal = false;
			/*
			if (nl.points && nl.points.length > 0) {
				//两个节点之间距离特别近的时候的处理 START
				if (nl.startNode != nl.endNode && ((nl.directionfrom == 90 && nl.endDirection == -90) || (nl.directionfrom == -90 && nl.endDirection == 90))) {
					if (Math.abs(nl.xFrom - nl.xTo) <= 100 && Math.abs((nl.startNode.y + nl.startNode.height / 2) - (nl.endNode.y + nl.endNode.height / 2)) < 15) {
					
						isdrawlineflag = true;
						ishorizontal = true;
					}
				} else if (nl.startNode != nl.endNode && ((nl.directionfrom == 180 && nl.endDirection == 0) || (nl.directionfrom == 0 && nl.endDirection == 180))) {
					if (Math.abs(nl.yFrom - nl.yTo) <= 100 && Math.abs((nl.startNode.x + nl.startNode.width / 2) - (nl.endNode.x + nl.endNode.width / 2)) < 15) {
				
					}
					isdrawlineflag = true;

				}
			}
			
			if (!nl.points || nl.points.length == 0 || isdrawlineflag) {
			*/

			if (nl.points && nl.points.length > 0) {
				var sp = nl.points[0];
				var ep = nl.points[nl.points.length - 1];
				if (nl.startDirection) {

				}
			}

			if (!nl.points || nl.points.length == 0) {
				//nl.points = $vmlpxml.attr("points");
				var bl = new BaseLine();
				bl.startNode = nl.startNode;
				bl.endNode = nl.endNode;
				bl.startRotation = startDirection;
				bl.endDirection = endDirection;
				bl.oldPoints = this.oldPoints;
				bl.isreject = nl.isreject;
				nl.points = bl.calPoints();
				nl.startDirection = bl.startRotation;
				nl.endDirection = bl.endRotation;
			}

			nl.shapetype = this.shapetype; //$vmlpxml.attr("shapetype");
			nl.zIndex = this.zIndex; //$vmlpxml.attr("zIndex");
			nl.fromRelX = this.fromRelX; //$vmlpxml.attr("fromRelX");
			nl.fromRelY = this.fromRelY; //$vmlpxml.attr("fromRelY");

			nl.toRelX = this.toRelX; //$vmlpxml.attr("toRelX");
			nl.toRelY = this.toRelY; //$vmlpxml.attr("toRelY");

			workflowBase.nodeLinks.push(nl);
		});

		$(data.groups).each(function() {
			//var $bpxml = $(this);
			var g = new Group();
			g.id = this.id; //$bpxml.attr("id");
			g.workflowid = this.workflowid; //$bpxml.attr("workflowid");
			g.groupName = this.groupName; //$bpxml.attr("text");
			g.direction = this.direction; //parseInt($bpxml.attr("direction"));
			g.x = this.x; //parseInt($bpxml.attr("x"));
			g.y = this.y; // parseInt($bpxml.attr("y"));
			g.width = this.width; //parseInt($bpxml.attr("width"));
			g.height = this.height; //parseInt($bpxml.attr("height"));
			g.isNew = false;

			workflowBase.groups.push(g);
		});

		return workflowBase;
	};
};