if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.GridTable = function(type, id, mecJson){
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
MEC_NS.GridTable.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.GridTable.prototype.getDesignHtml = function(){
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

MEC_NS.GridTable.prototype.afterDesignHtmlBuild = function(){
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
MEC_NS.GridTable.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;
	var tip = "";
	if(_userLanguage=="8"){
		tip = "Click the Add button on the top right to add the query column. If the query column is not specified, the default selection is performed by the first column in the display.";
	}else if(_userLanguage=="9"){
		tip = "單擊右上角的添加按鈕以添加查詢列，如果未指定查詢列，則默認按照展示中選擇的第一列進行查詢";
	}else{
		tip = "单击右上角的添加按钮以添加查询列，如果未指定查询列，则默认按照展示中选择的第一列进行查询";
	}

	var theId = this.id;
	
	var htm = "<div id=\"MADGT_"+theId+"\" style=\"padding-bottom: 0px;\">"
					+ "<div class=\"MADGT_Title\">"+SystemEnv.getHtmlNoteName(4398)+"</div>"  //表格数据设置
					+ "<div class=\"MADGT_BaseInfo_MoreFlag\" id=\"MADGT_BaseInfo_MoreFlag_"+theId+"\" style=\"top:0px;\">"
					+ SystemEnv.getHtmlNoteName(3888)  //更多
					+ "</div>"
					+ "<div class=\"MADGT_BaseInfo\">"
						+ "<div>"
							+ "<span class=\"MADGT_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4144) + " </span>"  //内容来源：
							+ "<select class=\"MADGT_Select\" id=\"source_"+theId+"\" onfocus=\"this.defOpt=this.selectedIndex\" onchange=\"MADGT_SourceChange('"+theId+"');\" style=\"width:265px;\">"
								+ MADGT_getListSelectOptionHtml()
							+ "</select>"
						+ "</div>"
						
						+ "<div style=\"position: relative;height:24px;\">"
							+ "<span class=\"MADGT_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4145) + " </span>"  //数据链接：
							+ "<select name=\"urltype\" id=\"urltype_"+theId+"\" class=\"MADGT_Select\" onchange=\"MADGT_UrltypeChange('"+theId+"')\" style=\"width: auto;\">"
		 						+ "<option value=\"0\">"+SystemEnv.getHtmlNoteName(4146)+"</option>"  //自动解析
		 						+ "<option value=\"1\">"+SystemEnv.getHtmlNoteName(4147)+"</option>"  //手动输入
		 					+ "</select>"
		 					+ "<span class=\"urlcontent-wrap\" style=\"display: inline-block;\">"
							+ "<input type=\"text\" id=\"dataurl_"+theId+"\" class=\"MADGT_Text urlcontent urlcontent"+styleL+"\"/>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"MADGT_BaseInfo_MoreContainer MADGT_BaseInfo_MoreContainer"+styleL+"\" id=\"MADGT_BaseInfo_MoreContainer_"+theId+"\">"
						
							+ "<table class=\"attrTable\">"
								+ "<tr class=\"titleTr\">"
									+ "<td>"+SystemEnv.getHtmlNoteName(4148)+"</td>"  //每页条数
									+ "<td>"+SystemEnv.getHtmlNoteName(4149)+"</td>"  //扩展按钮
									+ "<td>"+SystemEnv.getHtmlNoteName(4150)+"</td>"  //隐藏查询
									+ "<td>"+SystemEnv.getHtmlNoteName(4151)+"</td>"  //数据只读
									+ "<td>"+SystemEnv.getHtmlNoteName(4309)+"</td>"  //延迟加载
								+ "</tr>"
								+ "<tr>"
									+ "<td><input type=\"text\" id=\"pagesize_"+theId+"\" class=\"MADGT_Text\" style=\"width: 50px;height: 18px; line-height: 10px;\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"pageexpandFlag_"+theId+"\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"hiddenSearch_"+theId+"\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"dataReadonly_"+theId+"\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/></td>"
								+ "</tr>"
							+ "</table>"
						
							+ "<div id=\"MADGT_SearchColumn_"+theId+"\" style=\"margin-bottom:10px;margin-right:10px;\">"
								+ "<div class=\"list_search_column_title\">"
									+ SystemEnv.getHtmlNoteName(4152)  //指定查询列
									+ "<div class=\"list_search_column_add\" onclick=\"MADGT_AddSearchColumnEntry('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
								+ "</div>"
								+ "<div class=\"list_search_column_content\">"
									+ "<div class=\"list_empty_tip\">"+tip+"</div>"  //单击右上角的添加按钮以添加查询列，如果未指定查询列，则默认按照展示中选择的第一列进行查询
									+ "<ul class=\"list_ul_root\"></ul>"
								+ "</div>"
							+ "</div>"
							
							+ "<div id=\"MADGT_ListBtn_"+theId+"\" style=\"margin-bottom:10px;margin-right:10px;\">"
								+ "<div class=\"list_btn_title\">"
									+ SystemEnv.getHtmlNoteName(4158)  //自定义按钮
									+ "<div class=\"list_btn_add\" onclick=\"MADGT_AddBtn('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
								+ "</div>"
								+ "<div class=\"list_btn_content\">"
									+ "<div class=\"list_btn_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
									+ "<ul></ul>"
								+ "</div>"
							+ "</div>"
							
							+ "<div>"
								+ "<span>"+SystemEnv.getHtmlNoteName(4160)+"</span>"  //搜索提示文字：
								+ "<input type=\"text\" id=\"searchTips_"+theId+"\" class=\"MADGT_Input\" data-multi=false></input>"
							+ "</div>"
							
							+ "<div>"
								+ "<div style=\"margin-bottom:0px;position: relative;\">"+SystemEnv.getHtmlNoteName(4163)   //高级检索：
									+ "<input type=\"checkbox\" id=\"advancedSearch_"+theId+"\" onclick=\"MADGT_DisplayAdvancedSearch(this, '"+theId+"');\"/>"
									+ "<div class=\"MADGT_EditAdvancedSearch MADGT_EditAdvancedSearch"+styleL+"\" onclick=\"MADGT_EditAdvancedSearch('"+theId+"');\"></div>"
									+ "<input id=\"advancedSearchContent_"+theId+"\" type=\"hidden\"/>"
								+ "</div>"
							+ "</div>"
							
							+ "<div id=\"advancedSearchConfig_"+theId+"\" style=\"display:none;\">"
								+ "<div>"
									+ "<span>"+SystemEnv.getHtmlNoteName(4320)+"</span>" //默认显示：
									+ "<input type=\"checkbox\" id=\"searchAutoShow_"+theId+"\"/>&nbsp;"+SystemEnv.getHtmlNoteName(4868)//默认显示高级检索，通过检索显示表格
								+ "</div>"
								+ "<div>"
									+ "<span>"+SystemEnv.getHtmlNoteName(4869)+"</span>" //页面标题：
									+ "<input type=\"text\" id=\"asBigTitle_"+theId+"\" style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 100px;\" data-multi=false>&nbsp;-&nbsp;"
									+ "<input type=\"text\" id=\"asSmallTitle_"+theId+"\" style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 100px;\" data-multi=false>"
								+ "</div>"
							+ "</div>"
						
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADGT_Title MADGT_Title"+styleL+"\">"+SystemEnv.getHtmlNoteName(4399)+"</div>"  //表格显示设置
					+ "<div class=\"MADGT_BaseInfo\">"
						+ "<div>"
							+ SystemEnv.getHtmlNoteName(4400) + " "  //表格宽-高：
							+ "<input type=\"text\" id=\"gtWidth_"+theId+"\" style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 65px;\"/>"
							+ "&nbsp;-&nbsp;"
							+ "<input type=\"text\" id=\"gtHeight_"+theId+"\" style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 65px;\"/>"
						+ "</div>"
						+ "<div>"
							+ SystemEnv.getHtmlNoteName(4401) + "<span style=\"visibility: hidden;\">-</span>： "  //分组合计
							+ "<input type=\"checkbox\" id=\"groupsum_"+theId+"\"/>"
							+ "<span style=\"margin-left: 10px;\">("+SystemEnv.getHtmlNoteName(4402)+")</span>"  //注：分组会使用第一个字段进行分组并合计
						+ "</div>"
						+ "<div>"
							+ SystemEnv.getHtmlNoteName(4942)+"<span style=\"visibility: hidden;\">-</span>： "  //显示总计
							+ "<input type=\"checkbox\" id=\"totalsum_"+theId+"\"/>"
						+ "</div>"
						+ "<div>"
							+ SystemEnv.getHtmlNoteName(4403) + "<span style=\"visibility: hidden;\">-</span>： "  //锁定列数
							+"<select id=\"fixedColumn_"+theId+"\" style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 65px;\" >"
								+"<option value=\"0\">0</option><option value=\"1\">1</option><option value=\"2\">2</option><option value=\"3\">3</option>"
							+"</select>"
							+ "<span style=\"margin-left: 10px;\">("+SystemEnv.getHtmlNoteName(4404)+")</span>"  //注：设置锁定几列
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADGT_Title\" style=\"position: relative;\">"
						+ SystemEnv.getHtmlNoteName(4405)  //表格列设置
						+ "<div class=\"gridview_add\" onclick=\"MADGT_AddGridView('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
					+ "</div>"
					
					+ "<div class=\"MADGT_GridView\">"
						+ "<div class=\"gridview_empty_tip\">"+SystemEnv.getHtmlNoteName(4406)+"</div>"  //单击右上角的添加按钮以添加表格显示列
						+ "<ul></ul>"
					+ "</div>"
					
					+ "<div class=\"MADGT_Bottom\">"
    					+ "<div class=\"MADGT_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>"  //确定
    				+ "</div>"
    				
			+ "</div>";
			
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.GridTable.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	$("#MADGT_BaseInfo_MoreFlag_" + theId).click(function(e){
		var $moreThis = $(this);
		$("#MADGT_BaseInfo_MoreContainer_" + theId).slideToggle(100, function(){
			if($(this).is(":visible")){
				$moreThis.addClass("MADGT_BaseInfo_MoreFlag_Hidden");
				$moreThis.html(SystemEnv.getHtmlNoteName(3549));  //隐藏
			}else{
				$moreThis.removeClass("MADGT_BaseInfo_MoreFlag_Hidden");
				$moreThis.html(SystemEnv.getHtmlNoteName(3888));  //更多
			}
		});
		e.stopPropagation();
	});
	
	$("#source_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["source"]));
	this.loadUIField();
	
	$("#urltype_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["urltype"] , "0"));
	
	$("#dataurl_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["dataurl"] , ""));
	
	MADGT_UrltypeChange(theId);
	
	var pagesize = Mec_FiexdUndefinedVal(this.mecJson["pagesize"]);
	if(pagesize == "" || isNaN(pagesize) || parseInt(pagesize) <= 0){
		pagesize = 100;
	}
	$("#pagesize_"+theId).val(pagesize);
	
	var pageexpandFlag = Mec_FiexdUndefinedVal(this.mecJson["pageexpandFlag"]);
	if(pageexpandFlag == "1"){
		$("#pageexpandFlag_"+theId).attr("checked","checked");
	}
	
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
	
	var totalsum = Mec_FiexdUndefinedVal(this.mecJson["totalsum"] , "0");
	if(totalsum == "1"){
		$("#totalsum_"+theId).attr("checked","checked");
	}
	
	var $attrContainer = $("#MADGT_"+theId);
	var list_datas = this.mecJson["list_datas"];
	if(!list_datas){
		list_datas = [];
	}
	if(list_datas.length == 0){
		$(".list_empty_tip", $attrContainer).show();
	}else{
		MADGT_LoadChooseField(theId,list_datas);
	}
	
	$("#searchTips_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["searchTips"],""));
	
	var advancedSearch = Mec_FiexdUndefinedVal(this.mecJson["advancedSearch"] , "0");
	if(advancedSearch == "1"){
		$("#advancedSearch_"+theId).attr("checked","checked");
		$(".MADGT_EditAdvancedSearch", $attrContainer).show();
		$("#advancedSearchConfig_" + theId).show();
	}
	$("#advancedSearchContent_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["advancedSearchContent"]));
	
	var searchAutoShow = Mec_FiexdUndefinedVal(this.mecJson["searchAutoShow"] , "0");
	if(searchAutoShow == "1"){
		$("#searchAutoShow_"+theId).attr("checked","checked");
	}
	
	var asBigTitle;
	if(this.mecJson.hasOwnProperty("asBigTitle")){
		asBigTitle = Mec_FiexdUndefinedVal(this.mecJson["asBigTitle"],"")
	}else{
		asBigTitle = "高级检索";
	}
	$("#asBigTitle_"+theId).val(asBigTitle);	
	
	var asSmallTitle;
	if(this.mecJson.hasOwnProperty("asSmallTitle")){
		asSmallTitle = Mec_FiexdUndefinedVal(this.mecJson["asSmallTitle"],"")
	}else{
		asSmallTitle = "Advanced Search";
	}
	$("#asSmallTitle_"+theId).val(asSmallTitle);
	
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
		MADGT_AddOneGridViewToPage(theId, gw_datas[i]);
	}
	
	new URLSelector("dataurl_"+theId).init();
	
	$("#MADGT_"+theId).jNice();
	MLanguage({
		container: $("#MADGT_"+theId + " .MADGT_BaseInfo")
    });
	$("#MADGT_"+theId + " .MADGT_GridView > ul").sortable({
		revert: false,
		axis: "y",
		items: "li",
		handle: ".bemove"
	});
};

/*获取JSON*/
MEC_NS.GridTable.prototype.getMecJson = function(){
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
		
		this.mecJson["pageexpandFlag"] = $("#pageexpandFlag_"+theId).is(':checked') ? "1" : "0";	//是否显示页面扩展按钮
		
		this.mecJson["hiddenSearch"] = $("#hiddenSearch_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["dataReadonly"] = $("#dataReadonly_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["lazyLoad"] = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["groupsum"] = $("#groupsum_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["totalsum"] = $("#totalsum_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["searchTips"] =  MLanguage.getValue($("#searchTips_"+theId))|| $("#searchTips_"+theId).val();	// 搜索提示文字
		
		this.mecJson["advancedSearch"] = $("#advancedSearch_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["advancedSearchContent"] = $("#advancedSearchContent_"+theId).val();
		
		this.mecJson["searchAutoShow"] = $("#searchAutoShow_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["asBigTitle"] =  MLanguage.getValue( $("#asBigTitle_"+theId)) || $("#asBigTitle_"+theId).val();
		
		this.mecJson["asSmallTitle"] =  MLanguage.getValue( $("#asSmallTitle_"+theId)) || $("#asSmallTitle_"+theId).val();
		
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
				var btnText =   MLanguage.getValue($("input[name='btnText']", $(this))) || $("input[name='btnText']", $(this)).val();
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
			var columnText = MLanguage.getValue($("input[name='columnText']", $(this)))|| $("input[name='columnText']", $(this)).val();
			var columnName = $("select[name='columnName']", $(this)).val();
			var columnWidth = $("input[name='columnWidth']", $(this)).val();
			var fieldid = $("select[name='columnName']", $(this)).find("option:selected").attr("fieldid");
			gw_datas.push({
				"columnText" : columnText,
				"columnName" : columnName,
				"columnWidth" : columnWidth,
				"fieldid" : fieldid
			});
		});
		this.mecJson["gw_datas"] = gw_datas;
	}
	
	return this.mecJson;
};

MEC_NS.GridTable.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["source"] = "";	//内容来源
	defMecJson["dataReadonly"] = "0";	//数据只读
	
	defMecJson["list_datas"] = [];
	
	defMecJson["btn_datas"] = [];
	
	defMecJson["searchTips"] = SystemEnv.getHtmlNoteName(4170); //搜索提示文字     请输入...
	
	defMecJson["gtWidth"] = "100%";
	defMecJson["gtHeight"] = "200";
	
	defMecJson["gw_datas"] = [];
	
	return defMecJson;
};

MEC_NS.GridTable.prototype.loadUIField = function(){
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

function MADGT_getListSelectOptionHtml(){
	var htm = "<option value=\"\"></option>";
	for(var i = 0; i < common_list_items.length; i++){
		var uiid = common_list_items[i]["uiid"];
		if((uiid + "").indexOf("homepage_") != -1) continue;
		var uiname = common_list_items[i]["uiname"];
		htm += "<option value=\""+uiid+"\">"+uiname+"</option>";
	}
	return htm;
}



function MADGT_SourceChange(mec_id){
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	mecHandler.loadUIField();
	var _fieldData = mecHandler._fieldData;
	
	
	
	var $attrContainer = $("#MADGT_"+mec_id);
	
	var $g_li = $(".MADGT_GridView > ul >li", $attrContainer);
	
	if($g_li.length > 0){
		
		var $columnName = $("select[name='columnName']", $g_li);
		$columnName.find("option").remove();
		
		if(_fieldData.length > 0){
			$columnName.append("<option></option>");
			
			for(var i = 0; i < _fieldData.length; i++){
				var data = _fieldData[i];
				var fieldid = data["fieldid"];
				var fieldName = data["fieldName"];
				var fieldDesc = data["fieldDesc"];
				
				var optionHtm = "<option value=\""+fieldName+"\" fieldid=\""+fieldid+"\">";
				optionHtm += fieldDesc;
				optionHtm += "</option>";
				$columnName.append(optionHtm);
			}
		}
	}
}

function MADGT_DelHtmlTag(str){
	return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
}

function MADGT_AddSearchColumnEntry(mec_id){
	
	var result = {};
	
	var $attrContainer = $("#MADGT_SearchColumn_"+mec_id);
	
	var id = new UUID().toString();
	result["id"] = id;
	result["fieldid"] = "";
	result["fieldName"] = "";
	
	var $source = $("#source_" + mec_id);
	var sourceV = $source.val();
	if(sourceV != ""){
		var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=getUIField&id=" + sourceV);
		FormmodeUtil.doAjaxDataLoad(url, function(datas){
			$(".list_empty_tip", $attrContainer).hide();
			MADGT_AddSearchColumnEntryToPage(mec_id, result,datas);
		});
	}

}

function MADGT_AddSearchColumnEntryToPage(mec_id, result,datas){
	var $attrContainer = $("#MADGT_SearchColumn_"+mec_id);
	
	var id = result["id"];
	var fieldid = result["fieldid"];
	var fieldName = result["fieldName"];
	
	var $listEntry = $("<li id=\"listEntry_"+id+"\" class=\"listEntry\"></li>");
	
	var listEntryHtm = "<div class=\"list_table_wrap\">"
						+ "<table>"
							+ "<tr>"
								+ "<td width=\"120px\">"
									
									+"<select class=\"MADGT_SearchColumn_Select\" id=\"fieldid_"+id+"\" onchange=\"MADGT_SearchColumn_SelectChange('"+id+"')\">"
										+"  <option value=\"\" fieldName=\"\"></option>";
										
										for(var i = 0; i < datas.length; i++){
											var data = datas[i];
											var pointid = data;
											var selected = "";
											if (pointid["fieldid"]=="" || typeof(pointid)=="undefined") continue;
											if (pointid["fieldid"] == fieldid) selected = "selected";
											listEntryHtm += "<option value=\""+pointid["fieldid"]+"\" fieldName=\""+pointid["fieldName"]+"\" "+selected+">";
											listEntryHtm += pointid["fieldDesc"];
											listEntryHtm += "</option>";
										}
										
					listEntryHtm += "</select>"
								+ "</td>"
								+ "<td width=\"150px\" align=\"center\">"
									+ "<div class=\"MADGT_SearchColumn_Selected_FieldName\" id=\"fieldName_"+id+"\">"+fieldName+"</div>"
								+ "</td>"
								+ "<td width=\"60px;\" align=\"right\">"
									+ "<input type=\"hidden\" value=\""+id+"\" class=\"MADGT_LIST_ID\">"
									+ "<span class=\"list_btn_del\" onclick=\"MADGT_DeleteListEntry('"+mec_id+"', '"+id+"');\"></span>"
								+ "</td>"
							+ "</tr>"
						+ "</table>"
					+"</div>";
	$listEntry.html(listEntryHtm);				
	
	var $ParentListEntry;
	$ParentListEntry = $(".list_ul_root", $attrContainer);

	$ParentListEntry.append($listEntry);
	
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
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
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

function MADGT_UrltypeChange(mec_id){
	var $Entry = $("#MADGT_"+mec_id);
	
	var urltype = $("select[name='urltype']", $Entry).val();
	if(urltype == "0"){
		$(".urlcontent-wrap", $Entry).hide();
	}else if(urltype == "1"){
		$(".urlcontent-wrap", $Entry).show();
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
			    	htm += "<input name=\"btnText\" type=\"text\" class=\"MADGT_Text\" style=\"height:22px;line-height:10px;\" value=\""+result["btnText"]+"\" placeholder=\""+SystemEnv.getHtmlNoteName(4177)+"\" data-multi=false/>";  //按钮名称
			    htm += "</td>";
			    
			    htm += "<td width=\"160px\">";
					htm += "<div class=\"btn_click_desc\">";
						htm += "<input name=\"btnScript\" type=\"hidden\" value=\"\"/>";
						htm += SystemEnv.getHtmlNoteName(4178);  //单击事件
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
	MLanguage({
		container: $li
    });
	$("input[name='btnScript']", $li)[0].value = result["btnScript"];
	
	$(".btn_click_desc", $li).click(function(){
		var $this = $(this);
		var $btnScript = $("input[name='btnScript']", $this);
		SL_AddScriptToField($btnScript);
	});
}

function MADGT_deleteOneBtnOnPage(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
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

function MADGT_AddGridView(mec_id){
	MADGT_AddOneGridViewToPage(mec_id);
}


function MADGT_AddOneGridViewToPage(mec_id, result){
	
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
			  
			    
			    htm += "<td width=\"115px\">";
					htm += "<select name=\"columnName\" style=\"width: 110px;\" onchange=\"MADGT_columnNameToText(this);\">";
					htm += "</select>";
				htm += "</td>";
				
				 htm += "<td width=\"105px\" valign=\"middle\">";
			    	htm += "<input name=\"columnText\" type=\"text\" style=\"width: 95px;\" value=\""+columnText+"\" placeholder=\""+SystemEnv.getHtmlNoteName(4595)+"\"  data-multi=false/>";  //列显示名称
			    htm += "</td>";
				
				htm += "<td width=\"70px\">";
					htm += "<input name=\"columnWidth\" type=\"text\" value=\""+columnWidth+"\" placeholder=\""+SystemEnv.getHtmlNoteName(4597)+"\"/>";  //列宽
				htm += "</td>";
				
				htm += "<td align=\"right\">";
					htm += "<span class=\"inparam_btn_del\" onclick=\"MADGT_deleteOneGridViewOnPage('"+mec_id+"',this)\"></span>";
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
	MLanguage({
		container: $li
    });
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var _fieldData = mecHandler._fieldData;
	
	if(_fieldData.length > 0){
		var $columnName = $("select[name='columnName']", $li);
		$columnName.append("<option></option>");
		
		for(var i = 0; i < _fieldData.length; i++){
			var data = _fieldData[i];
			var fieldid = data["fieldid"];
			var fieldName = data["fieldName"];
			var fieldDesc = data["fieldDesc"];
			
			var selected = "";
			if (fieldName == columnName){
				selected = "selected";
			}
			var optionHtm = "<option value=\""+fieldName+"\" fieldid=\""+fieldid+"\" "+selected+">";
			optionHtm += fieldDesc;
			optionHtm += "</option>";
			$columnName.append(optionHtm);
		}
	}
	
}

function MADGT_deleteOneGridViewOnPage(mec_id, obj){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	$(obj).closest(".g_li").remove();
	
	var $attrContainer = $("#MADGT_"+mec_id);
	
	if($(".MADGT_GridView > ul > li", $attrContainer).length == 0){
		
		$(".gridview_empty_tip", $attrContainer).show();
	}
		
}

function MADGT_columnNameToText(obj){
	var text = $(obj).find("option:selected").text();
	var $columnText = $("input[name='columnText']", $(obj).closest(".g_li"));
	$columnText.val(text);
	$("input[name='multilang_columnText']", $(obj).closest(".g_li")).val(text);
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

function MADGT_DisplayAdvancedSearch(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $attrContainer = $("#MADGT_"+mec_id);
		if(cbObj.checked){
			$(".MADGT_EditAdvancedSearch", $attrContainer).show();
			$("#advancedSearchConfig_" + mec_id).show();
		}else{
			$(".MADGT_EditAdvancedSearch", $attrContainer).hide();
			$("#advancedSearchConfig_" + mec_id).hide();
		}
	},100);
}

function MADGT_EditAdvancedSearch(mec_id){
	var $source = $("#source_" + mec_id);
	var sourceV = $source.val();
	if(sourceV != ""){
		
		var advancedSearchContent = Mec_FiexdUndefinedVal($("#advancedSearchContent_" + mec_id).val());
		advancedSearchContent = encodeURIComponent(advancedSearchContent);
		var url = "/mobilemode/listSearchConfig.jsp?sourceV="+sourceV+"&advancedSearchContent="+advancedSearchContent;
		var dlg = top.createTopDialog();//获取Dialog对象
		dlg.Model = true;
		dlg.Width = 425;//定义长度
		dlg.Height = 400;
		dlg.URL = url;
		dlg.Title = SystemEnv.getHtmlNoteName(4179);  //高级检索
		dlg.show();
		dlg.hookFn = function(result){
			$("#advancedSearchContent_" + mec_id).val(result["advancedSearchContent"]);
		};
	
	}else{
		alert(SystemEnv.getHtmlNoteName(4180));  //请先选择内容来源
	}
}

function MADGT_LoadChooseField(mec_id,list_datas){
	var $source = $("#source_" + mec_id);
	var sourceV = $source.val();
	if(sourceV != ""){
		var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=getUIField&id=" + sourceV);
		FormmodeUtil.doAjaxDataLoad(url, function(datas){
			for(var i = 0; list_datas && i < list_datas.length; i++){
				var rowfields = list_datas[i];
				MADGT_AddSearchColumnEntryToPage(mec_id, rowfields,datas);
			}
		});
	}
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
