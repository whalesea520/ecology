top._initStatus = false;

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

function openFullWindowBySelf(url){
	if(url.indexOf("&is_customized_link=true")>-1) {
		url = url.substring(0, url.indexOf("&is_customized_link=true"));
		window.location.href = url;
		return;
	}
	url += "&isopenbyself=1"; 
	window.location.href = url;
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
		if(requestid>0){
			document.getElementById("wflist_"+requestid+"span").innerHTML = "";
		}
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
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-60 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ; 
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

/**打开长url的窗口，因为url过长时，会导致浏览器无法处理，add by fmj 2015-03-04 start*/
/**思路是，在当前窗口新建一个隐藏的form，将原本的url分为2部分，参数改为post传值，url作为form的action地址*/
function openFullWindowForLong(url,_target){
	if(url && url.length > 2048){
		var list = [];
		var index = url.indexOf("?");
		if(index != -1){
			var paramString = url.substring(index + 1);
			url = url.substring(0,index);
			var paramarr = paramString.split("&");
			for(var i = 0; i < paramarr.length; i++){
				var singlearr = paramarr[i];
				var arr = singlearr.split("=");
				var key = arr[0];
				var value = "";
				if(arr.length > 1){
					value = arr[1];
				}
				var param = {};
				param.key = key;
				param.value = value;
				list.push(param);
			}
		}
		var formObj = document.getElementById("long_url_form");
		if(formObj){   //如果已经存在form，先删除
			document.body.removeChild(formObj);
		}
		var _form = document.createElement("form");
		_form.id = "long_url_form";
		_form.action = url;
		_form.target = _target || "_blank";
		_form.method = "post";
		_form.style.display = "none";
		for(var i =0; i < list.length;i++){   //新建隐藏的文本域，将url中的参数存入隐藏域
			var _map = list[i];
			var input = document.createElement("input");
			input.name = _map.key;
			input.type = "hidden";
			input.value = _map.value;
			_form.appendChild(input);
		}
		document.body.appendChild(_form);
		_form.submit();
	}else{
		openFullWindowForXtable(url);
	}
}
/**打开长url的窗口，add by fmj 2015-03-04 start*/

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
		if(window.console)console.log("josinobj=======================" , josinobj);
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
	},
	getJsonValueByIndexNew: function (josinobj, index) {
		var _index = 0;
		try {
			var josinobj = eval("("+josinobj+")");
			if(typeof(josinobj) != undefined && typeof(josinobj) != 'undefined'&&null!=josinobj){
				var isjosin = josinobj.id;
				//alert("isjosin : "+isjosin);
				if(typeof(isjosin) != undefined && typeof(isjosin) != 'undefined'&&null!=isjosin)
				{
					for(var key in josinobj){
						if (index == _index) {
							return josinobj[key]; 			
						}
						_index++;
					}
				}
				else
				{
					jsids = new VBArray(josinobj).toArray();
					return jsids[index];
				}
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
			var dialogWidth = 560;
			if(url.indexOf("MutiResourceBrowser")>-1) dialogWidth = 674;

			if (!parent) {
				parent = "";
			}
			
			//ff下窗口不剧中问题统一处理
			if (!systemshowModalDialog) {
				if (!dialogParent) {
					dialogParent = "dialogWidth:"+dialogWidth+"px;dialogHeight:600px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(600))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(dialogWidth))/2 + "px" + ";";
				} else if (dialogParent != "" && dialogParent.indexOf("dialogTop") == -1) {
					dialogParent += ";dialogTop:" + (window.screen.availHeight - 30 - parseInt(dialogWidth))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(dialogWidth))/2 + "px" + ";";
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
				childWindow = window.open(url, "", "width="+dialogWidth+"px,height=600px,resizable=no,scroll=no,status=no,top=" + (window.screen.availHeight - 30 - parseInt(600))/2 + ",left=" + (window.screen.availWidth - 10 - parseInt(dialogWidth))/2);   
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
				if (!!key && key.indexOf(",") == 0) {
					key = key.substr(1);
				}
				
				ary += "(~!@#$%^&*)";
			}
			var jsonval = josinobj[key] ;
			if (!!jsonval && jsonval.indexOf(",") == 0) {
				jsonval = jsonval.substr(1);
			}
			ary += jsonval;
		}
	} catch (e) {}
	return ary;
}

