if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Tab = function(type, id, mecJson){
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
MEC_NS.Tab.prototype.getID = function(){
	return this.id;
};

MEC_NS.Tab.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Tab.prototype.getDesignHtml = function(){
	var theId = this.id;
	var tabMecMaps = this.mecJson["tabMecMaps"];
	if(!tabMecMaps){
		tabMecMaps = [];
	}
	//先把tab页内的abbr全部拿出来
	var $designContainer = $("#MEC_Design_Container");
	var $tabAbbr = $("#MEC_Design_Container abbr[id='"+theId+"']");
	var $tabAbbrs = $("abbr", $tabAbbr);
	$tabAbbrs.each(function(){
		if($(this).length>0){
			$designContainer.append($(this).clone());
			$(this).remove();
		}
	});
	//再根据配置把abbr添加到tab页的abbr中
	var $selectedTabLi = $("li.selected", $("#MADTab_"+theId));
	var htm = "<div class=\"tabContainer\" id=\"tabContainer"+theId+"\">"
				+ "<div class=\"tabTitle\">"
					+"<ul>";
					for(var i = 0; tabMecMaps && i < tabMecMaps.length; i++){
						htm += "<li ";
						if($selectedTabLi.length == 0){
							if(i == 0){
								htm += "class=\"selected\"";
							}
						}else{
							if($selectedTabLi.attr("detailid")==tabMecMaps[i]["tabID"]){
								htm += "class=\"selected\"";
							}
						}
						htm += " detailid=\""+tabMecMaps[i]["tabID"]+"\" href=\"#tabPage"+(i+1)+"\">"+tabMecMaps[i]["tabName"]+"</li>";
					}
			  htm += "</ul>"
			  	+ "</div>"
			  	+ "<div class=\"tabContent\">";		
				  	for(var i = 0; tabMecMaps && i < tabMecMaps.length; i++){
						htm += "<div class=\"tabPage";
						if($selectedTabLi.length == 0){
							if(i == 0){
								htm += " selected";
							}
						}else{
							if($selectedTabLi.attr("detailid")==tabMecMaps[i]["tabID"]){
								htm += " selected";
							}
						}
						htm += "\" detailID=\""+tabMecMaps[i]["tabID"]+"\" id=\"tabPage"+(i+1)+"\">";
						
						var mecHandlerIDs = tabMecMaps[i]["mecHandlerIDs"];
						for(var j = 0; j < mecHandlerIDs.length; j++){
							var m_id = mecHandlerIDs[j];
							var mecHandlerid = m_id["mecHandlerid"];
							var $movedAbbr = $("#MEC_Design_Container abbr[id='"+mecHandlerid+"']");
							if($movedAbbr.length == 0){
								var loseMecHandler = MECHandlerPool.getHandler(mecHandlerid);
								if(loseMecHandler){
									var html = loseMecHandler.getDesignHtml();
									$movedAbbr = createMecDesignObj(loseMecHandler, html);
								}
								
							}
							if($movedAbbr.length>0){
							    var $box = $('<div></div>');
							    for (var k = 0; k < $movedAbbr.length; k ++) {
							    	$box.append($($movedAbbr[k]).clone());
							    }
							    htm += $box.html();
								$movedAbbr.remove();
							}
						}
					htm += "</div>";
					}	
		htm += "</div>"					
		+ "</div>";
	return htm;
};

MEC_NS.Tab.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	$("#tabContainer"+theId+" > .tabTitle > ul > li").bind("click", function(){
		if(!$(this).hasClass("selected")){
			$(this).siblings("li.selected").removeClass("selected");
			$(this).addClass("selected");
			var tHref = $(this).attr("href");
			$(tHref).siblings(".tabPage.selected").removeClass("selected");
			$(tHref).addClass("selected");
			var detailid = $(this).attr("detailid");
			$("li.tabLi[detailid='"+detailid+"']").trigger("click");
		}
	});
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Tab.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	var htm = "<div id=\"MADTab_"+theId+"\" style=\"min-height: 170px;\">"
				+ "<div class=\"MADTab_Title\">"
					+ SystemEnv.getHtmlNoteName(4356)  //Tab页信息
					+ "<div class=\"tab_root_add\" onclick=\"MADTab_CreateTabCustomdetail('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4357)+"</div>"  //添加Tab
				+ "</div>"
				
				+ "<div class=\"MADTab_Customdetail\">"
					+ "<div class=\"MADTab_Customdetail_Title\"><ul class=\"MADTab_Customdetail_Name\"></ul></div>"
				+ "</div>"
				+ "<div class=\"MADTab_BaseInfo_Item\">"
					+ "<span class=\"MADTab_BaseInfo_Label\">"+SystemEnv.getHtmlNoteName(4129)+"</span>"  //延迟加载：
					+ "<input type=\"checkbox\" id=\"tabLazyLoad_"+theId+"\"/>"
				+ "</div>"
				+ "<div class=\"MADTab_Bottom\">"
					+ "<div class=\"MADTab_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4114)+"</div>"  //确&nbsp;定
				+ "</div>";
			+ "</div>"
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Tab.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var tabMecMaps = this.mecJson["tabMecMaps"];
	if(!tabMecMaps){
		tabMecMaps = [];
	}
	
	for(var i = 0; tabMecMaps && i < tabMecMaps.length; i++){
		MADTab_AddTabToPage(theId, tabMecMaps[i]);
		MADL_AddMecsToTab(theId, tabMecMaps[i]["tabID"], tabMecMaps[i]["mecHandlerIDs"]);
	}
	
	var $selectedTabLi = $("#tabContainer"+theId+" > .tabTitle > ul > li.selected");
	if($selectedTabLi.length > 0){
		var tabid = $selectedTabLi.attr("detailid");
		var $attrContainer = $("#MADTab_"+theId);
		var $MADTab_Customdetail_Name = $(".MADTab_Customdetail_Name", $attrContainer);
		$(".tabLi", $MADTab_Customdetail_Name).removeClass("selected");
		$(".tabLi[detailid='"+tabid+"']", $MADTab_Customdetail_Name).addClass("selected");
	}
	var lazyLoad = Mec_FiexdUndefinedVal(this.mecJson["tabLazyLoad"], "1");
	if(lazyLoad == "1"){
		$("#tabLazyLoad_"+theId).attr("checked","checked");
	}
	if(tabMecMaps.length == 0){
		MADTab_CreateTabCustomdetail(theId);
	}
	$("#MADTab_"+theId).jNice();
	
	MLanguage({
		container: $("#MADTab_"+theId)
    });
};

