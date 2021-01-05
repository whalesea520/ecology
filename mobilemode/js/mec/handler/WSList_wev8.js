if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.WSList = function(type, id, mecJson){
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
MEC_NS.WSList.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.WSList.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	var hasSearch = Mec_FiexdUndefinedVal(this.mecJson["hiddenSearch"]) != "1";
	var searchDisplay = hasSearch ? "block" : "none";
	htmTemplate = htmTemplate.replace("${searchDisplay}", searchDisplay);
	htmTemplate = htmTemplate.replace("${searchTips}", Mec_FiexdUndefinedVal(this.mecJson["searchTips"]));
	
	var dataReadonly = Mec_FiexdUndefinedVal(this.mecJson["dataReadonly"]);
	var readonly = (dataReadonly == "1") ? "readonly" : "";
	htmTemplate = htmTemplate.replace("${readonly}", readonly);
	
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
					
			forHtml += forContentTemplate.replace("${action}", "")
									.replace("${imgPartDisplay}", imgPartDisplay)
									.replace("${imgfield}", imgFieldValue)
									.replace("${titlefield}", MADWSL_DelHtmlTag(titleFieldValue));
			
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
									col_forHtml += col_forContentTemplate.replace("${colfield}", MADWSL_DelHtmlTag(colFieldValue));
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


/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.WSList.prototype.getAttrDlgHtml = function(){
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
		        		+ "<span class=\"MADL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段
		        		+ "<input type=\"hidden\" name=\"MADL_Field_Json\"/>"
		        	  + "</div>";
		}
		fieldHtm += "</div>";
	}
	
	var htm = "<div id=\"MADL_"+theId+"\" style=\"padding-bottom: 0px;\">"
					+ "<div class=\"MADL_Title\">WebService "+SystemEnv.getHtmlNoteName(4305)+"</div>"  //列表
					+ "<div class=\"MADL_BaseInfo\">"
						+ "<div>"
							+ "<span class=\"MADL_BaseInfo_span MADL_BaseInfo_span"+styleL+"\">"+SystemEnv.getHtmlNoteName(4141)+"</span>"+"<span class=\"MADL_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4141)+"&nbsp;： </span>"  //名称
							+ "<input type=\"text\" id=\"name_"+theId+"\" class=\"MADL_Text\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4306)+"\" style=\"width: 225px;\"></input>"  //一个中文的名称，如：ws列表
						+ "</div>"
					
						+ "<div>"
							+ "<span class=\"MADL_Desc"+styleL+"\">Endpoint： </span>"
							+ "<input type=\"text\" id=\"endpoint_"+theId+"\" class=\"MADL_Text\" style=\"width: 225px;\" placeholder=\"WebService "+SystemEnv.getHtmlNoteName(4311)+"\"/>"  //地址
						+ "</div>"
						
						+ "<div style=\"position: relative;\">"
							+ "<span class=\"MADL_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4592) + "&nbsp;： </span>"  //数据链接
							+ "<span style=\"display: inline-block;\">"
							+ "<input type=\"text\" id=\"dataurl_"+theId+"\" class=\"MADL_Text\" style=\"width: 225px;\"/>"
							+ "<input class=\"MADL_MText\" type=\"hidden\" id=\"dataurlJson_"+theId+"\"/>"
							+ "</span>"
						+ "</div>"
					
						+ "<div class=\"MADL_BaseInfo_MoreFlag\" id=\"MADL_BaseInfo_MoreFlag_"+theId+"\" style=\"top:38px;\">"
						+ SystemEnv.getHtmlNoteName(3888)  //更多
						+ "</div>"
						
						+ "<div class=\"MADL_BaseInfo_MoreContainer\" id=\"MADL_BaseInfo_MoreContainer_"+theId+"\">"
						
						+ "<div style=\"\">"
							+ "<span class=\"MADL_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4307) + "&nbsp;： </span>"  //命名空间
							+ "<input type=\"text\" id=\"namespace_"+theId+"\" class=\"MADL_Text\" style=\"width: 225px;\"/>"
						+ "</div>"
						
						+ "<div style=\"\">"
							+ "<span class=\"MADL_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4308) + "&nbsp;： </span>"  //方法名称
							+ "<input type=\"text\" id=\"operationName_"+theId+"\" class=\"MADL_Text\" style=\"width: 225px;\"/>"
						+ "</div>"
					
						+ "<div class=\"MADL_InParams_Container\" style=\"margin-top:6px;margin-bottom:15px;\">"
							+ "<div class=\"MADL_InParams_Title\" style=\"padding-left:1px;\">"
								+ SystemEnv.getHtmlNoteName(4293)  //输入参数
								+ "<div class=\"inparam_btn_add\" onclick=\"MADWSL_AddOneInParam('"+theId+"')\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
							+ "</div>"
							+ "<div class=\"MADL_InParams_Content\">"
								+ "<div class=\"list_empty_tip\" style=\"margin-top:5px;\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //单击右上角的添加按钮以添加输入参数
								+ "<ul>"
								+ "</ul>"
							+ "</div>"
						+ "</div>"
						
						+ "<div class=\"MADL_OutFormat_Container\" style=\"margin-bottom:15px;\">"
							+ "<div class=\"MADL_OutFormat_Title\">"
								+ SystemEnv.getHtmlNoteName(4295)  //输出格式
								+ "<select id=\"outformat_type_"+theId+"\" class=\"outformat_type\">"
									+ "<option value=\"JSON\">JSON</option>"
								+ "</select>"
							+ "</div>"
							+ "<div class=\"MADL_OutFormat_Content\">"
								+ "<ul>"
								+ "</ul>"
							+ "</div>"
						+ "</div>"
					
						+ "<table class=\"attrTable\" style=\"margin-bottom:10px;\">"
							+ "<tr class=\"titleTr\">"
								+ "<td>"+SystemEnv.getHtmlNoteName(4148)+"</td>"  //每页条数
								+ "<td>"+SystemEnv.getHtmlNoteName(4150)+"</td>"  //隐藏查询
								+ "<td>"+SystemEnv.getHtmlNoteName(4151)+"</td>"  //数据只读
								+ "<td>"+SystemEnv.getHtmlNoteName(4309)+"</td>"  //延迟加载
							+ "</tr>"
							+ "<tr>"
								+ "<td><input type=\"text\" id=\"pagesize_"+theId+"\" class=\"MADL_Text\" style=\"width: 35px;height: 18px; line-height: 10px;\"/></td>"
								+ "<td><input type=\"checkbox\" id=\"hiddenSearch_"+theId+"\"/></td>"
								+ "<td><input type=\"checkbox\" id=\"dataReadonly_"+theId+"\"/></td>"
								+ "<td><input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/></td>"
							+ "</tr>"
						+ "</table>"
						
						+ "<div>"
							+ "<span>"+SystemEnv.getHtmlNoteName(4160)+"</span>"  //搜索提示文字：
							+ "<input type=\"text\" id=\"searchTips_"+theId+"\" class=\"MADL_Input\" data-multi=false></input>"
						+ "</div>"
					
						+ "<div>"
							+ "<div style=\"margin-bottom:0px;position: relative;\">"+SystemEnv.getHtmlNoteName(4161)  //单条数据向左滑动时配置：
								+ "<div class=\"MADL_EditSwipeContent MADL_EditSwipeContent"+styleL+"\" onclick=\"MADWSL_EditSwipeContent('"+theId+"');\"></div>"
								+ "<div class=\"swipeContent_tip\" onclick=\"MADWSL_EditSwipeContent('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4162)+"</div>"  //已配置
								+ "<input type=\"hidden\" name=\"swipeType_"+theId+"\"/>"
							+ "</div>"
							+ "<input class=\"MADL_MText\" id=\"swipeStyle_"+theId+"\" type=\"hidden\"/>"
							+ "<input class=\"MADL_MText\" id=\"swipeContent_"+theId+"\" type=\"hidden\"/>"
							+ "<input class=\"MADL_MText\" id=\"swipeParams_"+theId+"\" type=\"hidden\"/>"
						+ "</div>"
						
						+ "<div>"
							+ "<div style=\"margin-bottom:0px;position: relative;\">"+SystemEnv.getHtmlNoteName(4291)  //是否启用日期提示：
								+ "<input type=\"checkbox\" name=\"isDatePrompt_"+theId+"\" onclick=\"MADWSL_isDatePrompt(this, '"+theId+"')\"/>"
								+ "<input class=\"MADL_Text\" style=\"height: 20px;line-height: 10px;font-family: 'Microsoft Yahei', Arial;font-size: 12px;display:none;width: 198px;margin-left: 5px;\" placeholder=\""+SystemEnv.getHtmlNoteName(4591)+"\" id=\"datePromptValue_"+theId+"\"/>"  //输入日期时间,例如{date} {time}
							+ "</div>"
						+ "</div>"
					
						+ "</div>"
						
					+ "</div>"
					
					+ "<div class=\"MADL_Title\">"+SystemEnv.getHtmlNoteName(4164)+"</div>"  //展示样式
					
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
			                        + "<span class=\"MADL_ImgField\" title=\""+SystemEnv.getHtmlNoteName(4166)+"\">"+SystemEnv.getHtmlNoteName(4167)+"</span>"  //图片字段  图片
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
    						+ "<label class=\"MADL_CField MADL_CField_None\" fieldid=\"0\">"+SystemEnv.getHtmlNoteName(4168)+"</label>"  //无                      
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
MEC_NS.WSList.prototype.afterAttrDlgBuild = function(){
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
	
	$("#endpoint_"+theId).val(this.mecJson["endpoint"]);
	
	$("#dataurl_"+theId).val(this.mecJson["dataurl"]);
	
	$("#namespace_"+theId).val(this.mecJson["namespace"]);
	
	$("#operationName_"+theId).val(this.mecJson["operationName"]);
	
	var dataurlJson = MADWSL_FormatJson2Value(this.mecJson["dataurlJson"]);
	$("#dataurlJson_" + theId).val(dataurlJson);
	
	
	var pagesize = Mec_FiexdUndefinedVal(this.mecJson["pagesize"]);
	if(pagesize == "" || isNaN(pagesize) || parseInt(pagesize) <= 0){
		pagesize = 10;
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
	
	var lazyLoad = Mec_FiexdUndefinedVal(this.mecJson["lazyLoad"]);
	if(lazyLoad == "1"){
		$("#lazyLoad_"+theId).attr("checked","checked");
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
	
	var swipeParams = MADWSL_FormatJson2Value(Mec_FiexdUndefinedVal(this.mecJson["swipeParams"], []));
	$("#swipeParams_" + theId).val(swipeParams);
	
	$("#searchTips_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["searchTips"],""));
	
	$("#datePromptValue_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["datePromptValue"],""));
	
	var isDatePrompt = Mec_FiexdUndefinedVal(this.mecJson["isDatePrompt"], "0");
	if(isDatePrompt == "1"){
		$("input[type='checkbox'][name='isDatePrompt_"+theId+"']").attr("checked","checked");
		$("#datePromptValue_"+theId).show();
	}
	
	var $MADL_Style = $("#MADL_Style_" + theId);
	
	var imgfield = this.mecJson["imgfield"];		//图片字段信息
	var imgfieldV = MADWSL_FormatJson2Value(imgfield);
	if(imgfieldV != ""){
		$(".MADL_ImgFieldWrap input[name='MADL_Field_Json']", $MADL_Style).val(imgfieldV);
		var fieldid = imgfield["fieldid"];
		if(fieldid != "0"){
			$(".MADL_ImgFieldWrap", $MADL_Style).addClass("MADL_FieldColWrap_Choosed");
		}
	}
	
	var titlefield = this.mecJson["titlefield"];	//标题字段信息
	var titlefieldV = MADWSL_FormatJson2Value(titlefield);
	if(titlefieldV != ""){
		$(".MADL_TitleFieldRowWrap input[name='MADL_Field_Json']", $MADL_Style).val(titlefieldV);
		var fieldid = titlefield["fieldid"];
		var fielddesc = titlefield["fielddesc"];
		$(".MADL_TitleFieldRowWrap .MADL_Field", $MADL_Style).html(MADWSL_DelHtmlTag(fielddesc));
		if(fieldid != "0"){
			$(".MADL_TitleFieldRowWrap .MADL_FieldColWrap", $MADL_Style).addClass("MADL_FieldColWrap_Choosed");
		}
	}
	
	var otherfields = this.mecJson["otherfields"];
	var $MADL_FieldRowWrap = $(".MADL_Style_R .MADL_FieldRowWrap", $MADL_Style).not(".MADL_TitleFieldRowWrap");
	$MADL_FieldRowWrap.each(function(i){
		$(".MADL_FieldColWrap", $(this)).each(function(j){
			var colfield = otherfields[i][j];
			var colfieldV = MADWSL_FormatJson2Value(colfield);
			if(colfieldV != ""){
				$("input[name='MADL_Field_Json']", $(this)).val(colfieldV);
				var fieldid = colfield["fieldid"];
				var fielddesc = colfield["fielddesc"];
				$(".MADL_Field", $(this)).html(MADWSL_DelHtmlTag(fielddesc));
				if(fieldid != "0"){
					$(this).addClass("MADL_FieldColWrap_Choosed");
				}
			}
		});
	});
	
	MADWSL_ResizeFieldColWidth(theId);
	
	MADWSL_BindRowOpt(theId);
	
	MADWSL_BindColOpt(theId);
	
	MADWSL_BindFieldChoose(theId);
	
	var inParams = this.mecJson["inParams"];
	for(var i = 0; inParams && i < inParams.length; i++){
		MADWSL_AddOneInParamToPage(theId, inParams[i]);
	}
	MADWSL_testTipDisplay(theId);
	
	var outFormat = this.mecJson["outFormat"];
	$("#outformat_type_" + theId).val(outFormat["type"]);
	var formats = outFormat["formats"];
	for(var i = 0; formats && i < formats.length; i++){
		MADWSL_AddOneOutFormatToPage(theId, formats[i]);
	}
	
	new URLSelector("dataurl_"+theId).init();
	
	$("#MADL_"+theId).jNice();
	
	MLanguage({
		container: $("#MADL_"+theId + " .MADL_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.WSList.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADL_"+theId);
	if($attrContainer.length > 0){
		var $MADL_Style = $("#MADL_Style_" + theId);
		var $MADL_FieldRowWrap = $(".MADL_Style_R .MADL_FieldRowWrap", $MADL_Style).not(".MADL_TitleFieldRowWrap");
		
		this.mecJson["name"] = MLanguage.getValue($("#name_"+theId)) || $("#name_"+theId).val();// 名称
		
		this.mecJson["endpoint"] = $("#endpoint_"+theId).val();	//endpoint
		
		this.mecJson["dataurl"] = $("#dataurl_"+theId).val();	//数据链接
		this.mecJson["dataurlJson"] = MADWSL_FormatValue2Json($("#dataurlJson_"+theId).val());	//数据链接
		
		this.mecJson["namespace"] = $("#namespace_"+theId).val();
		
		this.mecJson["operationName"] = $("#operationName_"+theId).val();
		
		var pagesize = $("#pagesize_"+theId).val();	//每页条数
		if(pagesize == "" || isNaN(pagesize) || parseInt(pagesize) <= 0){
			pagesize = 10;
		}
		this.mecJson["pagesize"] = pagesize;
		
		this.mecJson["hiddenSearch"] = $("#hiddenSearch_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["dataReadonly"] = $("#dataReadonly_"+theId).is(':checked') ? "1" : "0";

		this.mecJson["lazyLoad"] = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["swipeType"] = $("input[name='swipeType_"+theId+"']").val();
		
		this.mecJson["swipeStyle"] = $("#swipeStyle_"+theId).val();
		
		this.mecJson["swipeContent"] = $("#swipeContent_"+theId).val();
		
		this.mecJson["swipeParams"] = MADWSL_FormatValue2Json($("#swipeParams_"+theId).val());
		
		this.mecJson["searchTips"] = MLanguage.getValue($("#searchTips_"+theId)) || $("#searchTips_"+theId).val();	// 搜索提示文字
		
		this.mecJson["isDatePrompt"] = $("input[type='checkbox'][name='isDatePrompt_"+theId+"']").is(':checked') ? "1" : "0";
		
		this.mecJson["datePromptValue"] = $("#datePromptValue_"+theId).val();
		
		this.mecJson["row"] = $MADL_FieldRowWrap.length;	//行数
		this.mecJson["col"] = $("#column_"+theId).val();	//列数
		
		var imgfieldV = $(".MADL_ImgFieldWrap input[name='MADL_Field_Json']", $MADL_Style).val();
		this.mecJson["imgfield"] = MADWSL_FormatValue2Json(imgfieldV);		//图片字段信息
		
		var titlefieldV = $(".MADL_TitleFieldRowWrap input[name='MADL_Field_Json']", $MADL_Style).val();
		this.mecJson["titlefield"] = MADWSL_FormatValue2Json(titlefieldV);	//标题字段信息
	
		var otherfields = [];
		$MADL_FieldRowWrap.each(function(){
			var rowfields = [];
			$(".MADL_FieldColWrap", $(this)).each(function(){
				var colV = $("input[name='MADL_Field_Json']", $(this)).val();
				var colfield = MADWSL_FormatValue2Json(colV);
				rowfields.push(colfield);
			});
			otherfields.push(rowfields);
		});
		this.mecJson["otherfields"] = otherfields;
		
		/*
		var inParams = this.mecJson["inParams"];
		var $inParamLi = $(".MADL_InParams_Content > ul > li", $attrContainer);
		$inParamLi.each(function(){
			var liId = $(this).attr("id");
			if(liId && liId != ""){
				var inPmId = liId.substring("li_".length);
				var paramName = $("input[name='paramName']", $(this)).val();
				for(var i = 0; i < inParams.length; i++){
					if(inParams[i]["id"] == inPmId){
						inParams[i]["paramName"] = paramName;
						break;
					}
				}
			}
		});*/
		
		var outFormat = this.mecJson["outFormat"];
		outFormat["type"] = $("#outformat_type_" + theId).val();
		var formats = outFormat["formats"];
		var $outFormatLi = $(".MADL_OutFormat_Content > ul > li", $attrContainer);
		$outFormatLi.each(function(){
			var key = $("input[name='key']", $(this)).val();
			var keyName = $("input[name='keyName']", $(this)).val();
			
			for(var i = 0; i < formats.length; i++){
				if(formats[i]["key"] == key){
					formats[i]["keyName"] = keyName;
					break;
				}
			}
		});
		
	}
	
	return this.mecJson;
};

MEC_NS.WSList.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var row = 3;
	var col = 1;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	var count = 0;
	count = $("abbr[m_type='UrlList']", "#homepageContainer").length;
	
	defMecJson["name"] = SystemEnv.getHtmlNoteName(4310)+(count+1);	// 名称     ws列表
	defMecJson["endpoint"] = "";	//endpoint
	defMecJson["dataurl"] = "";	//数据连接
	defMecJson["dataurlJson"] = {};	//数据连接
	defMecJson["namespace"] = "";
	defMecJson["operationName"] = "";
	defMecJson["row"] = row;	//行数
	defMecJson["col"] = col;	//列数
	
	var swipeParams = [];
	defMecJson["swipeParams"] = swipeParams;
	defMecJson["swipeStyle"] = 1;
	defMecJson["swipeContent"] = "";
	defMecJson["swipeType"] = "1";
	
	defMecJson["searchTips"] = SystemEnv.getHtmlNoteName(4170); //搜索提示文字    请输入...
	
	defMecJson["isDatePrompt"] = "0";
	
	defMecJson["datePromptValue"] = "";
	
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
	
	var inParams = [];
	defMecJson["inParams"] = inParams;
	
	var outFormat = {
		type : "JSON",
		formats : [
		    {
		    	key : "TOTAL_SIZE",
		    	keyName : "totalSize",
		    	desc : SystemEnv.getHtmlNoteName(4301)  //总记录数对应KEY
		    },
		    {
		    	key : "DATAS",
		    	keyName : "datas",
		    	desc : SystemEnv.getHtmlNoteName(4302)  //数据JSON对应KEY
		    }
		]
	};
	defMecJson["outFormat"] = outFormat;
	return defMecJson;
};

/* 获取ws列表名称 */
MEC_NS.WSList.prototype.getName = function(){
	var theId = this.id;
	
	var name = this.mecJson["name"];
	if(name == "" || $.trim(name) == ""){
		name = theId;
	}
	
	return name;
};

function MADWSL_EditLink(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var dataurlJson = mecHandler.mecJson["dataurlJson"];
	var appid = $("#appid").val();
	
	var url = "/mobilemode/linkedit.jsp?appid="+appid+"&dataurlJson="+encodeURIComponent(MADWSL_FormatJson2Value(dataurlJson));
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 600;//定义长度
	dlg.Height = 335;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4303);  //编辑链接
	dlg.show();
	dlg.hookFn = function(result){
		mecHandler.mecJson["dataurl"] = result["dataurl"];
		mecHandler.mecJson["dataurlJson"] = MADWSL_FormatValue2Json(result["dataurlJson"]);
		
		$("#dataurl_" + mec_id).val(result["dataurl"]);
		$("#dataurlJson_" + mec_id).val(result["dataurlJson"]);
	};
}

function MADWSL_AddOneInParam(mec_id){
	var url = "/mobilemode/paraminfo_ws.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 400;//定义长度
	dlg.Height = 400;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3518);  //添加
	dlg.show();
	dlg.hookFn = function(result){
		result["id"] = new UUID().toString();
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var inParams = mecHandler.mecJson["inParams"];
		inParams.push(result);
		MADWSL_AddOneInParamToPage(mec_id, result);
		MADWSL_testTipDisplay(mec_id);
	};
}

function MADWSL_AddOneInParamToPage(mec_id, paramobj){
	var $attrContainer = $("#MADL_"+mec_id);
	var $ul = $(".MADL_InParams_Content > ul", $attrContainer);
	var $li = $("<li id=\"li_"+paramobj["id"]+"\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"80px\" valign=\"middle\">";
			    	htm += "<div class=\"inparam_param_name\">";
			    		htm += paramobj["paramName"];
			    	htm += "</div>";
			    htm += "</td>";
			    
			    htm += "<td width=\"160px\" valign=\"middle\">";
			    	htm += "<div class=\"inparam_param_type\">";
			    		htm += paramobj["paramTypeText"];
			    	htm += "</div>";
			    htm += "</td>";
			    
			    htm += "<td>";
					htm += "<div class=\"inparam_param_desc\">";
						htm += MLanguage.parse(paramobj["desc"]);
					htm += "</div>";
				htm += "</td>";
				
				htm += "<td width=\"40px\" align=\"right\">";
						htm += "<span class=\"inparam_btn_edit\" onclick=\"MADWSL_editOneInParamOnPage('"+mec_id+"','"+paramobj["id"]+"')\"></span>";
						htm += "<span class=\"inparam_btn_del\" onclick=\"MADWSL_deleteOneInParamOnPage('"+mec_id+"','"+paramobj["id"]+"')\"></span>";
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
}

function MADWSL_editOneInParamOnPage(mec_id, inParamId){
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
		
		var url = "/mobilemode/paraminfo_ws.jsp?paramName="+paramobj["paramName"]+"&paramType="+paramobj["paramType"]+"&paramValue="+encodeURIComponent(paramobj["paramValue"])+"&desc="+paramobj["desc"]+"&isEncrypt="+paramobj["isEncrypt"];
		var dlg = top.createTopDialog();//获取Dialog对象
		dlg.Model = true;
		dlg.normalDialog = false;
		dlg.Width = 400;//定义长度
		dlg.Height = 400;
		dlg.URL = url;
		dlg.Title = SystemEnv.getHtmlNoteName(3518);  //添加
		dlg.show();
		dlg.hookFn = function(result){
			paramobj["paramName"] = result["paramName"];
			paramobj["paramType"] = result["paramType"];
			paramobj["paramTypeText"] = result["paramTypeText"];
			paramobj["paramValue"] = result["paramValue"];
			paramobj["desc"] = result["desc"];
			paramobj["isEncrypt"] = result["isEncrypt"];
			
			var $li = $("#li_" + inParamId);
			$(".inparam_param_name", $li).html(result["paramName"]);
			$(".inparam_param_type", $li).html(result["paramTypeText"]);
			$(".inparam_param_desc", $li).html(MLanguage.parse(paramobj["desc"]));
		};
	}
}

function MADWSL_deleteOneInParamOnPage(mec_id, inParamId){
	if(!confirm(SystemEnv.getHtmlNoteName(4175))){  //确定删除吗
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
	
	MADWSL_testTipDisplay(mec_id);
}

function MADWSL_testTipDisplay(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var inParams = mecHandler.mecJson["inParams"];
	var $list_empty_tip = $("#MADL_" + mec_id + " .MADL_InParams_Content .list_empty_tip")
	if(inParams.length == 0){
		$list_empty_tip.show();
	}else{
		$list_empty_tip.hide();
	}
}

function MADWSL_DelHtmlTag(str){
	return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
}

function MADWSL_FormatValue2Json(v){
	return v == "" ? {} : $.parseJSON(v);
}

function MADWSL_FormatJson2Value(jsonObj){
	return $.isEmptyObject(jsonObj) ? "" : JSON.stringify(jsonObj);
}


function MADWSL_ResizeFieldColWidth(mec_id){
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

function MADWSL_BindColOpt(mec_id){
	var $MADL_StyleConfig = $("#MADL_StyleConfig_" + mec_id);
	var $column = $("#column_" + mec_id);
	$(".MADL_Column_Add", $MADL_StyleConfig).click(function(){
		var colV = parseInt($column.val());
		
		var $MADL_Style = $("#MADL_Style_" + mec_id);
		var $MADL_FieldRowWrap = $(".MADL_Style_R .MADL_FieldRowWrap", $MADL_Style).not(".MADL_TitleFieldRowWrap");
		var colHtml = "<div class=\"MADL_FieldColWrap\">"
						+ "<span class=\"MADL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段
                		+ "<input type=\"hidden\" name=\"MADL_Field_Json\"/>"
                	+ "</div>";
		$MADL_FieldRowWrap.append(colHtml);
		
		MADWSL_ResizeFieldColWidth(mec_id);
		
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
		
		MADWSL_ResizeFieldColWidth(mec_id);
		
		colV--;
		$column.val(colV);
	});
}

function MADWSL_BindRowOpt(mec_id){
	var $MADL_StyleConfig = $("#MADL_StyleConfig_" + mec_id);
	$(".MADL_StyleConfig_Row", $MADL_StyleConfig).click(function(){
		var $MADL_Style_R = $("#MADL_Style_" + mec_id + " .MADL_Style_R");
		var $column = $("#column_" + mec_id);
		var colV = parseInt($column.val());
		var $MADL_FieldRowWrap = $("<div class=\"MADL_FieldRowWrap\"><div class=\"del_btn\"></div></div>");
		var colHtml = "";
		for(var i = 0; i < colV; i++){
			colHtml += "<div class=\"MADL_FieldColWrap\">"
						+ "<span class=\"MADL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段
                		+ "<input type=\"hidden\" name=\"MADL_Field_Json\"/>"
                	 + "</div>";
		}
		$MADL_FieldRowWrap.append(colHtml);
		$MADL_Style_R.append($MADL_FieldRowWrap);
		
		MADWSL_ResizeFieldColWidth(mec_id);
		
	});
	
	$("#MADL_Style_" + mec_id + " .MADL_Style_R .MADL_FieldRowWrap .del_btn").live("click", function(){
		$(this).parent().remove();
	});
}

function MADWSL_BindFieldChoose(mec_id){
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
		MADWSL_PositionChooseFieldAndShow(this, mec_id);
		e.stopPropagation(); 
	});
	
	$("#MADL_Style_" + mec_id + " .MADL_FieldColWrap").live("click", function(e){
		setMADLChooseField(this);
		MADWSL_PositionChooseFieldAndShow(this, mec_id);
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
			$MADL_Field.html(MADWSL_DelHtmlTag(fielddesc));
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

function MADWSL_PositionChooseFieldAndShow(ele, mec_id){
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

function MADWSL_EditSwipeContent(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var mectype = mecHandler.type;
	var swipeType = Mec_FiexdUndefinedVal(mecHandler.mecJson["swipeType"], "1");
	var swipeStyle = Mec_FiexdUndefinedVal(mecHandler.mecJson["swipeStyle"], 1);
	
	var url = "/mobilemode/swipeContentEdit.jsp?mecid="+mec_id+"&mectype="+mectype+"&swipeType="+swipeType+"&swipeStyle="+swipeStyle;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 600;//定义长度
	dlg.Height = 660;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4176);  //单条数据向左滑动时配置
	dlg.show();
	dlg.hookFn = function(result){
		var $container = $("#MADL_" + mec_id);
		mecHandler.mecJson["swipeParams"] = MADWSL_FormatValue2Json(result["swipeParams"]);
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

function MADWSL_isDatePrompt(cbObj,mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(!cbObj.checked){
			$("#datePromptValue_" + mec_id).hide();
		}else{
			$("#datePromptValue_" + mec_id).show();
		}
	},100);
}

function MADWSL_AddOneOutFormatToPage(mec_id, formatobj){
	var $attrContainer = $("#MADL_"+mec_id);
	var $ul = $(".MADL_OutFormat_Content > ul", $attrContainer);
	var $li = $("<li></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"100px\" valign=\"middle\">";
			    	htm += "<input name=\"key\" type=\"hidden\" value=\""+formatobj["key"]+"\"/>";
			    	htm += "<input name=\"keyName\" type=\"text\" class=\"MADL_Text\" style=\"height:20px;line-height:10px;\" value=\""+formatobj["keyName"]+"\"/>";
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