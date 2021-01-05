if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.UrlGridTable = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = this.getDefaultMecJson();
	}
	this.mecJson = mecJson;
}

/*获取id。 必需的方法*/
MEC_NS.UrlGridTable.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.UrlGridTable.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	htmTemplate = htmTemplate.replace(/\${theId}/g, theId);
	
	var hasSearch = Mec_FiexdUndefinedVal(this.mecJson["hiddenSearch"]) != "1";
	var searchDisplay = hasSearch ? "block" : "none";
	htmTemplate = htmTemplate.replace("${searchDisplay}", searchDisplay);
	htmTemplate = htmTemplate.replace("${searchTips}", Mec_FiexdUndefinedVal(this.mecJson["searchTips"]));
	
	var gtWidth = Mec_FiexdUndefinedVal(this.mecJson["gtWidth"]);
	var tableWidthStr = MADGT_getWidthStyleStr(gtWidth);
	htmTemplate = htmTemplate.replace("${tableWidthStr}", tableWidthStr).replace("${tableWidthStr}", tableWidthStr);
	
	var gtHeight = Mec_FiexdUndefinedVal(this.mecJson["gtHeight"]);
	var tableHeightStr = MADGT_getHeightStyleStr(gtHeight);
	htmTemplate = htmTemplate.replace("${tableHeightStr}", tableHeightStr);
	
	htmTemplate = htmTemplate.replace("${loadMore}", "");
	
	var advancedSearch = Mec_FiexdUndefinedVal(this.mecJson["advancedSearch"] , "0");
	var advancedSearchDisplay = (advancedSearch == "1") ? "block" : "none";
	htmTemplate = htmTemplate.replace("${advancedSearchDisplay}", advancedSearchDisplay);
	
	var forAsSearchStart;
	if((forAsSearchStart = htmTemplate.indexOf("$mec_as_search_start$")) != -1){
		var forAsSearchEnd = htmTemplate.indexOf("$mec_as_search_end$", forAsSearchStart);
		var forTemplate = htmTemplate.substring(forAsSearchStart, forAsSearchEnd + "$mec_as_search_end$".length);
		htmTemplate = htmTemplate.replace(forTemplate, "");
	}
	
	var btn_datas = this.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
	}
	var hasBtn = btn_datas.length > 0;
	var gtBtnDisplay = hasBtn ? "block" : "none";
	htmTemplate = htmTemplate.replace("${gtBtnDisplay}", gtBtnDisplay);
	
	var forBtnStart;
	if((forBtnStart = htmTemplate.indexOf("$mec_gt_btn_forstart$")) != -1){
		var forBtnEnd = htmTemplate.indexOf("$mec_gt_btn_forend$", forBtnStart);
		var forTemplate = htmTemplate.substring(forBtnStart, forBtnEnd + "$mec_gt_btn_forend$".length);
		var forContentTemplate = htmTemplate.substring(forBtnStart + "$mec_gt_btn_forstart$".length, forBtnEnd);
		var forHtml = "";
		
		for(var i = 0; i < btn_datas.length; i++){
			var b_data = btn_datas[i];
			var btnId = b_data["id"];
			var btnText = b_data["btnText"];
			var btnScript = "";
			forHtml += forContentTemplate.replace("${btnId}", btnId)
											.replace("${btnText}", btnText)
											.replace("${btnScript}", btnScript);
		}
		
		htmTemplate = htmTemplate.replace(forTemplate, forHtml);
	}
	
	var gw_datas = this.mecJson["gw_datas"];
	
	var forTitleStart;
	if((forTitleStart = htmTemplate.indexOf("$mec_gt_title_forstart$")) != -1){
		var forTitleEnd = htmTemplate.indexOf("$mec_gt_title_forend$", forTitleStart);
		var forTemplate = htmTemplate.substring(forTitleStart, forTitleEnd + "$mec_gt_title_forend$".length);
		var forContentTemplate = htmTemplate.substring(forTitleStart + "$mec_gt_title_forstart$".length, forTitleEnd);
		var forHtml = "";
		
		for(var i = 0; gw_datas && i < gw_datas.length; i++){
			var gw_d = gw_datas[i];
			var columnText = gw_d["columnText"];
			var columnWidth = gw_d["columnWidth"];
			var colomnWidthStr = MADGT_getWidthStyleStr(columnWidth);
			forHtml += forContentTemplate.replace("${columnText}", columnText).replace("${colomnWidthStr}", colomnWidthStr);
		}
		
		htmTemplate = htmTemplate.replace(forTemplate, forHtml);
	}
	
	var forStart;
	while((forStart = htmTemplate.indexOf("$mec_gt_row_forstart$")) != -1){
		var forEnd = htmTemplate.indexOf("$mec_gt_row_forend$", forStart);
		var forTemplate = "";
		var forContentTemplate = "";
		if(forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_gt_row_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_gt_row_forstart$".length, forEnd);
			
			var forHtml = "";
			
			for(var dd = 0; dd < 5; dd++){
			forHtml += forContentTemplate.replace("${dataurl}", "");
			
			var col_forStart;
			if((col_forStart = forContentTemplate.indexOf("$mec_gt_col_forstart$")) != -1){
				var col_forEnd = forContentTemplate.indexOf("$mec_gt_col_forend$", col_forStart);
				if(col_forEnd != -1){
					var col_forTemplate = forContentTemplate.substring(col_forStart, col_forEnd + "$mec_gt_col_forend$".length);
					var col_forContentTemplate = forContentTemplate.substring(col_forStart + "$mec_gt_col_forstart$".length, col_forEnd);
					var col_forHtml = "";
					
					for(var i = 0; gw_datas && i < gw_datas.length; i++){
						var gw_d = gw_datas[i];
						var columnValue = "&nbsp;";
						var columnWidth = gw_d["columnWidth"];
						var colomnWidthStr = MADGT_getWidthStyleStr(columnWidth);
						
						col_forHtml += col_forContentTemplate.replace("${columnValue}", columnValue)
															.replace("${colomnWidthStr}", colomnWidthStr)
															.replace("${columnRealValue}", "");
					}
					forHtml = forHtml.replace(col_forTemplate, col_forHtml);
				}
			}
			}
			htmTemplate = htmTemplate.replace(forTemplate, forHtml);
		}else{
			break;
		}
	}
	var htm = htmTemplate;
	return htm;
};

