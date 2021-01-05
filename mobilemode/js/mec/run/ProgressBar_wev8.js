if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.initProgressBar = function(id, widthDisplay, width, color, showNum){//widthDisplay显示值，超过100正常显示；width最大100
	var animtime = 600;

	function countProgressBar(id, animtime, widthDisplay) {
		var $progress_bar_line = $("#progress_bar_line" + id);
		var i = 0;
		var intervalTime = Math.abs(animtime / widthDisplay);
		if(widthDisplay > 0){
			var timerID = setInterval(function() {
				i++;
				$progress_bar_line.text(i + "%");
				if (i == Math.ceil(widthDisplay)){
					$progress_bar_line.text(widthDisplay + "%");
					clearInterval(timerID);
				}
			}, intervalTime);
		}
	}
	
	$("#progress_bar_line" + id).css("width", "0%");
	
	setTimeout(function(){
		$("#progress_bar_line" + id).css("width", width + "%");
		$("#progress_bar_line" + id).css("background-color", color);
		
		if(showNum == true){
			countProgressBar(id, animtime, widthDisplay);
		}
	}, 500);
};