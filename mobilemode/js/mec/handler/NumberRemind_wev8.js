function NumberRemind(id, mecJson){
	this.id = id;
	if(!mecJson){
		mecJson = {};
	}
	this.mecJson = mecJson;
}

NumberRemind.prototype.generateID = function(){
	var id = new UUID().toString();
	this.id = id;
	return id;
};

NumberRemind.prototype.buildAttrDlg = function(){
	var theId = this.id;
	var $attrTable = $("#attrTable_"+theId);
	var $draggable_center = $("#draggable_center");
	
	if($attrTable.length == 0){
	
		var htm = "<table id=\"attrTable_"+theId+"\" class=\"e8_tblForm\" style=\"margin-top: -3px;\" style=\"display: none;\">"
			+ "<tr>"
				+ "<td class=\"e8_tblForm_label\" colspan=\"2\" style=\"padding-top: 0px;\">"
					+ "<div class=\"cbboxContainer\">"
						+ "<span class=\"cbboxEntry\">"
							+ "<input type=\"checkbox\" name=\"type_"+theId+"\" value=\"1\" onclick=\"changeSCT(this,'"+theId+"');\"/><span class=\"cbboxLabel\">sql</span>"
						+ "</span>"
						+ "<span class=\"cbboxEntry\">"
							+ "<input type=\"checkbox\" name=\"type_"+theId+"\" value=\"2\" onclick=\"changeSCT(this,'"+theId+"');\"/><span class=\"cbboxLabel\">java</span>"
						+ "</span>"
					+ "</div>"
				+ "</td>"
			+ "</tr>"
			+ "<tr>"
				+ "<td class=\"e8_tblForm_label\" width=\"50\">"
					+ "取值："
				+ "</td>"
				+ "<td class=\"e8_tblForm_field\" style=\"height:125px; vertical-align: top;\">"
					+ "<div id=\"valueDiv_1_"+theId+"\" class=\"valueContent_"+theId+"\">"
						+ "<textarea id=\"sql_"+theId+"\" name=\"sql_"+theId+"\" style=\"width:100%;height:80px;\"></textarea>"
						+ "<div class=\"e8_label_desc\">可使用变量<br/>{curruser}，{currdate}，{currdept}</div>"
					+ "</div>"
					+ "<div id=\"valueDiv_2_"+theId+"\" class=\"valueContent_"+theId+"\">"
						+ "<span class=\"codeEditFlag\" onclick=\"openCodeEdit(4, '"+theId+"');\" style=\"width: 130px; overflow: hidden; display: inline-block;text-overflow:ellipsis;\">"
							+ "<span id=\"javafilename_span_"+theId+"\"></span>"
						+ "</span>"
						+ "<input type=\"hidden\" id=\"javafilename_"+theId+"\" name=\"javafilename_"+theId+"\" value=\"\"/>"
					+ "</div>"
				+ "</td>"
			+ "</tr>"
		+ "</table>";
		$attrTable = $(htm);
		$draggable_center.append($attrTable);
		
		var type = fiexdUndefinedVal(this.mecJson["type"], "1");
		$("input[type='checkbox'][name='type_"+theId+"'][value='"+type+"']").attr("checked","checked");
		
		$("#sql_"+theId).val(fiexdUndefinedVal(this.mecJson["sql"]));
		
		$("#javafilename_span_"+theId).html(fiexdUndefinedVal(this.mecJson["javafilename"]));
		$("#javafilename_"+theId).val(fiexdUndefinedVal(this.mecJson["javafilename"]));
		
		$(".valueContent_"+theId).hide();
		$("#valueDiv_"+type+"_"+theId).show();
		
		$attrTable.jNice();
	}
	$draggable_center.children("table").hide();
	$attrTable.show();
	$("#draggable").show();
};

NumberRemind.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = "NumberRemind";
		
	var $attrTable = $("#attrTable_"+theId);
	if($attrTable.length > 0){
		this.mecJson["type"] = $("input[type='checkbox'][name='type_"+theId+"']:checked").val();
		this.mecJson["sql"] = $("#sql_"+theId).val();
		this.mecJson["javafilename"] = $("#javafilename_"+theId).val();
	}
	return this.mecJson;
};

function fiexdUndefinedVal(v, defV){
	if(typeof(v) == "undefined" || v == null){
		if(defV){
			return defV;
		}else{
			return "";
		}
	}
	return v;
}

function changeSCT(cbObj, mecId){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='type_"+mecId+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		$(".valueContent_"+mecId).hide();
		$("#valueDiv_"+objV+"_"+mecId).show();
	},100);
}

function openCodeEdit(type, mecId){
	top.openCodeEdit({
		"type" : type,
		"filename" : $("#javafilename_"+mecId).val()
	}, function(result){
		if(result){
			var fName = result["fileName"];
			$("#javafilename_span_"+mecId).html(fName);
			$("#javafilename_"+mecId).val(fName);
		}
	});
}