/*获取JSON*/
MEC_NS.Tab.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADTab_"+theId);
	if($attrContainer.length > 0){
		var tabMecMaps = [];
		
		var $tabLi = $(".MADTab_Customdetail_Name .tabLi", $attrContainer);
		$tabLi.each(function(){
			var tabID = $(this).attr("detailid");
			var tabName = Mec_FiexdUndefinedVal($(".MADTab_Text", $(this)).val());
			var tabNameML = MLanguage.getValue($(".MADTab_Text", $(this)));
			
			var mecHandlerIDs = [];
			var $mecLi = $(".MADTab_Customdetail_Content_Entry ul#Mecs_"+tabID+" li", $attrContainer);
			$mecLi.each(function(){
				var m = {};
				var mecid = $(this).attr("id").substring(4);//mec_11111.....
				m["mecHandlerid"] = mecid;
				mecHandlerIDs.push(m);
			});
			
			var t = {};
			t["tabID"] = tabID;
			t["tabName"] = tabNameML || tabName;
			t["mecHandlerIDs"] = mecHandlerIDs;
			
			tabMecMaps.push(t);
		});
		
		this.mecJson["tabMecMaps"] = tabMecMaps;
		this.mecJson["tabLazyLoad"] = $("#tabLazyLoad_"+theId).is(':checked') ? "1" : "0";
	}
	return this.mecJson;
};

MEC_NS.Tab.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["tabMecMaps"] = [];
	
	return defMecJson;
};

MEC_NS.Tab.prototype.onDelete = function(){
	
};

