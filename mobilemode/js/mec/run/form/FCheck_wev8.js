Mobile_NS.FCheck = {};
Mobile_NS.FCheck.onload = function(p){
	var theId = p["id"];
	var readonly = p["readonly"] || "0";
	if(readonly == "1"){	//只读
		return;
	}
	var $fieldContainer = $("#div" + theId);
	$(".FCheckContainer", $fieldContainer).click(function(){
		var $field = $("#" + theId);
		if($(this).hasClass("active")){
			$(this).removeClass("active");
			$field.val("");
		}else{
			$(this).addClass("active");
			$field.val("1");
		}
		$field.change();
	});
	
};