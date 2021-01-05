
function getLoadingDiv(){
	var languageid = readCookie("languageidweaver");
	var txt = SystemEnv.getHtmlNoteName(3417,languageid);
	/*if(languageid==8){
		txt = "Searching, please wait ...";
	}else if(languageid==9){
		txt = "正在查詢，請稍候...";
	}else{
		txt = "正在查询，请稍候...";
	}*/
	return jQuery("<div style=\"display:none;\" id=\"e8_loading\" class=\"e8_loading\">"+txt+"</div>");
}

function getTreeSwitch(){
	var languageid = readCookie("languageidweaver");
	jQuery("<div style=\"display:none;\" id=\"e8TreeSwitch\" class=\"e8_expandOrCollapseDiv\"></div>")
}


jQuery(document).ready(function(){
	setInnerStyle("#deeptree",{overflow:"hidden"});
});

function setInnerStyle(id,styles){
	jQuery(id).css(styles);
}
