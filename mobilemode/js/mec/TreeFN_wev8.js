if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.buildTree = function(mec_id, treeid, pid, pname, unCreateTitle){
	if(pid == null || typeof(pid) == "undefined"){
		pid = "";
	}
	
	if(typeof(top.lockPage) == "function"){
		top.lockPage();
	}

	var $treeContainer = $("#tree" + mec_id);
	
	var $treetitle = $(".treetitle", $treeContainer);
	
	var $toParent = $(".toParent", $treetitle);
	
	var $treepage = $("#treepage_"+mec_id+"_"+pid);
	
	if($treepage.length == 0){
		var $treeloading = $(".treeloading", $treeContainer);
		$treeloading.show();
		
		var appid = $("#appid").val();
		
		var url = "/weaver/com.weaver.formmodel.mobile.mec.servlet.MECAction?action=getTreeData&treeid="+treeid+"&pid="+pid+"&appid="+appid+"&mec_id="+mec_id;
		$.post(url, null, function(responseText){
			$treeloading.hide();
			var data = $.parseJSON(responseText);
			var status = data["status"];
			if(status == "-1"){
				alert("加载树时出现异常");
				return;
			}
			
			//隐藏之前的page
			$(".treepage", $treeContainer).hide();
			
			//创建一个新的page
			var $newTreePage = $("<div id=\"treepage_"+mec_id+"_"+pid+"\" class=\"treepage\"></div>");
			var $ul = $("<ul></ul>");
			
			$newTreePage.append($ul);
			$treeContainer.append($newTreePage);
			
			var childNodes = data["childNodes"];
			for(var i = 0; i < childNodes.length; i++){
				var cNode = childNodes[i];
				var cId = cNode["id"];
				var cName = cNode["name"];
				var cChildNum = cNode["childNum"];
				var cIsParent = cNode["isParent"];
				var cUrl = cNode["nodeurl_mobile"];
				var cAppendhtml = cNode["appendhtml"];
				var cBilldata = JSON.stringify(cNode["billdata"]);
				
				var $li = $("<li nodeid=\""+cId+"\" nodename=\""+cName+"\" nodeurl=\""+cUrl+"\" nodeparent=\""+cIsParent+"\"></li>");
				var htm = "<input type=\"hidden\" name=\"billdata\" value=\"\"/>"
				htm += "<div class=\"nodename\">"+cName+"</div>";
				
				if(cIsParent == "true"){
					htm += "<em class=\"child\">"+cChildNum+"</em>";
					htm += "<div class=\"toChild\"><i class=\"arrow\"></i></div>";
				}
				
				if(cAppendhtml && cAppendhtml != ""){
					htm += cAppendhtml;
				}
				$li.html(htm);
				$ul.append($li);
				
				$("input[name='billdata']", $li)[0].value = cBilldata;
			}
			
			//绑定事件
			$(".nodename", $newTreePage).click(function(e){
				var $theParent = $(this).parent();
				var nodeurl = $theParent.attr("nodeurl");
				var nodeparent = $theParent.attr("nodeparent");
				if(nodeurl == "" && nodeparent == "true"){
					$(this).siblings(".toChild").trigger("click");
				}else{
					var billdataStr = $("input[name='billdata']", $theParent).val();
					var billdata = $.parseJSON(billdataStr);
					billdata["_tree_node_name"] = $(this).text();
					var oParam = {"refreshedCallbackParamData":billdata};
					openDetail(nodeurl, $theParent[0], oParam);
				}
				e.stopPropagation(); 
			});
			
			$(".toChild", $newTreePage).click(function(e){
				var nodeid = $(this).parent().attr("nodeid");
				var nodename = $(this).parent().attr("nodename");
				Mobile_NS.buildTree(mec_id, treeid, nodeid, nodename);
				e.stopPropagation(); 
			});
			
			//添加头部
			if(!unCreateTitle){
				var titleNodename;
				if(pid == ""){
					titleNodename = data["rootNode"]["name"];
				}else{
					titleNodename = pname;
				}
				
				var $titleLI = $("<li nodeid=\""+pid+"\" nodename=\""+titleNodename+"\"><span class=\"nodeSplit\">/</span>"+titleNodename+"</li>");
				$treetitle.children("ul").append($titleLI);
				
				$titleLI.click(function(e){
					var nodeid = $(this).attr("nodeid");
					var nodename = $(this).attr("nodename");
					$(this).nextAll().remove();
					Mobile_NS.buildTree(mec_id, treeid, nodeid, nodename, true);
					e.stopPropagation(); 
				});
			}
			
			if(pid == ""){
				$toParent.hide();
			}else{
				$toParent.show();
			}
			
			if(typeof(refreshIScroll) == "function"){
				refreshIScroll();
			}
			
			if(top && typeof(top.resetActiveFrame) == "function"){
				top.resetActiveFrame();
			}
			
			if(typeof(top.lazyReleasePage) == "function"){
	    		top.lazyReleasePage();
	    	}
			
			Mobile_NS.whenTreepageAsyncCreate();
		});
	}else{
		
		//隐藏之前的page
		$(".treepage", $treeContainer).hide();
		
		$treepage.show();
		
		//添加头部
		if(!unCreateTitle){
			var $titleLI = $("<li nodeid=\""+pid+"\" nodename=\""+pname+"\"><span class=\"nodeSplit\">/</span>"+pname+"</li>");
			$treetitle.children("ul").append($titleLI);
			
			$titleLI.click(function(e){
				var nodeid = $(this).attr("nodeid");
				var nodename = $(this).attr("nodename");
				$(this).nextAll().remove();
				Mobile_NS.buildTree(mec_id, treeid, nodeid, nodename, true);
				e.stopPropagation(); 
			});
		}
		
		if(pid == ""){
			$toParent.hide();
		}else{
			$toParent.show();
		}
		
		if(typeof(refreshIScroll) == "function"){
			refreshIScroll();
		}
			
		if(top && typeof(top.resetActiveFrame) == "function"){
			top.resetActiveFrame();
		}
		
		if(typeof(top.lazyReleasePage) == "function"){
			setTimeout(function(){
				top.lazyReleasePage();
			}, 500);
    		
    	}
	}
};

