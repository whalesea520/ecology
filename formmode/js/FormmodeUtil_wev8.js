var FormModeConstant = {
	_CURRENT_APP : "CurrAPPId",
	_CURRENT_FORM : "CurrFormId",
	_CURRENT_MODEL : "CurrModelId",
	_CURRENT_EXPAND:"CurrExpandId",
	_CURRENT_TREE:"CurrTreeId",
	_CURRENT_PAGE:"CurrPageId",
	_CURRENT_SELECTITEM:"CurrSelectItemId",
	_CURRENT_REPORT:"CurrReportId",
	_CURRENT_REPORTINFO:"CurrReportInfoId",
	_CURRENT_BROWSER:"CurrBrowserId",
	_CURRENT_CUSTOMSEARCH:"CurrCustomSearchId",
	_CURRENT_INTERFACE:"CurrInterfaceId",
	_CURRENT_Mobile_APP : "CurrMobileAppId",
	_CURRENT_Mobile_FORMUI : "CurrMobileFormUiId",
	_CURRENT_Mobile_MODELINFO : "CurrMobileModeInfoId",
	_CURRENT_RESOURCE : "CurrResourceId"
};

var FormmodeUtil = {};

//写cookie
FormmodeUtil.writeCookie = function(name, value){
	var Days = 30; //此 cookie 将被保存 30 天
    var exp = new Date();    //new Date("December 31, 9998");
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
};

//读cookie
FormmodeUtil.readCookie = function(name){
	var b = document.cookie;
    var e = name + "=";
    var d = b.indexOf("; " + e);
    if (d == -1) {
        d = b.indexOf(e);
        if (d != 0) {
            return null;
        }
    } else {
        d += 2
    }
    var a = document.cookie.indexOf(";", d);
    if (a == -1) {
        a = b.length
    }
    return unescape(b.substring(d + e.length, a))
};

//获取上一次的id，所有模块都可使用此方法
FormmodeUtil.getLastId = function(cookieName, datas, key){
	var lastId = FormmodeUtil.readCookie(cookieName);
	if(lastId != null){
		var flag = false;
		for(var i = 0; i < datas.length; i++){
			if(lastId == datas[i][key]){
				flag = true;
				break;
			}
		}
		if(!flag){	//cookie中存放的id在现有的数据中不存在，取现有数据的第一个
			lastId = (datas.length > 0) ? datas[0][key] : null;
		}
	}else{	//cookie中没有存放id，取现有数据的第一个
		lastId = (datas.length > 0) ? datas[0][key] : null;
	}
	return lastId;
};

//获取上一次的id的页数，所有模块都可使用此方法
FormmodeUtil.getLastIdPageIndex = function(currMobileAppId,datas,key,pageSize){
	var currPageIndex = 0;
	if(currMobileAppId != null){
		for(var i = 0; i < datas.length; i++){
			if(currMobileAppId == datas[i][key]){
				currPageIndex = Math.floor(i/pageSize);
				break;
			}
		}
	}
	return currPageIndex;
};

//异步数据加载的工具方法
FormmodeUtil.doAjaxDataLoad = function(url, callbackFn){
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	success: function(responseText, textStatus) 
	 	{
	 		var datas = $.parseJSON(responseText);
	 		callbackFn.call(this, datas);
	 	},
	    error: function(){
	    	//alert("error");
	    }
	});
};

//异步数据保存工具方法
FormmodeUtil.doAjaxDataSave = function(url, paramData, callbackFn){
	$.ajax({
	    url: url,
	    data: paramData, 
	    dataType: 'json',
	    type: 'POST',
	    success: function (res) {
	    	callbackFn.call(this, res);
	    },
	    error: function(){
	    	//alert("error");
	    }
	});
};

FormmodeUtil.openBrowser = function(url,inputname,spanname,width,height){
	var opts={
		_dwidth: width || '550px',
		_dheight: height || '550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		_displayTemplate:"#b{name}",
		_displaySelector:"",
		_required:"no",
		_displayText:"",
		value:""
	};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
		
	var datas = window.showModalDialog(url,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (datas) {
		if (datas.id!= "") {
			$("#"+spanname).html(datas.name);
			$("input[name="+inputname+"]").val(datas.id);
		}else{
			$("#"+spanname).html("");
			$("input[name="+inputname+"]").val("");
		}
	}
};