function MADL_FormatValue2Json(v){
	return v == "" ? {} : $.parseJSON(v);
}

function MADL_FormatJson2Value(jsonObj){
	return $.isEmptyObject(jsonObj) ? "" : JSON.stringify(jsonObj);
}

function MADTab_AddTabToPage(mec_id, result, slideTo){
	var $attrContainer = $("#MADTab_"+mec_id);
	var $MADTab_Customdetail = $(".MADTab_Customdetail", $attrContainer);
	var $MADTab_Customdetail_Name = $(".MADTab_Customdetail_Name", $MADTab_Customdetail);
	var $MADTab_Customdetail_Content = $(".MADTab_Customdetail_Content", $MADTab_Customdetail);
	if($MADTab_Customdetail_Content.length==0){
		$MADTab_Customdetail_Content = $("<div class=\"MADTab_Customdetail_Content\"></div>");
		$MADTab_Customdetail.append($MADTab_Customdetail_Content);
	}
	if($MADTab_Customdetail_Name.children().length < 3){
		$MADTab_Customdetail_Name.css("width","auto");
	}else{
		$MADTab_Customdetail_Name.css("width","100%");
	}
	$(".tabLi", $MADTab_Customdetail_Name).removeClass("selected");
	$MADTab_Customdetail_Name.append("<li class=\"tabLi selected\" detailid=\""+result["tabID"]+"\"><input id=\"tabName_"+result["tabID"]+"\" class=\"MADTab_Text\" onfocus=\"this.select();\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4358)+"\" value=\""+result["tabName"]+"\"/><div class=\"delFlag\" onclick=\"MADTab_DelTab('"+result["tabID"]+"','"+mec_id+"');\"></div></li>");  //输入名称
	
	$(".MADTab_Customdetail_Content_Entry", $MADTab_Customdetail_Content).removeClass("selected");
	var $Entry = $("<div class=\"MADTab_Customdetail_Content_Entry  selected\" detailid=\""+result["tabID"]+"\"></div>");
	$Entry.append("<input type=\"hidden\" name=\"detailid\" value=\""+result["tabID"]+"\" />");
	$Entry.append("<div class=\"label\">"+SystemEnv.getHtmlNoteName(4359)+"<div class=\"tabContent_root_add\">"+SystemEnv.getHtmlNoteName(4360)+"</div></div>");  //Tab页显示内容：    添加内容
	$Entry.append("<div id=\"tabMenus_"+result["tabID"]+"\" class=\"MADTab_menus\"><ul><li><a href=\"javascript:selectFromMECHandlerPool('"+result["tabID"]+"','"+mec_id+"');\">"+SystemEnv.getHtmlNoteName(4361)+"</a></li><li><a href=\"javascript:createNewMecToTab('"+result["tabID"]+"','"+mec_id+"');\">"+SystemEnv.getHtmlNoteName(4362)+"</a></li></ul></div>");  //从页面中选择    新建一个
	$MADTab_Customdetail_Content.append($Entry);
	
	$(".tabContent_root_add",$MADTab_Customdetail_Content).click(function(event){
		if(!$("#tabMenus_"+result["tabID"]).hasClass("selected")){
			$(this).addClass("selected");
			$("#tabMenus_"+result["tabID"]).addClass("selected");
			$("#tabMenus_"+result["tabID"]).show();
		}else{
			$(this).removeClass("selected");
			$("#tabMenus_"+result["tabID"]).removeClass("selected");
			$("#tabMenus_"+result["tabID"]).hide();
		}
		event.stopPropagation()
	});
	
	$("li",$MADTab_Customdetail_Name).click(function(){
		if(!$(this).hasClass("selected")){
			$(this).siblings(".selected").removeClass("selected");
			$(this).addClass("selected");
			var detailid = $(this).attr("detailid");
			var $Content = $(this).parent().parent().siblings(".MADTab_Customdetail_Content");
			$(".MADTab_Customdetail_Content_Entry", $Content).removeClass("selected");
			$(".MADTab_Customdetail_Content_Entry[detailid='"+detailid+"']", $Content).addClass("selected");
			
			$("#" + mec_id + " .tabTitle li[detailid='"+detailid+"']").trigger("click");
		}
	});
	
	$attrContainer.click(function(){
		 $(".MADTab_menus").each(function(){
			if($(this).hasClass("selected")){
				$(".MADTab_menus").removeClass("selected");
				$(".tabContent_root_add").removeClass("selected");
				$(".MADTab_menus").hide();
			}
		 });
	});
	
	MLanguage({
		container: $MADTab_Customdetail_Name
    });
}

