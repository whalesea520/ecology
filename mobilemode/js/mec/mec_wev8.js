var $editorScroll;
function mecLoaded(){
	
	Mec_SetDraggableHeight();
	
	initToMecDesign();
	
	sortableMECDesignContainer();
	
	var max_Zindex = "2147483647";
	
	var $metro = $(".metro");
	var m_Zindex = $metro.css("z-index");
    $(".mec_item .mec_node", $metro).draggable({
		connectToSortable: "#MEC_Design_Container",
		helper: "clone",
		revert: "invalid",
		revertDuration: 0,
		cancel: ".mec_item_disabled",
		start: function(){
			$metro.css("z-index",max_Zindex);
		},
		stop: function() {
			$metro.css("z-index",m_Zindex);
			parseToMecDesign();
		}
    });
    
    var $mecExpandContainer = $("#mecExpandContainer");
    var e_Zindex = $mecExpandContainer.css("z-index");
    $(".mec_item .mec_node", $mecExpandContainer).draggable({
		connectToSortable: "#MEC_Design_Container",
		helper: "clone",
		revert: "invalid",
		revertDuration: 0,
		cancel: ".mec_item_disabled",
		start: function(){
			$mecExpandContainer.css("z-index",max_Zindex);
		},
		stop: function() {
			$mecExpandContainer.css("z-index",e_Zindex);
			parseToMecDesign();
		}
    });
    
    $("#mecExpandContainer, #mec_item_container").on("click", function(e){
    	e.stopPropagation();
    });
    
	registerMECDesignEvent();
	
	$editorScroll = $("#content_editor").niceScroll();
	
	giveMecIndex();
	
	MECHandlerPool.eachHandler(function(i){
		if(typeof(this.runWhenPageOnLoad) == "function"){
			this.runWhenPageOnLoad();
		}
	});
	
	initPicChangeByRightMenu();
	
	$("#pageAttr_setting").click(function(e){
		triggerPageAttrDesign();
		
		e.stopPropagation(); 
	});
	
	$("body").click(function(){
		unexpandMEC();
	});
	//去除复制插件生成的多余节点
	if($(".zclip").length > 0){
		$(".zclip").remove();
	}
	$(".Design_MecHandler .copy_btn").each(function(){
		buildZclip($(this));
	});
	
	triggerLazyloadWithImg();
};

function sortableMECDesignContainer(){
	$("#MEC_Design_Container").sortable({
		revert: false,
		axis: "y",
		items: ".Design_MecHandler",
		cancel: ".Design_MecHandler_UnSortable",
		placeholder: "ul-state-highlight",
		stop: function(event, ui) {
			giveMecIndex();
		}
	}).disableSelection();
}

function registerMECDesignEvent(){
	/*删除*/
	$(".Design_MecHandler .del_btn").live("click", function(e){
		var mec_id = $(this).parent().attr("id");
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		if(typeof(mecHandler.onDelete) == "function"){
			mecHandler.onDelete();
		}
		if(copy){
			var $copyBtn = $(this).siblings(".copy_btn");
			$copyBtn.zclip("remove");
			sortableMECDesignContainer();
			copy = false;
		}
		deleteMecDesign(mec_id);
		e.stopPropagation(); 
	});
	
	function triggerMecHandlerDel(event){
		var keyCode = event.keyCode;
		if(keyCode == 46){
			var se = event.srcElement || e.target;
			if(se.tagName.toLowerCase() == "body"){
				$(".Design_MecHandler_Curr .del_btn").trigger("click");
			}
		}
	}
	
	/*单击*/
	$(".Design_MecHandler").live("click", function(e){
		var mec_id = $(this).attr("id");
		triggerMECDesign(mec_id);
		$(document.body).unbind("keyup", triggerMecHandlerDel);
		$(document.body).one("keyup", triggerMecHandlerDel);
		document.body.focus();
		
		e.stopPropagation(); 
	});
	
	$(".Design_MecHandler_Curr").trigger("click");
	
	$(document.body).click(function(){
		$(document.body).unbind("keyup", triggerMecHandlerDel);
	});
}

function giveMecIndex(){
	$("#MEC_Design_Container .Design_MecHandler").each(function(i){
		$(this).attr("mec_index", i);
	});
}

