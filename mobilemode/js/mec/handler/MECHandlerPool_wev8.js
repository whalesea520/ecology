var MECHandlerPool = [];

MECHandlerPool.initHandler = function(mecJsonArr, loadedFn){
	var c = mecJsonArr.length;
	function runLoadedFn(){
		if(typeof(loadedFn) == "function"){
			loadedFn.call(this);
		}
	}
	if(c == 0){
		runLoadedFn();
	}else{
		
		$("#content_editor_wrap").css("visibility", "hidden");
		$("#editor_resource_loading").show();
		
		for(var i = 0; i < mecJsonArr.length; i++){
			var mecJson = mecJsonArr[i];
			var id = mecJson["id"];
			var mectype =  mecJson["mectype"];
			var mecparam =  mecJson["mecparam"];
			var mecJson = $.parseJSON(mecparam);
			try{
				var that = this;
				var callbackFn = function(){
					var _mectype = this._mectype;
					var _id = this._id;
					var _mecJson = this._mecJson;
					var mecHandler = eval("new MEC_NS."+_mectype+"(_mectype, _id, _mecJson)");
					that.addHandler(mecHandler);
					c--;
					if(c == 0){
						
						$("#content_editor_wrap").css("visibility", "visible");
						$("#editor_resource_loading").fadeOut(500);
						
						runLoadedFn();
					}
				};
				callbackFn._mectype = mectype;
				callbackFn._id = id;
				callbackFn._mecJson = mecJson;
				
				ResourceLoader.loadResource(mectype, callbackFn);
				
				/*
				 * var mecHandler = eval("new MEC_NS."+_mec_type+"(_mectype, id, mecJson)");
					that.addHandler(mecHandler);
				 */
			}catch(e){
				console.error("MECHandlerPool.initHandler >> " + e);
			}
		}
	}
};

MECHandlerPool.addHandler = function(mecHandler){
	this.push(mecHandler);
};

MECHandlerPool.removeHandler = function(mec_id){
	var removeIndex = -1;
	for(var i = 0; i < this.length; i++){
		var mecHandler = this[i];
		if(mecHandler.id == mec_id){
			removeIndex = i;
			break;
		}
	}
	if(removeIndex != -1){
		this.splice(removeIndex, 1);
	}
};

MECHandlerPool.getHandler = function(mec_id){
	for(var i = 0; i < this.length; i++){
		var mecHandler = this[i];
		if(mecHandler.id == mec_id){
			return mecHandler;
		}
	}
};

MECHandlerPool.getHandlerByType = function(type){
	var result = new Array();
	for(var i = 0; i < this.length; i++){
		var mecHandler = this[i];
		if(mecHandler.type == type){
			result.push(mecHandler);
		}
	}
	return result;
};

MECHandlerPool.eachHandler = function(fn){
	for(var i = 0; i < this.length; i++){
		var mecHandler = this[i];
		fn.call(mecHandler, i);
	};
};

MECHandlerPool.getPageMecJsonArr = function(){
	var pageMecJsonArr = [];
	for(var i = 0; i < this.length; i++){
		var mecHandler = this[i];
		pageMecJsonArr.push(mecHandler.getMecJson());
	}
	return pageMecJsonArr;
};