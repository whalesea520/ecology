// 判断input框中是否输入的是小数,包括小数点
	/*
	 * p（精度） 指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。
	 * 
	 * s（小数位数） 指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <=
	 * p。最大存储大小基于精度而变化。
	 */
function ItemDecimal_KeyPress(elementname,p,s)
{
	var evt = getEvent();
	var keyCode = evt.which ? evt.which : evt.keyCode;
	tmpvalue = $GetEle(elementname).value;

    var dotCount = 0;
	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var len = -1;
    if(elementname){
		len = tmpvalue.length;
    }

    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			dotCount++;
			hasDot=false;
		}else{
			if(hasDot==false){
				integerCount++;
			}else{
				afterDotCount++;
			}
		}		
    }

    if(!(((keyCode>=48) && (keyCode<=57)) || keyCode==46 || keyCode==45) || (keyCode==46 && dotCount == 1)){  
		if (evt.keyCode) {
	     	evt.keyCode = 0;evt.returnValue=false;     
	     } else {
	     	evt.which = 0;evt.preventDefault();
	     }
    }
	if(integerCount>=p-s && hasDot==false && (keyCode>=48) && (keyCode<=57)){
		if (evt.keyCode) {
	     	evt.keyCode = 0;evt.returnValue=false;     
	     } else {
	     	evt.which = 0;evt.preventDefault();
	     }
	}
	if(afterDotCount>=s&&integerCount>=p-s){
		 if (evt.keyCode) {
	     	evt.keyCode = 0;evt.returnValue=false;     
	     } else {
	     	evt.which = 0;evt.preventDefault();
	     }
	}
	/* 新增 */
	var rtnflg = false;
	
	var cursorPosition = getCursortPosition($GetEle(elementname));
	var vidValue = $GetEle(elementname).value;
	var dotIndex = vidValue.indexOf(".");
	if (hasDot) {
		if (cursorPosition <= dotIndex) {
			if (integerCount >= (p - s)) {
				rtnflg = true;
			}
		} else {
			if(afterDotCount >= s) {
				rtnflg = true;
			}
		}
	}
	
	if (rtnflg) {
		if (evt.keyCode != undefined) {
			evt.keyCode = 0;
			evt.returnValue=false;     
		} else {
			evt.which = 0;
			evt.preventDefault();
		}
	}
}

// 判断input框中是否输入的是数字,不包括小数点
function ItemCount_KeyPress()
{
	var evt = getEvent();
	var keyCode = evt.which ? evt.which : evt.keyCode;
 if(!(((keyCode>=48) && (keyCode<=57))|| keyCode==45))
  {
     if (evt.keyCode) {
     	evt.keyCode = 0;evt.returnValue=false;     
     } else {
     	evt.which = 0;evt.preventDefault();
     }
     
	 
	 
  }
}

//检查浮点型数字的正确性。
function checkFloat(obj)
{
	var value = obj.value;
	if(value != ""){
		//var reg = /^-?\d+\.?\d+$/;
		var reg = /^(-?\d+)(\.\d+)?$/;
		if (!reg.test(value)){
			obj.value = "";
			// add by liaodong for qc75759 in 2013-10-24 start
		}else{
			try{
				var dlength = obj.getAttribute("datalength");
				if(dlength==null && obj.getAttribute("datavaluetype").toString()=="5"){
					dlength = 2;
				}else if(dlength == null){
					dlength = 4;
				}
				obj.value = addZero(value,dlength);
			}catch(e){}
		 //end
		}
	}
}

//用于验证值的范围在最小值与最大值之间。否则清空值。
function checkItemScale(obj,msg, minValue,maxValue){
	var val = obj.value;
	if(val != ""){
		try{
			//调用parseInt转换类型必须指定第二个参数值，来设置保存数字的进制的值。否则有可能使用8进制 16进制来转换数据。
			val = parseInt(val, 10);
			if(val < minValue || val > maxValue){
				alert(msg);
				obj.value = "";
				return false;
			} else {
				return true;
			}
		}catch(e){
			obj.value = "";
			return false;
		}
	}
}

function changeToNormalFormat(inputfieldname){
    var sourcevalue = $GetEle(inputfieldname).value;
    sourcevalue = sourcevalue.replace(/,/g,"");
    $GetEle(inputfieldname).value = sourcevalue;
}

function changeToThousands(inputfieldname,qfws){
    var sourcevalue = $GetEle(inputfieldname).value;
	var dlength =$GetEle(inputfieldname).getAttribute("datalength")
	if(0 < dlength && $GetEle(inputfieldname).getAttribute("datavaluetype") != "5"){
		sourcevalue = addZero(sourcevalue,dlength);
	}else if($GetEle(inputfieldname).getAttribute("datavaluetype") == "5"){
		sourcevalue = addZero(sourcevalue,qfws);
		sourcevalue=sourcevalue.replace(/\s+/g,""); 
		if(sourcevalue != ''){
			sourcevalue =commafy(sourcevalue);
		}
	}
    $GetEle(inputfieldname).value = sourcevalue;
}