function triggerMECDesign(mec_id){
	var $D_Mec = $("#"+mec_id);
	if(!$D_Mec.hasClass("Design_MecHandler_Curr")){
		$(".Design_MecHandler_Curr").removeClass("Design_MecHandler_Curr");
		$D_Mec.addClass("Design_MecHandler_Curr");
	}
	
	var $D_AttrDlg = $("#MAD_"+mec_id); 
	if($D_AttrDlg.length == 0){
		$D_AttrDlg = $("<div id=\"MAD_"+mec_id+"\" style=\"display:none;position: relative;\"></div>");
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var htm = mecHandler.getAttrDlgHtml();
		//htm = MLanguage.parse(htm);
		$D_AttrDlg.html(htm);
		$("#draggable_center").append($D_AttrDlg);
		
		$("#draggable_center").children().hide();
		$D_AttrDlg.show();
		$("#draggable").show();
			
		if(typeof(mecHandler.afterAttrDlgBuild) == "function"){
			mecHandler.afterAttrDlgBuild();
		}
	}else{
		if($D_AttrDlg.is(":hidden")){
			$("#draggable_center").children().hide();
			$D_AttrDlg.show();
		}
		$("#draggable").show();
	}
	//修改属性面板复制按钮的copy-content内容
	$("#draggable_title_copy").attr("copy-content", mec_id).html("(ID：" + mec_id + ")");
	var pluginConfig = getPluginConfigByMecid(mec_id);
	
	if(pluginConfig){
		$("#draggable_titlename").html(pluginConfig["text"]);
	}
}

function triggerPageAttrDesign(){
	$("#draggable_titlename").html(SystemEnv.getHtmlNoteName(4643));  //页面属性
	$("#draggable_center").children().hide();
	$("#pageAttr_setting_dlg").show();
	$("#draggable").show();
}

function initToMecDesign(){
	var $MEC_Design_Container = $("#MEC_Design_Container");
	if($MEC_Design_Container.length == 0){
		return;
	}
	
	var mecHandlerArr = new Array();
	
	var htm = $MEC_Design_Container.html();
	var currMec_id = "";
	var beginIndex = 0;
	var mecStart;
	while((mecStart = htm.indexOf("#mec{", beginIndex)) != -1){
		var mecEnd = htm.indexOf("}#",mecStart);
		if(mecEnd != -1){
			var mecInitHtm = htm.substring(mecStart, mecEnd + "}#".length);
			var mecInitContentHtm = htm.substring(mecStart + "#mec{".length, mecEnd);
			
			var mecInitJson = $.parseJSON("{"+mecInitContentHtm+"}");
			
			var initById = false;
			var mecHandler;
			var mec_id = mecInitJson["id"];
			if(mec_id && mec_id != ""){
				mecHandler = MECHandlerPool.getHandler(mec_id);
				initById = true;
			}else{
				var mec_type = mecInitJson["type"];
				var mecJson = mecInitJson["mecJson"];
				mecHandler = createMecHandler(mec_type, mecJson);
			}
			
			if(!mecHandler || mecHandler == -1){
				beginIndex = mecEnd;
				continue;
			}

			mec_id = mecHandler.getID();
			
			var designHtml = mecHandler.getDesignHtml();
			
			var $D_Mec = createMecDesignObj(mecHandler, designHtml);
	
			var mecDesignHtm;
			if(mecHandler.type == "TopButton"){
				$("#content_editor").prepend($D_Mec);
				mecDesignHtm = "";
			}else if(mecHandler.type == "WebClientHead"){
				$("#content_editor").prepend($D_Mec);
				mecDesignHtm = "";
			}else if(mecHandler.type == "EMobile50Head"){
				$("#content_editor").prepend($D_Mec);
				mecDesignHtm = "";
			}else{
				mecDesignHtm = $D_Mec.prop("outerHTML");
			}
			
			htm = $MEC_Design_Container.html();
			htm = htm.replace(mecInitHtm, mecDesignHtm);
			$MEC_Design_Container.html(MLanguage.parse(htm));
			
			if(!initById){
				triggerMECDesign(mec_id);
			}
			
			var isCurr = mecInitJson["isCurr"];
			if(isCurr == "true"){
				currMec_id = mec_id;
			}
			
			mecHandlerArr.push(mecHandler);
		}else{
			break;
		}
	}
	
	for(var i = 0; i < mecHandlerArr.length; i++){
		var mecHandler = mecHandlerArr[i];
		if(typeof(mecHandler.afterDesignHtmlBuild) == "function"){
			mecHandler.afterDesignHtmlBuild();
		}
	}
	
	if(currMec_id != ""){
		triggerMECDesign(currMec_id);
	}
}

