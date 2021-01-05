var zNodes = [{"id":"68","pId":"1","name":"建模功能测试","icon":"","click":"javascript:onTreeClick('68');","childappcount":"1"},{"id":"69","pId":"66","name":"sddsds","icon":"","click":"javascript:onTreeClick('69');","childappcount":"1"},{"id":"56","pId":"50","name":"响当当的","icon":"","click":"javascript:onTreeClick('56');","childappcount":"0"},{"id":"58","pId":"57","name":"水水水水","icon":"","click":"javascript:onTreeClick('58');","childappcount":"0"},{"id":"70","pId":"69","name":"dddsdsds","icon":"","click":"javascript:onTreeClick('70');","childappcount":"0"},{"id":"71","pId":"1","name":"车辆管理（勿删）","icon":"","click":"javascript:onTreeClick('71');","childappcount":"0"},{"id":"74","pId":"1","name":"测试（fj）","icon":"","click":"javascript:onTreeClick('74');","childappcount":"3"},{"id":"75","pId":"74","name":"fjtestA应用","icon":"","click":"javascript:onTreeClick('75');","childappcount":"0"},{"id":"76","pId":"74","name":"fj图书管理","icon":"","click":"javascript:onTreeClick('76');","childappcount":"0"},{"id":"77","pId":"68","name":"cddd","icon":"","click":"javascript:onTreeClick('77');","childappcount":"0"},{"id":"79","pId":"1","name":"测试接口(wbp)","icon":"","click":"javascript:onTreeClick('79');","childappcount":"0"},{"id":"81","pId":"51","name":"0721","icon":"","click":"javascript:onTreeClick('81');","childappcount":"0"},{"id":"82","pId":"51","name":"cdy测试","icon":"","click":"javascript:onTreeClick('82');","childappcount":"0"},{"id":"12","pId":"6","name":"品质与测试（勿删）","icon":"","click":"javascript:onTreeClick('12');","childappcount":"0"},{"id":"17","pId":"1","name":"hubo","icon":"","click":"javascript:onTreeClick('17');","childappcount":"0"},{"id":"78","pId":"74","name":"fjtestB应用","icon":"","click":"javascript:onTreeClick('78');","childappcount":"0"},{"id":"35","pId":"32","name":"zx3","icon":"","click":"javascript:onTreeClick('35');","childappcount":"0"},{"id":"62","pId":"37","name":"111","icon":"","click":"javascript:onTreeClick('62');","childappcount":"0"},{"id":"33","pId":"32","name":"zx1","icon":"","click":"javascript:onTreeClick('33');","childappcount":"0"},{"id":"34","pId":"32","name":"zx2","icon":"","click":"javascript:onTreeClick('34');","childappcount":"0"},{"id":"36","pId":"32","name":"zx4","icon":"","click":"javascript:onTreeClick('36');","childappcount":"0"},{"id":"66","pId":"65","name":"WWW","icon":"","click":"javascript:onTreeClick('66');","childappcount":"1"},{"id":"47","pId":"46","name":"上第三代","icon":"","click":"javascript:onTreeClick('47');","childappcount":"1"},{"id":"5","pId":"1","name":"培训管理","icon":"","click":"javascript:onTreeClick('5');","childappcount":"0"},{"id":"6","pId":"1","name":"研发管理（勿删）","icon":"","click":"javascript:onTreeClick('6');","childappcount":"1"},{"id":"7","pId":"1","name":"合同收付款","icon":"","click":"javascript:onTreeClick('7');","childappcount":"0"},{"id":"31","pId":"1","name":"练习题","icon":"","click":"javascript:onTreeClick('31');","childappcount":"0"},{"id":"37","pId":"1","name":"sdfsd","icon":"","click":"javascript:onTreeClick('37');","childappcount":"1"},{"id":"63","pId":"1","name":"车辆管理test","icon":"","click":"javascript:onTreeClick('63');","childappcount":"1"},{"id":"40","pId":"1","name":"四十四","icon":"","click":"javascript:onTreeClick('40');","childappcount":"0"},{"id":"1","pId":"0","name":"所有应用","icon":"","click":"javascript:onTreeClick('1');","childappcount":"23"},{"id":"64","pId":"63","name":"驾驶员信息","icon":"","click":"javascript:onTreeClick('64');","childappcount":"0"},{"id":"48","pId":"46","name":"第三代","icon":"","click":"javascript:onTreeClick('48');","childappcount":"0"},{"id":"65","pId":"47","name":"顶顶顶顶","icon":"","click":"javascript:onTreeClick('65');","childappcount":"1"},{"id":"50","pId":"1","name":"是打发士大夫","icon":"","click":"javascript:onTreeClick('50');","childappcount":"2"},{"id":"67","pId":"1","name":"合同管理","icon":"","click":"javascript:onTreeClick('67');","childappcount":"0"},{"id":"80","pId":"51","name":"0721bef","icon":"","click":"javascript:onTreeClick('80');","childappcount":"0"},{"id":"83","pId":"1","name":"模块导入","icon":"","click":"javascript:onTreeClick('83');","childappcount":"0"},{"id":"46","pId":"1","name":"第三代是","icon":"","click":"javascript:onTreeClick('46');","childappcount":"2"},{"id":"51","pId":"1","name":"测试0624","icon":"","click":"javascript:onTreeClick('51');","childappcount":"3"},{"id":"57","pId":"50","name":"十分大方","icon":"","click":"javascript:onTreeClick('57');","childappcount":"1"},{"id":"4","pId":"1","name":"日程管理45","icon":"","click":"javascript:onTreeClick('4');","childappcount":"0"},{"id":"32","pId":"1","name":"zx","icon":"","click":"javascript:onTreeClick('32');","childappcount":"4"},{"id":"18","pId":"1","name":"测试(changc)","icon":"","click":"javascript:onTreeClick('18');","childappcount":"0"},{"id":"9","pId":"1","name":"测试(lhl)","icon":"","click":"javascript:onTreeClick('9');","childappcount":"0"},{"id":"73","pId":"1","name":"表单建模回归测试_胡俊","icon":"","click":"javascript:onTreeClick('73');","childappcount":"0"},{"id":"61","pId":"1","name":"模块检验(????)","icon":"","click":"javascript:onTreeClick('61');","childappcount":"0"}];



