if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.TouchButton = function(type, id, mecJson){
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
MEC_NS.TouchButton.prototype.getID = function(){
	return this.id;
};

MEC_NS.TouchButton.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.TouchButton.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htm = "<div id=\"touchBtn\"></div>";
	return htm;
};

MEC_NS.TouchButton.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	var $Design_MecHandler = $("#" + theId);
	$Design_MecHandler.addClass("Design_MecHandler_UnSortable");
	
	var $touchBtn = $("#touchBtn");
	
	var timer = null; 
	$Design_MecHandler.pep({
		useCSSTranslation: false,
		constrainTo: '#content_editor',
		shouldEase: false,
		//shouldPreventDefault: false,
		start: function(ev, obj){
			
			$touchBtn[0].style.opacity = "";
			$touchBtn.addClass("custom-active");
			if(timer != null){
				clearTimeout(timer);
				timer = null;
			}
		},
		drag: function(ev, obj){
		},
		stop: function(ev, obj){
			var containerWidth = $("#content_editor").width();
			var eWidth = obj.$el.outerWidth();
			var lWidth = (containerWidth - eWidth) / 2;
			
			var moveT = obj.$el.position().top;
			var moveL;
			var l = obj.$el.position().left;
			if(l >= lWidth){
				moveL = (containerWidth - eWidth);
			}else{
				moveL = 0;
			}
			
			this.moveTo(moveL, moveT, true);
			
			timer = setTimeout(function(){
				$touchBtn.animate({opacity: '0.3'}, 800, function(){
					this.style.opacity = "";
					$(this).removeClass("custom-active");
					timer = null;
				});
			}, 2000);
		}
	});
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.TouchButton.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADTOUCH_"+theId+"\">"
				+ "<div class=\"MADTOUCH_Title\">"
					+ SystemEnv.getHtmlNoteName(4271)  //浮动按钮
					+ "<div class=\"touch_root_add\" onclick=\"MADTOUCH_OpenWin('"+theId+"', null);\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
				+ "</div>"
				+ "<div class=\"MADTOUCH_Content\">"
					+ "<ul class=\"touch_ul_root\">"
					+ "</ul>"
					+ "<div class=\"touch_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
				+ "</div>"
				+ "<div class=\"MADTOUCH_Bottom\"><div class=\"MADTOUCH_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>"
			+ "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>"  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.TouchButton.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var $attrContainer = $("#MADTOUCH_"+theId);
	
	var touch_datas = this.mecJson["touch_datas"];
	
	if(touch_datas.length == 0){
		$(".touch_empty_tip", $attrContainer).show();
	}
	
	for(var i = 0; i < touch_datas.length; i++){
		var data = touch_datas[i];
		MADTOUCH_AddTouchEntryToPage(theId, data);
	}
	
	MADTOUCH_BeMove(theId);
};


/*获取JSON*/
MEC_NS.TouchButton.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	return this.mecJson;
};

MEC_NS.TouchButton.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["touch_datas"] = [];
	
	defMecJson["touch_level_count"] = 4;
	
	return defMecJson;
};

function MADTOUCH_ChangeTouchDataOrder(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var touch_datas = mecHandler.mecJson["touch_datas"];
	
	var new_touch_datas = [];
	
	$("#MADTOUCH_"+mec_id + " > .MADTOUCH_Content .touch_ul_root li").each(function(){
		var d_id = $(this).attr("id").replace("TouchEntry_", "");
		for(var i = 0; i < touch_datas.length; i++){
			var data = touch_datas[i];
			if(data["id"] == d_id){
				new_touch_datas.push(data);
				break;
			}
		}
	});
	
	touch_datas = null;
	mecHandler.mecJson["touch_datas"] = new_touch_datas;
}