function parseToMecDesign(){
	var $mecnodes = $("#MEC_Design_Container .mec_node");
	$mecnodes.each(function(){
		var $mnode = $(this);
		var mec_init = $mnode.attr("mec_init");
		if(mec_init == "false"){
			$mnode.attr("mec_init", "true");
			
			var mec_type = $mnode.attr("mec_type");
			
			function addMecDesignToPage(){
				
				var mecHandler = createMecHandler(mec_type);
				if(mecHandler == -1){
					$mnode.remove();
					return;
				}
				
				var mec_id = mecHandler.getID();
				var htm = mecHandler.getDesignHtml();
				
				var $D_Mec = createMecDesignObj(mecHandler, htm);
				
				if(mec_type == "TopButton"){
					$("#content_editor").prepend($D_Mec);
				}else if(mec_type == "WebClientHead"){
					$("#content_editor").prepend($D_Mec);
				}else if(mec_type == "EMobile50Head"){
					$("#content_editor").prepend($D_Mec);
				}else{
					if(mec_type == "Reply"){// 滚动条滚动到底部
						$(document).scrollTop($(window).height());
					}
					$D_Mec.insertAfter($mnode);
				}
				
				$mnode.remove();
				
				if(typeof(mecHandler.afterDesignHtmlBuild) == "function"){
					mecHandler.afterDesignHtmlBuild();
				}
				
				triggerMECDesign(mec_id);
				
				triggerEditorScroll();
				
				giveMecIndex();
				
				unexpandMEC();
				
				triggerLazyloadWithImg();
			}
			
			var isLoaded = ResourceLoader.isLoaded(mec_type);
			
			if(isLoaded){	//资源已加载
				addMecDesignToPage();
			}else{
				var $resourceLoading = $("<div class=\"mec_resource_loading\">"+SystemEnv.getHtmlNoteName(4990)+"</div>")//正在加载插件资源，请稍后...
				$resourceLoading.insertAfter($mnode);
				$mnode.remove();
				$mnode = $resourceLoading;
				ResourceLoader.loadResource(mec_type, function(){
					addMecDesignToPage();
				});
				
			}
		}
	});
}

function createMecHandler(mec_type, mecJson){
	var mecHandler;
	try{
		var constructor = eval("MEC_NS."+mec_type);
		if(typeof(constructor) != "function"){
			alert("未找到控件 "+mec_type+" 相应的处理程序");
			return;
		}
		if(typeof(mecJson) != "undefined" && mecJson != null && $.isPlainObject(mecJson)){
			mecHandler = eval("new MEC_NS."+mec_type+"(mec_type, null, mecJson)");
		}else{
			mecHandler = eval("new MEC_NS."+mec_type+"(mec_type)");
		}
	}catch(e){
		alert("初始化控件 "+mec_type+" 时出现异常:" + e.message);
		console.log(e);
		return -1;
	}
	
	var pluginConfig = getPluginConfigById(mec_type);
	var unique = pluginConfig["unique"];
	if(unique){
		var uniqueFlag = false;
		MECHandlerPool.eachHandler(function(eHandler){
			if(this.type == mec_type){
				uniqueFlag = true;
			}
		});
		if(uniqueFlag){
			alert(SystemEnv.getHtmlNoteName(4992));//该类控件在一个自定义页面中最多只能添加一个
			return -1;
		}
	}
	
	MECHandlerPool.addHandler(mecHandler);
	return mecHandler;
}

function createMecDesignObj(mecHandler, designHtml){
	var mec_id = mecHandler.id;
	var mec_type = mecHandler.type;
	var $D_Mec = $("<abbr id=\""+mec_id+"\" class=\"Design_MecHandler Design_MecHandler_"+mec_type+"\" m_type=\""+mec_type+"\" mec=\"true\"><div title=\""+SystemEnv.getHtmlNoteName(4989)+"\" class=\"copy_btn\"><span></span></div><div title=\""+SystemEnv.getHtmlNoteName(4988)+"\" class=\"del_btn\"></div></abbr>");//复制插件ID 删除插件
	$D_Mec.append(designHtml);
	buildZclip($(".copy_btn", $D_Mec));
	return $D_Mec;
}

