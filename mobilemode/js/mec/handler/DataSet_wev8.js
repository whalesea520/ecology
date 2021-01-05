if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.DataSet = function(type, id, mecJson){
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
MEC_NS.DataSet.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.DataSet.prototype.getDesignHtml = function(){
	var theId = this.id;
	var name = Mec_FiexdUndefinedVal(this.mecJson["name"]);
	var htm = "<div class=\"DataSet-Tip\">"+SystemEnv.getHtmlNoteName(4374)+"-"+name+"</div>";  //数据集
	return htm;
};


/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.DataSet.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADDS_"+theId+"\">"
	htm += "<div class=\"MADDS_Title\">"+SystemEnv.getHtmlNoteName(4374)+"</div>";  //数据集
	htm += "<div class=\"MADDS_Content\">"
		 	   + "<div class=\"MADDS_BaseInfo_Entry\">"
					+ "<span class=\"MADDS_BaseInfo_Entry_Label MADDS_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4142)+"</span>"  //名称：
					+ "<span class=\"MADDS_BaseInfo_Entry_Content\">"
						+ "<input type=\"text\" id=\"name_"+theId+"\" class=\"MADDS_Text\" placeholder=\""+SystemEnv.getHtmlNoteName(4375)+"\"/>"  //一个英文的名称，如：shopData
					+ "</span>"
				+ "</div>" 
				
				+ "<div class=\"MADDS_BaseInfo_Entry\">"
					+ "<span class=\"MADDS_BaseInfo_Entry_Label MADDS_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4255)+"</span>"   //来源：
					+ "<span class=\"MADDS_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry\" style=\"width: 60px;\">"
							+ "<input type=\"checkbox\" name=\"sourceType_"+theId+"\" value=\"0\" onclick=\"MADDS_ChangeSourceType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4376)+"</span>"  //表单
						+ "</span>"
						+ "<span class=\"cbboxEntry\" style=\"width: 60px;\">"
							+ "<input type=\"checkbox\" name=\"sourceType_"+theId+"\" value=\"1\" onclick=\"MADDS_ChangeSourceType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">SQL</span>"
						+ "</span>"
						+ "<span class=\"cbboxEntry\" style=\"position: relative;width:120px;\">"
							+ "<input type=\"checkbox\" name=\"sourceType_"+theId+"\" value=\"2\" onclick=\"MADDS_ChangeSourceType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">Url</span>"
						+ "</span>"
					+ "</span>"
				+ "</div>" 
				
				+ "<div id=\"div_sourceType_"+theId+"_0\" class=\"div_sourceType\" style=\"display:none;\">"
				
					+ "<div class=\"MADDS_BaseInfo_Entry\">"
						+ "<span class=\"MADDS_BaseInfo_Entry_Label MADDS_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4377)+"</span>"  //表单：
						+ "<span class=\"MADDS_BaseInfo_Entry_Content\">"
							+ "<input id=\"tablename_"+theId+"\" class=\"MADDS_Text2\" type=\"text\" readonly=\"readonly\" style=\"\"/>"
							+ "<button type=\"button\" onclick=\"MADDS_openTableChoose('"+theId+"')\" class=\"MADDS_BrowserBtn\"></button>"
							+ "<input id=\"tableid_"+theId+"\" type=\"hidden\"/>"
						+ "</span>"
					+ "</div>" 
					+ "<div class=\"MADDS_BaseInfo_Entry\">"
						+ "<span class=\"MADDS_BaseInfo_Entry_Label MADDS_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4378)+"</span>"  //条件：
						+ "<span class=\"MADDS_BaseInfo_Entry_Content\">"
							+ "<input type=\"text\" id=\"tablecondition_"+theId+"\" class=\"MADDS_Text\" placeholder=\""+SystemEnv.getHtmlNoteName(4594)+"\"/>"  //查询条件,支持变量,如:id={id} and name={name}
						+ "</span>"
					+ "</div>" 
			
				+ "</div>"
				
				+ "<div id=\"div_sourceType_"+theId+"_1\" class=\"div_sourceType\" style=\"display:none;\">"
				
					+ "<div class=\"MADDS_BaseInfo_Entry\">"
						+ "<span class=\"MADDS_BaseInfo_Entry_Label MADDS_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
						+ "<span class=\"MADDS_BaseInfo_Entry_Content\">"
							+"<select class=\"MADDS_Select\" id=\"datasource_"+theId+"\">"
							+"  <option value=\"\">(local)</option>"
							+"</select>"
						+ "</span>"
					+ "</div>" 
				
					+ "<div class=\"MADDS_BaseInfo_Entry\">"
						+ "<textarea id=\"sql_"+theId+"\" class=\"MADDS_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4380)+"\"></textarea>"  //请在此处键入SQL
					+ "</div>" 
				
				+ "</div>"
				
				+ "<div id=\"div_sourceType_"+theId+"_2\" class=\"div_sourceType\" style=\"display:none;\">"
				
					+ "<div class=\"MADDS_BaseInfo_Entry\">"
						+ "<textarea id=\"url_"+theId+"\" class=\"MADDS_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4381)+"\"></textarea>"  //请在此处键入Url
					+ "</div>" 
				
				+ "</div>"
			+"</div>";
	htm += "<div class=\"MADDS_Bottom\"><div class=\"MADDS_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.DataSet.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	$("#name_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["name"]));
	$("#name_"+theId).blur(function(){
		var nameV = $(this).val();
		if(nameV != '' && !eval("/^[A-Za-z]+$/.test(\""+nameV+"\")")){
			alert(SystemEnv.getHtmlNoteName(4382));  //请输入英文名称，不包含中文、空格、数字等字符！s
			$(this).val("");
		}
	});
	
	var sourceTypeV = this.mecJson["sourceType"];
	var $sourceType = $("input[type='checkbox'][name='sourceType_"+theId+"'][value='"+sourceTypeV+"']");
	if($sourceType.length > 0){
		$sourceType.attr("checked", "checked");
		$sourceType.triggerHandler("click");
	}
	
	var datasource = Mec_FiexdUndefinedVal(this.mecJson["datasource"]);
	$("#datasource_"+theId).val(datasource);
	MADDS_setDataSourceHTML(theId, datasource);
	
	$("#sql_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["sql"]));
	$("#url_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["url"]));
	
	$("#tablename_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["tablename"]));
	$("#tableid_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["tableid"]));
	$("#tablecondition_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["sqlwhere"]));
	
	$("#MADDS_"+theId).jNice();
};

/*获取JSON*/
MEC_NS.DataSet.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MAD_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["name"] = $("#name_"+theId).val();
		this.mecJson["sourceType"] = $("input[type='checkbox'][name='sourceType_"+theId+"']:checked").val();
		this.mecJson["datasource"] = $("#datasource_"+theId).val();
		this.mecJson["sql"] = $("#sql_"+theId).val();
		this.mecJson["url"] = $("#url_"+theId).val();
		this.mecJson["tablename"] = $("#tablename_" + theId).val();
		this.mecJson["tableid"] = $("#tableid_" + theId).val();
		this.mecJson["sqlwhere"] = $("#tablecondition_" + theId).val();
	}
	return this.mecJson;
};

MEC_NS.DataSet.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["name"] = "";	//标题
	defMecJson["sourceType"] = "1";	//SQL
	defMecJson["datasource"] = "";	//单击类型
	defMecJson["sql"] = "";	//sql
	defMecJson["url"] = "";	//url
	
	return defMecJson;
};

function MADDS_ChangeSourceType(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='sourceType_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		$(".div_sourceType", "#MADDS_"+mec_id).hide();
		$("#div_sourceType_"+mec_id+"_" + objV).show();
		
	},100);
}

