/**
 * 日期字段选择限制范围
 * @param {fieldid} 	日期字段ID
 * @param {floorday} 	下限天数(与当前日期比较)，空值代表不限制
 * @param {upperday} 	上限天数(与当前日期比较)，空值代表不限制
 * @return 返回true表示在范围内，false表示超出限定范围或日期置为空
 */
function cus_judgeDateRange(fieldid, floorday, upperday){
	var fieldObj = jQuery("input[name="+fieldid+"]");
	if(fieldObj.size() == 0)
		return false;
	var fieldval = fieldObj.val();
	if(!!!fieldval)		
		return false;
	floorday = (floorday === "" ? -99999 : parseInt(floorday));
	upperday = (upperday === "" ? 99999 : parseInt(upperday));
	var curdate = new Date();
	var defdate = curdate.getFullYear()+"-"+(curdate.getMonth()+1)+"-"+curdate.getDate();
	var diffdays = (new Date(fieldval.replace(/-/g, "/")).getTime() - new Date(defdate.replace(/-/g, "/")).getTime())/(24*3600*1000);
	diffdays = Math.ceil(diffdays);
	if(diffdays >= floorday && diffdays <= upperday)
		return true;
	else
		return false;
}

/**
 * 计算时间差
 * @param {begfields} 开始时间
 * @param {endfields} 结束时间
 * @param {unit} 	计量结果单位1(天)、2(小时)、3(分钟)、4(秒)，默认为天
 * @param {digit} 	计算结果保留小数位数，默认2位小数
 * @return 以endfields字段值减去beginfields字段值得到时间差值
 * 注：begfields/endfields结构，可为单独日期字段、单独时间字段、日期+时间组合字段(以英文逗号隔开);日期字段空值默认取今天，时间字段空值默认为00:00
 */
function cus_CalTimeDiff(begfields, endfields, unit, digit){
	if(!!!begfields || !!!endfields)
		return "ParamsError";
	var diffmillsecond = cus_GetTimeDiffMillSecond(begfields, endfields);
	var diffsecond = diffmillsecond/1000;
	unit = !!unit ? parseInt(unit) : 1;
	digit = (!!digit || digit == 0) ? parseInt(digit) : 2;
	var retdiff = 0;
	if(unit === 1)
		retdiff = diffsecond/(3600*24);
	else if(unit === 2)
		retdiff = diffsecond/3600;
	else if(unit === 3)
		retdiff = diffsecond/60;
	else if(unit === 4)
		retdiff = diffsecond;
	if(digit === 0)
		retdiff = Math.floor(retdiff);	//向下取整
	else
		retdiff = retdiff.toFixed(digit);
	return retdiff;
}

/**
 * 比较timefield1与timefield2两字段时间大小
 * @param {timefield1} 字段1(开始时间)
 * @param {timefield2} 字段2(结束时间)
 * @return 返回true表示timefield2较大，false表示timefield1较大或相等
 * 注：timefield1/timefield2结构，可为单独日期字段、单独时间字段、日期+时间组合字段(以英文逗号隔开);日期字段空值默认取今天，时间字段空值默认为00:00
 */
function cus_CompareTime(timefield1, timefield2){
	var diffmillsecond = cus_GetTimeDiffMillSecond(timefield1, timefield2);
	return diffmillsecond > 0;
}

//计算两时间字段相差毫秒数
function cus_GetTimeDiffMillSecond(field1, field2){
	var timeval1 = cus_getTimeValueByField(field1);
	var timeval2 = cus_getTimeValueByField(field2);
	var diffmillsecond = new Date(timeval2.replace(/-/g, "/")).getTime() - new Date(timeval1.replace(/-/g,"/")).getTime();
	return diffmillsecond;
}

//根据日期/时间字段ID取标准格式时间值
function cus_getTimeValueByField(fields){
	var timeval;
	var fieldArr = fields.split(",");
	if(fieldArr.length === 1)
		timeval = jQuery("input[name="+fieldArr[0]+"]").val();
	else if(fieldArr.length > 1)
		timeval = jQuery("input[name="+fieldArr[0]+"]").val() + " " + jQuery("input[name="+fieldArr[1]+"]").val();
	var curdate = new Date();
	var defdate = curdate.getFullYear()+"-"+(curdate.getMonth()+1)+"-"+curdate.getDate();
	if(timeval.indexOf("-") == -1)		timeval = defdate + " " + timeval;
	return timeval;
}

/**
 * 选择框转换成Radio框样式显示/编辑
 * @param {fields}	字段id集合，以逗号隔开
 * 注:转换后可能不支持联动功能，只是转换样式显示/编辑
 */
