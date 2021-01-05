jQuery(document).ready(function () {
	jQuery(".liststyle tr:gt(0)").hover(function(){
		if(jQuery(this).attr("class")!="header"){
			jQuery(this).children().css("background-color","#def0ff");
		}
	},function(){
		if(jQuery(this).attr("class")!="header"){
			jQuery(this).children().css("background-color","#fff");
		}
	});
})

function reflash(){
	jQuery(".liststyle tr:gt(0)").hover(function(){
		if(jQuery(this).attr("class")!="header"){
			jQuery(this).children().css("background-color","#def0ff");
		}
	},function(){
		if(jQuery(this).attr("class")!="header"){
			jQuery(this).children().css("background-color","#fff");
		}
	});
}