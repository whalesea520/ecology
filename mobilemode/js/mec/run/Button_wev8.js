
Mobile_NS.Button = {};

Mobile_NS.Button.onload = function(p){
	var $buttonContainer = $("#NMEC_" + p);
	$(".mecButton", $buttonContainer).each(function(){
		var script = decodeURIComponent($(this).attr("script"));
		$(this).on("click", function(){
			try{
				if(script && script != ""){
					eval((script));
				}
			}catch(e){
				console.log(e);
			}
		});
	});
};