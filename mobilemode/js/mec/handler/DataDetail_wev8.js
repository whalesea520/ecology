if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.DataDetail = function(type, id, mecJson){
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
MEC_NS.DataDetail.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.DataDetail.prototype.getDesignHtml = function(){
	var theId = this.id;
	var dataDetail_datas = this.mecJson["dataDetail_datas"];
	var htm = "";
	if(dataDetail_datas.length == 0){
		htm = "<div class=\"noDataDetail\">"+SystemEnv.getHtmlNoteName(4383)+"</div>";  //未添加明细
	}else{
		var htmTemplate = getPluginContentTemplateById(this.type);
		htmTemplate = htmTemplate.replace("${theId}", theId);
		var forTemplate = "";
		var forContentTemplate = "";
		var forStart = htmTemplate.indexOf("$mec_forstart$");
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		if(forStart != -1 && forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
		}
		var forHtml = "";
		for(var i = 0; i < dataDetail_datas.length; i++){
			var data = dataDetail_datas[i];
			var entryName = data["entryName"];
			var entryContent = data["entryContent"];
			var dataDetailHtml = forContentTemplate.replace("${entryName}", entryName)
				.replace("${entryContent}", entryContent);
			forHtml += dataDetailHtml;
		}
		htm = htmTemplate.replace(forTemplate, forHtml);
	}
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.DataDetail.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	var htm = "<div id=\"MADDataDetail_" + theId + "\">"
				+ "<div class=\"MADDataDetail_title\">"
					+ SystemEnv.getHtmlNoteName(4384)  //插件信息
					
					+ "<div class=\"DataDetail_title_add\" id=\"DataDetail_ADD\" onclick=\"MADDataDetail_ShowEditor('"+theId+"')\"><span></span>"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
					+ "<div class=\"DataDetail_title_submit DataDetail_title_submit"+styleL+"\" id=\"DataDetail_SUBMIT\" onclick=\"MADDataDetail_AddOne('"+theId+"')\" style=\"display:none\"><span></span>"+SystemEnv.getHtmlNoteName(3821)+"</div>"  //确认
					+ "<div class=\"DataDetail_title_submit DataDetail_title_submit2"+styleL+"\" id=\"DataDetail_SUBMIT2\" style=\"display:none\"><span></span>"+SystemEnv.getHtmlNoteName(3883)+"</div>"  //修改
					+ "<div class=\"DataDetail_title_cancel DataDetail_title_cancel"+styleL+"\" id=\"DataDetail_CANCEL\" style=\"display:none;margin-right:10px;\" onclick=\"MADDataDetail_Cancel('"+theId+"')\"><span></span>"+SystemEnv.getHtmlNoteName(3516)+"</div>"  //取消
				+ "</div>"
				+ "<div id=\"dataDetailEditor\" style=\"display:none\">"
					+ "<div class=\"MADDataDetail_BaseInfo\">"
						+ "<div style=\"position: relative;padding-left: 75px;\">"
							+ "<span class=\"MADDataDetail_BaseInfo_Label\" style=\"position: absolute;top: 3px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4385)+"</span>"  //明细名称：
							+ "<input class=\"MADDataDetail_Text\" id=\"dataDetailName\" name=\"name_"+theId+"\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4386)+"\"></textarea>"  //明细名称
						+ "</div>"
					+ "</div>"
					+ "<div class=\"MADDataDetail_BaseInfo\">"
						+ "<div style=\"position: relative;padding-left: 75px;\">"
								+ "<span class=\"MADDataDetail_BaseInfo_Label\" style=\"position: absolute;top: 3px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4387)+"</span>"   //明细内容：
							+ "<select class=\"MADDataDetail_Select\" id=\"dataSetName\">"
							+ "</select>"
							+ "<select class=\"MADDataDetail_Select\" id=\"dataSetKey\" style=\"margin-left:5px;\">"
								+ "<option value=\"\">"+SystemEnv.getHtmlNoteName(4388)+"</option>"  //数据集变量
							+ "</select>"
							+ "<div style=\"padding-top: 3px;position:relative;display:inline-block;margin-left:5px;\"><a href=\"javascript:void(0);\" id=\"userDefineContent\">"+SystemEnv.getHtmlNoteName(3916)+"</a></div>"  //自定义
						+ "</div>"
					+ "</div>"
					+ "<div class=\"MADDataDetail_BaseInfo\" id=\"dataDetailContentBox\" style=\"display:none\">"
						+ "<div style=\"position: relative;padding-left: 75px;\">"
							+ "<span class=\"MADDataDetail_BaseInfo_Label\" style=\"position: absolute;top: 3px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4389)+"</span>"  //自定义内容：
							+ "<textarea class=\"MADDataDetail_Textarea\" id=\"dataDetailContent\" placeholder=\""+SystemEnv.getHtmlNoteName(4626)+"\"></textarea>"  //输入自定义明细内容，数据集变量用{dSetName.dSetKey}表示
						+ "</div>"
					+ "</div>"
				+ "</div>"
				+ "<div class=\"MADDataDetail_Content\">"
					+ "<ul class=\"DataDetail_ul_root\">"
					+ "</ul>"
					+ "<div class=\"DataDetail_empty_tip\">"+SystemEnv.getHtmlNoteName(4391)+"</div>"  //单击右上角的添加按钮以添加明细内容
				+ "</div>"
				+ "<div class=\"MADDataDetail_Bottom\"><div id=\"MADDataDetail_Submit\" class=\"MADDataDetail_SaveBtn\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>"
			+ "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>"  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.DataDetail.prototype.afterAttrDlgBuild = function(){
	
	var theId = this.id;
	var $attrContainer = $("#MADDataDetail_" + theId);
	var dataDetail_datas = this.mecJson["dataDetail_datas"];
	if(dataDetail_datas.length > 0){
		$(".DataDetail_empty_tip", $attrContainer).hide();
	}
	for(var i = 0; i < dataDetail_datas.length; i++){
		MADDataDetail_AddDataDetailEntryToPage(theId, dataDetail_datas[i]);
	}
	$("#userDefineContent", $attrContainer).toggle(function(){
		$(this).html(SystemEnv.getHtmlNoteName(3549));  //隐藏
		$("#dataDetailContentBox", $attrContainer).slideDown();
	}, function(){
		$(this).html(SystemEnv.getHtmlNoteName(3916));  //自定义
		$("#dataDetailContentBox", $attrContainer).slideUp();
	});
	$("#dataSetName", $attrContainer).change(function(){
		MADDataDetail_dataSetKeyChange(theId);
	});
	$("#dataSetKey", $attrContainer).change(function(){
		var datasetName = $("#dataSetName", $attrContainer).val();
		var datasetKey = $("#dataSetKey", $attrContainer).val();
		if(datasetKey.length > 0){
			$("#dataDetailContent", $attrContainer).val("{"+datasetName+"."+datasetKey+"}");
		}
	});
	$("#MADDataDetail_Submit", $attrContainer).bind("click", function(){
		refreshMecDesign(theId);
	});
	$("#MADDataDetail_" + theId).jNice();//调用表单插件
	$("#MADDataDetail_" + theId + " .MADDataDetail_Content > ul").sortable({
		revert: false,
		axis: "y",
		items: "li",
		handle: ".bemove"
	});
	
};

/*获取JSON*/
MEC_NS.DataDetail.prototype.getMecJson = function(){
	var theId = this.id;
	this.mecJson["id"] = theId;
	this.mecJson["mectype"]= this.type;
	
	var $attrContainer = $("#MADDataDetail_" + theId);
	if($attrContainer.length > 0){
		var dataDetail_datas = [];
		$(".dd_li", $attrContainer).each(function(){
			$li = $(this);
			var $attrId = $li.attr("id");
			var entryId = $attrId.substring(16);
			var entryName = $(".DataDetail_entry_nameML", $li).val();
			var entryDSName = $(".DataDetail_entry_DSName", $li).val();
			var entryDSKey = $(".DataDetail_entry_DSKey", $li).val();
			var entryContent = $(".DataDetail_entry_content", $li).html();
			
			dataDetail_datas.push({
				"entryId"      : entryId,
				"entryName"    : entryName,
				"entryDSName"  : entryDSName,
				"entryDSKey"   : entryDSKey,
				"entryContent" : entryContent
			});
		});
		this.mecJson["dataDetail_datas"] = dataDetail_datas;
	}
	return this.mecJson;
};

MEC_NS.DataDetail.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	var dataDetail_datas = [];
	defMecJson["dataDetail_datas"] = dataDetail_datas;
	return defMecJson;
};

function MADDataDetail_dataSetKeyChange(mec_id, defKey){
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	var that = $("#dataSetName", $attrContainer);
	var val = that.val();
	var $option = $("option[value="+val+"]", that);
	var dsMecId = $option.attr("id");
	var mecHandler = MECHandlerPool.getHandler(dsMecId);
	//如果数据集不存在，不加判断编辑时会出错
	if(!mecHandler){
		$("#dataSetKey", $attrContainer).val("");
		return;
	}
	var sourceType = mecHandler.mecJson["sourceType"];
	if(sourceType == 0){
		var tableid = mecHandler.mecJson["tableid"];
		$("#dataSetKey", $attrContainer).html("").show();
		MADDataDetail_GetFieldOptionHtml2(dsMecId, $("#dataSetKey", $attrContainer), tableid, defKey, true);
		$("#dataDetailContentBox", $attrContainer).hide();
	}
	if(sourceType == 2){
		$("#dataSetKey", $attrContainer).hide();
		$("#dataDetailContentBox", $attrContainer).show();
	}
	if(sourceType == 1){
		var sql = mecHandler.mecJson["sql"];
		var wherePattern = /(.*)where/gi;
		if(!wherePattern.test(sql)){
			sql += "where 1=1";
		}
		var tablesArray = [];
		var fieldsArray = [];
		//获取字段
		var allFieldPattern = /select(\s+.*\s+)from(.*)where/gi;
		var matches = allFieldPattern.exec(sql);
		if(matches != null && matches.length > 0){
			var fieldsString = matches[1];
			var tableString = matches[2];
			
			//直接从sql中提取字段
			var fieldsArrayTemp = fieldsString.split(",");
			for(var i = 0; i < fieldsArrayTemp.length; i++){
				var field = "";
				var fieldTemp = fieldsArrayTemp[i];
				
				var asteriskPattern = /(\w+)?(\.|\s+)?(\*)/;
				var asteriskMatches = asteriskPattern.exec(fieldTemp);
				//包含*，需要查数据库
				//获取数据库表名
				if(asteriskMatches != null){
					var tablesArrayTemp = [];
					tablesArrayTemp = tableString.split(",");
					//包含*的查询字段是否包含表别名
					var tableAlias = asteriskMatches[1];
					//匹配表名
					
					//不包含表别名，则获取sql中所有表名
					if(tableAlias == undefined){
						fieldsArray = [];
						tablesArray = [];
						for(var j = 0; j < tablesArrayTemp.length; j++){
							var tablePattern = /(\w+)((\s+(as\s+)?)(\w+))?\s*((\w+\s+)?join\s+(\w+)(\s+(as\s+)?)(\w+))?/gi;
							var tableTemp = tablesArrayTemp[j];
							var tableMatches = tablePattern.exec(tableTemp);
							if(tableMatches == null){
								continue;
							}
							if(tableMatches[1] != undefined){
								tablesArray.push(tableMatches[1]);
							}
							if(tableMatches[8] != undefined){
								tablesArray.push(tableMatches[8]);
							}
						}
						break;
					}else{//包含表别名，则获取别名指向的数据库表
						for(var j = 0; j < tablesArrayTemp.length; j++){
							var tablePattern = /(\w+)((\s+(as\s+)?)(\w+))?\s*((\w+\s+)?join\s+(\w+)(\s+(as\s+)?)(\w+))?/gi;
							var tableTemp = tablesArrayTemp[j];
							var tableMatches = tablePattern.exec(tableTemp);
							if(tableMatches == null){
								continue;
							}
							if(tableMatches[1] != undefined && tableMatches[5] == tableAlias){
								tablesArray.push(tableMatches[1]);
							}
							if(tableMatches[8] != undefined && tableMatches[11] == tableAlias){
								tablesArray.push(tableMatches[8]);
							}
						}
						continue;
					}
				}
				//查询字段是否包含别名
				var aliasPattern = /(\(.*\)|\w+\.?\w+)(\s+as\s+|\s+)(\w+)/gi;
				var aliasMatches = aliasPattern.exec(fieldTemp);
				if(aliasMatches != null){
					field = aliasMatches[3];
					fieldsArray.push(field);
					continue;
				}
				//是否包含点
				var dotPattern = /\w+\.(\w+)/;
				var dotMatches = dotPattern.exec(fieldTemp);
				if(dotMatches != null){
					field = dotMatches[1];
					fieldsArray.push(field);
					continue;
				}
				field = fieldTemp.trim();
				fieldsArray.push(field);
			}
		}
		$("#dataSetKey", $attrContainer).html("<option value=\"\">请选择</option>");
		for(var i = 0; i < fieldsArray.length; i++){
			var optionHtml = "<option value=\"" + fieldsArray[i] + "\">" + fieldsArray[i] + "</option>";
			$("#dataSetKey", $attrContainer).append(optionHtml).attr({"class":"MADDataDetail_Select"}).removeAttr("disabled");;
		}
		if(tablesArray.length > 0){
			MADDataDetail_GetFieldOptionHtml(dsMecId, $("#dataSetKey", $attrContainer), tablesArray.toString(), defKey, false);
		}
		$("#dataSetKey", $attrContainer).show();
		$("#dataDetailContentBox", $attrContainer).hide();
	}
}

function MADDataDetail_GetFieldOptionHtml(mecId, element, tableArray, defval, hasEmptyOption){
	var mecHandler = MECHandlerPool.getHandler(mecId);
	if(!mecHandler){
		return;
	}
	var datasource = mecHandler.mecJson["datasource"];
	if(datasource.length == 0){
		datasource = "$ECOLOGY_SYS_LOCAL_POOLNAME";
	}
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getFieldsByTables&dsName="+datasource+"&tbArray="+tableArray);
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + timestamp;
	element.attr({"class":"MADDataDetail_Select MADDataDetail_loading","disabled":true});
	$.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	cache:false,
	 	success: function(responseText, textStatus) 
	 	{
	 		var result = $.parseJSON(responseText);
	 		var status = result.status;
	 		if(status == "1"){
				var optionHtml = "";
				if(hasEmptyOption){
					optionHtml+= "<option value=\"\">请选择</option>";
				}
				var data = result.data;
				for(var i = 0; i < data.length; i++){
					var column_name = MLanguage.parse(data[i]["column_name"]);
					optionHtml+= "<option value=\""+column_name+"\"";
					if(defval && column_name.toLowerCase()==defval.toLowerCase()){
						optionHtml+= " selected = \"selected\" ";
					}
					optionHtml+= ">"+column_name+"</option>";
				}
				element.append(optionHtml);
				element.attr({"class":"MADDataDetail_Select"}).removeAttr("disabled");
			}
	 	},
	    error: function(e){
	    	console.log(e);
	    }
	});
}

