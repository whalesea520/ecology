if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Timelinr = function(typeTmp, idTmp, mecJsonTmp){
	this.type = typeTmp;
	if(!idTmp){
		idTmp = new UUID().toString();
	}
	this.id = idTmp;
	if(!mecJsonTmp){
		mecJsonTmp = this.getDefaultMecJson();
	}
	this.mecJson = mecJsonTmp;
	this.fieldInfo = null;
}

MEC_NS.Timelinr.prototype.getID = function(){
	return this.id;
};

MEC_NS.Timelinr.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	var forStart;
	while((forStart = htmTemplate.indexOf("$mec_forstart$")) != -1){
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		var forTemplate = "";
		var forContentTemplate = "";
		if(forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
			var forHtml = "";
			
			var timePartDisplay = "";
			
			var titlefield = this.mecJson["titlefield"];
			var titleFieldValue = titlefield["fielddesc"] ? titlefield["fielddesc"] : SystemEnv.getHtmlNoteName(3534);  //标题
			forHtml += forContentTemplate.replace("${timePartDisplay}", timePartDisplay)
									.replace("${year}", "年")
									.replace("${monthday}", "月-日");
			var group_forStart;
			if((group_forStart = forTemplate.indexOf("$mec_timelinr_group_forstart$")) != -1){	
				var group_forEnd = forTemplate.indexOf("$mec_timelinr_group_forend$", group_forStart);	
				if(group_forEnd != -1){
					var group_forTemplate = forTemplate.substring(group_forStart, group_forEnd + "$mec_timelinr_group_forend$".length);
					var group_forContentTemplate = forTemplate.substring(group_forStart + "$mec_timelinr_group_forstart$".length, group_forEnd);
					var group_forHtml = "";
								
					var row_forStart;
					if((row_forStart = forTemplate.indexOf("$mec_timelinr_row_forstart$")) != -1){
						var row_forEnd = forTemplate.indexOf("$mec_timelinr_row_forend$", row_forStart);
						if(row_forEnd != -1){
							var row_forTemplate = forTemplate.substring(row_forStart, row_forEnd + "$mec_timelinr_row_forend$".length);
							var row_forContentTemplate = forTemplate.substring(row_forStart + "$mec_timelinr_row_forstart$".length, row_forEnd);
							var row_forHtml = "";
					
							var col_forStart;
							if((col_forStart = row_forTemplate.indexOf("$mec_timelinr_col_forstart$")) != -1){
								var col_forEnd = row_forTemplate.indexOf("$mec_timelinr_col_forend$", col_forStart);
								if(col_forEnd != -1){
									var col_forTemplate = row_forTemplate.substring(col_forStart, col_forEnd + "$mec_timelinr_col_forend$".length);
									var col_forContentTemplate = row_forTemplate.substring(col_forStart + "$mec_timelinr_col_forstart$".length, col_forEnd);
							
									var otherfields = this.mecJson["otherfields"];
							
									for(var i = 0; i < otherfields.length; i++){
										var rowfields = otherfields[i];
										var col_forHtml = "";
										for(var j = 0; j < rowfields.length; j++){
											var colfield = rowfields[j];
											var colFieldValue = colfield["fielddesc"] ? colfield["fielddesc"] : SystemEnv.getHtmlNoteName(4139);  //选择字段
											col_forHtml += col_forContentTemplate.replace("${colfield}", colFieldValue);
										}
										row_forHtml += row_forContentTemplate.replace(col_forTemplate, col_forHtml);
									}
								}
							}
							group_forHtml = group_forContentTemplate.replace(row_forTemplate, row_forHtml).replace("${titlefield}", titleFieldValue).replace("${action}","");
						}
					}
					forHtml = forHtml.replace(group_forTemplate, group_forHtml);
				}
			}
			htmTemplate = htmTemplate.replace(forTemplate, forHtml);
		}else{
			break;
		}
	}
	htmTemplate = htmTemplate.replace("${loadMore}", "");
	var htm = htmTemplate;
	return htm;
};

