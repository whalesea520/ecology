
function banBackSpace(e) {
	var ev = e || window.event;
	var element = ev.target || ev.srcElement;
	var type = element.type || element.getAttribute("type");
	
	var vReadOnly = element.readOnly;
	var vDisabled = element.disabled;
	var flag1 = (ev.keyCode == 8 && (type == "password" || type == "text" || type == "textarea") && (vReadOnly == true || vDisabled == true)) ? true : false;
	var flag2 = (ev.keyCode == 8 && type != "password" && type != "text" && type != "textarea") ? true : false;
	if (flag1) {
		return false;
	}
	if (flag2) {
		return false;
	}
}
document.onkeypress = banBackSpace;
document.onkeydown = banBackSpace;