function MADDataDetail_GetFieldOptionHtml2(mecId, element, billid, defval, hasEmptyOption){
	var mecHandler = MECHandlerPool.getHandler(mecId);
	if(!mecHandler){
		return;
	}
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getFieldsByBillid&billid=" + billid);
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + timestamp;
	element.attr({"class":"MADDataDetail_Select MADDataDetail_loading","disabled":true});
	$.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	cache:false,
	 	success: function(responseText, textStatus) 
	 	{
	 		var result = $.parseJSON(responseText);
	 		var status = result.status;
	 		if(status == "1"){
				var optionHtml = "";
				if(hasEmptyOption){
					optionHtml+= "<option value=\"\">请选择</option>";
				}
				var data = result.data;
				for(var i = 0; i < data.length; i++){
					var field_name = data[i]["fieldname"];
					var label_name = MLanguage.parse(data[i]["labelName"]);
					optionHtml+= "<option value=\""+field_name+"\"";
					if(defval && field_name.toLowerCase()==defval.toLowerCase()){
						optionHtml+= " selected = \"selected\" ";
					}
					optionHtml+= ">"+label_name+"</option>";
				}
				element.append(optionHtml);
				element.attr({"class":"MADDataDetail_Select"}).removeAttr("disabled");
			}
	 	},
	    error: function(e){
	    	console.log(e);
	    }
	});
}

