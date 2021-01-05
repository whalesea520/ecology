$.fn.cssCheckBox = function () {
	if(_browserType == "2"){	//单选
		$(".valueHolder", $(this)).each(function () {
			
			if (this.checked) {
				$(this).parent().addClass("checked");
			}
			
			$(this).parent().unbind("click");
			$(this).parent().click(function(e){
				deCheckedAllOnPage();
				
				var $valueHolder = $(".valueHolder", this);
				var hrm_data = $.parseJSON($valueHolder.attr("hrm_data"));
				var id = hrm_data["id"];
				
				checkedOnPage(id);
					
				clearSelectedArr();
				addInSelectedArr(hrm_data);
				refreshSelectedNum();
				e.stopPropagation();
			});
		});
	}else{	//多选
		$(".valueHolder", $(this)).each(function () {
			if (this.checked) {
				$(this).parent().addClass("checked");
			}
			
			$(this).parent().unbind("click");
			$(this).parent().click(function(e){
				var $valueHolder = $(".valueHolder", this);
				
				var hrm_data = $.parseJSON($valueHolder.attr("hrm_data"));
				var id = hrm_data["id"];
				if($(this).hasClass("checked")){
					deCheckedOnPage(id);
					removeFromSelectedArr(hrm_data);
			    }else{
			    	checkedOnPage(id);
					addInSelectedArr(hrm_data);
			    }
			    
			    refreshSelectedNum();
			    e.stopPropagation();
			});
		});
	}
};


function resetBrowser(obj){
	_fieldId = obj["fieldId"] || "";
	_fieldSpanId = obj["fieldSpanId"] || "";
	_browserId = obj["browserId"] || "";
	_browserName = obj["browserName"] || "";
	_browserText = obj["browserText"] || "";
	_selectedIds = obj["selectedIds"] || "";
	_browserType = obj["browserType"] || "2";
	
	clearSelectedArr();	//清空已选
	deCheckedAllOnPage();	//清空页面已选
	refreshSelectedNum();	//刷新已选个数
	$(document.body).cssCheckBox();	//重新进行事件绑定
	$("#page-center").removeClass("selected-result-open");	//控制不让结果页面显示
	
	$(".company-data").html("");
	var url = "/mobilemode/browser/commonTreeBrowserAction.jsp?action=getTreeInitData&_browserId="+_browserId+"&_browserName="+_browserName+"&"+ new Date().getTime() + "=" + new Date().getTime();
	$.get(url, null, function(responseText){
		var data = $.parseJSON(responseText);
		var status = data["status"];
		if(status == "1"){
			$(".company-data").html(data["rootname"]);
		}else{
			var errMsg = data["errMsg"];
			alert(_resultBtnText[6] + errMsg);
		}
	});
	
	$(".company-data").attr("data-id","0_0");
	$(".company-data").attr("data-type",_browserName);
	
	
	var $rootTreePage = $("#tree-org-container .root-tree-page");
	var $rootTreeData = $rootTreePage.children("li").children(".one-tree-data");
	$rootTreePage.children("li").children("ul").remove();
	
	if($rootTreeData.hasClass("opened")){
		$rootTreeData.removeClass("opened");
		$rootTreeData.addClass("closed");
	}
	initTreeNode($rootTreeData);
}

$(document).ready(function(){
	FastClick.attach(document.body);
	
	$("#choosedResult").html(_resultBtnText[0]+"(<span id=\"selectedNum\">0</span>)");
	$("#okResult").html(_resultBtnText[1]);
	$("#backResult").html(_resultBtnText[2]);
	$("#clearResult").html(_resultBtnText[3]);

	if(_isRunInEmobile){
		$(document.body).addClass("_emobile");
	}
	
	refreshSelectedNum();
	initPageControl();
	initHeader();
	//流程页面，需要调用
	$(".company-data").html("");
	var url = "/mobilemode/browser/commonTreeBrowserAction.jsp?action=getTreeInitData&_browserId="+_browserId+"&_browserName="+_browserName;
	$.get(url, null, function(responseText){
		var data = $.parseJSON(responseText);
		var status = data["status"];
		if(status == "1"){
			$(".company-data").html(data["rootname"]);
		}else{
			var errMsg = data["errMsg"];
			alert(_resultBtnText[6] + errMsg);
		}
	});
	$(".company-data").attr("data-id","0_0");
	$(".company-data").attr("data-type",_browserName);
	var $rootTreePage = $("#tree-org-container .root-tree-page");
	var $rootTreeData = $rootTreePage.children("li").children(".one-tree-data");
	$rootTreePage.children("li").children("ul").remove();
	
	if($rootTreeData.hasClass("opened")){
		$rootTreeData.removeClass("opened");
		$rootTreeData.addClass("closed");
	}
	$rootTreeData.click();
	
	$("#result-hrm-content").click(function(e){
		$("li.beDelete", this).removeClass("beDelete");
	});	
	$("#clearResult").click(function(e){
		//删除数据
		clearSelectedArr();
		//刷新底部选中个数
		refreshSelectedNum();
		//取消页面数据的选中状态
		deCheckedAllOnPage();
		
		//页面上删除
		var $oneData = $("#result-data .one-data");
		$oneData.addClass("deleted");
		setTimeout(function(){
			$oneData.remove();
		},500);
	});
	
	initSelectedResultSearch();
});

