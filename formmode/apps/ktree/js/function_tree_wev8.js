$(document).ready(function(){
	//initLoad();
	$("#functionName").keydown(function(e){ 
        var curKey = e.which; 
        if(curKey == 13){ 
        	search();
            return false; 
        } 
    }); 
});

function beforeClickNode(treeId, treeNode, clickFlag){
	 //return (treeNode.isclick==true);
}

function dclickNode(event, treeId, treeNode, clickFlag){
	$('.the_tree a:not(.curSelectedNode)').parent().removeClass("ztreeNodeBgColor");
	$('.the_tree a:not(.curSelectedNode)').parent().addClass("noover");
	$('.the_tree .curSelectedNode').parent().addClass("ztreeNodeBgColor");
	if(treeNode==null)
		return;
	var functionid = treeNode.id;
	//写入cookie
	var selectNodePath = ","+treeNode.id;
	var tempTreeNode = treeNode;
	while(tempTreeNode.getParentNode()!=null){
		tempTreeNode = tempTreeNode.getParentNode();
		selectNodePath=","+tempTreeNode.id+selectNodePath;
	}
	var ktree_function = "{\"versionid\":\""+$("#versionid").val()+"\",\"functionPath\":\""+selectNodePath+"\"}";
	FormmodeUtil.writeCookie("ktree_function", ktree_function);
	$("#functionid").val(functionid);//当前functionid
	/*
	 * 点击加载标签页面
	 * */
	/*$(".center_right_container").load("/formmode/apps/ktree/KtreeTabInfo.jsp?versionid="+$("#versionid").val()+"&functionid="+treeNode.id,function(){
		initTreeTab();
		resetContainer();
		jQuery(window).resize(function(){resetContainer();resetFrame();});
	});*/
	$(".tabsContainer > .tabs > ul > li").each(function(){
		var liObj = $(this);
		var tabId = liObj.attr("_tabId");
		readUnread($("#versionid").val(),functionid,tabId,liObj);
		resetContainer();
		jQuery(window).resize(function(){resetContainer();resetFrame();});
	});
	$(".tabsContainer > .subtabs > ul > li").each(function(){
		var liObj = $(this);
		var tabId = liObj.attr("_tabId");
		readUnread($("#versionid").val(),functionid,tabId,liObj);
	});
	
	var activeTabid = $(".tabsContainer > .subtabs > ul").find("li[class='selected']").attr("_tabId");
	if(typeof(activeTabid)!='undefined'){
		changeFrameUrl(activeTabid);
	}
	resetContainer();
	jQuery(window).resize(function(){resetContainer();resetFrame();});
}
function readUnread(versionId,functionid,tabId,obj){
	$.ajax({
		type:"post",
		async:false,
		url: "/formmode/apps/ktree/KtreeTabInfoOperation.jsp",
		data:{versionId:versionId,functionId:functionid,tabId:tabId}, 
		complete: function(data){ 
			if("true"==data.responseText.trim()){
				obj.find("img").remove();
				obj.append("<img src=\"/formmode/apps/ktree/images/BDNew_wev8.png\"/>");
			}
		}
	});
}

String.prototype.trim=function(){
　 return this.replace(/(^\s*)|(\s*$)/g, "");
}
function filter(treeId, parentNode, childNodes) {
	if (!childNodes) return null;
	for (var i=0, l=childNodes.length; i<l; i++) {
		childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
	}
	return childNodes;
}

function initLoad(){
	//浏览客户上次浏览的内容，如果没有就用默认的。
	var versionid = FormmodeUtil.readCookie("ktree_version");
	if(versionid==null){
		loadtree($("#versionid").val());
		selectFirst();
	}else{
		$("#versionid").val(versionid);
		loadtree(versionid);
		selectfunction();
	}
}
//默认选择第一个
function selectFirst(){
	var treeObj = $.fn.zTree.getZTreeObj("the_tree");
	var nodeArray = treeObj.getNodes();
	if(nodeArray.length>0){
		selectNode(nodeArray[0].id);
	}
}

function selectfunction(){
	var ktree_function = FormmodeUtil.readCookie("ktree_function");
	if(ktree_function!=null){
	    var fucntionObj = null;
		try{
			fucntionObj = JSON.parse(ktree_function);
		}catch(e){
		   return false;
		}
		if($("#versionid").val()==fucntionObj.versionid){
			var selectNodePath = fucntionObj.functionPath;
			var selectNodePathArray = selectNodePath.split(",");
			for(var i=0;i<selectNodePathArray.length;i++){
				if(selectNodePathArray[i]=="")
					continue;
				if(i==selectNodePathArray.length-1){
					selectNode(selectNodePathArray[i]);
				}else{
					expandNode(selectNodePathArray[i]);
				}
			}
		}
	}else{
		
	}
}

