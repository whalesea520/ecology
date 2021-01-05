var XmlParse = function () {
	this.parse = function (xml) {
		var workflowBase = new WorkflowBase();
		xml = "<xml>" + xml + "</xml>";
	    $(xml).find('Proc').each(function() {
	        var $bpxml = $(this).children('BaseProperties');
	        var $vmlpxml = $(this).children('VMLProperties');
	        var node = new NodeBase();
	        
	        node.id = $bpxml.attr("id");
            node.text = $bpxml.attr("text");
            node.procType = $bpxml.attr("procType");
            node.nodetype = $bpxml.attr("nodetype");
            node.nodeattribute = $vmlpxml.attr("nodeattribute");
            node.passNum = $bpxml.attr("passNum");
            node.nodeOptType = $bpxml.attr("optType");
            node.nodeOperatorName = $bpxml.attr("nodeOperatorName");
            node.nodeOperatorNames = $bpxml.attr("nodeOperatorNames");
            node.nodeViewNames = $bpxml.attr("nodeViewNames");
            node.nodeNotOperatorNames = $bpxml.attr("nodeNotOperatorNames");
            /*
            if (node.nodeOperatorName != null && node.nodeOperatorName != "" && node.nodeOperatorName.indexOf("_") != -1) {
            	node.nodeOperatorName = node.nodeOperatorName.split("_")[2];
            }
            
            
            if (node.nodeOperatorNames != null && node.nodeOperatorNames != "" && node.nodeOperatorNames.indexOf("_") != -1) {
            	var tnms = node.nodeOperatorNames.split(" ");
            	node.nodeOperatorNames = "";
            	for (var i=0; i<tnms.length; i++) {
            		if (tnms[i] != null && tnms[i] != "" && tnms[i].indexOf("_") != -1) {
            			node.nodeOperatorNames += tnms[i].split("_")[2] + " ";
            		}
            	}
            }
            
            if (node.nodeViewNames != null && node.nodeViewNames != "" && node.nodeViewNames.indexOf("_") != -1) {
            	var tnms = node.nodeViewNames.split(" ");
            	node.nodeViewNames = "";
            	for (var i=0; i<tnms.length; i++) {
            		if (tnms[i] != null && tnms[i] != "" && tnms[i].indexOf("_") != -1) {
            			node.nodeViewNames += tnms[i].split("_")[2] + " ";
            		}
            	}
            }
            
            if (node.nodeNotOperatorNames != null && node.nodeNotOperatorNames != "" && node.nodeNotOperatorNames.indexOf("_") != -1) {
            	var tnms = node.nodeNotOperatorNames.split(" ");
            	node.nodeNotOperatorNames = "";
            	for (var i=0; i<tnms.length; i++) {
            		if (tnms[i] != null && tnms[i] != "" && tnms[i].indexOf("_") != -1) {
            			node.nodeNotOperatorNames += tnms[i].split("_")[2] + " ";
            		}
            	}
            }
            */
            
            
            if (node.nodeNotOperatorNames == "" || node.nodeNotOperatorNames == null) {
                node.nodeNotOperatorNames = node.nodeOperatorName;
            }
            node.shapetype = $vmlpxml.attr("shapetype");
            node.width = $vmlpxml.attr("width");
            node.height = $vmlpxml.attr("height");
            node.x = parseInt($vmlpxml.attr("x")) - 48 + 60;
            node.y = parseInt($vmlpxml.attr("y")) - 30 + 40;
            node.zIndex = $vmlpxml.attr("zIndex");
            workflowBase.nodeBases.push(node);
		});
		var newLineCount = 0; 
		$(xml).find('Step').each(function() {
	        var $bpxml = $(this).children('BaseProperties');
	        var $vmlpxml = $(this).children('VMLProperties');
	        
	        var nl = new NodeLink();
	        
			nl.id = $bpxml.attr("id");
			nl.text = $bpxml.attr("text");
			nl.isNew = false;
			nl.from = $bpxml.attr("from");
			nl.to = $bpxml.attr("to");
			nl.remindMsg = $bpxml.attr("remindMsg");
			nl.isreject = $bpxml.attr("isreject");
			nl.ismustpass = $bpxml.attr("ismustpass");
			nl.directionfrom = $bpxml.attr("directionfrom");
			nl.directionto = $bpxml.attr("directionto");
			var startDirection = $bpxml.attr("startDirection");
			var endDirection = $bpxml.attr("endDirection");
			nl.startDirection = startDirection;
			nl.endDirection = endDirection;
			             
			nl.hasRole = $bpxml.attr("hasRole");
			nl.hasCondition = $bpxml.attr("hasCondition");
			nl.ispass = $bpxml.attr("ispass");
			
			nl.points = $vmlpxml.attr("newPoints");
			if (nl.points == undefined || nl.points == null || nl.points == "") {
				//nl.points = $vmlpxml.attr("points");
				if (newLineCount == 0) {
					backoldPic();
					return;
				}
				try {
					var tempPoints = "";
					var startNode = workflowBase.getnNodeByNodeId(nl.from);
					var endNode = workflowBase.getnNodeByNodeId(nl.to);
					if (startNode.x < endNode.x && Math.abs(startNode.y - endNode.y) < 30) {
						tempPoints = (startNode.x + 120) + "," + (startNode.y + 35) + ","
						+ (endNode.x) + "," + (endNode.y + 35)
					} else if (startNode.x > endNode.x && Math.abs(startNode.y - endNode.y) < 30) {
						tempPoints = (startNode.x) + "," + (startNode.y + 35) + ","
						+ (endNode.x + 120) + "," + (endNode.y + 35)
					} else if (startNode.y < endNode.y ) {
						tempPoints = (startNode.x + 60) + "," + (startNode.y + 100) + ","
						+ (endNode.x + 60) + "," + (endNode.y)
					} else if (startNode.y > endNode.y ) {
						tempPoints = (startNode.x + 60) + "," + (startNode.y) + ","
						+ (endNode.x + 60) + "," + (endNode.y + 100)
					} else {
						tempPoints = (startNode.x + 60) + "," + (startNode.y + 35) + ","
						+ (endNode.x + 60) + "," + (endNode.y + 35)
					}
					nl.points = tempPoints;
				} catch (e) {}
			} else {
				newLineCount++;
			}
			nl.shapetype = $vmlpxml.attr("shapetype");
			nl.zIndex = $vmlpxml.attr("zIndex");
			nl.fromRelX = $vmlpxml.attr("fromRelX");
			nl.fromRelY = $vmlpxml.attr("fromRelY");
			
			nl.toRelX = $vmlpxml.attr("toRelX");
			nl.toRelY = $vmlpxml.attr("toRelY");
			workflowBase.nodeLinks.push(nl);
		});
		
		$(xml).find('Group').each(function() {
	        var $bpxml = $(this);
	        var g = new Group();
			g.id = $bpxml.attr("id");
			g.workflowid = $bpxml.attr("workflowid");
			g.groupName = $bpxml.attr("text");
			g.direction = parseInt($bpxml.attr("direction"));
			g.x = parseInt($bpxml.attr("x"));
			g.y = parseInt($bpxml.attr("y"));
			g.width = parseInt($bpxml.attr("width"));
			g.height = parseInt($bpxml.attr("height"));
			g.isNew = false;
	       
            workflowBase.groups.push(g);
		});
		
		return workflowBase;
    };
};