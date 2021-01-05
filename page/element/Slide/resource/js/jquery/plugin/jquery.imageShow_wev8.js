
/* 
* imageShow 0.1 
* Copyright (c) 2009 WangChengCai
* Date: 2010-03-30 
* 
*/
(function ($) {
	$.fn.imageShow = function (options, speed_out, speed_in) {
		var opts = $.extend({}, $.fn.imageShow.defaults, options);
		var smallImgAEle = "#" + opts.smallImgULId + " li a";
		$("#" + opts.scrollimgTigHovId).each(function () {
			$.dequeue(this, "fx");
		}).animate({top:$($(smallImgAEle).get(0)).offset().top - 4, left:$($(smallImgAEle).get(0)).offset().left}, 0, "easeOutExpo");
		$("#" + opts.scrollimgTigHovId).show();
		var smallImgs = $(smallImgAEle);
		var curr = $(smallImgAEle).get(0);
		var nextImg = $(smallImgAEle).get(0);
		setTimer(smallImgs, curr, nextImg);
		
		$(smallImgAEle).hover(function () {
			$("#" + opts.scrollimgTigHovId).stopTime("autoRun");
			curr = this;
			animation(this);
			setTimer(smallImgs, curr, nextImg);
		}, function () {
			//
		});
		function animation(ele) {
			$("#" + opts.scrollimgTigHovId).each(function () {
				$.dequeue(this, "fx");
				
			}).animate({top:$(ele).offset().top - 4, left:$(ele).offset().left}, speed_in, "easeOutExpo");
			
			
			$("." + opts.bigImageClass).fadeOut(speed_out);
			$("." + opts.bigImageDetaildClass).fadeOut(speed_out);
			
			var cur_dis = $("." + opts.bigImageClass).get(parseInt($(ele).attr("href").substr(1) - 1));
			var cur_dis_des = $("." + opts.bigImageDetaildClass).get(parseInt($(ele).attr("href").substr(1) - 1));
			$(cur_dis_des).css("filter", "alpha(opacity=40)");
			
			$(cur_dis).fadeIn(speed_in);
			$(cur_dis_des).fadeIn(speed_in);
	

		}
		function setTimer(smallImgAEle, curr, nextImg) {
			$("#" + opts.scrollimgTigHovId).everyTime("5s", "autoRun", function () {
				var imgIndex = -1;
				for (var i = 0; i < smallImgAEle.length; i++) {
					if ($(smallImgAEle).get(i) == curr) {
						imgIndex = i;
						break;
					}
				}
				if ((imgIndex + 1) <= (smallImgAEle.length - 1)) {
					nextImg = $(smallImgAEle).get(imgIndex + 1);
					if ($(nextImg).offset().top != $(curr).offset().top) {
						nextImg = $(smallImgAEle).get(0);
					}
					animation(nextImg);
					curr = nextImg;
				} else {
					nextImg = $(smallImgAEle).get(0);
					animation(nextImg);
					curr = nextImg;
				}
			});
		}
	};
	$.fn.imageShow.defaults = {smallImgULId:"nav", scrollimgTigHovId:"bigHover", bigImageClass:"bigimgdis", bigImageDetaildClass:"imgdetaild"};
})(jQuery);




