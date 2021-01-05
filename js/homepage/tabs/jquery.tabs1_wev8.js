/* =================================================
// jQuery Tabs Plugins 1.0
// author:chenyg@5173.com
// URL:http://stylechen.com/jquery-tabs.html
// 4th Dec 2010
// =================================================*/

;(function($){
	$.fn.extend({
		Tabs:function(options){
			// 澶勭悊鍙傛暟
			options = $.extend({
				event : 'mouseover',
				timeout : 0,
				auto : 0,
				callback : null,
				getLine:0,
				topHeight:0
			}, options);
			
			var self = $(this),
				tabBox = self.children( 'div.tab_box' ).children( 'div' ),
				menu = self.children( 'ul.tab_menu' ),
				items = menu.find( 'li' ),
				timer,
				$magicLine;
				
			var tabHandle = function( elem ){
					elem.siblings( 'li' )
						.removeClass( 'current' )
						.end()
						.addClass( 'current' );
						
					tabBox.siblings( 'div' )
						.addClass( 'hide' )
						.end()
						.eq( elem.index() )
						.removeClass( 'hide' );
					if(options.getLine){
						$magicLine
	                    .width($magicLine.siblings(".current").width()-16)
	                    .css("left", $magicLine.siblings(".current").position().left+8)
	                    .data("origLeft", $magicLine.position().left+8)
	                    .data("origWidth", $magicLine.width()-16);
					}
				},
					
				delay = function( elem, time ){
					time ? setTimeout(function(){ tabHandle( elem ); }, time) : tabHandle( elem );
				},
				
				start = function(){
					if( !options.auto ) return;
					timer = setInterval( autoRun, options.auto );
				},
				
				autoRun = function(){
					var current = menu.find( 'li.current' ),
						firstItem = items.eq(0),
						len = items.length,
						index = current.index() + 1,
						item = index === len ? firstItem : current.next( 'li' ),
						i = index === len ? 0 : index;
					
					current.removeClass( 'current' );
					item.addClass( 'current' );
					
					tabBox.siblings( 'div' )
						.addClass( 'hide' )
						.end()
						.eq(i)
						.removeClass( 'hide' );
				};
							
			items.bind( options.event, function(){
				delay( $(this), options.timeout );
				if( options.callback ){
					options.callback( $(this).parent().parent());
				}
			});
			
			if( options.auto ){
				start();
				self.hover(function(){
					clearInterval( timer );
					timer = undefined;
				},function(){
					start();
				});
			}
			
			var tabboxheight = $(".tab_box").css("height");
			if(tabboxheight.indexOf("px")>0){
					tabboxheight = tabboxheight.substring(0,tabboxheight.indexOf("px"));
			}
			$(".tab_box").css("height",tabboxheight-options.topHeight);
			
			if(options.getLine){
			    var $el, leftPos, newWidth,
                $mainNav = $(".tab_menu");
                
             
						var idx = 0;
						var liWidth = 0;
						var first = false;
						var div = null;
						var insertItem = null;
						menu = self.find( 'ul.tab_menu' );
						items = menu.find( "li[class!='magic-line'][class!='e8_expand']" );
						items.each(function(index){
							var curItem = jQuery(this);
							var nextItem = items.eq(index+1);
							if(nextItem==null)return;
							if(parseInt(curItem.attr("idx"))>parseInt(nextItem.attr("idx"))){
								exchangePos(curItem,nextItem,true);
							}
						});
						items = menu.find( "li[class!='magic-line'][class!='e8_expand']" );
						var needHide = false;
						var timeout = null;
						var maxWidth = 0;
						var menuWidth = jQuery(menu).width();
						//console.log("2---"+jQuery("ul.tab_menu").width());
						items.each(function(index){
							if(jQuery(this).children("span.e8_rightBorder").length<=0 && options.needLine){
								jQuery(this).append("<span class='e8_rightBorder'>"+options.lineSep+"</span>");
							}else{
								jQuery(this).children("span.e8_rightBorder").show();
							}
							jQuery("li.e8_tree").children("span.e8_rightBorder").hide();
							liWidth+=jQuery(this).outerWidth();
							if(liWidth+25>=menuWidth && !first){
								idx = index-1;
								first = true;
								if(idx<items.length-1){
									var startItem = items.eq(idx);
									startItem.children("span.e8_rightBorder").hide();
									var endItem = items.eq(items.length-1);
									insertItem = jQuery("<li class='e8_expand'></li>");
									startItem.after(insertItem);
									div = jQuery("<div class='e8_content hide'></div>");
									if(!maxWidth || maxWidth<jQuery(this).outerWidth()){
										maxWidth =jQuery(this).outerWidth();
									}
									div.append(this);
									jQuery(this).children("span.e8_rightBorder").hide();
									insertItem.bind("click",function(){
										if(timeout!=null)
											clearInterval(timeout);
										jQuery(div).toggle();
										if(jQuery(div).css("display")=="none"){
											jQuery(this).removeClass("e8_expand_selected");
											needHide = false;
										}else{
											jQuery(this).addClass("e8_expand_selected");
											needHide = true;
											div.css("left",jQuery("li.e8_expand").offset().left-div.width()+jQuery("li.e8_expand").outerWidth()-options.leftWidth-2);
											div.css("top",jQuery("li.e8_expand").offset().top+items.eq(0).height()+1);
										}
									}).bind("mouseout",function(){
										if(timeout!=null)
											clearInterval(timeout);
										if(needHide){
											timeout = window.setTimeout(function(){
												if(needHide){
													jQuery("div.e8_content").hide();
													jQuery("li.e8_expand").removeClass("e8_expand_selected");
												}
											},500);
										}
									});
									div.bind("mouseover",function(){
										needHide = false;
									}).bind("mouseout",function(e){
										if(isMouseLeaveOrEnter(e,this)){
											needHide = false;
											jQuery("div.e8_content").hide();
											jQuery("li.e8_expand").removeClass("e8_expand_selected");
										}
									});
								}		
							}else if(first){
								if(!maxWidth || maxWidth<jQuery(this).outerWidth()){
									maxWidth =jQuery(this).outerWidth();
								}
								div.append(this);
								jQuery(this).children("span.e8_rightBorder").hide();
							}
							if(index==items.length-1 && first){
								insertItem.after(div);
								div.css("left",jQuery("li.e8_expand").offset().left-div.width()+jQuery("li.e8_expand").outerWidth()-options.leftWidth-2);
								div.css("top",jQuery("li.e8_expand").offset().top+items.eq(0).height()+1);
								div.width(maxWidth);
								insertItem.prev("li").children("span.e8_rightBorder").hide();
								//if current li hide, then exchange it
								var currentItem = jQuery("div.e8_content li.current");
								if(currentItem.length>0){
									var lastViewItem = jQuery("li.e8_expand").prev("li");
									exchangePos(lastViewItem,currentItem);
								}
							}else if(index==items.length-1 && !first){
								jQuery(this).children("span.e8_rightBorder").hide();
								jQuery("li.e8_expand").hide();
							}
						});
						if(options.containerHide){
					    	jQuery(options.hideSelector).hide();
					    }
					    resetShadowPosition();
					
                    
                $(".tab_menu li").hover(function() {
                	/*$magicLine = $(this).siblings(".magic-line"); 
                    $el = $(this);
                    leftPos = $el.position().left+8;
                    newWidth = $el.width()-16;
                    $magicLine.stop().animate({
                        left: leftPos,
                        width: newWidth
                    });*/
                }, function() {
                	/*if(!$magicLine.data("origLeft"))$magicLine.data("origLeft",0);
                    $magicLine.stop().animate({
                        left: $magicLine.data("origLeft"),
                        width: $magicLine.siblings(".current").width()-16
                    });  */  
                });
			}
			
			return this;
		}
	});
})(jQuery);