Mobile_NS.HoriList = {};

Mobile_NS.HoriList.onload = function(p){
	var mec_id = p["id"];
	
	Mobile_NS.onTap("#NMEC_"+mec_id+" > ul > li a", function(e){e.stopPropagation();});
	Mobile_NS.onTap("#NMEC_"+mec_id+" *[stopPropagation='true']", function(e){e.stopPropagation();});
	
	Mobile_NS.imgLazyload($("#NMEC_"+mec_id), null, "#NMEC_" + mec_id);
	
	$("#NMEC_"+mec_id+" > ul > li").click(function(){
		var dataurl = $(this).attr("dataurl");
		if(dataurl && dataurl != ""){
			if(dataurl.indexOf("javascript") == 0){
				var dataurl = decodeURIComponent(dataurl);
				var script = dataurl.substring("javascript:".length);
				eval(script);
			}else{
				openDetail(dataurl, this);
			}
		}
	});
};