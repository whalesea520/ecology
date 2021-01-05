//--------------------------------------
// 流程签字意见分页用javaScript
// 因此处iFrame上图片可能还没有加载完成，故把本方法中调整iFrame高度的代码去掉。
//--------------------------------------
function bodyresize(_document, iframeId, eachCnt){
	try {	
		var objAList = _document.getElementsByTagName("A");
		for(var i=0; i<objAList.length; i++){
			var obj = objAList[i];
			var href = obj.href;
			var target = obj.target;
			if(href.indexOf("javascript:") == -1){
				obj.target = "_blank";
			}
		}
	} catch (e){}
	window.setTimeout(function(){
		bodyresize(_document, iframeId, eachCnt);
    },500);
}

//对签单意见内容中图像作调整。
function imgResize(docObj, ifrmID, imgObj){
    var $imgObj = jQuery(imgObj);
    //获取当前iFrame的宽度。因img标签父节点有padding属性，故需要在iFrame的宽度基础上减少一定距离。
    var ifrmWidth = jQuery("#" + ifrmID).width() - 20;
    var imgWidth = $imgObj.width();
    var imgHeight = $imgObj.height();
    //如果图片宽度大于iFrame宽度，则对图片进行等比例缩小。
    if(imgWidth > ifrmWidth){
	newHeight = ifrmWidth * imgHeight / imgWidth;
	$imgObj.width(ifrmWidth);
	$imgObj.height(newHeight);
    }
    
    ifrResize(docObj, ifrmID, 1);
}

//对存放签字意见内容的iFrame的高度作调整。
function ifrResize(docObj, ifrmID, eachCnt){
    if (eachCnt >= 20) {
	return;
    }
    eachCnt++ ;
    
    var funObj = function(){
	ifrResize(docObj, ifrmID, eachCnt);
    }
    
    //部分客户端加载比较慢，第一次调用时候iframe内body子节点的table标签的ViewForm样式(字体设置成9pt)
    //可能没有应用完成。进行造成iframe的高度比 table高度大很多，而致使签字意见栏过高的问题。故在第一次
    //时候，首先等待0.5秒再执行。
    if (eachCnt == 2)
    {
        window.setTimeout(function(){
            funObj();
        },500);
        return;
    }
    
    var bodyContentHeight = 0;
    if (jQuery.client.browser == "Explorer") {
    	bodyContentHeight = docObj.body.scrollHeight+11;
    } else if (jQuery.client.browser == "Firefox") {
    	bodyContentHeight = docObj.body.offsetHeight;
    } else if (jQuery.client.browser == "Chrome" || jQuery.client.browser == "Safari") {
    	bodyContentHeight = jQuery(docObj.body).find("TABLE").height();
    }
    

    try{
	var valHei = jQuery("#" + ifrmID).height();
	//如果页面上当前iframe未加载完成，则等待500毫秒之后再次处理。
	if(bodyContentHeight == 0){
	    window.setTimeout(new function(){ funObj(); } , 800);
	} else {
	    jQuery("iframe[name=" + ifrmID+"]").height(bodyContentHeight);
		//alert(jQuery(window.frames[ifrmID].document.body).find("table").get(0).offsetWidth+":"+jQuery("iframe[name=" + ifrmID+"]").parent().width());
	    if (jQuery(window.frames[ifrmID].document.body).find("table").get(0).offsetWidth >jQuery("iframe[name=" + ifrmID+"]").parent().width()){
          	  jQuery("iframe[name=" + ifrmID+"]").height(bodyContentHeight+20);
	    }
	}
	jQuery("#" + ifrmID).attr("id", "");
    }catch(e){
    } 
}

function setIframeBodyContent(_contentWindow, tmpContextDiv, iframeId, _iframeHtml) {
    try {
    	_iframeHtml = _iframeHtml.replace(/<p><br\/><\/p>/,"").replace("<table>","<table class='wfsigntbl'>"); 
        jQuery(_contentWindow.document.body).html("<table style=\"border-spacing:0px !important;\" class=\"ViewForm\" width=99.9%><tr><td style=\"border:0px;border-spacing:0px !important;\">" + _iframeHtml + "</td></tr></table>");
    } catch(e) {
    	alert(e);
    }
}

