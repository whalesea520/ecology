function getItemHtml(text, eleHtml) {
	var itemHtml = "<div name=\"attrContainer\" class=\"attrClass\">";
				 +      "<div class=\"attrValueBody\">"
				 +			eleHtml
				 +	    "</div>"
				 +	    "<div class=\"attrKeyBody\">" + text + "</div>"
				 + "</div>";
	return itemHtml;
}

function setContent(jsonString, flag) {
//window.console.log(jsonString);
	//var s_html = "";
	//jQuery("#attributeTable TBODY").html(s_html);
	var rtnHtml = "";
	var jsonSource = eval(jsonString);
	jQuery.each(jsonSource, function (i, item) { 
		var id = item.id;
		var type = item.type;
		var name = item.label;
		var label = eval(item.label);
		var value = item.value;
		var options = item.options;
		var url = item.url;
		var hasCon = item.hasIdetity;
		
		var wfid = item.wfid;
		var formid = item.formid;
		var isBill = item.isBill;
		var isCust = item.isCust;
		
		if (type == 1) {
			rtnHtml += getItemHtml(label, "<input type='text' name='" + name + "' value='" + value + "' onchange='synchInfo(" + flag + ", " + id + ", this.name, this.value);'>");
		}
		
		if (type == 2) {
			var isDymGetData = item.isDymGetData;
			var dymGetDataMethod = item.dymGetDataMethod;
			
			if (isDymGetData && dymGetDataMethod == "") {
			}
			var selectHtml = "<select name='" + name + "' _nodeid='" + id + "' _wfid='" + wfid + "' _formid='" + formid + "' _isBill='" + isBill + "' _isCust='" + isCust + "' onchange='synchInfo(" + flag + ", " + id + ", this.name, this.value);'>";
			jQuery.each(options, function (j, j_item) { 
				var text = j_item.text;
				try {
					text = eval(j_item.text);
				} catch (e) {}
				var o_value = j_item.value;
				if (o_value == value) {
					selectHtml += "<option value='" + o_value + "' selected>" + text + "</option>"
				} else {
					selectHtml += "<option value='" + o_value + "'>" + text + "</option>"
				}
			});
			
			if (isDymGetData) {
				eval(dymGetDataMethod);
			}
			
			selectHtml += "</select>";
			rtnHtml += getItemHtml(label, selectHtml);
		} else if (type == 3) {
			rtnHtml += getItemHtml(label, "<div class='propertyWin' onclick=\"openExtWin2('" + url + "')\" style='height:24px;'></div>");
		}
	});
	jQuery("#attrBody").html(rtnHtml);
	return "1";
}