function MADDataDetail_ShowEditor(mec_id, entry_id){
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	if(entry_id != undefined){
		var $dataDetailEntry = $("#DataDetailEntry_" + entry_id);
		var entryName = $(".DataDetail_entry_nameML", $dataDetailEntry).val();
		var entryDSName = $(".DataDetail_entry_DSName", $dataDetailEntry).val();
		var entryDSKey = $(".DataDetail_entry_DSKey", $dataDetailEntry).val();
		var entryContent = $(".DataDetail_entry_content", $dataDetailEntry).html();
		MADDataDetail_setDataSetName(mec_id, entryDSName, entryDSKey);
		$("#dataDetailName", $attrContainer).val(entryName);
		$("input[name='multilang_name_"+mec_id+"']").val(entryName); 
		$("#dataDetailName", $attrContainer).attr("data-multi", "false");
		$("#dataDetailContent", $attrContainer).val(entryContent);
		$("#DataDetail_SUBMIT2", $attrContainer).show();
		$("#DataDetail_SUBMIT", $attrContainer).hide();
		//$("#dataSetName", $attrContainer).change();
		$("#dataDetailContentBox", $attrContainer).show();
	}else{
		MADDataDetail_setDataSetName(mec_id);
		MADDataDetail_clearContent(mec_id);
	}
	$("#MADDataDetail_Submit", $attrContainer).fadeOut(1500);
	$("#DataDetail_ADD", $attrContainer).hide();
	$("#DataDetail_CANCEL", $attrContainer).show();
	$("#dataDetailEditor", $attrContainer).slideDown();
	
	MLanguage({
		container: $attrContainer
    });
}

