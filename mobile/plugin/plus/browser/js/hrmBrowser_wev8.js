$.fn.cssCheckBox = function () {
	if(_browserType == "2"){	//��ѡ
		$(".valueHolder", $(this)).each(function () {
			if (this.checked) {
				$(this).parent().addClass("checked");
			}
			
			$(this).parent().unbind("click");
			$(this).parent().click(function(){
				deCheckedAllOnPage();
				
				var $valueHolder = $(".valueHolder", this);
				var hrm_data = $.parseJSON($valueHolder.attr("hrm_data"));
				var id = hrm_data["id"];
				
				checkedOnPage(id);
					
				clearSelectedArr();
				addInSelectedArr(hrm_data);
				refreshSelectedNum();
			});
		});
	}else{	//��ѡ
		$(".valueHolder", $(this)).each(function () {
			if (this.checked) {
				$(this).parent().addClass("checked");
			}
			
			$(this).parent().unbind("click");
			$(this).parent().click(function(){
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
			});
		});
	}
};


function resetBrowser(obj){
	_fieldId = obj["fieldId"] || "";
	_fieldSpanId = obj["fieldSpanId"] || "";
	_browserType = obj["browserType"] || "1";
	var selectedIds = obj["selectedIds"] || "";
	
	
	$("#list-hrm-content > .group-wrap").hide();
	setTimeout(function(){
		$("#list-hrm-content > .group-wrap").show();
	}, 0);
	
	clearSelectedArr();	//�����ѡ
	deCheckedAllOnPage();	//���ҳ����ѡ
	refreshSelectedNum();	//ˢ����ѡ����
	$(document.body).cssCheckBox();	//���½����¼���
	$("#page-center").removeClass("selected-result-open");	//���Ʋ��ý��ҳ����ʾ
	
	//�첽������ѡ
	if(selectedIds != ""){
		var url = "//mobile/plugin/plus/browser/hrmBrowserAction.jsp?action=getSelectedDatas&selectedIds=" + selectedIds;
		//window.prompt("",url);
		$.get(url, null, function(responseText){
			responseText = $.trim(responseText);
			var data = $.parseJSON(responseText);
			var status = data["status"];
			if(status == "1"){
				var datas = data["datas"];
				for(var i = 0; i < datas.length; i++){
					var selectedData = datas[i];
					checkedOnPage(selectedData.id);
					addInSelectedArr(selectedData);
				}
				refreshSelectedNum();
			}
		});
	}
}
	