function initPageControl(){
	var $page = $("#page-center");
	$("#choosedResult").click(function(){
		resetSelectedResultSearch();
		buildSelectedResultPage();
		initSelectedResultPageEvt();
		$page.addClass("selected-result-open");
	});
}

function refreshSelectedNum(){
	$("#selectedNum").html(_selected_arr.length);
}

function indexOfSelectedArr(id){
	var index = -1;
	for(var i = 0; i < _selected_arr.length; i++){
		var selectedData = _selected_arr[i];
		if(selectedData["id"] == id){
			index = i;
			break;
		}
	}
	return index;
}

function addInSelectedArr(data){
	if(indexOfSelectedArr(data.id) == -1){
		_selected_arr.push(data);
	}
}

function removeFromSelectedArr(data){
	removeFromSelectedArrById(data.id);
}

function removeFromSelectedArrById(id){
	var index = indexOfSelectedArr(id);
	if(index != -1){
		_selected_arr.splice(index, 1);
	}	
}

function clearSelectedArr(){
	_selected_arr = [];
}

function updateSelectedArrSort(){
	var _new_selected_arr = new Array();
	$("#result-data li.one-data").each(function(){
		var hrmId = $(this).attr("hrmId");
		var index = indexOfSelectedArr(hrmId);
		if(index != -1){
			var data = _selected_arr[index];
			_new_selected_arr.push(data);
		}
	});
	
	if(_new_selected_arr.length == _selected_arr.length){
		_selected_arr = _new_selected_arr;
	}
}

function checkedOnPage(id){
	var $valueHolder = $(".valueHolder[hrmId='"+id+"']");
	$valueHolder.attr("checked", "checked");
	$valueHolder.parent().addClass("checked");
}

function deCheckedOnPage(id){
	var $valueHolder = $(".valueHolder[hrmId='"+id+"']");
	$valueHolder.removeAttr("checked");
	$valueHolder.parent().removeClass("checked");
}

function deCheckedAllOnPage(){
	var $valueHolder = $(".valueHolder");
	$valueHolder.removeAttr("checked");
	$valueHolder.parent().removeClass("checked");
}

function initHeader(){
	$("#nav-header .header-left").click(doLeftMenuConfig);
	$("#nav-header .header-right").click(doRightMenuConfig);
	
	$("#backResult").click(doLeftMenuConfig);
	$("#okResult").click(doRightMenuConfig);
}
function buildSelectedResultPage(){
	var $resultData = $("#result-data");
	$resultData.children("ul").remove();
	var $dataUL = $("<ul></ul>");
	$resultData.append($dataUL);
	
	for(var i = 0; i < _selected_arr.length; i++){
		var selectedData = _selected_arr[i];
		var id = selectedData["id"];	//人员id
		var lastname = selectedData["lastname"];	//姓名
		
		$dataUL.append("<li class=\"one-data\" hrmId=\""+id+"\">"+
							"<div class=\"data-inner\">"+
								"<div class=\"data-delete\"></div>"+
								"<div class=\"data-part1\">"+
									"<div class=\"data-lastname\">"+lastname+"</div>"+
								"</div>"+
								"<div class=\"data-move\"></div>"+
							"</div>"+
							
							"<div class=\"delete-data\" hrmId=\""+id+"\">"+_resultBtnText[5]+"</div>"+
						"</li>");
	}
}
function initSelectedResultPageEvt(){
	var $resultData = $("#result-data");
	
	$(".data-delete", $resultData).click(function(e){
		$(this).parent().parent().addClass("beDelete");
		e.stopPropagation();
	});
	$("li.one-data", $resultData).click(function(e){
		if($(this).hasClass("beDelete")){
			$(this).removeClass("beDelete");
			e.stopPropagation();
		}
	});	
	$(".delete-data", $resultData).click(function(e){
		//删除数据
		var hrmId = $(this).attr("hrmId");
		removeFromSelectedArrById(hrmId);
		//刷新底部选中个数
		refreshSelectedNum();
		//取消页面数据的选中状态
		deCheckedOnPage(hrmId);
		//页面上删除
		var $oneData = $(this).parent();
		$oneData.addClass("deleted");
		setTimeout(function(){
			$oneData.remove();
		},500);
		e.stopPropagation();
	});
	
	new Sortable($("ul", $resultData)[0], {
		animation: 150,
		handle: ".data-move",
		draggable: ".one-data",
		onUpdate: function (evt){
			var item = evt.item;
			updateSelectedArrSort();
		}
	});
}

