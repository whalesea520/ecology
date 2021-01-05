$(document).ready(function(){
	initInfoDate();
	
	initCenterMenuCount();
	
	initCenterMenuEvent();
	
	initMenuSystemEvent();
	
	initFooterMenuEvent();
});

function slidePageViewLeft(){
	slidePageView("left");
}

function slidePageViewRight(){
	slidePageView("right");
}

function slidePageView(direction){
	lockFramePage();
	var $mainContainer = $("#main-container");
	if($mainContainer.hasClass("effected")){
		resetPageViewSlide();
		setTimeout(releaseFramePage, 500);
	}else{
		$(".page-slide").hide();
		$("#"+direction+"-slide-page").show();

		$mainContainer[0].className = "main-container"; // clear
		$mainContainer.addClass("effected").addClass("effect-" + direction);
		
		setTimeout( function() {
			var eventtype = "click";
			$(document.body).on(eventtype, function(evt){
				if(hasParentClass(evt.target, "page-view")) {
					resetPageViewSlide();
					$(document.body).off(eventtype);
					setTimeout(releaseFramePage, 500);
				}
			});
		}, 25);
	}
}

function resetPageViewSlide(){
	$("#main-container")[0].className = "main-container"; // clear
}

function initInfoDate(){
	var str = "";
	var _date = new Date();
	str += _date.getFullYear() + "年";
	str += (parseInt(_date.getMonth()) + 1) + "月";
	str += _date.getDate() + "日";
	
	str += "&nbsp;&nbsp;";
	
	var Week = ['日','一','二','三','四','五','六'];  
	str += "星期" + Week[_date.getDay()];
	$("#right-page-header .info-date").html(str);
}

function initCenterMenuCount(){
	$("#left-page-center .center-menu ul li").each(function(){
		var $that = $(this);
		var url = $that.attr("count");
		if(!url){
			return;
		}
		$.get(url, null, function(responseText){
			try{
				var data = $.parseJSON(responseText);
				var count = parseInt(data["count"]) || 0;
				var $menuRemind = $(".menu-remind", $that);
				if(count > 0){
					if(count > 99){
						count = "99+";
					}
					if($menuRemind.length == 0){
						$menuRemind = $("<div class=\"menu-remind\"></div>");
						$that.append($menuRemind);
					}
					$menuRemind.html(count);
				}else{
					if($menuRemind.length > 0){
						$menuRemind.remove();
					}
				}
			}catch(e){}
		});
	});
}

function initCenterMenuEvent(){
	$("#left-page-center .center-menu ul li").click(function(evt){
		if(!$(this).hasClass("selected")){
			$(this).siblings(".selected").removeClass("selected");
			$(this).addClass("selected");
			
			var url = $(this).attr("url");
			//var menuName = $(".menu-text", $(this)).html();
			setTimeout(function(){
				if(url && url != ""){
					//$("#middlePageName_top").html(menuName);
					openNewPage(url);
				}
			}, 200);
		}
		
		resetPageViewSlide();
		var eventtype = "click";
		$(document.body).off(eventtype);
		setTimeout(releaseFramePage, 500);
		
	});
}

function removeAllFrame(){
	$("#mobileFrameContainer iframe").remove();
	$(".st-menu iframe:not(.lazy-frame)").remove();
}

function openNewPage(url){
	removeAllFrame();
	$("#loading").show();
	
	var $frame = $("<iframe class=\"mobileFrame activeFrame\" frameborder=\"0\" scrolling=\"auto\"></iframe>");
	$("#mobileFrameContainer").append($frame);
	
	$frame[0].onload = function(){
		$("#loading").hide();
		resetActiveFrame();
		giveCurrFrameAId(this);
		refreshWebHead();
	};
	$frame[0].src = url;
}

function initMenuSystemEvent(){
	$("#menu-system").on("click", function(){
		location.href = "/logout.do";
	});
}

function initFooterMenuEvent(){
	$("#menu-home").click(function(){
		$("#left-page-center .center-menu ul li").first().trigger("click");
	});
}