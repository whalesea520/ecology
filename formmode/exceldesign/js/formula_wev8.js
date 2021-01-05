/**
 * 明细添加addRow触发相应公式计算
 * 解决主字段参与计算赋值给明细字段，新添加的明细行不触发问题
 */
function triFormula_addRow(groupid){
	try{
		var hasTri = {};
		jQuery(".excelMainTable").find("td[_cellattr][_formula]").each(function(){
			var _cellattr = jQuery(this).attr("_cellattr");
			var _formula = jQuery(this).attr("_formula");
			var reg = new RegExp("^(MAIN|TAB_\d+)\.");
			var reg1 = new RegExp("DETAIL_"+(parseInt(groupid)+1)+"\.");
			if(!reg.test(_cellattr) || !reg1.test(_formula))
				return true;
			//主表字段触发计算明细表行
			var needTri = false;
			var _formulaArr = _formula.split(",");
			jQuery.each(_formulaArr, function(i,value){
				if(!(value in hasTri)){		//避免重复计算
					hasTri[value] = value;
					needTri = true;
				}
			});
			if(needTri){
				var _fieldObj = jQuery(this).find("input[name='field"+jQuery(this).attr("_fieldid")+"']").get(0);
				formulaTrigger(_fieldObj, "addRow");		//手动触发公式计算一次
			}
		});
	}catch(e){
		if(window.console)	console.log("triFormula_addRowError:"+e);
	}
}

/**
 * 明细删除deleteRow触发相应公式计算
 */
function triFormula_delRow(groupid){
	try{
		var needTriFormula = {};
		var reg = new RegExp("^(MAIN|TAB_\d+)\.");
		var detailTable = jQuery(".excelMainTable").find("table#oTable"+groupid);
		if(jQuery("#modesnum"+groupid).val() == "0"){		//明细记录全删除情况
			var reg_detail = new RegExp("DETAIL_"+(parseInt(groupid)+1)+"\.");
			for(var key in globalFormula){
				var formulaObj = globalFormula[key];
				var destcell = formulaObj["destcell"];
				var formulatxt = formulaObj["formulatxt"];
				if(reg.test(destcell) && reg_detail.test(formulatxt)){	//取值字段含明细字段且赋值字段为主字段
					this.setFieldValueById("field"+formulaObj["destfield"], 0); 	//直接赋值零
				}
			}
		}else{
			detailTable.find("td[_cellattr][_formula]").each(function(){
				var _formulaArr = jQuery(this).attr("_formula").split(",");
				var _vthis = jQuery(this);
				jQuery.each(_formulaArr, function(i,value){
					if(reg.test(value) && !(value in needTriFormula))	//赋值给主字段,避免重复计算
						needTriFormula[value] = _vthis;
				});
			});
			for(var _formula in needTriFormula){
				var _tdObj = needTriFormula[_formula];
				var _fieldObj = _tdObj.find("input[name='field"+_tdObj.attr("_fieldid")+"']").get(0);
				formulaTrigger(_fieldObj, "delRow");		//手动触发公式计算一次
			}
		}
	}catch(e){
		if(window.console)	console.log("triFormula_delRowError:"+e);
	}
}

/**
 * 触发公式，所有公式计算总入口
 */