function cus_ConvertSelectToRadio(fieldids){
	jQuery.each(fieldids.split(","), function(i, fieldid){
		var isdisabled = false;
		var selectObj = jQuery("select[name=dis"+fieldid+"]");
		if(selectObj.size() > 0){
			isdisabled = true;
		}else{
			selectObj = jQuery("select[name="+fieldid+"]");
			if(selectObj.size() == 0)	return true;
		}
		var radioHtml = "";
		selectObj.find("option").each(function(){
			var selval = jQuery(this).val();
			var seltext = jQuery(this).text();
			if(selval != ""){
				radioHtml += '<input type="radio" name="opt'+fieldid+'" value="'+selval+'" ';
				if(jQuery(this).is(":selected"))
					radioHtml += ' checked';
				if(isdisabled)
					radioHtml += ' disabled';
				else
					radioHtml += ' onclick="cus_SyncSelectVal(this)"'
				radioHtml += ' />' + seltext + "&nbsp;&nbsp;";
			}
		});
		selectObj.after(radioHtml);
		selectObj.hide();
		if(isdisabled){
			window.setTimeout(function(){
				selectObj.parent().find("span:not([id])").css("display","none");
			},200);
		}
	})
}

//点击Radio反向回写Select框
function cus_SyncSelectVal(vthis){
	var radioname = jQuery(vthis).attr("name");
	var selectObj = jQuery("select[name='"+radioname.substring(3)+"']");
	selectObj.val(jQuery(vthis).val());
	try{
		selectObj.trigger("blur").trigger("change");
	}catch(e){}
}

/**
 * 显示指定区域
 * @param {areanames} 自定义属性中设置的name属性区域集合，多个以逗号隔开
 */
function cus_ShowAreaByName(areanames){
	jQuery.each(areanames.split(","), function(i,value){
		jQuery("[name="+value+"]").show().removeClass("edesign_hide");
	});
}

/**
 * 隐藏指定区域，隐藏的区域不校验必填
 * @param {areanames} 自定义属性中设置的name属性区域集合，多个以逗号隔开
 */
function cus_HideAreaByName(areanames){
	jQuery.each(areanames.split(","), function(i,value){
		jQuery("[name="+value+"]").hide().addClass("edesign_hide");
	});
}

/**
 * 控制明细列隐藏/显示
 * @param {cusclassname}  列自定义class属性
 * @param {status}  1为显示，2为隐藏
 */
function cus_ControlDetailColumnByClass(cusclassname, status){
	if(status === 1)
		jQuery("td."+cusclassname).show().removeClass("edesign_hide");
	else if(status === 2)
		jQuery("td."+cusclassname).hide().addClass("edesign_hide");
}

/**
 * 校验字段是否必填，不满足弹出提示
 * @param {fieldid} 需校验的字段ID，多个以逗号分隔
 * @param {alertmsg} 存在未必填字段时弹出提示信息，空则不提示
 * @return true代表存在未填写字段，false表示校验通过
 */
function cus_verifyExistNullField(fieldids, alertmsg){
	var existNullField = false;
	jQuery.each(fieldids.split(","), function(i, fieldid){
		var fieldObj = jQuery("[name="+fieldid+"]");
		if(fieldObj.size() == 0 || fieldObj.is("input[type=checkbox]"))
			return true;
		var fieldval = cus_getFieldValue(fieldid);
		if(fieldval === ""){
			existNullField = true;
			return false;
		}
	})
	if(existNullField && !!alertmsg)
		alert(alertmsg);
	return existNullField;
}

/**
 * 根据字段ID取字段值
 * @param {fieldid} 字段ID
 * @return 字段对应值
 * 注：支持文本、多行文本框、浏览框(ID值)、选择框、check框(选中为1未选中为0)
 */
function cus_getFieldValue(fieldid){
	var fieldObj = jQuery("[name="+fieldid+"]");
	if(fieldObj.size() == 0)	return "";
	var fieldval = "";
	if(fieldObj.is("input[type=checkbox]")){
		if(fieldObj.is(":checked"))
			fieldval = "1";
		else
			fieldval = "0";
	}else if(fieldObj.is("input")){
		fieldval = fieldObj.val();
		if(!!fieldval && fieldObj.attr("datavaluetype") == "5")
			fieldval = fieldval.replace(/,/g,"");
	}else if(fieldObj.is("textarea")){
		fieldval = fieldObj.text();
	}else if(fieldObj.is("select")){
		fieldval = fieldObj.find("option:selected").val();
	}
	return fieldval;
}

/**
 * 给文本字段赋值，支持只读/编辑情况
 * @param {fieldid} 字段ID
 * @param {fieldvalue}	字段值 
 */
function cus_setInputFieldValue(fieldid, fieldvalue){
	var fieldObj = jQuery("input[name="+fieldid+"]");
	if(fieldObj.size() == 0)	return;
	fieldObj.val(fieldvalue);
	if(fieldObj.attr("type")=="hidden"){		//只读
		jQuery("span#"+fieldid+"span").text(fieldvalue);
	}else{
		if(!!fieldvalue)	//去必填标示
			jQuery("span#"+fieldid+"span").text("");
	}
}


