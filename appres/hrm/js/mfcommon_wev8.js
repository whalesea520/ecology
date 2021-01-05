/**
 * @author wcd
 * @date 2014-11-20
 */
String.prototype.trim = function(){
	return this.replace(/(^\s*)|(\s*$)/g, "");
}

String.prototype.ltrim = function(){
	return this.replace(/(^\s*)/g,"");
}

String.prototype.rtrim = function(){
	return this.replace(/(\s*$)/g,"");
}

function ajaxinit(){
	var xmlhttp;
	try{
		xmlhttp = new ActiveXObject('Msxm12.XMLHTTP');

	}catch(e){
		try{
			xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');

		}catch(e){
			try{
				xmlhttp = new XMLHttpRequest();
			}catch(e){}
		}
	}
	return xmlhttp;
}

function randomNum(min, max) {   
	var range = max - min;
	var rand = Math.random();
	return(min + Math.round(rand * range));
}

function randomString(len) {
	var len = len || 32;
	var $chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';
	var maxPos = $chars.length;
	var pwd = '';
	for (i = 0; i < len; i++) {
		pwd += $chars.charAt(Math.floor(Math.random() * maxPos));
	}
	return pwd;
}

function $G(el) {
	return $GetEle(el);
}

function $V(el) {
	return $G(el).value;
}

function MFCommon(){
	this.init();
}