function formulaTrigger(vthis, triTag){
	try{
		if(typeof(triTag) == "undefined"){		//onpropertychange、_listener触发
			triTag = "";
			if(jQuery.browser.msie && window.event){
				var propertyName = window.event.propertyName;
				if(!!!propertyName || propertyName != 'value')
					return;
			}
		}
		var triggerFieldid = jQuery(vthis).attr("name").replace("field","");
		var _formula = jQuery("td[_fieldid='"+triggerFieldid+"']").attr("_formula");
		var formulaArr = _formula.split(",");
		for(var len=0;len<formulaArr.length;len++){
			try{
				var formulaJson = globalFormula[formulaArr[len]]
				var destcell = formulaJson["destcell"];
				var formulatxt = formulaJson["formulatxt"];
				var cellrange = formulaJson["cellrange"];
				formulatxt = jQuery.trim(formulatxt).substring(1);
				
				if(window.console) console.log("1>>>destcell: "+destcell+">>>formulatxt: "+formulatxt);
				//公式解析分如下几种情况
				if(destcell.indexOf("DETAIL_")==-1){				//赋值给主表字段
					if(formulatxt.match(/DETAIL_\d+\./g)){			//取值字段包含明细表字段
						var reg = /^EXCEL_AVERAGE\((\s*(MAIN|TAB_\d+|DETAIL_\d+)\.[A-Z]+\d+\s*(\,)?)+\)$/;
						if(reg.test(formulatxt)){	//针对明细平均计算特殊处理
							this.calculate_special_detailfield(destcell, formulatxt, cellrange, triTag);
						}else{
							this.calculate_detailSumVal(destcell,formulatxt,cellrange, triTag);
						}
					}else{											//取值字段全部为主表字段
						this.calculate_single(destcell,formulatxt,cellrange,false,"", triTag);
					}
				}else{												//赋值给明细表字段
					if(formulatxt.match(/(MAIN|TAB_\d+)\./g)){		//取值字段包含主表字段
						var triggerCellAttr = jQuery("td[_fieldid='"+triggerFieldid+"']").attr("_cellattr");
						if(triggerCellAttr.indexOf("DETAIL_")==-1){	//触发字段为主字段，需计算明细所有行记录
							this.calculate_detailAllRow(destcell,formulatxt,cellrange, triTag);
						}else{										//触发字段为明细字段，则只计算当前行
							this.calculate_single(destcell,formulatxt,cellrange,true,triggerFieldid, triTag);
						}
					}else{											//取值字段全部为明细表字段
						this.calculate_single(destcell,formulatxt,cellrange,true,triggerFieldid, triTag);
					}
				}
			}catch(ex){
				if(window.console)	console.log("9>>>>>formula calculate error: "+ex);
			}
		}
	}catch(e){
		if(window.console)	console.log("formulaTrigger Error");
	}
}

/**
 * 单一公式计算---包含三种情况(纯主表间计算、纯明细表间计算、触发字段为明细字段且赋值字段为明细字段计算)
 * @argument hasDetail 计算是否包含明细表
 */
function calculate_single(destcell,formulatxt,cellrange,hasDetail,triggerFieldid, triTag){
	var rowid = "";
	if(hasDetail){		//涉及到明细表，需传入明细行id
		if(triggerFieldid.indexOf("_")>-1){
			rowid = triggerFieldid.substring(triggerFieldid.indexOf("_")+1);
			if(!isInt(rowid))
				throw new Error("Detail current rowid is not a int");
		}else{
			throw new Error("Get detail current rowid error");
		}
	}
	formulatxt = this.formulaReplaceValue(formulatxt,cellrange,rowid);
	
	if(destcell.indexOf("DETAIL_")>-1){
		destcell += "_"+rowid;
	}
	var destFieldid = "field"+jQuery("td[_cellattr='"+destcell+"']").attr("_fieldid");
	var calculateResult = eval(formulatxt);
	
	if(window.console)	console.log("2>>>formulatxt: "+destFieldid+"=="+formulatxt+">>>calResult: "+calculateResult);
	this.setFieldValueById(destFieldid,calculateResult);
}

/**
 * 求和公式计算--赋值字段为主字段，取值字段为明细/主表字段混合情况；需明细每条记录计算，再求和，再赋值给主表字段
 * @argument groupid   对应明细表ID
 */
