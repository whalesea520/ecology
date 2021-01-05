if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Tree = function(type, id, mecJson){
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
MEC_NS.Tree.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Tree.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htm = "";
	var source = this.mecJson["source"];
	if(source == ""){
		htm = "<div class=\"Design_Tree_Tip\">"+SystemEnv.getHtmlNoteName(4253)+"</div>";  //树形信息设置不完整，未配置树形来源
	}else{
		var htmTemplate = getPluginContentTemplateById(this.type);
		htmTemplate = htmTemplate.replace("${theId}", theId);
		htm = htmTemplate;
	}
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Tree.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	var source = this.mecJson["source"];
	if(source != ""){
		Mobile_NS.whenTreepageAsyncCreate = function(){
			var $treeContainer = $("#tree" + theId);
			$(".nodename", $treeContainer).unbind("click");
			$(".toChild", $treeContainer).unbind("click");
		};
		Mobile_NS.buildTree(theId, source);
	}
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Tree.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADTREE_"+theId+"\" style=\"min-height: 170px;\">"
				+ "<div class=\"MADTREE_Title\">"+SystemEnv.getHtmlNoteName(4254)+"</div>"  //树形信息
				+ "<div class=\"MADTREE_BaseInfo\">"
					+ "<div>"
						+ SystemEnv.getHtmlNoteName(4256)+" "  //树形来源：
						+ "<select class=\"MADTREE_Select\" id=\"source_"+theId+"\" onchange=\"MADTree_CreateTreeCustomdetail('"+theId+"');\">"
						+ "</select>"
						
						+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
							+ "<INPUT id=\"sourceSearch_"+theId+"\" class=\"MADTREE_SourceSearch\" type=\"text\"/>"
							+ "<div id=\"sourceSearchTip_"+theId+"\" class=\"MADTREE_SourceSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
						+ "</span>"
					+ "</div>"
					+ "<div style=\"display:none;\">"
						+ SystemEnv.getHtmlNoteName(3977)+" "  //链接地址：
						+ "<input type=\"text\" id=\"url_"+theId+"\" class=\"MADTREE_Text\" style=\"width: 260px;\"/>"
					+ "</div>"
				+ "</div>"
				
				+ "<div id=\"sourceSearchResult_"+theId+"\" class=\"MADTREE_SourceSearchResult\">"
					+ "<ul></ul>"
				+ "</div>"
				
				+ "<div class=\"MADTREE_Customdetail\">"
				
				+ "</div>"
				
				+ "<div class=\"MADTREE_Bottom\">"
					+ "<div class=\"MADTREE_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4114)+"</div>"  //确&nbsp;定
				+ "</div>";
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局

	return htm;
};

var treeSourceData = null;

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Tree.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	if(treeSourceData == null){
		$.ajax({
		 	type: "POST",
		 	contentType: "application/json",
		 	url: encodeURI(jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getTreeSourceData")),
		 	async: false,
		 	data: "{}",
		 	success: function(responseText, textStatus) 
		 	{
		 		treeSourceData = $.parseJSON(responseText);
		 	}
		});
	}
	
	var $source = $("#source_" + theId);
	$source.append("<option value=\"\"></option>");
	for(var i = 0; i < treeSourceData.length; i++){
		var id = treeSourceData[i]["id"];
		var name = MLanguage.parse(treeSourceData[i]["treename"]);
		$source.append("<option value=\""+id+"\">"+name+"</option>");
	}
	
	$source.val(this.mecJson["source"]);
	$("#url_" + theId).val(this.mecJson["url"]);
	
	MADTree_InitSourceSearch(theId);
	
	MADTree_CreateTreeCustomdetail(theId);
};

