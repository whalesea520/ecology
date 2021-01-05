if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.SegControl = function(type, id, mecJson){
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
MEC_NS.SegControl.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.SegControl.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var htmTemplate = getPluginContentTemplateById(this.type);
	var forTemplate = "";
	var forContentTemplate = "";
	var forStart = htmTemplate.indexOf("$mec_segcontrol_forstart$");
	var forEnd = htmTemplate.indexOf("$mec_segcontrol_forend$", forStart);
	if(forStart != -1 && forEnd != -1){
		forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_segcontrol_forend$".length);
		forContentTemplate = htmTemplate.substring(forStart + "$mec_segcontrol_forstart$".length, forEnd);
	}
	var forHtml = "";
	var btn_datas = this.mecJson["btn_datas"];
	for(var i = 0; i < btn_datas.length; i++){
		var activeClass = (i == 0) ? " active" : "";
		var segId = btn_datas[i]["segId"];
		var segName = btn_datas[i]["segName"];
		if(!segName || segName==""){
			segName = "&nbsp;";
		}else{
			segName = segName.replace(/</g, "&lt;").replace(/>/g, "&gt;");
		}
		var isremind = btn_datas[i]["isremind"];
		var reminddisplay = isremind == "1" ? "inline" : "none";
		var remindnum = "N";
		var remindclass = "MEC_NumberRemind1";
		forHtml += forContentTemplate.replace("${activeClass}", activeClass)
							.replace("${segId}", segId)
							.replace("${segName}", segName)
							.replace("${reminddisplay}", reminddisplay)
							.replace("${remindnum}", remindnum)
							.replace("${remindclass}", remindclass);
	}
	var htm = htmTemplate.replace(forTemplate, forHtml).replace("${theId}", theId);
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.SegControl.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADSegControl_"+theId+"\">"
	htm += "<div id=\"MADSegControl_Btn_"+theId+"\" class=\"SegControl_Btn_Container\">";
	htm += "<div class=\"btnTitle\">";
	htm += SystemEnv.getHtmlNoteName(4396);  //分段插件
	htm += "<div class=\"btnAdd\" onclick=\"SegControl_AddBtn('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>";  //添加
	htm += "</div>";
	htm += "<ul></ul>";
	htm += "</div>";
	htm += "<div class=\"MADSeg_Bottom\"><div class=\"MADSeg_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	htm += "<div class=\"MAD_Warn\" style=\"display: none;\">"+SystemEnv.getHtmlNoteName(4397)+"</div>";  //按钮配置项不得少于1个
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.SegControl.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var btn_datas = this.mecJson["btn_datas"];
	for(var i = 0; i < btn_datas.length; i++){
		SegControl_AddBtnToPage(theId, btn_datas[i]);
	}
	
	$("#MADSegControl_"+theId).jNice();
	$("#MADSegControl_Btn_"+theId + " > ul").sortable({
		revert: false,
		axis: "y",
		items: "li",
		handle: ".bemove"
	});
};

/*获取JSON*/
MEC_NS.SegControl.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MAD_"+theId);
	if($attrContainer.length > 0){
		
		var btn_datas = [];
		
		var $li = $(".SegControl_Btn_Container > ul > li", $attrContainer);
		$li.each(function(){
			var liId = $(this).attr("id");
			if(liId && liId != ""){
				var btnId = liId.substring("li_".length);
				var segName =  MLanguage.getValue($("input[name='segName']", $(this)))||$("input[name='segName']", $(this)).val();
				var segScript = $("input[name='segScript']", $(this)).val();
				
				var btn_item = {};
				btn_item["segId"] = btnId;
				btn_item["segName"] = segName;
				btn_item["segScript"] = segScript;
				
				btn_item["isremind"] = $("input[name='isremind']", $(this)).is(':checked') ? "1" : "0";
				btn_item["remindtype"] = $("input[name='remindtype']", $(this)).val();
				btn_item["remindsql"] = $("input[name='remindsql']", $(this)).val();
				btn_item["reminddatasource"] = $("input[name='reminddatasource']", $(this)).val();
				btn_item["remindjavafilename"] = $("input[name='remindjavafilename']", $(this)).val();
				
				btn_datas.push(btn_item);
			}
		});
		
		this.mecJson["btn_datas"] = btn_datas;
		
	}
	return this.mecJson;
};

MEC_NS.SegControl.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	var btn_datas = [];
	var btn_data = {};
	btn_data["segId"] = new UUID().toString();
	btn_data["segName"] = "";// 按钮名称
	btn_data["segScript"] = "";// 执行脚本
	btn_datas.push(btn_data);
	
	defMecJson["btn_datas"] = btn_datas;
	
	return defMecJson;
};

function SegControl_AddBtn(mec_id){
	
	var btn_data = {};
	btn_data["segId"] = new UUID().toString();
	btn_data["segName"] = "";
	btn_data["segScript"] = "";
	
	SegControl_AddBtnToPage(mec_id, btn_data);
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var btn_datas = mecHandler.mecJson["btn_datas"];
	btn_datas.push(btn_data);
	
}

