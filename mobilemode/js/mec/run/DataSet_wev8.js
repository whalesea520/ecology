var datasetQueue = [];
function $d(str, callbackFn){
	if(!str){ return; }
	
	if(str.indexOf(".") != -1){
		var tmpArr = str.split(".");
		var dSetName = tmpArr[0];
		var dKey = tmpArr[1];
		
		if(typeof(Mobile_NS.DataSet) == "undefined"){
			datasetQueue.push({"dSetName" : dSetName, "dKey" : dKey, "callbackFn" : callbackFn});
			return;
		}
		
		
		var dataSet = Mobile_NS.DataSet.getDataSet(dSetName);
		if(!dataSet){
			datasetQueue.push({"dSetName" : dSetName, "dKey" : dKey, "callbackFn" : callbackFn});
			return;
		}
		
		if(!dataSet.initialize){
			datasetQueue.push({"dSetName" : dSetName, "dKey" : dKey, "callbackFn" : callbackFn});
			return;
		}else{
			var obj = new Object();
			obj.value = dataSet.getDataByKey(dKey);
			callbackFn.call(obj);
		}
	}
}

function DataSet(name, initialize, data){
	this.name = name;
	this.initialize = initialize;
	this.dataObj = data;
	this.init();
}

DataSet.prototype.init = function(){
	var that = this;
	//填充页面上引用的值
	$("[data-set='"+that.name+"'],[data-wev]").each(function(){
		var dataKey;
		
		var dataWev = $(this).attr("data-wev");
		if(dataWev && dataWev.indexOf(".") != -1){
			var tmpArr = dataWev.split(".");
			var dSetName = tmpArr[0];
			if(dSetName == that.name){
				dataKey = tmpArr[1];
			}else{
				return;
			}
		}else{
			dataKey = $(this).attr("data-key");
		}
		
		var dataValue = that.getDataByKey(dataKey);
		
		var dataFill = $(this).attr("data-fill");
		
		if(!dataFill){
			if(this.tagName.toLowerCase() == "img"){
				dataFill = "attr:src";
			}else{
				dataFill = "text";
			}
		}
		
		if(dataFill.indexOf("attr:") == 0){
			var attrName = dataFill.substring("attr:".length);
			$(this).attr(attrName, dataValue);
		}else{
			$(this).html(dataValue);
		}
	});
	
	//回调dataset队列
	for(var i = (datasetQueue.length-1); i>=0; i--){
		var oneQueue = datasetQueue[i];
		
		if(oneQueue["dSetName"] == that.name){
			
			datasetQueue.splice(i, 1);
			
			var dKey = oneQueue["dKey"];
			var callbackFn = oneQueue["callbackFn"];
			
			var obj = new Object();
			obj.value = that.getDataByKey(dKey);
			callbackFn.call(obj);
		}
	}
};

DataSet.prototype.getDataByKey = function(key){
	if(!key){
		return "";
	}
	
	var dataObj = this.dataObj;
	if($.isArray(dataObj)){
		dataObj = dataObj[0];
	}
	
	if($.isPlainObject(dataObj)){
		var value = "";
		for(var key2 in dataObj){
			if(key2.toLowerCase() == key.toLowerCase()){
				value = dataObj[key2];
				break;
			}
		}
		return value;
	}else{
		return "";
	}
};

Mobile_NS.DataSet = {};

Mobile_NS.DataSet.dArray = [];

Mobile_NS.DataSet.addDataSet = function(name, init, data){
	var dataSet = new DataSet(name, init, data);
	this.dArray.push(dataSet);
};

Mobile_NS.DataSet.getDataSet = function(name){
	var result = null;
	for(var i = 0; i < this.dArray.length; i++){
		var dataSet = this.dArray[i];
		if(dataSet.name == name){
			result = dataSet;
			break;
		}
	}
	return result;
};

Mobile_NS.DataSet.onload = function(name, init, data){
	this.addDataSet(name, init, data);
};