function MADTOUCH_BeMove(mec_id){
	$("#MADTOUCH_"+mec_id + " > .MADTOUCH_Content .touch_ul_root").sortable({
		revert: false,
		axis: "y",
		items: "> li",
		handle: ".bemove",
		containment: 'parent',
		stop: function(event, ui) {
			MADTOUCH_ChangeTouchDataOrder(mec_id);
		}
	});
	
	$("#MADTOUCH_"+mec_id + " > .MADTOUCH_Content .touch_ul_root > li > ul").sortable({
		revert: false,
		axis: "y",
		items: "> li",
		handle: ".bemove",
		containment: 'parent',
		stop: function(event, ui) {
			MADTOUCH_ChangeTouchDataOrder(mec_id);
		}
	});
	
	$("#MADTOUCH_"+mec_id + " > .MADTOUCH_Content .touch_ul_root > li > ul > li > ul").sortable({
		revert: false,
		axis: "y",
		items: "> li",
		handle: ".bemove",
		containment: 'parent',
		stop: function(event, ui) {
			MADTOUCH_ChangeTouchDataOrder(mec_id);
		}
	});
}
function MADTOUCH_OpenWin(mec_id, pid){
	if(!pid){
		pid = "";
	}
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var touch_level_count = mecHandler.mecJson["touch_level_count"];
	var childNum = MADTOUCH_ChildTouchEntryNum(mec_id, pid);
	if(childNum >= touch_level_count){
		if(_userLanguage=="8"){
			top.Dialog.alert("A maximum of only " + touch_level_count + " elements can be added", null, 200, 60);
		}else if(_userLanguage=="9"){
			top.Dialog.alert("一級最多隻能添加" + touch_level_count + "个元素", null, 200, 60);
		}else{
			top.Dialog.alert("一级最多只能添加" + touch_level_count + "個元素", null, 200, 60);
		}

		
		return;
	}
	
	var appid = $("#appid").val();
	var url = "/mobilemode/touchEntry.jsp?appid="+appid;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 400;//定义长度
	dlg.Height = 228;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3518);  //添加
	dlg.show();
	dlg.hookFn = function(result){
		result["pid"] = pid;
		MADTOUCH_AddOrEditTouchEntry(mec_id, result);
	};
}

function MADTOUCH_EditTouchEntry(mec_id, id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var touch_datas = mecHandler.mecJson["touch_datas"];
	var paramobj = null;
	for(var i = 0; i < touch_datas.length; i++){
		var data = touch_datas[i];
		if(data["id"] == id){
			paramobj = data;
			break;
		}
	}
	if(paramobj != null){
		var picpath = paramobj["picpath"];
		var showname = encodeURIComponent(paramobj["showname"]);
		var source_type = paramobj["source_type"];
		var source_value = paramobj["source_value"];
		var isremind = paramobj["isremind"];
		var remindtype = paramobj["remindtype"];
		var remindsql = $m_encrypt(paramobj["remindsql"]);
		var reminddatasource = paramobj["reminddatasource"];
		var remindjavafilename = paramobj["remindjavafilename"];
		
		var appid = $("#appid").val();
		var url = "/mobilemode/touchEntry.jsp?appid="+appid+"&picpath="+picpath+"&showname="+showname+"&source_type="+source_type+"&source_value="+source_value+"&isremind="+isremind+"&remindtype="+remindtype+"&remindsql="+remindsql+"&reminddatasource="+reminddatasource+"&remindjavafilename="+remindjavafilename;
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
			MADTOUCH_AddOrEditTouchEntry(mec_id, paramobj);
		};
	}
}

function MADTOUCH_AddOrEditTouchEntry(mec_id, result){
	
	var $attrContainer = $("#MADTOUCH_"+mec_id);
	
	var id = result["id"];
	if(!id || id == ""){	//add
		id = new UUID().toString();
		result["id"] = id;
		
		$(".touch_empty_tip", $attrContainer).hide();
		
		MADTOUCH_AddTouchEntryToPage(mec_id, result);
		
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var touch_datas = mecHandler.mecJson["touch_datas"];
		touch_datas.push(result);
		
	}else{
		MADTOUCH_EditTouchEntryOnPage(mec_id, id, result);
	}
}

function MADTOUCH_EditTouchEntryOnPage(mec_id, id, data){
	var $attrContainer = $("#MADTOUCH_"+mec_id);
	var $touchEntry = $("#TouchEntry_" + id, $attrContainer);
	var $touch_table_wrap = $("#touch_table_wrap_" + id, $touchEntry);
	$(".touch_dis_icon", $touch_table_wrap).attr("src", data["picpath"]);
	$(".touch_dis_showname", $touch_table_wrap).html(MLanguage.parse(data["showname"]));
	$(".touch_dis_sourcetype", $touch_table_wrap).html(data["_source_type"]);
	$(".touch_dis_sourcecontent", $touch_table_wrap).html(data["_source_value"]).attr("title",data["_source_value"]);
}