function MADDataDetail_clearContent(mec_id){
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	$("#dataDetailName", $attrContainer).val("");
	$("#dataDetailContent", $attrContainer).val("");
	$("#dataSetName", $attrContainer).val("");
	$("#dataSetKey", $attrContainer).html("<option value=\"\">"+SystemEnv.getHtmlNoteName(4392)+"</option>");  //选择数据集变量
	$("#DataDetail_SUBMIT", $attrContainer).show();
	$("#dataDetailContentBox", $attrContainer).hide();
}

function MADDataDetail_AddOne(mec_id, entry_id){
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	var entryName = $("#dataDetailName", $attrContainer).val().trim();
	var entryNameML = MLanguage.getValue($("#dataDetailName", $attrContainer));
	entryName = entryNameML || entryName;
	var entryContent = $("#dataDetailContent", $attrContainer).val().trim();
	var entryDSName = $("#dataSetName", $attrContainer).val();
	var entryDSKey = $("#dataSetKey", $attrContainer).val();
	if(entryName.length == 0){
		alert(SystemEnv.getHtmlNoteName(4393));  //明细名称不能为空
		return;
	}
	$(".DataDetail_empty_tip", $attrContainer).hide();
	if(entry_id != undefined){
		var $dataDetailEntry = $("#DataDetailEntry_" + entry_id);
		$(".DataDetail_entry_name", $dataDetailEntry).html(MLanguage.parse(entryName));
		$(".DataDetail_entry_nameML", $dataDetailEntry).val(entryName);
		$(".DataDetail_entry_DSName", $dataDetailEntry).val(entryDSName);
		$(".DataDetail_entry_DSKey", $dataDetailEntry).val(entryDSKey);
		$(".DataDetail_entry_content", $dataDetailEntry).html(entryContent);
		$("#DataDetail_SUBMIT2", $attrContainer).unbind("click").hide();

		$("#DataDetail_ADD", $attrContainer).show();
		$("#DataDetail_CANCEL", $attrContainer).hide();
		$("#dataDetailEditor", $attrContainer).slideUp();
		$("#MADDataDetail_Submit", $attrContainer).fadeIn(1500);
	}else{
		var _entryId = new UUID().toString();
		var data = [];
		data["entryId"]      = _entryId;
		data["entryName"]    = entryName;
		data["entryDSName"]  = entryDSName;
		data["entryDSKey"]   = entryDSKey;
		data["entryContent"] = entryContent;
		MADDataDetail_AddDataDetailEntryToPage(mec_id, data);
		$("#DataDetail_SUBMIT", $attrContainer).hide();
		
		MADDataDetail_clearContent(mec_id);
	}
	refreshMecDesign(mec_id);
	$(".MAD_Alert").hide();
}

