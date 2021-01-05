var ResourceLoader = {
	'loadedType' : []
};

ResourceLoader.loadResource = function(mec_type, callbackFn){
	var that = this;
	if(that.isLoaded(mec_type)){
		if(typeof(callbackFn) == "function"){
			callbackFn.call(callbackFn);
		}
	}else{
		$.get("/mobilemode/MECAction.jsp?action=getDesignResource&mec_type="+mec_type, function(responseText){
			var resources = $.parseJSON(responseText);
			for(var i = 0; i < resources.length; i++){
				var r = resources[i];
				var type = r["type"];
				var content = r["content"];
				if (type == "js") {
					that.runJs(content);
                } else if (type == "css"){
                	that.runCss(content);
                }
			}
			that.setLoaded(mec_type);
			if(typeof(callbackFn) == "function"){
				callbackFn.call(callbackFn);
			}
		});
	}
};

ResourceLoader.isLoaded = function(mec_type){
	
	for(var i = 0; i < this.loadedType.length; i++){
		if(this.loadedType[i] == mec_type){
			return true;
		}
	}
	
	return false;
};

ResourceLoader.setLoaded = function(mec_type){
	this.loadedType.push(mec_type);
};

ResourceLoader.runCss = function (_css) {
	var headEle = document.getElementsByTagName("head")[0]; 
	var styleEle = document.createElement("style");
	styleEle.setAttribute("type","text/css"); 
	if(styleEle.styleSheet){
		styleEle.styleSheet.cssText = _css;
	}else{
		styleEle.appendChild(document.createTextNode(_css));
	}
	headEle.appendChild(styleEle);
};

ResourceLoader.runJs = function (_js) {
    if (window.execScript) {
        window.execScript(_js)
    } else {
        window.eval(_js)
    }
};