function refreshMecDesign(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	mecHandler.getMecJson();	//获取Json，可以刷新插件内部的JSON数据
	
	var delBtnHtm = "<div title=\""+SystemEnv.getHtmlNoteName(4989)+"\" class=\"copy_btn\"><span></span></div><div title=\""+SystemEnv.getHtmlNoteName(4988)+"\" class=\"del_btn\"></div>";//复制插件ID 删除插件
	var designHtm = mecHandler.getDesignHtml();
	var htm = delBtnHtm + designHtm;
	htm = MLanguage.parse(htm);
	var $D_Mec = $("#"+mec_id);
	$D_Mec[0].innerHTML = htm;
	buildZclip($(".copy_btn", $D_Mec));
	if(typeof(mecHandler.afterDesignHtmlBuild) == "function"){
		mecHandler.afterDesignHtmlBuild();
	}
	
	triggerLazyloadWithImg();
	
	var $MAD_Alert = $("#MAD_"+mec_id+" .MAD_Alert");
	$MAD_Alert.css("top", $("#draggable_center").scrollTop() + "px");
	$MAD_Alert.fadeIn(1000, function(){
		$(this).fadeOut(2000);
	});
}

function deleteMecDesign(mec_id){
	$("#"+mec_id).remove();
	$("#MAD_"+mec_id).remove();
	showMADEmptyTip();
	MECHandlerPool.removeHandler(mec_id);
	
	triggerEditorScroll();
}

function showMADEmptyTip(){
	var allMADHide = true;
	$("#draggable_center").children().each(function(){
		if($(this).is(":visible")){
			allMADHide = false;
			return;
		}
	});
	if(allMADHide){
		$("#MAD_Empty_Tip").show();
	}
}

