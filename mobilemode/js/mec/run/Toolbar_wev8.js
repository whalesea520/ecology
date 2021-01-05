Mobile_NS.Toolbar = {};

Mobile_NS.Toolbar.onload = function(p){
	var theId = p["id"];
	var containerId = "toolbarWrap"+theId;
	var $container = $("#"+containerId);
	var sildeCount = $container.find(".toolbarContainer").length;
	if(sildeCount <= 1){	/*只有一张图片，不作为幻灯片显示*/
		$("#"+containerId+"").css("visibility", "visible");
		$("#"+containerId+" .toolbar-point").hide();
	}else{
		var params = {
			continuous: false,
			disableScroll: true,
			stopPropagation: true,
			callback: function(index, element) {
				$("#"+containerId+" .toolbar-point b").removeClass("currPoint");
				$("#"+containerId+" .toolbar-point b").eq(index).addClass("currPoint");
			},
			transitionEnd: function(index, element) {
			}
		};
		
		Swipe($container[0], params);
	}
	
	var isFixedBottom = p["isFixedBottom"];
	if(isFixedBottom == "1"){
		$("#scroll_footer").append($("#abbr_"+theId)).show();
		$("#scroll_wrapper").css("bottom", $("#scroll_footer").height());		
	}
};

