// 同步查询数据
function queryData(paramsObj,successFun,errorFun) {
	if(console && JSON) {
		console.log("paramsObj : "+JSON.stringify(paramsObj));
	}
	var param_dataType = (paramsObj.dataType ? paramsObj.dataType : "json");
	jQuery.ajax({
		url:paramsObj.url,
		type:"post",
		async:false,
		dataType : param_dataType,
		data:paramsObj,
		timeout : 10000,
		success:function(msg){
			if(console && JSON) {
				console.log("msg : "+JSON.stringify(msg));
			}
			if(successFun) {
				successFun(paramsObj,msg);
			}
		},
		error:function(XMLHttpRequest, textStatus, errorThrown) {
			if(errorFun) {
				errorFun(paramsObj, textStatus, XMLHttpRequest);
			}
		}
	});
}

function sucQueryData(paramsObj,msg) {
	// alert(JSON.stringify(paramsObj));
	// alert(JSON.stringify(msg));
}

function errQueryData(paramsObj, textStatus, XMLHttpRequest) {
	
}

// 加载下拉选项
function initSelectItems(targetObj,datas,cusField) {
	if(targetObj && datas && $(targetObj)) {
		$.each(datas,function(k,v) {
			if(cusField) {
				$(targetObj).append("<option cusField='"+cusField[""+k]+"' value='"+k+"'>"+v+"</option>");
			} else {
				$(targetObj).append("<option value='"+k+"'>"+v+"</option>");
			}
			
		});
	}
}