function calculate_detailSumVal(destcell,formulatxt,cellrange, triTag){
	var groupid = -1;
	for(var idx=0;idx<cellrange.length;idx++){
		var cellattr = cellrange[idx];
		if(cellattr.indexOf("DETAIL_")>-1){
			groupid = getGroupid(cellattr);
			break;
		}
	}
	if(groupid==-1)		throw new Error("Get detail groupid error!");
						
	var calculateSumResult = 0;
	jQuery("input[type='checkbox'][name='check_mode_"+groupid+"']").each(function(){
		try{
			var rowid = jQuery(this).val();
			var formulatxt_clone = formulatxt;
			formulatxt_clone = formulaReplaceValue(formulatxt_clone,cellrange,rowid);
			var calculateResult = eval(formulatxt_clone);
			
			if(window.console)	console.log("2>>>rowid: "+rowid+">>>formulatxt_clone: "+formulatxt_clone+">>>calResult: "+calculateResult);
			if(!isNaN(parseFloat(calculateResult))){
				calculateSumResult = rewrite_add(calculateSumResult,calculateResult);
			}
		}catch(ev){}
	});
	var destFieldid = "field"+jQuery("td[_cellattr='"+destcell+"']").attr("_fieldid");
	this.setFieldValueById(destFieldid,calculateSumResult);
}

/**
 * 明细所有行公式计算--赋值字段为明细字段，触发字段为主表字段；明细表每条记录都需经过公式计算再赋值
 * @argument groupid   对应明细表ID
 */
function calculate_detailAllRow(destcell,formulatxt,cellrange, triTag){
	var groupid = getGroupid(destcell);
	if(groupid==-1)		throw new Error("Get detail groupid error!");
	
	var eachRowObj = jQuery("input[type='checkbox'][name='check_mode_"+groupid+"']");
	if(triTag === "addRow")
		eachRowObj = eachRowObj.last();
	eachRowObj.each(function(){
		try{
			var rowid = jQuery(this).val();
			var formulatxt_clone = formulatxt;
			formulatxt_clone = formulaReplaceValue(formulatxt_clone,cellrange,rowid);
			var calculateResult = eval(formulatxt_clone);
			
			if(window.console)	console.log("2>>>rowid: "+rowid+">>>formulatxt_clone: "+formulatxt_clone+">>>calResult: "+calculateResult);
			var destFieldid = "field"+jQuery("td[_cellattr='"+destcell+"_"+rowid+"']").attr("_fieldid");
			setFieldValueById(destFieldid,calculateResult);
		}catch(ev){}
	}); 
}

/**
 * 公式特殊处理，只计算一次，明细字段替换时取明细所有行字段的值
 */
function calculate_special_detailfield(destcell,formulatxt,cellrange, triTag){
	formulatxt = this.formulaReplaceValue(formulatxt,cellrange,"all");
	var destFieldid = "field"+jQuery("td[_cellattr='"+destcell+"']").attr("_fieldid");
	var calculateResult = eval(formulatxt);
	
	if(window.console)	console.log("2>>>formulatxt: "+destFieldid+"=="+formulatxt+">>>calResult: "+calculateResult);
	this.setFieldValueById(destFieldid,calculateResult);
}

/**
 * 将公式字符串中的单元格ID替换为对应的值
 * @param {} formulatxt		公式原字符串
 * @param {} cellrange		公式中所有单元格ID
 * @param {} rowid	明细当前行
 */
function formulaReplaceValue(formulatxt,cellrange,rowid){
	jQuery.each(cellrange,function(index,cellattr){
		var cellValue = "";
		if(rowid === "all" && cellattr.indexOf("DETAIL_")>-1){	//需替换明细所有行字段
			var groupid = getGroupid(cellattr);
			jQuery("input[type='checkbox'][name='check_mode_"+groupid+"']").each(function(index){
				var _row = "_"+jQuery(this).val();
				var _cellValue = getFieldValueById(cellattr, _row);
				if(index != 0)	_cellValue = ","+_cellValue;
				cellValue += _cellValue;
			});
		}else{
			var _row = "";
			if(rowid !== "" && cellattr.indexOf("DETAIL_")>-1)
				_row = "_"+rowid;
			cellValue = getFieldValueById(cellattr, _row);
		}
		if(cellValue == "")		cellValue = "\""+cellValue+"\"";
		//不能简单的用replace，需判断替换串后一个字符是否是数字，避免例如MAIN.D1的值替换了MAIN.D11串
		var curindex = -1;
		while(formulatxt.indexOf(cellattr)>curindex){
			curindex = formulatxt.indexOf(cellattr);
			var str1 = formulatxt.substring(0,curindex);
			var str2 = formulatxt.substring(curindex+cellattr.length);
			var reg=/^[0-9]$/;
			var nextchar = str2.substr(0,1);
			if(reg.test(nextchar))	continue;
			formulatxt = str1+cellValue+str2;
		}
	});
	return formulatxt;
}

