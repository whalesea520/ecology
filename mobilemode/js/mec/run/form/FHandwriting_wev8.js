Mobile_NS.FHandwriting = {};

Mobile_NS.FHandwriting.onload = function(p){
	var that = this;
	var mecid = p["id"];
	var fieldlabel = p["fieldlabel"] || "";
	var readonly = p["readonly"];
	var $field = $("#HandwritingWrap" + mecid);
	var data = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAANSURBVBhXY/j///9/AAn7A/0FQ0XKAAAAAElFTkSuQmCC";
	if(readonly != 1){
		$field.bind("click", function(){
			var fieldValue = $("#HandwritingField" + mecid).val();
			if(fieldValue){
				data = $("img", $field).attr("src");
			}
			ImgDrawing.draw({
				data : data,
				title : fieldlabel,
				type : "handwriting",
				callback : {
					done : function(base64Data){
						$field.removeClass("empty");
						$("img", $field)[0].src = base64Data;
						$("#HandwritingField" + mecid)[0].value = base64Data;
					}
				}
			});
		});
	}
}