function MADTree_CreateTreeCustomdetail(mec_id){
	var styleL = "_style" + _userLanguage;
	var tip = ""
	if(_userLanguage=="8"){
		tip = "Here to fill a need for the callback function name, such as listRefreshed, then refresh the list after the completion of, the system will call list page where listRefreshed, and will be on the tree node data in JSON form passed as a parameter to this method. To complete the list after the completion of the list of some of the post operation. If you do not need to be available here.";
	}else if(_userLanguage=="9"){
		tip = "在此處填寫需要回調的函數名稱，如listRefreshed，那麽在列表刷新完成後，系統會調用列表所在頁面的listRefreshed方法，并将被點擊的樹形節點的數據以json的形式作爲參數傳遞到此方法中。以用來完成列表刷新後的一些後置操作處理。如不需要此處至空即可。";
	}else{
		tip = "在此处填写需要回调的函数名称，如listRefreshed，那么在列表刷新完成后，系统会调用列表所在页面的listRefreshed方法，并将被点击的树形节点的数据以json的形式作为参数传递到此方法中。以用来完成列表刷新后的一些后置操作处理。如不需要此处至空即可。";
	}

	var $attrContainer = $("#MADTREE_"+mec_id);
	var $MADTREE_Customdetail = $(".MADTREE_Customdetail", $attrContainer);
	$MADTREE_Customdetail.find("*").remove();
	
	var source = $("#source_" + mec_id).val();
	if(source != ""){
		$.ajax({
		 	type: "POST",
		 	contentType: "application/json",
		 	url: encodeURI(jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getTreeCustomdetailData&treeid=" + source)),
		 	async: false,
		 	data: "{}",
		 	success: function(responseText, textStatus) 
		 	{
		 		var result = $.parseJSON(responseText);
		 		var status = result["status"];
		 		if(status == "-1"){
					alert(SystemEnv.getHtmlNoteName(4258));  //加载节点时出现异常
					return;
				}
		 		
		 		var data = result["data"];
		 		if(data.length == 0){
		 			return;
		 		}
		 		
		 		var $MADTREE_Customdetail_Name = $("<ul class=\"MADTREE_Customdetail_Name\"></ul>");
		 		for(var i = 0; i < data.length; i++){
		 			var id = data[i]["id"];
		 			var nodename = data[i]["nodename"];
		 			var c = (i == 0) ? "selected" : "";
		 			$MADTREE_Customdetail_Name.append("<li class=\""+c+"\" detailid=\""+id+"\">"+nodename+"</li>");
		 		}
		 		$MADTREE_Customdetail.append($MADTREE_Customdetail_Name);
		 		
		 		var mecHandler = MECHandlerPool.getHandler(mec_id);
		 		var _source = mecHandler.mecJson["source"];
		 		var _customdetail = mecHandler.mecJson["customdetail"];
		 		
		 		var $MADTREE_Customdetail_Content = $("<div class=\"MADTREE_Customdetail_Content\"></div>");
		 		$MADTREE_Customdetail.append($MADTREE_Customdetail_Content);
		 		
		 		for(var i = 0; i < data.length; i++){
		 			var id = data[i]["id"];
		 			var nodename = data[i]["nodename"];
		 			var c = (i == 0) ? "selected" : "";
		 			
		 			var appendhtml = "";
		 			var urltype = "";
		 			var inputurl = "";
		 			var pageid = "";
		 			var listid = "";
		 			var listparams = "";
		 			var callbackfn = "";
		 			if(_source == source){
		 				for(var j = 0; j < _customdetail.length; j++){
			 				if(_customdetail[j]["detailid"] == id){
			 					appendhtml = _customdetail[j]["appendhtml"];
			 					urltype = Mec_FiexdUndefinedVal(_customdetail[j]["urltype"]);
			 					inputurl = Mec_FiexdUndefinedVal(_customdetail[j]["inputurl"]);
			 					pageid = Mec_FiexdUndefinedVal(_customdetail[j]["pageid"]);
			 					listid = Mec_FiexdUndefinedVal(_customdetail[j]["listid"]);
			 					listparams = Mec_FiexdUndefinedVal(_customdetail[j]["listparams"]);
			 					callbackfn = Mec_FiexdUndefinedVal(_customdetail[j]["callbackfn"]);
			 					break;
			 				}
			 			}
		 			}
		 			
		 			var $Entry = $("<div class=\"MADTREE_Customdetail_Content_Entry "+c+"\" detailid=\""+id+"\"></div>");
		 			$Entry.append("<input type=\"hidden\" name=\"detailid\" value=\""+id+"\" />");
		 			$Entry.append("<div class=\"label\">"+SystemEnv.getHtmlNoteName(4259)+"</div>");  //节点附加Html：
		 			var $textarea = $("<textarea name=\"appendhtml\" rows=\"\" cols=\"\"></textarea>");
		 			$textarea[0].value = appendhtml;
		 			$Entry.append($textarea);
		 			
		 			$Entry.append("<div class=\"label\" style=\"margin-top: 5px;\">"+SystemEnv.getHtmlNoteName(4260)+"</div>");  //节点URL：
		 			$Entry.append("<div class=\"label\" style=\"margin-top: 5px;\">"
		 							+ "<span class=\"inputlabel inputlabel"+styleL+"\">"+SystemEnv.getHtmlNoteName(4185)+"</span>"  //类型：
			 						+ "<select name=\"urltype\" onchange=\"MADTree_UrltypeChange('"+mec_id+"','"+id+"')\">"
				 						+ "<option value=\"0\">"+SystemEnv.getHtmlNoteName(4146)+"</option>"  //自动解析
				 						+ "<option value=\"1\">"+SystemEnv.getHtmlNoteName(4147)+"</option>"  //手动输入
				 						+ "<option value=\"2\">"+SystemEnv.getHtmlNoteName(4261)+"</option>"  //动作：刷新列表
			 						+ "</select>"
		 						+ "</div>");
		 			
		 			$Entry.append("<div class=\"label urlcontent urlcontent1\" style=\"margin-top: 5px;\">"
		 							+ "<span class=\"inputlabel inputlabel"+styleL+"\">"+SystemEnv.getHtmlNoteName(4262)+"</span>"  //输入URL：
		 							+ "<span style=\"display: inline-block;\">"
		 							+ "<input type=\"text\" name=\"inputurl\" id=\"inputurl_"+mec_id+"_"+i+"\" style=\"box-sizing: border-box;height: 24px;\"/>"
		 							+ "</span>"
		 						+ "</div>");
		 			
		 			$Entry.append("<div class=\"label urlcontent urlcontent2\" style=\"margin-top: 5px;\">"
		 						 	+ "<div>"
			 							+ "<span class=\"inputlabel inputlabel"+styleL+"\">"+SystemEnv.getHtmlNoteName(4263)+"</span>"  //选择页面：
			 							+ "<select name=\"pageid\">"
					 						+ MADTree_getHomepageSelectOptionHtml()
				 						+ "</select>"
				 						+ "<span class=\"inputdesc inputdesc"+styleL+"\">"+SystemEnv.getHtmlNoteName(4264)+"</span>"  //选择需要刷新的列表所在页面
		 							+ "</div>"
		 							+ "<div style=\"margin-top: 5px;\">"
			 							+ "<span class=\"inputlabel inputlabel"+styleL+"\">"+SystemEnv.getHtmlNoteName(4265)+"</span>"  //列表id：
			 							+ "<input type=\"text\" name=\"listid\" placeholder=\""+SystemEnv.getHtmlNoteName(4266)+"\"/>"  //如果列表所在页面只包含一个列表，此项可至空
		 							+ "</div>"
		 							+ "<div style=\"margin-top: 5px;\">"
			 							+ "<span class=\"inputlabel inputlabel"+styleL+"\">"+SystemEnv.getHtmlNoteName(4267)+"</span>"  //传递参数：
			 							+ "<input type=\"text\" name=\"listparams\" placeholder=\""+SystemEnv.getHtmlNoteName(4268)+"\"/>"  //名称=值，如 creator={id} 多个参数用分号隔开
		 							+ "</div>"
		 							+ "<div style=\"margin-top: 5px;\">"
			 							+ "<span class=\"inputlabel inputlabel"+styleL+"\">"+SystemEnv.getHtmlNoteName(4269)+"</span>"  //回调函数：
			 							+ "<input type=\"text\" name=\"callbackfn\"/>"
			 							+ "<span class=\"inputdesc inputdesc"+styleL+"\">"+tip+"</span>"  //在此处填写需要回调的函数名称，如listRefreshed，那么在列表刷新完成后，系统会调用列表所在页面的listRefreshed方法，并将被点击的树形节点的数据以json的形式作为参数传递到此方法中。以用来完成列表刷新后的一些后置操作处理。如不需要此处至空即可。
		 							+ "</div>"
		 						+ "</div>");
		 			
		 			$MADTREE_Customdetail_Content.append($Entry);
		 			
		 			$("select[name='urltype']", $Entry).val(urltype);
		 			$("input[name='inputurl']", $Entry)[0].value = inputurl;
		 			$("select[name='pageid']", $Entry).val(pageid);
		 			$("input[name='listid']", $Entry)[0].value = listid;
		 			$("input[name='listparams']", $Entry)[0].value = listparams;
		 			$("input[name='callbackfn']", $Entry)[0].value = callbackfn;
		 			
		 			MADTree_UrltypeChange(mec_id, id);
		 			new URLSelector("inputurl_"+mec_id+"_"+i).init();
		 		}
		 		
		 		$("li",$MADTREE_Customdetail_Name).click(function(){
		 			if(!$(this).hasClass("selected")){
		 				$(this).siblings(".selected").removeClass("selected");
		 				$(this).addClass("selected");
		 				var detailid = $(this).attr("detailid");
		 				var $Content = $(this).parent().next(".MADTREE_Customdetail_Content");
		 				$(".MADTREE_Customdetail_Content_Entry", $Content).removeClass("selected");
		 				$(".MADTREE_Customdetail_Content_Entry[detailid='"+detailid+"']", $Content).addClass("selected");
		 			}
		 		});
		 	}
		});
	}
}

/*获取JSON*/
MEC_NS.Tree.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADTREE_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["source"] = $("#source_" + theId).val();
		this.mecJson["url"] = $("#url_" + theId).val();
		
		var customdetail = [];
		
		var $Entry = $(".MADTREE_Customdetail .MADTREE_Customdetail_Content_Entry", $attrContainer);
		$Entry.each(function(){
			var detailid = $("input[name='detailid']", $(this)).val();
			var appendhtml = $("textarea[name='appendhtml']", $(this)).val();
			var urltype = $("select[name='urltype']", $(this)).val();
 			var inputurl = $("input[name='inputurl']", $(this)).val();
 			var pageid = $("select[name='pageid']", $(this)).val();
 			var listid = $("input[name='listid']", $(this)).val();
 			var listparams = $("input[name='listparams']", $(this)).val();
 			var callbackfn = $("input[name='callbackfn']", $(this)).val();
 			
			var d = {};
			d["detailid"] = detailid;
			d["appendhtml"] = appendhtml;
			d["urltype"] = urltype;
			d["inputurl"] = inputurl;
			d["pageid"] = pageid;
			d["listid"] = listid;
			d["listparams"] = listparams;
			d["callbackfn"] = callbackfn;
			
			customdetail.push(d);
		});
		
		this.mecJson["customdetail"] = customdetail;
	}
	return this.mecJson;
};