function setIframeContent(_iframeId, _iframeHtml, docObj) {
    try {
        var _tcontentWindow = document.getElementById(_iframeId).contentWindow;
        _tcontentWindow.document.write("<html ><LINK href=\"/css/Weaver_wev8.css\" type=text/css rel=STYLESHEET>" 
    	    + "<LINK href=\"/css/rp_wev8.css\" rel=\"STYLESHEET\" type=\"text/css\">" 
    	    + "<body style=\"border:0px;margin:0px;padding:0px;\"  class='"+_iframeId+"' onclick=\"parent.triggerMouseupHandle()\" onload=\"" + "document.oncontextmenu = function () {parent.fckshowrightmenu(document, '" + _iframeId + "');return false;};document.onclick = parent.fckhiddenrightmenu;" + "\" bgColor=\"transparent\"></body></html>");
        _tcontentWindow.document.close();
        setIframeBodyContent(_tcontentWindow, _iframeId + "Div", _iframeId, _iframeHtml);
        
        var len = 0;
        //对签字意见内容中的手写签批图片的img标签加上 load事件。
        var $imgObj = jQuery("img[alt='signture']", docObj);
        $imgObj.each(function(i){
	    	jQuery(this).bind("load", function(){
	    		imgResize(docObj, _iframeId, this);
	    	})
        });
        len += $imgObj.length;
        
        //对签字意见内容中的电子签章图片的img标签加上 load事件。
        $imgObj = jQuery("img[name='electricSignature']", docObj);
        $imgObj.each(function(i){
	    	jQuery(this).bind("load", function(){
	    		imgResize(docObj, _iframeId, this);
	    	})
        });
        len += $imgObj.length;
        
        //对签字意见内容中的表单签章图片的object标签加上 load事件。
        $imgObj = jQuery("object[name='formSignature']", docObj);
        $imgObj.each(function(i){
	    	jQuery(this).bind("load", function(){
	    		imgResize(docObj, _iframeId, this);
	    	})
        });
        len += $imgObj.length;
        
        //如果签字意见内容不包含手写签批内容，则手动调用方法调整iFrame的高度。
        if(len == 0){
    	    ifrResize(docObj, _iframeId, 1);
        }
    } catch(e){}
}


function fckhiddenrightmenu(){
	rightMenu.style.visibility="hidden";
    if (!window.ActiveXObject) {
		rightMenu.style.display = "none";
 	}
}

function getAbsolutePosition(_document, obj) {
    var position = new Object();
    position.x = 0;
    position.y = 0;
    var tempobj = obj;
    while(tempobj != null && tempobj != _document.body) {
    	position.x += tempobj.offsetLeft + tempobj.clientLeft;
    	position.y += tempobj.offsetTop + tempobj.clientTop;
    	tempobj = tempobj.offsetParent;
    }
    position.x += document.body.scrollLeft;
    if(document.getElementById("divWfBill")) {
    	position.y -= document.getElementById("divWfBill").scrollTop;
    }
    return position;
}

function fckshowrightmenu(_document, iframeId){
	var event = getIframeEvent(iframeId);
	var position = getAbsolutePosition(_document, document.getElementById(iframeId));
	var rightedge = document.body.clientWidth - event.clientX - position.x;
	var bottomedge = document.body.clientHeight - event.clientY - position.y;
	if (rightedge < rightMenu.offsetWidth){
		rightMenu.style.left = document.body.clientWidth - rightMenu.offsetWidth;
	}else{
		rightMenu.style.left = position.x + event.clientX;
	}
	
	//if (bottomedge < rightMenu.offsetHeight && document.getElementById(iframeId).offsetHeight <= document.body.clientHeight){
	//	rightMenu.style.top = document.body.clientHeight - rightMenu.offsetHeight;
	//}else{
		rightMenu.style.top = position.y + event.clientY;
	//}
	
	rightMenu.style.visibility = "visible";
	if (!window.ActiveXObject) {
		rightMenu.style.display = "";
	}
	return false
}

function getIframeEvent(iframeId) {
	if (window.ActiveXObject) {
		return document.getElementById(iframeId).contentWindow.event;// 如果是ie
	}
	func = getIframeEvent.caller;
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

function aboutVersion(versionid) {
	alert("当前是V" + versionid + "版本");
}