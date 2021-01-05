var formatUtil = {
	convertValue: function(realval,formatJSON){
		try{
			var formatval="";
			var numberType=parseInt(formatJSON["numberType"]);
			if(numberType===1){			//1常规
			}else if(numberType===2){	//2数值
				var transQfw = parseInt(formatJSON["thousands"]||0) === 1;
				var transAbs = formatJSON["formatPattern"] == "3" || formatJSON["formatPattern"] == "4";
				if(parseInt(formatJSON["decimals"]) < 0 ){
					return realval;
				}
				formatval = formatFloatValue(realval, parseInt(formatJSON["decimals"]), transQfw, transAbs);
			}else if(numberType===3){	//3日期
				formatval = this.formatToDate(realval,formatJSON["formatPattern"]);
			}else if(numberType===4){	//4时间
				formatval = this.formatToTime(realval,formatJSON["formatPattern"]);
			}else if(numberType===5){	//5百分比
				formatval = this.formatToPercent(realval,formatJSON["decimals"]);
			}else if(numberType===6){	//6科学计数
				formatval = this.formatToScience(realval,formatJSON["decimals"]);
			}else if(numberType===7){	//7文本
			}else if(numberType===8){	//8特殊
				formatval = this.formatToSpecial(realval,formatJSON["formatPattern"]);
			}else if(numberType===99){//99 金额大写
                formatval = numberConvertChinese(realval);
			}
			return formatval;
		}catch(e){
			if(window.console)	console.log("format error:"+ e);
			return realval;
		}
	},
	formatToDate: function(realVal,formatPattern){
		var pattern  =  new RegExp("^\\d{2,4}-\\d{1,2}-\\d{1,2}$");
		if(!pattern.test(realVal)){
			return realVal;
		}
		/**
		 * formatPattern
		 * 1：yyyy/MM/dd
		 * 2：yyyy-MM-dd
		 * 3：yyyy年MM月dd日
		 * 4：yyyy年MM月
		 * 5：MM月dd日
		 * 6：EEEE
		 * 7：日期大写
		 * 8：yyyy/MM/dd hh:mm a
		 * 9：yyyy/MM/dd HH:mm
		 */
		var arr = realVal.split("-");
		var year =  arr[0];
		var month = arr[1];
		var day = arr[2];
		if(parseInt(month) > 12 || parseInt(day) > 31 || parseInt(year) <= 0 || parseInt(month) <= 0 || parseInt(day) <= 0){
			return realVal;
		}
		if(year.length == 2) year = "00"+year;
		if(year.length == 3) year = "0"+year;
		if(month.length == 1) month = "0"+month;
		if(day.length == 1) day = "0"+day;
		realVal = year + "-" + month + "-" + day;
		if(new Date(realVal).toString().indexOf("undefined") > -1){		//解决IE下类似不存在的日期2014-9-31通过new Date无法生成日期问题，chrome下默认取的下一天
			return realVal;
		}
		
		switch(parseInt(formatPattern)){
			case 1:
				return this.formatDate(new Date(realVal),"yyyy/MM/dd");
			case 2:
				return this.formatDate(new Date(realVal),"yyyy-MM-dd");
			case 3:
				return this.formatDate(new Date(realVal),"yyyy年MM月dd日");
			case 4:
				return this.formatDate(new Date(realVal),"yyyy年MM月");
			case 5:
				return this.formatDate(new Date(realVal),"MM月dd日");
			case 6:
				return this.formatDate(new Date(realVal),"wwww");	
			case 7:
				return this.dataToChinese(new Date(realVal));
			case 8:
				return this.formatDate(new Date(realVal),"yyyy/MM/dd 12:00 a");		
			case 9:
				return this.formatDate(new Date(realVal),"yyyy/MM/dd 00:00");
			default:
				return realVal;
		}
	},
	formatDate: function(date, fmt){
		fmt = fmt || 'yyyy-MM-dd HH:mm:ss';
		var obj = {
			'y': date.getFullYear(), // 年份，注意必须用getFullYear
			'M': date.getMonth() + 1, // 月份，注意是从0-11
			'd': date.getDate(), // 日期
			'q': Math.floor((date.getMonth() + 3) / 3), // 季度
			'w': date.getDay(), // 星期，注意是0-6
			'H': 12, // 24小时制
			'h': 12, // 12小时制
			'm': 0, // 分钟
			's': 0, // 秒
			'S': 0, // 毫秒
			'a': 'AM'
		};
		var week = ['天', '一', '二', '三', '四', '五', '六'];
		for(var i in obj){
			fmt = fmt.replace(new RegExp(i+'+', 'g'), function(m){
				var val = obj[i] + '';
				if(i == 'a') return val;
				if(i == 'w') return (m.length > 2 ? '星期' : '周') + week[val];
				for(var j = 0, len = val.length; j < m.length - len; j++) val = '0' + val;
				return m.length == 1 ? val : val.substring(val.length - m.length);
			});
		}
		return fmt;
	},
	dataToChinese: function(date){
		var arr =  ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九"];
    	var year  = date.getFullYear();
    	var month = date.getMonth() + 1;
		var day = date.getDate();
    	var tempYear = year.toString().split('').map((o)=>{
    		return arr[parseInt(o)];
    	}).toString();
    	return (tempYear + "年" + this.convertNumToChinese(month) + "月" + this.convertNumToChinese(day) + "日").replace(/\,/g,'');
	},
	convertNumToChinese: function(num){
		var arr1 = ["", "", "二", "三"];
		var arr2 = ["", "一", "二", "三", "四", "五", "六", "七", "八", "九"];
		num = num<10 ? "0"+num.toString() : num.toString();
		var first = parseInt(num.toString().split("")[0]);
		var second = parseInt(num.toString().split("")[1]);
		return arr1[first] + (first > 0 ? "十" : "") + arr2[second];
	},
	formatToTime: function(realVal,formatPattern){
		var pattern  =  new RegExp("^(\\d{1,2}:\\d{1,2})(:\\d{1,2})?$");
		if(!pattern.test(realVal)){
			return realVal;
		}
		/**
		 * formatPattern
		 * 1：HH:MI:SS
		 * 2：HH:MI:SS AM/PM
		 * 3：HH:MI
		 * 4：HH:MI AM/PM
		 * 5：HH时MI分SS秒
		 * 6：HH时MI分
		 * 7：HH时MI分SS秒 AM/PM
		 * 8：HH时MI分 AM/PM
		 **/
		var realValArr = realVal.split(":");
		var hour  = realValArr[0];
		var minute = realValArr[1];
		var separatorChar = ":";
		var suffix  = parseInt(hour) < 12 ? " AM":" PM";
		switch(parseInt(formatPattern)){
			case 1:
				return hour + separatorChar +  minute + separatorChar + "00";
			case 2:
				return hour + separatorChar +  minute + separatorChar + "00" +　suffix;
			case 3:
				return hour + separatorChar +  minute;
			case 4:
				return hour + separatorChar +  minute + suffix;
			case 5:
				return hour + "时" + minute + "分00秒"; 
			case 6:
				return hour + "时" + minute + "分";
			case 7:
				return hour + "时" + minute + "分00秒" + suffix;
			case 8:
				return hour + "时" + minute + "分" + suffix;
			default:
				return realVal;
		}
	},
	formatToPercent: function(realVal,decimals){	//转百分比
		var pattern  =  new RegExp("^(-?\\d+)(\\.\\d+)?$");
		if(!pattern.test(realVal)){
			return realVal;
		}
		return formatFloatValue(Number(realVal) * 100,parseInt(decimals),false) + "%";
	},
	formatToScience: function(realVal,decimals){	//转科学计数
		var pattern  =  new RegExp("^(-?\\d+)(\\.\\d+)?$");
		if(!pattern.test(realVal)){
			return realVal;
		}
		var result = Number(realVal).toExponential(decimals).toUpperCase();
		result = result.replace(/E(\+|-)(\d){1}$/, "E$10$2");	//补零
		return result;
	},
	formatToSpecial: function(realVal,formatPattern){
		var pattern  =  new RegExp("^(-?\\d{1,12})(\\.\\d+)?$");
		if(!pattern.test(realVal)){
			return realVal;
		}
		if(parseInt(formatPattern) === 1){
			var digit = ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九"];
			var unit = [["", "万", "亿"],["", "十", "百", "千"]];
			return this.specialTrans(realVal,digit,unit);
		}else{
			var digit = ["零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"];
			var unit = [["", "万", "亿"],["", "拾", "佰", "千"]];
			return this.specialTrans(realVal,digit,unit);
		}
	},
	specialTrans: function(realVal,digit,unit){
		realVal = parseFloat(realVal).toString();
		if(parseFloat(realVal) === 0){
			return digit[0];
		}
		var headfix = "";
		var intPar_t = "";
		var pointPar_t = "";
		
		if(parseFloat(realVal) < 0){
			realVal = realVal.substring(1);		
			headfix = "-";
		}
		var realValArr = realVal.split(".");
		var intPar  = realValArr[0].trim();
		while(intPar.length > 0 && parseInt(intPar[0]) === 0 ){
			intPar = intPar.substr(1);
		}
		var pointPar = realValArr.length === 2 ?realValArr[1].trim() : "";
		var lastflag =  false;
		var intParArr = intPar.length > 0 ? intPar.toString().split('') : [];
		var pointParArr = pointPar.length > 0 ? pointPar.toString().split(''):[];
		var j = 0;
		
		pointPar_t = pointPar.length > 0 ? "." : pointPar_t;
		pointParArr.map(v=>{
			pointPar_t = pointPar_t + digit[parseInt(v)];
		});
		
		for(var i=intParArr.length - 1;i >= 0 ;i--,j++ ){
			var v = parseInt(intParArr[i]);
			var m  = j%4;
			if(m === 0){
				lastflag = false;
				intPar_t = unit[0][j/4]+intPar_t;
			}
			
			if(v === 0){
				if(lastflag && intPar_t[0] === digit[0]) {
					intPar_t = digit[v]+intPar_t;
				}
			}else{
				lastflag = true;
				intPar_t = digit[v] + unit[1][m] + intPar_t;
			}
		}
		intPar_t =  intPar_t.trim().length === 0 ? digit[0] : intPar_t;
		return headfix + intPar_t + pointPar_t;
	}
}


