/* =================================================
// jQuery Tabs Plugins 1.0
// author:chenyg@5173.com
// URL:http://stylechen.com/jquery-tabs.html
// 4th Dec 2010
// =================================================*/

;(function($){
	$.fn.extend({
		PortalTabs:function(options){
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
				menu = self.children( 'ul.p_tab_menu' ),
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
                $mainNav = $(".p_tab_menu");
                $mainNav.append("<li class='magic-line'></li>");
                $magicLine = $(".magic-line");
                $magicLine
                    .width($(".current").width()-16)
                    .css("left", $(".current").position().left+8)
                    .data("origLeft", $magicLine.position().left+8)
                    .data("origWidth", $magicLine.width()-16);
                    
                $(".p_tab_menu li").hover(function() {
                	$magicLine = $(this).siblings(".magic-line"); 
                    $el = $(this);
                    leftPos = $el.position().left+8;
                    newWidth = $el.width()-16;
                }, function(){});
			}
			return this;
		}
	});
})(jQuery);