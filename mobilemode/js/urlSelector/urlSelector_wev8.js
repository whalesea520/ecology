

function URLSelector(eleid){
	this.eleid =  eleid;
}

URLSelector.data = [];

URLSelector.initData = function(data){
	URLSelector.data = data;
	$(".url-selector-panel").remove();
};

URLSelector.prototype.init = function(){
	var that = this;
	var $ele = $("#" + that.eleid);
	if($ele.length == 0){return;}
	
	$ele.css({
		"padding-right": "22px"
	});
	
	var $pEle = $ele.parent();
	var positionStyle = $pEle.css("position");
	if(positionStyle == "static"){
		$pEle.css("position", "relative");
	}
	
	/*
	var $pEle = $ele.parent();
	$pEle.css("position", "relative");
	
	var position = $ele.position();
	console.log(position.left);
	console.log(position.top);
	console.log($ele.outerHeight());
	console.log($pEle.outerWidth());
	
	var r = parseInt($pEle.outerWidth() - (position.left + $ele.outerWidth()));*/
	

	var $arrow = $ele.siblings(".url-selector-arrow");
	if($arrow.length == 0){
		$arrow = $("<div class=\"url-selector-arrow\"></div>");
		$ele.after($arrow);
	}
	
	$arrow.click(function(e){
		var $panel = that.getPanel();
		if($panel.length == 0){
			that.createPanel();
		}else{
			if($panel.is(':visible')){
				that.hidePanel();
			}else{
				that.showPanel();
			}
		}
		e.stopPropagation();
	});
};

URLSelector.prototype.getPanelId = function(){
	return this.eleid + "_url_selector";
};

URLSelector.prototype.getPanel = function(){
	return $("#" + this.getPanelId());
};

URLSelector.prototype.createPanel = function(){
	var that = this;
	var id = that.getPanelId();
	var $panel = $("<div id=\""+id+"\" class=\"url-selector-panel\"></div>");
	
	$panel.append("<div class=\"url-selector-panel-search\"><input type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4748)+"\"/></div>");//请输入检索项
	
	var html = "<div class=\"url-selector-panel-content\">";
	html += "<ul>";
	for(var i = 0; i < URLSelector.data.length; i++){
		var name = URLSelector.data[i]["name"];
		var url = URLSelector.data[i]["url"];
		html += "<li data-url=\""+url+"\">"+name+"</li>";
	}
	html += "</ul>";
	html += "</div>";
	$panel.append(html);
	
	$(document.body).append($panel);
	
	$("li", $panel).click(function(){
		var url = $(this).attr("data-url");
		that.setValue(url);
	}).mouseover(function(){
		$(this).removeClass("selected");
	});
	
	$(".url-selector-panel-search input", $panel).click(function(e){
		e.stopPropagation();
	}).bind("input", function(){
		var v = $(this).val();
		$("li.selected", $panel).removeClass("selected");
		$("li", $panel).each(function(){
			var t = $(this).text();
			if(t.toLowerCase().indexOf(v.toLowerCase()) == -1){
				$(this).addClass("not-match");
			}else{
				$(this).removeClass("not-match");
			}
		});
	}).bind("keydown", function(e){
		switch(e.keyCode){
		    case 38: //向上键
		    	var $li = $("li.selected", $panel).removeClass("selected").prevAll(":not(.not-match)").eq(0);
		    	if($li.length == 0){
		    		$li = $("li", $panel).not(".not-match").last();
		    	}
		    	$li.addClass("selected");
		    	if($li.length > 0){
		    		$li.get(0).scrollIntoView(false);
		    	}
		    	e.preventDefault(); 
		    	break;
		    case 40: //向下键
		    	var $li = $("li.selected", $panel).removeClass("selected").nextAll(":not(.not-match)").eq(0);
		    	if($li.length == 0){
		    		$li = $("li", $panel).not(".not-match").first();
		    	}
		    	$li.addClass("selected");
		    	if($li.length > 0){
		    		$li.get(0).scrollIntoView(false);
		    	}
		    	e.preventDefault(); 
		    	break;
		    case 13: //回车
		    	var $li = $("li.selected", $panel);
		    	if($li.length > 0){
		    		$li.trigger("click");
		    	}
		    	break;
		    default:
		    	break;
		}
		
	});
	that.showPanel();
};

URLSelector.prototype.showPanel = function(){
	var that = this;
	var $ele = $("#" + that.eleid);
	var $panel = that.getPanel();
	
	var $input = $(".url-selector-panel-search input", $panel);
	if($input.val() != ""){
		$input.val("").trigger("input");
	}
	
	var offset = $ele.offset();
	
	var t;
	if(($(window).height() - (offset.top + $ele.outerHeight())) < $panel.height()){
		t = offset.top - $(document.body).scrollTop() - $panel.height() - 3;
	}else{
		t = offset.top - $(document.body).scrollTop() + $ele.outerHeight() + 3;
	}
	var l = offset.left + $ele.outerWidth() - $panel.width();
	$panel.css({
		"top": t + "px",
		"left": l + "px"
	});
	$panel.slideDown(200, function(){
		$(".url-selector-panel-search input", this)[0].focus();
	});
};

URLSelector.prototype.hidePanel = function(){
	var $panel = this.getPanel();
	$panel.slideUp(100);
};

URLSelector.prototype.setValue = function(v){
	var that = this;
	var $ele = $("#" + that.eleid);
	var oldV = $ele.val();
	if(oldV != ""){
		var i = oldV.indexOf("&");
		if(i != -1){
			var paramStr = oldV.substring(i);
			v = v + paramStr;
		}
	}
	$ele.val(v).focus();
};

$(document.body).click(function(){
	$(".url-selector-panel").slideUp(100);
});