MEC_NS.UrlGridTable.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	var $container = $("#NMEC_" + theId);
	var cWidth = $("table.gtContent", $container).width();
	$(".gtContentWrap", $container).width(cWidth);
	
	MADGT_fixTableWidthStr(theId);
	
	var $gtbtn_wrap = $("#gtsearch" + theId + " .gtbtn_wrap");
	var $btns = $(".gtbtn", $gtbtn_wrap);
	
	if($btns.length > 0){
		var w = $gtbtn_wrap.width() + 8;
		$("#gtsearch" + theId + " .gtHeader").css("right", w+"px");
	}
	
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.UrlGridTable.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADGT_"+theId+"\" style=\"padding-bottom: 0px;\">"
					+ "<div class=\"MADGT_Title\">表格数据设置</div>"
					+ "<div class=\"MADGT_BaseInfo_MoreFlag\" id=\"MADGT_BaseInfo_MoreFlag_"+theId+"\" style=\"top:0px;\">"
					+ "展开"
					+ "</div>"
					+ "<div class=\"MADGT_BaseInfo\">"
						+ "<div>"
							+ "内容来源： "
							+ "<input type=\"text\" id=\"source_"+theId+"\" class=\"MADGT_Text\" style=\"width:265px;\"/>"
						+ "</div>"
						+ "<div style=\"margin-left: 65px;\">"
						+ "提示：系统内部jsp必须放在mobilemode目录下 "
						+ "</div>"
						+ "<div style=\"position: relative;height:24px;\">"
							+ "数据链接： "
							+ "<span style=\"display: inline-block;\">"
							+ "<input type=\"text\" id=\"dataurl_"+theId+"\" class=\"MADGT_Text\" style=\"width:265px;\"/>"	
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"MADGT_BaseInfo_MoreContainer\" id=\"MADGT_BaseInfo_MoreContainer_"+theId+"\">"
						
							+ "<table class=\"attrTable\">"
								+ "<tr class=\"titleTr\">"
									+ "<td>每页条数</td>"
									+ "<td>隐藏查询</td>"
									+ "<td>数据只读</td>"
									+ "<td>延迟加载</td>"
								+ "</tr>"
								+ "<tr>"
									+ "<td><input type=\"text\" id=\"pagesize_"+theId+"\" class=\"MADGT_Text\" style=\"width: 50px;height: 18px; line-height: 10px;\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"hiddenSearch_"+theId+"\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"dataReadonly_"+theId+"\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/></td>"
								+ "</tr>"
							+ "</table>"
						
							+ "<div id=\"MADGT_ListBtn_"+theId+"\" style=\"margin-bottom:10px;margin-right:10px;\">"
								+ "<div class=\"list_btn_title\">"
									+ "自定义按钮"
									+ "<div class=\"list_btn_add\" onclick=\"MADGT_AddBtn('"+theId+"');\">添加</div>"
								+ "</div>"
								+ "<div class=\"list_btn_content\">"
									+ "<div class=\"list_btn_empty_tip\">单击右上角的添加按钮以添加内容</div>"
									+ "<ul></ul>"
								+ "</div>"
							+ "</div>"
							
							+ "<div>"
								+ "<span>搜索提示文字：</span>"
								+ "<input type=\"text\" id=\"searchTips_"+theId+"\" class=\"MADGT_Input\"></input>"
							+ "</div>"
							
							+ "<div class=\"MADGT_InParams_Container\">"
								+ "<div class=\"MADGT_InParams_Title\">"
									+ "输入参数"
									+ "<span class=\"requestCharsetWrap\">"
										+ "请求字符集："
										+ "<select id=\"requestCharset_"+theId+"\" class=\"MADGT_Select2\">"
											+ "<option value=\"UTF-8\">UTF-8</option>"
											+ "<option value=\"GBK\">GBK</option>"
											+ "<option value=\"ISO-8859-1\">ISO-8859-1</option>"
										+ "</select>"
									+ "</span>"
									+ "<div class=\"inparam_btn_add\" onclick=\"MADUL_AddOneInParam('"+theId+"')\">添加</div>"
								+ "</div>"
								+ "<div class=\"MADGT_InParams_Content\">"
									+ "<ul>"
									+ "</ul>"
								+ "</div>"
							+ "</div>"
							
							+ "<div class=\"MADGT_OutFormat_Container\">"
								+ "<div class=\"MADGT_OutFormat_Title\">"
									+ "输出格式"
									+ "<select id=\"outformat_type_"+theId+"\" class=\"outformat_type\">"
										+ "<option value=\"JSON\">JSON</option>"
									+ "</select>"
								+ "</div>"
								+ "<div class=\"MADGT_OutFormat_Content\">"
									+ "<ul>"
									+ "</ul>"
								+ "</div>"
							+ "</div>"
							
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADGT_Title\">表格显示设置</div>"
					+ "<div class=\"MADGT_BaseInfo\">"
						+ "<div>"
							+ "表格宽-高： "
							+ "<input type=\"text\" id=\"gtWidth_"+theId+"\" style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 65px;\"/>"
							+ "&nbsp;-&nbsp;"
							+ "<input type=\"text\" id=\"gtHeight_"+theId+"\" style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 65px;\"/>"
						+ "</div>"
						+ "<div>"
							+ "分组合计<span style=\"visibility: hidden;\">-</span>： "
							+ "<input type=\"checkbox\" id=\"groupsum_"+theId+"\"/>"
							+ "<span style=\"margin-left: 10px;\">(注：分组会使用第一个字段进行分组并合计)</span>"
						+ "</div>"
						+ "<div>"
							+ "锁定列数<span style=\"visibility: hidden;\">-</span>： "
							+"<select id=\"fixedColumn_"+theId+"\" style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 65px;\" >"
								+"<option value=\"0\">0</option><option value=\"1\">1</option><option value=\"2\">2</option><option value=\"3\">3</option>"
							+"</select>"
							+ "<span style=\"margin-left: 10px;\">(注：设置锁定几列)</span>"
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADGT_Title\" style=\"position: relative;\">"
						+ "表格列设置"
						+ "<div class=\"gridview_add\" onclick=\"MADULT_AddGridView('"+theId+"');\">添加</div>"
					+ "</div>"
					
					+ "<div class=\"MADGT_GridView\">"
						+ "<div class=\"gridview_empty_tip\">单击右上角的添加按钮以添加表格显示列</div>"
						+ "<ul></ul>"
					+ "</div>"
					
					+ "<div class=\"MADGT_Bottom\">"
    					+ "<div class=\"MADGT_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">确定</div>"
    				+ "</div>"
    				
			+ "</div>";
			
	htm += "<div class=\"MAD_Alert\">已生成到布局</div>";
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.UrlGridTable.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	$("#MADGT_BaseInfo_MoreFlag_" + theId).click(function(e){
		var $moreThis = $(this);
		$("#MADGT_BaseInfo_MoreContainer_" + theId).slideToggle(100, function(){
			if($(this).is(":visible")){
				$moreThis.addClass("MADGT_BaseInfo_MoreFlag_Hidden");
				$moreThis.html("隐藏");
			}else{
				$moreThis.removeClass("MADGT_BaseInfo_MoreFlag_Hidden");
				$moreThis.html("更多");
			}
		});
		e.stopPropagation();
	});
	
	$("#source_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["source"]));
	this.loadUIField();
	
	$("#urltype_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["urltype"] , "0"));
	
	$("#dataurl_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["dataurl"] , ""));
	
	var pagesize = Mec_FiexdUndefinedVal(this.mecJson["pagesize"]);
	if(pagesize == "" || isNaN(pagesize) || parseInt(pagesize) <= 0){
		pagesize = 100;
	}
	$("#pagesize_"+theId).val(pagesize);
	
	var hiddenSearch = Mec_FiexdUndefinedVal(this.mecJson["hiddenSearch"]);
	if(hiddenSearch == "1"){
		$("#hiddenSearch_"+theId).attr("checked","checked");
	}
	
	var dataReadonly = Mec_FiexdUndefinedVal(this.mecJson["dataReadonly"]);
	if(dataReadonly == "1"){
		$("#dataReadonly_"+theId).attr("checked","checked");
	}
	
	var lazyLoad = Mec_FiexdUndefinedVal(this.mecJson["lazyLoad"] , "0");
	if(lazyLoad == "1"){
		$("#lazyLoad_"+theId).attr("checked","checked");
	}
	
	var groupsum = Mec_FiexdUndefinedVal(this.mecJson["groupsum"] , "0");
	if(groupsum == "1"){
		$("#groupsum_"+theId).attr("checked","checked");
	}
	
	var $attrContainer = $("#MADGT_"+theId);
	var list_datas = this.mecJson["list_datas"];
	if(!list_datas){
		list_datas = [];
	}
	
	$("#searchTips_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["searchTips"],""));
	
	var btn_datas = this.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
	}
	if(btn_datas.length == 0){
		$(".list_btn_empty_tip", $attrContainer).show();
	}
	for(var i = 0; btn_datas && i < btn_datas.length; i++){
		MADGT_AddBtnToPage(theId, btn_datas[i]);
	}
	
	var gtWidth = Mec_FiexdUndefinedVal(this.mecJson["gtWidth"]);
	$("#gtWidth_" + theId).val(gtWidth);
	
	var gtHeight = Mec_FiexdUndefinedVal(this.mecJson["gtHeight"]);
	$("#gtHeight_" + theId).val(gtHeight);
	
	var fixedColumn = Mec_FiexdUndefinedVal(this.mecJson["fixedColumn"], "0");
	$("#fixedColumn_" + theId).val(fixedColumn);
	
	var gw_datas = this.mecJson["gw_datas"];
	if(!gw_datas){
		gw_datas = [];
	}
	if(gw_datas.length == 0){
		$(".gridview_empty_tip", $attrContainer).show();
	}
	for(var i = 0; gw_datas && i < gw_datas.length; i++){
		MADULT_AddOneGridViewToPage(theId, gw_datas[i]);
	}
	
	var requestCharset = Mec_FiexdUndefinedVal(this.mecJson["requestCharset"]);
	$("#requestCharset_"+theId).val(requestCharset);
	
	$("#MADGT_"+theId).jNice();
	
	$("#MADGT_"+theId + " .MADGT_GridView > ul").sortable({
		revert: false,
		axis: "y",
		items: "li",
		handle: ".bemove"
	});
	
	var inParams = this.mecJson["inParams"];
	for(var i = 0; inParams && i < inParams.length; i++){
		MADUL_AddOneInParamToPage(theId, inParams[i]);
	}
	
	var outFormat = this.mecJson["outFormat"];
	$("#outformat_type_" + theId).val(outFormat["type"]);
	var formats = outFormat["formats"];
	for(var i = 0; formats && i < formats.length; i++){
		MADUL_AddOneOutFormatToPage(theId, formats[i]);
	}
	
	new URLSelector("dataurl_"+theId).init();
};

/*获取JSON*/
MEC_NS.UrlGridTable.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADGT_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["source"] = $("#source_"+theId).val();	//内容来源
		
		this.mecJson["urltype"] = $("#urltype_"+theId).val();
		
		this.mecJson["dataurl"] = $("#dataurl_"+theId).val();	//数据链接
		
		var pagesize = $("#pagesize_"+theId).val();	//每页条数
		if(pagesize == "" || isNaN(pagesize) || parseInt(pagesize) <= 0){
			pagesize = 10;
		}
		this.mecJson["pagesize"] = pagesize;
		
		this.mecJson["hiddenSearch"] = $("#hiddenSearch_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["dataReadonly"] = $("#dataReadonly_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["lazyLoad"] = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["groupsum"] = $("#groupsum_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["searchTips"] = $("#searchTips_"+theId).val();	// 搜索提示文字
		
		this.mecJson["requestCharset"] = $("#requestCharset_"+theId).val();
		
		var $searchColumnContent = $("#MADGT_SearchColumn_" + theId);
		var $listEntry = $(".listEntry", $searchColumnContent);
		var list_datas = [];
		$listEntry.each(function(){
			var rowfields = {};
			var id = $(".MADGT_LIST_ID", $(this)).val();
			var fieldid = $(".MADGT_SearchColumn_Select", $(this)).val();
			var fieldName = $(".MADGT_SearchColumn_Selected_FieldName", $(this)).html();
			rowfields.id = id;
			rowfields.fieldid = fieldid;
			rowfields.fieldName = fieldName;
			list_datas.push(rowfields);
		});
		this.mecJson["list_datas"] = list_datas;
		
		var btn_datas = this.mecJson["btn_datas"];
		if(!btn_datas){
			btn_datas = [];
		}
		var $BtnLi = $(".list_btn_content > ul > li", $attrContainer);
		$BtnLi.each(function(){
			var liId = $(this).attr("id");
			if(liId && liId != ""){
				var btnId = liId.substring("li_".length);
				var btnText = $("input[name='btnText']", $(this)).val();
				var btnScript = $("input[name='btnScript']", $(this)).val();
				for(var i = 0; i < btn_datas.length; i++){
					if(btn_datas[i]["id"] == btnId){
						btn_datas[i]["btnText"] = btnText;
						btn_datas[i]["btnScript"] = btnScript;
						break;
					}
				}
			}
		});
		
		this.mecJson["gtWidth"] = $("#gtWidth_"+theId).val();
		
		this.mecJson["gtHeight"] = $("#gtHeight_"+theId).val();
		
		this.mecJson["fixedColumn"] = $("#fixedColumn_"+theId).val();
		
		var gw_datas = [];
		var $g_li = $(".MADGT_GridView > ul > li", $attrContainer);
		$g_li.each(function(){
			var columnText = $("input[name='columnText']", $(this)).val();
			var columnName = $("input[name='columnName']", $(this)).val();
			var columnWidth = $("input[name='columnWidth']", $(this)).val();
			gw_datas.push({
				"columnText" : columnText,
				"columnName" : columnName,
				"columnWidth" : columnWidth
			});
		});
		this.mecJson["gw_datas"] = gw_datas;
	}
	
	return this.mecJson;
};

MEC_NS.UrlGridTable.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["source"] = "";	//内容来源
	defMecJson["dataReadonly"] = "0";	//数据只读
	
	defMecJson["list_datas"] = [];
	
	defMecJson["btn_datas"] = [];
	
	defMecJson["searchTips"] = "请输入..."; //搜索提示文字
	
	defMecJson["gtWidth"] = "100%";
	defMecJson["gtHeight"] = "200";
	
	defMecJson["gw_datas"] = [];
	
	defMecJson["requestCharset"] = "UTF-8";
	
	var inParams = [
	    {
	    	id : new UUID().toString(),
	    	paramName : "pageNo",
	    	paramValue : "{PAGE_NO}",
	    	desc : "当前页",
	    	isSystem : "1"
	    },
	    {
	    	id : new UUID().toString(),
	    	paramName : "pageSize",
	    	paramValue : "{PAGE_SIZE}",
	    	desc : " 每页显示数量",
	    	isSystem : "1"
	    },
	    {
	    	id : new UUID().toString(),
	    	paramName : "searchKey",
	    	paramValue : "{SEARCH_KEY}",
	    	desc : "查询参数",
	    	isSystem : "1"
	    }
	];
	
	defMecJson["inParams"] = inParams;
	
	var outFormat = {
		type : "JSON",
		formats : [
		    {
		    	key : "TOTAL_SIZE",
		    	keyName : "totalSize",
		    	desc : "总记录数对应KEY"
		    },
		    {
		    	key : "DATAS",
		    	keyName : "datas",
		    	desc : "数据JSON对应KEY"
		    }
		]
	};
	defMecJson["outFormat"] = outFormat;
	
	return defMecJson;
};

