/**
 * liuzy 2015/12/31
 * Html模板行列规则改造，不在后台解析生成JS，改为根据行列规则配置JS计算
 */
 
/**
 * 全局变量，存储按明细归类的行列规则信息 
 */
var calRuleCfg = {};

/**
 * 全局变量，calsum通过getEvent取不到触发字段时使用此对象，用于字段联动、SQL联动等给明细字段赋值时调用
 */
var triDetailCalSumField = "";

var calOperate = (function(){
	var referRowAssignStr = "";		//记录本次行列规则运算行规则赋值字段，判断是否需要触发列规则
	
	/**
	 * 根据明细表获取对应所属的规则信息
	 * groupid:0/1/2 对应明细表1/2/3
	 * symbol: rowcal(行规则计算)/colcal(列字段合计)/maincal(合计赋值给主字段)
	 */
	function getAppointRuleStr(groupid, symbol){
		var rulestr = "";
		var detailKey = "detail_"+groupid;
		if(detailKey in calRuleCfg){
			var ruleObj = calRuleCfg[detailKey];
			if(symbol in ruleObj){
				rulestr = ruleObj[symbol];
			}
		}
		return rulestr;
	}
	
	/**
	 * 高级明细模式行列规则计算实现主体
	 */
	function calSumFun(groupid){
		var oTable = jQuery("table#oTable"+groupid);
		if(oTable.length == 0)
			return;
		var trifieldid = "";
		try{
			var evt = getEvent();
			trifieldid = (evt.srcElement ? evt.srcElement : evt.target).name.toString();
		}catch(e){
			trifieldid = triDetailCalSumField;
		}
		if(!!trifieldid)		//触发字段行规则计算
			calRowRule_valChange(groupid, trifieldid);
		var indexnum = parseInt(jQuery("input#indexnum"+groupid).val());
		//取触发字段串
		var trifieldstr = "";
		if(!!trifieldid && trifieldid.indexOf("field")>-1){
			trifieldstr = trifieldid.replace("field_lable", "").replace("field", "");
			trifieldstr = "detailfield_"+trifieldstr.substring(0, trifieldstr.indexOf("_"));
		}
		//合计赋值
		var __hasSumField = {}; 
		var colcalStr = getAppointRuleStr(groupid, "colcal");
		if(!!colcalStr){
			var colcalArr = colcalStr.split(";");
			for(var i=0; i<colcalArr.length; i++){
				var sumfield = colcalArr[i];
				if(trifieldstr != "" && sumfield != trifieldstr && referRowAssignStr.indexOf(sumfield) == -1)
					continue;	//合计字段不为触发字段且不为行规则赋值字段情况不触发合计
				sumfield = sumfield.replace("detailfield_", "");
				var sumfieldInput = oTable.find("input#sumvalue"+sumfield);
				if(sumfieldInput.length == 0)
					continue;	//当前明细模板会放置合计字段
				var sumval = 0;
				var fieldtype;
				var datalength;
				for(var j=0; j<indexnum; j++){
					var rowFieldObj = jQuery("input#field"+sumfield+"_"+j);
					if(rowFieldObj.length > 0){		//循环存在的行
						fieldtype = rowFieldObj.attr("fieldtype");
						datalength = rowFieldObj.attr("datalength");
						var rowFieldVal = rowFieldObj.val();
						rowFieldVal = rowFieldVal.replace(/,/g, "");
						if(!!rowFieldVal)
							sumval += rowFieldVal*1;
					}
				}
				__hasSumField[sumfield] = sumval;
				//赋值给合计字段
				var decimals = 0;
				if(fieldtype != "2"){
					decimals = 2;
					if(!!datalength)
						decimals = datalength;
				}
				var isthousands = (fieldtype == "5") ? true :false;
				sumval = formatNumber(sumval, decimals, isthousands);
				if(window.console)	console.log("明细字段"+sumfield+"合计值："+sumval);
				sumfieldInput.val(sumval);
				oTable.find("span#sum"+sumfield).text(sumval);
			}
		}
		//赋值给主字段
		var maincalStr = getAppointRuleStr(groupid, "maincal");
		if(!!maincalStr){
			var maincalArr = maincalStr.split(";");
			for(var i=0; i<maincalArr.length; i++){
				var maincalstr = maincalArr[i];
				var equalIdx = maincalstr.indexOf("=");
				if(equalIdx == -1)
					continue;
				var assignMainField = maincalstr.substring(0, equalIdx);
				var evalDetailField = maincalstr.substring(equalIdx+1);
				if(trifieldstr != "" && evalDetailField != trifieldstr && referRowAssignStr.indexOf(evalDetailField) == -1)
					continue;	//合计字段不为触发字段且不为行规则赋值字段情况不触发合计
				assignMainField = assignMainField.replace("mainfield_", "field");
				evalDetailField = evalDetailField.replace("detailfield_", "");
				var detailSumVal = 0;
				if(evalDetailField in __hasSumField){
					detailSumVal = __hasSumField[evalDetailField];
				}else{
					for(var j=0; j<indexnum; j++){
						var rowFieldObj = jQuery("input#field"+evalDetailField+"_"+j);
						if(rowFieldObj.length > 0){		//循环存在的行
							var rowFieldVal = rowFieldObj.val();
							rowFieldVal = rowFieldVal.replace(/,/g, "");
							if(!!rowFieldVal)
								detailSumVal += rowFieldVal*1;
						}
					}
				}
				//计算结果赋值给主字段
				setMainFieldVal(assignMainField, detailSumVal);
			}
		}
	}
	
	/**
	 * 页面加载计算明细表所有行的行规则
	 */
	function calRowRule_allRow(groupid){
		var oTable = jQuery("table#oTable"+groupid);
		if(oTable.length == 0)
			return;
		var rowcalStr = getAppointRuleStr(groupid, "rowcal");
		if(!!!rowcalStr)
			return;
		var rowcalArr = rowcalStr.split(";");
		oTable.find("input[name='check_node_"+groupid+"']").each(function(){		//循环行
			var rowmark = jQuery(this).val();
			for(var i=0; i<rowcalArr.length; i++){
				var rowrule = rowcalArr[i];
				var equalIdx = rowrule.indexOf("=");
				if(equalIdx == -1)
					continue;
				var assignStr = rowrule.substring(0, equalIdx);
				var evalStr = rowrule.substring(equalIdx+1);
				calRowRule_single(oTable, rowmark, assignStr, evalStr);
			}
		});
	}
	
	/**
	 * 字段值变更触发当前行的行规则
	 */
	function calRowRule_valChange(groupid, trifieldid){
		var oTable = jQuery("table#oTable"+groupid);
		var rowcalStr = getAppointRuleStr(groupid, "rowcal");
		if(!!!rowcalStr)
			return;
		var reg = new RegExp("field\\d+_\\d+");
		trifieldid = trifieldid.replace("field_lable", "field");	//金额转换字段触发
		if(!reg.test(trifieldid))
			return;
		var trifield_id = trifieldid.substring(5, trifieldid.indexOf("_"));
		var rowmark = trifieldid.substring(trifieldid.indexOf("_")+1);
		var referFieldArr = new Array();		//存储参与行规则的字段数组，用于判断是否触发此项行规则
		referFieldArr.push("detailfield_"+trifield_id);
		var rowcalArr = rowcalStr.split(";");
		for(var i=0; i<rowcalArr.length; i++){
			var rowrule = rowcalArr[i];
			var equalIdx = rowrule.indexOf("=");
			if(equalIdx == -1)
				continue;
			var assignStr = jQuery.trim(rowrule.substring(0, equalIdx));
			var evalStr = jQuery.trim(rowrule.substring(equalIdx+1));
			var needTri = judgeNeedTriCalRow(evalStr, referFieldArr);
			if(needTri || assignStr.replace("detailfield_","") === trifield_id){
				calRowRule_single(oTable, rowmark, assignStr, evalStr);
				referFieldArr.push(assignStr);		//当前赋值字段再作为另一行规则取值字段情况，也需再次触发计算
			}
		}
	}
	
	/**
	 * 判断是否需要触发，取值串evalStr包含某个referFieldArr字段即需触发
	 */
	function judgeNeedTriCalRow(evalStr, referFieldArr){
		for(var i=0; i<referFieldArr.length; i++){
			var fieldStr = referFieldArr[i];
			var reg = new RegExp(fieldStr+"(?!\d+)");
			if(reg.test(evalStr))
				return true;
		}
		return false;
	}
	
	/**
	 * 某明细某行单个行规则计算
	 * oTable：明细表对象
	 * rowmark： 明细行标示
	 * assignStr： 赋值串
	 * evalStr： 取值串
	 */
	function calRowRule_single(oTable, rowmark, assignStr, evalStr){
		try{
			var reg = new RegExp("detailfield_\\d+");
			//解析赋值对象
			var assignFieldObj = jQuery();
			if(reg.test(assignStr)){
				var fieldstr = reg.exec(assignStr)[0];		//exec返回数组
				referRowAssignStr += ","+fieldstr;
				assignFieldId = fieldstr.replace("detailfield_", "field")+"_"+rowmark;
				assignFieldObj = oTable.find("input[name='"+assignFieldId+"']");
			}
			if(assignFieldObj.length === 0 || assignFieldObj.parent().is("div.detailRowHideArea"))		//赋值字段不存在，不触发计算
				return;
			//解析行规则取值串
			reg.compile("detailfield_\\d+", "g");
			var evalFieldArr = evalStr.match(reg);
			if(evalFieldArr == null)
				return;
			for(var i=0; i<evalFieldArr.length; i++){
				var fieldstr = evalFieldArr[i];
				var fieldid = fieldstr.replace("detailfield_", "field")+"_"+rowmark;
				var fieldObj = oTable.find("input[name='"+fieldid+"']");
				if(fieldObj.length === 0 || fieldObj.parent().is("div.detailRowHideArea"))		//取值字段不存在，不触发计算
					return;
				var fieldval = getFieldVal(fieldObj);
				var reg1 = new RegExp(fieldstr+"(?!\d)");		//正向否定预查，后面跟的不是数字才匹配
				evalStr = evalStr.replace(reg1, fieldval);
			}
			//获取计算结果
			var calResult = 0;
			try{
				if (evalStr.indexOf("--") > -1) {
					evalStr = evalStr.replace(/--/g, "+");
				}
				calResult = eval(evalStr);
				if(window.console)	console.log("calculate row rule success.【"+evalStr+"="+calResult+"】");
			}catch(e){}
			//计算结果赋值给目标字段
			setDetailFieldVal(assignFieldObj, calResult);
		}catch(e){
			if(window.console)	console.log("calculate row rule error"+e);
		}
	}
	
	/**
	 * 字段取值
	 */
	function getFieldVal(fieldObj){
		var fieldval = 0;
		try{
			var __fieldval = fieldObj.val().replace(/,/g, "");
			var reg = /^(-?\d+)(\.\d+)?$/;
			if(reg.test(__fieldval)){
				fieldval = parseFloat(__fieldval);
			}
		}catch(e){}
		return fieldval;
	}
	
	/**
	 * 明细字段赋值
	 */
	function setDetailFieldVal(fieldObj, calResult){
		if(fieldObj.length > 1)
			fieldObj = fieldObj.first();
		var fieldtype = fieldObj.attr("fieldtype");
		if(!!!fieldtype || fieldtype == "1")
			return;
		//结果值格式化
		var decimals = 0;
		if(fieldtype == "3" || fieldtype == "5" || fieldtype == "4"){
			decimals = 2;
			if(!!fieldObj.attr("datalength"))
				decimals = fieldObj.attr("datalength");
		}
		var isthousands = (fieldtype == "5") ? true :false;
		var setval = formatNumber(calResult, decimals, isthousands);
		var fieldid = fieldObj.attr("name");
		fieldObj.val(setval);		//字段赋值
		if(fieldtype == "4"){		//金额转换
			var field_labelid = fieldid.replace("field", "field_lable");
			var field_labelObj = jQuery("input#"+field_labelid);
			if(field_labelObj.length > 0){		//主读为disabled，结构一致
				var setval_chinese = numberChangeToChinese(setval);
				field_labelObj.val(setval_chinese);
				//控制必填
				checkinput3(field_labelid, fieldid+"span", fieldObj.attr("viewtype"));
			}
		}else{
			if(fieldObj.attr("type") == "hidden"){	//只读
				var fieldSpan = jQuery("span#"+fieldid+"span");
				if(fieldSpan.length > 0)
					fieldSpan.text(setval);
			}else{
				//控制必填
				checkinput2(fieldid, fieldid+"span", fieldObj.attr("viewtype"));
			}
		}
	}
	
	/**
	 * 给主字段赋值
	 */
	function setMainFieldVal(fieldid, detailSumVal){
		var fieldObj = jQuery("input[name='"+fieldid+"']");
		if(fieldObj.length == 0)
			return;
		if(fieldObj.length > 1)
			fieldObj = fieldObj.first();
		var fieldtype = fieldObj.attr("fieldtype");
		if(!!!fieldtype || fieldtype == "1")
			return;
		//结果值格式化
		var decimals = 0;
		if(fieldtype == "3" || fieldtype == "5" || fieldtype == "4"){
			decimals = 2;
			if(!!fieldObj.attr("datalength"))
				decimals = fieldObj.attr("datalength");
		}
		var isthousands = (fieldtype == "5") ? true :false;
		var setval = formatNumber(detailSumVal, decimals, isthousands);
		fieldObj.val(setval);		//字段赋值
		if(fieldtype == "4"){		//金额转换
			var field_labelid = fieldid.replace("field", "field_lable");
			var field_labelObj = jQuery("input#"+field_labelid);
			if(field_labelObj.length > 0){		//可编辑，只读情况下隐藏域绑有监听无需特殊处理
				var setval_thous = formatNumber(setval, decimals, true);
				field_labelObj.val(setval_thous);
				var setval_chinese = numberChangeToChinese(setval);
				jQuery("input#"+fieldid.replace("field", "field_chinglish")).val(setval_chinese);
				//控制必填
				checkinput2(field_labelid, field_labelid+"span", fieldObj.attr("viewtype"));
			}
		}else{
			if(fieldObj.attr("type") == "hidden"){		//只读
				var fieldSpan = jQuery("span#"+fieldid+"span");
				if(fieldSpan.length > 0)
					fieldSpan.text(setval);
			}else{
				//控制必填
				checkinput2(fieldid, fieldid+"span", fieldObj.attr("viewtype"));
			}
		}
	}
	
	/**
	 * 数字格式化
	 */
	function formatNumber(realval, decimals, isthousands){
		var regnum = /^(-?\d+)(\.\d+)?$/;
		if(!regnum.test(realval))
			realval = 0;
		realval = realval.toString();
		var formatval = "";
		if(decimals === 0){		//需取整
			formatval = Math.round(parseFloat(realval));
		}else{
			var pindex = realval.indexOf(".");
			var pointLength = pindex>-1 ? realval.substr(pindex+1).length : 0;	//当前小数位数
			if(decimals > pointLength){		//需补零
				formatval = pindex>-1 ? realval : realval+".";
				for(var i=0; i<decimals-pointLength; i++){
					formatval += "0";
				}
			}else if(decimals == pointLength){
				formatval = realval;
			}else{		//需四舍五入
				var realval_num = new Number(realval);
				formatval = toFix(realval_num,decimals);
			}
		}
		formatval = formatval.toString();
		if(isthousands && !!formatval){
			if(formatval.indexOf(".")<0)
	        	re = /(\d{1,3})(?=(\d{3})+($))/g;
	     	else
	        	re = /(\d{1,3})(?=(\d{3})+(\.))/g;
			formatval = formatval.replace(re, "$1,");
		}
		return formatval;
	}
	
	
	return {
		initCalRuleCfg: function(formcalrule){
			try{
				calRuleCfg = JSON.parse(formcalrule);
				//if(window.console)	console.dir(calRuleCfg);
			}catch(e){
				if(window.console)	console.log("initCalRuleCfg error"+e);
			}
		},
		calSumFun: function(groupid){
			return calSumFun(groupid);
		},
		calRowRule_allRow: function(groupid){
			return calRowRule_allRow(groupid);
		},
		calRowRule_valChange: function(groupid, trifieldid){
			return calRowRule_valChange(groupid, trifieldid)
		}
	}

})();