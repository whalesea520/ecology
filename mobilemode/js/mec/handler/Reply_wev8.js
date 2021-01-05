if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Reply = function(type, id, mecJson){
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
MEC_NS.Reply.prototype.getID = function(){
	return this.id;
};

MEC_NS.Reply.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Reply.prototype.getDesignHtml = function(){
	var replyName = this.mecJson["replyName"];
	
	var htm = "";
	htm += "<div class=\"Design_Reply_Container\">";
	htm += "<div class=\"Design_Reply_Content\">"+SystemEnv.getHtmlNoteName(4315)+"</div>";  //请回复...
	htm += "<div class=\"Design_Reply_Btn\" title=\""+replyName+"\">"+replyName+"</div>";
	htm += "</div>";
		
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Reply.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	if(!Mec_IsInBottomContainer(theId)){
		Mec_MoveContentFromEditorToBottom(theId);
	}
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Reply.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "";
	htm += "<div id=\"MADReply_"+theId+"\">";
	htm += "<div class=\"MADReply_Title\">"+SystemEnv.getHtmlNoteName(4316)+"</div>";  //回复信息
	htm += "<div class=\"MADReply_loading\">";
	htm += "<span>"+SystemEnv.getHtmlNoteName(4317)+"</span>";  //数据加载中，请等待...
	htm += "</div>";
	htm += "<div class=\"MADReply_BaseInfo\">";
    htm += "<span class=\"MADReply_BaseInfo_Label MADReply_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4318)+"</span>";  //按钮名称：
    htm += "<input class=\"MADReply_Text\" id=\"replyName_"+theId+"\" type=\"text\" data-multi=false />";
    htm += "</div>";
    htm += "<div class=\"MADReply_BaseInfo\" style=\"padding:0 0 0 70px;margin:10px 0;position:relative;display:none;\">";
    htm += "<span class=\"MADReply_Textarea_Label\">"+SystemEnv.getHtmlNoteName(4319)+"</span>";  //回调脚本：
    htm += "<textarea id=\"callbackFn_"+theId+"\"></textarea>";
    htm += "</div>";
    htm += "<div class=\"MADReply_BaseInfo\">";
    htm += "<span class=\"MADReply_BaseInfo_Label MADReply_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4320)+"</span>";  //默认显示：
    htm += "<input id=\"isDefault_"+theId+"\" type=\"checkbox\" />";
    htm += "</div>";
    htm += "<div class=\"MADReply_Title\">";
    htm += SystemEnv.getHtmlNoteName(4321)+"（<span class=\"leftBtnSpan\" id=\"leftBtn_"+theId+"\">"+SystemEnv.getHtmlNoteName(4322)+"</span>";  //字段设置     自动保存
    htm += "<span class=\"rightBtnSpan\" id=\"rightBtn_"+theId+"\">"+SystemEnv.getHtmlNoteName(4323)+"</span>）";  //手动保存
    htm += "</div>";
    htm += "<div class=\"MADReply_Params_Container\" id=\"paramsContainer_"+theId+"\">";
    htm += "<div class=\"MADReply_Field_Title\">";
    htm += "<span>"+SystemEnv.getHtmlNoteName(4324)+"</span><span>"+SystemEnv.getHtmlNoteName(4325)+"</span>";  //字段名称    描述
    htm += "<div class=\"params_btn_add\" onclick=\"MADReply_AddOneToParams('"+theId+"')\">"+SystemEnv.getHtmlNoteName(3518)+"</div>";  //添加
    htm += "</div>";
    htm += "<ul></ul>";
    htm += "<div class=\"MADReply_BaseInfo\" style=\"padding:15px 0 0 0;margin-bottom:0;\">";
    htm += "<span class=\"MADReply_BaseInfo_Label MADReply_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4326)+"</span>";  //提交URL：
    htm += "<input class=\"MADReply_Text\" id=\"replyUrl_"+theId+"\" type=\"text\" style=\"width:263px;\" />";
    htm += "</div>";
    htm += "</div>";
    htm += "<div class=\"MADReply_Auto_Container\" id=\"autoContainer_"+theId+"\">";
    htm += "<div class=\"MADReply_BaseInfo\">"
    htm += "<span class=\"MADReply_BaseInfo_Label MADReply_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
    htm += "<select class=\"MADReply_Select\" id=\"datasource_"+theId+"\" onchange=\"MADReply_DataSourceChange('"+theId+"');\">"
    htm += "  <option value=\"$ECOLOGY_SYS_LOCAL_POOLNAME\">(local)</option>"
    htm += "</select>"
    htm += "<input type=\"button\" id=\"reloadbutton_"+theId+"\" class=\"MADReply_Reloadbutton\" onclick=\"MADReply_RemoveTablesFromComInfo('"+theId+"')\" value=\""+SystemEnv.getHtmlNoteName(4335)+"\"/>"  //清除缓存
    htm += "</div>"
    htm += "<div class=\"MADReply_BaseInfo\">"
    htm += "<span class=\"MADReply_BaseInfo_Label MADReply_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4327)+" </span>"  //表名：
    htm += "<select class=\"MADReply_Select\" id=\"tablename_"+theId+"\" onchange=\"MADReply_TableNameChange('"+theId+"');\">"
    htm += "</select>"
    htm += "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
    htm += "<INPUT id=\"sourceSearch_"+theId+"\" class=\"MADReply_SourceSearch\" type=\"text\"/>"
    htm += "<div id=\"sourceSearchTip_"+theId+"\" class=\"MADReply_SourceSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
    htm += "</span>"
    htm += "</span>"
    htm += "</div>"
    htm += "<div id=\"sourceSearchResult_"+theId+"\" class=\"MADReply_SourceSearchResult MADReply_SourceSearchResult"+styleL+"\"><ul></ul></div>";
    htm += "<div class=\"MADReply_Field_Container\">";
    htm += "<div class=\"MADReply_Field_Title\">";
    htm += "<span class=\"fieldspan fieldspan"+styleL+"\">"+SystemEnv.getHtmlNoteName(4328)+"</span><span class=\"fieldspan fieldspan"+styleL+"\">"+SystemEnv.getHtmlNoteName(4325)+"</span>";   //对应字段   描述
    htm += "<div class=\"params_btn_add\" onclick=\"MADReply_AddOneFieldToPage('"+theId+"')\">"+SystemEnv.getHtmlNoteName(3518)+"</div>";  //添加
    htm += "</div>";
    htm += "<ul></ul>";
    htm += "</div>";
    htm += "</div>";
    htm += "<div id=\"errorMsgContainer\" style=\"border: 1px solid red;margin: 3px 0px;padding: 3px;display: none;margin:0 13px;\">";
	htm += "<div id=\"errorMsgTitle\" style=\"color: red;font-weight: bold;\"></div>";
	htm += "<div style=\"color: red;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"errorMsgContent\"></span></div>";
	htm += "</div>";
	htm += "</div>";
	htm += "<div class=\"MADReply_Bottom\">";
    htm += "<div class=\"MADReply_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>";  //确定
    htm += "</div>";
    
    htm += "<div class=\"MADReply_Tip\"><span style=\"font-size:12px;font-weight:bolder;\">"+SystemEnv.getHtmlNoteName(4329)+"</span>";  //调用说明：
    htm += "<div class=\"\">Mobile_NS.replyPageHide(); --"+SystemEnv.getHtmlNoteName(4330)+"</div>";  //插件隐藏
    htm += "<div class=\"\">Mobile_NS.replyDataSet(jsonObj); --"+SystemEnv.getHtmlNoteName(4331)+"</div>";  //隐藏域赋值
    htm += "<div class=\"\">Mobile_NS.replyPageShow(callbackFn, jsonObj); --"+SystemEnv.getHtmlNoteName(4332)+"</div>";  //插件显示
    htm += "</div>";
    
	htm += "</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Reply.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var replyName = this.mecJson["replyName"];
	var isDefault = this.mecJson["isDefault"];// 默认显示
	var datasource = this.mecJson["datasource"];
	var tablename = this.mecJson["tablename"];
	var isAuto = this.mecJson["isAuto"];
	
	$("#replyName_"+theId).val(replyName);
	if(isDefault == "1") $("#isDefault_"+theId).attr("checked", true);
	$("#datasource_"+theId).val(datasource);
	$("#tablename_"+theId).val(tablename);
	
	var $leftBtn = $("#leftBtn_"+theId);
	var $rightBtn  = $("#rightBtn_"+theId);
	var $autoContainer = $("#autoContainer_"+theId);
	var $paramsContainer = $("#paramsContainer_"+theId);
	if(isAuto == "0"){// 自动保存
		$leftBtn.addClass("checked");
		$paramsContainer.hide();
	}else{// 手动保存
		$rightBtn.addClass("checked");
		$autoContainer.hide();
	}
	
	var isAutoParams = this.mecJson["isAutoParams"];
	MADReply_setDataSourceHTML(theId,datasource,tablename,isAutoParams);
	MADReply_InitSourceSearch(theId);
	
	var replyUrl = this.mecJson["replyUrl"]; 
	$("#replyUrl_"+theId).val(replyUrl);
	var params = this.mecJson["params"];
	for(var i = 0; params && i < params.length; i++){
		MADReply_AddOneParamToPage(theId, params[i]);
	}
	
	var $attrContainer = $("#MADReply_"+theId);
	var $ul = $(".MADReply_Params_Container > ul", $attrContainer);
	if($ul.children().length < 1){
		var params = this.mecJson["params"];
		MADReply_AddOneParamToPage(theId, params[0]);
	}
	
	$leftBtn.click(function(){
		$(this).addClass("checked");
		$rightBtn.removeClass("checked");
		$autoContainer.show();
		$paramsContainer.hide();
	});
	$rightBtn.click(function(){
		$(this).addClass("checked");
		$leftBtn.removeClass("checked");
		$autoContainer.hide();
		$paramsContainer.show();
	});
	
	$("#MADReply_"+theId).jNice();
	
	MLanguage({
		container: $("#MADReply_"+theId)
    });
};

/*获取JSON*/
MEC_NS.Reply.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADReply_"+theId);
	if($attrContainer.length > 0){
		var replyName = Mec_FiexdUndefinedVal($("#replyName_"+theId).val());
		var replyNameML = MLanguage.getValue($("#replyName_"+theId));
		this.mecJson["replyName"] = replyNameML == undefined ? replyName : replyNameML;
		
		this.mecJson["isDefault"] = $("#isDefault_"+theId).is(":checked") ? "1" : "0";
		this.mecJson["datasource"] = $("#datasource_"+theId).val();
		this.mecJson["tablename"] = $("#tablename_"+theId).val();
		
		
		if($("#leftBtn_"+theId).hasClass("checked")){
			this.mecJson["isAuto"] = "0";// 自动保存
		}else{
			this.mecJson["isAuto"] = "1";// 手动保存
		}
		
		var param;
		var isAutoParams = [];
		var $fieldLi = $(".MADReply_Field_Container > ul > li", $attrContainer);
		$fieldLi.each(function(){
			var liId = $(this).attr("id");
			if(liId && liId != ""){
				var param_id = liId.substring("li_".length);
				var paramName = Mec_FiexdUndefinedVal($("select", $(this)).val());
				$input = $("input", $(this));
				var desc = Mec_FiexdUndefinedVal($input.val());
				var descML = MLanguage.getValue($input);
				var paramValue = Mec_FiexdUndefinedVal($input.attr("paramValue"));
				paramValue = decodeURIComponent(paramValue);
				var isSystem = $input.attr("isSystem");
				
				param = {};
				param["id"] = param_id;
				param["paramName"] = paramName;
				param["paramValue"] = paramValue;
				param["desc"] = descML == undefined ? desc : descML;
				param["isEncrypt"] = "0";
				param["isSystem"] = isSystem;
				isAutoParams.push(param);
				
			}
		});
		this.mecJson["isAutoParams"] = isAutoParams;
		
		var replyUrl = Mec_FiexdUndefinedVal($("#replyUrl_"+theId).val());
		this.mecJson["replyUrl"] = replyUrl;
		
		var params = this.mecJson["params"];
		var $paramLi = $(".MADReply_Params_Container > ul > li", $attrContainer);
		$paramLi.each(function(){
			var liId = $(this).attr("id");
			if(liId && liId != ""){
				var param_id = liId.substring("li_".length);
				var param_name = Mec_FiexdUndefinedVal($("input", $(this)).val());
				for(var i = 0; i < params.length; i++){
					if(params[i]["id"] == param_id){
						params[i]["paramName"] = param_name;
						break;
					}
				}
			}
		});
		
	}
	
	return this.mecJson;
};