MEC_NS.Timelinr.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var row = this.mecJson["row"];
	var col = this.mecJson["col"];
	var pagesize = this.mecJson["pagesize"];
	
	var fieldHtm = "";
	for(var i = 0; i < row; i++){
		fieldHtm += "<div class=\"MADTL_FieldRowWrap\"><div class=\"del_btn\"></div>";
		for(var j = 0; j < col; j++){
			var colfield = {};
			fieldHtm += "<div class=\"MADTL_FieldColWrap\">"
		        		+ "<span class=\"MADTL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段
		        		+ "<input type=\"hidden\" name=\"MADTL_Field_Json\"/>"
		        	  + "</div>";
		}
		fieldHtm += "</div>";
	}
	
	var htm = "<div id=\"MADTL_"+theId+"\" style=\"padding-bottom: 40px;\">"
					+ "<div class=\"MADTL_Title\">"+SystemEnv.getHtmlNoteName(4245)+"</div>"  //时间轴信息
					+ "<div class=\"MADTL_BaseInfo\">"
						+ "<div>"
							+ "<span class=\"MADL_BaseInfo_span MADL_BaseInfo_span"+styleL+"\">"+SystemEnv.getHtmlNoteName(4141)+"</span>"+"<span class=\"MADL_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4142)+"</span> "  //名称     名称：
							+ "<input type=\"text\" id=\"name_"+theId+"\" name=\"name_"+theId+"\" class=\"MADTL_Input\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4612)+"\"></input>"  //一个中文的名称，如：时间轴
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADTL_BaseInfo\">"
						+ "<div>"
							+ "<span class=\"MADL_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4144) + "</span> "  //内容来源：
							+ "<select class=\"MADTL_Select\" id=\"source_"+theId+"\" onfocus=\"this.defOpt=this.selectedIndex\" onchange=\"MADTL_SourceChange('"+theId+"');\">"
								+ MADTL_getListSelectOptionHtml()
							+ "</select>"
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADTL_BaseInfo\">"
						+ "<div>"
							+ "<span class=\"MADL_Desc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4247) + "</span> "  //每页显示：
							+ "<input type=\"text\" id=\"pagesize_"+theId+"\" class=\"MADTL_Pagesize\" onkeyup=\"keyUp(this)\" onafterpaste=\"afterPaste(this)\" value=\""+pagesize+"\"/>"
							+ "&nbsp;&nbsp;("+SystemEnv.getHtmlNoteName(4248)+")"  //按日期
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADTL_BaseInfo\">"
						+ "<div>"
							+ SystemEnv.getHtmlNoteName(4129) + " "  //延迟加载：
							+ "<input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/>"
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADTL_Title\">"+SystemEnv.getHtmlNoteName(4164)+"</div>"  //展示样式
					
					+ "<div class=\"MADTL_StyleConfig\" id=\"MADTL_StyleConfig_"+theId+"\">"
						+ "<div class=\"MADTL_StyleConfig_Column\">"
							//+ "列数："
							//+ "<span class=\"MADTL_Column_Minus\"></span>"
							+ "<input type=\"hidden\" id=\"column_"+theId+"\" class=\"MADTL_Column_Text\" value=\""+col+"\"/>" 
							//+ "<input type=\"text\" id=\"column_"+theId+"\" class=\"MADTL_Column_Text\" value=\""+col+"\" disabled=\"disabled\"/>"
							//+ "<span class=\"MADTL_Column_Add\"></span>"
						+ "</div>"
						
						+ "<div class=\"MADTL_StyleConfig_Row\">"+SystemEnv.getHtmlNoteName(3575)+"</div>"  //添加行
					+ "</div>"
					
					
					+ "<div class=\"MADTL_StyleWrap\">"
        				+ "<div class=\"MADTL_Style\" id=\"MADTL_Style_"+theId+"\">"
        					+ "<div class=\"MADTL_Style_L\">"
        						+ "<div class=\"MADTL_TimeFieldWrap\">"
			                        + "<span class=\"MADTL_TimeField\" title=\""+SystemEnv.getHtmlNoteName(4249)+"\">"+SystemEnv.getHtmlNoteName(3706)+"</span>"  //时间字段   时间
			                        + "<input type=\"hidden\" name=\"MADTL_Field_Json\"/>"
		                        + "</div>"
		                    + "</div>"
		                    
		                    + "<div class=\"MADTL_Style_R\">"
		                    	+ "<div class=\"MADTL_FieldRowWrap MADTL_TitleFieldRowWrap\">"
		                    		+ "<div class=\"MADTL_FieldColWrap\">"
		                        		+ "<span class=\"MADTL_Field MADTL_TitleField\">"+SystemEnv.getHtmlNoteName(3534)+"</span>"  //标题
		                        		+ "<input type=\"hidden\" name=\"MADTL_Field_Json\"/>"
		                        	+ "</div>"
		                        + "</div>"
		                        + fieldHtm
		                    + "</div>"
        				+ "</div>"
    				+ "</div>"
					
					
					+ "<div class=\"MADTL_Bottom\">"
    					+ "<div class=\"MADTL_SaveBtn\" onclick=\"MADTL_SaveBtn('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>"  //确定
    				+ "</div>"
    				
    				+ "<div class=\"MADTL_ChooseFields\" id=\"MADTL_ChooseFields_"+theId+"\">"                        
    					+ "<span class=\"MADTL_ChooseFields_Top\"></span>"  
    					+ "<span class=\"MADTL_ChooseFields_Top2\"></span>"                    
    					+ "<div class=\"MADTL_ChooseFields_Container\">" 
    						+ "<label class=\"MADTL_CField MADTL_CField_None\" fieldid=\"0\">"+SystemEnv.getHtmlNoteName(4168)+"</label>"  //无                        
    						+ "<div class=\"MADTL_CFieldWrap\">"
    						+ "</div>"
    						+ "<div class=\"MADTL_CField_CustomWrap\">"
    							+ "<label class=\"MADTL_CField MADTL_CField_Custom\" fieldid=\"-1\">"
    								+ "<div class=\"MADTL_CField_Custom_Tip\">"+SystemEnv.getHtmlNoteName(4169)+"</div>"  //点击输入字段内容
    								+ "<div class=\"MADTL_CField_Custom_Content\">"
    									+ "<textarea class=\"MADTL_CField_Custom_Text\"></textarea>"
    									+ "<div class=\"MADTL_CField_Custom_Btn\">"+SystemEnv.getHtmlNoteName(3451)+"</div>"  //确定
    								+ "</div>"
    							+ "</label>"
    						+ "</div>"
    					+ "</div>"                    
    				+ "</div>"
			+ "</div>";
			
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