MEC_NS.Tree.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["source"] = "";	//树形来源
	defMecJson["url"] = "";	//链接地址
	
	defMecJson["customdetail"] = [];
	
	return defMecJson;
};

function MADTree_InitSourceSearch(mec_id){
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
				
				var $vtableName = $("#source_"  + mec_id);
				$vtableName.find("option").each(function(){
					var vt = $(this).text();
					var vv = $(this).attr("value");
					if(vt.toLowerCase().indexOf(searchValue) != -1){
						resultHtml += "<li><a href=\"javascript:MADTree_SetSourceSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADTREE_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADTree_SetSourceSelected(mec_id, v){
	var $source = $("#source_" + mec_id);
	$source.val(v);
	$source.trigger("change", [mec_id]);
	
	preSearchText = "";
	var $searchText = $("#sourceSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	
}

function MADTree_getHomepageSelectOptionHtml(){
	var htm = "";
	for(var i = 0; i < common_homepage_items.length; i++){
		var id = common_homepage_items[i]["id"];
		var uiname = common_homepage_items[i]["uiname"];
		htm += "<option value=\""+id+"\">"+uiname+"</option>";
	}
	return htm;
}

function MADTree_UrltypeChange(mec_id, detailid){
	var $Entry = $("#MADTREE_"+mec_id+" .MADTREE_Customdetail_Content_Entry[detailid='"+detailid+"']");
	
	var urltype = $("select[name='urltype']", $Entry).val();
	if(urltype == "0"){
		$(".urlcontent", $Entry).hide();
	}else if(urltype == "1"){
		$(".urlcontent2", $Entry).hide();
		$(".urlcontent1", $Entry).show();
	}else if(urltype == "2"){
		$(".urlcontent1", $Entry).hide();
		$(".urlcontent2", $Entry).show();
	}
}