function selectNode(treeNodeId){
	var zTree = $.fn.zTree.getZTreeObj("the_tree");
	zTree.selectNode(getTreeNodeById(zTree,treeNodeId));
	dclickNode(event,"the_tree",getTreeNodeById(zTree,treeNodeId),"");
}

function getTreeNodeById(zTree,TreeNodeId){
	return zTree.getNodeByParam("id",TreeNodeId,null);
}

function expandNode(treeNodeId) {
	var zTree = $.fn.zTree.getZTreeObj("the_tree");
	zTree.expandNode(getTreeNodeById(zTree,treeNodeId), true, null, null, true);
}

function changeVersion(num){
	$("#versionid").val(num);
	FormmodeUtil.writeCookie("ktree_version", num);
	loadtree(num);
	selectFirst();
}

function addDiyDom(treeId, treeNode){
	if(treeNode.isNewFlag&&treeNode.isNewFlag==1){
		$("#" + treeNode.tId + "_a").append("<img src='/formmode/apps/ktree/images/BDNew_wev8.png'>");
	}
}

function loadtree(versionid){
	// 异步分级加载
	var setting = {
		view: {
			selectedMulti: false,
			showLine: false,
			showIcon: false,
			addDiyDom:addDiyDom
		},
		async: {
			enable: true,
			url:"asyncDataFunction.jsp?versionid="+versionid,
			autoParam:["versionid", "id"]
		},
		callback: {
			beforeClick: beforeClickNode,
			onClick: dclickNode
		}
	};
//	$("#versionid_"+versionid).css("curr");
//	alert($(".version").find("[id=versionid_"+versionid+"]"));
	$(".version li").removeClass("curr");
	$(".version").find("[id=versionid_"+versionid+"]").addClass("curr");
	$.fn.zTree.init($("#the_tree"), setting);
	/*
	//一次性加载
	$.ajax({
		url:"asyncAllDataFunction.jsp?versionid="+versionid,
		type:"post",
		async:false,
		cache:false,
		dataType:'json',
		success:function(data){
			var settingsearch = {
				view: {
					selectedMulti: false,
					showLine: false,
					showIcon: false,
					addDiyDom:addDiyDom
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback:{
					beforeClick: beforeClickNode,
					onClick: dclickNode
				}
			};
			$.fn.zTree.init($("#the_tree"), settingsearch,data);
			var zTree = $.fn.zTree.getZTreeObj("the_tree");
			//zTree.expandAll(true);
		}
	
	});
	*/
}

function search(){
	var versionid = $("#versionid").val();
	var search = $("#functionName").val();
	if(search==''){
		loadtree(versionid);
		return false;
	}
	$.ajax({
		url:"asyncDataSearchNewFunction.jsp?versionid="+versionid+"&search="+search,
		type:"post",
		async:false,
		cache:false,
		dataType:'json',
		success:function(data){
			var settingsearch = {
				view: {
					selectedMulti: false,
					showLine: false,
					showIcon: false,
					addDiyDom:addDiyDom
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback:{
					beforeClick: beforeClickNode,
					onClick: dclickNode
				}
			};
			$.fn.zTree.init($("#the_tree"), settingsearch,data);
			var zTree = $.fn.zTree.getZTreeObj("the_tree");
			zTree.expandAll(true);
		}
	});
//		var zTree = $.fn.zTree.getZTreeObj("the_tree");
//		var allNodes = zTree.getNodes();
//		zTree.hideNodes(allNodes);
//		for(var i=0;i<allNodes.length;i++){
//			zTree.hideNodes(allNodes[i]);
//		}
//		var searchNodes =  zTree.getNodesByParamFuzzy("name",search,null);
//		zTree.showNodes(searchNodes);
		
	
	
}

function searchNew(){
	var versionid = $("#versionid").val();
//	var setting = {
//		view: {
//			selectedMulti: false,
//			showLine: false,
//			showIcon: false,
//			addDiyDom:addDiyDom
//		},
//		async: {
//			enable: true,
//			url:"asyncDataFunction.jsp?shownew=1&versionid="+versionid,
//			autoParam:["versionid", "id","shownew"]
//		},
//		callback: {
//			beforeClick: beforeClickNode,
//			onClick: dclickNode
//		}
//	};
//	$.fn.zTree.init($("#the_tree"), setting);
	
	$.ajax({
		url:"asyncSearchNewDataFunction.jsp?versionid="+versionid,
		type:"post",
		async:false,
		cache:false,
		dataType:'json',
		success:function(data){
			var settingsearch = {
				view: {
					selectedMulti: false,
					showLine: false,
					showIcon: false,
					addDiyDom:addDiyDom
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback:{
					beforeClick: beforeClickNode,
					onClick: dclickNode
				}
			};
			$.fn.zTree.init($("#the_tree"), settingsearch,data);
			var zTree = $.fn.zTree.getZTreeObj("the_tree");
			zTree.expandAll(true);
		}
	});
	
}