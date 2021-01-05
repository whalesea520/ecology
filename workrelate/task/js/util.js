
jQuery(document).ready(function(){
	setMainHeight();
});
jQuery(window).resize(function(){
	setMainHeight();
});

function setMainHeight(){
	jQuery("#maininfo").height(document.body.clientHeight-30);
}