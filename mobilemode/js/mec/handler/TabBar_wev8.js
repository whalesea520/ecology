if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.TabBar = function(type, id, mecJson){
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
MEC_NS.TabBar.prototype.getID = function(){
	return this.id;
};

MEC_NS.TabBar.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild(true);
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.TabBar.prototype.getDesignHtml = function(){
	var theId = this.id;
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
	var datas = this.mecJson["datas"];
	for(var i = 0; i < datas.length; i++){
		var itemId = datas[i]["id"];
		var picpath = datas[i]["picpath"];
		var picpath2 = datas[i]["picpath2"];
		var noImg = false;
		if($.trim(picpath) == "" && $.trim(picpath2) == ""){
			noImg = true;
		}else{
			if($.trim(picpath) == ""){
				picpath = picpath2;
			}else if($.trim(picpath2) == ""){
				picpath2 = picpath;
			}
		}
		var showname = datas[i]["showname"];
		
		var itemClass = (i == 0) ? " active" : "";
		itemClass += noImg ? " noImg" : "";
		
		var isremind = datas[i]["isremind"];
		var reminddisplay = isremind == "1" ? "block" : "none";
		var remindnum = "N";
		var remindclass = "MEC_NumberRemind1";
		
		forHtml += forContentTemplate.replace("${itemId}", itemId)
									.replace("${itemClass}", itemClass)
									.replace("${picpath}", picpath)
									.replace("${picpath2}", picpath2)
									.replace("${showname}", showname)
									.replace("${reminddisplay}", reminddisplay)
									.replace("${remindnum}", remindnum)
									.replace("${remindclass}", remindclass);
		
	}
	var htm = htmTemplate.replace(forTemplate, forHtml);
	return htm;
};

MEC_NS.TabBar.prototype.afterDesignHtmlBuild = function(isPageOnload){
	var theId = this.id;
	if(!Mec_IsInBottomContainer(theId)){
		Mec_MoveContentFromEditorToBottom(theId);
		if(!isPageOnload){
			document.getElementById("NMEC_" + theId).scrollIntoView();
		}
	}
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.TabBar.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADTabBar_"+theId+"\">"
				+ "<div class=\"MADTabBar_Title\">"
					+ SystemEnv.getHtmlNoteName(4439)  //标签栏
					+ "<div class=\"tabbar_root_add\" onclick=\"MADTabBar_OpenWin('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
				+ "</div>"
				+ "<div class=\"MADTabBar_Content\">"
					+ "<ul class=\"tabbar_ul_root\">"
					+ "</ul>"
					+ "<div class=\"tabbar_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
				+ "</div>"
				+ "<div class=\"MADTabBar_Bottom\"><div class=\"MADTabBar_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>"
			+ "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>"  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.TabBar.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var $attrContainer = $("#MADTabBar_"+theId);
	
	var datas = this.mecJson["datas"];
	
	if(datas.length == 0){
		$(".tabbar_empty_tip", $attrContainer).show();
	}
	
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		MADTabBar_AddEntryToPage(theId, data);
	}
	
	MADTabBar_BeMove(theId);
};


/*获取JSON*/
MEC_NS.TabBar.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	return this.mecJson;
};

MEC_NS.TabBar.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["datas"] = [{
		"id" : new UUID().toString(),
		"picpath" : "/mobilemode/piclibrary/icon5/icon21.png",
		"picpath2" : "",
		"showname" : appHomepageName,
		"source_type" : "1",
		"_source_type" : SystemEnv.getHtmlNoteName(4106),  //自定义页面
		"source_value" : appHomepageId,
		"_source_value" : appHomepageName,
		"isremind" : "0",
		"remindtype" : "",
		"remindsql" : "",
		"reminddatasource" : "",
		"remindjavafilename" : ""
	}];
	
	return defMecJson;
};