MEC_NS.Timelinr.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	$("#name_"+theId).val(this.mecJson["name"]);	
	
	$("#source_"+theId).val(this.mecJson["source"]);
	
	var pagesize = !isNaN(parseInt(this.mecJson["pagesize"])) && parseInt(this.mecJson["pagesize"]) > 0 ? parseInt(this.mecJson["pagesize"]) : 3;
	
	$("#pagesize_"+theId).val(pagesize);	
	
	var lazyLoad = Mec_FiexdUndefinedVal(this.mecJson["lazyLoad"] , "0");
	if(lazyLoad == "1"){
		$("#lazyLoad_"+theId).attr("checked","checked");
	}
	
	var $MADTL_Style = $("#MADTL_Style_" + theId);
	
	var timefield = this.mecJson["timefield"];		//图片字段信息
	var timefieldV = MADTL_FormatJson2Value(timefield);
	if(timefieldV != ""){
		$(".MADTL_TimeFieldWrap input[name='MADTL_Field_Json']", $MADTL_Style).val(timefieldV);
		var fieldid = timefield["fieldid"];
		if(fieldid != "0"){
			$(".MADTL_TimeFieldWrap", $MADTL_Style).addClass("MADTL_FieldColWrap_Choosed");
		}
	}
	
	var titlefield = this.mecJson["titlefield"];	//标题字段信息
	var titlefieldV = MADTL_FormatJson2Value(titlefield);
	if(titlefieldV != ""){
		$(".MADTL_TitleFieldRowWrap input[name='MADTL_Field_Json']", $MADTL_Style).val(titlefieldV);
		var fieldid = titlefield["fieldid"];
		var fielddesc = titlefield["fielddesc"];
		$(".MADTL_TitleFieldRowWrap .MADTL_Field", $MADTL_Style).html(MADTL_DelHtmlTag(fielddesc));
		if(fieldid != "0"){
			$(".MADTL_TitleFieldRowWrap .MADTL_FieldColWrap", $MADTL_Style).addClass("MADTL_FieldColWrap_Choosed");
		}
	}
	
	var otherfields = this.mecJson["otherfields"];
	var $MADTL_FieldRowWrap = $(".MADTL_Style_R .MADTL_FieldRowWrap", $MADTL_Style).not(".MADTL_TitleFieldRowWrap");
	$MADTL_FieldRowWrap.each(function(i){
		$(".MADTL_FieldColWrap", $(this)).each(function(j){
			var colfield = otherfields[i][j];
			var colfieldV = MADTL_FormatJson2Value(colfield);
			if(colfieldV != ""){
				$("input[name='MADTL_Field_Json']", $(this)).val(colfieldV);
				var fieldid = colfield["fieldid"];
				var fielddesc = colfield["fielddesc"];
				$(".MADTL_Field", $(this)).html(MADTL_DelHtmlTag(fielddesc));
				if(fieldid != "0"){
					$(this).addClass("MADTL_FieldColWrap_Choosed");
				}
			}
		});
	});
	
	MADTL_ResizeFieldColWidth(theId);
	
	MADTL_BindRowOpt(theId);
	
	MADTL_BindColOpt(theId);
	
	MADTL_LoadChooseField(theId);
	
	MADTL_BindFieldChoose(theId);
	
	$("#MADTL_"+theId).jNice();
	
	MLanguage({
		container: $("#MADTL_"+theId)
    });
};

