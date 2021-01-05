Mobile_NS.FScores = {};
Mobile_NS.FScores.onload = function(p){
	var theId = p["id"];
	var readonly = p["readonly"] || "0";
	if(readonly == "1"){	//只读
		return;
	}
	var text = p["text"];
	var textArr = text.split(",");
	var $fieldContainer = $("#div" + theId);
	$(".score-rating > b", $fieldContainer).click(function(){
		var index = $(this).index();
		
		$(this).siblings("b.active").removeClass("active");
		$(this).addClass("active");
		$(this).parent().addClass("score-fill");
		
		var t = "";
		if(index < textArr.length){
			t = textArr[index];
		}
		$(this).siblings("label").html(t);
		
		var $field = $("#" + theId);
		var v = index + 1;
		$field.val(v);
		$field.change();
	});
};