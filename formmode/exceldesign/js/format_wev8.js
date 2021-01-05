/**
 * 根据format属性对字段值格式化，隐藏原对象并显示format对象
 * @param triggerFlag 1为失去原对象焦点触发；2为onpropertychange触发
 */
function showFormatObj(vthis,triggerFlag){
	try{
		var curObj=jQuery(vthis);
		var fieldid=curObj.attr("id");		//获取input对象的fieldid
		
		//onpropertychange触发判定
		if(triggerFlag===2 && jQuery(vthis).attr("type")!="hidden"){
			//IE下非value改变不继续触发
			if(jQuery.browser.msie && window.ActiveXObject && window.event){
				var propertyName = window.event.propertyName;
				if(window.console)	console.log(propertyName+"---"+!!!propertyName+"---"+(propertyName != 'value'));
				if(!!!propertyName || propertyName != 'value')
					return;
			}
			try{	//页面加载触发时IE获取document.activeElement直接抛异常，why...
				//输入中input不继续触发
				var activeElm = document.activeElement;
				if(typeof(activeElm) != "undefined"){
					if(window.console)	console.log(activeElm.tagName+"---"+activeElm.id+"---"+fieldid)
					if(activeElm.tagName.toUpperCase()=="INPUT" && (activeElm.id=="" || activeElm.id==fieldid))
						return;
					//if(activeElm.tagName.toUpperCase()=="TD" && activeElm.id.indexOf(fieldid)>-1)
					//	return;		//IE下浮点数focus方法改变value触发，activeElm定位到TD
				}
			}catch(e){
				if(window.console)	console.log("IE--Get--document.activeElement--error");
			}
		}
		if(window.console)	console.log(triggerFlag+"---触发--only one time")
		
		var realval=curObj.val();
		var format=curObj.attr("_format");
		if(!!format){		//值为空也需触发
			var formatJSON=eval("({"+format+"})");
			if(curObj.attr("datavaluetype")=="5"){		//千分位字段先去掉逗号
				realval=realval.replace(/,/g,"");
			}
			dynamicFormatObj(fieldid,realval,formatJSON,triggerFlag);	//获取format后的值
		}
	}catch(e){
		if(window.console)	console.log("showFormatObj---"+triggerFlag+"---error");
	}
}

/**
 * onfocus触发，隐藏format的input对象，显示原input对象
 */
function showRealObj(vthis){
	var fieldid=jQuery(vthis).attr("id").replace("_format","");
	var realField=jQuery("#"+fieldid);
	if(realField.css("display") == "none"){
		jQuery(vthis).hide();
		realField.show().focus();
		setFocusPointEnd(realField);
	}
}

//设置鼠标焦点到input最后位置
function setFocusPointEnd(realField){
	try{
		var length = realField.val().length;
		if(jQuery.browser.msie){
			var rtextRange = realField[0].createTextRange();
			rtextRange.moveStart('character', length);
			rtextRange.collapse(true);
			rtextRange.select();
		}else{
			realField[0].setSelectionRange(length, length);
		}
	}catch(e){}
}

/**
 * 同步修改Format对象
 */