function initPluginConfig(async){
	if(pluginConfigArr != null){
		return;
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.plugin.PluginAction", "action=getAllPluginConfig");
	$.ajax({
	    url: url,
	    async: async,
	    type: 'get',
	    success: function (responseText) {
	    	var data = $.parseJSON(responseText);
			var status = data["status"];
			if(status == "1"){
				pluginConfigArr = data["data"];
			}
	    },
	    error: function(res){
	    }
	});
	
}

function getPluginConfigById(id){
	initPluginConfig(false);
	for(var i = 0; i < pluginConfigArr.length; i++){
		var pluginConfig = pluginConfigArr[i];
		if(pluginConfig["id"] == id){
			return pluginConfig;
		}
	}
}

function getPluginConfigByMecid(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	return getPluginConfigById(mecHandler.type);
}

function getPluginContentTemplateById(id, contentType){
	var contentTemplate;
	var pluginConfig = getPluginConfigById(id);
	if(contentType){
		if(contentType == "view"){
			contentTemplate = pluginConfig["viewContentTemplate"];
		}else if(contentType == "edit"){
			contentTemplate = pluginConfig["editContentTemplate"];
		}else{
			console.error("unknow contentType:" + contentType);
			contentTemplate = "";
		}
	}else{
		contentTemplate = pluginConfig["contentTemplate"];
	}
	return contentTemplate;
}

function Mec_FiexdUndefinedVal(v, defV){
	if(typeof(v) == "undefined" || v == null){
		if(defV){
			return defV;
		}else{
			return "";
		}
	}
	return v;
}

function Mec_IsInBottomContainer(mec_id){
	var result = false;
	$("#content_editor_bottom .Design_MecHandler").each(function(){
		if(this.id == mec_id){
			result = true;
			return false;
		}
	});
	return result;
}

function Mec_MoveContentFromEditorToBottom(mec_id){
	
	var $Design_MecHandler = $("#"+mec_id);
	var $content_editor_bottom = $("#content_editor_bottom");
	$content_editor_bottom.append($Design_MecHandler);
	$content_editor_bottom.show();
	
	var $homepageContainer = $("#homepageContainer");
	$homepageContainer.css("margin-bottom", $content_editor_bottom.height());
}

function Mec_MoveContentFromBottomToEditor(mec_id){
	var $Bottom_Design_MecHandler = $("#content_editor_bottom .Design_MecHandler");
	if($Bottom_Design_MecHandler.length > 0){
		
		$Bottom_Design_MecHandler.each(function(){
			var $Design_MecHandler = $(this);
			
			if(mec_id && $Design_MecHandler.attr("id") != mec_id){	
				return true;	//continue;
			}
			
			var mec_index = $Design_MecHandler.attr("mec_index");
			var $MEC_Design_Container = $("#MEC_Design_Container");
			var $nextMecHandler = null;
			$(".Design_MecHandler", $MEC_Design_Container).each(function(){
				var mec_index2 = $(this).attr("mec_index");
				if(mec_index <= mec_index2){	
					$nextMecHandler = $(this);
					return false;	//break
				}
			});
			if($nextMecHandler != null){
				$nextMecHandler.before($Design_MecHandler);
			}else{
				$MEC_Design_Container.append($Design_MecHandler);
			}
		});
		
		var $content_editor_bottom = $("#content_editor_bottom");
		var $homepageContainer = $("#homepageContainer");
		$homepageContainer.css("margin-bottom", $content_editor_bottom.height());
	}
}

function clearContainerHtml(id){
	var $container = $("#" + id);
	if($container.length > 0){
		var html = $container.html();
		while(html.indexOf("\n") != -1){
			html = html.replace("\n", "");
		}
		$container.html(html);
	}
}

function getSource(){
	Mec_MoveContentFromBottomToEditor();
	
	var $content_editor = $("#content_editor");
	var $MEC_Design_Container = $("#MEC_Design_Container");
	
	$("abbr[mec='true']", $content_editor).each(function(i){
		if($(this).parents("#MEC_Design_Container").length == 0){
			$MEC_Design_Container.prepend($(this));
		}
	});
	
	clearContainerHtml("MEC_Design_Container");
	var $mecObjs = $("abbr[mec='true']", $content_editor)
	$mecObjs.each(function(i){
		var id = this.id;
		var isCurrHtm = "";
		if($(this).hasClass("Design_MecHandler_Curr")){
			isCurrHtm = ",\"isCurr\":\"true\"";
		}
		var mecReplaceHtm = "\n	#mec{\"id\":\""+id+"\""+isCurrHtm+"}#";
		if(i == ($mecObjs.length - 1)){
			mecReplaceHtm += "\n";
		}
		$(this).before(mecReplaceHtm);
		$(this).remove();
	});
	
	clearContainerHtml("JSCode_Container");
	var $jscodeObjs = $("div[jscode='true']", $content_editor);
	$jscodeObjs.each(function(i){
		var id = $(this).attr("codeid");
		var jscodeReplaceHtm = "\n	#jscode{\"id\":\""+id+"\"}#";
		if(i == ($jscodeObjs.length - 1)){
			jscodeReplaceHtm += "\n";
		}
		$(this).before(jscodeReplaceHtm);
		$(this).remove();
	});
	
	var source = $content_editor.html();
	source = $.trim(source);
	return source;
}

function setSource(){
	var sourceFrame = document.getElementById("sourceFrame");
	var sourceFrameWin = sourceFrame.contentWindow;
	var code = sourceFrameWin.getCode();
	$("#content_editor").html(code);
	initToMecDesign();
	sortableMECDesignContainer();
}

var isSourceShow = false;
function Mec_Source(){
	if(!isSourceShow){
		disabledMecItem();
		var $sourceFrame = $("#sourceFrame");
		var height = $sourceFrame.height();
		var url = "/mobilemode/homepageSource.jsp?height="+height+"&"+ Date.parse(new Date());
		$sourceFrame.attr("src", url);
		
		$sourceFrame.show();
		$("#content").hide();
		$(".ruler_x").hide();
		triggerEditorScroll();
	}else{
		$("#sourceFrame").hide();
		$("#content").show();
		$(".ruler_x").show();
		setSource();
		enabledMecItem();
		triggerEditorScroll();
		initPicChangeByRightMenu();
	}
	isSourceShow = !isSourceShow;
}

function disabledMecItem(){
	$("#tabs-3 .mec_item, #mecExpandContainer .mec_item").addClass("mec_item_disabled");
}

function enabledMecItem(){
	$("#tabs-3 .mec_item, #mecExpandContainer .mec_item").removeClass("mec_item_disabled");
}

function triggerEditorScroll(){
	if($editorScroll){	//触发resize矫正滚动条
		$editorScroll.resize();
	}
}

function isEmptyDesignContainer(){
	var $MEC_Design_Container = $("#MEC_Design_Container");
	return $MEC_Design_Container.children().length == 0;
}

function initPicChangeByRightMenu(){
	var $img = $("img[changebyrightmenu='true']");
	if($img.length > 0){
		$img.contextMenu({
			menu: 'changePicRightMenu'
		}, function(action, el, pos) {
			if(action == "changePic"){		//更改图片
				
				var url = "/mobilemode/picset.jsp?pic_type=0&pic_path="+$(el).attr("src");
				
				var dlg = top.createTopDialog();//获取Dialog对象
				dlg.Model = true;
				dlg.Width = 331;//定义长度
				dlg.Height = 371;
				dlg.URL = url;
				dlg.Title = "更改图片";
				dlg.show();
				dlg.hookFn = function(result){
					var picPath = result["pic_path"];
					$(el).attr("src", picPath);
				};
			}
		});
	}
}

var expandMECFlag = true;
function expandMEC(){
	var $mec_split = $(".mec_split");
	var $mecExpandContainer = $("#mecExpandContainer");
	var $mec_item_expand = $("#mec_item_expand");
	if(expandMECFlag){
		$mec_split.addClass("mec_expand_split");
		$mecExpandContainer.slideDown(100, function(){
			$mec_item_expand.addClass("mec_item_expanded");
		});
	}else{
		$mecExpandContainer.slideUp(100, function(){
			$mec_split.removeClass("mec_expand_split");
			$mec_item_expand.removeClass("mec_item_expanded");
		});
	}
	expandMECFlag = !expandMECFlag;
}

function unexpandMEC(){
	expandMECFlag = false;
	expandMEC();
}

function getCommonNavItems(count){
	if(!count || count > common_mec_nav_items.length){
		count = common_mec_nav_items.length;
	}
	
	//通过转换生成新的数组对象，避免直接操作公共array的元素属性而影响插件之间的引用。
	var tmpStr = JSON.stringify(common_mec_nav_items);
	var tmpArr = $.parseJSON(tmpStr);
	
	return tmpArr.slice(0, count); 
}

function Mec_GetFormOptionHtml(){
	var htm="";
	MECHandlerPool.eachHandler(function(){
		if(this.type=="Form"){
			htm+="<option value=\""+this.id+"\">"+this.mecJson["formname"]+"</option>";
		}
	})
	return MLanguage.parse(htm);
}

function Mec_GetFieldOptionHtml(formid, fieldid, defval, hasEmptyOption){
	var mecHandler = MECHandlerPool.getHandler(formid);
	if(!mecHandler){
		return;
	}
	var datasource = mecHandler.mecJson["datasource"];
	var tablename = mecHandler.mecJson["tablename"];
	var formtype = mecHandler.mecJson["formtype"];
	formtype = (formtype == undefined ? "1" : formtype);
	var workflowid = mecHandler.mecJson["workflowid"];
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getFieldsByTable&dsName="+datasource+"&tbName="+tablename+"&formType="+formtype+"&workflowId="+workflowid);
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + timestamp;
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
					optionHtml+= "<option value=\"\"></option>";
				}
				var data = result.data;
				for(var i = 0; i < data.length; i++){
					var column_name = data[i]["column_name"];
					var column_label = data[i]["column_label"];
					optionHtml+= "<option value=\""+column_name+"\"";
					if(defval && column_name && column_name.toLowerCase()==defval.toLowerCase()){
						optionHtml+= " selected = \"selected\" ";
					}
					if(column_label&&column_label!=""){
						column_name = column_name + " ["+column_label+"]";
					}
					optionHtml+= ">"+column_name+"</option>";
				}
				var $fieldObj = $("#"+fieldid);
				$fieldObj.empty().append(MLanguage.parse(optionHtml));
			}
	 	},
	    error: function(){
	    }
	});
}