MEC_NS.Reply.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["replyName"] = SystemEnv.getHtmlNoteName(4336);  //提交
	defMecJson["replyUrl"] = "";
	defMecJson["isDefault"] = "0";
	defMecJson["isAuto"] = "0";	
	defMecJson["datasource"] = "";
	defMecJson["tablename"] = "";
	
	var param = {};
	param["id"] = new UUID().toString();
	param["paramName"] = "content";
	param["paramValue"] = "";
	param["desc"] = SystemEnv.getHtmlNoteName(4337);  //回复内容
	param["isEncrypt"] = "0";
	param["isSystem"] = "1";
	var params = [];
	params.push(param);
	defMecJson["params"] = params;	
	defMecJson["isAutoParams"] = params;
	
	return defMecJson;
};

function MADReply_AddOneToParams(mec_id){
	var url = "/mobilemode/paraminfo.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 400;//定义长度
	dlg.Height = 350;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3518);  //添加
	dlg.show();
	dlg.hookFn = function(result){
		result["id"] = new UUID().toString();
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var params = mecHandler.mecJson["params"];
		params.push(result);
		MADReply_AddOneParamToPage(mec_id, result);
	};
}

function MADReply_AddOneParamToPage(mec_id, paramobj){
	var styleL = "_style" + _userLanguage;
	var $attrContainer = $("#MADReply_"+mec_id);
	var $ul = $(".MADReply_Params_Container > ul", $attrContainer);
	var $li = $("<li id=\"li_"+paramobj["id"]+"\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"100px\" valign=\"middle\">";
			    	htm += "<input type=\"text\" class=\"MADReply_Text MADReply_Text"+styleL+"\" style=\"height:20px;line-height:10px;\" value=\""+paramobj["paramName"]+"\"/>";
			    htm += "</td>";
			    
			    htm += "<td width=\"160px\">";
					htm += "<div class=\"MADReply_Params_desc\">";
						htm += MLanguage.parse(paramobj["desc"]);
					htm += "</div>";
				htm += "</td>";
				
				htm += "<td align=\"right\">";
				var isSystem = paramobj["isSystem"];
				if(isSystem != "1"){
					htm += "<span class=\"params_btn_edit\" onclick=\"MADReply_editOneParamOnPage('"+mec_id+"','"+paramobj["id"]+"')\"></span>";
					htm += "<span class=\"params_btn_del\" onclick=\"MADReply_deleteOneParamOnPage('"+mec_id+"','"+paramobj["id"]+"')\"></span>";
				}
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm); 
	$ul.append($li);
}