/**
 * 根据字段唯一ID获取字段
 */
function getFieldValueById(cellattr, _row){
	var fieldid = "field"+jQuery("td[_cellattr='"+cellattr+_row+"']").attr("_fieldid");
	var fieldval = "";
	var fieldObj = jQuery("input#"+fieldid);
	if(fieldObj.size()>0){
		fieldval = fieldObj.val();
		if(!!fieldval&&fieldObj.attr("datavaluetype")=="5"){
			fieldval = fieldval.replace(/,/g,"");
		}
	}
	if(fieldval == "")
		fieldval = "emptyval";
	if(isNaN(fieldval))	
		fieldval = "\""+fieldval+"\"";
	return fieldval;
}

/**
 * 将计算结果更新到赋值字段中
 */
function setFieldValueById(fieldid,calculateResult){
	var fieldElement=jQuery("input#"+fieldid);
	if(fieldElement.size()==0)	return;
	var fieldvalue = "";
	var regnum = /^(-?\d+)(\.\d+)?$/;
	var isNumber = regnum.test(calculateResult);
	//eval(23*1.4)=32.19999，eval都存在误差，赋值前都toFixed下
	if(fieldElement.attr("datatype")=="int"){		//转换为整数
		if(isNumber)
			fieldvalue = Math.round(parseFloat(calculateResult)).toString();
	}else if(fieldElement.attr("datatype")=="float"){	//调用format_wev8.js的方法转换为浮点数、千分位
		if(isNumber){
			var decimals = parseInt(fieldElement.attr("datalength"));
			var calculateResult_num = new Number(calculateResult);
			calculateResult = calculateResult_num.toFixed(decimals).toString();
			if(fieldElement.attr("datavaluetype")=="5"){
				fieldvalue = formatValue_float(calculateResult,decimals,1,1);
			}else{
				fieldvalue = formatValue_float(calculateResult,decimals,0,1);
			}
		}
	}else{
		if(isNumber){	//数值赋值给文本，取两位小数
			var calculateResult_num = new Number(calculateResult);
			calculateResult = calculateResult_num.toFixed(2).toString();
		}
		fieldvalue = calculateResult;
	}
	
	fieldElement.attr("value",fieldvalue);
	if(fieldElement.attr("type")=="hidden"){		//只读
		if(fieldElement.attr("fieldtype")=="4"){
			var fieldidint = fieldid.substring("5");
			var fieldLabelElement = jQuery("input#field_lable"+fieldidint);
			fieldLabelElement.val(fieldvalue);
			numberToFormat(fieldidint);
		}else{
			if(jQuery("span#"+fieldid+"span").size()>0){
				jQuery("span#"+fieldid+"span").text(fieldvalue);
			}
		}
	}
	window.setTimeout(function(){			//明细字段触发SQL赋值，需延时执行，why
		fieldElement.trigger("change");		//触发合计函数
	},100);
}

//获取属于哪个明细表groupid
function getGroupid(cellattr){
	var idx = cellattr.indexOf("DETAIL_");
	if(cellattr.indexOf("DETAIL_") == -1)
		return -1;
	var groupid = cellattr.substring(idx+7 ,cellattr.indexOf("."));
	return parseInt(groupid)-1;
}

//是否是纯数字
function isInt(str){
	var reg = /^[0-9]+$/;
	return reg.test(str);
}

//JS parseFloat求和精度不一致问题解决
function rewrite_add(arg1,arg2){
	var r1=0,r2=0; 
	try{
		r1=arg1.toString().split(".")[1].length;
	}catch(e){}
	try{
		r2=arg2.toString().split(".")[1].length;
	}catch(e){}
	var m=Math.pow(10,Math.max(r1,r2)); 
	return (arg1*m+arg2*m)/m; 
}