window.onload = function(){
	
	setInterval('scrollComments("#divComment")',3000);
	
	var $searchText = $(".searchText");
	var $searchTextTip = $(".searchText_tip");
	
	$searchTextTip.click(function(){
		$searchText[0].focus();
	});
	
	$searchText.focus(function(){
		$searchTextTip.hide();
	});
	
	$searchText.blur(function(){
		if(this.value == ""){
			$searchTextTip.show();
		}
	});
	
	initTree(zNodes);
	
	$(document).on('mouseover', '.the_tree li', function(event) {
		$(this).parents().addClass("noover");
		$(this).removeClass("noover");
		event.stopPropagation();
	});
	
	initTreeTab();
	
	$(".center_left_container").niceScroll({
		//cursorcolor : "#1e7145"
	});
	
	//$(".mainTable").css("opacity", "0.3");
	//$(".center_left_top").css("opacity", "0.3");
	//$(".tabsContainer").css("opacity", "0.3");
	
	$("#btnEnter").click(function(){
		$("#cover").animate({ top: "-100%", opacity: 1}, 500, function(){
			$(".mainTable").animate({opacity: 1}, 500);
			$(".center_left_top").animate({opacity: 1}, 500);
			$(".tabsContainer").animate({opacity: 1}, 500);
		});
	});
};

function initTree(treeDatas){
	
//	var treeSetting = {
//		view: {
//			showLine: false,
//			showIcon: false
//		},
//		data: {
//			simpleData: {
//				enable: true
//			}
//		},
//		callback: {
//			onClick: function(e,treeId, treeNode) {
//				$('.the_tree a:not(.curSelectedNode)').parent().removeClass("ztreeNodeBgColor");
//				$('.the_tree a:not(.curSelectedNode)').parent().addClass("noover");
//				$('.the_tree .curSelectedNode').parent().addClass("ztreeNodeBgColor");
//			}
//		}
//	};
	
//	$.fn.zTree.init($("#the_tree"), treeSetting, treeDatas);
	initLoad();
//	
//	var selectedNode = treeObj.getNodeByParam("id", "79", null);
//	treeObj.selectNode(selectedNode, true, true);
//	zTreeOnAsyncSuccess();
	//treeObj.setting.callback.onClick(null, treeObj.setting.treeId, selectedNode);//调用事件 
	
}