function MADReply_editOneParamOnPage(mec_id, param_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var params = mecHandler.mecJson["params"];
	var paramobj = null;
	for(var i = 0; i < params.length; i++){
		var data = params[i];
		if(data["id"] == param_id){
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
		dlg.Height = 350;
		dlg.URL = url;
		dlg.Title = SystemEnv.getHtmlNoteName(3518);  //添加
		dlg.show();
		dlg.hookFn = function(result){
			paramobj["paramName"] = result["paramName"];
			paramobj["paramValue"] = result["paramValue"];
			paramobj["desc"] = result["desc"];
			paramobj["isEncrypt"] = result["isEncrypt"];
			
			var $li = $("#li_" + param_id);
			$("input", $li).val(result["paramName"]);
			$(".MADReply_Params_desc", $li).html(MLanguage.parse(paramobj["desc"]));
		};
	}
}

function MADReply_deleteOneParamOnPage(mec_id, param_id){
	if(!confirm(SystemEnv.getHtmlNoteName(4175))){  //确定删除吗？
		return;
	}
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var params = mecHandler.mecJson["params"];
	var index = -1;
	for(var i = 0; i < params.length; i++){
		var data = params[i];
		if(data["id"] == param_id){
			index = i;
			break;
		}
	}
	if(index != -1){
		params.splice(index, 1);
	}
	
	$("#li_" + param_id).remove();
}

function MADReply_setDataSourceHTML(mec_id,datasource,tablename,isAutoParams){
	var $MADReply_DataSource = $("#datasource_" + mec_id);
	var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=getDataSource");
	FormmodeUtil.doAjaxDataLoad(url, function(datas){
		for(var i = 0; i < datas.length; i++){
			var data = datas[i];
			var pointid = data;
			var selected = "";
			if (pointid=="" || typeof(pointid)=="undefined") continue;
			if (pointid == datasource) selected = "selected";
			var dataSourceSelectHtml = "<option value=\""+pointid+"\" "+selected+">";
			dataSourceSelectHtml += pointid;
			dataSourceSelectHtml += "</option>";
			$MADReply_DataSource.append(dataSourceSelectHtml);
		}
		MADReply_DataSourceChange(mec_id,tablename,isAutoParams);
	});
}

function MADReply_DataSourceChange(mec_id,tablename,isAutoParams){
	resetErrorMsg();
	var $vdatasource = $("#datasource_" + mec_id);
	var $vtableName = $("#tablename_" + mec_id);
	var $vtableName_loading = $(".MADReply_loading");
	var vdatasourceV = $vdatasource.val();

	$vdatasource.attr("disabled",true);
	$vtableName.attr("disabled",true);
	$vtableName_loading.show();
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getDataSourceTables&datasource="+vdatasourceV);
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		var status = result.status;
		if(status == "1"){
			var data = result.data;
			MADReply_addTablenameOption(mec_id,data,tablename,isAutoParams);
		}else{
			var errorMsg = result.errorMsg;
			setErrorMsg(SystemEnv.getHtmlNoteName(4333), errorMsg);  //获取表(视图)时发生如下错误：
		}
	});
}