function changeToThousands2(inputfieldname,qfws){
    sourcevalue = $GetEle(inputfieldname).value;
	var dlength =$GetEle(inputfieldname).getAttribute("datalength")
	if(0 < dlength && $GetEle(inputfieldname).getAttribute("datavaluetype") != "5"){
		sourcevalue = addZero(sourcevalue,dlength);
		tovalue = sourcevalue;
	}else if($GetEle(inputfieldname).getAttribute("datavaluetype") == "5"){
		sourcevalue = addZero(sourcevalue,qfws);
		sourcevalue=sourcevalue.replace(/\s+/g,""); 
        var  sourcevalue01=sourcevalue;
		if(sourcevalue01!=''){
     
	      tovalue =commafy(sourcevalue01);
                   
		}else{
			tovalue = sourcevalue;
		}
	}else{
		tovalue = sourcevalue;
	}
	//end
    $GetEle(inputfieldname).value = tovalue;
}

//验证整数的正确性
function checkcount1(objectname){
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) {
		charnumber = parseInt(valuechar[i]);
		if( isNaN(charnumber) && (valuechar[i]!="-" || (valuechar[i]=="-" && i!=0))){
			isnumber = true ;
		}
		if (valuechar.length==1 && valuechar[i]=="-"){
		    isnumber = true ;
		}
	}
	if(isnumber){
		objectname.value = "" ;
	}
}

function addZero(aNumber,precision){
	if(aNumber==null || aNumber.trim()=="" || isNaN(aNumber))return "";
	var valInt = (aNumber.toString().split(".")[1]+"").length;
	if(valInt != precision){
	    var lengInt = precision-valInt;
		//判断添加小数位0的个数
		if(lengInt == 1){
			aNumber += "0";
		}else if(lengInt == 2){
			aNumber += "00";
		}else if(lengInt == 3){
			aNumber += "000";
		}else if(lengInt < 0){
			if(precision == 1){
				aNumber += ".0";
			}else if(precision == 2){
				aNumber += ".00";
			}else if(precision == 3){
				aNumber += ".000";
			}else if(precision == 4){
				aNumber += ".0000";
			}
			var ins = aNumber.toString().split(".");
			if(ins.length>2){
				aNumber = parseFloat(ins[0]+"."+ins[1]).toFixed(precision);
			}
		}		
	}
	return  aNumber;			
}

/**  
 * 数字格式转换成千分位  
 * @param{Object}num  
 */  
function commafy(num) { 
 
	num = num + "";   
	num = num.replace(/[ ]/g, ""); //去除空格  
 
   if (num == "") {   
       return;   
    }   
 
    if (isNaN(num)){  
    return;   
   }   
 
   //2.针对是否有小数点，分情况处理   
   var index = num.indexOf(".");   
    if (index==-1) {//无小数点   
      var reg = /(-?\d+)(\d{3})/;   
       while (reg.test(num)) {   
        num = num.replace(reg, "$1,$2");   
        }   
    } else {   
        var intPart = num.substring(0, index);   
       var pointPart = num.substring(index + 1, num.length);   
       var reg = /(-?\d+)(\d{3})/;   
      while (reg.test(intPart)) {   
       intPart = intPart.replace(reg, "$1,$2");   
       }   
      num = intPart +"."+ pointPart;   
   }   
   
   return num;  
}


function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	var func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

/**
 * 根据标识（name或者id）获取元素，主要用于解决系统中很多元素没有id属性，
 * 却在js中使用document.getElementById(name)来获取元素的问题。
 * @param identity name或者id
 * @return 元素
 */
function $GetEle(identity, _document) {
	var rtnEle = null;
	if (_document == undefined || _document == null) _document = document;
	
	rtnEle = _document.getElementById(identity);
	if (rtnEle == undefined || rtnEle == null) {
		rtnEle = _document.getElementsByName(identity);
		if (rtnEle.length > 0) rtnEle = rtnEle[0];
		else rtnEle = null;
	}
	return rtnEle;
}

/**
 * 获取光标所在位置
 */
function getCursortPosition(inputElement) {
	var CaretPos = 0; 
	if (document.selection) {
		inputElement.focus();
		var Sel = document.selection.createRange();
		Sel.moveStart('character', -inputElement.value.length);
		CaretPos = Sel.text.length;
	} else if (inputElement.selectionStart || inputElement.selectionStart == '0') { //ff
		CaretPos = inputElement.selectionStart;
	}
	return (CaretPos);
}