MFCommon.prototype = {
	init: function(){
		this.MF_STATUS = {
			L : "L",
			R : "R",
			D : "D"
		};
		this.key = randomString(19);
		this.num = randomNum(7,30);
		this.status = this.MF_STATUS.L;
		
		this.initDialog();
	},
	initDialog: function(options){
		this.dialogOptions = jQuery.extend({
			width : 800, //窗口宽度
			height : 500, //窗口高度
			isDrag : true, //是否允许拖拽
			showMax : true, //是否显示右上角最大化
			showClose : true, //是否显示右上角关闭
			checkDataChange : true, //关闭时是否需要检查数据是否更改
			cancelEvent : null, //取消事件
			closeEvent : null, //关闭事件
			normalDialog : true,
			_callBack : null
		}, options);
	},
	showDialog: function(url, title){
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = title;
		dialog.Width = this.dialogOptions.width;
		dialog.Height = this.dialogOptions.height;
		dialog.Drag = this.dialogOptions.isDrag;
		dialog.maxiumnable = this.dialogOptions.showMax;
		dialog.ShowCloseButton = this.dialogOptions.showClose;
		dialog.CancelEvent = this.dialogOptions.cancelEvent;
		dialog.closeHandle = this.dialogOptions.closeEvent;
		dialog.checkDataChange = this.dialogOptions.checkDataChange;
		dialog.normalDialog = this.dialogOptions.normalDialog;
		dialog._callBack = this.dialogOptions._callBack;
		dialog.URL = url;
		dialog.show();
		return dialog;
	},
	getDialogReturnValue: function(datas){
		var newData = {id:"", name:""};
		try{
		if (datas){
			var ids = wuiUtil.getJsonValueByIndex(datas,0);
			ids = !ids ? "" : ""+ids;
			if (ids!= ""){
				try{
					ids = ids.replace(/ /g,"");
					ids = ids.replace(/[\n\r]/g,"");
				}catch(e){}
				try{ids = trim(ids);}catch(e){try{ids = ids.trim();}catch(e){}}
				var names = wuiUtil.getJsonValueByIndex(datas,1);
				try{
					if(datas.tag){
						ids = datas.id;
						names = datas.path;
					}
				}catch(e){}
				var idArr = ids.split(",");
				if(names) try{names = trim(names);}catch(e){names = names.trim();}
				var nameArr = names.split(",");
				var showNames = "";
				for(var i=0;i<idArr.length;i++) showNames += "<a href='#"+idArr[i]+"' onclick='return false;'>"+nameArr[i]+"</a>";
				newData = {id:ids, name:showNames};
			}
		}
		}catch(e){}
		return newData;
	},
	ajaxUrl: function(){
		return "/js/hrm/getdata.jsp";
	},
	ajax: function(url, arg0, callback){
		var result;
		var xmlhttp = ajaxinit();
		if(!url){
			return "";
		} else if(url.indexOf(".jsp") == -1){
			url = this.ajaxUrl()+(url.indexOf("?") == -1 ? "?" : "")+ url;
		}
		if(!arg0){
			url = encodeURI(url);
		}
		xmlhttp.open("get",url,false);
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState == 4){
				if(xmlhttp.status == 200){
					result = xmlhttp.responseText;
					if(typeof callback == "function") callback(jQuery.trim(result));
				}
			}
		}
		xmlhttp.send(null);
		return result.trim();
	},
	post: function(datas, sFun, url) {
		jQuery.ajax({
			url : !url ? this.ajaxUrl() : url,
			type : "post",
			async : true,
			data : datas,
			dataType : "json",
			contentType: "application/x-www-form-urlencoded;charset=utf-8",
			success: sFun
		});
	},
	changeSelectValue: function(id, value){
		var option = jQuery("select[id="+id+"]").find("option[value="+value+"]");
		jQuery("select[id="+id+"]").selectbox("change", option.attr('value'), option.html());
	},
	removeEditTableTr: function(group, tr){
		try{
			var trline = tr.next("tr");
			tr.remove();
			trline.remove();
			group.realCount--;
			$GetEle("weaverTableRealRows").value = group.realCount;
		}catch(e){}
	},
	getLanguageId: function(){
		return readCookie("languageidweaver");
	},
	getLanguageStr: function(){
		var languageStr = "zh-cn";
		var id = this.getLanguageId();
		if(id == 8) languageStr ="en";
		else if(id == 9) languageStr ="zh-tw";
		return languageStr;
	},
	date2str: function(x, y) {
		var z = {M:x.getMonth()+1,d:x.getDate(),h:x.getHours(),m:x.getMinutes(),s:x.getSeconds()};
		y = y.replace(/(M+|d+|h+|m+|s+)/g,function(v) {return ((v.length>1?"0":"")+eval('z.'+v.slice(-1))).slice(-2)});
		return y.replace(/(y+)/g,function(v) {return x.getFullYear().toString().slice(-v.length)});
	},
	daysBetween: function(dateTwo, dateOne){
		var OneMonth = dateOne.substring(5,dateOne.lastIndexOf ('-'));  
		var OneDay = dateOne.substring(dateOne.length,dateOne.lastIndexOf ('-')+1);  
		var OneYear = dateOne.substring(0,dateOne.indexOf ('-'));  
	  
		var TwoMonth = dateTwo.substring(5,dateTwo.lastIndexOf ('-'));  
		var TwoDay = dateTwo.substring(dateTwo.length,dateTwo.lastIndexOf ('-')+1);  
		var TwoYear = dateTwo.substring(0,dateTwo.indexOf ('-'));  
	  
		var cha=((Date.parse(OneMonth+'/'+OneDay+'/'+OneYear)- Date.parse(TwoMonth+'/'+TwoDay+'/'+TwoYear))/86400000);   
		return Math.abs(cha);  
	},
	compareDate: function(date1,date2){
		var ss1 = date1.split("-",3);
		var ss2 = date2.split("-",3);

		date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
		date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

		var t1,t2;
		t1 = Date.parse(date1);
		t2 = Date.parse(date2);
		if(t1==t2) return 0;
		if(t1>t2) return 1;
		if(t1<t2) return -1;

		return 0;
	},
	saveData: function (name, value) {
        var top = window.top, cache = top['_CACHE'] || {};
        top['_CACHE'] = cache;
        return value !== undefined ? cache[name] = value : cache[name];
    },
	getData: function (name) {
        var cache = window.top['_CACHE'];
		var result = "";
		try{
			result = name !== undefined ? cache[name] : "";
		}catch(e){}
        return result;
    },
    removeData: function (name) {
        var cache = window.top['_CACHE'];
        if (cache && cache[name]) delete cache[name];
    },
	checkNumber: function (el){
		var temp=/^\d+(\.\d+)?$/;
		var $el = $GetEle(el);
		if(el){
			if(temp.test($el.value)==false){
				$el.value = "";
			}
		}
	},
	checkInteger: function (el){
		var temp=/^[0-9]*[1-9][0-9]*$/;
		var $el = $GetEle(el);
		if(el){
			if(temp.test($el.value)==false){
				$el.value = "";
			}
		}
	},
	cusCheck: function(name, span){
		try{
		var obj = $GetEle(name);
		var oSpan = $GetEle(span);
		if(parseInt(obj.value) <= 0) {
			obj.value = "";
			oSpan.innerHTML = "<img align='absMiddle' src='/images/BacoError_wev8.gif'/>";
		}
		} catch(e){}
	},
	toHtml: function (s){
		var ns = "";
		if(s){
			ns = s.replace(/&lt;/g, '< ')
			.replace(/&gt;/g, '>')
			.replace(/&quot;/g, '"')
			.replace(/&apos;/g, '\'')
			.replace(/&amp;/g, '&')
			.replace(/&nbsp;/g, ' ')
			.replace(/&copy;/g, '©')
			.replace(/&reg;/g, '®')
			.replace(/&times;/g, '×')
			.replace(/&divide;/g, '÷')
			.replace(/&yen;/g, '¥')
			.replace(/&ordf;/g, 'ª')
			.replace(/&pi;/g, 'π')
			.replace(/&zeta;/g, 'ζ')
			.replace(/&ang;/g, '∠');
		}
		return ns;
	},
	resetCondition: function(obj) {
		var form= jQuery(obj).parents("form").first();
		form.find("input[type='text']").val("");
		form.find(".Browser").siblings("span").html("");
		form.find(".Browser").siblings("input[type='hidden']").val("");
		form.find(".e8_outScroll .e8_innerShow span").html("");
		form.find(".e8_os").find("span.e8_showNameClass").remove();
		form.find(".e8_os").find("input[type='hidden']").val("");
		form.find(".calendar").siblings("span").html("");
		form.find(".calendar").siblings("input[type='hidden']").val("");
		form.find(".Calendar").siblings("span").html("");
		form.find(".Calendar").siblings("input[type='hidden']").val("");
		form.find("input[type='checkbox']").each(function(){
			try{changeCheckboxStatus(this,false);}catch(e){this.checked = false;}
		});
		try{
			form.find("select").selectbox("reset");
		}catch(e){
			form.find("select").each(function(){
				var $target = jQuery(this);
				var _defaultValue = $target.attr("_defaultValue");
				if(!_defaultValue){
					var option = $target.find("option:first");
					_defaultValue = option.attr("value");
				}
				$target.val(_defaultValue).trigger("change");
			});
		}
	},
	resetFormCondition: function() {
		var form = jQuery("#searchfrm");
		form.find("input[type='text']").val("");
		form.find(".Browser").siblings("span").html("");
		form.find(".Browser").siblings("input[type='hidden']").val("");
		form.find(".e8_outScroll .e8_innerShow span").html("");
		form.find(".e8_os").find("span.e8_showNameClass").remove();
		form.find(".e8_os").find("input[type='hidden']").val("");
		form.find(".calendar").siblings("span").html("");
		form.find(".calendar").siblings("input[type='hidden']").val("");
		form.find(".Calendar").siblings("span").html("");
		form.find(".Calendar").siblings("input[type='hidden']").val("");
		form.find("input[type='checkbox']").each(function(){
			try{changeCheckboxStatus(this,false);}catch(e){this.checked = false;}
		});
		try{
			form.find("select").selectbox("reset");
		}catch(e){
			form.find("select").each(function(){
				var $target = jQuery(this);
				var _defaultValue = $target.attr("_defaultValue");
				if(!_defaultValue){
					var option = $target.find("option:first");
					_defaultValue = option.attr("value");
				}
				$target.val(_defaultValue).trigger("change");
			});
		}
	},
	showItem: function(checked, item) {
		try{
			if(checked) showEle(item);
			else hideEle(item);
		}catch(e){}
	},
	getDate: function(spanName, inputName, isMand, onPickedCallBack, onClearedCallBack){
		isMand = isMand == undefined ? 1 : parseInt(isMand);
		WdatePicker({
			lang:this.getLanguageStr(),
			el:spanName,
			onpicked:function(dp){
				var rValue = dp.cal.getDateStr();
				$dp.$(inputName).value = rValue;
				if(typeof onPickedCallBack == "function") onPickedCallBack(inputName, rValue);
			},
			oncleared:function(dp){
				$dp.$(inputName).value = '';
				$dp.$(spanName).innerHTML = isMand == 0 ? "" : "<img align='absMiddle' src='/images/BacoError_wev8.gif'/>";
				if(typeof onClearedCallBack == "function") onClearedCallBack(inputName);
			}
		});
	},
	getBrowserName: function() {
		return jQuery.client.browserVersion.browser;
	},
	isIE: function() {
		var browserName = this.getBrowserName();
		return browserName && browserName == "IE";
	}
};