function setErrorMsg(title, content){
	$("#errorMsgTitle").html(title);
	$("#errorMsgContent").html(content);
	$("#errorMsgContainer").show();
}

function resetErrorMsg(){
	$("#errorMsgTitle").html("");
	$("#errorMsgContent").html("");
	$("#errorMsgContainer").hide();
}

function MADReply_addTablenameOption(mec_id,data,tablename,isAutoParams){
	var $vtableName=$("#tablename_"+mec_id);
	var optionHtml = "";
	for(var i = 0; i < data.length; i++){
		var table_name = data[i]["table_name"];
		var table_type = data[i]["table_type"];
		if(table_type == "VIEW")continue;
		var selected = "";
		if (table_name == tablename) selected = "selected";
		var showText = table_name + (table_type == "TABLE" ? " ["+SystemEnv.getHtmlNoteName(4509)+"]" : "");//表
		var virtualformtype = table_type == "TABLE" ? 0 : "";
		optionHtml += "<option value=\""+table_name+"\" virtualformtype=\""+virtualformtype+"\" "+selected+">"+showText+"</option>";
	}
	$vtableName.empty().append(optionHtml);
	
	if(!tablename) tablename = $vtableName.val();
	for(var i = 0; isAutoParams && i < isAutoParams.length; i++){
		MADReply_AddOneFieldToPage(mec_id, isAutoParams[i], tablename);
	}
	
	var $vdatasource = $("#datasource_" + mec_id);
	var $vtableName_loading = $(".MADReply_loading");
	$vdatasource.removeAttr("disabled");
	$vtableName.removeAttr("disabled");
	$vtableName_loading.hide();
}

