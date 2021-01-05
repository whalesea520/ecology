Mobile_NS.DetailTable = {};

Mobile_NS.DetailTable.onload = function(p){
	var theId = p["id"];
	var tablename = p["tablename"];
	this.initUI(theId);
	this.initDataEvent(p);
};

Mobile_NS.DetailTable.initUI = function(mec_id){
	var that = this,
		contentTdWidthArr = [],
		$container = $("#detailtable"+mec_id);
	//获取第一行数据的每列列宽
	var $firstContentRow = $("table.DetailTable_Content>tbody>tr.dt_content_tr", $container).first();
	$firstContentRow.children("td").each(function(){
		var w = $(this).width();
		contentTdWidthArr.push(w);
	});
	
	var $firstTitleRow = $("table.DetailTable_Title>tbody>tr.dt_title_tr", $container).first();
	//比较标题列宽是否等于数据列宽，如果不等于则重新计算标题列宽
	$firstTitleRow.children("td").each(function(i){
		var $td = $(this);
		var w = contentTdWidthArr[i];
		if(w == null || typeof(w) == "undefined"){
			return;
		}
		var w2 = $td.width();
		if(w != w2){
			var p = that.getHorizontalPadding($td);	//padding
			var nw2 = w - p;
			$td.css("width", nw2 + "px");
		}
	});
	var cWidth = $(".DetailTable_Title", $container).width();
	$(".DetailTable_ContentWrap", $container).width(cWidth);
};