function dynamicFormatObj(fieldid,realval,formatJSON,triggerFlag){
	try{
		var dynamicfun = function(){
			if(formatval==""){
				formatval = realval;
			}
			var curObj = jQuery("#"+fieldid);
			var formatObj = null;
			if(curObj.attr("type") == "hidden"){		//隐藏input联动修改span值
				//先找_format的span，找不到则找原对象
				formatObj = jQuery("#"+fieldid+"span_format");
				if(formatObj.size() == 0)			
					formatObj = jQuery("#"+fieldid+"span");
				
				window.setTimeout(function(){
					formatObj.text(formatval);
				},300);
			}else if(curObj.attr("type") == "text"){	//显示input联动切换input对象
				formatObj = jQuery("#"+fieldid+"_format");
				
				formatObj.val(formatval);
				if(triggerFlag === 1){
					curObj.hide();
					var formatstyle = curObj.attr("style");
					if(formatJSON["numberType"]=="2" && (formatJSON["formatPattern"]=="1" || formatJSON["formatPattern"]=="4"))
						formatstyle += ";color:red !important;";		//数值格式化为红色
					formatObj.attr("style", formatstyle).show();
				}
			}
		};
		
		var formatval="";
		var numberType=parseInt(formatJSON["numberType"]);
		if(numberType===1){			//1常规
		}else if(numberType===2){	//2数值
			formatval=formatValue_float(realval,formatJSON["decimals"],formatJSON["thousands"],formatJSON["formatPattern"]);
			dynamicfun();
		}else if(numberType===3){	//3日期
			jQuery.ajax({
				type:"POST",
				url:"/formmode/exceldesign/excelAjaxData.jsp?src=formatToDate&realVal="+realval+"&formatPattern="+formatJSON["formatPattern"],
				success:function(res){
					formatval=jQuery.trim(res);
					dynamicfun();
				}
			});
		}else if(numberType===4){	//4时间
			jQuery.ajax({
				type:"POST",
				url:"/formmode/exceldesign/excelAjaxData.jsp?src=formatToTime&realVal="+realval+"&formatPattern="+formatJSON["formatPattern"],
				success:function(res){
					formatval=jQuery.trim(res);
					dynamicfun();
				}
			});
		}else if(numberType===5){	//5百分比
			jQuery.ajax({
				type:"POST",
				url:"/formmode/exceldesign/excelAjaxData.jsp?src=formatToPercent&realVal="+realval+"&decimals="+formatJSON["decimals"],
				success:function(res){
					formatval=jQuery.trim(res);
					dynamicfun();
				}
			});
		}else if(numberType===6){	//6科学计数
			jQuery.ajax({
				type:"POST",
				url:"/formmode/exceldesign/excelAjaxData.jsp?src=formatToScience&realVal="+realval+"&decimals="+formatJSON["decimals"],
				success:function(res){
					formatval=jQuery.trim(res);
					dynamicfun();
				}
			});
		}else if(numberType===7){	//7文本
		}else if(numberType===8){	//8特殊
			jQuery.ajax({
				type:"POST",
				url:"/formmode/exceldesign/excelAjaxData.jsp?src=formatToSpecial&realVal="+realval+"&formatPattern="+formatJSON["formatPattern"],
				success:function(res){
					formatval=jQuery.trim(res);
					dynamicfun();
				}
			});
		}else if(numberType===99){	//	财务格式-金额大写
			jQuery.ajax({
				type:"POST",
				url:"/formmode/exceldesign/excelAjaxData.jsp?src=formatToMoneyUpper&realVal="+realval,
				success:function(res){
					formatval=jQuery.trim(res);
					dynamicfun();
				}
			});
		}
	}catch(e){
		if(window.console)	console.log(fieldid+"format error");
	}
}

/**
 * 设置-数值format
 */
function formatValue_float(realval,decimals,thousands,formatPattern){
	var regnum = /^(-?\d+)(\.\d+)?$/;
	if(!regnum.test(realval)){
		return realval;
	}
	realval = realval.toString();
	var formatval = "";
	if(decimals === 0){		//需取整
		formatval = Math.round(parseFloat(realval));
	}else{
		var pindex = realval.indexOf(".");
		var pointLength = pindex>-1 ? realval.substr(pindex+1).length : 0;	//当前小数位数
		if(decimals >= pointLength){		//需补零
			formatval = pindex>-1 ? realval : realval+".";
			for(var i=0; i<decimals-pointLength; i++){
				formatval += "0";
			}
		}else{		//需四舍五入
			var realval_num = new Number(realval);
			formatval = realval_num.toFixed(decimals);
		}
	}
	formatval = formatval.toString();
	var index = formatval.indexOf(".");
	var intPar = index>-1 ? formatval.substring(0,index) : formatval;
	var pointPar = index>-1 ? formatval.substring(index) : "";
	//取绝对值
	if(formatPattern==3 || formatPattern==4){		//负数变正数
		intPar = Math.abs(intPar).toString();
	}
	if(thousands===1){				//整数位format成千分位
   		var reg1 = /(-?\d+)(\d{3})/;
        while(reg1.test(intPar)) {   
        	intPar = intPar.replace(reg1, "$1,$2");   
        } 
	}
	formatval = intPar + pointPar;
	return formatval;
}