function MADReply_InitSourceSearch(mec_id){
	var $searchText = $("#sourceSearch_" + mec_id);
	var $searchTextTip = $("#sourceSearchTip_" + mec_id);
	
	$searchTextTip.click(function(e){
		$searchText[0].focus();
		e.stopPropagation(); 
	});
	
	$searchText.focus(function(){
		$searchTextTip.hide();
	});
	
	$searchText.blur(function(){
		if(this.value == ""){
			$searchTextTip.show();
		}
	});
	
	$searchText.click(function(e){
		e.stopPropagation(); 
	});
	
	var $srarchResult = $("#sourceSearchResult_" + mec_id);
	function hideSearchResult(){
		$srarchResult.hide();	
	}
	
	function showSearchResult(){
		$srarchResult.show();	
	}
	
	function clearSearchResult(){
		$srarchResult.children("ul").find("*").remove();	
	}
	
	var preSearchText = "";
	
	$searchText.keyup(function(event){
		if(this.value == ""){
			preSearchText = "";
			hideSearchResult();
			clearSearchResult();
		}else{
			if(this.value != preSearchText){
				preSearchText = this.value;
				var searchValue = this.value;
				//clearSearchResult();
				
				var resultHtml = "";
				
				var $vtableName = $("#tablename_"  + mec_id);
				$vtableName.find("option").each(function(){
					var vt = $(this).text();
					var vv = $(this).attr("value");
					if(vt.toLowerCase().indexOf(searchValue.toLowerCase()) != -1){
						resultHtml += "<li><a href=\"javascript:MADReply_SetSourceSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
					}
				});
				
				if(resultHtml == ""){
					resultHtml = "<li><font class='tip'>"+SystemEnv.getHtmlNoteName(4270)+"</font></li>";  //无匹配的结果
				}
				
				$srarchResult.children("ul").html(resultHtml);
				showSearchResult();
			}
		}
	});
	
	$("#MADReply_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADReply_SetSourceSelected(mec_id, v){
	var $source = $("#tablename_" + mec_id);
	$source.val(v);
	MADReply_TableNameChange(mec_id);
	
	preSearchText = "";
	var $searchText = $("#sourceSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
}

function MADReply_RemoveTablesFromComInfo(mec_id){
	var $vdatasource = $("#datasource_" + mec_id);
	var $vtableName = $("#tablename_" + mec_id);
	var $vtableName_loading = $(".MADReply_loading");
	var vdatasourceV = $vdatasource.val();

	$vdatasource.attr("disabled",true);
	$vtableName.attr("disabled",true);
	$vtableName_loading.show();
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=removeTablesFromComInfo&datasource="+vdatasourceV);
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		var message = result.message;
		var status = result.status;
		if(status == "1"){
			MADReply_DataSourceChange(mec_id);
		}else{
			$vdatasource.removeAttr("disabled");
			$vtableName.removeAttr("disabled")
			$vtableName_loading.hide();
			alert(message);
		}
	});
}