var firstAsyncSuccessFlag = 0;
function zTreeOnAsyncSuccess() {
	if (firstAsyncSuccessFlag == 0) {
          try {
        	  	 var treeObj = $.fn.zTree.getZTreeObj("the_tree");
                 //调用默认展开第一个结点  
                 var selectedNode = treeObj.getSelectedNodes();
                 var nodes = treeObj.getNodes();
                 treeObj.expandNode(nodes[0], true); 
                 var childNodes = treeObj.transformToArray(nodes[0]);  
                 treeObj.expandNode(childNodes[1], true);  
                 //treeObj.selectNode(childNodes[1]);  
                 var childNodes1 = treeObj.transformToArray(childNodes[1]);  
                 treeObj.checkNode(childNodes1[1], true, true);  
                 firstAsyncSuccessFlag = 1;  
           } catch (err) {
              
           }
     }
}
function initTreeTab(){
	
	//var ktree_tab1 = "{\"ktree_ptabid\":\"\",\"ktree_stabid\":\"\"}";
	//FormmodeUtil.writeCookie("ktree_tab", ktree_tab1);
	
	var ptabid = "";
	var stabid = "";
	var ktreetabobj = null;
	var ktree_tab = null;
	var cookieVersionid = "";
	var cookieFunctionid = "";
	var $tabs = $(".tabsContainer > .tabs > ul > li");
	$tabs.bind("click", function(){
		if(!$(this).hasClass("selected")){
			var $prevSelectedTab = $(this).siblings(".selected");
			$prevSelectedTab.removeClass("selected");
			$(this).addClass("selected");
			
			var prevH = $prevSelectedTab.attr("href");
			if(prevH && prevH != ""){
				$(prevH).hide();
			}
			
			var h = $(this).attr("href");
			var index = h.substring(h.indexOf("-")+1,h.length);
			var versionId = $(this).attr("_versionId");
			var functionId = $(this).attr("_functionId");
			var tabId = $(this).attr("_tabId");
			/*if(index!=1 && tabId!=''){
				$.ajax({
					type:"post",
					async:false,
					url: "/formmode/apps/ktree/KtreeTabInfoOperation.jsp",
					contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					data:{versionId:versionId,functionId:functionId,tabId:tabId,index:index}, 
					complete: function(data){ 
					    if(data.responseText!=''){
					    	$(".tabsContainer").append(data.responseText);
					    }
					}
				});
			}*/
			
			if(h && h != ""){
				$(h).show();
				
				ktree_tab = FormmodeUtil.readCookie("ktree_tab");
				if(ktree_tab!=null){
					ktreetabobj = JSON.parse(ktree_tab);
					if(ktreetabobj!=null){
						cookieVersionid = ktreetabobj.versionid;
						cookieFunctionid = ktreetabobj.functionid;
						stabid = ktreetabobj.ktree_stabid;
					}
				}
				tabId = jQuery("#subtabs-"+index+" > ul > li").filter("[_tabId='"+stabid+"']").attr("_tabId");
				if(cookieVersionid==jQuery("#versionid").val() && cookieFunctionid==jQuery("#functionid").val() &&
						stabid!="" && typeof(tabId)!="undefined"){
					$(".tabsContainer > .subtabs > ul > li").filter("[_tabId='"+stabid+"']").trigger("click");
				}else{
					var $subtabs = $(h).children("ul").children("li");
					var $subSelectedTab = $subtabs.filter(".selected");
					if($subSelectedTab.length > 0){
						$subSelectedTab.eq(0).trigger("click");
					}else{
						var $subDefSelectedTab = $subtabs.filter("[defaultSelected='true']");
						if($subDefSelectedTab.length > 0){
							$subDefSelectedTab.eq(0).trigger("click");
						}
					}
				}
			}
		}
	});
	
	$(".tabsContainer > .subtabs > ul > li").live("click", function(){
		if(!$(this).hasClass("selected")){
			$(this).siblings(".selected").removeClass("selected");
			$(this).addClass("selected");
		}
	});
	
	ktree_tab = FormmodeUtil.readCookie("ktree_tab");
	if(ktree_tab!=null){
		ktreetabobj = JSON.parse(ktree_tab);
		if(ktreetabobj!=null){
			cookieVersionid = ktreetabobj.versionid;
			cookieFunctionid = ktreetabobj.functionid;
			ptabid = ktreetabobj.ktree_ptabid;
		}
	}
	if(cookieVersionid==jQuery("#versionid").val() && cookieFunctionid==jQuery("#functionid").val() && ptabid!=""){
		$tabs.filter("[_tabId='"+ptabid+"']").trigger("click");
	}else{
		$tabs.filter("[defaultSelected='true']").eq(0).trigger("click");
	}
	
}

function onTreeClick(){
	
}

function scrollComments(obj){ 
	$(obj).find("ul:first").animate({marginTop:"-100px"}, 500, function(){ 
		$(this).css({marginTop:"0px"}).find("li:first").appendTo(this); 
	}); 
}