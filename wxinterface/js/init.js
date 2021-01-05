function openFullWindow(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ; 
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowHaveBar(url){
  var redirectUrl = url ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
   var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes,toolbar=no,location=no," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowHaveBarForWFList(url,requestid){
	try{
		document.getElementById("wflist_"+requestid+"span").innerHTML = "";
	}catch(e){}
	var redirectUrl = url ;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	//if (height == 768 ) height -= 75 ;
	//if (height == 600 ) height -= 60 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}

//为了删除时用
function openFullWindow1(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top="+height/2+"," ; 
  szFeatures +="left="+width/2+"," ; 
  szFeatures +="width=181," ;
  szFeatures +="height=129," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=no" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}


function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top=100," ; 
  szFeatures +="left=400," ;
  szFeatures +="width="+width/2+"," ;
  szFeatures +="height="+height/2+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function  readCookie(name){  
   var  cookieValue  =  "7";  
   var  search  =  name  +  "=";
   try{
	   if(document.cookie.length  >  0) {    
	       offset  =  document.cookie.indexOf(search);  
	       if  (offset  !=  -1)  
	       {    
	           offset  +=  search.length;  
	           end  =  document.cookie.indexOf(";",  offset);  
	           if  (end  ==  -1)  end  =  document.cookie.length;  
	           cookieValue  =  unescape(document.cookie.substring(offset,  end))  
	       }  
	   }  
   }catch(exception){
   }
   return  cookieValue;  
} 

function setMenuDisabled(){
	var o, _disabled;
	switch(arguments.length){
		case 0 :
			o = window.frames["rightMenuIframe"].event.srcElement;
			_disabled = true;
			break;
		case 1 :
			o = arguments[0];
			_disabled = true;
			break;
		case 2 :
			o = arguments[0];
			_disabled = arguments[1];
			break;
	}
	o.disabled = _disabled;
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

var wuiUtil = {
	/**
	 * isNotNull 目标值不为null || undefined，返回true，否则返回false
	 */
	isNotNull: function (target) {
		if (target == undefined || target == null) {
			return false;
		}
		return true;
	}, 
	/**
	 * isNullOrEmpty 目标值为null、undefined、空，返回true，否则返回false
	 */
	isNullOrEmpty : function (target) {
		if (target == undefined || target == null || target == "") {
			return true;
		}
		return false;
	}, 
	/**
	 * isNotEmpty 目标值不为null、undefined、空，返回true，否则返回false
	 */
	isNotEmpty : function (target) {
		if (target == undefined || target == null || target == "") {
			return false;
		}
		return true;
	},
	getJsonValueByIndex: function (josinobj, index) {
		var _index = 0;
		try {
			for(var key in josinobj){
				if (index == _index) {
					return josinobj[key]; 			
				}
				_index++;
			}
		} catch (e) {alert("browser return value is error!");}
		return "";
	}
};

//是否是chrome37+
var systemshowModalDialog = window._systemshowModalDialog;
//dialog返回值
var dialogReturnValue = void 0;
//showmodeldialog方法调用者
var dialogcaller = void 0;
//流程字段联动
var datainputCaller = void 0;
//字段联动方法
var datainputFun = void 0;
//showmodeldialog方法调用者参数
var dialogcallerArguments = void 0;


var othcaller = void 0;

var childWindow = void 0;
/**
 * 页面关闭时调用
 */
var closeHandle = function (rtvval) {
	if (dialogcaller) {
		//重写方法
		callerhandle(dialogcaller.toString(), datainputCaller);
	}
	var nfunarguments = new Array();
	nfunarguments.push(dialogReturnValue);
	
	//alert("test:"+ dialogcallerArguments.length);
	if (dialogcallerArguments) {
		for (var i=0; i<dialogcallerArguments.length; i++) {
			//alert(dialogcallerArguments[i]);
			//var argument = dialogcallerArguments[i];
			nfunarguments.push(dialogcallerArguments[i]);
		}
    }
	if (typeof(_callbackfunciton) == 'function') {
		_callbackfunciton.apply(null, nfunarguments);
	}
	
	if (!!datainputFun) {
		try {
			eval(datainputFun);
		} catch (e) {}
	}
	
	if (!!othcaller) {
		parentCallerHandle(dialogcaller.toString(), othcaller.toString(), dialogReturnValue);
	}
	
	//调用完毕，重置参数，保证下次调用的正确性
	resetDialog();
}

/**
 * 重写调用者方法
 */
var _callbackfunciton;
function callerhandle(callerstr, datainputCaller) {
	var funnameregex = /function +[^\(]*\(/;
	//var funnameregex = /function +.+\(/;
	var funnameendregex = /_callbackfunciton *= *function *\(_callbackobj, *\)/;
	
	callerstr = callerstr.replace(funnameregex, "_callbackfunciton = function (_callbackobj,");
	callerstr = callerstr.replace(funnameendregex, "_callbackfunciton = function (_callbackobj)");
	
	var _callerstrback = callerstr;
	//alert(callerstr);
	var callbackfun = "";
	//var regex = /=[ ]*window\.showModalDialog\(([^\(]+([\(][^\)]*\))*[^\)]+)*\)/g;
	var regex = /=[ ]*(window\.)?showModalDialog\([^\)]+\)/g;
	
	callerstr = callerstr.replace(regex, " = _callbackobj;//");
	
	//alert(callerstr);
	try {
		//不需要赋值的情况(比如：流程导入)
		var regex3 = /[ ]*(window\.)?showModalDialog\([^\)]+\)/g;
		//var regex = /=[ ]*window\.showModalDialog\(([^\(]+([\(][^\)]*\))*[^\)]+)*\)/g;
		callerstr = callerstr.replace(regex3, "//");
		//alert(callerstr);
		eval(callerstr);
		if (!!datainputCaller) {
			var datainputCallerstr = datainputCaller.toString();
			
			var diregex = /datainput\(\'field[\d]+\'\);?/;
			
			var rs = diregex.exec(datainputCallerstr);
			if (!!rs && rs.length > 0) {
				datainputFun = rs[0];
			} else {
				//明细字段的字段联动
				diregex = /datainputd\(\'field[\d]+_[\d]+\'\);?/;
				rs = diregex.exec(datainputCallerstr);
				if (!!rs && rs.length > 0) {
					datainputFun = rs[0];
				} 
			}
		}
	} catch (e) {
		try {
			var regexRs = regex.exec(_callerstrback);
			if (!!regexRs && regexRs.length > 0) {
				var rexindex = regex.lastIndex;
				
				var tempfunstr = _callerstrback.substr(rexindex);
				var temprightgindex = tempfunstr.indexOf(")");
				
				if (temprightgindex != -1 ) {
					tempfunstr = tempfunstr.substr(temprightgindex + 1);
				}
				
				var count = 0;
				
				var tempregex = /^[ ]*[\)]*[ ]*[+,]/;
				var temprs = tempregex.exec(tempfunstr);
				while (!!temprs && temprs.length > 0) {
					temprightgindex = tempfunstr.indexOf(")");
					if (temprightgindex == -1 ) {
						break;
					}
					tempfunstr = tempfunstr.substr(temprightgindex + 1);
					tempregex = /^[^\)]*[\)][\+,]/;
					temprs = tempregex.exec(tempfunstr);
					if (count++ == 20) {
						break;
					}
				}
				temprightgindex = tempfunstr.indexOf(")");
				if (temprightgindex != -1 ) {
					tempfunstr = tempfunstr.substr(temprightgindex + 1);
				}
				tempfunstr = tempfunstr.replace(/^[ ]*;/g, "");
				var tempfunbeforestr = _callerstrback.substring(0, rexindex);
				
				
				tempfunbeforestr = tempfunbeforestr.replace(regex, " = _callbackobj;//");
				_callerstrback = tempfunbeforestr + "\r\n" + tempfunstr;
			}
			//不需要赋值的情况(比如：流程导入)
			var regex3 = /[ ]*(window\.)?showModalDialog\([^\)]+\)/g;
			//var regex = /=[ ]*window\.showModalDialog\(([^\(]+([\(][^\)]*\))*[^\)]+)*\)/g;
			_callerstrback = _callerstrback.replace(regex3, "//");
			eval(_callerstrback);
		} catch (e10) {
		}
	}
}

function parentCallerHandle(_callerstr, of, _dialogReturnValue) {
	try {
		if (!!!_dialogReturnValue || !!!of) return; 
		
		var _pcallerstr = of.toString();
		
		var callerfnname = getFuncName(_callerstr);
		var ofname = getFuncName(of);
		
		if (callerfnname == 'onSetRejectNode' && ofname == 'doReject') {
			var rjnoderegex = /onSetRejectNode\(\)/g;
			_pcallerstr = _pcallerstr.replace(rjnoderegex, "true");
			
			var funnameregex = /function +[^\(]*\(/;
			_pcallerstr = _pcallerstr.replace(funnameregex, "_parentcallbackfun = function (");
			eval(_pcallerstr);
			//执行
			_parentcallbackfun();
		}
		
	} catch (e) {alert(e);}
}

/**
 * 重置dialog参数
 */
function resetDialog() {
	_callbackfunciton = void 0;
	dialogReturnValue = void 0;
	dialogcaller = void 0;
	datainputCaller = void 0;
	datainputFun = void 0;
	
	othcaller = void 0;
} 

function getFuncName(func){
    var funcName = String(func) ;
    return funcName.replace(/^function(\s|\n)+(.+)\((.|\n)+$/,'$2');
}
//-----------------------------------------
// 选择框用转换程序 start
//-----------------------------------------
if (typeof(SYSTEM_SHOW_MODAL_DIALOG) == "undefined" && typeof(SYSTEM_SHOW_MODAL_DIALOG) != "fucntion") {
	var SYSTEM_SHOW_MODAL_DIALOG = null;
	if (!!!window._isNotFirstInit) {
		window._isNotFirstInit = true;
		//系统模态窗口
		SYSTEM_SHOW_MODAL_DIALOG = window.showModalDialog;
		//chrome37+
		if (!systemshowModalDialog && !!!SYSTEM_SHOW_MODAL_DIALOG) {
			systemshowModalDialog = true;
			window._systemshowModalDialog = true;
		}
	}
	
	if (window.showModalDialog == SYSTEM_SHOW_MODAL_DIALOG) {
		//重写系统模态窗口
		window.showModalDialog = function () {
			var url	= arguments[0];
			var parent = arguments[1];
			var dialogParent = arguments[2];

			if (!parent) {
				parent = "";
			}
			
			//ff下窗口不剧中问题统一处理
			if (!systemshowModalDialog) {
				if (!dialogParent) {
					dialogParent = "dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";";
				} else if (dialogParent != "" && dialogParent.indexOf("dialogTop") == -1) {
					dialogParent += ";dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";";
				}
			}
			//alert(systemshowModalDialog);
			//alert(window.showModalDialog.caller);
			//alert(systemshowModalDialog);
			//只有chrome37+才处理
			if (systemshowModalDialog) {
				//打开当前窗口的同时，关闭其他弹出窗口，并重置参数
				if(childWindow){   
			         childWindow.close(); 
			         childWindow = undefined;
			         resetDialog();
			    }
				dialogcaller = window.showModalDialog.caller;
				//处理字段联动
				if (!!dialogcaller && !!dialogcaller.caller ) {
					if (dialogcaller.caller.toString().indexOf("datainput(") != -1) {
						datainputCaller = dialogcaller.caller;
					}
					if (dialogcaller.caller.toString().indexOf("datainputd(") != -1) {
						datainputCaller = dialogcaller.caller;
					}
					
					othcaller = dialogcaller.caller;
					//alert(getFuncName(dialogcaller));
					/*
					if (getFuncName(dialogcaller.caller.toString()).indexOf("datainput(") != -1) {
					
					}
					*/
				}
				
				//alert(dialogcaller.caller);
				if (dialogcaller) {
					dialogcallerArguments = dialogcaller.arguments;
				}
				//alert(dialogcaller.arguments);
				//var dialog = window.open(url);
				childWindow = window.open(url, "", "width=560px,height=580px,resizable=no,scroll=no,status=no,top=" + (window.screen.availHeight - 30 - parseInt(550))/2 + ",left=" + (window.screen.availWidth - 10 - parseInt(550))/2);   
//  				window.childWindow.focus();  
				//timeoutDialog(dialog);
				//setTimeout(function () );
				return ;
			}
			
			var returnValue2;
			//调用系统模态窗口弹出function
			var rtnValue = SYSTEM_SHOW_MODAL_DIALOG(url, parent, dialogParent); 
			//ie下如果调用的是js，而返回值是vb则转换成json
			if (window.ActiveXObject) {
				//返回值是vb
				if (rtnValue != undefined && rtnValue != null && typeof(rtnValue) == "unknown") {
					var func = window.showModalDialog.caller;
					//判断调用模态窗口者是否是js
					if (typeof(func) == "function") {
						var tempArray = new VBArray(rtnValue).toArray();
						var tempJsonData = "{";
						if (tempArray != null) {
							for (var i=0; i<tempArray.length; i++) {
								if (i == 0) {
									tempJsonData += "id:\"" + tempArray[i] + "\"";
								} else if (i == 1) {
									tempJsonData += "name:\"" + tempArray[i] + "\"";
								} else {
									tempJsonData += "key" + i + ":\"" + tempArray[i] + "\"";
								}
								
								if (i < tempArray.length - 1) {
									tempJsonData += ", ";
								}
							}
						}
						tempJsonData += "}";
						
						returnValue2 =  eval('(' + tempJsonData + ')');
						return returnValue2;
					}
				} else if (typeof(rtnValue) == "object"){
					//alert(window.showModalDialog.caller.caller);
					var func = window.showModalDialog.caller;
					try {
						window.console.log("href:" + window.location.href);
						window.console.log("caller type:" + typeof(func));
						window.console.log("caller content:" + func);
					} catch (e) {}
					//判断调用模态窗口者是否是vb
					if ((typeof(func) == "function" && func.toString().indexOf("function onclick()") != -1) || typeof(func) == "object") {
						return string2VbArray(json2String(rtnValue));
					} else {
						var	regex = new RegExp("jsid[ ]{0,}=[ ]{0,}new VBArray[\(]id[\)].toArray[\(][\)]", "g"); // 创建正则表达式对象。  
						var r = func.toString().match(regex);
					　　 if (r != null && r != undefined && r != "") {
						 	return string2VbArray(json2String(rtnValue));
					 	}
					}
				}
			}
			return rtnValue;
		};
	}
}

function json2String(josinobj) {
	if (josinobj == undefined || josinobj == null) {
		return "";
	}
	var ary = "";
	var _index = 0;
	try {
		for(var key in josinobj){
			if (_index++ > 0) {
				ary += "(~!@#$%^&*)";
			}
			ary += josinobj[key];
		}
	} catch (e) {}
	return ary;
}
//-----------------------------------------
//选择框用转换程序 END
//-----------------------------------------

