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
});
$(document).bind("click",function(e){
	var target=$.event.fix(e).target;
	if($(target).attr("id")!="yearpanel"){
		$("#yearselect").hide();
	}
});