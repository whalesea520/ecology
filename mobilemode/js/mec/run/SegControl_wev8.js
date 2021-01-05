Mobile_NS.SegControl = {};

Mobile_NS.SegControl.onload = function(p){
	
	var theId = p["id"];
	var btn_datas = p["btn_datas"];
	
	$("a", "#NMEC_"+theId).each(function(){
		
		var $this = $(this);
		
		var segId = $this.attr("segId");
		for(var i = 0; i < btn_datas.length; i++){
			var data = btn_datas[i];
			if(data["segId"] == segId){
				var segScript = data["segScript"];
				$this.click(function(e){
					$this.siblings().removeClass("active");
					$this.addClass("active");
					
					Mobile_NS.dynamicRunCode(segScript);
					
					e.stopPropagation();
				});
				break;
			}
		}
		
	});
	
};