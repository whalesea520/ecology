Mobile_NS.FCheckbox = {};
Mobile_NS.FCheckbox.onload = function(p){
	var theId = p["id"];
	var $fieldContainer = $("#div" + theId);
	$(".FCheckboxContainer ul li", $fieldContainer).click(function(){
		var readonly = $(this).attr("readonly");
		if(readonly == "1"){
			return;
		}
		var v = $(this).attr("data-value");
		var $field = $("#" + theId);
		var fieldV = $field.val();
		
		var cbType = $(this).parent().parent().attr("cb-type");
		
		if(cbType == "1"){	//多选
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
				fieldV = ("," + fieldV).replace(("," + v), "");
			}else{
				$(this).addClass("checked");
				fieldV += "," + v;
			}
			
			if(fieldV.indexOf(",") == 0){
				fieldV = fieldV.substring(1);
			}
		}else{	//单选
			if(!$(this).hasClass("checked")){
				$(this).siblings(".checked").removeClass("checked");
				$(this).addClass("checked");
				fieldV = v;
			}else{
				$(this).removeClass("checked");
				fieldV = "";
			}
		}
		
		$field.val(fieldV);
	});
	
};
Mobile_NS.FCheckbox.reset = function(theId){
	var $field = $("#" + theId);
	var fieldV = $field.val();
	var $fieldContainer = $("#div" + theId);
	$(".FCheckboxContainer ul li", $fieldContainer).each(function(){
		var v = $(this).attr("data-value");
		if((fieldV + ",").indexOf((v + ",")) != -1){
			if(!$(this).hasClass("checked")){
				$(this).addClass("checked");
			}
		}else{
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}
		}
	});
};