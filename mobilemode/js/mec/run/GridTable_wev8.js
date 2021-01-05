Mobile_NS.GridTable = {};

Mobile_NS.GridTable.onload = function(mec_id){
	this.bindEvent(mec_id);

	this.bindDataEvent(mec_id);
	
	this.groupSum(mec_id);
	
	this.resetGridColumnWidth(mec_id);
	
	this.initAdvancedSearch(mec_id);
	
	this.buildFixedColumn(mec_id);
	
	this.fixTableWidthStr(mec_id);
	
};

Mobile_NS.GridTable.bindEvent = function(mec_id){
	var that = this;
	
	$("#gtsearch"+mec_id+" .searchBtn").click(function(){
		that.search(mec_id);
	});
	
	$("#gtsearch"+mec_id+" form[disabledEnterSubmit]").keydown(function(event){
		var keyCode = event.keyCode;
		if(keyCode == 13){
			return false;
		}
	});
	
	$("#gtsearch"+mec_id+" .searchKey").keyup(function(event){
		var keyCode = event.keyCode;
		if(keyCode == 13){
			that.search(mec_id);
		}
	});
	
	var $gtbtn_wrap = $("#gtsearch" + mec_id + " .gtbtn_wrap");
	var $btns = $(".gtbtn", $gtbtn_wrap);
	if($btns.length > 0){
		var w = $gtbtn_wrap.width() + 8;
		$("#gtsearch" + mec_id + " .gtHeader").css("right", w+"px");
		$btns.click(function(){
			var script = $(this).attr("script");
			if(script && script != ""){
				script = decodeURIComponent(script);
				eval(script);
			}
		});
	}
};

Mobile_NS.GridTable.delHtmlTag = function(str){
	return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
};

Mobile_NS.GridTable.groupSum = function(mec_id){
	
	var $container = $("#NMEC_" + mec_id);
	
	var isGroupSum = $container.attr("data-groupsum") == "1";
	
	$(".gtWrap .gtContentWrap > table.gtContent tr.groupsum_tr", $container).remove();
	
	var sumArr = new Array();
	var totalSumArr = new Array();
	$(".gtWrap .gtContentWrap > table.gtContent tr.content_tr", $container).each(function(i){
		var $row = $(this);
		
		$row.children("td").each(function(j){
			var totalCalculate = 0;
			var isThousands = false;
			var htmltype = $(this).attr("data-htmltype");
			var type = $(this).attr("data-type");
			if(htmltype == "1" && (type == "2" || type == "3")){
				totalCalculate = 1;
			}else if(htmltype == "1" && type == "5"){
				totalCalculate = 1;
				isThousands = true;
			}
			
			if(totalCalculate == 0){
				return;
			}
			
			var dv = $(this).attr("data-value");
			
			if(dv.indexOf(",") != -1){
				dv = dv.replace(/,/g,"");
			}
			
			if(!isNaN(dv) && dv != ""){
				var sv = sumArr[j];
				if(typeof(sv) == "undefined"){
					sv = "0";
				}
				if(sv.indexOf(",") != -1){
					sv = sv.replace(/,/g,"");
				}
				sumArr[j] = Mobile_NS.GridTable.accAdd(sv, dv);
				
				var tsv = totalSumArr[j];
				if(typeof(tsv) == "undefined"){
					tsv = "0";
				}
				if(tsv.indexOf(",") != -1){
					tsv = tsv.replace(/,/g,"");
				}
				totalSumArr[j] = Mobile_NS.GridTable.accAdd(tsv, dv);
				
				if(isThousands){
					sumArr[j] = Mobile_NS.GridTable.changeToThousands(sumArr[j]);
					totalSumArr[j] = Mobile_NS.GridTable.changeToThousands(totalSumArr[j]);
				}
			}
			
		});
		
		if(isGroupSum){
			
			var $firstCol = $row.children("td").first();
			var firstColVal = $firstCol.attr("data-value");
			
			var $nextRow = $row.next();
			var $nextfirstCol = $nextRow.children("td").first();
			var nextfirstColVal = $nextfirstCol.attr("data-value");
			
			if(firstColVal != nextfirstColVal){
				var $groupRow = $row.clone();
				$groupRow[0].className = "groupsum_tr";
				var $groupCol = $groupRow.children("td");
				$groupCol.html("");
				
				$groupCol.first().html(_multiGTJson['16911']);//小计
				$groupCol.each(function(j){
					if(j == 0){
						return;
					}
					var sv = sumArr[j];
					if(typeof(sv) == "undefined"){
						sv = "";
					}
					
					$(this).html(sv);
				});
				
				$row.after($groupRow);
				
				sumArr = [];
			}
		}
	});
	
	var isTotalSum = $container.attr("data-totalsum") == "1";
	if(isTotalSum){
		var $lastRow = $(".gtWrap .gtContentWrap > table.gtContent > tbody > tr", $container).last();
		if($lastRow.length > 0){
			var $totalRow = $lastRow.clone();
			$totalRow[0].className = "groupsum_tr";
			var $totalCol = $totalRow.children("td");
			$totalCol.html("");
			
			$totalCol.first().html(_multiGTJson['129959']);//总计
			$totalCol.each(function(j){
				if(j == 0){
					return;
				}
				var tsv = totalSumArr[j];
				if(typeof(tsv) == "undefined"){
					tsv = "";
				}
				
				$(this).html(tsv);
			});
			$lastRow.after($totalRow);
		}
	}
};

