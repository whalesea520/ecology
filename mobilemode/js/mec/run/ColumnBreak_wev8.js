Mobile_NS.ColumnBreak = {};

Mobile_NS.ColumnBreak.initColumnBreak = function(theId, mecJson){
	var $column_break = $("#NMEC_" + theId);
	var $left_line = $(".left_line", $column_break);
	var $middle_content = $(".middle_content", $column_break);
	var $right_line = $(".right_line", $column_break);
	
	var scrollWidth = $column_break.width();
	var displayStyle = mecJson["displayStyle"];
	if(displayStyle == "1"){
		$column_break.removeClass("column_break_midStyle");
		var leftLineWidth = $left_line.width();
		var middleContentWidth = $middle_content.width();
		var rightLineWidth = scrollWidth - leftLineWidth - middleContentWidth;
		$right_line.width(rightLineWidth + "px");
	}else if(displayStyle == "2"){
		$column_break.addClass("column_break_midStyle");
		var middleContentWidth = $middle_content.width();
		var lineWidth = (scrollWidth - middleContentWidth)/2;
		$left_line.width(lineWidth + "px");
		$right_line.width(lineWidth + "px");
		$middle_content.css("left", lineWidth + "px");
	}
}