/* 
* imageVerticalShow 0.1 
* Copyright (c) 2009 WangChengCai
* Date: 2010-03-30 
* 
*/ 
(function($){
    $.fn.imageVerticalShow = function(options, speed_out, speed_in) {
        var opts = $.extend({},$.fn.imageVerticalShow.defaults, options);
        
        var smallImgAEle = ".moveInt"
        
        $("#" + opts.scrollimgTigHovId).each(function(){
						$.dequeue(this, "fx");}).animate({
						    top : $($(smallImgAEle).get(0)).offset().top-5 ,
								left: $($(smallImgAEle).get(0)).offset().left-10
				    },0, 'backout');
        
        $("#" + opts.scrollimgTigHovId).show();
   
        var smallImgs = $(smallImgAEle);
        var curr = $(smallImgAEle).get(0);
        var nextImg = $(smallImgAEle).get(0);
        setTimer(smallImgs, curr, nextImg);
        
        $(smallImgAEle).hover(
            function() {
            	$("#" + opts.scrollimgTigHovId).stopTime("autoRun");
            	curr = this;
					    animation(this);
					    setTimer(smallImgs, curr, nextImg);
	          },
            function() {}
        );
        
		    function animation(ele) {
		    			$("#" + opts.scrollimgTigHovId).each(function(){
							$.dequeue(this, "fx");}).animate({
							    top : $(ele).offset().top - 5,
									left: $(ele).offset().left - 10
					    },speed_in, 'easeOutExpo');
		    	
		    	
		    	    $("." + opts.bigImageClass).fadeOut(speed_out);
					    //$("." + opts.bigImageDetaildClass).fadeOut(speed_out);
							
					    var cur_dis = $("." + opts.bigImageClass).get(parseInt($(ele).attr('_target').substr(1) -1));
						
							//var cur_dis_des = $("." + opts.bigImageDetaildClass).get(parseInt($(ele).attr('href').substr(1) -1));
							
							
							//$(cur_dis_des).css("filter", "alpha(opacity=40)");
								
							$(cur_dis).fadeIn(speed_in);
							//$(cur_dis_des).fadeIn(speed_in);	
		    }
		    
		   function setTimer(smallImgAEle, curr, nextImg) {
					$("#" + opts.scrollimgTigHovId).everyTime("5s", "autoRun", function () {
						var imgIndex = -1;
						for (var i = 0; i < smallImgAEle.length; i++) {
							if ($(smallImgAEle).get(i) == curr) {
								imgIndex = i;
								break;
							}
						}
						if ((imgIndex + 1) <= (smallImgAEle.length - 1)) {
							nextImg = $(smallImgAEle).get(imgIndex + 1);
							if ($(nextImg).offset().left != $(curr).offset().left) {
								nextImg = $(smallImgAEle).get(0);
							}
							animation(nextImg);
							curr = nextImg;
						} else {
							nextImg = $(smallImgAEle).get(0);
							animation(nextImg);
							curr = nextImg;
						}
					});
			}
        
    };
    
    $.fn.imageVerticalShow.defaults = {
		    smallImgULId:'nav',
		    scrollimgTigHovId:'bigHover',
		    bigImageClass:'bigimgdis',
		    bigImageDetaildClass:'imgdetaild'
	  };
})(jQuery);

/* 
* imageVerticalShow 0.1 
* Copyright (c) 2009 WangChengCai
* Date: 2010-03-30 
* 
*/ 
(function($){
    $.fn.imageVerticalShowRight = function(options, speed_out, speed_in) {
        var opts = $.extend({},$.fn.imageVerticalShowRight.defaults, options);
        
        var smallImgAEle = ".moveClass"
        
        $("#" + opts.scrollimgTigHovId).each(function(){
						$.dequeue(this, "fx");}).animate({
						    top : $($(smallImgAEle).get(0)).offset().top ,
								left: $($(smallImgAEle).get(0)).offset().left -12
				    },0, 'backout');
        
        $("#" + opts.scrollimgTigHovId).show();
   
        var smallImgs = $(smallImgAEle);
        var curr = $(smallImgAEle).get(0);
        var nextImg = $(smallImgAEle).get(0);
        setTimer(smallImgs, curr, nextImg);
        
        $(smallImgAEle).hover(
            function() {
            	$("#" + opts.scrollimgTigHovId).stopTime("autoRun");
            	curr = this;
					    animation(this);
					    setTimer(smallImgs, curr, nextImg);
	          },
            function() {}
        );
        
		    function animation(ele) {
		    			$("#" + opts.scrollimgTigHovId).each(function(){
							$.dequeue(this, "fx");}).animate({
							    top : $(ele).offset().top ,
									left: $(ele).offset().left-12
					    },speed_in, 'easeOutExpo');
		    	
		    	
		    	    $("." + opts.bigImageClass).fadeOut(speed_out);
							
					    var cur_dis = $("." + opts.bigImageClass).get(parseInt($(ele).attr('_target').substr(1) -1));
						
								
							$(cur_dis).fadeIn(speed_in);
		    }
		    
		   function setTimer(smallImgAEle, curr, nextImg) {
					$("#" + opts.scrollimgTigHovId).everyTime("5s", "autoRun", function () {
						var imgIndex = -1;
						for (var i = 0; i < smallImgAEle.length; i++) {
							if ($(smallImgAEle).get(i) == curr) {
								imgIndex = i;
								break;
							}
						}
						if ((imgIndex + 1) <= (smallImgAEle.length - 1)) {
							nextImg = $(smallImgAEle).get(imgIndex + 1);
							if ($(nextImg).offset().left != $(curr).offset().left) {
								nextImg = $(smallImgAEle).get(0);
							}
							animation(nextImg);
							curr = nextImg;
						} else {
							nextImg = $(smallImgAEle).get(0);
							animation(nextImg);
							curr = nextImg;
						}
					});
			}
        
    };
    
    $.fn.imageVerticalShowRight.defaults = {
		    smallImgULId:'nav',
		    scrollimgTigHovId:'bigHover',
		    bigImageClass:'bigimgdis',
		    bigImageDetaildClass:'imgdetaild'
	  };
})(jQuery);