function judgeValueIsNumber(val){
    if(val === null || typeof val === "undefined")
        return false;
    var reg = /^(-?\d+)(\.\d+)?$/;
    return reg.test(val.toString());
}


/**
 * 数值转换(精度、千分位)等
 * @param {String} realval   真实值
 * @param {int} decimals  精度
 * @param {Boolean} transQfw  是否千分位
 * @param {Boolean} transAbs  是否绝对值
 */
function formatFloatValue(realval, decimals, transQfw, transAbs){
	if(!judgeValueIsNumber(realval))     //非数值直接返回原始值
		return realval;
    realval = realval.toString();
	var formatval = "";
	if(decimals === 0){		//需取整
		formatval = Math.round(parseFloat(realval)).toString();
	}else{
        var n = Math.pow(10, decimals);
        formatval = (Math.round(parseFloat(realval)*n)/n).toString();
		var pindex = formatval.indexOf(".");
		var pointLength = pindex>-1 ? formatval.substr(pindex+1).length : 0;	//当前小数位数
		if(decimals > pointLength){		//需补零
            if(pindex == -1)
			    formatval += ".";
			for(var i=0; i<decimals-pointLength; i++){
				formatval += "0";
			}
		}
	}
	var index = formatval.indexOf(".");
	var intPar = index>-1 ? formatval.substring(0,index) : formatval;
	var pointPar = index>-1 ? formatval.substring(index) : "";
	//取绝对值
	if(transAbs === true){		//取绝对值
		intPar = Math.abs(intPar).toString();
	}
	if(transQfw === true){				//整数位format成千分位
   		var reg1 = /(-?\d+)(\d{3})/;
        while(reg1.test(intPar)) {   
        	intPar = intPar.replace(reg1, "$1,$2");   
        } 
	}
	formatval = intPar + pointPar;
	return formatval;
}