function MADTab_CreateTabCustomdetail(mec_id){
	var result = {};
	var id = new UUID().toString();
	result["tabID"] = id;
	result["tabName"] = "";
	result["mecHandlerIDs"] = [];
	
	MADTab_AddTabToPage(mec_id,result,true);
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var tabMecMaps = mecHandler.mecJson["tabMecMaps"];
	if(!tabMecMaps){
		tabMecMaps = [];
		mecHandler.mecJson["tabMecMaps"] = tabMecMaps;
	}
	tabMecMaps.push(result);
}

function MADL_AddMecsToTab(mec_id, tabID, mecHandlerIDs){
	if(mecHandlerIDs.length>0){
		var $container = $("#MADTab_" + mec_id);
		var $currentTab = $(".MADTab_Customdetail_Content_Entry[detailid='"+tabID+"']", $container);
		var $Entry = $("#Mecs_"+tabID,$currentTab);
		var entryLength = $Entry.length;
		if($Entry.length==0){
			$Entry = $("<ul class=\"MADTab_Mecs\" id=\"Mecs_"+tabID+"\"></ul>");
		}
		for(var i = 0; i < mecHandlerIDs.length; i++){
			var m_id = mecHandlerIDs[i];
			var mecHandlerid = m_id["mecHandlerid"];
			var mecHandler = MECHandlerPool.getHandler(mecHandlerid);
			if(!mecHandler || mecHandler == -1){
				continue;
			}
			mecHandler.onDelete = function(){
				var oneid = this.getID();
				MADTab_DelTabMec(oneid, tabID, mec_id);
			};
			var mecType = mecHandler.type;
			var pluginConfig = getPluginConfigById(mecType);
			var mecText = pluginConfig["text"];
			$Entry.append("<li id=\"mec_"+mecHandlerid+"\"><div class=\"bemove\"></div><div class=\"mecTextName\">"+mecText+"</div><div class=\"mecIdName\">"+mecHandlerid+"</div><div class=\"mec_del\" onclick=\"MADTab_confirmDelTabMec('"+mecHandlerid+"','"+tabID+"','"+mec_id+"');\"></div></li>");
		}
		$currentTab.append($Entry);
		if(entryLength == 0){
			$Entry.sortable({
				revert: false,
				axis: "y",
				items: "li",
				handle: ".bemove"
			});
		}
	}
}

function MADL_AddMecsToTabMecJson(mec_id, tabID, mecHandlerIDs){
	$(".Design_MecHandler_Curr").removeClass("Design_MecHandler_Curr");
	var $currentTab = $("#" + mec_id);
	$currentTab.addClass("Design_MecHandler_Curr");
	$currentTab.trigger("click");
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var tabMecMaps = mecHandler.mecJson["tabMecMaps"];
	var flag = false;
	if(!tabMecMaps){
		tabMecMaps = [];
		mecHandler.mecJson["tabMecMaps"] = tabMecMaps;
	}
	for(var i = 0; tabMecMaps && i < tabMecMaps.length; i++){
		if(tabMecMaps[i]["tabID"] == tabID){
			tabMecMaps[i]["mecHandlerIDs"] = mecHandlerIDs;
			flag = true;
		}
	}
	if(!flag){
		var result = {};
		result["tabID"] = tabID;
		result["tabName"] = "";
		result["mecHandlerIDs"] = mecHandlerIDs;
		tabMecMaps.push(result);
	}
	MADL_AddMecsToTab(mec_id, tabID, mecHandlerIDs);
	refreshMecDesign(mec_id);
}