function SegControl_AddBtnToPage(mec_id, btn_data){
	
	var $btnContainer = $("#MADSegControl_Btn_"+mec_id);
	
	var $ul = $("ul", $btnContainer);
	var $li = $("<li id=\"li_"+btn_data["segId"]+"\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    		htm += "<td class=\"bemove\" width=\"7%\"></td>";
			    htm += "<td width=\"100px\" valign=\"middle\">";
			    	htm += "<input name=\"segName\" type=\"text\" class=\"SegControl_Text\" style=\"height:22px;line-height:22px;\" value=\"\" placeholder=\""+SystemEnv.getHtmlNoteName(4177)+"\" data-multi=false/>";  //按钮名称
			    htm += "</td>";
			    
			    htm += "<td width=\"100px\">";
					htm += "<div class=\"segbtn_click_desc\">";
						htm += "<input name=\"segScript\" type=\"hidden\" value=\"\"/>";
						htm += SystemEnv.getHtmlNoteName(4178);  //单击事件
					htm += "</div>";
				htm += "</td>";
				
				htm += "<td width=\"66px\" style=\"position: relative;\">";
					htm += SystemEnv.getHtmlNoteName(3621) + "：<input name=\"isremind\" type=\"checkbox\" value=\"1\" onclick=\"SegControl_IsremindChange(this);\"/>" ;
					htm += "<input type=\"hidden\" name=\"remindtype\"/>"
					htm += "<input type=\"hidden\" name=\"remindsql\"/>"
					htm += "<input type=\"hidden\" name=\"reminddatasource\"/>"
					htm += "<input type=\"hidden\" name=\"remindjavafilename\"/>"
					htm += "<div class=\"numremindEditFlag\" onclick=\"SegControl_NumremindEdit(this);\"></div>"
				htm += "</td>";
				
				htm += "<td align=\"right\">";
					htm += "<span class=\"segbtn_del\" onclick=\"SegControl_deleteOneBtnOnPage('"+mec_id+"','"+btn_data["segId"]+"');\"></span>";
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
	$("input[name='segName']", $li)[0].value = btn_data["segName"];
	$("input[name='segScript']", $li)[0].value = btn_data["segScript"];
	
	var isremind = Mec_FiexdUndefinedVal(btn_data["isremind"]);
	if(isremind == "1"){
		var $isremind = $("input[name='isremind']", $li);
		$isremind.attr("checked","checked");
		SegControl_IsremindChange($isremind[0]);
	}
	$("input[name='remindtype']", $li).val(Mec_FiexdUndefinedVal(btn_data["remindtype"]));
	$("input[name='remindsql']", $li).val(Mec_FiexdUndefinedVal(btn_data["remindsql"]));
	$("input[name='reminddatasource']", $li).val(Mec_FiexdUndefinedVal(btn_data["reminddatasource"]));
	$("input[name='remindjavafilename']", $li).val(Mec_FiexdUndefinedVal(btn_data["remindjavafilename"]));
	
	$(".segbtn_click_desc", $li).click(function(){
		var $this = $(this);
		var $segScript = $("input[name='segScript']", $this);
		SL_AddScriptToField($segScript);
	});
	
	$li.jNice();
	MLanguage({
		container: $li
    });
}

function SegControl_IsremindChange(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $numremindEditFlag = $(cbObj).closest("td").find(".numremindEditFlag");
		if(cbObj.checked){
			$numremindEditFlag.show();
		}else{
			$numremindEditFlag.hide();
		}
	},100);
}

function SegControl_NumremindEdit(obj){
	var $remindtype = $(obj).siblings("input[name='remindtype']");
	var $remindsql = $(obj).siblings("input[name='remindsql']");
	var $reminddatasource = $(obj).siblings("input[name='reminddatasource']");
	var $remindjavafilename = $(obj).siblings("input[name='remindjavafilename']");
	
	var remindtypeV = $remindtype.val();
	
	var remindsqlV = $remindsql.val();
	remindsqlV = $m_encrypt(remindsqlV);// 系统安全编码
	
	var reminddatasourceV = $reminddatasource.val();
	var remindjavafilenameV = $remindjavafilename.val();
	
	var url = "/mobilemode/numremind.jsp?remindtype="+remindtypeV+"&remindsql="+remindsqlV+"&reminddatasource="+reminddatasourceV+"&remindjavafilename="+remindjavafilenameV;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 500;//定义长度
	dlg.normalDialog = false;
	dlg.Height = 255;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4116);  //数字提醒
	dlg.show();
	dlg.hookFn = function(result){
		$remindtype.val(result["remindtype"]);
		$remindsql.val(result["remindsql"]);
		$reminddatasource.val(result["reminddatasource"]);
		$remindjavafilename.val(result["remindjavafilename"]);
	};
}

function SegControl_deleteOneBtnOnPage(mec_id, segId){
	
	var $btnContainer = $("#MADSegControl_Btn_"+mec_id);
	
	var $li = $("li", $btnContainer);
	if($li.length <= 1){
		$("#MAD_"+mec_id+" .MAD_Warn").fadeIn(1000, function(){
			$(this).fadeOut(2000);
		});
		return;
	}
	
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var btn_datas = mecHandler.mecJson["btn_datas"];
	
	var index = -1;
	for(var i = 0; i < btn_datas.length; i++){
		var data = btn_datas[i];
		if(data["segId"] == segId){
			index = i;
			break;
		}
	}
	if(index != -1){
		btn_datas.splice(index, 1);
	}
	
	$("#li_" + segId).remove();
	
}
