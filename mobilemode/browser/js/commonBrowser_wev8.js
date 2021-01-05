$.fn.cssCheckBox = function () {
	if(_browserType == "2"){	//单选
		$(".valueHolder", $(this)).each(function () {
			if (this.checked) {
				$(this).parent().addClass("checked");
			}
			
			$(this).parent().unbind("click");
			$(this).parent().click(function(){
				deCheckedAllOnPage();
				
				var $valueHolder = $(".valueHolder", this);
				var data_json = $.parseJSON($valueHolder.attr("data_json"));
				var id = data_json["id"];
				
				checkedOnPage(id);
					
				clearSelectedArr();
				addInSelectedArr(data_json);
				refreshSelectedNum();
			});
		});
	}else{	//多选
		$(".valueHolder", $(this)).each(function () {
			if (this.checked) {
				$(this).parent().addClass("checked");
			}
			
			$(this).parent().unbind("click");
			$(this).parent().click(function(){
				var $valueHolder = $(".valueHolder", this);
				
				var data_json = $.parseJSON($valueHolder.attr("data_json"));
				var id = data_json["id"];
				if($(this).hasClass("checked")){
					deCheckedOnPage(id);
					removeFromSelectedArr(data_json);
			    }else{
			    	checkedOnPage(id);
					addInSelectedArr(data_json);
			    }
			    
			    refreshSelectedNum();
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
	_params = obj["params"] || {};
	
	clearSelectedArr();	//清空已选
	deCheckedAllOnPage();	//清空页面已选
	refreshSelectedNum();	//刷新已选个数
	$(document.body).cssCheckBox();	//重新进行事件绑定
	$("#page-center").removeClass("selected-result-open");	//控制不让结果页面显示
	$("#search-key").val("");
	
	if(_browserText == ""){
		window.toDoMiddlePageName = undefined;
	}else{
		window.toDoMiddlePageName = function(){
			return _browserText;
		};
	}
	
	searchListData(true);
}
	
$(document).ready(function(){
	FastClick.attach(document.body);
	
	$("#choosedResult").html(_resultBtnText[0]+"(<span id=\"selectedNum\">0</span>)");
	$("#okResult").html(_resultBtnText[1]);
	$("#backResult").html(_resultBtnText[2]);
	$("#clearResult").html(_resultBtnText[3]);
	$("#list-loadMore").html(_resultBtnText[4]);
	
	if(_isRunInEmobile){
		$(document.body).addClass("_emobile");
	}
	
	refreshSelectedNum();
	
	initSearch();
	
	initPageControl();
	
	initHeader();
	
	if(_browserId != ""){
		searchListData(true);
	}
	
	$("#list-loadMore").click(function(){
		var $this = $(this);
		$this.addClass("click");
		setTimeout(function(){
			$this.removeClass("click");
			searchListDataMore();
		},300);
	});
	
	$("#result-data-content").click(function(e){
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

var prevSearchKey = "";
function initSearch(){
	var $searchKey = $("#search-key");
	var $srarchInner = $("#list-data-srarch .srarch-inner");
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
		if(currSearchKey != prevSearchKey){
			prevSearchKey = currSearchKey;
			searchListData();
		}
		
	});
}

function clearSearch(){
	var $searchKey = $("#search-key");
	var v = $searchKey.val();
	if(v != ""){
		$searchKey.val("");
		$searchKey.trigger("blur");
		$searchKey.trigger("input");
	}
	
}

var currPgNo = 1;
var pageSize = 10;
var pageCount = 0;
var timestamp;	//时间戳

function doSearch(pageLoad){
	$("#list-loadMore").hide();
	$("#list-loading").show();
	var url = "/mobilemode/browser/commonBrowserAction.jsp?action=getListData&pageNo="+currPgNo+"&browserId="+_browserId+"&browserName="+_browserName;
	if(pageLoad){
		url += "&selectedIds=" + _selectedIds;
	}
	
	if(typeof(_params) == "object"){
		url += "&params="+encodeURIComponent(JSON.stringify(_params));
	}
	
	if(_top._noLogin == "1"){
		url += (url.indexOf("?") == -1 ? "?" : "&") + "noLogin=" + _top._noLogin;
	}
	
	url += "&" + ((new Date()).valueOf());
	
	var $searchKey = $("#search-key");
	var searchKey = encodeURIComponent($searchKey.val());
	var _timestamp = (new Date()).valueOf();	//时间戳
	timestamp = _timestamp;
	$.get(url, {"searchKey":searchKey, "pageSize":pageSize}, function(responseText){
		if(timestamp!=_timestamp){
			return ;
		}
		$("#list-loading").hide();
		var data = $.parseJSON(responseText);
		var status = data["status"];
		if(status == "1"){
			var single = data["single"];
			_browserType = single ? "2" : "1";
			
			if(pageLoad){
				var sel_datas = data["sel_datas"];
				for(var i = 0; i < sel_datas.length; i++){
					var selectedData = sel_datas[i];
					addInSelectedArr(selectedData);
				}
				refreshSelectedNum();
			}
			
			var totalRecordCount = data["totalSize"];
			var datas = data["datas"];
			fillListDatasToPage(datas);
			pageCount = (totalRecordCount % pageSize) == 0 ? parseInt(totalRecordCount / pageSize) : (parseInt(totalRecordCount / pageSize) + 1);
			if(currPgNo >= pageCount){
				$("#list-loadMore").hide();
			}else{
				$("#list-loadMore").show();
			}
		}else{
			var errMsg = data["errMsg"];
			$("#list-data-content .data-ul").append("<div style=\"padding: 8px 12px;font-size: 16px;line-height: 22px;\">"+_resultBtnText[6]+"<br/>" + errMsg + "</div>");
		}
	});
}

function searchListData(pageLoad){
	$("#list-data-content .data-ul").find("*").remove();
	currPgNo = 1;
	doSearch(pageLoad);
}

function searchListDataMore(){
	currPgNo++;
	doSearch();
}

function fillListDatasToPage(datas){
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		var id = data["id"];	//数据id
		var objname = data["objname"];	
		var objname2 = data["objname2"];
		if(objname2 == objname) objname2 = "";
		
		var $dataUl = $("#list-data-content .data-wrap > .data-ul");
		
		var checkedStr = (indexOfSelectedArr(id) == -1) ? "" : "checked=\"checked\"";
		var $oneData = $("<li class=\"one-data\"></li>");
		$oneData.append("<input type=\"checkbox\" class=\"valueHolder\" name=\"checkbox_hrm\" dataId=\""+id+"\" value=\""+id+"\" "+checkedStr+"/>"+
						"<div class=\"data-inner\">"+
							"<div class=\"data-part1\">"+
								objname+
							"</div>"+
							"<div class=\"data-part2\">"+
								objname2+
							"</div>"+
						"</div>");
		$dataUl.append($oneData);
		
		$(".valueHolder", $oneData).attr("data_json", JSON.stringify(data));
		
		$oneData.cssCheckBox();
	}
}

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
		var dataId = $(this).attr("dataId");
		var index = indexOfSelectedArr(dataId);
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
	var $valueHolder = $(".valueHolder[dataId='"+id+"']");
	$valueHolder.attr("checked", "checked");
	$valueHolder.parent().addClass("checked");
}

function deCheckedOnPage(id){
	var $valueHolder = $(".valueHolder[dataId='"+id+"']");
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
		var id = selectedData["id"];	//数据id
		var objname = selectedData["objname"];	
		var objname2 = selectedData["objname2"];
		
		var style = "";
		if(objname2 == objname || objname2 == ""){
			style = "height: 46px;";
			objname2 = "";
		}
		
		$dataUL.append("<li class=\"one-data\" dataId=\""+id+"\" style=\""+style+"\">"+
							"<div class=\"data-inner\">"+
								"<div class=\"data-delete\"></div>"+
								"<div class=\"data-part1\">"+
									objname+
								"</div>"+
								"<div class=\"data-part2\">"+
									objname2+
								"</div>"+
								"<div class=\"data-move\"></div>"+
							"</div>"+
							
							"<div class=\"delete-data\" dataId=\""+id+"\">"+_resultBtnText[5]+"</div>"+
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
		var dataId = $(this).attr("dataId");
		removeFromSelectedArrById(dataId);
		//刷新底部选中个数
		refreshSelectedNum();
		//取消页面数据的选中状态
		deCheckedOnPage(dataId);
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
	var $srarchInner = $("#result-data-srarch .srarch-inner");
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
			var textVal = $(".data-part1", this).text();
			if(textVal.indexOf(searchKeyVal) != -1){
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

/***兼容移动建模的头部***/
function hasOperationConfig(){
	return "true,,false,false,";
}
function toDoMiddlePageName(){
	return _browserText;
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
		nameValue += selectedData["objname"] + ",";
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