Mobile_NS.bindTreeBack = function(mec_id){
	var $treeContainer = $("#tree" + mec_id);
	
	var $treetitle = $(".treetitle", $treeContainer);
	
	var $toParent = $(".toParent", $treetitle);
	
	$toParent.click(function(e){
		var $ul = $treetitle.children("ul");
		var $li = $ul.children("li:not(.more)");
		var $preNode = $li.eq($li.length - 2);
		if($preNode.length > 0){
			$preNode.trigger("click");
		}
		e.stopPropagation(); 
	});
};

Mobile_NS.bindTreeSearch = function(mec_id, treeid){
	var $treeContainer = $("#tree" + mec_id);
	
	var $treesearch = $(".treesearch", $treeContainer);
	
	var $searchBtn = $(".searchBtn", $treesearch);
	
	$searchBtn.click(function(e){
		
		var $searchKey = $(".searchKey", $treesearch);
		var searchKeyV = $.trim($searchKey.val());
		
		if(searchKeyV != ""){
			
			var $treeloading = $(".treeloading", $treeContainer);
			$treeloading.show();
			
			var appid = $("#appid").val();
			
			var url = "/weaver/com.weaver.formmodel.mobile.mec.servlet.MECAction?action=getTreeDataWithSearch&treeid="+treeid+"&appid="+appid+"&mec_id="+mec_id+"&searchKey="+encodeURI(encodeURI(searchKeyV));
			$.post(url, null, function(responseText){
				$treeloading.hide();
				
				var data = $.parseJSON(responseText);
				var status = data["status"];
				if(status == "-1"){
					alert("搜索时出现异常");
					return;
				}
				
				//隐藏之前的page
				$(".treepage:not(.searchpage):visible", $treeContainer).attr("prev_treepage", "true").hide();
				
				
				//创建或者显示searchpage
				var $searchPage = $("#searchpage_" + mec_id);
				if($searchPage.length == 0){
					$searchPage = $("<div id=\"searchpage_"+mec_id+"\" class=\"treepage searchpage\"></div>");
					$treeContainer.append($searchPage);
				}else{
					$searchPage.find("*").remove();
					$searchPage.show();
				}

				var $ul = $("<ul></ul>");
				
				$searchPage.append($ul);
				
				var childNodes = data["childNodes"];
				for(var i = 0; i < childNodes.length; i++){
					var cNode = childNodes[i];
					var cId = cNode["id"];
					var cName = cNode["name"];
					var cUrl = cNode["nodeurl_mobile"];
					var cAppendhtml = cNode["appendhtml"];
					var cBilldata = JSON.stringify(cNode["billdata"]);
					
					var $li = $("<li nodeid=\""+cId+"\" nodename=\""+cName+"\" nodeurl=\""+cUrl+"\"></li>");
					var htm = "<input type=\"hidden\" name=\"billdata\" value=\"\"/>"
					htm += "<div class=\"nodename\">"+cName+"</div>";
					
					if(cAppendhtml && cAppendhtml != ""){
						htm += cAppendhtml;
					}
					$li.html(htm);
					$ul.append($li);
					
					$("input[name='billdata']", $li)[0].value = cBilldata;
				}
				
				//绑定事件
				$(".nodename", $searchPage).click(function(e){
					var $theParent = $(this).parent();
					var billdataStr = $("input[name='billdata']", $theParent).val();
					var billdata = $.parseJSON(billdataStr);
					billdata["_tree_node_name"] = $(this).text();
					var oParam = {"refreshedCallbackParamData":billdata};
					
					var nodeurl = $theParent.attr("nodeurl");
					openDetail(nodeurl, $theParent[0], oParam);
					e.stopPropagation(); 
				});
				
				//添加头部
				var st = "搜索<b>“"+searchKeyV+"”</b>的结果";
				var $treetitle = $(".treetitle", $treeContainer);
				var $searchText = $(".searchText", $treetitle);
				var $searchInnerTextWrap = $(".searchInnerTextWrap", $searchText);
				var $searchInnerText = $(".searchInnerText", $searchInnerTextWrap);
				$searchInnerText.html(st);
				$searchText.show();
				var $searchCanel = $searchInnerTextWrap.children(".searchCanel[click_event!='true']");
				if($searchCanel.length > 0){
					$searchCanel.attr("click_event", "true");
					$searchCanel.click(function(e){
						$searchText.hide();
						$searchPage.hide();
						$searchKey.val("");
						$(".treepage:not(.searchpage)[prev_treepage='true']", $treeContainer).removeAttr("prev_treepage").show();
						if(typeof(refreshIScroll) == "function"){
							refreshIScroll();
						}
						
						if(top && typeof(top.resetActiveFrame) == "function"){
							top.resetActiveFrame();
						}
						e.stopPropagation(); 
					});
				}
				
				if(typeof(refreshIScroll) == "function"){
					refreshIScroll();
				}
				
				if(top && typeof(top.resetActiveFrame) == "function"){
					top.resetActiveFrame();
				}
			});
		}
		
		e.stopPropagation(); 
	});
	
	$(".searchKey", $treesearch).keyup(function(event){
		var keyCode = event.keyCode;
		if(keyCode == 13){
			$searchBtn.trigger("click");
		}
	});
	
};

Mobile_NS.whenTreepageAsyncCreate = function(){
	
};