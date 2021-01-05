
Mobile_NS.UserAvatar = {};

Mobile_NS.UserAvatar.onload = function(p){
	var theId = p["id"];
	
	var url = "/mobilemode/MECAction.jsp?action=getMecData&mec_id="+theId;
	Mobile_NS.ajax(url, Mobile_NS.pageParams, function(responseText){
		var data = $.parseJSON(responseText);
		
		var $NMECHeader = $("#NMEC_" + theId);
		
		for(var key in data){
			var value = data[key];
			
			var $textFill = $("[data-key='"+key+"'][data-fill='text']", $NMECHeader);
			if($textFill.length > 0){
				$textFill.html(value);
			}
			
			var $imgFill = $("img[data-key='"+key+"'][data-fill='src']", $NMECHeader);
			if($imgFill.length > 0){
				$imgFill.attr("src", value);
			}
		}
	});
};