if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.List = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = this.getDefaultMecJson();
	}
	this.mecJson = mecJson;
	this.fieldInfo = null;
}

/*获取id。 必需的方法*/
MEC_NS.List.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.List.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	var hasSearch = Mec_FiexdUndefinedVal(this.mecJson["hiddenSearch"]) != "1";
	var searchDisplay = hasSearch ? "block" : "none";
	htmTemplate = htmTemplate.replace("${searchDisplay}", searchDisplay);
	htmTemplate = htmTemplate.replace("${searchTips}", Mec_FiexdUndefinedVal(this.mecJson["searchTips"]));
	
	var dataReadonly = Mec_FiexdUndefinedVal(this.mecJson["dataReadonly"]);
	var readonly = (dataReadonly == "1") ? "readonly" : "";
	htmTemplate = htmTemplate.replace("${readonly}", readonly);
	
	htmTemplate = htmTemplate.replace(/\${theId}/g, theId);
	
	var btn_datas = this.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
	}
	var hasBtn = btn_datas.length > 0;
	var listBtnDisplay = hasBtn ? "block" : "none";
	htmTemplate = htmTemplate.replace("${listBtnDisplay}", listBtnDisplay);
	
	htmTemplate = htmTemplate.replace("${loadMore}", "");
	
	var advancedSearch = Mec_FiexdUndefinedVal(this.mecJson["advancedSearch"] , "0");
	var advancedSearchDisplay = (advancedSearch == "1") ? "block" : "none";
	htmTemplate = htmTemplate.replace("${advancedSearchDisplay}", advancedSearchDisplay);
	
	var forAsSearchStart;
	if((forAsSearchStart = htmTemplate.indexOf("$mec_as_search_start$")) != -1){
		var forAsSearchEnd = htmTemplate.indexOf("$mec_as_search_end$", forAsSearchStart);
		var forTemplate = htmTemplate.substring(forAsSearchStart, forAsSearchEnd + "$mec_list_btn_forend$".length);
		htmTemplate = htmTemplate.replace(forTemplate, "");
	}
	
	var forBtnStart;
	if((forBtnStart = htmTemplate.indexOf("$mec_list_btn_forstart$")) != -1){
		var forBtnEnd = htmTemplate.indexOf("$mec_list_btn_forend$", forBtnStart);
		var forTemplate = htmTemplate.substring(forBtnStart, forBtnEnd + "$mec_list_btn_forend$".length);
		var forContentTemplate = htmTemplate.substring(forBtnStart + "$mec_list_btn_forstart$".length, forBtnEnd);
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
	
	var forStart;
	while((forStart = htmTemplate.indexOf("$mec_forstart$")) != -1){
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		var forTemplate = "";
		var forContentTemplate = "";
		if(forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
			
			var forHtml = "";
			
			var imgPartDisplay = "";
			var imgfield = this.mecJson["imgfield"];
			
			var imgfieldid = imgfield["fieldid"];
			var imgFieldValue = "";
			if(imgfieldid && (imgfieldid > 0 || imgfieldid == -1)){
				imgFieldValue = "<img width=\"80\" height=\"80\" style=\"border: 1px solid rgb(81,145,233);border-radius: 4px;\" src=\"/mobilemode/images/mec/img-space_wev8.png\"/>";
			}else{
				imgFieldValue = "<img width=\"80\" height=\"80\" style=\"border: 1px solid rgb(204,204,204);border-radius: 4px;\" src=\"/mobilemode/images/mec/img-space1_wev8.png\"/>";
			}
			
			var titlefield = this.mecJson["titlefield"];
			var titleFieldValue = titlefield["fielddesc"] ? titlefield["fielddesc"] : SystemEnv.getHtmlNoteName(3534);  //标题
					
			forHtml += forContentTemplate.replace("${dataurl}", "")
									.replace("${imgPartDisplay}", imgPartDisplay)
									.replace("${imgfield}", imgFieldValue)
									.replace("${titlefield}", MADL_DelHtmlTag(titleFieldValue));
			
			var row_forStart;
			if((row_forStart = forTemplate.indexOf("$mec_list_row_forstart$")) != -1){
				var row_forEnd = forTemplate.indexOf("$mec_list_row_forend$", row_forStart);
				if(row_forEnd != -1){
					var row_forTemplate = forTemplate.substring(row_forStart, row_forEnd + "$mec_list_row_forend$".length);
					var row_forContentTemplate = forTemplate.substring(row_forStart + "$mec_list_row_forstart$".length, row_forEnd);
					var row_forHtml = "";
					
					var col_forStart;
					if((col_forStart = row_forTemplate.indexOf("$mec_list_col_forstart$")) != -1){
						var col_forEnd = row_forTemplate.indexOf("$mec_list_col_forend$", col_forStart);
						if(col_forEnd != -1){
							var col_forTemplate = row_forTemplate.substring(col_forStart, col_forEnd + "$mec_list_col_forend$".length);
							var col_forContentTemplate = row_forTemplate.substring(col_forStart + "$mec_list_col_forstart$".length, col_forEnd);
							
							var otherfields = this.mecJson["otherfields"];
							
							for(var i = 0; i < otherfields.length; i++){
								var rowfields = otherfields[i];
								var col_forHtml = "";
								for(var j = 0; j < rowfields.length; j++){
									var colfield = rowfields[j];
									var colFieldValue = colfield["fielddesc"] ? colfield["fielddesc"] : SystemEnv.getHtmlNoteName(4139);  //选择字段
									col_forHtml += col_forContentTemplate.replace("${colfield}", MADL_DelHtmlTag(colFieldValue));
								}
								row_forHtml += row_forContentTemplate.replace(col_forTemplate, col_forHtml);
							}
						}
					}
					forHtml = forHtml.replace(row_forTemplate, row_forHtml);
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

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.List.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	var $listBtn = $("#listsearch" + theId + " .listBtn");
	var $btns = $(".lbtn", $listBtn);
	
	if($btns.length > 0){
		var w = $listBtn.width() + 8;
		$("#listsearch" + theId + " .listHeader").css("right", w+"px");
	}
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.List.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	
	var theId = this.id;
	
	var row = this.mecJson["row"];
	var col = this.mecJson["col"];
	
	var fieldHtm = "";
	for(var i = 0; i < row; i++){
		fieldHtm += "<div class=\"MADL_FieldRowWrap\"><div class=\"del_btn\"></div>";
		for(var j = 0; j < col; j++){
			var colfield = {};
			fieldHtm += "<div class=\"MADL_FieldColWrap\">"
		        		+ "<span class=\"MADL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段   选择字段
		        		+ "<input type=\"hidden\" name=\"MADL_Field_Json\"/>"
		        	  + "</div>";
		}
		fieldHtm += "</div>";
	}
	var htm = "<div id=\"MADL_"+theId+"\" style=\"padding-bottom: 0px;\">"
					+ "<div class=\"MADL_Title\">"+SystemEnv.getHtmlNoteName(4140)+"</div>"  //列表信息
					+ "<div class=\"MADL_BaseInfo_MoreFlag\" id=\"MADL_BaseInfo_MoreFlag_"+theId+"\" style=\"top:0px;\">"
					+ SystemEnv.getHtmlNoteName(3888)  //更多
					+ "</div>"
					+ "<div class=\"MADL_BaseInfo\">"
						+ "<div>"
							+ "<span class=\"MADL_BaseInfo_span MADL_BaseInfo_span"+styleL+"\">"+SystemEnv.getHtmlNoteName(4141)+"</span>"+"<span class=\"MADL_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4142)+"</span> "  //名称   名称：
							+ "<input type=\"text\" id=\"name_"+theId+"\" name=\"name_"+theId+"\" class=\"MADL_Text MADL_Input"+styleL+"\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4583)+"\"></input>"  //一个中文的名称，如：人员列表
						+ "</div>"
						
						+ "<div>"
							+ "<span class=\"MADL_Desc"+styleL+"\">" + SystemEnv.getHtmlNoteName(4144) + "</span> "  //内容来源：
							+ "<select class=\"MADL_Select MADL_Select"+styleL+"\" id=\"source_"+theId+"\" onfocus=\"this.defOpt=this.selectedIndex\" onchange=\"MADL_SourceChange('"+theId+"');\" style=\"width: 265px;\">"
								+ MADL_getListSelectOptionHtml()
							+ "</select>"
						+ "</div>"
						
						+ "<div style=\"position: relative;\">"
							+ "<span class=\"MADL_Desc"+styleL+"\">" + SystemEnv.getHtmlNoteName(4145) + "</span> "  //数据链接：
							+ "<select class=\"MADL_Select MADL_Select"+styleL+"\" name=\"urltype\" id=\"urltype_"+theId+"\" onchange=\"MADL_UrltypeChange('"+theId+"')\" style=\"width:auto;\">"
		 						+ "<option value=\"0\">"+SystemEnv.getHtmlNoteName(4146)+"</option>"  //自动解析
		 						+ "<option value=\"1\">"+SystemEnv.getHtmlNoteName(4147)+"</option>"  //手动输入
		 					+ "</select>"
		 					+ "<span class=\"urlcontent-wrap\" style=\"display: inline-block;\">"
							+ "<input type=\"text\" id=\"dataurl_"+theId+"\" class=\"MADL_Text urlcontent urlcontent"+styleL+"\" placeholder=\""+SystemEnv.getHtmlNoteName(4993)+"\"/>" //输入页面地址
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"MADL_BaseInfo_MoreContainer MADL_BaseInfo_MoreContainer"+styleL+"\" id=\"MADL_BaseInfo_MoreContainer_"+theId+"\">"
						
							+ "<table class=\"attrTable\">"
								+ "<tr class=\"titleTr\">"
									+ "<td>"+SystemEnv.getHtmlNoteName(4148)+"</td>"  //每页条数
									+ "<td>"+SystemEnv.getHtmlNoteName(4149)+"</td>"  //扩展按钮
									+ "<td>"+SystemEnv.getHtmlNoteName(4150)+"</td>"  //隐藏查询
									+ "<td>"+SystemEnv.getHtmlNoteName(4151)+"</td>"  //数据只读
									+ "<td>"+SystemEnv.getHtmlNoteName(4129)+"</td>"  //延迟加载
								+ "</tr>"
								+ "<tr>"
									+ "<td><input type=\"text\" id=\"pagesize_"+theId+"\" class=\"MADL_Text\" style=\"width: 35px;height: 18px; line-height: 10px;\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"pageexpandFlag_"+theId+"\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"hiddenSearch_"+theId+"\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"dataReadonly_"+theId+"\"/></td>"
									+ "<td><input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/></td>"
								+ "</tr>"
							+ "</table>"
						
							+ "<div id=\"MADL_SearchColumn_"+theId+"\" style=\"margin-bottom:10px;margin-right:10px;\">"
								+ "<div class=\"list_search_column_title\">"
									+ SystemEnv.getHtmlNoteName(4152) //指定查询列
									+ "<div class=\"list_search_column_add\" onclick=\"MADL_AddSearchColumnEntry('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
								+ "</div>"
								+ "<div class=\"list_search_column_content\">"
									+ "<div class=\"list_empty_tip\">"+SystemEnv.getHtmlNoteName(4154)+SystemEnv.getHtmlNoteName(4156)+SystemEnv.getHtmlNoteName(4157)+"</div>"  //单击右上角的添加按钮以添加查询列，如果未指定查询列，则默认按照展示中选择的第一列进行查询
									+ "<ul class=\"list_ul_root\"></ul>"
								+ "</div>"
							+ "</div>"
							
							+ "<div id=\"MADL_ListBtn_"+theId+"\" style=\"margin-bottom:10px;margin-right:10px;\">"
								+ "<div class=\"list_btn_title\">"
									+ SystemEnv.getHtmlNoteName(4158)  //自定义按钮
									+ "<div class=\"list_btn_add\" onclick=\"MADL_AddBtn('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
								+ "</div>"
								+ "<div class=\"list_btn_content\">"
									+ "<div class=\"list_btn_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
									+ "<ul></ul>"
								+ "</div>"
							+ "</div>"
							
							+ "<div>"
								+ "<span>"+SystemEnv.getHtmlNoteName(4160)+"</span>"  //搜索提示文字：
								+ "<input type=\"text\" id=\"searchTips_"+theId+"\" class=\"MADL_Text\" style=\"width: 247px;\" data-multi=false></input>"
							+ "</div>"
							
							+ "<div>"
								+ "<div style=\"margin-bottom:0px;position: relative;\">"+SystemEnv.getHtmlNoteName(4161)  //单条数据向左滑动时配置：
									+ "<div class=\"MADL_EditSwipeContent MADL_EditSwipeContent"
									+ styleL +"\" onclick=\"MADL_EditSwipeContent('"+theId+"');\"></div>"
									+ "<div class=\"swipeContent_tip swipeContent_tip"+ styleL +"\" onclick=\"MADL_EditSwipeContent('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4162)+"</div>"  //已配置
									+ "<input type=\"hidden\" name=\"swipeType_"+theId+"\"/>"
								+ "</div>"
								+ "<input id=\"swipeStyle_"+theId+"\" type=\"hidden\"/>"
								+ "<input id=\"swipeContent_"+theId+"\" type=\"hidden\"/>"
								+ "<input id=\"swipeParams_"+theId+"\" type=\"hidden\"/>"
							+ "</div>"
							
							+ "<div>"
								+ "<div style=\"margin-bottom:0px;position: relative;\">"+SystemEnv.getHtmlNoteName(4163)  //高级检索：
									+ "<input type=\"checkbox\" id=\"advancedSearch_"+theId+"\" onclick=\"MADL_DisplayAdvancedSearch(this, '"+theId+"');\"/>"
									+ "<div class=\"MADL_EditAdvancedSearch MADL_EditAdvancedSearch"
									+ styleL + "\" onclick=\"MADL_EditAdvancedSearch('"+theId+"');\"></div>"
									+ "<input id=\"advancedSearchContent_"+theId+"\" type=\"hidden\"/>"
								+ "</div>"
							+ "</div>"
							
							+ "<div id=\"advancedSearchConfig_"+theId+"\" style=\"display:none;\">"
								+ "<div>"
									+ "<span>"+SystemEnv.getHtmlNoteName(4320)+"</span>" //默认显示：
									+ "<input type=\"checkbox\" id=\"searchAutoShow_"+theId+"\"/>&nbsp;"+SystemEnv.getHtmlNoteName(4868)//默认显示高级检索，通过检索显示列表
								+ "</div>"
								+ "<div>"
									+ "<span>"+SystemEnv.getHtmlNoteName(4869)+"</span>" //页面标题：
									+ "<input type=\"text\" id=\"asBigTitle_"+theId+"\" data-multi=false style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 100px;\">&nbsp;-&nbsp;"
									+ "<input type=\"text\" id=\"asSmallTitle_"+theId+"\" data-multi=false style=\"border: 1px solid rgb(204, 204, 204);height: 20px;padding-left: 3px;width: 100px;\">"
								+ "</div>"
							+ "</div>"
						
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADL_Title MADL_Title"+styleL+"\">"+SystemEnv.getHtmlNoteName(4164)+"</div>"  //展示样式
					
					+ "<div class=\"MADL_StyleConfig\" id=\"MADL_StyleConfig_"+theId+"\">"
						+ "<div class=\"MADL_StyleConfig_Column\">"
							+ SystemEnv.getHtmlNoteName(4585)  //列数：
							+ "<span class=\"MADL_Column_Minus\"></span>"
							+ "<input type=\"text\" id=\"column_"+theId+"\" class=\"MADL_Column_Text\" value=\""+col+"\" disabled=\"disabled\"/>"
							+ "<span class=\"MADL_Column_Add\"></span>"
						+ "</div>"
						
						+ "<div class=\"MADL_StyleConfig_Row\">"+SystemEnv.getHtmlNoteName(3575)+"</div>"  //添加行
					+ "</div>"
					
					
					+ "<div class=\"MADL_StyleWrap\">"
        				+ "<div class=\"MADL_Style\" id=\"MADL_Style_"+theId+"\">"
        					+ "<div class=\"MADL_Style_L\">"
        						+ "<div class=\"MADL_ImgFieldWrap\">"
			                        + "<span class=\"MADL_ImgField\" title=\""+SystemEnv.getHtmlNoteName(4166)+"\">"+SystemEnv.getHtmlNoteName(4167)+"</span>"  //图片字段    图片
			                        + "<input type=\"hidden\" name=\"MADL_Field_Json\"/>"
		                        + "</div>"
		                    + "</div>"
		                    
		                    + "<div class=\"MADL_Style_R\">"
		                    	+ "<div class=\"MADL_FieldRowWrap MADL_TitleFieldRowWrap\">"
		                    		+ "<div class=\"MADL_FieldColWrap\">"
		                        		+ "<span class=\"MADL_Field MADL_TitleField\">"+SystemEnv.getHtmlNoteName(3534)+"</span>"  //标题
		                        		+ "<input type=\"hidden\" name=\"MADL_Field_Json\"/>"
		                        	+ "</div>"
		                        + "</div>"
		                        + fieldHtm
		                    + "</div>"
        				+ "</div>"
    				+ "</div>"
					
					
					+ "<div class=\"MADL_Bottom\">"
    					+ "<div class=\"MADL_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>"  //确定
    				+ "</div>"
    				
    				+ "<div class=\"MADL_ChooseFields\" id=\"MADL_ChooseFields_"+theId+"\">"                        
    					+ "<span class=\"MADL_ChooseFields_Top\"></span>"  
    					+ "<span class=\"MADL_ChooseFields_Top2\"></span>"                    
    					+ "<div class=\"MADL_ChooseFields_Container\">" 
    						+ "<label class=\"MADL_CField MADL_CField_None\" fieldid=\"0\">"+SystemEnv.getHtmlNoteName(4168)+"</label>" //无                       
    						+ "<div class=\"MADL_CFieldWrap\">"
    						+ "</div>"
    						+ "<div class=\"MADL_CField_CustomWrap\">"
    							+ "<label class=\"MADL_CField MADL_CField_Custom\" fieldid=\"-1\">"
    								+ "<div class=\"MADL_CField_Custom_Tip\">"+SystemEnv.getHtmlNoteName(4169)+"</div>"  //点击输入字段内容
    								+ "<div class=\"MADL_CField_Custom_Content\">"
    									+ "<textarea class=\"MADL_CField_Custom_Text\"></textarea>"
    									+ "<div class=\"MADL_CField_Custom_Btn\">"+SystemEnv.getHtmlNoteName(3451)+"</div>"  //确定
    								+ "</div>"
    							+ "</label>"
    						+ "</div>"
    					+ "</div>"                    
    				+ "</div>"
			+ "</div>";
			
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.List.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	$("#MADL_BaseInfo_MoreFlag_" + theId).click(function(e){
		var $moreThis = $(this);
		$("#MADL_BaseInfo_MoreContainer_" + theId).slideToggle(100, function(){
			if($(this).is(":visible")){
				$moreThis.addClass("MADL_BaseInfo_MoreFlag_Hidden");
				$moreThis.html(SystemEnv.getHtmlNoteName(3549));  //隐藏
			}else{
				$moreThis.removeClass("MADL_BaseInfo_MoreFlag_Hidden");
				$moreThis.html(SystemEnv.getHtmlNoteName(3888));  //更多
			}
		});
		e.stopPropagation();
	});
	
	$("#name_"+theId).val(this.mecJson["name"]);	
	
	$("#source_"+theId).val(this.mecJson["source"]);	
	
	$("#urltype_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["urltype"] , "0"));
	
	$("#dataurl_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["dataurl"] , ""));
	
	MADL_UrltypeChange(theId);
	
	var pagesize = Mec_FiexdUndefinedVal(this.mecJson["pagesize"]);
	if(pagesize == "" || isNaN(pagesize) || parseInt(pagesize) <= 0){
		pagesize = 10;
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
	
	var $attrContainer = $("#MADL_"+theId);
	
	$("#searchTips_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["searchTips"],""));
	
	var advancedSearch = Mec_FiexdUndefinedVal(this.mecJson["advancedSearch"] , "0");
	if(advancedSearch == "1"){
		$("#advancedSearch_"+theId).attr("checked","checked");
		$(".MADL_EditAdvancedSearch", $attrContainer).show();
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
	
	var list_datas = this.mecJson["list_datas"];
	if(!list_datas){
		list_datas = [];
	}
	if(list_datas.length == 0){
		$(".list_empty_tip", $attrContainer).show();
	}
	
	var btn_datas = this.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
	}
	if(btn_datas.length == 0){
		$(".list_btn_empty_tip", $attrContainer).show();
	}
	for(var i = 0; btn_datas && i < btn_datas.length; i++){
		MADL_AddBtnToPage(theId, btn_datas[i]);
	}
	
	var swipeType = Mec_FiexdUndefinedVal(this.mecJson["swipeType"], "1");
	$("input[name='swipeType_"+theId+"']").val(swipeType);
	
	var swipeStyle = Mec_FiexdUndefinedVal(this.mecJson["swipeStyle"], 1);
	$("#swipeStyle_" + theId).val(swipeStyle);
	
	var swipeContent = Mec_FiexdUndefinedVal(this.mecJson["swipeContent"], "");
	$("#swipeContent_"+theId)[0].value = swipeContent;
	
	if($("#swipeContent_" + theId).val()!=""){
		$(".swipeContent_tip").show();
	}
	
	var swipeParams = MADL_FormatJson2Value(Mec_FiexdUndefinedVal(this.mecJson["swipeParams"], []));
	$("#swipeParams_" + theId).val(swipeParams);
	
	var $MADL_Style = $("#MADL_Style_" + theId);
	
	var imgfield = this.mecJson["imgfield"];		//图片字段信息
	var imgfieldV = MADL_FormatJson2Value(imgfield);
	if(imgfieldV != ""){
		$(".MADL_ImgFieldWrap input[name='MADL_Field_Json']", $MADL_Style).val(imgfieldV);
		var fieldid = imgfield["fieldid"];
		if(fieldid != "0"){
			$(".MADL_ImgFieldWrap", $MADL_Style).addClass("MADL_FieldColWrap_Choosed");
		}
	}
	
	var titlefield = this.mecJson["titlefield"];	//标题字段信息
	var titlefieldV = MADL_FormatJson2Value(titlefield);
	if(titlefieldV != ""){
		$(".MADL_TitleFieldRowWrap input[name='MADL_Field_Json']", $MADL_Style).val(titlefieldV);
		var fieldid = titlefield["fieldid"];
		var fielddesc = titlefield["fielddesc"];
		$(".MADL_TitleFieldRowWrap .MADL_Field", $MADL_Style).html(MADL_DelHtmlTag(fielddesc));
		if(fieldid != "0"){
			$(".MADL_TitleFieldRowWrap .MADL_FieldColWrap", $MADL_Style).addClass("MADL_FieldColWrap_Choosed");
		}
	}
	
	var otherfields = this.mecJson["otherfields"];
	var $MADL_FieldRowWrap = $(".MADL_Style_R .MADL_FieldRowWrap", $MADL_Style).not(".MADL_TitleFieldRowWrap");
	$MADL_FieldRowWrap.each(function(i){
		$(".MADL_FieldColWrap", $(this)).each(function(j){
			var colfield = otherfields[i][j];
			var colfieldV = MADL_FormatJson2Value(colfield);
			if(colfieldV != ""){
				$("input[name='MADL_Field_Json']", $(this)).val(colfieldV);
				var fieldid = colfield["fieldid"];
				var fielddesc = colfield["fielddesc"];
				$(".MADL_Field", $(this)).html(MADL_DelHtmlTag(fielddesc));
				if(fieldid != "0"){
					$(this).addClass("MADL_FieldColWrap_Choosed");
				}
			}
		});
	});
	
	MADL_ResizeFieldColWidth(theId);
	
	MADL_BindRowOpt(theId);
	
	MADL_BindColOpt(theId);
	
	MADL_LoadChooseField(theId,list_datas);
	
	MADL_BindFieldChoose(theId);
	
	new URLSelector("dataurl_"+theId).init();
	
	$("#MADL_"+theId).jNice();
	
	MLanguage({
		container: $("#MADL_"+theId + " .MADL_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.List.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADL_"+theId);
	if($attrContainer.length > 0){
		var $MADL_Style = $("#MADL_Style_" + theId);
		var $MADL_FieldRowWrap = $(".MADL_Style_R .MADL_FieldRowWrap", $MADL_Style).not(".MADL_TitleFieldRowWrap");
		
		this.mecJson["name"] = MLanguage.getValue($("#name_"+theId)) || $("#name_"+theId).val();// 列表名称
		
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
		
		this.mecJson["searchTips"] = MLanguage.getValue($("#searchTips_"+theId)) || $("#searchTips_"+theId).val();// 搜索提示文字
		
		this.mecJson["advancedSearch"] = $("#advancedSearch_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["advancedSearchContent"] = $("#advancedSearchContent_"+theId).val();
		
		this.mecJson["searchAutoShow"] = $("#searchAutoShow_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["asBigTitle"] = MLanguage.getValue($("#asBigTitle_"+theId)) || $("#asBigTitle_"+theId).val();
		
		this.mecJson["asSmallTitle"] = MLanguage.getValue($("#asSmallTitle_"+theId)) || $("#asSmallTitle_"+theId).val();
		
		var $searchColumnContent = $("#MADL_SearchColumn_" + theId);
		var $listEntry = $(".listEntry", $searchColumnContent);
		var list_datas = [];
		$listEntry.each(function(){
			var rowfields = {};
			var id = $(".MADL_LIST_ID", $(this)).val();
			var fieldid = $(".MADL_SearchColumn_Select", $(this)).val();
			var fieldName = $(".MADL_SearchColumn_Selected_FieldName", $(this)).html();
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
						btn_datas[i]["btnText"] = MLanguage.getValue($("input[name='btnText']", $(this))) || btnTextML;
						btn_datas[i]["btnScript"] = btnScript;
						break;
					}
				}
			}
		});
		
		this.mecJson["swipeType"] = $("input[name='swipeType_"+theId+"']").val();
		
		this.mecJson["swipeStyle"] = $("#swipeStyle_"+theId).val();
		
		this.mecJson["swipeContent"] = $("#swipeContent_"+theId).val();
		
		this.mecJson["swipeParams"] = MADL_FormatValue2Json($("#swipeParams_"+theId).val());
		
		this.mecJson["row"] = $MADL_FieldRowWrap.length;	//行数
		this.mecJson["col"] = $("#column_"+theId).val();	//列数
		
		var imgfieldV = $(".MADL_ImgFieldWrap input[name='MADL_Field_Json']", $MADL_Style).val();
		this.mecJson["imgfield"] = MADL_FormatValue2Json(imgfieldV);		//图片字段信息
		
		var titlefieldV = $(".MADL_TitleFieldRowWrap input[name='MADL_Field_Json']", $MADL_Style).val();
		this.mecJson["titlefield"] = MADL_FormatValue2Json(titlefieldV);	//标题字段信息
	
		var otherfields = [];
		$MADL_FieldRowWrap.each(function(){
			var rowfields = [];
			$(".MADL_FieldColWrap", $(this)).each(function(){
				var colV = $("input[name='MADL_Field_Json']", $(this)).val();
				var colfield = MADL_FormatValue2Json(colV);
				rowfields.push(colfield);
			});
			otherfields.push(rowfields);
		});
		this.mecJson["otherfields"] = otherfields;
	}
	
	return this.mecJson;
};

MEC_NS.List.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var row = 3;
	var col = 1;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["source"] = "";	//内容来源
	defMecJson["row"] = row;	//行数
	defMecJson["col"] = col;	//列数
	
	defMecJson["list_datas"] = [];
	
	defMecJson["btn_datas"] = [];
	
	var swipeParams = [];
	defMecJson["swipeParams"] = swipeParams;
	defMecJson["swipeStyle"] = 1;
	defMecJson["swipeContent"] = "";
	defMecJson["swipeType"] = "1";
	
	defMecJson["searchTips"] = SystemEnv.getHtmlNoteName(4170); //搜索提示文字    请输入...
	
	defMecJson["imgfield"] = {};	//图片字段信息
	defMecJson["titlefield"] = {};	//图片字段信息
	
	var otherfields = [];
	for(var i = 0; i < row; i++){
		var rowfields = [];
		for(var j = 0; j < col; j++){
			var colfield = {};
			rowfields.push(colfield);
		}
		otherfields.push(rowfields);
	}
	defMecJson["otherfields"] = otherfields;
	return defMecJson;
};

/* 获取列表名称 */
MEC_NS.List.prototype.getName = function(){
	var theId = this.id;
	
	var name = this.mecJson["name"];
	if(name == "" || $.trim(name) == ""){
		name = theId;
	}
	
	return name;
};

/* 获取列表字段 */
MEC_NS.List.prototype.getFieldInfo = function(){
	var that = this;
	var theId = that.id;
	
	if(that.fieldInfo == null){
		var sourceV = "";
		
		var $source = $("#source_" + theId);
		if($source.length > 0){
			sourceV = $source.val();
		}else{
			sourceV = that.mecJson["source"];
		}
		
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
			 		var datas = $.parseJSON(responseText);
			 		that.fieldInfo = datas;
			 	},
			    error: function(){
			    	that.fieldInfo = [];
			    }
			});
		}else{
			that.fieldInfo = [];
		}
	}
	
	return that.fieldInfo;
};

function MADL_FormatValue2Json(v){
	return v == "" ? {} : $.parseJSON(v);
}

function MADL_FormatJson2Value(jsonObj){
	return $.isEmptyObject(jsonObj) ? "" : JSON.stringify(jsonObj);
}

function MADL_getListSelectOptionHtml(){
	var htm = "<option value=\"\"></option>";
	for(var i = 0; i < common_list_items.length; i++){
		var uiid = common_list_items[i]["uiid"];
		if((uiid + "").indexOf("homepage_") != -1) continue;
		var uiname = common_list_items[i]["uiname"];
		htm += "<option value=\""+uiid+"\">"+uiname+"</option>";
	}
	return htm;
}

function MADL_ResizeFieldColWidth(mec_id){
	var $MADL_FieldRowWrap = $("#MADL_Style_" + mec_id + " .MADL_Style_R .MADL_FieldRowWrap").not(".MADL_TitleFieldRowWrap");
	$MADL_FieldRowWrap.each(function(){
		var rowWidth = parseInt($(this).width());
		var $MADL_FieldColWrap = $(".MADL_FieldColWrap", $(this));
		var colCount = parseInt($MADL_FieldColWrap.length);
		var colWidth = parseInt(rowWidth/colCount);
		var lastColWidth = colWidth + (rowWidth - (colWidth * colCount));
		var colWidthArr = new Array();
		for(var i = 0; i < colCount; i++){
			if(i != (colCount - 1)){
				colWidthArr.push(colWidth);
			}else{
				colWidthArr.push(lastColWidth);
			}
		}
		$MADL_FieldColWrap.each(function(i){
			$(this).width(colWidthArr[i]);
		});
	});
}

function MADL_BindColOpt(mec_id){
	var $MADL_StyleConfig = $("#MADL_StyleConfig_" + mec_id);
	var $column = $("#column_" + mec_id);
	$(".MADL_Column_Add", $MADL_StyleConfig).click(function(){
		var colV = parseInt($column.val());
		
		var $MADL_Style = $("#MADL_Style_" + mec_id);
		var $MADL_FieldRowWrap = $(".MADL_Style_R .MADL_FieldRowWrap", $MADL_Style).not(".MADL_TitleFieldRowWrap");
		var colHtml = "<div class=\"MADL_FieldColWrap\">"
						+ "<span class=\"MADL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段  选择字段
                		+ "<input type=\"hidden\" name=\"MADL_Field_Json\"/>"
                	+ "</div>";
		$MADL_FieldRowWrap.append(colHtml);
		
		MADL_ResizeFieldColWidth(mec_id);
		
		colV++;
		$column.val(colV);
		
	});
	
	$(".MADL_Column_Minus", $MADL_StyleConfig).click(function(){
		var colV = parseInt($column.val());
		if(colV <= 1){
			return;
		}
		var $MADL_Style = $("#MADL_Style_" + mec_id);
		var $MADL_FieldRowWrap = $(".MADL_Style_R .MADL_FieldRowWrap", $MADL_Style).not(".MADL_TitleFieldRowWrap");
		$(".MADL_FieldColWrap:last-child", $MADL_FieldRowWrap).remove();
		
		MADL_ResizeFieldColWidth(mec_id);
		
		colV--;
		$column.val(colV);
	});
}

function MADL_BindRowOpt(mec_id){
	var $MADL_StyleConfig = $("#MADL_StyleConfig_" + mec_id);
	$(".MADL_StyleConfig_Row", $MADL_StyleConfig).click(function(){
		var $MADL_Style_R = $("#MADL_Style_" + mec_id + " .MADL_Style_R");
		var $column = $("#column_" + mec_id);
		var colV = parseInt($column.val());
		var $MADL_FieldRowWrap = $("<div class=\"MADL_FieldRowWrap\"><div class=\"del_btn\"></div></div>");
		var colHtml = "";
		for(var i = 0; i < colV; i++){
			colHtml += "<div class=\"MADL_FieldColWrap\">"
						+ "<span class=\"MADL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段   选择字段
                		+ "<input type=\"hidden\" name=\"MADL_Field_Json\"/>"
                	 + "</div>";
		}
		$MADL_FieldRowWrap.append(colHtml);
		$MADL_Style_R.append($MADL_FieldRowWrap);
		
		MADL_ResizeFieldColWidth(mec_id);
		
	});
	
	$("#MADL_Style_" + mec_id + " .MADL_Style_R .MADL_FieldRowWrap .del_btn").live("click", function(){
		$(this).parent().remove();
	});
}

function MADL_BindFieldChoose(mec_id){
	$("#MAD_" + mec_id).click(function(){
		$("#MADL_ChooseFields_" + mec_id).hide();
	});
	
	function setMADLChooseField(ele){
		$("#MADL_Style_" + mec_id + " .MADL_FieldColWrap_Curr").removeClass("MADL_FieldColWrap_Curr");
		
		var $MADL_ChooseFields = $("#MADL_ChooseFields_" + mec_id);
		
		$(".MADL_CField_Checked", $MADL_ChooseFields).removeClass("MADL_CField_Checked");
		$(".MADL_CField_Custom_Tip", $MADL_ChooseFields).show();
		$(".MADL_CField_Custom_Content", $MADL_ChooseFields).hide();
		$(".MADL_CField_Custom_Text", $MADL_ChooseFields).val("");
		
		var $MADL_Field_Json = $("input[name='MADL_Field_Json']", $(ele));
		if($MADL_Field_Json.val() != ""){
			var f_json = $.parseJSON($MADL_Field_Json.val());
			var fieldid = f_json["fieldid"];
			var fielddesc = f_json["fielddesc"];
			$("#MADL_ChooseFields_" + mec_id + " .MADL_CField[fieldid='"+fieldid+"']").addClass("MADL_CField_Checked");
			if(fieldid == "-1"){
				$(".MADL_CField_Custom_Tip", $MADL_ChooseFields).hide();
				$(".MADL_CField_Custom_Content", $MADL_ChooseFields).show();
				$(".MADL_CField_Custom_Text", $MADL_ChooseFields).val(fielddesc);
			}
		}
		$(ele).addClass("MADL_FieldColWrap_Curr");
	}
	
	$("#MADL_Style_" + mec_id + " .MADL_ImgFieldWrap").click(function(e){
		setMADLChooseField(this);
		MADL_PositionChooseFieldAndShow(this, mec_id);
		e.stopPropagation(); 
	});
	
	$("#MADL_Style_" + mec_id + " .MADL_FieldColWrap").live("click", function(e){
		setMADLChooseField(this);
		MADL_PositionChooseFieldAndShow(this, mec_id);
		e.stopPropagation(); 
	});
	
	function setMADLField(ele){
		var $ele = $(ele);
		
		var fieldid = $ele.attr("fieldid");
		var fielddesc;
		if($ele.hasClass("MADL_CField_Custom")){
			fielddesc = $(".MADL_CField_Custom_Text", $ele).val();
		}else{
			fielddesc = $ele.html();
		}
		fielddesc = $.trim(fielddesc);
		
		var f_json = {"fieldid":fieldid, "fielddesc":fielddesc};
		
		var $MADL_FieldColWrap_Curr = $("#MADL_Style_" + mec_id + " .MADL_FieldColWrap_Curr");
		$MADL_FieldColWrap_Curr.removeClass("MADL_FieldColWrap_Choosed");
		if(fieldid != "0"){
			$MADL_FieldColWrap_Curr.addClass("MADL_FieldColWrap_Choosed");
		}
		if(!$MADL_FieldColWrap_Curr.hasClass("MADL_ImgFieldWrap")){
			var $MADL_Field = $(".MADL_Field", $MADL_FieldColWrap_Curr);
			$MADL_Field.html(MADL_DelHtmlTag(fielddesc));
			//$MADL_Field.attr("title", fielddesc);
		}
		var $MADL_Field_Json = $("input[name='MADL_Field_Json']", $MADL_FieldColWrap_Curr);
		$MADL_Field_Json.val(JSON.stringify(f_json));
	}
	
	
	$("#MADL_ChooseFields_" + mec_id + " .MADL_CField_None").click(function(e){
		setMADLField(this);
	});
	
	$("#MADL_ChooseFields_" + mec_id + " .MADL_CFieldWrap .MADL_CField").live("click", function(e){
		setMADLField(this);
	});
	
	$("#MADL_ChooseFields_" + mec_id + " .MADL_CField_Custom").click(function(e){
		var $MADL_CField_Custom_Content = $(".MADL_CField_Custom_Content", $(this));
		if(!$MADL_CField_Custom_Content.is(":visible")){
			$(".MADL_CField_Custom_Tip", $(this)).hide();
			$MADL_CField_Custom_Content.show();
		}
		e.stopPropagation(); 
	});
	
	$("#MADL_ChooseFields_" + mec_id + " .MADL_CField_Custom .MADL_CField_Custom_Btn").click(function(e){
		setMADLField($(this).parents(".MADL_CField_Custom")[0]);
		$("#MADL_ChooseFields_" + mec_id).hide();
		e.stopPropagation(); 
	});
}

function MADL_SourceChange(mec_id){
	var $MADL_Style = $("#MADL_Style_" + mec_id);
	var $MADL_Field_Json = $("input[name='MADL_Field_Json']", $MADL_Style);
	var $MADL_Field_Json2 = $MADL_Field_Json.filter("[value!='']");
	if($MADL_Field_Json2.length > 0){
		top.Dialog.confirm(SystemEnv.getHtmlNoteName(4172)+SystemEnv.getHtmlNoteName(4173)+"<br/>"+SystemEnv.getHtmlNoteName(4174),function(){   //切换列表会导致展示样式中已选择的字段信息丢失   确认要继续吗？
			//确认
			$MADL_Field_Json2.each(function(){
				$(this).val("");
				var $MADL_Field = $(this).parent().find(".MADL_Field");
				if($MADL_Field.hasClass("MADL_TitleField")){
					$MADL_Field.html(SystemEnv.getHtmlNoteName(3534));  //标题
				}else{
					$MADL_Field.html(SystemEnv.getHtmlNoteName(4139));  //选择字段
				}
				$(this).parents(".MADL_FieldColWrap_Choosed").removeClass("MADL_FieldColWrap_Choosed");
			});
			MADL_LoadChooseField(mec_id);
		},function(){
			//取消
			var sourceObj = document.getElementById("source_" + mec_id);
			sourceObj.selectedIndex = sourceObj.defOpt;
		});
	}else{
		MADL_LoadChooseField(mec_id);
	}
	
	// 给列表名称赋值
	var text_name = $("#source_"+mec_id).find("option:selected").text();
	if(typeof(text_name) != "undefined" && text_name != ""){
		text_name = $.trim(text_name.split("（")[0]);
	}
	$("#name_"+mec_id).val(text_name);
	$("input[name='multilang_name_"+mec_id+"']").val(text_name);  
	
}

function MADL_LoadChooseField(mec_id,list_datas){
	
	var $MADL_ChooseFields = $("#MADL_ChooseFields_" + mec_id);
	var $MADL_CFieldWrap = $(".MADL_ChooseFields_Container > .MADL_CFieldWrap", $MADL_ChooseFields);
	$MADL_CFieldWrap.find("*").remove();
	
	var $source = $("#source_" + mec_id);
	var sourceV = $source.val();
	if(sourceV != ""){
		var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=getUIField&id=" + sourceV);
		FormmodeUtil.doAjaxDataLoad(url, function(datas){
			
			var mecHandler = MECHandlerPool.getHandler(mec_id);
			mecHandler.fieldInfo = datas;
				
			for(var i = 0; list_datas && i < list_datas.length; i++){
				var rowfields = list_datas[i];
				MADL_AddSearchColumnEntryToPage(mec_id, rowfields,datas);
			}
			
			for(var i = 0; i < datas.length; i++){
				var data = datas[i];
				var htm = "<label class=\"MADL_CField\" fieldid=\""+data["fieldid"]+"\" title=\""+data["fieldName"]+"\">"+data["fieldDesc"]+"</label>";
				$MADL_CFieldWrap.append(MLanguage.parse(htm));
			}
		});
	}
}

function MADL_PositionChooseFieldAndShow(ele, mec_id){
	var $MAD = $("#MAD_" + mec_id);	//顶级元素
	var $MADL_ChooseFields = $("#MADL_ChooseFields_" + mec_id);
	
	var p_offset = $MAD.offset();
	var p_t = p_offset.top;
	var p_l = p_offset.left;
	
	var $ele = $(ele);
	var e_offset = $ele.offset();
	var e_t = e_offset.top;
	var e_l = e_offset.left;
	
	$MADL_ChooseFields.removeClass("MADL_ChooseFields_Img");
	
	var t;
	var l;
	if($ele.hasClass("MADL_ImgFieldWrap")){
		t = (e_t - p_t) + $ele.height() + 11;
		l = (e_l - p_l);
		$MADL_ChooseFields.addClass("MADL_ChooseFields_Img");
	}else{
		//11是箭头高度，3是margin-bottom
		t = (e_t - p_t) + $ele.height() + 11 - 3;
		l = (e_l - p_l) - ($MADL_ChooseFields.outerWidth()/2) + ($ele.outerWidth()/2);
	}
	
	$MADL_ChooseFields.css({"top" : t + "px", "left" : l + "px"});
	$MADL_ChooseFields.show();
}

function MADL_DelHtmlTag(str){
	return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
}

function MADL_AddSearchColumnEntry(mec_id){
	var result = {};
	
	var $attrContainer = $("#MADL_SearchColumn_"+mec_id);
	
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
			MADL_AddSearchColumnEntryToPage(mec_id, result,datas);
		});
	}

}

function MADL_AddSearchColumnEntryToPage(mec_id, result,datas){
	var $attrContainer = $("#MADL_SearchColumn_"+mec_id);
	
	var id = result["id"];
	var fieldid = result["fieldid"];
	var fieldName = result["fieldName"];
	
	var $listEntry = $("<li id=\"listEntry_"+id+"\" class=\"listEntry\"></li>");
	
	var listEntryHtm = "<div class=\"list_table_wrap\">"
						+ "<table>"
							+ "<tr>"
								+ "<td width=\"120px\">"
									
									+"<select class=\"MADL_SearchColumn_Select\" id=\"fieldid_"+id+"\" onchange=\"MADL_SearchColumn_SelectChange('"+id+"')\">"
										+"  <option value=\"\" fieldName=\"\"></option>";
										
										for(var i = 0; i < datas.length; i++){
											var data = datas[i];
											var pointid = data;
											var selected = "";
											if (pointid["fieldid"]=="" || typeof(pointid)=="undefined") continue;
											if(pointid["htmlType"] == 1 || pointid["htmlType"] == 2 || pointid["htmlType"] == 3){// 字段类型(1-单行文本 2-多行文本 3-浏览按钮)
												if (pointid["fieldid"] == fieldid) selected = "selected";
												listEntryHtm += "<option value=\""+pointid["fieldid"]+"\" fieldName=\""+pointid["fieldName"]+"\" "+selected+">";
												listEntryHtm += pointid["fieldDesc"];
												listEntryHtm += "</option>";
											}
										}
										
					listEntryHtm += "</select>"
								+ "</td>"
								+ "<td width=\"150px\" align=\"center\">"
									+ "<div class=\"MADL_SearchColumn_Selected_FieldName\" id=\"fieldName_"+id+"\">"+fieldName+"</div>"
								+ "</td>"
								+ "<td width=\"60px;\" align=\"right\">"
									+ "<input type=\"hidden\" value=\""+id+"\" class=\"MADL_LIST_ID\">"
									+ "<span class=\"list_btn_del\" onclick=\"MADL_DeleteListEntry('"+mec_id+"', '"+id+"');\"></span>"
								+ "</td>"
							+ "</tr>"
						+ "</table>"
					+"</div>";
	$listEntry.html(MLanguage.parse(listEntryHtm));				
	
	var $ParentListEntry;
	$ParentListEntry = $(".list_ul_root", $attrContainer);

	$ParentListEntry.append($listEntry);
	
}

function MADL_SearchColumn_SelectChange(id){
	var $fieldidObj = $("#fieldid_"+id);
	var fieldName = $fieldidObj.find("option:selected").attr("fieldName");
	var $fieldNameObj = $("#fieldName_"+id);
	$fieldNameObj.html(fieldName);
}

function MADL_DeleteListData(mec_id, id){
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

function MADL_DeleteListEntry(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	MADL_DeleteListData(mec_id, id);
	
	var $attrContainer = $("#MADL_SearchColumn_"+mec_id);
	$("#listEntry_" + id, $attrContainer).remove();
	
	var $ulBody = $(".list_ul_root",$attrContainer);
	if($ulBody.children().length == 0){
		$(".list_empty_tip", $attrContainer).show();
	}
}

function MADL_EditSwipeContent(mec_id){
	
	var $source = $("#source_" + mec_id);
	var sourceV = $source.val();
	if(sourceV != ""){
		
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var mectype = mecHandler.type;
		var swipeType = Mec_FiexdUndefinedVal(mecHandler.mecJson["swipeType"], "1");
		var swipeStyle = Mec_FiexdUndefinedVal(mecHandler.mecJson["swipeStyle"], 1);
		
		var url = "/mobilemode/swipeContentEdit.jsp?mecid="+mec_id+"&mectype="+mectype+"&sourceV="+sourceV+"&swipeType="+swipeType+"&swipeStyle="+swipeStyle;
		var dlg = top.createTopDialog();//获取Dialog对象
		dlg.Model = true;
		dlg.Width = 600;//定义长度
		dlg.Height = 660;
		dlg.URL = url;
		dlg.Title = SystemEnv.getHtmlNoteName(4176);  //单条数据向左滑动时配置
		dlg.show();
		dlg.hookFn = function(result){
			var $container = $("#MADL_" + mec_id);
			mecHandler.mecJson["swipeParams"] = MADL_FormatValue2Json(result["swipeParams"]);
			mecHandler.mecJson["swipeStyle"] = result["swipeStyle"];
			mecHandler.mecJson["swipeType"] = result["swipeType"];
			mecHandler.mecJson["swipeContent"] = result["swipeContent"];
			
			
			$("#swipeParams_" + mec_id, $container).val(result["swipeParams"]);
			$("#swipeStyle_" + mec_id, $container).val(result["swipeStyle"]);
			$("input[name='swipeType_"+mec_id+"']", $container).val(result["swipeType"]);
			$("#swipeContent_" + mec_id, $container).val(result["swipeContent"]);
			
			if(result["swipeContent"]!=""){
				$(".swipeContent_tip").show();
			}else {
				$(".swipeContent_tip").hide();
			}
		};
	
	}
}

function MADL_UrltypeChange(mec_id){
	var $Entry = $("#MADL_"+mec_id);
	
	var urltype = $("select[name='urltype']", $Entry).val();
	if(urltype == "0"){
		$(".urlcontent-wrap", $Entry).hide();
	}else if(urltype == "1"){
		$(".urlcontent-wrap", $Entry).show();
	}
}

function MADL_AddBtn(mec_id){
	var result = {};
	result["id"] = new UUID().toString();
	result["btnText"] = "";
	result["btnScript"] = "";
	
	MADL_AddBtnToPage(mec_id, result);
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var btn_datas = mecHandler.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
		mecHandler.mecJson["btn_datas"] = btn_datas;
	}
	btn_datas.push(result);
}

function MADL_AddBtnToPage(mec_id, result){
	
	var $attrContainer = $("#MADL_"+mec_id);
	
	$(".list_btn_empty_tip", $attrContainer).hide();
	
	var $ul = $(".list_btn_content > ul", $attrContainer);
	var $li = $("<li id=\"li_"+result["id"]+"\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"100px\" valign=\"middle\">";
			    	htm += "<input name=\"btnText\" type=\"text\" class=\"MADL_Text\" style=\"height:22px;line-height:10px;\" value=\""+result["btnText"]+"\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4177)+"\"/>";  //按钮名称
			    htm += "</td>";
			    
			    htm += "<td width=\"160px\">";
					htm += "<div class=\"btn_click_desc\">";
						htm += "<input name=\"btnScript\" type=\"hidden\" value=\"\"/>";
						htm += SystemEnv.getHtmlNoteName(4178);  //单击事件
					htm += "</div>";
				htm += "</td>";
				
				htm += "<td align=\"right\">";
					htm += "<span class=\"inparam_btn_del\" onclick=\"MADL_deleteOneBtnOnPage('"+mec_id+"','"+result["id"]+"')\"></span>";
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
	
	MLanguage({
		container: $li
    });
}

function MADL_deleteOneBtnOnPage(mec_id, id){
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
		var $attrContainer = $("#MADL_"+mec_id);
		$(".list_btn_empty_tip", $attrContainer).show();
	}
}

function MADL_DisplayAdvancedSearch(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $attrContainer = $("#MADL_"+mec_id);
		if(cbObj.checked){
			$(".MADL_EditAdvancedSearch", $attrContainer).show();
			$("#advancedSearchConfig_" + mec_id).show();
		}else{
			$(".MADL_EditAdvancedSearch", $attrContainer).hide();
			$("#advancedSearchConfig_" + mec_id).hide();
		}
	},100);
}

function MADL_EditAdvancedSearch(mec_id){
	var $source = $("#source_" + mec_id);
	var sourceV = $source.val();
	if(sourceV != ""){
		
		var advancedSearchContent = Mec_FiexdUndefinedVal($("#advancedSearchContent_" + mec_id).val());
		advancedSearchContent = encodeURIComponent(advancedSearchContent);
		
		var url = "/mobilemode/listSearchConfig.jsp?sourceV="+sourceV+"&advancedSearchContent="+advancedSearchContent;
		var dlg = top.createTopDialog();//获取Dialog对象
		dlg.Model = true;
		dlg.Width = 400;//定义长度
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