function MADReply_AddOneFieldToPage(mec_id, paramobj, tablename){
	var styleL = "_style" + _userLanguage;
	if(!paramobj){
		paramobj = {};
		paramobj["id"] = new UUID().toString();
		paramobj["paramName"] = "";
		paramobj["paramValue"] = "";
		paramobj["desc"] = "";
		paramobj["isSystem"] = "0";
	}
	if(!tablename){
		tablename = $("#tablename_" + mec_id).val();
	}
	
	var isSystem = paramobj["isSystem"];
	var $attrContainer = $("#MADReply_"+mec_id);
	var $ul = $(".MADReply_Field_Container > ul", $attrContainer);
	var $li = $("<li id=\"li_"+paramobj["id"]+"\"></li>");
	var htm = "<table style=\"margin-top:5px;\">";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"100px\" valign=\"middle\">";
			    	htm += "<select class=\"MADReply_Select\" ></select>";
			    htm += "</td>";
			    
			    htm += "<td width=\"160px\">";
		    	if(isSystem != "1"){
		    		var paramValue = paramobj["paramValue"];
		    		paramValue = encodeURIComponent(paramValue);
		    		htm += "<input type=\"text\" class=\"MADReply_Text MADReply_Text"+styleL+"\" value=\""+paramobj["desc"]+"\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4334)+"\" paramValue=\""+paramValue+"\"/>";  //在此填写描述...
		    	}else{
		    		htm += "<input type=\"text\" class=\"MADReply_Text MADReply_Text"+styleL+"\" value=\""+paramobj["desc"]+"\" isSystem=\"1\" readonly />";
		    	}
				htm += "</td>";
				
				htm += "<td align=\"right\">";
				if(isSystem != "1"){
					htm += "<span class=\"params_btn_edit\" onclick=\"MADReply_editOneFieldOnPage('"+mec_id+"','"+paramobj["id"]+"')\"></span>";
					htm += "<span class=\"params_btn_del\" onclick=\"MADReply_deleteOneFieldOnPage('"+mec_id+"','"+paramobj["id"]+"')\"></span>";
				}
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
	addFieldSelectOption(mec_id, $li, paramobj["paramName"], tablename);
	
	MLanguage({
		container: $li
    });
}