var prevSearchKey2 = "";
function initSelectedResultSearch(){
	var $searchKey = $("#result-search-key");
	var $srarchInner = $("#result-hrm-srarch .srarch-inner");
	$searchKey.focus(function(){
		$srarchInner.addClass("searching");
	});
	
	$searchKey.blur(function(){
		if(this.value == ""){
			$srarchInner.removeClass("searching");
		}
	});
	
	$searchKey.bind("input", function(){
		var currSearchKey = this.value;
		if(currSearchKey != prevSearchKey2){
			prevSearchKey2 = currSearchKey;
			searchSelectedResult();
		}
	});
}

function searchSelectedResult(){
	var $oneData = $("#result-data li.one-data");
	var searchKeyVal = $("#result-search-key").val();
	if(searchKeyVal == ""){
		$oneData.show();
	}else{
		$oneData.each(function(){
			var datalastname = $(".data-lastname", this).text();
			if(datalastname.indexOf(searchKeyVal) != -1){
				$(this).show();
			}else{
				$(this).hide();
			}
		});
	}
}

function resetSelectedResultSearch(){
	var $searchKey = $("#result-search-key");
	$searchKey.val("");
	$searchKey.trigger("blur");
}

function initTreeNode(obj){
	var $oneTreeData = $(obj);
	var expanding = $oneTreeData.attr("expanding");
	if(expanding == "1"){
		return;
	}
	$oneTreeData.attr("expanding", "1");
	
	var $treePage = $oneTreeData.siblings(".tree-page");
	
	if($oneTreeData.hasClass("closed")){
		$oneTreeData.removeClass("closed");
		$oneTreeData.addClass("opened");
		if($treePage.length > 0){
			$treePage.show();
			$oneTreeData.removeAttr("expanding");
		}else{
			
			//从服务端加载
			var $treeLoading = $("<div class=\"tree-loading\"></div>");
			$treeLoading.insertAfter($oneTreeData);
			
			var dataType = $oneTreeData.attr("data-type");
			var dataId = $oneTreeData.attr("data-id");
			dataId = encodeURIComponent(dataId);
			var temp_sel = encodeURIComponent(_selectedIds);
			url = "/mobilemode/browser/commonTreeBrowserAction.jsp?action=getTreeData&type="+dataType+"&pid="+dataId+"&selectedIds=" + temp_sel+"&"+ new Date().getTime() + "=" + new Date().getTime();
			$.get(url, null, function(responseText){
				$treeLoading.remove();
				
				var data = $.parseJSON(responseText);
				var status = data["status"];
				if(status == "1"){
					var sel_datas = data["sel_datas"];
					for(var i = 0; i < sel_datas.length; i++){
						var selectedData = sel_datas[i];
						addInSelectedArr(selectedData);
					}
					refreshSelectedNum();
					
					var datas = data["datas"];
					var isonlyleaf = data["isonlyleaf"];
					fillTreeDatasToPage(datas, $oneTreeData,isonlyleaf);
					
				}else{
					var errMsg = data["errMsg"];
					alert(_resultBtnText[6] + errMsg);
					
					$oneTreeData.removeClass("opened");
					$oneTreeData.addClass("closed");
				}
				
				$oneTreeData.removeAttr("expanding");
			});
		}
	}else if($oneTreeData.hasClass("opened")){
		$treePage.hide();
		$oneTreeData.removeClass("opened");
		$oneTreeData.addClass("closed");
		$oneTreeData.removeAttr("expanding");
	}
	
	var e=event || window.event;
    if (e && e.stopPropagation){
        e.stopPropagation();    
    }
}