function toChinese(num, index,cn,unit,start) {
        var num = num.replace(/\d/g, function($1) {
            return cn.charAt($1) + unit[index].charAt(start-- % 4 ? start % 4 : -1);
        });
        return num;
}

//数字转金额大写
function numberConvertChinese(num){
  try{
    if(!judgeValueIsNumber(num))
        return "";
    var amount_convert_unit = "圆";
    if(typeof num === "string")
        num = parseFloat(num);
    var prefh = "";
    if(num < 0) {
        prefh = "负";
        num = Math.abs(num);
    }
    if(num > Math.pow(10, 12))
        return "";
    var cn = "零壹贰叁肆伍陆柒捌玖";
    var unit = new Array("拾佰仟", "分角");
    var unit1 = new Array("万亿万", "");
    var numArray = num.toString().split(".");
    var start = new Array(numArray[0].length - 1, 2);
    for(var i = 0; i < numArray.length; i++) {
        var tmp = "";
        for(var j = 0; j * 4 < numArray[i].length; j++) {
            var strIndex = numArray[i].length - (j + 1) * 4;
            var str = numArray[i].substring(strIndex, strIndex + 4);
            var start = i ? 2 : str.length - 1;
            var tmp1 = toChinese(str, i,cn,unit,start);
            tmp1 = tmp1.replace(/(零.)+/g, "零").replace(/零+$/, "");
            tmp = (tmp1 + unit1[i].charAt(j - 1)) + tmp;
        }
        numArray[i] = tmp;
    }
    numArray[1] = numArray[1] ? numArray[1] : "";
    numArray[0] = numArray[0] ? numArray[0] + amount_convert_unit : numArray[0];
    numArray[1] = numArray[1].replace(/^零+/, "");
    numArray[1] = numArray[1].match(/分/) ? numArray[1] : numArray[1] + "整";
    var money = numArray[0] + numArray[1];
    money = money.replace(/(亿万)+/g, "亿");
    if(money == "整") {
        money = "零"+amount_convert_unit+"整";
    } else {
        money = prefh + money;
    }
  }catch(e){
  }
    return money;
}