function MADDS_setDataSourceHTML(mec_id,val){
	var $MADFS_DataSource = $("#datasource_" + mec_id);
	var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=getDataSource");
	FormmodeUtil.doAjaxDataLoad(url, function(datas){
		for(var i = 0; i < datas.length; i++){
			var data = datas[i];
			var pointid = data;
			var selected = "";
			if (pointid=="" || typeof(pointid)=="undefined") continue;
			if (pointid == val) selected = "selected";
			var dataSourceSelectHtml = "<option value=\""+pointid+"\" "+selected+">";
			dataSourceSelectHtml += pointid;
			dataSourceSelectHtml += "</option>";
			$MADFS_DataSource.append(dataSourceSelectHtml);
		}
	});
}

function MADDS_openTableChoose(mec_id){
	var url = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 550;//定义长度
	dlg.Height = 650;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3418);  //请选择
	dlg.show();
	dlg.callback = function(result){
		var nameRegex = /<a[^>]*>([^<]*)(<div[^>]*>(.*)<\/div>)?<\/a>/;
		var id = result.id;
		var name = result.name;
		var nameMatches = nameRegex.exec(name);
		if(nameMatches != null){
			name = nameMatches[1];
			if(nameMatches[3] != undefined){
				name += nameMatches[3];
			}
		}
		$("#tableid_" + mec_id).val(id);
		$("#tablename_" + mec_id).val(name);
		dlg.close();
	};
}