/*获取JSON*/
MEC_NS.Timelinr.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADTL_"+theId);
	if($attrContainer.length > 0){
		var $MADTL_Style = $("#MADTL_Style_" + theId);
		var $MADTL_FieldRowWrap = $(".MADTL_Style_R .MADTL_FieldRowWrap", $MADTL_Style).not(".MADTL_TitleFieldRowWrap");
		
		var name = $("#name_"+theId).val();	
		var nameML = MLanguage.getValue($("#name_"+theId));
		this.mecJson["name"] = nameML == undefined ? name : nameML;	// 名称
		this.mecJson["source"] = $("#source_"+theId).val();	//内容来源
		this.mecJson["pagesize"] = $("#pagesize_"+theId).val() ? $("#pagesize_"+theId).val() : "3";
		this.mecJson["lazyLoad"] = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["row"] = $MADTL_FieldRowWrap.length;	//行数
		this.mecJson["col"] = $("#column_"+theId).val();	//列数
		
		var timefieldV = $(".MADTL_TimeFieldWrap input[name='MADTL_Field_Json']", $MADTL_Style).val();
		this.mecJson["timefield"] = MADTL_FormatValue2Json(timefieldV);		//图片字段信息
		
		var titlefieldV = $(".MADTL_TitleFieldRowWrap input[name='MADTL_Field_Json']", $MADTL_Style).val();
		this.mecJson["titlefield"] = MADTL_FormatValue2Json(titlefieldV);	//标题字段信息
	
		var otherfields = [];
		$MADTL_FieldRowWrap.each(function(){
			var rowfields = [];
			$(".MADTL_FieldColWrap", $(this)).each(function(){
				var colV = $("input[name='MADTL_Field_Json']", $(this)).val();
				var colfield = MADTL_FormatValue2Json(colV);
				rowfields.push(colfield);
			});
			otherfields.push(rowfields);
		});
		this.mecJson["otherfields"] = otherfields;
	}
	
	return this.mecJson;
};