$(document).ready(function(){
	FastClick.attach(document.body);
	
	if(_isRunInEmobile){
		$(document.body).addClass("_emobile");
	}
	
	refreshSelectedNum();
	
	initSearch();
	
	initPageControl();
	
	initHeader();
	
	searchListData();
	
	$("#list-loadMore").click(function(){
		var $this = $(this);
		$this.addClass("click");
		setTimeout(function(){
			$this.removeClass("click");
			searchListDataMore();
		},300);
	});
	
	var $rootTreePage = $("#tree-org-container .root-tree-page");
	bindTreeEvt($rootTreePage);
	var $rootTreeData = $rootTreePage.children("li").children(".one-tree-data");
	$rootTreeData.trigger("click");
	
	$("#result-hrm-content").click(function(e){
		$("li.beDelete", this).removeClass("beDelete");
	});	
	$("#clearResult").click(function(e){
		//ɾ������
		clearSelectedArr();
		//ˢ�µײ�ѡ�и���
		refreshSelectedNum();
		//ȡ��ҳ�����ݵ�ѡ��״̬
		deCheckedAllOnPage();
		
		//ҳ����ɾ��
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
	var $srarchInner = $("#list-hrm-srarch .srarch-inner");
	$(".search-holder", $srarchInner).click(function(){
		$srarchInner.addClass("searching");
		$searchKey[0].focus();
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
var pageSize = 100;
var pageCount = 0;

function doSearch(){
	$("#list-loadMore").hide();
	$("#list-loading").show();
	var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp?action=getListData&pageNo="+currPgNo;
	var $searchKey = $("#search-key");
	var searchKey = encodeURIComponent($searchKey.val());
	$.get(url, {"searchKey":searchKey, "pageSize":pageSize}, function(responseText){
		$("#list-loading").hide();
		var data = $.parseJSON(responseText);
		var status = data["status"];
		if(status == "1"){
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
			$("#list-hrm-content > .group-wrap").append("��������ʱ���ִ���" + errMsg);
		}
	});
}

function searchListData(){
	$("#list-hrm-content > .group-wrap").find("*").remove();
	currPgNo = 1;
	doSearch();
}

function searchListDataMore(){
	currPgNo++;
	doSearch();
}

function fillListDatasToPage(datas){
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		var id = data["id"];	//��Աid
		var lastname = data["lastname"];	//����
		var lastname_py = data["lastname_py"];	//ƴ��
		var departmentName = data["departmentName"];	//��������
		var jobTitlesName = data["jobTitlesName"];	//��λ����
		var subCompanyName = data["subCompanyName"]	//�ֲ�����
		
		var $group = $("#list-hrm-content > .group-wrap > .group[group_id='"+lastname_py+"']");
		if($group.length == 0){
			$group = $("<div class=\"group\" group_id=\""+lastname_py+"\"></div>");
			$group.append("<div class=\"group-title\">"+lastname_py+"</div>");
			$group.append("<ul class=\"group-data muti\"></ul>");
			$("#list-hrm-content > .group-wrap").append($group);
		}
		
		var $groupData = $group.children(".group-data");
		
		var checkedStr = (indexOfSelectedArr(id) == -1) ? "" : "checked=\"checked\"";
		var $oneData = $("<li class=\"one-data\"></li>");
		$oneData.append("<input type=\"checkbox\" class=\"valueHolder\" name=\"checkbox_hrm\" hrmId=\""+id+"\" value=\""+id+"\" "+checkedStr+"/>"+
						"<div class=\"data-inner\">"+
							"<div class=\"data-avatar\">"+
								"<div></div>"+
							"</div>"+
							"<div class=\"data-part1\">"+
								"<div class=\"data-lastname\">"+lastname+"</div>"+
								"<div class=\"data-subCompany\">"+subCompanyName+"</div>"+
							"</div>"+
							"<div class=\"data-part2\">"+
								"<div class=\"data-jobTitle\">"+jobTitlesName+"</div>"+
								"<div class=\"data-department\">"+departmentName+"</div>"+
							"</div>"+
						"</div>");
		$groupData.append($oneData);
		
		$(".valueHolder", $oneData).attr("hrm_data", JSON.stringify(data));
		
		$oneData.cssCheckBox();
	}
}

function initPageControl(){
	var $page = $("#page-center");
	var $centerContent = $("#center-content");
	var $pageControl = $("#page-control");
	
	$("#page-control").click(function(){
		$page.toggleClass("control-open");
	});
	
	$("#page-mask").click(function(){
		$page.removeClass("control-open");
	});
	
	$("#control-hrm").click(function(){
		$page.removeClass("control-open");
		if(!$pageControl.hasClass("hrm")){
			$pageControl[0].className = "hrm";
			showTypeName = "������";
			$(".control-text", $pageControl).html(showTypeName);
			changeHeaderTitle();
		}
		
		if(!$centerContent.hasClass("hrm")){
			$centerContent[0].className = "hrm";
		}
	});
	
	$("#control-org").click(function(){
		$page.removeClass("control-open");
		if(!$pageControl.hasClass("org")){
			$pageControl[0].className = "org";
			showTypeName = "��֯�ܹ�";
			$(".control-text", $pageControl).html(showTypeName);
			changeHeaderTitle();
		}
		
		if(!$centerContent.hasClass("org")){
			$centerContent[0].className = "org";
		}
	});
	
	$("#control-group").click(function(){
		$page.removeClass("control-open");
	});
	
	$("#choosedResult").click(function(){
		resetSelectedResultSearch();
		buildSelectedResultPage();
		initSelectedResultPageEvt();
		$page.addClass("selected-result-open");
	});
}

function changeHeaderTitle(){
	$("#nav-header .header-center").html(showTypeName);
	if(typeof(top.changeMiddlePageName) == "function"){
		top.changeMiddlePageName();
	}
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
		var id = selectedData["id"];	//��Աid
		var lastname = selectedData["lastname"];	//����
		var departmentName = selectedData["departmentName"];	//��������
		var jobTitlesName = selectedData["jobTitlesName"];	//��λ����
		var subCompanyName = selectedData["subCompanyName"]	//�ֲ�����
		
		$dataUL.append("<li class=\"one-data\" hrmId=\""+id+"\">"+
							"<div class=\"data-inner\">"+
								"<div class=\"data-delete\"></div>"+
								"<div class=\"data-part1\">"+
									"<div class=\"data-lastname\">"+lastname+"</div>"+
									"<div class=\"data-subCompany\">"+subCompanyName+"</div>"+
								"</div>"+
								"<div class=\"data-part2\">"+
									"<div class=\"data-jobTitle\">"+jobTitlesName+"</div>"+
									"<div class=\"data-department\">"+departmentName+"</div>"+
								"</div>"+
								"<div class=\"data-move\"></div>"+
							"</div>"+
							
							"<div class=\"delete-data\" hrmId=\""+id+"\">ɾ��</div>"+
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
		//ɾ������
		var hrmId = $(this).attr("hrmId");
		removeFromSelectedArrById(hrmId);
		//ˢ�µײ�ѡ�и���
		refreshSelectedNum();
		//ȡ��ҳ�����ݵ�ѡ��״̬
		deCheckedOnPage(hrmId);
		//ҳ����ɾ��
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
	$(".search-holder", $srarchInner).click(function(){
		$srarchInner.addClass("searching");
		$searchKey[0].focus();
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

function bindTreeEvt($wrap){
	$(".one-tree-data[data-haschild='1']", $wrap).click(function(){
		var $oneTreeData = $(this);
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
				//�ӷ���˼���
				var $treeLoading = $("<div class=\"tree-loading\"></div>");
				$treeLoading.insertAfter($oneTreeData);
				
				var dataType = $oneTreeData.attr("data-type");
				var dataId = $oneTreeData.attr("data-id");
				
				var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp?action=getTreeData&type="+dataType+"&pid="+dataId;
								
				$.get(url, null, function(responseText){
					$treeLoading.remove();
					
					var data = $.parseJSON(responseText);
					var status = data["status"];
					if(status == "1"){
						var datas = data["datas"];
						fillTreeDatasToPage(datas, $oneTreeData);
					}else{
						var errMsg = data["errMsg"];
						alert("��������ʱ���ִ���" + errMsg);
						
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
	});
}

function fillTreeDatasToPage(datas, $obj){
	var $treePage = $("<ul class=\"tree-page\"></ul>");
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		var id = data["id"];	//id
		var name = data["name"];	//����
		var type = data["type"];	//����
		
		var $li;
		if(type == "4"){	//��Ա
			$li = $("<li class=\"hrm\"></li>");
			var checkedStr = (indexOfSelectedArr(id) == -1) ? "" : "checked=\"checked\"";
			$li.append("<input type=\"checkbox\" class=\"valueHolder\" name=\"checkbox_hrm\" hrmId=\""+id+"\" value=\""+id+"\" "+checkedStr+"/>"+
					   "<div class=\"one-tree-data\">"+
							"<div class=\"data-avatar\">"+
								"<div></div>"+
							"</div>"+
							"<div class=\"data-name\">"+
								name+
							"</div>"+
						"</div>");
			$treePage.append($li);
			$(".valueHolder", $li).attr("hrm_data", JSON.stringify(data));
			$li.cssCheckBox();
		}else{
			var hasChild = data["hasChild"];	//�Ƿ����ӽڵ�
			var hasChildFlag = hasChild ? "1" : "0"; 
			var cssStr = hasChild ? "closed" : "";
		
			$li = $("<li></li>");
			$li.append("<div class=\"one-tree-data "+cssStr+"\" data-id=\""+id+"\" data-type=\""+type+"\" data-haschild=\""+hasChildFlag+"\">"+name+"</div>");
			$treePage.append($li);
		}
		
	}
	$treePage.insertAfter($obj);
	
	bindTreeEvt($treePage);
}
/***�����ƶ���ģ��ͷ��***/
function hasOperationConfig(){
	return "true,,false,true,/downloadpic.do?url=/mobile/plugin/plus/browser/images/ok.png?css={width:36px;height:36px;top:7px;}";
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
		var browserWin = top._BrowserWindow;
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
	
	var browserWin = top._BrowserWindow;
	if(browserWin && typeof(browserWin.onBrowserOk) == "function"){
		browserWin.onBrowserOk(result);
	}
	return "1";
}
/******/