function bindTreeEvt1($wrap){
	$(".expend[data-haschild='1']", $wrap).click(function(e){
		var $expendTreeData = $(this);
		var $oneTreeData = $(this).next();
		var expanding = $expendTreeData.attr("expanding");
		if(expanding == "1"){
			return;
		}
		$expendTreeData.attr("expanding", "1");
		
		var $treePage = $expendTreeData.siblings(".tree-page");
		
		if($expendTreeData.hasClass("closed")){
			$expendTreeData.removeClass("closed");
			$expendTreeData.addClass("opened");
			
			if($treePage.length > 0){
				$treePage.show();
				$expendTreeData.removeAttr("expanding");
			}else{
				//从服务端加载
				var $treeLoading = $("<div class=\"tree-loading\"></div>");
				$treeLoading.insertAfter($oneTreeData);
				
				var dataType = $oneTreeData.attr("data-type");
				var dataId = $oneTreeData.attr("data-id");
				dataId = encodeURIComponent(dataId);
				var url = "/mobilemode/browser/commonTreeBrowserAction.jsp?action=getTreeData&type="+dataType+"&pid="+dataId+"&"+ new Date().getTime() + "=" + new Date().getTime();
								
				$.get(url, null, function(responseText){
					$treeLoading.remove();
					
					var data = $.parseJSON(responseText);
					var status = data["status"];
					if(status == "1"){
						var datas = data["datas"];
						var isonlyleaf = data["isonlyleaf"];
						fillTreeDatasToPage(datas, $oneTreeData,isonlyleaf);
					}else{
						var errMsg = data["errMsg"];
						alert(_resultBtnText[6] + errMsg);
						
						$expendTreeData.removeClass("opened");
						$expendTreeData.addClass("closed");
					}
					
					$expendTreeData.removeAttr("expanding");
				});
			}
		}else if($expendTreeData.hasClass("opened")){
			$treePage.hide();
			$expendTreeData.removeClass("opened");
			$expendTreeData.addClass("closed");
			$expendTreeData.removeAttr("expanding");
		}
		e.stopPropagation();
	});
}

function fillTreeDatasToPage(datas, $obj,isonlyleaf){
	var $treePage = $("<ul class=\"tree-page\"></ul>");
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		var id = data["id"];	//id
		var name = data["name"];	//名称
		var type = data["type"];	//类型
		
		var $li;
		var hasChild = data["hasChild"];	//是否有子节点
		var hasChildFlag = hasChild ? "1" : "0"; 
		var cssStr = hasChild ? "closed" : "";
		var classStr = hasChild ? "hasChild" : "";
		var checkedStr = (indexOfSelectedArr(id) == -1) ? "" : "checked=\"checked\"";
	
		if(isonlyleaf==1&&hasChildFlag==1){
			$li = $("<li class=\"data "+classStr+"\" style=\"background-image: url('')\"></li>");
		}else{
			$li = $("<li class=\"data "+classStr+"\"></li>");
			$li.append("<input type=\"checkbox\" class=\"valueHolder\" name=\"checkbox_hrm\" hrmId=\""+id+"\" value=\""+id+"\" "+checkedStr+"/>");
		}
		
		if(hasChildFlag==1){
			$li.append("<div class=\"expend "+cssStr+"\" data-haschild=\""+hasChildFlag+"\"></div>");
		}
		$li.append("<div class=\"one-tree-data\" data-id=\""+id+"\" data-type=\""+type+"\">"+name+"</div>");
		$treePage.append($li);
		$(".valueHolder", $li).attr("hrm_data", JSON.stringify(data));
		$li.cssCheckBox();
		
	}
	$treePage.insertAfter($obj);
	
	bindTreeEvt1($treePage);
}

/***兼容移动建模的头部***/
function hasOperationConfig(){
	return "true,,false,true,/downloadpic.do?url=/mobilemode/browser/images/ok.png?css={width:36px;height:36px;top:7px;}";
}
function toDoMiddlePageName(){
	return showTypeName;
}
function doLeftMenuConfig(){
	var $pageCenter = $("#page-center");
	if($pageCenter.hasClass("selected-result-open")){
		$pageCenter.removeClass("selected-result-open");	
	}else{
		//backpage
		var browserWin = _top._BrowserWindow;
		if(browserWin && typeof(browserWin.onBrowserBack) == "function"){
			browserWin.onBrowserBack();
		}
	}
}
function doRightMenuConfig(){
	
	var idValue = "";
	var nameValue = "";
    for(var i = 0; i < _selected_arr.length; i++){
		var selectedData = _selected_arr[i];
		idValue += selectedData["id"] + ",";
		nameValue += selectedData["lastname"] + ",";
	}
	if(idValue != ""){
		idValue = idValue.substring(0, idValue.length-1);
	}
	if(nameValue != ""){
		nameValue = nameValue.substring(0, nameValue.length-1);
	}
	var result = {
		"fieldId" : _fieldId,
		"fieldSpanId" : _fieldSpanId,
		"idValue" : idValue,
		"nameValue" : nameValue
	};
	
	
	var browserWin = _top._BrowserWindow;
	if(browserWin && typeof(browserWin.onBrowserOk) == "function"){
		browserWin.onBrowserOk(result);
	}
	return "1";
}
/******/