MEC_NS.Timelinr.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var row = 3;
	var col = 1;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["source"] = "";	//内容来源
	defMecJson["pagesize"] = "3";	//内容来源
	defMecJson["row"] = row;	//行数
	defMecJson["col"] = col;	//列数
	
	defMecJson["timefield"] = {};	//图片字段信息
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

/* 获取时间轴名称 */
MEC_NS.Timelinr.prototype.getName = function(){
	var theId = this.id;
	
	var name = this.mecJson["name"];
	if(name == "" || $.trim(name) == ""){
		name = theId;
	}
	
	return name;
};

/* 获取时间轴字段 */
MEC_NS.Timelinr.prototype.getFieldInfo = function(){
	var that = this;
	var theId = that.id;
	
	if(this.fieldInfo == null){
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

function MADTL_FormatValue2Json(v){
	return v == "" ? {} : $.parseJSON(v);
}

function MADTL_FormatJson2Value(jsonObj){
	return $.isEmptyObject(jsonObj) ? "" : JSON.stringify(jsonObj);
}

function MADTL_getListSelectOptionHtml(){
	var htm = "<option value=\"\"></option>";
	for(var i = 0; i < common_list_items.length; i++){
		var uiid = common_list_items[i]["uiid"];
		if((uiid + "").indexOf("homepage_") != -1) continue;
		var uiname = common_list_items[i]["uiname"];
		htm += "<option value=\""+uiid+"\">"+uiname+"</option>";
	}
	return htm;
}

function MADTL_ResizeFieldColWidth(mec_id){
	var $MADTL_FieldRowWrap = $("#MADTL_Style_" + mec_id + " .MADTL_Style_R .MADTL_FieldRowWrap").not(".MADTL_TitleFieldRowWrap");
	$MADTL_FieldRowWrap.each(function(){
		var rowWidth = parseInt($(this).width());
		var $MADTL_FieldColWrap = $(".MADTL_FieldColWrap", $(this));
		var colCount = parseInt($MADTL_FieldColWrap.length);
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
		$MADTL_FieldColWrap.each(function(i){
			$(this).width(colWidthArr[i]);
		});
	});
}

function MADTL_BindColOpt(mec_id){
	var $MADTL_StyleConfig = $("#MADTL_StyleConfig_" + mec_id);
	var $column = $("#column_" + mec_id);
	$(".MADTL_Column_Add", $MADTL_StyleConfig).click(function(){
		var colV = parseInt($column.val());
		
		var $MADTL_Style = $("#MADTL_Style_" + mec_id);
		var $MADTL_FieldRowWrap = $(".MADTL_Style_R .MADTL_FieldRowWrap", $MADTL_Style).not(".MADTL_TitleFieldRowWrap");
		var colHtml = "<div class=\"MADTL_FieldColWrap\">"
						+ "<span class=\"MADTL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段
                		+ "<input type=\"hidden\" name=\"MADTL_Field_Json\"/>"
                	+ "</div>";
		$MADTL_FieldRowWrap.append(colHtml);
		
		MADTL_ResizeFieldColWidth(mec_id);
		
		colV++;
		$column.val(colV);
		
	});
	
	$(".MADTL_Column_Minus", $MADTL_StyleConfig).click(function(){
		var colV = parseInt($column.val());
		if(colV <= 1){
			return;
		}
		var $MADTL_Style = $("#MADTL_Style_" + mec_id);
		var $MADTL_FieldRowWrap = $(".MADTL_Style_R .MADTL_FieldRowWrap", $MADTL_Style).not(".MADTL_TitleFieldRowWrap");
		$(".MADTL_FieldColWrap:last-child", $MADTL_FieldRowWrap).remove();
		
		MADTL_ResizeFieldColWidth(mec_id);
		
		colV--;
		$column.val(colV);
	});
}

function MADTL_BindRowOpt(mec_id){
	var $MADTL_StyleConfig = $("#MADTL_StyleConfig_" + mec_id);
	$(".MADTL_StyleConfig_Row", $MADTL_StyleConfig).click(function(){
		var $MADTL_Style_R = $("#MADTL_Style_" + mec_id + " .MADTL_Style_R");
		var $column = $("#column_" + mec_id);
		var colV = parseInt($column.val());
		var $MADTL_FieldRowWrap = $("<div class=\"MADTL_FieldRowWrap\"><div class=\"del_btn\"></div></div>");
		var colHtml = "";
		for(var i = 0; i < colV; i++){
			colHtml += "<div class=\"MADTL_FieldColWrap\">"
						+ "<span class=\"MADTL_Field\" title=\""+SystemEnv.getHtmlNoteName(4139)+"\">"+SystemEnv.getHtmlNoteName(4139)+"</span>"  //选择字段
                		+ "<input type=\"hidden\" name=\"MADTL_Field_Json\"/>"
                	 + "</div>";
		}
		$MADTL_FieldRowWrap.append(colHtml);
		$MADTL_Style_R.append($MADTL_FieldRowWrap);
		
		MADTL_ResizeFieldColWidth(mec_id);
		
	});
	
	$("#MADTL_Style_" + mec_id + " .MADTL_Style_R .MADTL_FieldRowWrap .del_btn").live("click", function(){
		$(this).parent().remove();
	});
}

function MADTL_BindFieldChoose(mec_id){
	$("#MAD_" + mec_id).click(function(){
		$("#MADTL_ChooseFields_" + mec_id).hide();
	});
	
	function setMADTLChooseField(ele){
		$("#MADTL_Style_" + mec_id + " .MADTL_FieldColWrap_Curr").removeClass("MADTL_FieldColWrap_Curr");
		
		var $MADTL_ChooseFields = $("#MADTL_ChooseFields_" + mec_id);
		
		$(".MADTL_CField_Checked", $MADTL_ChooseFields).removeClass("MADTL_CField_Checked");
		$(".MADTL_CField_Custom_Tip", $MADTL_ChooseFields).show();
		$(".MADTL_CField_Custom_Content", $MADTL_ChooseFields).hide();
		$(".MADTL_CField_Custom_Text", $MADTL_ChooseFields).val("");
		
		var $MADTL_Field_Json = $("input[name='MADTL_Field_Json']", $(ele));
		if($MADTL_Field_Json.val() != ""){
			var f_json = $.parseJSON($MADTL_Field_Json.val());
			var fieldid = f_json["fieldid"];
			var fielddesc = f_json["fielddesc"];
			$("#MADTL_ChooseFields_" + mec_id + " .MADTL_CField[fieldid='"+fieldid+"']").addClass("MADTL_CField_Checked");
			if(fieldid == "-1"){
				$(".MADTL_CField_Custom_Tip", $MADTL_ChooseFields).hide();
				$(".MADTL_CField_Custom_Content", $MADTL_ChooseFields).show();
				$(".MADTL_CField_Custom_Text", $MADTL_ChooseFields).val(fielddesc);
			}
		}
		$(ele).addClass("MADTL_FieldColWrap_Curr");
	}
	
	$("#MADTL_Style_" + mec_id + " .MADTL_TimeFieldWrap").click(function(e){
		setMADTLChooseField(this);
		MADTL_PositionChooseFieldAndShow(this, mec_id);
		e.stopPropagation(); 
	});
	
	$("#MADTL_Style_" + mec_id + " .MADTL_FieldColWrap").live("click", function(e){
		setMADTLChooseField(this);
		MADTL_PositionChooseFieldAndShow(this, mec_id);
		e.stopPropagation(); 
	});
	
	function setMADTLField(ele){
		var $ele = $(ele);
		
		var fieldid = $ele.attr("fieldid");
		var fielddesc;
		if($ele.hasClass("MADTL_CField_Custom")){
			fielddesc = $(".MADTL_CField_Custom_Text", $ele).val();
		}else{
			fielddesc = $ele.html();
		}
		fielddesc = $.trim(fielddesc);
		
		var f_json = {"fieldid":fieldid, "fielddesc":fielddesc};
		
		var $MADTL_FieldColWrap_Curr = $("#MADTL_Style_" + mec_id + " .MADTL_FieldColWrap_Curr");
		$MADTL_FieldColWrap_Curr.removeClass("MADTL_FieldColWrap_Choosed");
		if(fieldid != "0"){
			$MADTL_FieldColWrap_Curr.addClass("MADTL_FieldColWrap_Choosed");
		}
		if(!$MADTL_FieldColWrap_Curr.hasClass("MADTL_TimeFieldWrap")){
			var $MADTL_Field = $(".MADTL_Field", $MADTL_FieldColWrap_Curr);
			$MADTL_Field.html(MADTL_DelHtmlTag(fielddesc));
			//$MADTL_Field.attr("title", fielddesc);
		}
		var $MADTL_Field_Json = $("input[name='MADTL_Field_Json']", $MADTL_FieldColWrap_Curr);
		$MADTL_Field_Json.val(JSON.stringify(f_json));
	}
	
	
	$("#MADTL_ChooseFields_" + mec_id + " .MADTL_CField_None").click(function(e){
		setMADTLField(this);
	});
	
	$("#MADTL_ChooseFields_" + mec_id + " .MADTL_CFieldWrap .MADTL_CField").live("click", function(e){
		setMADTLField(this);
	});
	
	$("#MADTL_ChooseFields_" + mec_id + " .MADTL_CField_Custom").click(function(e){
		var $MADTL_CField_Custom_Content = $(".MADTL_CField_Custom_Content", $(this));
		if(!$MADTL_CField_Custom_Content.is(":visible")){
			$(".MADTL_CField_Custom_Tip", $(this)).hide();
			$MADTL_CField_Custom_Content.show();
		}
		e.stopPropagation(); 
	});
	
	$("#MADTL_ChooseFields_" + mec_id + " .MADTL_CField_Custom .MADTL_CField_Custom_Btn").click(function(e){
		setMADTLField($(this).parents(".MADTL_CField_Custom")[0]);
		$("#MADTL_ChooseFields_" + mec_id).hide();
		e.stopPropagation(); 
	});
}

function MADTL_SourceChange(mec_id){
	var $MADTL_Style = $("#MADTL_Style_" + mec_id);
	var $MADTL_Field_Json = $("input[name='MADTL_Field_Json']", $MADTL_Style);
	var $MADTL_Field_Json2 = $MADTL_Field_Json.filter("[value!='']");
	if($MADTL_Field_Json2.length > 0){
		top.Dialog.confirm(SystemEnv.getHtmlNoteName(4172)+SystemEnv.getHtmlNoteName(4173)+"<br/>"+SystemEnv.getHtmlNoteName(4174),function(){  //切换列表会导致展示样式中已选择的字段信息丢失     确认要继续吗？
			//确认
			$MADTL_Field_Json2.each(function(){
				$(this).val("");
				var $MADTL_Field = $(this).parent().find(".MADTL_Field");
				if($MADTL_Field.hasClass("MADTL_TitleField")){
					$MADTL_Field.html(SystemEnv.getHtmlNoteName(3534));  //标题
				}else{
					$MADTL_Field.html(SystemEnv.getHtmlNoteName(4139));  //选择字段
				}
				$(this).parents(".MADTL_FieldColWrap_Choosed").removeClass("MADTL_FieldColWrap_Choosed");
			});
			MADTL_LoadChooseField(mec_id);
		},function(){
			//取消
			var sourceObj = document.getElementById("source_" + mec_id);
			sourceObj.selectedIndex = sourceObj.defOpt;
		});
	}else{
		MADTL_LoadChooseField(mec_id);
	}
	
	// 给列表名称赋值
	var text_name = $("#source_"+mec_id).find("option:selected").text();
	if(typeof(text_name) != "undefined" && text_name != ""){
		text_name = $.trim(text_name.split("（")[0]);
	}
	$("#name_"+mec_id).val(text_name);
	$("input[name='multilang_name_"+mec_id+"']").val(text_name); 
	
}

function MADTL_SaveBtn(mec_id){
	var MADTL_Field_value = $("#MADTL_Style_" + mec_id+" input[name='MADTL_Field_Json']").val();
	if(MADTL_Field_value==""){
		alert(SystemEnv.getHtmlNoteName(4250));  //请设置时间字段！
	}else{
		var MADTL_Field_Json = MADTL_FormatValue2Json(MADTL_Field_value);
		var fieldid = MADTL_Field_Json["fieldid"];
		if(fieldid==0){
			alert(SystemEnv.getHtmlNoteName(4250));  //请设置时间字段！
		}
	}
	refreshMecDesign(mec_id);
}

function MADTL_LoadChooseField(mec_id){
	var $MADTL_ChooseFields = $("#MADTL_ChooseFields_" + mec_id);
	var $MADTL_CFieldWrap = $(".MADTL_ChooseFields_Container > .MADTL_CFieldWrap", $MADTL_ChooseFields);
	$MADTL_CFieldWrap.find("*").remove();
	
	var $source = $("#source_" + mec_id);
	var sourceV = $source.val();
	if(sourceV != ""){
		var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=getUIField&id=" + sourceV);
		FormmodeUtil.doAjaxDataLoad(url, function(datas){
			
			var mecHandler = MECHandlerPool.getHandler(mec_id);
			if(mecHandler){
				mecHandler.fieldInfo = datas;
			}
			
			for(var i = 0; i < datas.length; i++){
				var data = datas[i];
				var htm = "<label class=\"MADTL_CField\" fieldid=\""+data["fieldid"]+"\" title=\""+data["fieldName"]+"\">"+data["fieldDesc"]+"</label>";
				$MADTL_CFieldWrap.append(htm);
			}
		});
	}
}

function MADTL_PositionChooseFieldAndShow(ele, mec_id){
	var $MAD = $("#MAD_" + mec_id);	//顶级元素
	var $MADTL_ChooseFields = $("#MADTL_ChooseFields_" + mec_id);
	
	var p_offset = $MAD.offset();
	var p_t = p_offset.top;
	var p_l = p_offset.left;
	
	var $ele = $(ele);
	var e_offset = $ele.offset();
	var e_t = e_offset.top;
	var e_l = e_offset.left;
	
	$MADTL_ChooseFields.removeClass("MADTL_ChooseFields_Time");
	
	var t;
	var l;
	if($ele.hasClass("MADTL_TimeFieldWrap")){
		t = (e_t - p_t) + $ele.height() + 11;
		l = (e_l - p_l);
		$MADTL_ChooseFields.addClass("MADTL_ChooseFields_Time");
	}else{
		//11是箭头高度，3是margin-bottom
		t = (e_t - p_t) + $ele.height() + 11 - 3;
		l = (e_l - p_l) - ($MADTL_ChooseFields.outerWidth()/2) + ($ele.outerWidth()/2);
	}
	
	$MADTL_ChooseFields.css({"top" : t + "px", "left" : l + "px"});
	$MADTL_ChooseFields.show();
}

function MADTL_DelHtmlTag(str){
	return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
}

function keyUp(obj) {
    obj.value=obj.value.replace(/\D/g,'');
    obj.value=parseInt(obj.value);
    if (isNaN(obj.value) || obj.value < 1) {
		obj.value="3";
	}
    if (obj.value.length > 2) {
    	obj.value = obj.value.substring(0,2);
    }
}

function afterPaste(obj) {
	obj.value=obj.value.replace(/\D/g,'');
	obj.value=parseInt(obj.value);
    if (isNaN(obj.value) || obj.value < 1) {
		obj.value="3";
	}
	if (obj.value.length > 2) {
    	obj.value = obj.value.substring(0,2);
    }
}