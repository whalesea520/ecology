if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.DataDetail = {};

Mobile_NS.DataDetail.onload = function(id){
	$("#NMEC_" + id + " > ul.dataDetailUlFields > li > .entryContent").each(function(){
		var $entryContent = $(this);
		var v = $.trim($entryContent.html());
		var t = $.trim($entryContent.text());
		if(v == t){	//纯文本
			
			if((/(\+\d+)?1[3458]\d{9}$/.test(v)) || (/^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/.test(v))){	//普通的电话号码文本
				var vHtml = "<a href=\"javascript:Mobile_NS.callMobile('"+v+"');\" class=\"phone-number\">" + v +"</a>";
				$entryContent.html(vHtml);
			}else{
				
				Mobile_NS.DataDetail.isAddr(v, (function($ec) {
					return function(result){
						if(result){
							var vHtml = "<a href=\"javascript:Mobile_NS.openMap('"+v+"');\" class=\"chinese-address\">" + v +"</a>";
							$ec.html(vHtml);
						}
					}
				})($entryContent));
			}
			
		}
		
	});
};

Mobile_NS.DataDetail.isAddr = function(v, callbackFn){
	var addrKeyWord = ["省", "市", "区", "县", "镇", "街", "路", "弄", "号", "室"];
	
	/*初步筛选判断是否可能是一个地址*/
	var flag = false;
	for(var i = 0; i < addrKeyWord.length; i++){
		if(v.indexOf(addrKeyWord[i]) != -1){
			flag = true;
			break;
		}
	}
	
	
	/*百度api逆地址解析，能解析出来才说明通过*/
	if(flag){
		var map = new BMap.Map();
		var localSearch = new BMap.LocalSearch(map, { //智能搜索
			onSearchComplete: function(results){
	            if(results.getNumPois() > 0){
	    			callbackFn.call(null, true);
	            }else{
	            	callbackFn.call(null, false);
	            }
	    	}
	    });
	    localSearch.search(v);
	}
	
	
};