function showChangeRealValue(obj,key,formulaobj){
	if($(obj).attr("id")!=null && $(obj).attr("id")!= undefined && $(obj).attr("id").indexOf("_d")!=-1){
		  key = key+"_d";
	}
    if($("#field"+key).attr("onblur")!=null&&$("#field"+key).attr("onblur")!=undefined){
		 $("#field"+key).trigger("onblur");  
	}

    if($("#field"+key).attr("onfocus")!=null&&$("#field"+key).attr("onfocus")!=undefined){
		 $("#field"+key).trigger("onfocus");  
	}

	if($("#field"+key).attr("onchange")!=null&&$("#field"+key).attr("onchange")!=undefined){
		 $("#field"+key).trigger("onchange");  
	}
   var realval=$(obj).val();
   var objfommula=JSON.parse($(obj).attr("fomulastr"));
   var colorStyle="";
   if(objfommula.numberType=='2'&&(objfommula.formatPattern=='1'||objfommula.formatPattern=='4')){
          colorStyle = "color:red !important";       
   }else{
        colorStyle="";
   }
  var formatVal=formatUtil.convertValue(realval,objfommula);
  if(formatVal==""){
	  $("#field"+key).val("");
	$("#field"+key).attr("value","");
	$(obj).val(formatVal);
  }else{
	          
    $("#field"+key).val(realval);
	$("#field"+key).attr("value",realval);
	$(obj).css("cssText",colorStyle);
	$(obj).val(formatVal);
  }

  if($(obj).attr("id")!=null && $(obj).attr("id")!= undefined && $(obj).attr("id").indexOf("_d")!=-1){
	  try{
		  if($("#field"+key).attr("onchange")!=null&&$("#field"+key).attr("onchange")!=undefined){
			 $("#field"+key).trigger("onchange");  
		  }  
		  $("#fieldformart"+key.replace("_d","")).val(formatVal);
		  $("#fieldformart"+key.replace("_d","")).attr("value",formatVal);
	  }catch(e){}
      $("#"+$("#"+key.replace("_d","").replace("_","")).val()).css("cssText",colorStyle);
	  $("#"+$("#"+key.replace("_d","").replace("_","")).val()).html(formatVal);
  }

}


function showFocusRealValue(obj,key){
	if($(obj).attr("id")!=null && $(obj).attr("id")!= undefined && $(obj).attr("id").indexOf("_d")!=-1){
		  key = key+"_d";
	}
	 $(obj).val($("#field"+key).val().replace(/,/g, ""));
}