function e8showAjaxTips(context,soh,e8class){
	var tips = jQuery("#e8showAjaxTip");
	if(!e8class){
		e8class = "e8showAjaxTip";
	}
	if(tips.length==0){
		tips = jQuery("<div id='e8showAjaxTip' style='font-size:12px;' class='"+e8class+"'></div>");
		jQuery("body").append(tips);
	}
	tips.html(context);
	if(soh){
		tips.show();
		tips.css({
			"left":jQuery(window).width()/2-tips.width()+30,
			"top":jQuery(window).height()/2-20
		});
	}else{
		tips.hide();
	}
}

function e8PageLoading(){
	var tips = jQuery("#e8PageLoading");
	if(tips.length==0){
		tips = jQuery("<div id='e8PageLoading' class='e8PageLoading'></div>");
		jQuery("body").append(tips);
	}
	tips.html(context);
	tips.css({
		"left":jQuery(window).width()/2-50,
		"top":jQuery(window).height()/2-20
	});
}


function getLoadingDiv(){
	var languageid = readCookie("languageidweaver");
	var txt = SystemEnv.getHtmlNoteName(3417,languageid);
	/*if(languageid==8){
		txt = "Searching, please wait ...";
	}else if(languageid==9){
		txt = "正在查詢，請稍候...";
	}else{
		txt = "正在查询，请稍候...";
	}*/
	return jQuery("<div style=\"display:none;\" id=\"e8_loading\" class=\"e8_loading\">"+txt+"</div>");
}

function getTreeSwitch(){
	var languageid = readCookie("languageidweaver");
	jQuery("<div style=\"display:none;\" id=\"e8TreeSwitch\" class=\"e8_expandOrCollapseDiv\"></div>")
}


jQuery(document).ready(function(){
	setInnerStyle("#deeptree",{overflow:"hidden"});
	var mainIframe = jQuery("#mainFrame",parent.document);
	if(mainIframe.length>0 && jQuery("#flowFrame").length>0){
		jQuery(document.body).css("overflow","hidden");
	}
    //防止浏览框变形
    jQuery(".AddDocFlowHidden").each(function(){
       if(this.type=="button" && jQuery(this).parent().attr("class").indexOf("e8_browserSpan") >= 0 ){
          jQuery(this).parent().css("display","block");
          jQuery(this).parent().css("width","21px");
       }
    });
});

function setInnerStyle(id,styles){
	jQuery(id).css(styles);
}


function isIE11(){
	if (jQuery.browser.mozilla && jQuery.browser.version == '11.0') {
		return true;
	}else{
		return false;
	}
}

//-----------------------------------------
//选择框用转换程序 END
//-----------------------------------------


/**
*清空搜索条件
*/
function resetCondtion(selector){
	resetCondition(selector);
}

function resetCondition(selector){
	if(!selector)selector="#advancedSearchDiv";
	//清空文本框
	jQuery(selector).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(selector).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(selector).find(".e8_os").find("input[type='hidden']").val("");
	//清空下拉框
	try{
		jQuery(selector).find("select").selectbox("reset");
	}catch(e){
		jQuery(selector).find("select").each(function(){
			var $target = jQuery(this);
			var _defaultValue = $target.attr("_defaultValue");
			if(!_defaultValue){
				var option = $target.find("option:first");
				_defaultValue = option.attr("value");
			}
			$target.val(_defaultValue).trigger("change");
		});
	}
	//清空日期
	jQuery(selector).find(".calendar").siblings("span").html("");
	jQuery(selector).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find(".Calendar").siblings("span").html("");
	jQuery(selector).find(".Calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find("input[type='checkbox']").each(function(){
		try{
			changeCheckboxStatus(this,false);
		}catch(e){
			this.checked = false;
		}
	});
}