function Mec_GetWorkflowOptionHtml(formid, workflowid, defval, hasEmptyOption){
	var mecHandler = MECHandlerPool.getHandler(formid);
	if(!mecHandler){
		return;
	}
	var datasource = mecHandler.mecJson["datasource"];
	var tablename = mecHandler.mecJson["tablename"];
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getWorkflowsByTable&dsName="+datasource+"&tbName="+tablename);
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + timestamp;
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
					optionHtml+= "<option value=\"\"></option>";
				}
				var data = result.data;
				for(var i = 0; i < data.length; i++){
					var workflow_name = MLanguage.parse(data[i]["workflow_name"]);
					if(workflow_name.length > 20) workflow_name = workflow_name.substring(0, 20) + "...";
					var workflow_id = data[i]["workflow_id"];
					optionHtml+= "<option value=\""+workflow_id+"\"";
					if(workflow_id == defval){
						optionHtml+= " selected = \"selected\" ";
					}
					optionHtml+= ">"+workflow_name+"</option>";
				}
				var $fieldObj = $("#"+workflowid);
				$fieldObj.empty().append(optionHtml);
			}
	 	},
	    error: function(){
	    }
	});
}

function Mec_GetJSCodeOptionHtml(){
	var htm = "";
	htm += "<option value=\"\"></option>";
	htm += "<option value=\"refresh\">"+SystemEnv.getHtmlNoteName(3596)+"</option>";//刷新
	htm += "<option value=\"backToHomepage\">"+SystemEnv.getHtmlNoteName(4991)+"</option>";//回到首页
	return htm;
}