function formartFieldValue(key,_format,trrowindex){
	   var datatype = "";
	   if($("#field"+key+trrowindex).attr("datatype") != null && $("#field"+key+trrowindex).attr("datatype") != undefined){
		  datatype = " datatype=\""+$("#field"+key+trrowindex).attr("datatype")+"\"";
	   }
		var datetype = "";
		if($("#field"+key+trrowindex).attr("datetype") != null && $("#field"+key+trrowindex).attr("datetype") != undefined){
			datetype = " datetype=\""+$("#field"+key+trrowindex).attr("datetype")+"\"";
		}
		var datavaluetype="";
		var isdatavaluetype="";
		if($("#field"+key+trrowindex).attr("datavaluetype") != null && $("#field"+key+trrowindex).attr("datavaluetype") != undefined){
			datavaluetype = " datavaluetype=\""+$("#field"+key+trrowindex).attr("datavaluetype")+"\"";
			isdatavaluetype = $("#field"+key+trrowindex).attr("datavaluetype");
		}
		var datalength="";
		if($("#field"+key+trrowindex).attr("datalength") != null && $("#field"+key+trrowindex).attr("datalength") != undefined){
			 datalength = " datalength=\""+$("#field"+key+trrowindex).attr("datalength")+"\"";
		}

	   var realval=$("#field"+key+trrowindex).val();
	   realval=realval.replace(/,/g, "");

	   var formatval= formatUtil.convertValue(realval,_format);



		var onkeypress="";
	    if($("#field"+key+trrowindex).attr("onkeypress") != null && $("#field"+key+trrowindex).attr("onkeypress") != undefined){
		    onkeypress = " onkeypress=\""+$("#field"+key+trrowindex).attr("onkeypress").replace("field","fieldformart")+"\"";
		}
         
		var colorStyle="";
		if(_format.numberType=='2'&&(_format.formatPattern=='1'||_format.formatPattern=='4')){
           colorStyle = "color:red !important";        
        }else{
		    colorStyle = "";
		}
        if(isdatavaluetype!='4'){
			if( $("#field"+key+trrowindex+"_span").length>0){
				if($("#fieldformart"+key+trrowindex).length<=0){
					 $("#field"+key+trrowindex).after("<span style=\""+colorStyle+"\" id=\"fieldformart"+key+trrowindex+"\" fomulastr="+JSON.stringify(_format)+" name=\"fieldformart"+key+trrowindex+"\"  value=\""+formatval+"\" "+datatype+" "+datetype+" "+datavaluetype+"  "+datalength+"  "+onkeypress+" onfocus=\"showFocusRealValue(this,'"+key+trrowindex+"')\"  onblur=\"showChangeRealValue(this,'"+key+trrowindex+"');\"  >"+formatval+"</span>");  
			         $("#field"+key+trrowindex+"_span").hide();
					 $("#field"+key+trrowindex+"_span").attr("value",formatval);
				}
			}else{
			  if(trrowindex!=''&&$("input[id='field"+key+trrowindex+"'][type='hidden']").length>0){
				  if($("#fieldformart"+key+trrowindex).length<=0){
					  $("#field"+key+trrowindex).after("<input type=\"hidden\" id=\"fieldformart"+key+trrowindex+"\" fomulastr="+JSON.stringify(_format)+" name=\"fieldformart"+key+trrowindex+"\"  value=\""+formatval+"\" "+datatype+" "+datetype+" "+datavaluetype+"  "+datalength+"  "+onkeypress+" onfocus=\"showFocusRealValue(this,'"+key+trrowindex+"')\"  onblur=\"showChangeRealValue(this,'"+key+trrowindex+"');\"   />");
				      $("#fieldformart"+key+trrowindex).attr("value",formatval);
				  }
			  }else{
				   if($("#fieldformart"+key+trrowindex).length<=0){
			         $("#field"+key+trrowindex).after("<input type=\"text\" style=\""+colorStyle+"\" id=\"fieldformart"+key+trrowindex+"\" fomulastr="+JSON.stringify(_format)+" name=\"fieldformart"+key+trrowindex+"\"  value=\""+formatval+"\" "+datatype+" "+datetype+" "+datavaluetype+"  "+datalength+"  "+onkeypress+" onfocus=\"showFocusRealValue(this,'"+key+trrowindex+"')\"  onblur=\"showChangeRealValue(this,'"+key+trrowindex+"');\"  />");
			         $("#fieldformart"+key+trrowindex).attr("value",formatval);
				   }
			  }
			}
			 $("#field"+key+trrowindex).hide();
			 $("#"+$("#"+(key+trrowindex).replace("_","")).val()).css("cssText",colorStyle);
			 $("#"+$("#"+(key+trrowindex).replace("_","")).val()).html(formatval);
		}
}


