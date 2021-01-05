$(document).ready(function(){
	$("div.yearoption").bind("mouseover",function(){
		$(this).addClass("yearoption_hover");
	}).bind("mouseout",function(){
		$(this).removeClass("yearoption_hover");
	}).bind("click",function(){
		var _val = $(this).attr("_val");
		changeYear(_val);
	});
	$("#yearpanel").bind("click",function(){
		var _t = $(this).offset().top+$("#yearpanel").height();
		var _l = $(this).offset().left;
		$("#yearselect").css({"top":_t,"left":_l}).show();
	});
	
	$("div.weekoption").bind("mouseover",function(){
		$(this).addClass("weekoption_hover");
	}).bind("mouseout",function(){
		$(this).removeClass("weekoption_hover");
	});
	$("div.week_prev").bind("mouseover",function(){
		$(this).addClass("week_prev_hover");
	}).bind("mouseout",function(){
		$(this).removeClass("week_prev_hover");
	});
	$("div.week_next").bind("mouseover",function(){
		$(this).addClass("week_next_hover");
	}).bind("mouseout",function(){
		$(this).removeClass("week_next_hover");
	});
	$("#monthpanel").bind("click",function(){
		var _t = $(this).offset().top+$(this).height();
		var _l = $(this).offset().left-17;
		$("#monthselect").css({"top":_t,"left":_l}).show();
	});
	$("#weekpanel").bind("click",function(){
		var _t = $(this).offset().top+$(this).height();
		var _l = $(this).offset().left-17;
		$("#weekselect").css({"top":_t,"left":_l}).show();
	});
});
$(document).bind("click",function(e){
	var target=$.event.fix(e).target;
	if($(target).attr("id")!="yearpanel"){
		$("#yearselect").hide();
	}
	if($(target).attr("id")!="monthpanel"){
		$("#monthselect").hide();
	}
	if($(target).attr("id")!="weekpanel"){
		$("#weekselect").hide();
	}
});