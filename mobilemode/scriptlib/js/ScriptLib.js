var scriptCodeText = "";
top.scriptCodeFun = function(){
	return scriptCodeText;
};

function ScriptLib(){
	this.pageUrl = "/mobilemode/scriptlib/ScriptCenter.jsp";
}

ScriptLib.prototype.addScriptToField = function(selector, callbackFn){
	var $target = null;
	if(typeof selector === "string"){
		$target = $(selector);
	}else if(selector instanceof jQuery){
		$target = selector;
	}else{
		$target = $(selector);
	}
	var v = $target.val();
	this.openWindow(v, function(result){
		var scriptCode = result["scriptCode"];
		$target[0].value = scriptCode;
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this, scriptCode);
		}
	});
};

ScriptLib.prototype.openWindow = function(value, callbackFn){
	scriptCodeText = value;
	var url = this.pageUrl;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 800;//定义长度
	dlg.Height = 500;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4182);  //脚本库
	dlg.show();
	dlg.hookFn = function(result){
		callbackFn.call(this, result);
	};
};

function SL_AddScriptToField(selector, callbackFn){
	var sl = new ScriptLib();
	sl.addScriptToField(selector, callbackFn);
}