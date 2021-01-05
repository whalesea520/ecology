Mobile_NS.NavPanel = {};

Mobile_NS.NavPanel.onload = function(p){
	var theId = p["id"];
	var containerId = "NMEC_"+theId;
	var $container = $("#"+containerId);
	var sildeCount = $container.find(".navPanelContainer").length;
	if(sildeCount <= 1){
		$("#"+containerId+"").css("visibility", "visible");
		$("#"+containerId+" .navPanel-point").hide();
	}else{
		var params = {
			continuous: false,
			disableScroll: true,
			stopPropagation: true,
			callback: function(index, element) {
				$("#"+containerId+" .navPanel-point b").removeClass("currPoint");
				$("#"+containerId+" .navPanel-point b").eq(index).addClass("currPoint");
			},
			transitionEnd: function(index, element) {
			}
		};
		
		Swipe($container[0], params);
	}
	
};