function MADTOUCH_AddTouchEntryToPage(mec_id, result){
	var $attrContainer = $("#MADTOUCH_"+mec_id);
	
	var id = result["id"];
	var pid = result["pid"]
	var picpath = result["picpath"];
	var showname = MLanguage.parse(result["showname"]);
	var _source_type = result["_source_type"];
	var _source_value = result["_source_value"];
	
	var $TouchEntry = $("<li id=\"TouchEntry_"+id+"\"></li>");
	
	$TouchEntry.html("<div class=\"touch_table_wrap\" id=\"touch_table_wrap_" + id + "\">"
					+ "<table>"
						+ "<tr>"
							+ "<td width=\"16px\" class=\"bemove\" style=\"cursor: move;\">"
								+ "<img class=\"touch_dis_icon\" src=\""+picpath+"\"/>"
							+ "</td>"
							+ "<td width=\"80px\">"
								+ "<div class=\"touch_dis_showname\">"+showname+"</div>"
							+ "</td>"
							+ "<td width=\"60px\" align=\"right\">"
								+ "<div class=\"touch_dis_sourcetype\">"+_source_type+"</div>"
							+ "</td>"
							+ "<td>"
								+ "<div class=\"touch_dis_sourcecontent\" title=\""+_source_value+"\">"+_source_value+"</div>"
							+ "</td>"
							+ "<td width=\"50px;\" align=\"right\">"
								+ "<span class=\"touch_btn_del\" onclick=\"MADTOUCH_DeleteTouchEntry('"+mec_id+"', '"+id+"');\"></span>"
								+ "<span class=\"touch_btn_edit\" onclick=\"MADTOUCH_EditTouchEntry('"+mec_id+"', '"+id+"');\"></span>"
								+ "<span class=\"touch_btn_add\" onclick=\"MADTOUCH_OpenWin('"+mec_id+"', '"+id+"');\"></span>"
							+ "</td>"
						+ "</tr>"
					+ "</table>"
					+"</div>");
	
	var $ParentTouchEntry;
	if(!pid || pid == ""){
		$ParentTouchEntry = $(".touch_ul_root", $attrContainer);
	}else{
		var $PTouchEntryWrap = $("#TouchEntry_" + pid, $attrContainer);
		$ParentTouchEntry = $PTouchEntryWrap.children("ul");
		if($ParentTouchEntry.length == 0){
			$ParentTouchEntry = $("<ul></ul>");
			$PTouchEntryWrap.append($ParentTouchEntry);
		}
	}
	
	$ParentTouchEntry.append($TouchEntry);
	
	MADTOUCH_BeMove(mec_id);
}

function MADTOUCH_HasChildTouchEntry(mec_id, id){
	return MADTOUCH_ChildTouchEntryNum(mec_id, id) > 0;
}

function MADTOUCH_ChildTouchEntryNum(mec_id, id){
	var result = 0;
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var touch_datas = mecHandler.mecJson["touch_datas"];
	for(var i = 0; i < touch_datas.length; i++){
		var data = touch_datas[i];
		if(data["pid"] == id){
			result++;
		}
	}
	return result;
}

function MADTOUCH_DeleteTouchData(mec_id, id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var touch_datas = mecHandler.mecJson["touch_datas"];
	if(MADTOUCH_HasChildTouchEntry(mec_id, id)){
		for(var i = 0; i < touch_datas.length; i++){
			var data = touch_datas[i];
			if(data["pid"] == id){
				MADTOUCH_DeleteTouchData(mec_id, data["id"]);
			}
		}
		MADTOUCH_DeleteTouchData(mec_id, id);
	}else{
		var index = -1;
		for(var i = 0; i < touch_datas.length; i++){
			var data = touch_datas[i];
			if(data["id"] == id){
				index = i;
				break;
			}
		}
		if(index != -1){
			touch_datas.splice(index, 1);
		}
	}
}

function MADTOUCH_DeleteTouchEntry(mec_id, id){
	var hasChild = MADTOUCH_HasChildTouchEntry(mec_id, id);
	var msg;
	if(hasChild){
		msg = SystemEnv.getHtmlNoteName(4272);  //删除此数据会级联删除其子项\n确定删除吗？
	}else{
		msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	}
	if(!confirm(msg)){
		return;
	}
	
	MADTOUCH_DeleteTouchData(mec_id, id);
	
	var $attrContainer = $("#MADTOUCH_"+mec_id);
	$("#TouchEntry_" + id, $attrContainer).remove();
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var touch_datas = mecHandler.mecJson["touch_datas"];
	if(touch_datas.length == 0){
		$(".touch_empty_tip", $attrContainer).show();
	}
}