function formulaDetailTrigger(vthis,rowindex){

	try{
		if(typeof(triTag) == "undefined"){		//onpropertychange、_listener触发
			triTag = "";
			if(jQuery.browser.msie && window.event){
				var propertyName = window.event.propertyName;
				if(!!!propertyName || propertyName != 'value')
					return;
			}
		}
		var triggerFieldid = jQuery(vthis).attr("name").replace("field","").replace("_d","");
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
							calculate_special_detailfield(destcell, formulatxt, cellrange, triTag);
						}else{
							calculate_detailSumVal(destcell,formulatxt,cellrange, triTag);
						}
					}else{											//取值字段全部为主表字段
						calculate_single(destcell,formulatxt,cellrange,false,"", triTag);
					}
				}else{												//赋值给明细表字段
					if(formulatxt.match(/(MAIN|TAB_\d+)\./g)){		//取值字段包含主表字段
						var triggerCellAttr = jQuery("td[_fieldid='"+triggerFieldid+"']").attr("_cellattr");
						if(triggerCellAttr.indexOf("DETAIL_")==-1){	//触发字段为主字段，需计算明细所有行记录
							calculate_detailAllRow(destcell,formulatxt,cellrange, triTag);
						}else{										//触发字段为明细字段，则只计算当前行
							calculate_single(destcell,formulatxt,cellrange,true,triggerFieldid, triTag);
						}
					}else{											//取值字段全部为明细表字段
						 calculate_single(destcell,formulatxt,cellrange,true,triggerFieldid, triTag);
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


function formuaAttrShowDetail(trrowindex){
	for(var key in formulaattr){
		  if(key.indexOf("_")!=-1){ //明细字段
			  if($("#field"+key+trrowindex).length>0){
				 var formulaobj=JSON.parse(formulaattr[key]);
                 if(formulaobj._format){ //格式化
                    formartFieldValue(key,formulaobj._format,trrowindex);
				 }
				  if(formulaobj._formula){ //公式
					  try{
						  var count = 0;
						   var fieldattrchange=$("#field"+key+trrowindex).attr("onchange");
						  if(fieldattrchange!=null && fieldattrchange != undefined && fieldattrchange.indexOf("formulaDetailTrigger")==-1){
									$("#field"+key+trrowindex).attr("onchange","formulaDetailTrigger(this,'"+trrowindex+"');"+fieldattrchange);
									count++;
						  }
						  var fieldattrblur=$("#field"+key+trrowindex).attr("onblur");
						  if(fieldattrblur!=null && fieldattrblur != undefined && fieldattrblur.indexOf("formulaDetailTrigger")==-1&&count==0){
						 			$("#field"+key+trrowindex).attr("onblur","formulaDetailTrigger(this,'"+trrowindex+"');"+fieldattrblur);
						  }
					  }catch(e){}
				   }
			  }
		  }
	}
    
}


//公式与格式转化大写与小写，大写金额
function formuaAttrShow(){
     for(var key in formulaattr){
	     if(key.indexOf("_")==-1){ //明细字段
			  if($("#field"+key).length>0){
				  var formulaobj=JSON.parse(formulaattr[key]);
				   if(formulaobj._format){ //格式化
					   formartFieldValue(key,formulaobj._format,"");
				   }
				   if(formulaobj._formula){ //公式
						  var fieldattrchange=$("#field"+key).attr("onblur");
						  if(fieldattrchange!=null && fieldattrchange != undefined && fieldattrchange.indexOf("formulaTrigger")==-1){
						 			$("#field"+key).attr("onblur","formulaTrigger(this);"+fieldattrchange);
						  }

                        var fieldattrchange=$("#field"+key).attr("onchange");
						if(fieldattrchange!=null && fieldattrchange != undefined && fieldattrchange.indexOf("formulaTrigger")==-1){
								$("#field"+key).attr("onchange","formulaTrigger(this);"+fieldattrchange);
						}
				   }
			  }
		 }
	 }
   
}