function resizeDialog(_document){
	if(!_document)_document = document;
	
	var zDialog_div_bottom = jQuery(".zDialog_div_bottom:first");
	var zDialog_div_content = jQuery(".zDialog_div_content:first");
	var bottomheight = zDialog_div_bottom.height();
	var paddingBottom = zDialog_div_bottom.css("padding-bottom");
	var paddingTop = zDialog_div_bottom.css("padding-top");
	var headHeight = 0;
	var e8Box = zDialog_div_content.closest(".e8_box");
	if(e8Box.length>0){
		headHeight = e8Box.children(".e8_boxhead").height();
	}
	if(!!paddingBottom && paddingBottom.indexOf("px")>0){
		paddingBottom = paddingBottom.substring(0,paddingBottom.indexOf("px"));
	}
	if(!!paddingTop && paddingTop.indexOf("px")>0){
		paddingTop = paddingTop.substring(0,paddingTop.indexOf("px"));
	}
	if(isNaN(paddingBottom)){
		paddingBottom = 0;
	}else{
		paddingBottom = parseInt(paddingBottom);
	}
	if(isNaN(paddingTop)){
		paddingTop = 0;
	}else{
		paddingTop = parseInt(paddingTop);
	}
	window.setTimeout(function(){
		var bodyheight = jQuery(window).height();//_document.body.offsetHeight;
		if(document.documentMode!=5){
			zDialog_div_content.css("height",bodyheight-bottomheight-paddingTop-headHeight-7);
		}else{
			zDialog_div_content.css("height",bodyheight-bottomheight-paddingBottom-paddingTop-headHeight-7);
		}
	},10);
}

/**
 * 使必填字段获取焦点
 */
function formElementFocus(formelename) {
	try {
		if (formelename.name == 'remarkText10404') {
			//initRemark2();
			if(typeof autoscroll4remark === "function"){	//引入WorkflwoSignInput.jsp情况
				initRemark(true);
				autoscroll4remark();
			}else{		//签字意见输入框在模板内
				try{
					var remarkscrolltop = jQuery("#remark").offset().top;
					jQuery(document.body).animate({scrollTop : remarkscrolltop + "px"}, 500);
				}catch(e){}
			}
			if (window._isremarkcomp != false) {
			    var _ue = UE.getEditor('remark')
				_ue.focus(true);
				if (!!window.UEDITOR_CONFIG && !isNaN(window.UEDITOR_CONFIG.remarkfontsize)) {
                    _ue.execCommand('fontsize', window.UEDITOR_CONFIG.remarkfontsize + "px");
                }
                
                if (!!window.UEDITOR_CONFIG && !!window.UEDITOR_CONFIG.remarkfontsize) {
                    _ue.execCommand('fontfamily', window.UEDITOR_CONFIG.remarkfontfamily );
                }
			}
			return;
		}

		if (formelename.type == 'textarea') {
			if (!jQuery(formelename).is(":visible") && jQuery(formelename).attr("temptype") == '2') {
				UE.getEditor(formelename.name).focus(true);
			} else {
				formelename.select();
			}
			return;
		}
		
		formelename.focus();
		if (formelename.type == 'hidden' && !!document.getElementById("out" + formelename.name + "div")) {
			jQuery(document.getElementById("out" + formelename.name + "div")).trigger("click");
			return;
		}
	} catch (e) {}
}

function checkueditorContent(formelename) {
	var _result = false;
	if (formelename.type == 'textarea') {
		if (!jQuery(formelename).is(":visible") && jQuery("#" + formelename.name).is("div")) {
			var _html = UE.getEditor(formelename.name).getContent()
			if (_html.indexOf("<img ") != -1) {
				_result = true;
			}
		} 
	}
	return _result; 
}

