var listDynamicParams = {};

Mobile_NS.List = {};

Mobile_NS.getListDynamicParam = function(mec_id){
	var listDynamicParam = listDynamicParams[mec_id];
	if(!listDynamicParam){
		listDynamicParam = {};
		listDynamicParams[mec_id] = listDynamicParam;
	}
	return listDynamicParam;
};

Mobile_NS.loadListDataWithPage = function(mec_id, totalPageCount){
	
	eval("if(typeof(pageNo" + mec_id + ") == 'undefined'){pageNo" + mec_id + " = 1}");
	eval("pageNo" + mec_id + "++;");
	eval("var listPageNo = pageNo" + mec_id + ";");
	
	var $moreBtn = $("#more" + mec_id);
	$moreBtn.hide();
	
	var $loading = $("#more_loading" + mec_id);
	if($loading.length == 0){
		$loading = $(
				"<div id=\"more_loading"+mec_id+"\"><div class=\"spinner\">" +
					"<div class=\"bounce1\"></div>" +
					"<div class=\"bounce2\"></div>" +
					"<div class=\"bounce3\"></div>" +
				"</div></div>"
		);
		$moreBtn.before($loading);
	}
	
	var listDynamicParam = Mobile_NS.getListDynamicParam(mec_id);
	
	var requestParam = {};
	for(var key in Mobile_NS.pageParams){
		requestParam[key] = Mobile_NS.pageParams[key];
	}
	for(var key in listDynamicParam){
		requestParam[key] = listDynamicParam[key];
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getListDataWithPage&mec_id="+mec_id+"&pageNo="+listPageNo);
	Mobile_NS.ajax(url, requestParam, function(data){
		$loading.hide();
		$loading.remove();
		
		var $listContainer = $("#list" + mec_id);
		
		var $tagLastLi = $(".tag", $listContainer).last();
		if($tagLastLi.length > 0){
			var lastTagValue = $tagLastLi.attr("tagValue");
			var firstTagValue = data.substring(data.indexOf("{"),data.indexOf("}")+1);
			if(lastTagValue==firstTagValue){
				data = data.substring(data.indexOf("</li>")+5);
			}
		}

		var $pageObj = $(data);
		$listContainer.append($pageObj);
		
		if(listPageNo >= totalPageCount){
			$moreBtn.hide();
		}else{
			$moreBtn.show();
		}
		
		Mobile_NS.imgLazyload($pageObj);
		
		$("table a, *[stopPropagation='true']", $pageObj).on("click", function(e){
			e.stopPropagation();
		});
		
		Mobile_NS.swipeListData(mec_id);
		
		Mobile_NS.bindListDataEvent(mec_id);
		
		refreshIScroll();
		
		if(top && typeof(top.resetActiveFrame) == "function"){
			top.resetActiveFrame();
		}
		
		Mobile_NS.triggerPageChange({
			id : mec_id,
			type : "pageList"
		});
		
	});
};

Mobile_NS.List.refreshTimestamp = {};

Mobile_NS.List.refreshList = function(mec_id, listparams, callbackFn){
	
	if(!mec_id || mec_id == ""){	//没有列表组件id，取页面第一个列表组件的id
		var $listContainer = $(".listContainer");
		if($listContainer.length > 0){
			var listid = $listContainer.attr("id");
			mec_id = listid.substring("list".length);
		}else{	//不存在列表插件
			return;
		}
	}else{
		var $listContainer = $("#list" + mec_id);
		if($listContainer.length == 0){	//找不到指定id的列表
			return;
		}
	}
	
	var timestamp = (new Date()).valueOf();	//时间戳
	Mobile_NS.List.refreshTimestamp[mec_id] = timestamp;
	
	var listDynamicParam = Mobile_NS.getListDynamicParam(mec_id);
	
	if(listparams){
		var listparamArr = listparams.split(";");
		for(var i = 0; i < listparamArr.length; i++){
			var oneParam = listparamArr[i];
			var pIndex = oneParam.indexOf("=");
			if(pIndex != -1){
				var paramName = oneParam.substring(0, pIndex);
				var paramValue = oneParam.substring(pIndex + 1);
				listDynamicParam[paramName] = paramValue;
			}
		}
	}
	
	var requestParam = {};
	for(var key in Mobile_NS.pageParams){
		requestParam[key] = Mobile_NS.pageParams[key];
	}
	for(var key in listDynamicParam){
		requestParam[key] = listDynamicParam[key];
	}
	
	eval("pageNo" + mec_id + " = 1;");
	
	var $listContainer = $("#list" + mec_id);
	$listContainer.find("*").remove();
	
	var $listMore = $("#more" + mec_id);
	$listMore.remove();
	
	var $listNodata = $("#nodata" + mec_id);
	$listNodata.remove();
	
	var $listWarn = $(".listWarn" + mec_id);
	$listWarn.remove();
	
	$("#more_loading" + mec_id).remove();
	
	var $mecContainer = $("#NMEC_" + mec_id);
	var $loading = $(".mec_refresh_loading", $mecContainer);
	if($loading.length == 0){
		$loading = $(
				"<div class=\"mec_refresh_loading\"><div class=\"spinner\">" +
					"<div class=\"bounce1\"></div>" +
					"<div class=\"bounce2\"></div>" +
					"<div class=\"bounce3\"></div>" +
				"</div></div>"
		);
		$mecContainer.append($loading);
	}
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=refreshListData&mec_id="+mec_id+"&pageNo=1");
	Mobile_NS.ajax(url, requestParam, function(data){
		
		if(timestamp != Mobile_NS.List.refreshTimestamp[mec_id]){
			return;
		}
		
		$loading.hide();
		$loading.remove();
		
		var resultObj = $.parseJSON(data);
		
		var listDataHtml = resultObj["listDataHtml"];
		var pageBtnHtml = resultObj["pageBtnHtml"];
		
		$listContainer.append(listDataHtml);
		
		if($.trim(pageBtnHtml) != ""){
			$listContainer.after(pageBtnHtml);
			$listContainer.parent().trigger("create");	//触发jqm渲染
		}
		
		Mobile_NS.imgLazyload($listContainer);
		
		$("li > table a, *[stopPropagation='true']", $listContainer).on("click", function(e){
			e.stopPropagation();
		});
		
		Mobile_NS.swipeListData(mec_id);
		
		Mobile_NS.bindListDataEvent(mec_id);
		
		refreshIScroll();
		
		if(top && typeof(top.resetActiveFrame) == "function"){
			top.resetActiveFrame();
		}
		
		if(typeof(callbackFn) == "function"){
			callbackFn.call(window);
		}
		
		Mobile_NS.triggerPageChange({
			id : mec_id,
			type : "refreshList"
		});
	});
};

Mobile_NS.searchList = function(mec_id){
	var $searchKey = $("#listsearch"+mec_id+" .searchKey");
	var listparams = "searchKey=" + encodeURIComponent($searchKey.val());
	Mobile_NS.List.refreshList(mec_id, listparams);
	$searchKey[0].blur();
};

Mobile_NS.swipeListData = function(id){
	var $list = $("#list"+id).filter("[swipe='true']");
	if($list.length > 0){
		var type = $list.attr("swipeType");
		if(!type || type == ""){
			type = "1";
		}
		$list.children("li").each(function(){
			var $li = $(this);
			if($li.attr('swipe_event') != "true"){
				
				var bodyTouch = util.toucher($li[0]);
				
				bodyTouch.on('swipeLeft',function(e){
					
					var $theLi = $(this);
					
					var pdFn = function(e){
						e.preventDefault();
					};
					
					$theLi[0].addEventListener('touchmove', pdFn, false);
					setTimeout(function(){
						$theLi[0].removeEventListener("touchmove", pdFn, false);
					}, 300);
					
					
					//向左滑动时先复原其他已被划出的LI
					$theLi.siblings("[is_swiped='true']").trigger("swipeRight");
					
					var $slideBtnContainer = $(".slideBtnContainer", $theLi);
					var w = $slideBtnContainer.width();
					
					var $table = $theLi.children("table");
					if(type == "1"){
						$table.css({
							"-webkit-transform" : "translate3d(-"+w+"px, 0, 0)",
							"transform" : "translate3d(-"+w+"px, 0, 0)"
						});
						$slideBtnContainer.addClass("show");
					}else if(type == "2"){
						$slideBtnContainer.addClass("show");
					}
					$theLi.attr("is_swiped", "true");
					
					
					
				});
				
				var rightFn = function(e){
					var $theLi = $(this);
					
					var pdFn = function(e){
						e.preventDefault();
					};
					
					$theLi[0].addEventListener('touchmove', pdFn, false);
					setTimeout(function(){
						$theLi[0].removeEventListener("touchmove", pdFn, false);
					}, 300);
					
					var $slideBtnContainer = $(".slideBtnContainer", $theLi);
					var $table = $theLi.children("table");
					var w = $slideBtnContainer.width();
					
					if(type == "1"){
						$slideBtnContainer.removeClass("show");
						$table.css({
							"-webkit-transform" : "translate3d(0, 0, 0)",
							"transform" : "translate3d(0, 0, 0)"
						});
					}else if(type == "2"){
						$slideBtnContainer.removeClass("show");
					}
					$theLi.removeAttr("is_swiped");
				};
				
				bodyTouch.on('swipeRight', rightFn);
				$li.on('swipeRight', rightFn)
				
				Mobile_NS.initTapEvent($(".slideBtnContainer", $li));
				
				Mobile_NS.onTap($(".slideBtnContainer", $li), function(e){
					$(this).parent().trigger("swiperight");
					e.stopPropagation();
				});
			}
		});
		
		$list.children("li").attr("swipe_event", "true");
	}
};

Mobile_NS.bindListDataEvent = function(id){
	$("#list"+id).children("li").each(function(){
		var $li = $(this);
		if($li.attr('dataurl_bind') != "true"){
			if($li.length > 0){
				
				Mobile_NS.onTap($li, function(){
					var dataurl = $(this).attr("dataurl");
					if(dataurl && dataurl != ""){
						if(dataurl.indexOf("javascript") == 0){
							var dataurl = decodeURIComponent(dataurl);
							var script = dataurl.substring("javascript:".length);
							eval(script);
						}else{
							openDetail(dataurl, this);
						}
					}
				});
				$li.attr("dataurl_bind", "true");
				
				Mobile_NS.initTapEvent($li.children("table"), true);
			}
		}
	});
	
	var $btnBox = $("#list" + id + " .btnBox");
	if($btnBox.length > 0){
		Mobile_NS.onTap($btnBox, function(){
			var script = $(this).attr("script");
			if(script && script != ""){
				script = decodeURIComponent(script);
				eval(script);
			}
		});
	}
};

Mobile_NS.bindListBtnEvent = function(id){
	var $listBtn = $("#listsearch" + id + " .listBtn");
	var $btns = $(".lbtn", $listBtn);
	if($btns.length > 0){
		var w = $listBtn.width() + 8;
		$("#listsearch" + id + " .listHeader").css("right", w+"px");
		Mobile_NS.onTap($btns, function(){
			var script = $(this).attr("script");
			if(script && script != ""){
				script = decodeURIComponent(script);
				eval(script);
			}
		});
	}
};

Mobile_NS.showAdvancedSearch = function(id){
	var $advancedSearch = $("#as-container-" + id);
	$advancedSearch.addClass("searching");
	
	if(typeof(refreshRightViewScroll) == "function"){
		refreshRightViewScroll();
	}
	
	$(document.body).addClass("right_view_open");
	
	Mobile_NS.setViewOpen(Mobile_NS.hideAdvancedSearch);
};

Mobile_NS.hideAdvancedSearch = function(){

	$(document.body).removeClass("right_view_open");
	
	setTimeout(function(){
		var $advancedSearch = $(".as-container");
		$advancedSearch.removeClass("searching");
		
	},300);
};

Mobile_NS.List.autoShowAdvancedSearch = function(id){
	var $advancedSearch = $("#as-container-" + id);
	$advancedSearch.addClass("searching").css("visibility", "hidden");
	
	if(typeof(refreshRightViewScroll) == "function"){
		refreshRightViewScroll();
	}
	
	$(document.body).addClass("right_view_open");
	
	setTimeout(function(){
		$("#page_view").css("visibility", "visible");
	}, 300);
	
	eval("window.asAutoShow_" + id + " = true;");
};

Mobile_NS.List.initDate = function(eleid, eletype){
	var currYear = (new Date()).getFullYear();	
	var opt={};
	var _userlang = _multiListJson['userlang'] || 7;
	opt.date = {preset : 'date', dateFormat : "yy-mm-dd"};
	opt.datetime = {preset : 'datetime', width : 40};
	opt.time = {preset : 'time'};
	opt.defa = {
		theme: 'android-ics light', //皮肤样式
        display: 'modal', //显示方式 
        mode: 'scroller', //日期选择模式
		lang:_userlang == 8 ? 'en' : 'zh',
        startYear:currYear - 10, //开始年份
        endYear:currYear + 10 //结束年份
	};
	
	var $field = $("#" + eleid);
	if(eletype == "date"){
		var optCurr = $.extend(opt['date'], opt['defa']);
		$field.mobiscroll(optCurr).date(optCurr);
	}else if(eletype == "time"){
		var optCurr = $.extend(opt['time'], opt['defa']);
		$field.mobiscroll(optCurr).time(optCurr);
	}
};

Mobile_NS.List.initAdvancedSearchContent = function(mec_id){
	var $advancedSearch = $("#as-container-" + mec_id);
	
	var url = "/mobilemode/MECAction.jsp?action=method:getAdvancedSearchConfig&mec_id="+mec_id;
	Mobile_NS.ajax(url, Mobile_NS.pageParams, function(responseText){
		
		var $asContent = $(".as-content", $advancedSearch);
		var data = $.parseJSON(responseText);
		for(var i = 0; i < data.length; i++){
			var oneData = data[i];
			var fieldid = oneData["fieldid"];
			var fieldname = oneData["fieldname"];
			var showname = oneData["showname"];
			var htmltype = oneData["htmltype"];
			
			if(htmltype == "6" || htmltype == "7"){//过滤掉附件和特殊字段，不显示查询
				continue;
			}
			
			var isDateTime = false;
			var dateTimeType;
			
			var $fieldWrap = $("<div class=\"field-wrap\"></div>");
			var $fieldLabel = $("<div class=\"field-label\">"+showname+"<div class=\"separater\"></div></div>");
			var $fieldContent = $("<div class=\"field-content\"></div>");
			
			if(htmltype == "5"){	/*select*/
				$fieldWrap.addClass("select-field");
				var _h = "<select search=\"true\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\" fieldtype=\"select\">";
				_h += "<option></option>";
				
				var fieldData = oneData["data"];
				for(var dd = 0; dd < fieldData.length; dd++){
					_h += "<option value=\""+fieldData[dd]["selectvalue"]+"\">"+fieldData[dd]["selectname"]+"</option>";
				}
				
				_h += "</select>";
				$fieldContent.append(_h);
			}else if(htmltype == "3"){	/*browser*/
				var browserId = oneData["browserId"];
				var browserName = oneData["browserName"];
				
				if(browserId == "2"){//日期
					$fieldWrap.addClass("date-field");
					$fieldContent.append(
						"<div search=\"true\" fieldtype=\"date\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\" style=\"height:100%;\">" +
							"<table class=\"rangeSearchTable\">" +
								"<tr>" +
									"<td class=\"rangeSearchcol1\">" +
									"<input class=\"needsclick\" id=\"_as_fieldstart"+fieldid+"\" type=\"text\" placeholder=\""+_multiListJson['740']+"\" data-clear-btn=\"false\" onchange=\"Mobile_NS.List.showClearBtn('fieldstart', "+fieldid+");\">" +//开始日期
									"<div class=\"dataClean\" id=\"fieldstart"+fieldid+"\"></div>" +
									"</td>" +
									"<td class=\"rangeSearchcol2\"><div class=\"field_range_separater\"></div></td>" +
									"<td class=\"rangeSearchcol3\">" +
									"<input class=\"needsclick\" id=\"_as_fieldend"+fieldid+"\" type=\"text\" placeholder=\""+_multiListJson['741']+"\" data-clear-btn=\"false\" onchange=\"Mobile_NS.List.showClearBtn('fieldend', "+fieldid+");\">" +//结束日期
									"<div class=\"dataClean\" id=\"fieldend"+fieldid+"\"></div>" +
									"</td>" +
								"</tr>" +
							"</table>" +
						"</div>"
					);
					
					isDateTime = true;
					dateTimeType = "date";
				}else if(browserId == "19"){//时间
					$fieldWrap.addClass("time-field");
					$fieldContent.append(
						"<div search=\"true\" fieldtype=\"time\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\" style=\"height:100%;\">" +
							"<table class=\"rangeSearchTable\">" +
								"<tr>" +
									"<td class=\"rangeSearchcol1\">" +
									"<input class=\"needsclick\" id=\"_as_fieldstart"+fieldid+"\" type=\"text\" placeholder=\""+_multiListJson['742']+"\" data-clear-btn=\"false\" onchange=\"Mobile_NS.List.showClearBtn('fieldstart', "+fieldid+");\">" +//开始时间
									"<div class=\"dataClean\" id=\"fieldstart"+fieldid+"\"></div>" +
									"</td>" +
									"<td class=\"rangeSearchcol2\"><div class=\"field_range_separater\"></div></td>" +
									"<td class=\"rangeSearchcol3\">" +
									"<input class=\"needsclick\" id=\"_as_fieldend"+fieldid+"\" type=\"text\" placeholder=\""+_multiListJson['743']+"\" data-clear-btn=\"false\" onchange=\"Mobile_NS.List.showClearBtn('fieldend', "+fieldid+");\">" +//结束时间
									"<div class=\"dataClean\" id=\"fieldend"+fieldid+"\"></div>" +
									"</td>" +
								"</tr>" +
							"</table>" +
						"</div>"
					);
					
					isDateTime = true;
					dateTimeType = "time";
				}else{
					var single = oneData["single"];
					$fieldWrap.addClass("browser-field");
					$fieldContent.append(
							"<input id=\"_as_field"+fieldid+"\" type=\"hidden\" search=\"true\" single=\""+single+"\" fieldtype=\"browser\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>" +
							"<div class=\"browser-name-wrap\">" +
								"<span id=\"_as_field"+fieldid+"span\" class=\"browser-name\" onclick=\"Mobile_NS.openBrowser('_as_field"+fieldid+"', '_as_field"+fieldid+"span', '"+browserId+"', '"+browserName+"', '"+showname+"');\"></span>" +
								"<div class=\"browser-clear-btn\" onclick=\"Mobile_NS.clearBrowser('_as_field"+fieldid+"', '_as_field"+fieldid+"span');\"></div>" +
							"</div>" +
							"<div class=\"browser-flag\" onclick=\"Mobile_NS.openBrowser('_as_field"+fieldid+"', '_as_field"+fieldid+"span', '"+browserId+"', '"+browserName+"', '"+showname+"');\"></div>"
					);
				}
			}else if(htmltype == "4"){	/*checkbox*/
				$fieldWrap.addClass("checkbox-field");
				$fieldContent.append(
					"<input id=\"_as_field"+fieldid+"\" type=\"hidden\" search=\"true\" fieldtype=\"checkbox\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>" +
					"<div fieldid=\""+fieldid+"\" class=\"toggle\">" +
						"<div class=\"toggle-handle\"></div>" +
					"</div>"
				);
				$(".toggle", $fieldContent).click(function(){
					var tg_fieldid = $(this).attr("fieldid");
					if($(this).hasClass("active")){
						$(this).removeClass("active");
						$("#_as_field"+tg_fieldid).val("0");
					}else{
						$(this).addClass("active");
						$("#_as_field"+tg_fieldid).val("1");
					}
				});
			}else if(htmltype == "2"){/*多行*/
				$fieldWrap.addClass("textarea-field");
				$fieldContent.append("<input type=\"text\" placeholder=\""+_multiListJson['4170']+"\" fieldtype=\"textarea\" search=\"true\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>");//请输入...
			}else if(htmltype == "1"){/*单行*/
				var textType = oneData["textType"];
				if(textType == "1"){//文本
					$fieldWrap.addClass("text-field");
					$fieldContent.append("<input type=\"text\" placeholder=\""+_multiListJson['4170']+"\" fieldtype=\"text\" search=\"true\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>");//请输入...
				}else if(textType == "5"){//金额千分位
					$fieldWrap.addClass("thousandnumb-field");
					$fieldContent.append(
						"<div search=\"true\" fieldtype=\"thousandnumb\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\" style=\"height:100%;\">" +
							"<table class=\"rangeSearchTable\">" +
								"<tr>" +
									"<td class=\"rangeSearchcol1\"><input id=\"_as_fieldstart"+fieldid+"\" type=\"number\" placeholder=\""+_multiListJson['383810']+"\" data-clear-btn=\"false\"></td>" +//大于等于
									"<td class=\"rangeSearchcol2\"><div class=\"field_range_separater\"></div></td>" +
									"<td class=\"rangeSearchcol3\"><input id=\"_as_fieldend"+fieldid+"\" type=\"number\" placeholder=\""+_multiListJson['383811']+"\" data-clear-btn=\"false\"></td>" +//小于等于
								"</tr>" +
							"</table>" +
						"</div>"
					);
				}else{//整数，浮点数，金额转换
					$fieldWrap.addClass("numb-field");
					$fieldContent.append(
						"<div search=\"true\" fieldtype=\"numb\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\" style=\"height:100%;\">" +
							"<table class=\"rangeSearchTable\">" +
								"<tr>" +
									"<td class=\"rangeSearchcol1\"><input id=\"_as_fieldstart"+fieldid+"\" type=\"number\" placeholder=\""+_multiListJson['383810']+"\" data-clear-btn=\"false\"></td>" +//大于等于
									"<td class=\"rangeSearchcol2\"><div class=\"field_range_separater\"></div></td>" +
									"<td class=\"rangeSearchcol3\"><input id=\"_as_fieldend"+fieldid+"\" type=\"number\" placeholder=\""+_multiListJson['383811']+"\" data-clear-btn=\"false\"></td>" +//小于等于
								"</tr>" +
							"</table>" +
						"</div>"
					);
				}
			}else{/*上面已经过滤了附件和特殊字段，如果ecology增加新的字段类型，默认为text*/
				$fieldWrap.addClass("text-field");
				$fieldContent.append("<input type=\"text\" placeholder=\""+_multiListJson['4170']+"\" fieldtype=\"text\" search=\"true\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>");//请输入...
			}
			
			
			$fieldWrap.append($fieldLabel);
			$fieldWrap.append($fieldContent);
			
			$asContent.append($fieldWrap);
			
			if(isDateTime){
				Mobile_NS.List.initDate("_as_fieldstart"+fieldid, dateTimeType);
				Mobile_NS.List.initDate("_as_fieldend"+fieldid, dateTimeType);
			}
			
		}
		
		$advancedSearch.css("visibility", "visible");
	});
	
	var $searchBtn = $(".as-btn-wrap .search", $advancedSearch);
	$searchBtn.on("click", function(){
		eval("var asAutoShow = window.asAutoShow_" + mec_id + ";");
		if(typeof(asAutoShow) != "undefined" && asAutoShow == true){
			asAutoShow = false;
			Mobile_NS.hideAdvancedSearch(); //手动关闭(不依赖返回)
		}else{
			if(typeof(isShowInTabV) != "undefined" && isShowInTabV == "1"){ //tab页中嵌入模块查询列表采用手动关闭(不依赖返回)
				Mobile_NS.hideAdvancedSearch();
			}else{
				Mobile_NS.backPage();
			}
		}
		
		var _asArray = [];
		$("[search='true']", $advancedSearch).each(function(){
			var _as = {};
			if($(this).attr("fieldtype") == "date" || $(this).attr("fieldtype") == "time" || $(this).attr("fieldtype") == "numb" || $(this).attr("fieldtype") == "thousandnumb"){//单独处理日期或者时间，数字
				var as_fieldid = $(this).attr("fieldid");
				var $_as_fieldstart = $("#_as_fieldstart" + as_fieldid);
				var $_as_fieldend = $("#_as_fieldend" + as_fieldid);
				var _as_fieldstartValue = $_as_fieldstart.val();
				var _as_fieldendValue = $_as_fieldend.val();
				if(_as_fieldstartValue != "" || _as_fieldendValue != ""){
					_as["fieldname"] = $(this).attr("fieldname");
					_as["fieldvalue"] = _as_fieldstartValue + "," + _as_fieldendValue;
					_as["fieldtype"] = $(this).attr("fieldtype");
					_asArray.push(_as);
				}
			}else{
				var v = $.trim($(this).val());
				if(v != ""){
					_as["fieldname"] = $(this).attr("fieldname");
					_as["fieldvalue"] = v;
					_as["fieldtype"] = $(this).attr("fieldtype");
					if($(this).attr("fieldtype") == "browser"){
						_as["single"] = $(this).attr("single");
					}
					_asArray.push(_as);
				}
			}
		});
		var listparams = "_asArray=" + encodeURIComponent(JSON.stringify(_asArray));
		setTimeout(function(){
			Mobile_NS.List.refreshList(mec_id, listparams);
		}, 300);
	});
	
	var $clearBtn = $(".as-btn-wrap .clear", $advancedSearch);
	$clearBtn.on("click", function(){
		$("[search='true']", $advancedSearch).each(function(){
			var fieldtype = $(this).attr("fieldtype");
			if(fieldtype == "browser"){
				$(this).parent().children(".browser-name-wrap").removeClass("hasValue")
								.children(".browser-name").html("");
			}else if(fieldtype == "checkbox"){
				$(this).parent().children(".toggle").removeClass("active");
			}else if(fieldtype == "date" || fieldtype == "time" || fieldtype == "numb" || fieldtype == "thousandnumb"){
				$(this).find(".rangeSearchcol1").find("input").val("");
				$(this).find(".rangeSearchcol3").find("input").val("");
				$(this).find(".rangeSearchcol1").find(".dataClean").unbind().hide();
				$(this).find(".rangeSearchcol3").find(".dataClean").unbind().hide();
			}
			$(this).val("");
		});
		/*$searchBtn.trigger("click");*/
	});
};

Mobile_NS.List.showClearBtn = function(z, fieldid){
	var $clearBtn = $("#"+z+fieldid);
	$clearBtn.show();
	$clearBtn.click(function(e){
		e.stopPropagation();
		var fieldval = $("#_as_"+z+fieldid).val();
		if(fieldval && fieldval != ""){
			$("#_as_"+z+fieldid).val("");
			$clearBtn.hide();
			$clearBtn.unbind();
		}
	});
}