Mobile_NS.GridTable.accAdd = function(num1,num2){// 两个浮点数求和
	
   var r1,r2,m;
   try{
       r1 = num1.toString().split('.')[1].length;
   }catch(e){
       r1 = 0;
   }
   try{
       r2=num2.toString().split(".")[1].length;
   }catch(e){
       r2=0;
   }
   m=Math.pow(10,Math.max(r1,r2));
   
   var sum = Math.round(num1*m+num2*m)/m;
   sum = sum.toFixed(Math.max(r1,r2));// 恢复浮点数结果精度
   
   return sum;
}


Mobile_NS.GridTable.initAdvancedSearch = function(mec_id){
	var $container = $("#NMEC_" + mec_id);
	
	var isAsSearch = $container.attr("data-assearch") == "1";
	
	if(!isAsSearch){
		return;
	}

	var that = this;
	
	$("#right_view #as-container-"+mec_id).remove();
	
	$("#right_view").append($("#as-container-"+mec_id));

	$("#gtsearch"+mec_id+" .advancedSearch").click(function(event){
		that.showAdvancedSearch(mec_id);
	});
	
	that.initAdvancedSearchContent(mec_id);
};

Mobile_NS.GridTable.showAdvancedSearch = function(id){
	var $advancedSearch = $("#as-container-" + id);
	$advancedSearch.addClass("searching");
	
	if(typeof(refreshRightViewScroll) == "function"){
		refreshRightViewScroll();
	}
	
	$(document.body).addClass("right_view_open");
	
	Mobile_NS.setViewOpen(Mobile_NS.GridTable.hideAdvancedSearch);
};

Mobile_NS.GridTable.hideAdvancedSearch = function(){

	$(document.body).removeClass("right_view_open");
	
	setTimeout(function(){
		var $advancedSearch = $(".as-container");
		$advancedSearch.removeClass("searching");
		
	},300);

};