MEC_NS.UrlGridTable.prototype.loadUIField = function(){
	var theId = this.id;
	var _fieldData = [];
	 
	var sourceV = $("#source_" + theId).val();
	if(sourceV != ""){
		var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=getUIField&id=" + sourceV);
		$.ajax({
		 	type: "POST",
		 	contentType: "application/json",
		 	url: encodeURI(url),
		 	async: false,
		 	data: "{}",
		 	success: function(responseText, textStatus) 
		 	{
		 		_fieldData = $.parseJSON(responseText);
		 	}
		});
	}
	
	this._fieldData = _fieldData;	 
};

function MADGT_FormatValue2Json(v){
	return v == "" ? {} : $.parseJSON(v);
}

function MADGT_FormatJson2Value(jsonObj){
	return $.isEmptyObject(jsonObj) ? "" : JSON.stringify(jsonObj);
}

function MADGT_DelHtmlTag(str){
	return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
}

function MADGT_SearchColumn_SelectChange(id){
	var $fieldidObj = $("#fieldid_"+id);
	var fieldName = $fieldidObj.find("option:selected").attr("fieldName");
	var $fieldNameObj = $("#fieldName_"+id);
	$fieldNameObj.html(fieldName);
}

function MADGT_DeleteListData(mec_id, id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var list_datas = mecHandler.mecJson["list_datas"];
	if(!list_datas){
		list_datas = [];
	}
	var index = -1;
	for(var i = 0; i < list_datas.length; i++){
		var data = list_datas[i];
		if(data["id"] == id){
			index = i;
			break;
		}
	}
	if(index != -1){
		list_datas.splice(index, 1);
	}
}