Mobile_NS.DetailTable.initDataEvent = function(mecJson){
	var multiLJson = mecJson["multiLJson"];
	var mec_id = mecJson["id"];
	var tablename = mecJson["tablename"];
	var $detailTableContainer = $("#detailtable"+mec_id);
	//明细表删除按钮点击事件
	$("#deletebtn"+mec_id).bind("click", function(){
		var $contentTr = $(".dt_content_tr", $detailTableContainer);
		if($contentTr.length > 0){
			var $checkedTr = $(".dt_content_tr.checked", $detailTableContainer);
			if($checkedTr.length > 0){
				Mobile_NS.Confirm(multiLJson['383780'], multiLJson['383781'], [multiLJson['16631'],function(){//确定删除选定数据?  确认操作   确认
					$delidsDom = $("input[name='"+tablename+"_delids']", $detailTableContainer);
					var delids = $delidsDom.val();
					$checkedTr.each(function(){
						var delid = $("input[name='detaildatacheckbox']", $(this)).val();
						if(delid){
							delids += (delids ? ","+delid : delid);
						}
					});
					$delidsDom.val(delids);
					$checkedTr.remove();
					$(".rowindex"+mec_id).each(function(index){
						$(this).text(index+1);
					});
					$detailTableContainer.trigger("detailtableDomChanged");
		    	}],[multiLJson['32694'], function(){//取消

		    	}]);
			}else{
				Mobile_NS.Alert(multiLJson['24244']);//请先选择需要删除的数据
			}
		}else{
			Mobile_NS.Alert(multiLJson['383782']);//无数据可删除
		}
	});
	//添加按钮点击事件
	var $addPanel = $("#detailtableadd"+mec_id);
	var $addMask = $(".Design_DetailTable_AddDataMask", $addPanel);
	$("#addbtn"+mec_id).bind("click", function(){
		Mobile_NS.DetailTable.showAddDataPanel(mec_id, true);
	});
	$addMask.bind("click", function(){
		Mobile_NS.DetailTable.hideAddDataPanel(mec_id);
	});
	$(".detailtable_adddata_cancel_btn", $addPanel).bind("click", function(){
		Mobile_NS.DetailTable.hideAddDataPanel(mec_id);
	});
	$(".detailtable_adddata_ok_btn", $addPanel).bind("click", function(){
		var $form = $("#detailtableform"+mec_id);
		var errorMsg = Mobile_NS.Form.checkRequired($form);//验证必填项
		if(errorMsg != ""){
			Mobile_NS.Form.showMsg($form, errorMsg, "Form_Msg_Err");
			return;
		}
		Mobile_NS.DetailTable.addRowToPage(mecJson);
		Mobile_NS.DetailTable.hideAddDataPanel(mec_id);
		$detailTableContainer.trigger("detailtableDomChanged");
	});
};
Mobile_NS.DetailTable.showAddDataPanel = function(mec_id, isAdd){
	var $addPanel = $("#detailtableadd"+mec_id);
	var $addMask = $(".Design_DetailTable_AddDataMask", $addPanel);
	var $addContent = $(".Design_DetailTable_AddDataContent", $addPanel);
	$addPanel.show();
	$addMask.addClass("show");
	setTimeout(function(){
		$addContent.removeClass("hide");
	},20);
	//图片显示
	var $form = $("#detailtableform"+mec_id);
	$("img.lazy", $form).each(function(){
		var $img = $(this);
		var src = $img.attr("src");
		var originalSrc = $img.attr("data-original");
		if(originalSrc && src != originalSrc){
			$img.attr("src", originalSrc);
		}
	});
	//添加明细时触发字段联动,选择框联动
	if(isAdd){
		$("[onchange^='changeChildField']", $form).each(function(){
			$(this).trigger("change");
		});
		$("[onchange^='Mobile_NS.readyToTrigger'],[oninput^='Mobile_NS.readyToTrigger']", $form).each(function(){
			var that = $(this);
			if(that.val()){
				if(that.attr("onchange")){
					$(this).trigger("change");
				}
				if(that.attr("oninput")){
					$(this).trigger("input");
				}
			}
		});
	}
};
Mobile_NS.DetailTable.hideAddDataPanel = function(mec_id){
	var $addPanel = $("#detailtableadd"+mec_id);
	var $addMask = $(".Design_DetailTable_AddDataMask", $addPanel);
	var $addContent = $(".Design_DetailTable_AddDataContent", $addPanel);
	$("#detailbillid"+mec_id).val("");
	$("#detailcurrrowindex"+mec_id).val("");
	$addPanel.hide();
	$addContent.addClass("hide");
	Mobile_NS.initAddTablePanelUI(mec_id);
};
Mobile_NS.initAddTablePanelUI = function(mec_id){
	Mobile_NS.Form.reset("detailtableform"+mec_id);
};
Mobile_NS.DetailTable.addRowToPage = function(mecJson){
	var buildFieldHtmlFactory = {
		buildFInputTextHtml : function($form, mec_id, fieldname, tablename, rowindex){
			var value = $("input[name='fieldname_"+fieldname+"']", $form).val();
			var template = "<input type=\"hidden\" name=\""+tablename+"_"+fieldname+"_rowindex_"+rowindex+"\" id=\""+mec_id+"_"+rowindex+"\" value=\""+value+"\" data-role=\"none\" />";
			template += "<span id=\""+mec_id+"_span_"+rowindex+"\" showname=\""+value+"\">"+value+"</span>";
			return template;
		},
		buildFTextareaHtml : function($form, mec_id, fieldname, tablename, rowindex){
			var value = $("[name='fieldname_"+fieldname+"']", $form).val();
			var template = "<input type=\"hidden\" name=\""+tablename+"_"+fieldname+"_rowindex_"+rowindex+"\" id=\""+mec_id+"_"+ rowindex+"\" value=\""+value+"\" data-role=\"none\"/>";
			template += "<span id=\""+mec_id+"_span_"+rowindex+"\" showname=\""+value+"\">"+value+"</span>";
			template += "<input type=\"hidden\" name=\"type_"+tablename+"_"+fieldname+"_"+rowindex+"\" value=\"textarea\" />";
			return template;
		},
		buildFHiddenHtml : function($form, mec_id, fieldname, tablename, rowindex){
			var value = $("[name='fieldname_"+fieldname+"']", $form).val();
			var template = "<input type=\"hidden\" name=\""+tablename+"_"+fieldname+"_rowindex_"+rowindex+"\" id=\""+mec_id+"_"+rowindex+"\" value=\""+value+"\" data-role=\"none\"/>";
			return template;
		},
		buildFSelectHtml : function($form, mec_id, fieldname, tablename, rowindex){
			var value = $("[name='fieldname_"+fieldname+"']", $form).val();
			var showname = $("select[name='fieldname_"+fieldname+"'] option[value='"+value+"']", $form).text() || $("#"+mec_id+"_span").text() || "";
			var template = "<input type=\"hidden\" name=\""+tablename+"_"+fieldname+"_rowindex_"+rowindex+"\" id=\""+mec_id+"_"+rowindex+"\" value=\""+value+"\" data-role=\"none\" />";
			template += "<span id=\""+mec_id+"_span_"+rowindex+"\" showname=\""+showname+"\">"+showname+"</span>";
			return template;
		},
		buildFBrowserHtml : function($form, mec_id, fieldname, tablename, rowindex){
			var value = $("[name='fieldname_"+fieldname+"']", $form).val();
			var showname = $("#"+mec_id+"_span").html();
			var template = "<input type=\"hidden\" name=\""+tablename+"_"+fieldname+"_rowindex_"+rowindex+"\" id=\""+mec_id+"_"+rowindex+"\" value=\""+value+"\" data-role=\"none\" fieldhtmltype=\"3\"/>";
			template += "<span id=\""+mec_id+"_span_"+rowindex+"\" showname=\""+showname+"\">"+showname+"</span>";
			return template;
		},
		buildFCheckHtml : function($form, mec_id, fieldname, tablename, rowindex){
			var value = $("[name='fieldname_"+fieldname+"']", $form).val();
			var template = "<div class=\"FCheckContainer toggle "+(value == "1" ? "active" : "")+"\">"+
								"<div class=\"toggle-handle\"></div>"+
							"</div>";
			template += "<input type=\"hidden\" name=\""+tablename+"_"+fieldname+"_rowindex_"+rowindex+"\" id=\""+mec_id+"_"+rowindex+"\" value=\""+value+"\" data-role=\"none\" />";
			return template;
		},
		buildFFileHtml : function($form, mec_id, fieldname, tablename, rowindex){
			var value = $("[name='fieldname_"+fieldname+"']", $form).val();
			var template = "<div class=\"Design_FFile_EntryWrap\" id=\"FileEntryWrap"+mec_id+"_"+rowindex+"\">";
			template += "</div>";
			template += "<input type=\"hidden\" name=\""+tablename+"_"+fieldname+"_rowindex_"+rowindex+"\" id=\""+mec_id+"_"+rowindex+"\" value=\""+value+"\" data-role=\"none\" />";
			template += "<input type=\"hidden\" name=\"type_"+tablename+"_"+fieldname+"_"+rowindex+"\" value=\"file\" />";
			template += "<input type=\"hidden\" name=\"fieldmecid_"+tablename+"_"+fieldname+"_"+rowindex+"\" value=\""+mec_id+"_"+rowindex+"\" />";
			return template;
		},
		buildFPhotoHtml : function($form, mec_id, fieldname, tablename, rowindex, readonly){
			var value = $("[name='fieldname_"+fieldname+"']", $form).val();
			var template = "<div class=\"Design_FPhoto_EntryWrap\" id=\"photoEntryWrap"+mec_id+"_"+rowindex+"\">";

			var $formFhotoEntryWrap = $("#photoEntryWrap"+mec_id);
			var $expression = (readonly == "1" ? "" : ":not(:last-child)");
			$(".Design_FPhoto_EntryBorder"+$expression, $formFhotoEntryWrap).each(function(){
				template += "<div class=\"Design_FPhoto_EntryBorder\">";
				template += $(this).html();
				template += "</div>";
			});

			template += "</div>";
			template += "<input type=\"hidden\" name=\""+tablename+"_"+fieldname+"_rowindex_"+rowindex+"\" id=\""+mec_id+"_"+rowindex+"\" value=\""+value+"\" data-role=\"none\" />";
			template += "<input type=\"hidden\" name=\"type_"+tablename+"_"+fieldname+"_"+rowindex+"\" value=\"photo\" />";
			return template;
		}
	};
	var mec_id = mecJson["id"];
	var tablename = mecJson["tablename"];
	var dtablekey = mecJson["dtablekey"];
	var $detailTableContainer = $("#detailtable"+mec_id);
	var serialnum = $(".rowindex"+mec_id,$detailTableContainer).length || 0;
	var $form = $("#detailtableform"+mec_id);

	var detailbillid = $("#detailbillid"+mec_id).val();
	var isAdd = false;
	var rowindex = $("#detailcurrrowindex"+mec_id).val();
	//rowindex存在表示为编辑，不能用detailbillid判断
	if(!rowindex){
		isAdd = true;
		rowindex = (function(){
			var indexid = 0;
			$(".rowindex"+mec_id,$detailTableContainer).each(function(){
				var thisindex = parseInt($(this).attr("index"));
				if(thisindex > indexid) indexid = thisindex;
			});
			return ++indexid;
		})();
	}

	var rowHtml  = "<tr class=\"dt_content_tr\" onclick=\"Mobile_NS.DetailTable.editRowData(this, '"+mec_id+"', "+rowindex+");\" rowindex=\""+rowindex+"\">";
		rowHtml += 	"<td onclick=\"Mobile_NS.DetailTable.checkRowData('"+mec_id+"',this);\">";
		rowHtml +=		"<span class=\"rowindex rowindex"+mec_id+"\" index=\""+rowindex+"\">"+ ++serialnum +"</span>";
		rowHtml +=		"<input type=\"hidden\" name=\""+tablename+"_"+dtablekey+"_rowindex_"+rowindex+"\" value=\""+detailbillid+"\" />";
		rowHtml += 		"<input type=\"hidden\" name=\"detaildatacheckbox\" value=\"\" data-role=\"none\">";
		rowHtml += 		"<i><i>";
		rowHtml += 	"</td>";

		var fieldArray = mecJson["field_datas"] || [];
		var filemecids = [];
		for(var i in fieldArray){
			var fieldJson = fieldArray[i];
			var readonly = fieldJson["readonly"] || "0";
			//字段名
			var fieldName = fieldJson["fieldname"];
			var fieldType = fieldJson["fieldtype"];
			var fieldWidth = fieldJson["fieldwidth"] || "100";
			var fieldmecid = fieldJson["entryId"];
			var contentColomnStyle = "width:"+fieldWidth+"px;";
			//是否隐藏域
			if("8" == fieldType){
				contentColomnStyle = "display:none;";
			}
			rowHtml += "<td style=\""+contentColomnStyle+"\">";
			var fieldmectype = fieldJson["fieldmectype"];
			try{
				var buildFunc = "build"+fieldmectype+"Html";
				rowHtml += 	buildFieldHtmlFactory[buildFunc]($form, fieldmecid, fieldName, tablename, rowindex, readonly);
				if(fieldmectype == "FFile"){
					filemecids.push({fieldmecid:fieldmecid, readonly:readonly});
				}
			}catch(e){
				alert(e.message);
			}
			rowHtml += "</td>";
		}

		rowHtml += "</tr>";
		var $row = $(rowHtml);
		//附件上传字段需特殊处理
		for(var i in filemecids){
			var filemecid = filemecids[i]["fieldmecid"];
			var readonly = filemecids[i]["readonly"];
			var $formFileEntryWrap = $("#FileEntryWrap"+filemecid);
			var $rowFileEntryWrap = $("#FileEntryWrap"+filemecid+"_"+rowindex, $row);
			var $expression = (readonly == "1" ? "" : ":not(:last-child)");
			var $rowFileEntryWrapContent = $(".Design_FFile_EntryBorder"+$expression, $formFileEntryWrap);
			$rowFileEntryWrap.append($rowFileEntryWrapContent);
			$("input[name^='file"+filemecid+"']", $rowFileEntryWrap).each(function(){
				var $that = $(this);
				var name = $that.attr("name");
				name = name.replace(filemecid, filemecid+"_"+rowindex);
				$that.attr("name", name);
			});
		}
		//新增数据添加新的一行，更新数据替换当前行
		if(isAdd){
			$(".DetailTable_Content>tbody", $detailTableContainer).append($row);
		}else{
			var $editRow = $("tr[rowindex='"+rowindex+"']", $detailTableContainer);
			serialnum = $("span.rowindex", $editRow).text();
			$row.insertAfter($editRow);
			$editRow.remove();
			$("span.rowindex", $row).text(serialnum);
		}
};
Mobile_NS.DetailTable.editRowData = function(obj, mec_id, rowindex){
	var $editTr = $(obj);
	eval("var getMecJson = function(){return mecJson"+mec_id+";}");
	var mecJson = getMecJson();
	var tablename = mecJson["tablename"];
	var dtablekey = mecJson["dtablekey"];

	var $addPanel = $("#detailtableadd"+mec_id);
	var detailbillid = $("input[name='"+tablename+"_"+dtablekey+"_rowindex_"+rowindex+"']").val();
	$("#detailbillid"+mec_id).val(detailbillid);
	$("#detailcurrrowindex"+mec_id).val(rowindex);

	var parseFieldHtmlFactory = {
		parseFInputTextField : function($form, mec_id, fieldname, tablename, rowindex){
			var $editField = $("input[name='"+tablename+"_"+fieldname+"_rowindex_"+rowindex+"']", $editTr);
			var $formField = $("input[name='fieldname_"+fieldname+"']", $form);
			var fieldval = $editField.val() || "";
			if($editField && $formField){
				$formField.val(fieldval);
				$("#"+mec_id+"_span").html(fieldval);//只读
			}
		},
		parseFTextareaField : function($form, mec_id, fieldname, tablename, rowindex){
			var $editField = $("input[name='"+tablename+"_"+fieldname+"_rowindex_"+rowindex+"']", $editTr);
			var $formField = $("[name='fieldname_"+fieldname+"']", $form);
			if($editField && $formField){
				var fieldval = $editField.val();
				if(fieldval){
					brRegex = /<br>/g;
					replaceBrValue = "\n";
					spaceRegex = /&nnbbsspp;/g;
					replaceSpaceValue = " ";
					fieldval = fieldval.replace(brRegex, replaceBrValue).replace(spaceRegex, replaceSpaceValue);
				}
				$formField.val(fieldval);
				$("#"+mec_id+"_span").html(fieldval);//只读
			}
		},
		parseFSelectField : function($form, mec_id, fieldname, tablename, rowindex, fieldJson){
			var $editField = $("input[name='"+tablename+"_"+fieldname+"_rowindex_"+rowindex+"']", $editTr);
			var $fieldSpan = $("#"+mec_id+"_span_"+rowindex);
			var $formField = $("[name='fieldname_"+fieldname+"']", $form);
			if($editField && $formField){
				var fieldValue = $editField.val();
				var pFieldId = fieldJson["pfieldid"] || 0;
				var fieldId = fieldJson["fieldid"] || 0;
				if(pFieldId != 0 && fieldId != 0){
					doInitChildSelect(fieldId, pFieldId, fieldValue);
				}else{
					$formField.val($editField.val());
					$("#"+mec_id+"_span").html($fieldSpan.html() || "");
				}
			}
		},
		parseFBrowserField : function($form, mec_id, fieldname, tablename, rowindex){
			var $editField = $("input[name='"+tablename+"_"+fieldname+"_rowindex_"+rowindex+"']", $editTr);
			var $shownameEle = $("#"+mec_id+"_span_"+rowindex);
			var $formField = $("input[name='fieldname_"+fieldname+"']", $form);
			if($editField && $formField){
				var fieldvalue = $editField.val();
				$formField.val(fieldvalue);
				var $fieldSpan = $("#"+mec_id+"_span");
				if($fieldSpan){
					if(fieldvalue){
						$fieldSpan.parent().addClass("hasValue");
					}else{
						$fieldSpan.parent().removeClass("hasValue");
					}
					if($shownameEle){
						$fieldSpan.html($shownameEle.html());
					}
				}
			}
		},
		parseFHiddenField : function($form, mec_id, fieldname, tablename, rowindex){
			var $editField = $("input[name='"+tablename+"_"+fieldname+"_rowindex_"+rowindex+"']", $editTr);
			var $formField = $("input[name='fieldname_"+fieldname+"']", $form);
			if($editField && $formField){
				$formField.val($editField.val());
			}
		},
		parseFCheckField : function($form, mec_id, fieldname, tablename, rowindex){
			var $editField = $("input[name='"+tablename+"_"+fieldname+"_rowindex_"+rowindex+"']", $editTr);
			var $formField = $("input[name='fieldname_"+fieldname+"']", $form);
			if($editField && $formField){
				var fieldvalue = $editField.val();
				$formField.val(fieldvalue);
				var $checkFieldContainer = $("#div" + mec_id);
				var $FCheckContainer = $(".FCheckContainer", $checkFieldContainer);
				if(fieldvalue == "1"){
					$FCheckContainer.addClass("active");
				}else{
					$FCheckContainer.removeClass("active");
				}
			}
		},
		parseFPhotoField : function($form, mec_id, fieldname, tablename, rowindex, fieldJson){
			var readonly = fieldJson["readonly"] || "0";
			var $editField = $("input[name='"+tablename+"_"+fieldname+"_rowindex_"+rowindex+"']", $editTr);
			var $formField = $("input[name='fieldname_"+fieldname+"']", $form);
			if($editField && $formField){
				$formField.val($editField.val());
				var $fieldFhotoEntryWrap = $("#photoEntryWrap"+mec_id+"_"+rowindex);
				var $formPhotoEntryWrap = $("#photoEntryWrap"+mec_id);
				var $expression = (readonly == "1" ? "" : ":not(:last-child)");
				$(".Design_FPhoto_EntryBorder"+$expression, $formPhotoEntryWrap).remove();
				$formPhotoEntryWrap.prepend($(".Design_FPhoto_EntryBorder", $fieldFhotoEntryWrap).clone());
				/*$("img.lazy", $formPhotoEntryWrap).each(function(){
					var $img = $(this);
					var src = $img.attr("src");
					var originalSrc = $img.attr("data-original");
					if(src != originalSrc){
						$img.attr("src", originalSrc);
					}
				});*/
			}
		},
		parseFFileField : function($form, mec_id, fieldname, tablename, rowindex, fieldJson){
			var readonly = fieldJson["readonly"] || "0";
			var $editField = $("input[name='"+tablename+"_"+fieldname+"_rowindex_"+rowindex+"']", $editTr);
			var $formField = $("input[name='fieldname_"+fieldname+"']", $form);
			if($editField && $formField){
				$formField.val($editField.val());
				var $fieldFileEntryWrap = $("#FileEntryWrap"+mec_id+"_"+rowindex);
				var $formFileEntryWrap = $("#FileEntryWrap"+mec_id);
				var $expression = (readonly == "1" ? "" : ":not(:last-child)");
				$(".Design_FFile_EntryBorder"+$expression, $formFileEntryWrap).remove();
				$formFileEntryWrap.prepend($(".Design_FFile_EntryBorder", $fieldFileEntryWrap).clone());
			}
		}
	};
	var $form = $("#detailtableform"+mec_id);
	var fieldArray = mecJson["field_datas"] || [];
	for(var i in fieldArray){
		var fieldJson = fieldArray[i];
		//字段名
		var fieldName = fieldJson["fieldname"];
		var fieldmecid = fieldJson["entryId"];
		var fieldmectype = fieldJson["fieldmectype"];
		try{
			var parseFunc = "parse"+fieldmectype+"Field";
			parseFieldHtmlFactory[parseFunc]($form, fieldmecid, fieldName, tablename, rowindex, fieldJson);
		}catch(e){
			alert(e.message);
		}
	}

	Mobile_NS.DetailTable.showAddDataPanel(mec_id, false);
};

Mobile_NS.DetailTable.checkRowData = function(mec_id, obj){
	var that = $(obj);
	var $dtcontenttr = that.parents(".dt_content_tr");
	if($dtcontenttr.hasClass("checked")){
		$dtcontenttr.removeClass("checked");
	}else{
		$dtcontenttr.addClass("checked");
	}
	var e=event || window.event;
    if (e && e.stopPropagation){
        e.stopPropagation();
    }
};

Mobile_NS.DetailTable.getHorizontalPadding = function($obj){
	
	var paddingLeft = $obj.css("padding-left") || "";
	paddingLeft = paddingLeft.replace("px", "");
	paddingLeft = parseInt(paddingLeft) || 0;
	
	var paddingRight = $obj.css("padding-right") || "";
	paddingRight = paddingRight.replace("px", "");
	paddingRight = parseInt(paddingRight) || 0;
	
	return paddingLeft + paddingRight;
};