/**************新表单设计器-财务字段相关JS-begin*************/

function editFinancialField(vthis){
	var fieldid=jQuery(vthis).attr("id").replace("_fdiv","");
	var field_textObj = jQuery(vthis).closest("td").find("input[type='text'][name='"+fieldid+"']");
	if(field_textObj.size()>0){		//含input编辑区才可切换编辑
		jQuery(vthis).css("display","none");
		field_textObj.css("display","").focus();
	}
}

function showFinancialField(vthis){
	var fieldid = jQuery(vthis).attr("name");
	fin_dynamicChangeVal(fieldid);
	if(jQuery(vthis).attr("type")=="text"){
		jQuery(vthis).css("display","none");
	}
	jQuery("div#"+fieldid+"_fdiv").css("display","");
}

function dynamicFinancialField(vthis){
	var fieldid = jQuery(vthis).attr("name");
	fin_dynamicChangeVal(fieldid);
}

function fin_dynamicChangeVal(fieldid){
	var inputObj = jQuery("[name='"+fieldid+"']");
	var fieldVal = jQuery.trim(inputObj.val());
	if(inputObj.attr("datavaluetype")=="5"){
		fieldVal = fieldVal.replace(/,/g,"");
	}
	var valArr = new Array();			
	var reg1 = /^(-?\d+)(\.\d+)?$/;
	var reg2 = /^(-?\d*)(\.\d+)$/;		//解决类型-.22这种格式
	if(reg1.test(fieldVal)||reg2.test(fieldVal)){
		fieldVal = parseFloat(fieldVal).toFixed(2);
		if((fieldVal.length>2&&fieldVal.substring(0,2)=="0.")
			||(fieldVal.length>3&&fieldVal.substring(0,3)=="-0.")){
			fieldVal = fieldVal.replace("0.",".");
		}
		for(var i=fieldVal.length-1;i>=0;i--){
			var valc = fieldVal.charAt(i);
			if(valc!=".")	valArr.push(valc);
		}
	}
	
	var fin_table = jQuery("div#"+fieldid+"_fdiv table");
	var index = 0;
	for(var i=fin_table.find("td").size()-1;i>=0;i--,index++){
		var fin_td = fin_table.find("td:eq("+i+")");
		fin_td.html("");
		if(valArr.length==0){
			if(inputObj.attr("viewtype")=="1"&&index==0){
				fin_td.html("<img src='/images/BacoError_wev8.gif' align='absmiddle' />");
			}
		}else{
			if(index<valArr.length){
				fin_td.html(valArr[index]);	
			}
		}
	}
}

function fin_dynamicChangeSumVal(vthis){
	var sumid = jQuery(vthis).attr("name");
	var sumVal = jQuery.trim(jQuery(vthis).val());
	var valArr = new Array();
	if(sumVal!=""){
		sumVal = sumVal.replace(/,/g,"");
		sumVal = parseFloat(sumVal).toFixed(2);
		if((sumVal.length>2&&sumVal.substring(0,2)=="0.")
			||(sumVal.length>3&&sumVal.substring(0,3)=="-0.")){
			sumVal = sumVal.replace("0.",".");
		}
		for(var i=sumVal.length-1;i>=0;i--){
			var valc = sumVal.charAt(i);
			if(valc!=".")	valArr.push(valc);
		}
	}
	
	var fin_table = jQuery("div#"+sumid+"_fdiv table");
	var index = 0;
	for(var i=fin_table.find("td").size()-1;i>=0;i--,index++){
		var fin_td = fin_table.find("td:eq("+i+")");
		fin_td.html("");
		if(index<valArr.length){
			fin_td.html(valArr[index]);	
		}
	}
}
/**************新表单设计器-财务字段相关JS-end*************/