function MADGT_DeleteListEntry(mec_id, id){
	var msg = "确定删除吗？";
	if(!confirm(msg)){
		return;
	}
	
	MADGT_DeleteListData(mec_id, id);
	
	var $attrContainer = $("#MADGT_SearchColumn_"+mec_id);
	$("#listEntry_" + id, $attrContainer).remove();
	
	var $ulBody = $(".list_ul_root",$attrContainer);
	if($ulBody.children().length == 0){
		$(".list_empty_tip", $attrContainer).show();
	}
}

function MADGT_AddBtn(mec_id){
	var result = {};
	result["id"] = new UUID().toString();
	result["btnText"] = "";
	result["btnScript"] = "";
	
	MADGT_AddBtnToPage(mec_id, result);
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var btn_datas = mecHandler.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
		mecHandler.mecJson["btn_datas"] = btn_datas;
	}
	btn_datas.push(result);
}

function MADGT_AddBtnToPage(mec_id, result){
	
	var $attrContainer = $("#MADGT_"+mec_id);
	
	$(".list_btn_empty_tip", $attrContainer).hide();
	
	var $ul = $(".list_btn_content > ul", $attrContainer);
	var $li = $("<li id=\"li_"+result["id"]+"\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"100px\" valign=\"middle\">";
			    	htm += "<input name=\"btnText\" type=\"text\" class=\"MADGT_Text\" style=\"height:22px;line-height:10px;\" value=\""+result["btnText"]+"\" placeholder=\"按钮名称\"/>";
			    htm += "</td>";
			    
			    htm += "<td width=\"160px\">";
					htm += "<div class=\"btn_click_desc\">";
						htm += "<input name=\"btnScript\" type=\"hidden\" value=\"\"/>";
						htm += "单击事件";
					htm += "</div>";
				htm += "</td>";
				
				htm += "<td align=\"right\">";
					htm += "<span class=\"inparam_btn_del\" onclick=\"MADGT_deleteOneBtnOnPage('"+mec_id+"','"+result["id"]+"')\"></span>";
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
	
	$("input[name='btnScript']", $li)[0].value = result["btnScript"];
	
	$(".btn_click_desc", $li).click(function(){
		var $this = $(this);
		var $btnScript = $("input[name='btnScript']", $this);
		SL_AddScriptToField($btnScript);
	});
}

function MADGT_deleteOneBtnOnPage(mec_id, id){
	var msg = "确定删除吗？";
	if(!confirm(msg)){
		return;
	}
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var btn_datas = mecHandler.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
	}
	var index = -1;
	for(var i = 0; i < btn_datas.length; i++){
		var data = btn_datas[i];
		if(data["id"] == id){
			index = i;
			break;
		}
	}
	if(index != -1){
		btn_datas.splice(index, 1);
	}
	
	$("#li_" + id).remove();
	
	if(btn_datas.length == 0){
		var $attrContainer = $("#MADGT_"+mec_id);
		$(".list_btn_empty_tip", $attrContainer).show();
	}
}