function MADReply_editOneFieldOnPage(mec_id, param_id){
	var $input = $("input", "#li_"+param_id);

	var paramValue = decodeURIComponent($input.attr("paramValue"));
	paramValue = $m_encrypt(paramValue);// 系统安全编码
	
	var url = "/mobilemode/defaultparaminfo.jsp?paramValue="+paramValue;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 358;//定义长度
	dlg.Height = 250;
	dlg.normalDialog = false;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4002);  //编辑
	dlg.show();
	dlg.hookFn = function(result){
		paramValue = result["paramValue"];
		$input.attr("paramValue", encodeURIComponent(paramValue));
	};
}

function MADReply_deleteOneFieldOnPage(mec_id, param_id){
	if(confirm(SystemEnv.getHtmlNoteName(4175))) $("#li_" + param_id).remove();  //确定删除吗？
}

function addFieldSelectOption(mec_id, $li, paramName, tablename){
	if(!tablename) return;
	
	var datasource = $("#datasource_"+mec_id).val();
	var url = "/formmode/setup/formSettingsAction.jsp?action=getFieldsByTable&dsName="+datasource+"&tbName="+tablename;
	$.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	cache:true,
	 	success: function(responseText, textStatus) 
	 	{
	 		var result = $.parseJSON(responseText);
	 		var status = result.status;
			if(status == "1"){
				var optionHtml = "";
				var data = result.data;
				for(var i = 0; i < data.length; i++){
					var column_name = data[i]["column_name"];
					optionHtml+= "<option value=\""+column_name+"\">"+column_name+"</option>";
				}
				var $fieldObj = $(".MADReply_Select", $li);
				$fieldObj.empty().append(optionHtml);
				if(paramName){// 对应字段选中
					 $fieldObj.val(paramName);
				}
			}
	 	},
	    error: function(){
	    }
	});
}

function MADReply_TableNameChange(mec_id){
	var datasource = $("#datasource_"+mec_id).val();
	var tablename = $("#tablename_"+mec_id).val();
	var url = "/formmode/setup/formSettingsAction.jsp?action=getFieldsByTable&dsName="+datasource+"&tbName="+tablename;
	$.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	cache:true,
	 	success: function(responseText, textStatus) 
	 	{
	 		var result = $.parseJSON(responseText);
	 		var status = result.status;
			if(status == "1"){
				var optionHtml = "";
				var data = result.data;
				for(var i = 0; i < data.length; i++){
					var column_name = data[i]["column_name"];
					if(column_name.toLowerCase()=="id")continue;
					optionHtml+= "<option value=\""+column_name+"\">"+column_name+"</option>";
				}
				
				var $attrContainer = $("#MADReply_"+mec_id);
				var $fieldObjs = $(".MADReply_Field_Container .MADReply_Select", $attrContainer);
				for(i = 0; i < $fieldObjs.length; i++){
					var obj = $fieldObjs[i];
					$(obj).empty().append(optionHtml);
				}
			}
	 	},
	    error: function(){
	    }
	});
}