/* 设置延迟加载 */
function Mec_SetLazyLoad(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	if(mecHandler){
		mecHandler.mecJson["lazyLoad"]  = "1";
		$("#lazyLoad_"+mec_id).trigger("checked",true);
	}
}

function Mec_SetDraggableHeight(){
	var draggableHeight = $(window).height() - 370;
	if(draggableHeight > 340){
		$("#draggable_center").css("max-height", draggableHeight);
	}else{
		$("#draggable_center").css("max-height", 340);
	}
}

/**
 * 绑定复制插件ID事件，由于复制插件与排序插件和拖拽插件冲突，需相互切换
 * 
 * @param $obj 绑定复制事件的jquery对象
 * @param type 类型 1表示内容面板，2表示属性属性面板
 * @param content 复制内容
 * @author xxb
 */
var copy = false;
function buildZclip($obj, type){
	var $copyBtn = $obj;
	var $parent = $obj.parent();
	$copyBtn.hover(function(e){
		try{
			if(!copy){
				if(type !=undefined && type == 2){
					$( "#draggable" ).draggable("destroy");
				}else{
					$("#MEC_Design_Container").sortable("destroy");
				}
				$copyBtn.zclip({
					path : "/mobilemode/js/zclip/ZeroClipboard.swf",
					copy : function(){
						if(type !=undefined && type == 2){
							return $(this).attr("copy-content");
						}else{
							return $(this).parent().attr("id");
						}
					},
					afterCopy : function(){
						$("#copy_success_tip").fadeIn(1000, function(){
							$(this).fadeOut(2000);
						});
					}
				});
				if(type !=undefined && type == 2){
					$(".zclip", $parent).attr("title", SystemEnv.getHtmlNoteName(4696));//点击复制
				}else{
					$(".zclip", $parent).attr("title", SystemEnv.getHtmlNoteName(4989));//复制插件ID
					$($copyBtn).bind("click", function(e){
						e.stopPropagation();
					});
				}
				copy = true;
			}
		}catch(e){
			console.log(e.message);
		}
		e.stopPropagation();
	});
	$parent.on({
		"hover" : function(e){
			try{
				if(copy){
					if($(".zclip", $parent).length > 0){
						$copyBtn.zclip("remove");
					}
					if(type !=undefined && type == 2){
						$("#draggable").draggable({ containment: "#content",cursor:"move",handle:"#draggable_title"});
					}else{
						sortableMECDesignContainer();
					}				
					copy = false;
				}
			}catch(e){
				console.log(e.message);
			}
			e.stopPropagation();
		}
	});
}

function triggerLazyloadWithImg(){
	$("img.lazy[data-original]").each(function(){
		var original = $(this).attr("data-original");
		$(this).attr("src", original).removeAttr("data-original");
	});
}