function selectFromMECHandlerPool(id,mec_id){
	$("#tabMenus_"+id).removeClass("selected");
	$(".tabContent_root_add").removeClass("selected");
	$("#tabMenus_"+id).hide();
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var tabMecMaps = mecHandler.mecJson["tabMecMaps"];
	if(!tabMecMaps){
		tabMecMaps = [];
	}
	var htm = "";
	MECHandlerPool.eachHandler(function(){
		if(this.id!=mec_id){
			var flag = false;
			for(var i = 0; tabMecMaps && i < tabMecMaps.length; i++){
				var mecHandlerIDs = tabMecMaps[i]["mecHandlerIDs"];
				for(var j = 0; j < mecHandlerIDs.length; j++){
					var mecHandlerid = mecHandlerIDs[j]["mecHandlerid"];
					if(this.id==mecHandlerid){
						flag = true;
						break;
					}
				}
				if(flag){
					break;
				}
			}
			if(!flag){
				htm+="<div class=\"mec_item\"><div class=\"mec_node\" id=\""+this.id+"\"><span>"+getPluginConfigById(this.type)["text"]+"</span></div></div>";
			}
		}
	})
	
	var mobileModelDlg = top.createTopDialog();//定义Dialog对象
	mobileModelDlg.Model = true;
	mobileModelDlg.Width = 460;//定义长度
	mobileModelDlg.Height = 230;
	mobileModelDlg.normalDialog = false;
	if(typeof(id)=="undefined"){
		return;
	}
	eval("top.MEC_Tab_BeChoose_Html_"+id+" = htm;");
	mobileModelDlg.URL = "/mobilemode/selectFromMECHandlerPool.jsp?id="+id;
	mobileModelDlg.Title = SystemEnv.getHtmlNoteName(4361);  //从页面中选择
	mobileModelDlg.show();
	mobileModelDlg.hookFn=function(result){
		var tabID = result["tabID"];
		var mecHandlerIDs = MADL_FormatValue2Json(result["mecHandlerIDs"]);
		if(mecHandlerIDs.length>0){
			MADL_AddMecsToTabMecJson(mec_id, tabID, mecHandlerIDs);
		}
	};
}

function createNewMecToTab(tabID,mec_id){
	$("#tabMenus_"+tabID).removeClass("selected");
	$(".tabContent_root_add").removeClass("selected");
	$("#tabMenus_"+tabID).hide();
	
	var mobileModelDlg = top.createTopDialog();//定义Dialog对象
	mobileModelDlg.Model = true;
	mobileModelDlg.Width = 480;//定义长度
	mobileModelDlg.Height = 300;
	mobileModelDlg.normalDialog = false;
	if(typeof(tabID)=="undefined"){
		return;
	}
	mobileModelDlg.URL = "/mobilemode/createNewMecToTab.jsp";
	mobileModelDlg.Title = SystemEnv.getHtmlNoteName(4363);  //为Tab新建内容
	mobileModelDlg.show();
	mobileModelDlg.hookFn=function(result){
		var mecTypes = MADL_FormatValue2Json(result["mecTypes"]);
		if(mecTypes.length>0){
			var mecHandlerIDs = [];
			var c = mecTypes.length;
			for(var i = 0; mecTypes && i < mecTypes.length; i++){
				var mec_type = mecTypes[i]["mec_type"];
				
				var callbackFn = function(){
					var _mec_type = this.mec_type;
					var mecHandler = createMecHandler(_mec_type);
					var mecid = mecHandler.getID();
					var mecHandlerid = {};
					mecHandlerid["mecHandlerid"] = mecid;
					mecHandlerIDs.push(mecHandlerid);
					var htm = mecHandler.getDesignHtml();
					var $D_Mec = createMecDesignObj(mecHandler, htm);
					//放到左边设计器里面
					/*if($(".tabPage[detailID='"+tabID+"']").length==0){*/
						$("#MEC_Design_Container").append($D_Mec);
					/*}else{
						$(".tabPage[detailID='"+tabID+"']").append($D_Mec);
					}*/
					
					$(".Design_MecHandler_Curr").removeClass("Design_MecHandler_Curr");
					$D_Mec.addClass("Design_MecHandler_Curr");
					$D_Mec.trigger("click");
					
					if(typeof(mecHandler.afterDesignHtmlBuild) == "function"){
						mecHandler.afterDesignHtmlBuild();
					}
					
					c--;
					if(c == 0){
						MADL_AddMecsToTabMecJson(mec_id, tabID, mecHandlerIDs);
					}
				};
				
				callbackFn.mec_type = mec_type;
				
				ResourceLoader.loadResource(mec_type, callbackFn);
				
			}
			
		}
	};
}

