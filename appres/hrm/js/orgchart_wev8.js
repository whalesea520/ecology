/**
 * Author: wcd 
 * Version: 1.0 2014-09-04
 */
function MFChart(){
	this.define();
	this.bindWrapEvent();
}
MFChart.prototype = {
	define:function(){
		this.isWrapDraggable = false;
		this.isWrapDraggableSub = true;
		this.isWrapDraggableSubCtrl = false;
	},
	htmlContent:[
	'<div class="org_line_{type} {line_class}" ><div class="org_node_c" id="org_node_c_{id}" nid="{id}" isload="0" title="{title}" ntype="{type}"><div class="org_node_c_inner_{type}">',
	'	<div class="ops_nci" style="display:block">',
	'		<a class="unfold_nci" style="color:{name_color}"><strong>-</strong></a>',
	'		<a class="fold_nci" style="color:{name_color}"><strong>+</strong></a>',
	'		<a class="all" style="display:none">&nbsp;</a>',
	'		<table width="100%" height="64px" cellspacing="0" cellpadding="0" class="main_table_{type}">',
	'			<tr height="30%">',
	'				<td align="center"><span style="font-size:12px;cursor:pointer;color:{name_color}" class="main_name" onclick="{name_onclick}">{name}</span></td>',
	'			</tr>',
	'			<tr height="70%">',
	'				<td align="center" style="display:{display}"><a class="countNum" href="javascript:void(0);" onclick="{cOnclick}" title="{nTitle}">{num}</a><label style="color:#23A4FF;display:{oDisplay}">&nbsp;/&nbsp;<a class="rCountNum" href="javascript:void(0);" onclick="{sOnclick}" title="{subTitle}">{subRCount}</a></label></td>',
	'			</tr>',
	'		</table>',
	'	</div>',
	'</div></div></div>'
	],
	onCreateAllTreeCallback:function(data, isExec){
		var that = this;
		if(data.length === 0)return;
		var wrap = this.context.conf.wrap;
		if(!isExec){
			wrap.find("td.org_td").fadeIn(800);
			wrap.fadeIn(800);
			return;
		}		
		
		var id = this.context.DataObject.adapter.id;	

		var tWrap = wrap.find("table.org_table:first");
		var allNodes;

		var scaleValue = wrap.data("scaleValue") || 0;
		for(var i in data[0]){
			if(_jQuery("#org_td_" + i).length){
				for(var j in data[0][i]){
					var curNode = _jQuery("#org_td_" + data[0][i][j][id]);
					if(scaleValue !== 0){
						allNodes = curNode.find("div.org_node_c, div.org_node_c_inner");
						
						allNodes.each(function(i, e){
							if(e){
								var ew = parseFloat(that.context.COE.getFinalStyle(e, "width")) + scaleValue;
								e.style.width = ew + "px";
								e.style.height = ew * .5 + "px";

							}
						});
						
						window.chart.changeNodeBySize(wrap, curNode);
					}
					
					curNode.find("td.org_td").not(function(){
						return !!_jQuery(this).find("table.org_table").length;
					}).find("a.unfold_nci").hide();
					if(curNode.parents("table[type=column]").length){
						allNodes.find("a.unfold_nci").hide();
					}
					
					curNode.fadeIn(800);
				}
			}else{
				wrap.find("td.org_td").not(function(){
					return !!_jQuery(this).find("table.org_table").length;
				}).find("a.unfold_nci").hide();			
				
				wrap.fadeIn(800);
				break;
			}
		}
	},
	changeNodeBySize:function(wrap, container){
		if(!container){
			container = wrap;
		}
		var scaleValue = wrap.data("scaleValue");
		if(scaleValue >= 90){
			container.find("div.org_node_c").removeClass("small_ort_nci");
			container.find("div.info_nci, div.ops_nci").show();
			container.find("div.main_name_nci").hide();
			
			wrap.data("scaleValue", 90);
			return false;
		}else if(scaleValue > 60){
			container.find("div.org_node_c").removeClass("small_ort_nci");
			container.find("div.info_nci").show();
			container.find("div.main_name_nci, div.ops_nci").hide();	
		}else if(scaleValue <= -30){
			container.find("div.org_node_c").addClass("small_ort_nci");
			container.find("div.info_nci, div.ops_nci").hide();
			container.find("div.main_name_nci").show();

			wrap.data("scaleValue", -30);
			return false;
		}else{
			container.find("div.org_node_c").addClass("small_ort_nci");
			container.find("div.info_nci, div.ops_nci").hide();
			container.find("div.main_name_nci").show();	
		}

		return true;
	},
	bindWrapEvent:function(){
		var handle = _jQuery("#box_org_tree");
		var moveNode;
		var mouseStartX, 
			mlStartX, 
			pointX, 
			mx, 
			mouseStartY, 
			mlStartY, 
			pointY, 
			my, 
			status;
		var dragCond = false;
		handle.bind("mousedown", function(e){
			dragCond = window.chart.isWrapDraggable && window.chart.isWrapDraggableSub;
			status = true;
			if(!dragCond)return;
			moveNode = _jQuery("#box_org_tree").find("table.org_table:first");
			if(e.pageX != undefined){
				mouseStartX = e.pageX;
			}	
			if(e.pageY != undefined){
				mouseStartY = e.pageY;
			}
			mlStartX = parseFloat(moveNode.css("margin-left"));
			mlStartX = isNaN(mlStartX) ? 0 : mlStartX;
			mlStartY = parseFloat(moveNode.css("margin-top"));
			mlStartY = isNaN(mlStartY) ? 0 : mlStartY;
		}).bind("mousemove", function(e){
			if(!dragCond)return;
			if(!status)return;
			if(e.pageX != undefined){
				pointX = e.pageX;
			}
			if(e.pageY != undefined){
				pointY = e.pageY;
			}
			mx = pointX - mouseStartX;
			my = pointY - mouseStartY;
			moveNode.css("margin-left", mlStartX + mx);
			moveNode.css("margin-top", mlStartY + my);
		}).bind("mouseup", function(){
			status = false;
			if(!dragCond)return;
		}).bind("mouseover", function(){
			dragCond = window.chart.isWrapDraggable && window.chart.isWrapDraggableSub;
			if(!dragCond){
				_jQuery(this).css("cursor", "default");
				return;
			}
			_jQuery(this).css("cursor", "move");
		}).bind("mouseout", function(){
			if(!dragCond)return;
			_jQuery(this).css("cursor", "default");
		});
		_jQuery(document).bind("mouseup", function(){
			status = false;
			if(!dragCond)return;
		});
	},
	createHtmlContent:function(data,rank){
		var node, tp = data;
		var browserName = $.client.browserVersion.browser;
		var id = this.context.DataObject.adapter.id;
		var name = this.context.DataObject.adapter.name;
		var type = this.context.DataObject.adapter.type;
		var title = this.context.DataObject.adapter.title;
		var showNum = this.context.DataObject.adapter.showNum;
		var num = this.context.DataObject.adapter.num;
		var nTitle = this.context.DataObject.adapter.nTitle;
		var oDisplay = this.context.DataObject.adapter.oDisplay;
		var subRCount = this.context.DataObject.adapter.subRCount;
		var subTitle = this.context.DataObject.adapter.subTitle;
		var cOnclick = this.context.DataObject.adapter.cOnclick;
		var sOnclick = this.context.DataObject.adapter.sOnclick;
		var hasChild = this.context.DataObject.adapter.hasChild;
		var needPlus = this.context.DataObject.adapter.needPlus;
		hasChild = tp[hasChild];
		needPlus = tp[needPlus];
		if(typeof(tp[name]) == 'undefined'||tp[name]==null)
		{
			return node;
		}
		var lineClass = "";
		var content = [];
		_jQuery.each(this.html.htmlContent, function(idx, val){
			content.push(val);
		});
		content[0] = content[0].replace(/{id}/g, tp[id]);
		content[0] = content[0].replace(/{type}/g, tp[type]);
		content[0] = content[0].replace("{title}", tp[title]);
		if(this.context.DataObject.conf.orgType == "right"){
			lineClass = "org_line_lm";
		} else if(this.context.DataObject.conf.orgType == "mfchart"){
			if(rank && Number(rank) > 1){
				lineClass = "org_line_lm";
			} else {
				lineClass = browserName && browserName == "IE" ? "org_line_tm_e" : "org_line_tm";
			}
		}else {
			lineClass = "org_line_tm";
		}
		
		content[0] = content[0].replace("{line_class}", lineClass);
		content[3] = content[3].replace("{name_color}", tp[type] == "company" ? "#000079" : "#eee");
		content[4] = content[4].replace("{name_color}", tp[type] == "company" ? "#000079" : "#eee");
		content[5] = content[5].replace("{type}", tp[type]);
		content[7] = content[7].replace("{name}", tp[name]);
		content[7] = content[7].replace("{name_color}", tp[type] == "company" ? "#000079" : "#eee");
		content[7] = content[7].replace("{name_onclick}", tp[type] == "company" ? "" : (tp[type] == "subcompany" ? "openWin('subcompany','"+tp[id]+"');" : "openWin('dept','"+tp[id]+"');"));
		content[10] = content[10].replace("{display}", showNum=="true"?"":"none");
		content[10] = content[10].replace("{num}", tp[num]);
		content[10] = content[10].replace("{nTitle}", tp[nTitle]);
		content[10] = content[10].replace("{oDisplay}", tp[oDisplay]);
		content[10] = content[10].replace("{subRCount}", tp[subRCount]);
		content[10] = content[10].replace("{subTitle}", tp[subTitle]);
		content[10] = content[10].replace("{cOnclick}", tp[cOnclick] && tp[cOnclick].length != 0 ? ("window.open(\'"+tp[cOnclick]+"\',\'_fullwindow\')") : "");
		content[10] = content[10].replace("{sOnclick}", tp[sOnclick] && tp[sOnclick].length != 0 ? ("window.open(\'"+tp[sOnclick]+"\',\'_fullwindow\')") : "");
		node = _jQuery(content.join(""));
		this.addEvent(node);
		
		if(rank){
			var showtype = this.context.conf.showtype;
			var shownum = this.context.conf.shownum;
			var orgType = this.context.conf.orgType;
			var isHide = false;
			if(showtype != 0 && shownum > 0){
				isHide = rank == shownum;
			}
			
			if(isHide){
				_jQuery(document).ready(function(){
					var self = _jQuery(this);
					var orgNodeC = node.find("div.org_node_c");
					_jQuery("#org_td_" + orgNodeC.attr("nid")).find("table.org_table:first").fadeOut("slow", function(){
						self.hide();
						node.find("a.unfold_nci").css("display","none");
						node.find("a.fold_nci").css("display","inline");
						if(orgType == "right"){
							if(orgNodeC.hasClass("org_line_rm")){
								orgNodeC.removeClass("org_line_rm");
							}
							if(!orgNodeC.hasClass("org_line_lm")){
								orgNodeC.addClass("org_line_lm");
							}
						} else if(this.context.DataObject.conf.orgType == "mfchart"){
							if(orgNodeC.hasClass("org_line_bm")){
								orgNodeC.removeClass("org_line_bm");
							}
							if(rank && Number(rank) > 1){
								if(!orgNodeC.hasClass("org_line_lm")){
									orgNodeC.addClass("org_line_lm");
								}
							} else {
								if(!orgNodeC.hasClass(browserName && browserName == "IE" ? "org_line_tm_e" : "org_line_tm")){
									orgNodeC.addClass(browserName && browserName == "IE" ? "org_line_tm_e" : "org_line_tm");
								}
							}
						} else {
							if(orgNodeC.hasClass("org_line_bm")){
								orgNodeC.removeClass("org_line_bm");
							}
							if(!orgNodeC.hasClass("org_line_tm")){
								orgNodeC.addClass("org_line_tm");
							}
						}
					});
				});
			}
			var paddingpx = 0;
			if(hasChild==="true")
			{
				if(needPlus==="true")
				{
					node.find("a.unfold_nci").css("display","none");
					node.find("a.fold_nci").css("display","inline");
				}
				else
				{
					node.find("div.org_node_c").attr("isload","1");
					node.find("a.unfold_nci").css("display","inline");
					node.find("a.fold_nci").css("display","none");
				}
			}
			else
			{
				paddingpx = "14";
				node.find("div.org_node_c").attr("isload","1");
				node.find("a.unfold_nci").css("display","none");
				node.find("a.fold_nci").css("display","none");
			}
			try
			{
				var tableclassname = 'main_table_'+tp[type];
				node.find("table."+tableclassname).css("cssText","margin-top:"+paddingpx+"px!important;");
			}
			catch(e)
			{
			}
		}
		return node;
	},
	addEventToNode:function(item){
		var that = this;
		var wrap = this.context.conf.wrap;
		var orgType = this.context.conf.orgType;
		var orgNode = item.find("div.org_node_c");
		var nid = orgNode.attr("nid");
		var title = orgNode.attr("title");
		var ntype = orgNode.attr("ntype");
		var browserName = $.client.browserVersion.browser;
		
		item.find("a.main_name").bind("mousedown", function(){
			if(!window.chart.isWrapDraggableSubCtrl)return;
		});
		item.bind("mouseover", function(){
			if(!window.chart.isWrapDraggableSubCtrl)return;
			var self = _jQuery(this);
			window.chart.isWrapDraggableSub = false;
			self.css("cursor", "move");
			self.find("div.org_node_c_inner").addClass("over_org_nci");
		}).bind("mouseout", function(){
			if(!window.chart.isWrapDraggableSubCtrl)return;
			var self = _jQuery(this);
			window.chart.isWrapDraggableSub = true;
			self.css("cursor", "default");
			self.find("div.org_node_c_inner").removeClass("over_org_nci");
		}).bind("mousemove", function(){
			if(!window.chart.isWrapDraggableSubCtrl)return;
			window.chart.isWrapDraggableSub = false;
		});
		
		item.find("img").bind("mousemove", function(e){
			e.preventDefault();
		}).bind("mouseup", function(e){
			e.preventDefault();
		}).bind("mousedown", function(e){
			e.preventDefault();
		});
		item.find("a.unfold_nci").bind("mousedown", function(){
			var self = _jQuery(this);
			_jQuery("#org_td_"+nid).find("table.org_table:first").fadeOut("slow", function(){
				self.hide();
				var rank = _jQuery("#org_td_"+nid).attr("rank");
				if(orgType == "right"){			
					if(orgNode.hasClass("org_line_rm")){
						orgNode.removeClass("org_line_rm");
					}
					if(ntype != "company" && !orgNode.hasClass("org_line_lm")){
						orgNode.addClass("org_line_lm");
					}
				} else if(orgType == "mfchart"){
					if(orgNode.hasClass("org_line_bm")){
						orgNode.removeClass("org_line_bm");
					}
				} else {			
					if(orgNode.hasClass("org_line_bm")){
						orgNode.removeClass("org_line_bm");
					}
					if(ntype != "company" && !orgNode.hasClass("org_line_tm")){
						orgNode.addClass("org_line_tm");
					}
				}
				item.find("a.fold_nci").css("display","inline");
			});
		});
		item.find("a.fold_nci").bind("mousedown", function(){
			try
			{
	            var tempisload = orgNode.attr("isload");
	            var tempid = orgNode.attr("nid");
			    var temptype = orgNode.attr("ntype");
	            if(tempisload!="1")
	            {
		            var timestamp = (new Date()).valueOf();
		            var otherparams = "&status="+status+"&docStatus="+docStatus+"&customerType="+customerType
		                              +"&customerStatus="+customerStatus+"&workType="+workType+"&projectStatus="+projectStatus;
		            var params = "id="+tempid+"&type="+temptype+"&cmd="+cmd+"&sorgid="+sorgid+"&isShow="+isShow+otherparams+"&ts="+timestamp;
		            jQuery.ajax({
		                type: "POST",
		                url: "/hrm/company/HrmDepartLayoutAjax.jsp",
		                data: params,
		                async: false,
		                success: function(msg){
		                	msg = jQuery.trim(msg);
		                	if(msg!="") {
			                	try {
				                    orgNode.attr("isload","1");
				                    var newdata = jQuery.parseJSON(msg);
				                    window.CO.NodeObject.addNodeWithData(newdata);
			                    } catch(e){}
		                    }
		                    jQuery("#box_org_tree").show();
		                    jQuery("#org_group_undefined").hide();
		                }
		            });
	            }
            } catch(ex){}
			var self = _jQuery(this);
			_jQuery("#org_td_" + nid).find("table.org_table:first").fadeIn("slow", function(){
				self.hide();
				var rank = _jQuery("#org_td_"+nid).attr("rank");
				if(orgType == "right"){					
					if(!orgNode.hasClass("org_line_rm")){
						orgNode.addClass("org_line_rm");
					}
					if(orgNode.hasClass("org_line_lm")){
						orgNode.removeClass("org_line_lm");
					}
				} else if(orgType == "mfchart"){
					if(!orgNode.hasClass("org_line_bm")){
						orgNode.addClass("org_line_bm");
					}
					if(rank && Number(rank) > 1){
						if(orgNode.hasClass("org_line_lm")){
							orgNode.removeClass("org_line_lm");
						}
					} else {
						if(orgNode.hasClass(browserName && browserName == "IE" ? "org_line_tm_e" : "org_line_tm")){
							orgNode.removeClass(browserName && browserName == "IE" ? "org_line_tm_e" : "org_line_tm");
						}
					}
				} else {
					if(!orgNode.hasClass("org_line_bm")){
						orgNode.addClass("org_line_bm");
					}
					if(orgNode.hasClass("org_line_tm")){
						orgNode.removeClass("org_line_tm");
					}
				}
				item.find("a.unfold_nci").css("display","inline");
			});
		});
	}
};