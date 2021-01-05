function hasOperation(){
	var $activeFrame = getCurrActiveFrame();
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		var frameWin = activeFrame.contentWindow;
		try{ // 捕获可能存在的js跨域访问出现的异常
			if(typeof(frameWin.hasOperationConfig) == "function"){
				return frameWin.hasOperationConfig();
			}else{
				return "";
			}
		}catch(e){
			return "";
		}
	}else{
		return "";
	}
}

function doDefaultLeftSlide(){
}

function doDefaultRightSlide(){
}

function doLeftMenu(){
	var $activeFrame = getCurrActiveFrame();
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		var frameWin = activeFrame.contentWindow;
		try{ // 捕获可能存在的js跨域访问出现的异常
			if(typeof(frameWin.doLeftMenuConfig) == "function"){
				return frameWin.doLeftMenuConfig();
			}else{
				return "";
			}
		}catch(e){
			return "";
		}
	}else{
		return "";
	}
}

function doRightMenu(){
	var $activeFrame = getCurrActiveFrame();
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		var frameWin = activeFrame.contentWindow;
		try{ // 捕获可能存在的js跨域访问出现的异常
			if(typeof(frameWin.doRightMenuConfig) == "function"){
				return frameWin.doRightMenuConfig();
			}else{
				return "";
			}
		}catch(e){
			return "";
		}
	}else{
		return "";
	}
}

var _mobile_title_flag = true;
function doTitle(){
	var $activeFrame = getCurrActiveFrame();
	var result = "";
	if(_mobile_title_flag){
		if($activeFrame.length > 0){
			var activeFrame = $activeFrame[0];
			var frameWin = activeFrame.contentWindow;
			try{ // 捕获可能存在的js跨域访问出现的异常
				if(typeof(frameWin.doUpTitle) == "function"){
					frameWin.doUpTitle();
				}
			}catch(e){
				
			}
		}
		result = "up";
	}else{
		if($activeFrame.length > 0){
			var activeFrame = $activeFrame[0];
			var frameWin = activeFrame.contentWindow;
			try{ // 捕获可能存在的js跨域访问出现的异常
				if(typeof(frameWin.doDownTitle) == "function"){
					frameWin.doDownTitle();
				}
			}catch(e){
				
			}
		}
		result = "down";
	}
	_mobile_title_flag = !_mobile_title_flag;
	return result;
}

function resetTitle(){
	_mobile_title_flag = true;
	$("#middleBtnName_top > img.menu_arrow_down").show();
	$("#middleBtnName_top > img.menu_arrow_up").hide();
	if(_clienttype!="Webclient"){
		location = "emobile:titledown";
	}
}