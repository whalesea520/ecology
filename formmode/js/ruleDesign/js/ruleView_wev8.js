function leftMenuClickFn(attr,level,numberType){
	$(".flowFrame").attr("src", "/formmode/js/ruleDesign/ruleDesign.jsp?ruleid=" + attr.ruleid);
}


var diag_addRule = null;
/**
 * 存为新版
 */
function newRule() {
	var flashs = new Array(); 
	var flashobj = jQuery("#wfdesign")[0];
	if (!!jQuery("#wfdesign")[0]) {
		flashobj = jQuery("#wfdesign")[0].contentWindow.document.getElementById("container");
	}
	if (!!flashobj) {
		flashs[0] = flashobj;
	}
    if (!!window.top.Dialog) {
	   diag_addRule = new window.top.Dialog();
	} else {
	   diag_addRule = new Dialog();
	}
	diag_addRule.currentWindow = window;
	diag_addRule.flashs = flashs;
	diag_addRule.Width = 376;
	diag_addRule.Height = 182;
	diag_addRule.Modal = true;
	diag_addRule.Title = "另存一个新版本"; 
	diag_addRule.URL = "/formmode/js/ruleDesign/addRule.jsp?date=" + new Date().getTime();
	diag_addRule.show();
}

function cancelsaveAsWorkflow() {
	diag_addRule.close();
}