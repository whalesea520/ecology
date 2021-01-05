$(document).ready(function(){
	if(_clienttype=="Webclient"){
		//var eventtype = mobilecheck() ? "touchstart" : "click";
		var eventtype = "click";
		$(".leftTD_top").on(eventtype, function(ev){
			if($("#mobileFrameContainer iframe.mobileFrame").length == 1  && (!isTopfloorPageDisplay()) && (!isRightFrameDisplay()) && (!isCurrFrameViewOpen())){
				//slidePageViewLeft();
			}else{
				var leftHasOperation = toDoLeftMenu();
				if(leftHasOperation=="true"){
					doLeftMenu();
				}else{
					doLeftButton();
				}
			}
			ev.stopPropagation();
		});
			
		$(".centerTD_top").on(eventtype, function(ev){
			
			var middleHasOperation = toDoTitle();
			if(middleHasOperation=="true"){
				var flagChang = doTitle();
				if(flagChang=="up"){
					$("#middleBtnName_top > img.menu_arrow_up").show();
					$("#middleBtnName_top > img.menu_arrow_down").hide();
				}else{
					$("#middleBtnName_top > img.menu_arrow_down").show();
					$("#middleBtnName_top > img.menu_arrow_up").hide();
				}
			}
			
			ev.stopPropagation();
		});
		
		$(".rightTD_top").on(eventtype, function(ev){
			var rightHasOperation = toDoRightMenu();
			if(rightHasOperation=="true"){
				doRightMenu();
			}else{
				//slidePageViewRight();
			}
			
			ev.stopPropagation();
		});
			
	}
});

function toDoLeftMenu(){
	var configString = hasOperation();
	var configArr = configString.split(",");
	return configArr[0];
}

function toDoTitle(){
	var configString = hasOperation();
	var configArr = configString.split(",");
	return configArr[2];
}

function toDoRightMenu(){
	var configString = hasOperation();
	var configArr = configString.split(",");
	return configArr[3];
}

function refreshWebHead(){
	var configString = hasOperation();
	var configArr = configString.split(",");
	
	if($("#mobileFrameContainer iframe.mobileFrame").length == 1 && (!isTopfloorPageDisplay()) && (!isRightFrameDisplay()) && (!isCurrFrameViewOpen())){
		changeLeftImage("none");
	}else{
		if(configArr[0]=="true"){
			changeLeftImage(configArr[1]);
		}else{
			changeLeftImage("");
		}
	}
	
	changeMiddlePageName();
	if(configArr[2]=="true"){
		$("#middleBtnName_top > img.menu_arrow_down").show();
		$("#middleBtnName_top > img.menu_arrow_up").hide();
	}else{
		$("#middleBtnName_top > img.menu_arrow_down").hide();
		$("#middleBtnName_top > img.menu_arrow_up").hide();
	}
	
	if(configArr[3]=="true"){
		changeRightImage(configArr[4]);
	}else{
		changeRightImage("");
	}
}

function changeLeftImage(imgUrl){
	if(imgUrl){
		if(imgUrl == "none"){
			$("#leftButtonName_top_change").hide();
			$("#leftButtonName_top").hide();
		}else{
			if(imgUrl.indexOf("/downloadpic.do?url=") == 0){
				imgUrl = imgUrl.substring(20);
			}
			$("#leftButtonName_top").hide();
			$("#leftButtonName_top_change > img").attr("src",imgUrl);// /downloadpic.do?url=/
			$("#leftButtonName_top_change").show();
		}
	}else{
		$("#leftButtonName_top_change").hide();
		$("#leftButtonName_top").show();
	}
}

function changeMiddlePageName(){
	var $activeFrame = getCurrActiveFrame();
	//var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		var frameWin = activeFrame.contentWindow;
		try{ // 捕获可能存在的js跨域访问出现的异常
			if(typeof(frameWin.toDoMiddlePageName) == "function"){
				var middlePageName_ = frameWin.toDoMiddlePageName();
				$("#middlePageName_top").html(middlePageName_);
			}else{
				$("#middlePageName_top").html(_appname);
			}
		}catch(e){
			$("#middlePageName_top").html(_appname);
		}
	}else{
		$("#middlePageName_top").html(_appname);
	}
}

function changeRightImage(imgUrl){
	var $rightBtnName_top = $("#rightBtnName_top");
	if(imgUrl){
		if(imgUrl.indexOf("/downloadpic.do?url=") == 0){
			imgUrl = imgUrl.substring(20);
		}
		
		var $img = $rightBtnName_top.children("img");
		
		$img.removeAttr("style");

		var i = imgUrl.indexOf("?");
		if(i != -1){
			var i2 = imgUrl.indexOf("css={", i);
			if(i2 != -1){
				var i3 = imgUrl.indexOf("}", i2);
				if(i3 != -1){
					var cssStr = imgUrl.substring(i2+5, i3);
					imgUrl = imgUrl.replace("css={"+cssStr+"}", "");
					try{
						$img.attr("style", cssStr);
					}catch(e){}
				}
			}
		}
		
		$img.attr("src",imgUrl);// /downloadpic.do?url=/
		$rightBtnName_top.show();
	}else{
		$rightBtnName_top.hide();
	}
}