//求和
function EXCEL_SUM(){
	var result = 0;
	for(var i=0;i<arguments.length;i++){
		var par = arguments[i];
		if(!isNaN(parseFloat(par))){
			//result += parseFloat(par);
			result = rewrite_add(result,par);
		}
	}
	return result;
}
//求平均数
function EXCEL_AVERAGE(){
	var count = 0;
	var sumVal = 0;
	for(var i=0;i<arguments.length;i++){
		var par = arguments[i];
		if(!isNaN(parseFloat(par))){
			//sumVal += parseFloat(par);
			sumVal = rewrite_add(sumVal,par);
			count++;
		}
	}
	if(count>0){
		return parseFloat(sumVal/count);
	}else{
		throw new Error("EXCEL_AVERAGE divisor is zero");
	}
}
//求绝对值
function EXCEL_ABS(){
	if(arguments.length==1){
		var par = arguments[0];
		if(!isNaN(parseFloat(par))){
			var result = Math.abs(parseFloat(par));
			return result;
		}else{
			throw new Error("EXCEL_ABS arguments value is not a number");
		}
	}else{
		throw new Error("EXCEL_ABS arguments number must equal one");
	}
}
//精度计算
function EXCEL_ROUND(){
	if(arguments.length==2){
		var result = 0;
		var par1 = arguments[0];
		var par2 = arguments[1];
		if(!isNaN(parseFloat(par1))){
			par1 = parseFloat(par1);
		}else{
			throw new Error("EXCEL_ROUND first argument value is not a number");
		}
		if(isInt(par2)){
			par2 = parseInt(par2);
		}else{
			throw new Error("EXCEL_ROUND second argument value is not a int");
		}
		result = par1.toFixed(par2);
		return result;
	}else{
		throw new Error("EXCEL_ROUND arguments number must equal two");
	}
}
//条件判断
function EXCEL_IF(){
	if(arguments.length==3){
		if(eval(arguments[0])){
			return arguments[1];
		}else{
			return arguments[2];
		}
	}else{
		throw new Error("EXCEL_IF arguments number must equal three");
	}
}
//求最大值
function EXCEL_MAX(){
	var result;
	for(var i=0;i<arguments.length;i++){
		var par = arguments[i];
		if(!isNaN(parseFloat(par))){
			if(result==null){
				result = parseFloat(par);
			}else{
				if(parseFloat(par)>result)	
					result = parseFloat(par);
			}
		}
	}
	if(result!=null){
		return result;
	}else{
		throw new Error("EXCEL_MAX arguments value must contain a number");
	}
}
//求最小值
function EXCEL_MIN(){
	var result;
	for(var i=0;i<arguments.length;i++){
		var par = arguments[i];
		if(!isNaN(parseFloat(par))){
			if(result==null){
				result = parseFloat(par);
			}else{
				if(parseFloat(par)<result)	
					result = parseFloat(par);
			}
		}
	}
	if(result!=null){
		return result;
	}else{
		throw new Error("EXCEL_MIN arguments value must contain a number");
	}
}


/*jQuery(document).ready(function(){
	console.log("EXCEL_SUM:"+EXCEL_SUM("1","3.5","9","6.5"));
	console.log("EXCEL_AVERAGE:"+EXCEL_AVERAGE("1","3.5","9","6.5"));
	console.log("EXCEL_ABS:"+EXCEL_ABS("-0.00859"));
	console.log("EXCEL_ROUND:"+EXCEL_ROUND("-0.00859","3"));
	console.log("EXCEL_IF:"+EXCEL_IF("1>10","ETRUE","EFALSE"));
	console.log("EXCEL_MAX:"+EXCEL_MAX("1","3.5","9","6.5"));
	console.log("EXCEL_MIN:"+EXCEL_MIN("1","3.5","9","6.5"));
	console.log("简单嵌套:"+EXCEL_IF("1>0.2+0.9",EXCEL_SUM("1","3.5"),EXCEL_AVERAGE("1","3.5")));
});*/