function MADTabBar_ChangeDataOrder(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var datas = mecHandler.mecJson["datas"];
	
	var new_datas = [];
	
	$("#MADTabBar_"+mec_id + " > .MADTabBar_Content .tabbar_ul_root li").each(function(){
		var d_id = $(this).attr("id").replace("entry_", "");
		for(var i = 0; i < datas.length; i++){
			var data = datas[i];
			if(data["id"] == d_id){
				new_datas.push(data);
				break;
			}
		}
	});
	
	datas = null;
	mecHandler.mecJson["datas"] = new_datas;
}

function MADTabBar_BeMove(mec_id){
	$("#MADTabBar_"+mec_id + " > .MADTabBar_Content .tabbar_ul_root").sortable({
		revert: false,
		axis: "y",
		items: "> li:gt(0)",
		handle: ".bemove",
		containment: 'parent',
		stop: function(event, ui) {
			MADTabBar_ChangeDataOrder(mec_id);
		}
	});
}
function MADTabBar_OpenWin(mec_id){
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	
	var appid = $("#appid").val();
	var url = "/mobilemode/setup/navEntry.jsp?appid="+appid;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 400;//定义长度
	dlg.Height = 250;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3518);  //添加
	dlg.show();
	dlg.hookFn = function(result){
		MADTabBar_AddOrEditEntry(mec_id, result);
	};
}

function MADTabBar_EditEntry(mec_id, id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var datas = mecHandler.mecJson["datas"];
	var paramobj = null;
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		if(data["id"] == id){
			paramobj = data;
			break;
		}
	}
	if(paramobj != null){
		var picpath = paramobj["picpath"];
		var picpath2 = paramobj["picpath2"];
		var showname = encodeURIComponent(paramobj["showname"]);
		var source_type = paramobj["source_type"];
		var source_value = $m_encrypt(paramobj["source_value"]);
		var isremind = paramobj["isremind"];
		var remindtype = paramobj["remindtype"];
		var remindsql = $m_encrypt(paramobj["remindsql"]);
		var reminddatasource = paramobj["reminddatasource"];
		var remindjavafilename = paramobj["remindjavafilename"];
		
		var appid = $("#appid").val();
		var url = "/mobilemode/setup/navEntry.jsp?appid="+appid+"&picpath="+picpath+"&picpath2="+picpath2+"&showname="+showname+"&source_type="+source_type+"&source_value="+source_value+"&isremind="+isremind+"&remindtype="+remindtype+"&remindsql="+remindsql+"&reminddatasource="+reminddatasource+"&remindjavafilename="+remindjavafilename;
		var ind = $("#entry_" + id).index();
		if(ind == 0){
			url += "&disabledSource=1";
		}
		var dlg = top.createTopDialog();//获取Dialog对象
		dlg.Model = true;
		dlg.normalDialog = false;
		dlg.Width = 400;//定义长度
		dlg.Height = 228;
		dlg.URL = url;
		dlg.Title = SystemEnv.getHtmlNoteName(4002);  //编辑
		dlg.show();
		dlg.hookFn = function(result){
			paramobj["picpath"] = result["picpath"];
			paramobj["picpath2"] = result["picpath2"];
			paramobj["showname"] = result["showname"];
			paramobj["source_type"] = result["source_type"];
			paramobj["_source_type"] = result["_source_type"];
			paramobj["source_value"] = result["source_value"];
			paramobj["_source_value"] = result["_source_value"];
			paramobj["isremind"] = result["isremind"];
			paramobj["remindtype"] = result["remindtype"];
			paramobj["remindsql"] = result["remindsql"];
			paramobj["reminddatasource"] = result["reminddatasource"];
			paramobj["remindjavafilename"] = result["remindjavafilename"];
			MADTabBar_AddOrEditEntry(mec_id, paramobj);
		};
	}
}