function MADDataDetail_AddDataDetailEntryToPage(mec_id, data){
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	var entryId          = data["entryId"];
	var entryName        = data["entryName"];
	var entryDatasetName = data["entryDSName"];
	var entryDatasetKey  = data["entryDSKey"];
	var entryContent     = data["entryContent"];
	var $DataDetailEntry = $("<li class=\"dd_li\" id=\"DataDetailEntry_" + entryId + "\"></li>");
	$DataDetailEntry.html(
		  "<div class=\"DataDetail_table_wrap\">"
			+ "<table>"
				+ "<tr>"
					+ "<td class=\"bemove\" width=\"20px\">"
						+ "<input class=\"DataDetail_entry_DSName\" type=\"hidden\" value=\""+entryDatasetName+"\"/>"
						+ "<input class=\"DataDetail_entry_DSKey\" type=\"hidden\" value=\""+entryDatasetKey+"\"/>"
					+ "</td>"
					+ "<td width=\"100\">"
						+ "<div class=\"DataDetail_entry_name\">" + MLanguage.parse(entryName) + "</div>"
						+ "<input type=\"hidden\" class=\"DataDetail_entry_nameML\" value=\""+entryName+"\"/>"
					+ "</td>"
					+ "<td width=\"150\">"
						+ "<div class=\"DataDetail_entry_content\">" + entryContent + "</div>"
					+ "</td>"
					+ "<td width=\"30\">"
						+ "<span class=\"DataDetail_btn_del\" onclick=\"MADDataDetail_DeleteDataDetailEntry('" + mec_id + "', '" + entryId + "')\"></span>"
						+ "<span class=\"DataDetail_btn_edit\" onclick=\"MADDataDetail_EditOne('" + mec_id + "', '" + entryId + "')\"></span>"
					+ "</td>"
				+ "</tr>"
			+ "</table>"
		+ "</div>"
	);
	$(".DataDetail_ul_root", $attrContainer).append($DataDetailEntry);
}

