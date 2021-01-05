document.oncontextmenu = fckshowrightmenu;
document.onclick = fckhiddenrightmenu;

function fckhiddenrightmenu() {
	try{
		parent.jQuery("#rightMenu").css("visibility", "hidden");
		parent.jQuery("#rightMenu").hide();
	}catch(e){
		
	}
}
function getAbsolutePosition(obj) {
	position = new Object();
	position.x = 0;
	position.y = 0;
	var tempobj = obj;
	while (tempobj != null && tempobj != document.body) {
		position.x += tempobj.offsetLeft + tempobj.clientLeft;
		position.y += tempobj.offsetTop + tempobj.clientTop;
		tempobj = tempobj.offsetParent
	}
	position.x += parent.document.body.scrollLeft;
	// if(parent.document.getElementById("divWfBill")) position.y -=
	// parent.document.getElementById("divWfBill").scrollTop;
	return position;
}

function getIframeByElement(element){
    var iframe;
    jQuery("iframe",window.parent.document).each(function(){
        if(element.ownerDocument === this.contentWindow.document) {
            iframe = this;
        }
        return !iframe;
    });
    return iframe;
}

function fckshowrightmenu() {

	try{
		var _left = 0;
		var _top = 0;

		var event = getEvent();
		//var position = getAbsolutePosition(parent.document.getElementById(frameid));
		var position = getAbsolutePosition(getIframeByElement(document.body));
		var rightedge = parent.document.body.clientWidth - event.clientX
				- position.x;
		var bottomedge = parent.document.body.clientHeight - event.clientY
				- position.y;
		if (rightedge < parent.rightMenu.offsetWidth) {
			_left = parent.document.body.clientWidth - parent.rightMenu.offsetWidth;
		} else {
			_left = position.x + event.clientX;
		}
		/**
		 * if (bottomedge<parent.rightMenu.offsetHeight &&
		 * parent.document.getElementById(frameid).offsetHeight<=parent.document.body.clientHeight){
		 * _top = parent.document.body.clientHeight-parent.rightMenu.offsetHeight;
		 * }else{ _top = position.y+event.clientY; }
		 */
		_top = position.y + event.clientY;

		parent.jQuery("#rightMenu").css("top", _top + "px");
		parent.jQuery("#rightMenu").css("left", _left + "px");

		parent.jQuery("#rightMenu").css("visibility", "visible");
		parent.jQuery("#rightMenu").show();
		/*
		 * parent.rightMenu.style.visibility = "visible"; if (!window.ActiveXObject) {
		 * parent.rightMenu.style.display = ""; }
		 */
	}catch(e){
		
	}
	
	return false
}

function getEvent() {
	if (window.ActiveXObject) {
		return window.event;
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}