function __initQueryResultAreaHeight(searchAreaId,resultAreaId){
	window.setTimeout(function(){
		var searchAreaHeight = jQuery(searchAreaId).height();
		var contentHeight = jQuery("div.zDialog_div_content").height();
		var height = contentHeight - searchAreaHeight - 2;
		jQuery(resultAreaId).height(height).css("overflow","auto");
	},300);
}

/*显示列定制组件--->/js/dragBox/parentShowcol.js*/

function showColDialog(){
   	dialog = new top.Dialog();
   	dialog.currentWindow = window;
   	dialog.okLabel = SystemEnv.getHtmlNoteName(3515,readCookie("languageidweaver"));
   	dialog.cancelLabel = SystemEnv.getHtmlNoteName(3516,readCookie("languageidweaver"));
   	dialog.Drag = true;
   	dialog.Title = SystemEnv.getHtmlNoteName(3517,readCookie("languageidweaver"));
   	dialog.Width = 600;
   	dialog.Height = 400;
    if(jQuery("#pageId",window.document).val()=="Hrm:resourceSearchResultByManager"){
   		dialog.URL = "/hrm/HrmTab.jsp?_fromURL=hrmShowCol";
   		dialog.Width = 800;
   		dialog.Height = 600;
   	}else{
   		dialog.URL = "/showCol.jsp";
   	}
	dialog.show();
}

var ieVersion = 6;//ie版本

jQuery(document).ready(function(){
	// 设置jQuery Ajax全局的参数
	jQuery.ajaxSetup({  
        error: function(jqXHR, textStatus, errorThrown){  
            switch (jqXHR.status){
                case(499):
                	alert(SystemEnv.getHtmlNoteName(3544,readCookie("languageidweaver")));   
            }
        },   
        success: function(data){  
            if(data.__result__===false){
            	alert(data.__msg__);
            }
        }  
    });  

	jQuery(".addbtn").hover(function(){
		jQuery(this).addClass("addbtn2");
	},function(){
		jQuery(this).removeClass("addbtn2");
	});
	
	jQuery(".sapbtn").hover(function(){
		jQuery(this).addClass("sapbtn2");
	},function(){
		jQuery(this).removeClass("sapbtn2");
	});
	
	jQuery(".addbtnB").hover(function(){
		jQuery(this).addClass("addbtnB2");
	},function(){
		jQuery(this).removeClass("addbtnB2");
	});
	
	jQuery(".delbtn").hover(function(){
		jQuery(this).addClass("delbtn2");
	},function(){
		jQuery(this).removeClass("delbtn2");
	});
	
	jQuery(".downloadbtn").hover(function(){
		jQuery(this).addClass("downloadbtn2");
	},function(){
		jQuery(this).removeClass("downloadbtn2");
	});
	var isNewPlugisSelect = jQuery("#isNewPlugisSelect");
	if(isNewPlugisSelect.length>0&&isNewPlugisSelect.val()!="1"){
		// do nothing
	}else{
		try{
			beautySelect();
		}catch(e){}
	}
	try{
		jQuery("input[type=checkbox]").each(function(){
			if(jQuery(this).attr("tzCheckbox")=="true"){
				jQuery(this).tzCheckbox({labels:['','']});
			}
		});
	}catch(e){}
	
	jQuery(window).resize(function(){
		resizeDialog();
	});
	
		window.setTimeout(function(){
			try{
				if(!jQuery("#e8QuerySearchArea").data("hasBeenCal")){
					jQuery("div#e8QuerySearchArea").css("max-height","160px").perfectScrollbar({horizrailenabled:false,zindex:0});
			       	jQuery("div#e8QuerySearchArea").find(".e8_innerShowContent").resize(function(e){
			       		jQuery("div#e8QuerySearchArea").perfectScrollbar("update");
			       	});
			 	}
			 }catch(e){}
		},300);
	
	
});