function MADDataDetail_EditOne(mec_id, entry_id){
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	$("#DataDetail_SUBMIT2", $attrContainer).unbind("click");
	$("#DataDetail_SUBMIT2", $attrContainer).bind("click", function(){
		MADDataDetail_AddOne(mec_id, entry_id);
	});
	MADDataDetail_ShowEditor(mec_id, entry_id);
}

function MADDataDetail_Cancel(mec_id){
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	$("#DataDetail_ADD", $attrContainer).show();
	$("#DataDetail_CANCEL", $attrContainer).hide();
	$("#DataDetail_SUBMIT", $attrContainer).hide();
	$("#DataDetail_SUBMIT2", $attrContainer).hide();
	$("#dataDetailEditor", $attrContainer).slideUp();
	$("#MADDataDetail_Submit", $attrContainer).fadeIn(1500);
}

function MADDataDetail_DeleteDataDetailEntry(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4244);  //确定删除?
	if(!confirm(msg)){
		return;
	}
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	$("#DataDetailEntry_" + id, $attrContainer).remove();
	if($(".MADDataDetail_Content > ul > li", $attrContainer).length == 0){
		$(".DataDetail_empty_tip", $attrContainer).show();
	}
}
function MADDataDetail_setDataSetName(mec_id, defDS, defKey){
	var $attrContainer = $("#MADDataDetail_" + mec_id);
	var $mecContainer = $("#MEC_Design_Container");
	var $dataSets = $("abbr[m_type='DataSet']", $mecContainer);
	if($dataSets.length == 0){
		$("#dataSetName", $attrContainer).html("<option value=\"\">"+SystemEnv.getHtmlNoteName(4394)+"</option>");  //请添加数据集
		$("#dataSetKey", $attrContainer).attr("disabled", true);
	}else{
		$("#dataSetName", $attrContainer).html("<option value=\"\">"+SystemEnv.getHtmlNoteName(4395)+"</option>");  //选择数据集
		$dataSets.each(function(){
			var that = $(this);
			var dsMecId = that.attr("id");
			var mecHandler = MECHandlerPool.getHandler(dsMecId);
			var dsName = mecHandler.mecJson["name"];
			var sql = mecHandler.mecJson["name"];
			var selectHtml = "";
			if(defDS && dsName.toLowerCase()==defDS.toLowerCase()){
				selectHtml = " selected = \"selected\" ";
			}
			var optionHtml = "<option id=\"" + dsMecId + "\" value=\"" + dsName + "\" "+ selectHtml +">" + dsName + "</option>";
			$("#dataSetName", $attrContainer).append(optionHtml);
		});
		MADDataDetail_dataSetKeyChange(mec_id, defKey);
	}
}