function MADULT_AddGridView(mec_id){
	MADULT_AddOneGridViewToPage(mec_id);
}


function MADULT_AddOneGridViewToPage(mec_id, result){
	
	var $attrContainer = $("#MADGT_"+mec_id);
	
	$(".gridview_empty_tip", $attrContainer).hide();
	
	var columnText = "";
	var columnName = "";
	var columnWidth = "";
	if(result){
		columnText = Mec_FiexdUndefinedVal(result["columnText"]);
		columnName = Mec_FiexdUndefinedVal(result["columnName"]);
		columnWidth = Mec_FiexdUndefinedVal(result["columnWidth"]);
	}
	
	
	var $ul = $(".MADGT_GridView > ul", $attrContainer);
	var $li = $("<li class=\"g_li\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    		htm += "<td class=\"bemove\" width=\"20px\"></td>";
			    htm += "<td width=\"105px\" valign=\"middle\">";
			    	htm += "<input name=\"columnText\" type=\"text\" style=\"width: 95px;\" value=\""+columnText+"\" placeholder=\"列显示名称\"/>";
			    htm += "</td>";
			    
			    htm += "<td width=\"115px\">";
					htm += "<input name=\"columnName\" style=\"width: 105px;\" value=\""+columnName+"\" placeholder=\"列显示字段\"/>";
				htm += "</td>";
				
				htm += "<td width=\"70px\">";
					htm += "<input name=\"columnWidth\" type=\"text\" value=\""+columnWidth+"\" placeholder=\"列宽\"/>";
				htm += "</td>";
				
				htm += "<td align=\"right\">";
					htm += "<span class=\"inparam_btn_del\" onclick=\"MADULT_deleteOneGridViewOnPage('"+mec_id+"',this)\"></span>";
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
	
}

function MADULT_deleteOneGridViewOnPage(mec_id, obj){
	var msg = "确定删除吗？";
	if(!confirm(msg)){
		return;
	}
	
	$(obj).closest(".g_li").remove();
	
	var $attrContainer = $("#MADGT_"+mec_id);
	
	if($(".MADGT_GridView > ul > li", $attrContainer).length == 0){
		
		$(".gridview_empty_tip", $attrContainer).show();
	}
		
}

function MADGT_getWidthStyleStr(width){
	if(typeof(width) == "undefined" || width == null || width == ""){
		return "";
	}
	if(!isNaN(width)){
		width = width + "px";
	}
	return "width:" + width + ";";
}

function MADGT_getHeightStyleStr(height){
	if(typeof(height) == "undefined" || height == null || height == ""){
		return "";
	}
	if(!isNaN(height)){
		height = height + "px";
	}
	return "height:" + height + ";";
}

function MADGT_fixTableWidthStr(mec_id){
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

function MADUL_AddOneInParam(mec_id){
	var url = "/mobilemode/paraminfo.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 400;//定义长度
	dlg.Height = 300;
	dlg.URL = url;
	dlg.Title = "添加";
	dlg.show();
	dlg.hookFn = function(result){
		result["id"] = new UUID().toString();
		result["isSystem"] = "0";
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var inParams = mecHandler.mecJson["inParams"];
		inParams.push(result);
		MADUL_AddOneInParamToPage(mec_id, result);
	};
}

function MADUL_AddOneInParamToPage(mec_id, paramobj){
	var $attrContainer = $("#MADGT_"+mec_id);
	var $ul = $(".MADGT_InParams_Content > ul", $attrContainer);
	var $li = $("<li id=\"li_"+paramobj["id"]+"\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"100px\" valign=\"middle\">";
			    	htm += "<input name=\"paramName\" type=\"text\" class=\"MADGT_Text\" style=\"height:20px;line-height:10px;\" value=\""+paramobj["paramName"]+"\"/>";
			    htm += "</td>";
			    
			    htm += "<td width=\"160px\">";
					htm += "<div class=\"inparam_param_desc\">";
						htm += paramobj["desc"];
					htm += "</div>";
				htm += "</td>";
				
				htm += "<td align=\"right\">";
					var isSystem = paramobj["isSystem"];
					if(isSystem != "1"){
						htm += "<span class=\"inparam_btn_edit\" onclick=\"MADUL_editOneInParamOnPage('"+mec_id+"','"+paramobj["id"]+"')\"></span>";
						htm += "<span class=\"inparam_btn_del\" onclick=\"MADUL_deleteOneInParamOnPage('"+mec_id+"','"+paramobj["id"]+"')\"></span>";
					}
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
}

function MADUL_editOneInParamOnPage(mec_id, inParamId){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var inParams = mecHandler.mecJson["inParams"];
	var paramobj = null;
	for(var i = 0; i < inParams.length; i++){
		var data = inParams[i];
		if(data["id"] == inParamId){
			paramobj = data;
			break;
		}
	}
	
	if(paramobj != null){
		
		var url = "/mobilemode/paraminfo.jsp?paramName="+paramobj["paramName"]+"&paramValue="+encodeURIComponent(paramobj["paramValue"])+"&desc="+paramobj["desc"]+"&isEncrypt="+paramobj["isEncrypt"];
		var dlg = top.createTopDialog();//获取Dialog对象
		dlg.Model = true;
		dlg.normalDialog = false;
		dlg.Width = 400;//定义长度
		dlg.Height = 300;
		dlg.URL = url;
		dlg.Title = "添加";
		dlg.show();
		dlg.hookFn = function(result){
			paramobj["paramName"] = result["paramName"];
			paramobj["paramValue"] = result["paramValue"];
			paramobj["desc"] = result["desc"];
			paramobj["isEncrypt"] = result["isEncrypt"];
			
			var $li = $("#li_" + inParamId);
			$("input[name='paramName']", $li).val(result["paramName"]);
			$(".inparam_param_desc", $li).html(result["desc"]);
		};
	}
}

function MADUL_deleteOneInParamOnPage(mec_id, inParamId){
	if(!confirm("确定删除吗")){
		return;
	}
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var inParams = mecHandler.mecJson["inParams"];
	var index = -1;
	for(var i = 0; i < inParams.length; i++){
		var data = inParams[i];
		if(data["id"] == inParamId){
			index = i;
			break;
		}
	}
	if(index != -1){
		inParams.splice(index, 1);
	}
	
	$("#li_" + inParamId).remove();
}

function MADUL_AddOneOutFormatToPage(mec_id, formatobj){
	var $attrContainer = $("#MADGT_"+mec_id);
	var $ul = $(".MADGT_OutFormat_Content > ul", $attrContainer);
	var $li = $("<li></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"100px\" valign=\"middle\">";
			    	htm += "<input name=\"key\" type=\"hidden\" value=\""+formatobj["key"]+"\"/>";
			    	htm += "<input name=\"keyName\" type=\"text\" class=\"MADGT_Text\" style=\"height:20px;line-height:10px;\" value=\""+formatobj["keyName"]+"\"/>";
			    htm += "</td>";
			    
			    htm += "<td>";
					htm += "<div class=\"outformat_key_desc\">";
						htm += formatobj["desc"];
					htm += "</div>";
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
}

