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

function $G(identity, _document) {
	return $GetEle(identity, _document);
}

function $GetEles(identity) {
	var rtnEle = null;
	
	rtnEle = document.getElementsByName(identity);
	
	if (rtnEle.length == 1) {
		return rtnEle[0]; 
	} else if (rtnEle.length == 0) {
		return document.getElementById(identity);
	}
	return rtnEle;
}

function toFix(Number,decimalnum){
	var x=1;
	var temp_NUmber;
	//Number = Number.toFixed(decimalnum+1);
	for(var i=0; i<decimalnum; i++){
		x = x*10;
	}
	if(!isFinite(Number) || isNaN(Number)){

	temp_NUmber=0;
	}else{
	temp_NUmber  = Number>0?parseInt((Number*x+0.5),10)/x:parseInt((Number*x-0.5),10)/x;
	}
	//if(window.console)console.log("----2-temp_NUmber--"+temp_NUmber);
	return temp_NUmber.toFixed(decimalnum);
}