Mobile_NS.GridTable.autoShowAdvancedSearch = function(id){
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

Mobile_NS.GridTable.initDate = function(eleid, eletype){
	var currYear = (new Date()).getFullYear();	
	var opt={};
	var _userlang = _multiGTJson['userlang'] || 7;
	opt.date = {preset : 'date', dateFormat : "yy-mm-dd"};
	opt.datetime = {preset : 'datetime', width : 40};
	opt.time = {preset : 'time'};
	opt.def = {
		theme: 'android-ics light', //皮肤样式
        display: 'modal', //显示方式 
        mode: 'scroller', //日期选择模式
		lang:_userlang == 8 ? 'en' : 'zh',
        startYear:currYear - 10, //开始年份
        endYear:currYear + 10 //结束年份
	};
	
	var $field = $("#" + eleid);
	if(eletype == "date"){
		var optCurr = $.extend(opt['date'], opt['def']);
		$field.mobiscroll(optCurr).date(optCurr);
	}else if(eletype == "time"){
		var optCurr = $.extend(opt['time'], opt['def']);
		$field.mobiscroll(optCurr).time(optCurr);
	}
};

Mobile_NS.GridTable.initAdvancedSearchContent = function(mec_id){
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
									"<input class=\"needsclick\" id=\"_as_fieldstart"+fieldid+"\" type=\"text\" placeholder=\""+_multiGTJson['740']+"\" data-clear-btn=\"false\" onchange=\"Mobile_NS.GridTable.showClearBtn('fieldstart', "+fieldid+");\">" +//开始日期
									"<div class=\"dataClean\" id=\"fieldstart"+fieldid+"\"></div>" +
									"</td>" +
									"<td class=\"rangeSearchcol2\"><div class=\"field_range_separater\"></div></td>" +
									"<td class=\"rangeSearchcol3\">" +
									"<input class=\"needsclick\" id=\"_as_fieldend"+fieldid+"\" type=\"text\" placeholder=\""+_multiGTJson['741']+"\" data-clear-btn=\"false\" onchange=\"Mobile_NS.GridTable.showClearBtn('fieldend', "+fieldid+");\">" +//结束日期
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
									"<input class=\"needsclick\" id=\"_as_fieldstart"+fieldid+"\" type=\"text\" placeholder=\""+_multiGTJson['742']+"\" data-clear-btn=\"false\" onchange=\"Mobile_NS.GridTable.showClearBtn('fieldstart', "+fieldid+");\">" +//开始时间
									"<div class=\"dataClean\" id=\"fieldstart"+fieldid+"\"></div>" +
									"</td>" +
									"<td class=\"rangeSearchcol2\"><div class=\"field_range_separater\"></div></td>" +
									"<td class=\"rangeSearchcol3\">" +
									"<input class=\"needsclick\" id=\"_as_fieldend"+fieldid+"\" type=\"text\" placeholder=\""+_multiGTJson['743']+"\" data-clear-btn=\"false\" onchange=\"Mobile_NS.GridTable.showClearBtn('fieldend', "+fieldid+");\">" +//结束时间
									"<div class=\"dataClean\" id=\"fieldend"+fieldid+"\"></div>" +
									"</td>" +
								"</tr>" +
							"</table>" +
						"</div>"
					);
					
					isDateTime = true;
					dateTimeType = "time";
				}else{
					$fieldWrap.addClass("browser-field");
					$fieldContent.append(
							"<input id=\"_as_field"+fieldid+"\" type=\"hidden\" search=\"true\" fieldtype=\"browser\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>" +
							"<div class=\"browser-name-wrap\">" +
								"<span id=\"_as_field"+fieldid+"span\" class=\"browser-name\"></span>" +
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
				$fieldContent.append("<input type=\"text\" placeholder=\""+_multiGTJson['4170']+"\" fieldtype=\"textarea\" search=\"true\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>");//请输入...
			}else if(htmltype == "1"){/*单行*/
				var textType = oneData["textType"];
				if(textType == "1"){//文本
					$fieldWrap.addClass("text-field");
					$fieldContent.append("<input type=\"text\" placeholder=\""+_multiGTJson['4170']+"\" fieldtype=\"text\" search=\"true\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>");//请输入...
				}else if(textType == "5"){//金额千分位
					$fieldWrap.addClass("thousandnumb-field");
					$fieldContent.append(
						"<div search=\"true\" fieldtype=\"thousandnumb\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\" style=\"height:100%;\">" +
							"<table class=\"rangeSearchTable\">" +
								"<tr>" +
									"<td class=\"rangeSearchcol1\"><input id=\"_as_fieldstart"+fieldid+"\" type=\"number\" placeholder=\""+_multiGTJson['383810']+"\" data-clear-btn=\"false\"></td>" +//大于等于
									"<td class=\"rangeSearchcol2\"><div class=\"field_range_separater\"></div></td>" +
									"<td class=\"rangeSearchcol3\"><input id=\"_as_fieldend"+fieldid+"\" type=\"number\" placeholder=\""+_multiGTJson['383811']+"\" data-clear-btn=\"false\"></td>" +//小于等于
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
									"<td class=\"rangeSearchcol1\"><input id=\"_as_fieldstart"+fieldid+"\" type=\"number\" placeholder=\""+_multiGTJson['383810']+"\" data-clear-btn=\"false\"></td>" +//大于等于
									"<td class=\"rangeSearchcol2\"><div class=\"field_range_separater\"></div></td>" +
									"<td class=\"rangeSearchcol3\"><input id=\"_as_fieldend"+fieldid+"\" type=\"number\" placeholder=\""+_multiGTJson['383811']+"\" data-clear-btn=\"false\"></td>" +//小于等于
								"</tr>" +
							"</table>" +
						"</div>"
					);
				}
			}else{/*上面已经过滤了附件和特殊字段，如果ecology增加新的字段类型，默认为text*/
				$fieldWrap.addClass("text-field");
				$fieldContent.append("<input type=\"text\" placeholder=\""+_multiGTJson['4170']+"\" fieldtype=\"text\" search=\"true\" fieldname=\""+fieldname+"\" fieldid=\""+fieldid+"\"/>");//请输入...
			}
			
			
			$fieldWrap.append($fieldLabel);
			$fieldWrap.append($fieldContent);
			
			$asContent.append($fieldWrap);
			
			if(isDateTime){
				Mobile_NS.GridTable.initDate("_as_fieldstart"+fieldid, dateTimeType);
				Mobile_NS.GridTable.initDate("_as_fieldend"+fieldid, dateTimeType);
			}
		}
		
		$advancedSearch.css("visibility", "visible");
	});
	
	var $searchBtn = $(".as-btn-wrap .search", $advancedSearch);
	$searchBtn.on("click", function(){
		eval("var asAutoShow = window.asAutoShow_" + mec_id + ";");
		if(typeof(asAutoShow) != "undefined" && asAutoShow == true){
			asAutoShow = false;
			Mobile_NS.GridTable.hideAdvancedSearch(); //手动关闭(不依赖返回)
		}else{
			Mobile_NS.backPage();
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
					_asArray.push(_as);
				}
			}
		});
		var listparams = "_asArray=" + encodeURIComponent(JSON.stringify(_asArray));
		setTimeout(function(){
			Mobile_NS.GridTable.refresh(mec_id, listparams);
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

Mobile_NS.GridTable.resetGridColumnWidth = function(mec_id){
	var that = this;
	
	var $container = $("#NMEC_" + mec_id);
	
	var contentTdWidthArr = [];
	
	var $firstContentRow = $(".gtWrap .gtContentWrap > table.gtContent tr.content_tr", $container).first();
	$firstContentRow.children("td").each(function(){
		var w = $(this).width();
		contentTdWidthArr.push(w);
	});
	
	var $firstTitleRow = $(".gtWrap table.gtTitle tr.title_tr", $container).first();
	
	$firstTitleRow.children("td").each(function(i){
		var w = contentTdWidthArr[i];
		if(w == null || typeof(w) == "undefined"){
			return;
		}
		var w2 = $(this).width();
		if(w != w2){
			var p = that.getHorizontalPadding($(this));	//padding
			var nw2 = w - p;
			$(this).css("width", nw2 + "px");
		}
	});
	/*
	$("table.gtContent td", $container).each(function(i){
		var h = $(this).html();
		var w = $(this).width();
		$(this).html(h + ":" + w);
	});
	
	$("table.gtTitle td", $container).each(function(i){
		var h = $(this).html();
		var w = $(this).width();
		$(this).html(h + ":" + w);
	});
	*/
	var cWidth = $(".gtWrap .gtContentWrap > table.gtContent", $container).width();
	$(".gtContentWrap", $container).width(cWidth);
	
};

Mobile_NS.GridTable.getHorizontalPadding = function($obj){
	
	var paddingLeft = $obj.css("padding-left") || "";
	paddingLeft = paddingLeft.replace("px", "");
	paddingLeft = parseInt(paddingLeft) || 0;
	
	var paddingRight = $obj.css("padding-right") || "";
	paddingRight = paddingRight.replace("px", "");
	paddingRight = parseInt(paddingRight) || 0;
	
	return paddingLeft + paddingRight;
};

Mobile_NS.GridTable.getVerticalPadding = function($obj){
	var paddingTop = $obj.css("padding-top") || "";
	paddingTop = paddingTop.replace("px", "");
	paddingTop = parseInt(paddingTop) || 0;
	
	var paddingBottom = $obj.css("padding-bottom") || "";
	paddingBottom = paddingBottom.replace("px", "");
	paddingBottom = parseInt(paddingBottom) || 0;
	
	var borderBottom = $obj.css("border-bottom-width") || "";
	borderBottom = borderBottom.replace("px", "");
	borderBottom = parseInt(borderBottom) || 0;
	
	return paddingTop + paddingBottom + borderBottom;
};

var gtDynamicParams = {};

Mobile_NS.GridTable.getDynamicParam = function(mec_id){
	var dynamicParam = gtDynamicParams[mec_id];
	if(!dynamicParam){
		dynamicParam = {};
		gtDynamicParams[mec_id] = dynamicParam;
	}
	return dynamicParam;
};

Mobile_NS.GridTable.loadMoreData = function(mec_id, totalPageCount){
	var that = this;
	
	var $moreBtn = $("#more" + mec_id);
	$moreBtn.addClass("click");
	setTimeout(function(){
		$moreBtn.removeClass("click");
	},300);
	
	eval("if(typeof(pageNo" + mec_id + ") == 'undefined'){pageNo" + mec_id + " = 1}");
	eval("pageNo" + mec_id + "++;");
	eval("var pageNo = pageNo" + mec_id + ";");
	Mobile_NS.showLoader(); 
	
	var dynamicParam = that.getDynamicParam(mec_id);
	
	var requestParam = {};
	for(var key in Mobile_NS.pageParams){
		requestParam[key] = Mobile_NS.pageParams[key];
	}
	for(var key in dynamicParam){
		requestParam[key] = dynamicParam[key];
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getGTDataWithPage&mec_id="+mec_id+"&pageNo="+pageNo);
	Mobile_NS.ajax(url, requestParam, function(data){
		
		Mobile_NS.hideLoader();
		
		if(pageNo == totalPageCount){
			$("#more" + mec_id).hide();
		}
		
		var $container = $("#NMEC_" + mec_id);
		
		var $contentData = $(data);
		$(".gtWrap .gtContentWrap > table.gtContent > tbody", $container).append($contentData);
		
		that.groupSum(mec_id);
		
		//$contentData[0].scrollIntoView();
		
		that.bindDataEvent(mec_id);
		
		that.updateFixedContentColumn(mec_id);
		
		refreshIScroll();
		
	});
};

Mobile_NS.GridTable.refresh = function(mec_id, paramsstr, callbackFn){
	var that = this;
	
	if(!mec_id || mec_id == ""){	//没有表格组件id，取页面第一个列表组件的id
		var $GridTableContainer = $(".GridTableContainer");
		if($GridTableContainer.length > 0){
			var idStr = $GridTableContainer.attr("id");
			mec_id = idStr.substring("NMEC_".length);
		}else{	//不存在表格插件
			return;
		}
	}else{
		var $container = $("#NMEC_" + mec_id);
		if($container.length == 0){	//找不到指定id的表单
			return;
		}
	}
	
	var dynamicParam = that.getDynamicParam(mec_id);
	
	if(paramsstr){
		var paramArr = paramsstr.split(";");
		for(var i = 0; i < paramArr.length; i++){
			var oneParam = paramArr[i];
			var pIndex = oneParam.indexOf("=");
			if(pIndex != -1){
				var paramName = oneParam.substring(0, pIndex);
				var paramValue = oneParam.substring(pIndex + 1);
				dynamicParam[paramName] = paramValue;
			}
		}
	}
	
	var requestParam = {};
	for(var key in Mobile_NS.pageParams){
		requestParam[key] = Mobile_NS.pageParams[key];
	}
	for(var key in dynamicParam){
		requestParam[key] = dynamicParam[key];
	}
	
	
	eval("pageNo" + mec_id + " = 1;");
	Mobile_NS.showLoader(); 
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=refreshGTData&mec_id="+mec_id+"&pageNo=1");
	
	Mobile_NS.ajax(url, requestParam, function(data){
		Mobile_NS.hideLoader();
		
		var $container = $("#NMEC_" + mec_id);
		
		var $gtContent = $(".gtWrap .gtContentWrap > table.gtContent > tbody", $container);
		$gtContent.find("*").remove();
		
		var $moreBtn = $("#more" + mec_id);
		$moreBtn.remove();
		
		var resultObj = $.parseJSON(data);
		
		var dataHtml = resultObj["dataHtml"];
		var btnHtml = resultObj["btnHtml"];
		
		$gtContent.append(dataHtml);
		
		if($.trim(btnHtml) != ""){
			$(".gtWrap", $container).after(btnHtml);
		}
		
		that.groupSum(mec_id);
		
		that.bindDataEvent(mec_id);
		
		that.updateFixedContentColumn(mec_id);
		
		refreshIScroll();
		
		if(typeof(callbackFn) == "function"){
			callbackFn.call(window);
		}
		
	});
};

Mobile_NS.GridTable.search = function(mec_id){
	var that = this;
	var $searchKey = $("#gtsearch"+mec_id+" .searchKey");
	var paramstr = "searchKey=" + encodeURIComponent($searchKey.val());
	that.refresh(mec_id, paramstr);
	$searchKey[0].blur();
};


Mobile_NS.GridTable.bindDataEvent = function(mec_id){
	var $container = $("#NMEC_" + mec_id);
	$(".gtWrap .gtContentWrap > table.gtContent tr.content_tr", $container).each(function(){
		var $dataRow = $(this);
		if($dataRow.attr('dataurl_bind') != "true"){
			if($dataRow.length > 0){
				
				$dataRow.click(function(){
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
				$dataRow.attr("dataurl_bind", "true");
			}
		}
	});
};

Mobile_NS.GridTable.buildFixedColumn = function(mec_id){
	
	var that = this;
	
	var $container = $("#NMEC_" + mec_id);
	
	var fixedColumn = parseInt($container.attr("data-fixedColumn"));
	
	if(!fixedColumn || fixedColumn < 1){
		return;
	}
	
	var $gtTitle = $(".gtWrap table.gtTitle", $container);
	
	var fixedColumnWidth = 0;
	$("tr.title_tr", $gtTitle).children("td").each(function(i){
		if(i < fixedColumn){
			fixedColumnWidth += $(this).width() + 1;
		}
	});
	
	$(".fixedGtWrap", $container).css("width", fixedColumnWidth + "px");
	$(".fixedGtContentWrapMapping", $container).css("width", fixedColumnWidth + "px");
	
	var $gtTitle = $(".gtWrap table.gtTitle", $container);
	var $cloneGtTitle = $gtTitle.clone();
	$("tr.title_tr", $cloneGtTitle).each(function(){
		var $row = $(this);
		var index = fixedColumn - 1;
		$row.children("td").eq(index).nextAll().remove();
	});
	that.fixCloneTableWidth($cloneGtTitle, mec_id);
	$(".fixedGtTitleWrap", $container).append($cloneGtTitle);
	
	$("tr.title_tr", $gtTitle).each(function(i){
		var $row = $(this);
		var $col = $row.children("td").eq(0);
		var h = $col.height();
		
		var $col2 = $("tr.title_tr", $cloneGtTitle).eq(i).children("td").eq(0);
		var h2 = $col2.height();
		
		if(h > h2){
			var p = that.getVerticalPadding($col);	//padding
			var nh2 = h - p;
			$col2.css("height", nh2 + "px");
		}else if(h < h2){
			var p = that.getVerticalPadding($col2);	//padding
			var nh2 = h2 - p;
			$col.css("height", nh2 + "px");
		}
	});
	
	that.updateFixedContentColumn(mec_id);
	
	var rightScrolling = false;
	var rightTimeoutId = null;
	$(".gtContentWrap", $container).on("scroll", function(){
		if(leftScrolling || verticalScrolling){
			return;
		}
		
		rightScrolling = true;
		if(rightTimeoutId){
			clearTimeout(rightTimeoutId);
		}
		$(".fixedGtContentWrapMapping", $container).show();
		$(".fixedGtContentWrap", $container).css("visibility", "hidden");
		$(".fixedGtContentWrap", $container).scrollTop($(this).scrollTop());
		
		
		rightTimeoutId = setTimeout(function(){
			rightScrolling = false;
		}, 1000);
	});
	
	var leftScrolling = false;
	var leftTimeoutId = null;
	$(".fixedGtContentWrap", $container).on("scroll", function(){
		if(rightScrolling  || verticalScrolling){
			return;
		}
		
		leftScrolling = true;
		if(leftTimeoutId){
			clearTimeout(leftTimeoutId);
		}
		$(".fixedGtContentWrapMapping", $container).show();
		$(this).css("visibility", "hidden");
		$(".gtContentWrap", $container).scrollTop($(this).scrollTop());
		
		leftTimeoutId = setTimeout(function(){
			leftScrolling = false;
		}, 1000);
	});
	
	var verticalScrolling = false;
	var verticalTimeoutId = null;
	$(".gtWrap", $container).on("scroll", function(){
		verticalScrolling = true;
		
		if(verticalTimeoutId){
			clearTimeout(verticalTimeoutId);
		}
		
		$(".fixedGtContentWrap", $container).css("visibility", "visible");
		$(".fixedGtContentWrapMapping", $container).hide().css("left", $(this).scrollLeft() + "px");

		verticalTimeoutId = setTimeout(function(){
			verticalScrolling = false;
		}, 100);
	});
};

Mobile_NS.GridTable.updateFixedContentColumn = function(mec_id){
	var that = this;
	
	var $container = $("#NMEC_" + mec_id);
	
	var fixedColumn = parseInt($container.attr("data-fixedColumn"));
	
	if(!fixedColumn || fixedColumn < 1){
		return;
	}
	
	var $gtContent = $(".gtWrap .gtContentWrap > table.gtContent", $container);
	var $cloneGtContent = $gtContent.clone();
	$("tr.content_tr, tr.groupsum_tr", $cloneGtContent).each(function(){
		var $row = $(this);
		$row.children("td").not(".beFixedCol").remove();
	});
	that.fixCloneTableWidth($cloneGtContent, mec_id);
	
	$(".fixedGtContentWrap", $container).find("*").remove();
	$(".fixedGtContentWrap", $container).append($cloneGtContent);
	
	var $cloneGtContent2 = $cloneGtContent.clone();
	$(".fixedGtContentWrapMapping", $container).find("*").remove();
	$(".fixedGtContentWrapMapping", $container).append($cloneGtContent2);
	
	$("tr.content_tr, tr.groupsum_tr", $gtContent).each(function(i){
		var $row = $(this);
		var $col = $row.children("td").eq(0);
		var h = $col.height();
		
		var $col2 = $("tr.content_tr, tr.groupsum_tr", $cloneGtContent).eq(i).children("td").eq(0);
		var h2 = $col2.height();
		
		var $col3 = $("tr.content_tr, tr.groupsum_tr", $cloneGtContent2).eq(i).children("td").eq(0);
		var h3 = $col3.height();
		
		if(h > h2){
			var p = that.getVerticalPadding($col);	//padding
			var nh2 = h - p;
			$col2.css("height", nh2 + "px");
			$col3.css("height", nh2 + "px");
		}else if(h < h2){
			var p = that.getVerticalPadding($col2);	//padding
			var nh2 = h2 - p;
			$col.css("height", nh2 + "px");
		}
	});
};

Mobile_NS.GridTable.showClearBtn = function(z, fieldid){
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

Mobile_NS.GridTable.fixCloneTableWidth = function($table, mec_id){
	var tableWidthStr = $table.attr("style");
	
	var toIndex;
	if((toIndex = tableWidthStr.indexOf("%")) > 0){
		tableWidthStr = tableWidthStr.substring("width:".length, toIndex);
		if(tableWidthStr > 100){
			$table.attr("style", "width:100%;");
		}
	}else if((toIndex = tableWidthStr.indexOf("px")) > 0){
		var $container = $("#NMEC_" + mec_id);
		tableWidthStr = $(".fixedGtWrap", $container).attr("style");
		$table.attr("style", tableWidthStr);
	}
	
};

Mobile_NS.GridTable.fixTableWidthStr = function(mec_id){
	var that = this;
	
	var $container = $("#NMEC_" + mec_id);
	var $gtContent = $(".gtContentWrap > table.gtContent", $container);
	
	var tableWidthStr = $gtContent.attr("style");
	
	var toIndex;
	if((toIndex = tableWidthStr.indexOf("%")) > 0){
		tableWidthStr = tableWidthStr.substring("width:".length, toIndex);
		if(tableWidthStr > 100){
			$gtContent.attr("style", "width:100%;");
		}
	}
	
};

Mobile_NS.GridTable.changeToThousands = function(sv){
	sv = sv.replace(/\s+/g,""); 
	if(sv != ""){
		sv = Mobile_NS.GridTable.commafy(sv);
	}
	return sv;
};

Mobile_NS.GridTable.addZero = function(aNumber,precision){
	if(aNumber == null || aNumber.trim() == "" || isNaN(aNumber)) return "";
	var valInt = (aNumber.toString().split(".")[1]+"").length;
	if(valInt != precision){
	    var lengInt = precision - valInt;
		//判断添加小数位0的个数
		if(lengInt == 1){
			aNumber += "0";
		}else if(lengInt == 2){
			aNumber += "00";
		}else if(lengInt == 3){
			aNumber += "000";
		}else if(lengInt < 0){
			if(precision == 1){
				aNumber += ".0";
			}else if(precision == 2){
				aNumber += ".00";
			}else if(precision == 3){
				aNumber += ".000";
			}else if(precision == 4){
				aNumber += ".0000";
			}
			var ins = aNumber.toString().split(".");
			if(ins.length > 2){
				aNumber = parseFloat(ins[0]+"."+ins[1]).toFixed(precision);
			}
		}		
	}
	return  aNumber;			
};


/**  
 * 数字格式转换成千分位  
 * @param{Object}num  
 */ 
Mobile_NS.GridTable.commafy = function(num){
	num = num + "";   
	num = num.replace(/[ ]/g, ""); //去除空格  
 
   if (num == "") {   
       return;   
    }   
 
    if (isNaN(num)){  
    return;   
   }   
 
   //2.针对是否有小数点，分情况处理   
   var index = num.indexOf(".");   
    if (index == -1) {//无小数点   
      var reg = /(-?\d+)(\d{3})/;   
       while (reg.test(num)) {   
        num = num.replace(reg, "$1,$2");   
        }   
    } else {   
        var intPart = num.substring(0, index);   
       var pointPart = num.substring(index + 1, num.length);   
       var reg = /(-?\d+)(\d{3})/;   
      while (reg.test(intPart)) {   
       intPart = intPart.replace(reg, "$1,$2");   
       }   
      num = intPart +"."+ pointPart;   
   }   
   
   return num;  
};