function MADTabBar_AddOrEditEntry(mec_id, result){
	
	var $attrContainer = $("#MADTabBar_"+mec_id);
	
	var id = result["id"];
	if(!id || id == ""){	//add
		id = new UUID().toString();
		result["id"] = id;
		
		$(".tabbar_empty_tip", $attrContainer).hide();
		
		MADTabBar_AddEntryToPage(mec_id, result);
		
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var datas = mecHandler.mecJson["datas"];
		datas.push(result);
		
	}else{
		MADTabBar_EditEntryOnPage(mec_id, id, result);
	}
}

function MADTabBar_EditEntryOnPage(mec_id, id, data){
	var $attrContainer = $("#MADTabBar_"+mec_id);
	var $entry = $("#entry_" + id, $attrContainer);
	var $table_wrap = $("#tabbar_table_wrap_" + id, $entry);
	$(".tabbar_dis_icon", $table_wrap).attr("src", data["picpath"]);
	$(".tabbar_dis_showname", $table_wrap).html(MLanguage.parse(data["showname"])||data["showname"]);
	$(".tabbar_dis_sourcetype", $table_wrap).html(data["_source_type"]);
	$(".tabbar_dis_sourcecontent", $table_wrap).html(data["_source_value"]).attr("title",data["_source_value"]);
}

function MADTabBar_AddEntryToPage(mec_id, result){
	var $attrContainer = $("#MADTabBar_"+mec_id);
	
	var id = result["id"];
	var picpath = result["picpath"];
	var showname = result["showname"];
	var shownameLabel = MLanguage.parse(showname)||showname;
	var _source_type = result["_source_type"];
	var _source_value = result["_source_value"];
	
	var $entry = $("<li id=\"entry_"+id+"\"></li>");
	
	$entry.html("<div class=\"tabbar_table_wrap\" id=\"tabbar_table_wrap_" + id + "\">"
					+ "<table>"
						+ "<tr>"
							+ "<td class=\"bemove\" width=\"24px\"></td>"
							+ "<td width=\"20px\">"
								+ "<img class=\"tabbar_dis_icon\" src=\""+picpath+"\"/>"
							+ "</td>"
							+ "<td width=\"80px\">"
								+ "<div class=\"tabbar_dis_showname\">"+shownameLabel+"</div>"
							+ "</td>"
							+ "<td width=\"80px\" align=\"right\">"
								+ "<div class=\"tabbar_dis_sourcetype\">"+_source_type+"</div>"
							+ "</td>"
							+ "<td>"
								+ "<div class=\"tabbar_dis_sourcecontent\" title=\""+_source_value+"\">"+_source_value+"</div>"
							+ "</td>"
							+ "<td width=\"30px;\" align=\"right\">"
								+ "<span class=\"tabbar_btn_edit\" onclick=\"MADTabBar_EditEntry('"+mec_id+"', '"+id+"');\"></span>"
								+ "<span class=\"tabbar_btn_del\" onclick=\"MADTabBar_DeleteEntry('"+mec_id+"', '"+id+"');\"></span>"
							+ "</td>"
						+ "</tr>"
					+ "</table>"
					+"</div>");
	
	var $parentEntry = $(".tabbar_ul_root", $attrContainer);
	
	$parentEntry.append($entry);
	
	if($entry.index() == 0){
		$(".bemove", $entry).removeClass("bemove");
		$(".tabbar_btn_del", $entry).hide();
	}
	
	MADTabBar_BeMove(mec_id);
}

function MADTabBar_DeleteData(mec_id, id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var datas = mecHandler.mecJson["datas"];
	var index = -1;
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		if(data["id"] == id){
			index = i;
			break;
		}
	}
	if(index != -1){
		datas.splice(index, 1);
	}
}

function MADTabBar_DeleteEntry(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	MADTabBar_DeleteData(mec_id, id);
	
	var $attrContainer = $("#MADTabBar_"+mec_id);
	$("#entry_" + id, $attrContainer).remove();
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var datas = mecHandler.mecJson["datas"];
	if(datas.length == 0){
		$(".tabbar_empty_tip", $attrContainer).show();
	}
}