function MADTab_DelTab(tabID, mec_id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var tabMecMaps = mecHandler.mecJson["tabMecMaps"];
	var arrayObj = new Array();
	for(var i = 0; tabMecMaps && i < tabMecMaps.length; i++){
		if(tabMecMaps[i]["tabID"] == tabID){
			var mIDs = tabMecMaps[i]["mecHandlerIDs"];
			for(var m = 0; m < mIDs.length; m++){
				arrayObj.push(mIDs[m]["mecHandlerid"]);
			}
		}
	}
	
	for(var i = 0; arrayObj && i < arrayObj.length; i++){
		MADTab_DelTabMec(arrayObj[i],tabID,mec_id);
	}
	
	var index = -1;
	for(var i = 0; tabMecMaps && i < tabMecMaps.length; i++){
		if(tabMecMaps[i]["tabID"] == tabID){
			index = i;
			break;
		}
	}
	if(index != -1){
		tabMecMaps.splice(index, 1);
	}
	
	var $attrContainer = $("#MADTab_"+mec_id);
	$(".tabLi[detailid='"+tabID+"']", $attrContainer).remove();
	$(".MADTab_Customdetail_Content_Entry[detailid='"+tabID+"']", $attrContainer).remove();
	var $MADTab_Customdetail_Name = $(".MADTab_Customdetail_Name", "#MADTab_"+mec_id);
	if($MADTab_Customdetail_Name.children().length < 4){
		$MADTab_Customdetail_Name.css("width","auto");
	}else{
		$MADTab_Customdetail_Name.css("width","100%");
	}
	if($(".tabLi", $attrContainer).length>0){
		$(".tabLi", $attrContainer)[0].click();
	}
}

function MADTab_confirmDelTabMec(mecHandlerid,tabID,mec_id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	MADTab_DelTabMec(mecHandlerid,tabID,mec_id);
}

function MADTab_DelTabMec(mecHandlerid,tabID,mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var tabMecMaps = mecHandler.mecJson["tabMecMaps"];
	if(!tabMecMaps){
		tabMecMaps = [];
	}
	for(var i = 0; tabMecMaps && i < tabMecMaps.length; i++){
		if(tabMecMaps[i]["tabID"] == tabID){
			var mecHandlerIDs = tabMecMaps[i]["mecHandlerIDs"];
			var index = -1;
			for(var j = 0; j < mecHandlerIDs.length; j++){
				if(mecHandlerIDs[j]["mecHandlerid"] == mecHandlerid){
					var $movedAbbr = $("abbr#"+mecHandlerid, $("abbr#"+mec_id));
					var $MEC_Design_Container = $("#MEC_Design_Container");
					if($movedAbbr.length>0){
						$MEC_Design_Container.append($movedAbbr);
					}
					index = j;
					break;
				}
			}
			if(index != -1){
				mecHandlerIDs.splice(index, 1);
				var mecHandler = MECHandlerPool.getHandler(mecHandlerid);
				mecHandler.onDelete = null;
				break;
			}
		}
	}
	
	$("#mec_" + mecHandlerid).remove();
}

/*覆盖mec_wev8.js方法*/
function deleteMecDesign(mec_id){
	$("abbr", "#"+mec_id).each(function(){
		var innerId = $(this).attr("id");
		deleteMecDesign(innerId);
	});
	
	$("#"+mec_id).remove();
	$("#MAD_"+mec_id).remove();
	showMADEmptyTip();
	MECHandlerPool.removeHandler(mec_id);
	
	triggerEditorScroll();
}