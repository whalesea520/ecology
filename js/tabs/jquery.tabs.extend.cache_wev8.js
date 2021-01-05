/* =================================================
// jQuery Tabs Plugins 1.0
// author:chenyg@5173.com
// URL:http://stylechen.com/jquery-tabs.html
// 4th Dec 2010
// =================================================*/

;(function($){
	$.fn.extend({
		Tabs:function(_options){
			if(!!_options && _options.method==="set"){
				if(!!jQuery(this).data("update_toptitle_num"))
					jQuery(this).data("update_toptitle_num")(_options);
				
				return jQuery(this);
			}
			if(!!_options && _options.method === "update"){
				if(!!jQuery(this).data("update_toptitle")){
					jQuery(this).data("update_toptitle")(this);
				}else{
					jQuery(this).data("iframeLoaded")(jQuery(this).data("currentIframe"),this);
				}
				return jQuery(this);
			}
			if(!!_options && _options.method==="getContentDocument"){
				return jQuery(this).data("_contentDocument");
			}
			if(!!_options && _options.method==="getContentWindow"){
				return jQuery(this).data("_contentWindow");
			}
			var options = $.extend({
				event : 'click',
				timeout : 0,
				auto : 0,
				callback : null,
				getLine:1,
				iframe:null,
				topTitle:"topTitle",
				needTopTitle:true,
				needLine:true,
				image:true,
				cache:false
			}, _options);
			
			var rightBoxMap = {};
			var iframeMap = {};
			var currentIframe = null;
			var currentRightBox = null;
			var lastRightBox = null;
			var lastIframe = null;
			currentIframe = options.iframe;
			currentRightBox = options.iframe+"_box";
			ifrm = jQuery("#"+currentIframe).get(0);
			jQuery(this).data("currentIframe",ifrm);
			$this = this;
			//cal tab_box height
			var mainIframe = jQuery("#mainFrame",parent.document);
			
			var maxRightBoxWidthMap = {};
			var currentA = null;
			var maxRightBoxWidth = 0;
			
			var firstInit = false;
			if(mainIframe.length>0){
				jQuery("div.e8_box").height(mainIframe.height()-2);
			}else{
				jQuery("div.e8_box").height(jQuery(window.parent).height()-2);
			}
			jQuery("div.e8_box div.tab_box").height(jQuery("div.e8_box").height()-jQuery("ul.tab_menu").height());
		    
			var initTopTitle = function(ifrm){
				var _contentWindow = ifrm.contentWindow;
				var _document = _contentWindow.document;
				var setRightBoxWidth = function(width){
					if(!jQuery.browser.msie){
						return width;
					}
					if(!!maxRightBoxWidthMap[currentA]){
						maxRightBoxWidth = maxRightBoxWidthMap[currentA];
					}else{
						if(!maxRightBoxWidth || maxRightBoxWidth<width){
							maxRightBoxWidth = width;
						}
						maxRightBoxWidthMap[currentA] = maxRightBoxWidth;
					}
					return maxRightBoxWidth;
				}
				jQuery(_document).ready(function(){
					jQuery("div.e8_box").show();
					if(!options.needTopTitle)return;
					if(!!setRightBoxWidth(0)){
						jQuery("div#rightBox").width(setRightBoxWidth(0));
					}
					var tt = jQuery("#"+options.topTitle,_document);
					var htmlx = tt.find("td.rightSearchSpan").html();
					if(!htmlx){
						htmlx = "";
					}
					var outerHTML = "<div id='"+currentIframe+"_box'>"+htmlx+"</div>";
					if(options.cache){
						rightBoxMap[currentA] = currentIframe+"_box";
						jQuery("div#rightBox").append(jQuery(outerHTML));
						currentRightBox = currentIframe+"_box";
						console.log("initTitle::"+currentRightBox);
					}else{
						jQuery("div#rightBox").html(outerHTML);
					}
					window.setTimeout(function(){
						jQuery("div#rightBox").find("input[type=button]").each(function(){
							var _click = this.getAttributeNode("onclick").nodeValue;
							jQuery(this).attr("onclick","").bind("click",function(){
								if(_click.toLowerCase().indexOf("javascript:")!=-1 && _click.indexOf("_contentWindow")==-1){
									_click = "javascript:_contentWindow."+_click.substring(_click.indexOf("javascript:")+11);
								}else if(_click.indexOf("_contentWindow")==-1){
									_click = "_contentWindow."+_click;
								}
								eval(_click);
							});
						});
						jQuery("div#rightBox").find("span.cornerMenu").each(function(){
							jQuery(this).unbind("click").bind("click",function(){
								bindCornerMenuEvent(jQuery("div#rightBox"),_contentWindow);
							});
						});
						var searchInputs=jQuery("div#rightBox").find(".searchInput");
						searchInputs.each(function(){
							var searchFn = jQuery(this).attr("_searchFn");
							var searchInput = jQuery(this).clone();
							var corner = jQuery("div#rightBox").find("span#advancedSearch");
							if(corner.length<=0){
								corner = jQuery("div#rightBox").find("span.cornerMenu:first");
							}
							corner.before(searchInput);
							var $this = this;
							jQuery(this).closest("span#searchblockspan").remove();
							searchInput.removeAttr("onchange");
							jQuery(searchInput).searchInput({searchFn:function(val){
									jQuery("input[name='"+jQuery($this).attr("name")+"']",_document).val(val);
									jQuery("input[name='"+jQuery($this).attr("name")+"']",_document).trigger("change");
									eval("_contentWindow."+searchFn+"('"+val+"')");
								}
							});
						});
						
						//advancedSearch click
						jQuery("div#rightBox").find("span#advancedSearch").each(function(){
								jQuery(this).unbind("click").bind("click",function(){
									var as = jQuery("span#advancedSearch",_document);
									if(as.hasClass("click")){
										jQuery(this).removeClass("click");
									}else{
										jQuery(this).addClass("click");
									}
									as.click();
								});
							});
						
						var width = jQuery("div#rightBox").width();
						jQuery("ul.tab_menu").width(jQuery("div.e8_box").width()-setRightBoxWidth(width)-2);
						searchInputs.each(function(){
							initsearchblock();
						});
					},100);
				});
			}
			
			var init = function(obj){
				var self = $(obj),
					tabBox = self.children( 'div.tab_box' ).children( 'div' ),
					menu = self.children( 'ul.tab_menu' ),
					items = menu.find( "li[class!='magic-line'][class!='e8_expand']" ),
					timer,
					$magicLine;
				
				var preDealLink = function(){
					items.each(function(index){
						var $this = jQuery(this).children("a:first");
						var id = $this.attr("id");
						if(!id){
							$this.attr("id", "li_a_"+index);
						}
						$this.bind("click",function(){
							currentA = jQuery(this).attr("id");
							maxRightBoxWidth = 0;
							if(!!options.cache){
								if(!!iframeMap[currentA]){
									console.log(lastRightBox+"::"+currentRightBox);
									if(rightBoxMap[currentA]!=lastRightBox){
										lastRightBox = currentRightBox;
										lastIframe = currentIframe;
										currentRightBox = rightBoxMap[currentA];
										currentIframe = iframeMap[currentA];
										switchCache();
									}
									return false;
								}else{
									lastRightBox = currentRightBox;
									lastIframe = currentIframe;
									currentIframe = currentA+"_iframe";
									var iframe = jQuery("<iframe src=\"\" id="+currentIframe+" name="+currentIframe+" class=\"flowFrame\" onload=\"update();\" frameborder=\"0\" height=\"100%\" width=\"100%;\"></iframe>");
									jQuery("div.tab_box div:first").append(iframe);
									jQuery(this).attr("target",currentIframe);
									jQuery("#"+lastRightBox).hide();
									jQuery("#"+lastIframe).hide();
								}
							}
						});
					});
					currentA = menu.children("li.current:first").children("a:first").attr("id");
					rightBoxMap[currentA] = currentRightBox;
					iframeMap[currentA] = currentIframe;
		    	}
		    	if(!jQuery(this).data("update_toptitle"))
					preDealLink();
				var tabHandle = function( elem ){
						elem = jQuery(elem).parent("li");
						if(elem.hasClass("e8_tree")){
							return;
						}
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
							$magicLine = $(".magic-line");
							var current = $magicLine.siblings(".current") || $magicLine.parent(".current");					
							$magicLine
		                    .width(current.width())
		                    .css("left", current.offset().left)
		                    .data("origLeft", $magicLine.offset().left)
		                    .data("origWidth", $magicLine.width());
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
					},
					
					update = function(){
						jQuery("ul.tab_menu").width(jQuery("div.e8_box").width()-jQuery("div#rightBox").width()-2);
						var insertItem = jQuery("li.e8_expand");
						var beforeItem = insertItem.prev("li");
						beforeItem.after(jQuery("div.e8_content").children("li"));
						jQuery("div.e8_content").remove();
						insertItem.remove();
						format(menu,items);
						insertImages();
					},
					
					updateAjax = function(obj){
						var ifrm = jQuery("#"+currentIframe).get(0);
						iframeLoaded(ifrm,obj);
					}
					
					updateNum = function(_options){
						for(var key in _options){
							if(key=="method")continue;
							var span = jQuery("ul.tab_menu li a span#"+key);
							span.html("("+_options[key]+")");
						}
						update();
					},
					
					isMouseLeaveOrEnter = function(e, handler) {
					    if (e.type != 'mouseout' && e.type != 'mouseover') return false;
					    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;
					    while (reltg && reltg != handler)
					        reltg = reltg.parentNode;
					    return (reltg != handler);
					},
					
					
					format = function(menu,items){
						var menuWidth = jQuery(menu).width();
						var idx = 0;
						var liWidth = 0;
						var first = false;
						var div = null;
						var insertItem = null;
						menu = self.children( 'ul.tab_menu' );
						items = menu.find( "li[class!='magic-line'][class!='e8_expand']" );
						var needHide = false;
						var timeout = null;
						var maxWidth = 0;
						items.each(function(index){
							if(jQuery(this).children("span.e8_rightBorder").length<=0 && options.needLine){
								jQuery(this).append("<span class='e8_rightBorder'>|</span>");
							}else{
								jQuery(this).children("span.e8_rightBorder").show();
							}
							jQuery("li.e8_tree").children("span.e8_rightBorder").hide();
							liWidth+=jQuery(this).outerWidth();
							if(liWidth+35>=menuWidth && !first){
								idx = index-1;
								first = true;
								if(idx<items.length-1){
									var startItem = items.eq(idx);
									startItem.children("span.e8_rightBorder").hide();
									var endItem = items.eq(items.length-1);
									insertItem = jQuery("<li class='e8_expand'></li>");
									startItem.after(insertItem);
									div = jQuery("<div class='e8_content hide'></div>");
									if(!!maxWidth || maxWidth<jQuery(this).outerWidth()){
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
											div.css("left",jQuery("li.e8_expand").offset().left-div.width()+jQuery("li.e8_expand").outerWidth()-2);
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
								if(!!maxWidth || maxWidth<jQuery(this).outerWidth()){
									maxWidth =jQuery(this).outerWidth();
								}
								div.append(this);
								jQuery(this).children("span.e8_rightBorder").hide();
							}
							if(index==items.length-1 && first){
								insertItem.after(div);
								div.css("left",jQuery("li.e8_expand").offset().left-div.width()+jQuery("li.e8_expand").outerWidth()-2);
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
					},
				exchangePos = function(elem1, elem2) {
	                if(elem1.length === 0 && elem2.length === 0){
	                    return;
	                }
	                var next = elem2.next(),
	                    prev = elem2.prev();
	                elem1.before(elem2);
	                if(next.length === 0){
	                    prev.after(elem1);
	                }else{
	                    next.before(elem1);
	                }
	                //elem2.css("background-image","url(/images/ecology8/top_icons/"+elem1.attr("imageIdx")+"-1_wev8.png)");
	                //elem1.css("background-image","none");
	                elem1.removeClass("current");
	                jQuery(this).css("background-position","0 50%");
	            },
	            insertImages = function(){
	            	var menu = self.children( 'ul.tab_menu' );
					var items = menu.find( "li[class!='magic-line'][class!='e8_expand'][class!='e8_tree']" );
					items.each(function(index){
						jQuery(this).attr("imageIdx",index+1);
						if(options.image){
							jQuery(this).css("background-image","url(/images/ecology8/top_icons/"+(index+1)+"-1_wev8.png)");
							jQuery(this).css("background-position","0 50%");
							jQuery(this).css("background-repeat","no-repeat");
							if(jQuery(this).parent("div.e8_content").length>0){
								//jQuery(this).css("background-image","none");
								jQuery(this).css("background-position","10px 50%");
							}
						}else{
							jQuery(this).css("padding-left","10px");
						}
					});
	            };
				update();
				items.children("a").bind( options.event, function(){
					delay( $(this), options.timeout );
					if( options.callback ){
						options.callback( self );
					}
				});
				
				items.bind("click",function(){
					if(jQuery(this).parent("div.e8_content").length>0){
						var lastViewItem = jQuery("li.e8_expand").prev("li");
						exchangePos(lastViewItem,jQuery(this));
						jQuery("div.e8_content").hide();
						jQuery("li.e8_expand").removeClass("e8_expand_selected");
						delay( $(this).children("a:first"), options.timeout );
					}
				});
				
				$(window).resize(function(){
					update();
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
				
				if(options.getLine){
				    var $el, leftPos, newWidth,topPos,
	                $mainNav = $(".tab_menu");
	                $magicLine = $(".magic-line");
	                if($magicLine.length<=0){
	                	$mainNav.append("<li class='magic-line'></li>");
	                	$magicLine = $(".magic-line");
	                	var marginTop = $magicLine.css("margin-top").replace(/\D/g,"");
						if(jQuery.browser.msie){
							marginTop = marginTop-2;
							$magicLine.css("margin-top",marginTop+"px");
						}
	                }
	                var current = $(".current");
	                $magicLine = $(".magic-line");
	                if(current.length>0){
		                $magicLine
		                    .width($(".current").width())
		                    .css("left", $(".current").position().left)
		                    .data("origLeft", $magicLine.position().left)
		                    .data("origWidth", $magicLine.width());
	                }else{
	                	$magicLine.hide();
	                }
	                    
	                $(".tab_menu li a").hover(function() {
	                	$el = $(this).closest("li");
	                	$magicLine = $el.siblings(".magic-line")||$el.parent(".magic-line"); 
	                    leftPos = $el.position().left;
	                    newWidth = $el.width();
	                    if($el.parent("div.e8_content").length>0){
	                    	$el.addClass("e8_li_hover");
	                    }else if($el.hasClass("e8_expand")||$el.hasClass("e8_tree")){
	                    	
	                    }else{
		                    $magicLine.stop().animate({
		                        left: leftPos,
		                        width: newWidth
		                    });
		                }
	                }, function() {
	                	if(!$magicLine.data("origLeft"))$magicLine.data("origLeft",0);
	                	var current = $magicLine.siblings(".current") || $magicLine.parent(".current");
	                     if($el.parent("div.e8_content").length>0){
	                    	$el.removeClass("e8_li_hover");
	                    }else if($el.hasClass("e8_expand")||$el.hasClass("e8_tree")){
	                    	
	                    }else{
		                    $magicLine.stop().animate({
		                        left: $magicLine.data("origLeft"),
		                        width: current.width()
		                    });
		                 }    
	                });
				};
				
				jQuery(obj).data("update_toptitle",updateAjax);
				jQuery(obj).data("update_toptitle_num",updateNum);
				return jQuery(obj);
			}
			
			var switchCache = function(){
				jQuery("#"+lastRightBox).hide();
				jQuery("#"+lastIframe).hide();
				jQuery("#"+currentRightBox).show();
				jQuery("#"+currentIframe).show();
			}
			
			var iframeLoaded = function(ifrm,$this){
				iframeMap[currentA] = currentIframe;
		    	initTopTitle(ifrm);
    			jQuery($this).data("_contentDocument",ifrm.contentWindow.document);
    			jQuery($this).data("_contentWindow",ifrm.contentWindow);
				init($this);
		    }
		    
		    jQuery(this).data("iframeLoaded",iframeLoaded);
		    /*if(true || jQuery.browser.msie){
		    	if(!!ifrm){
				    if(!jQuery(this).data("update_toptitle")){
						var iframeHtml = jQuery("<div></div>").append(jQuery(ifrm).clone()).html();
						iframeHtml = iframeHtml.replace(/<IFRAME/gi, "<iframe onload=\"update();\" ");
						var targetIframe = jQuery(iframeHtml);
						jQuery(ifrm).after(targetIframe);
						jQuery(ifrm).remove();
						firstInit = true;
						iframeLoaded(targetIframe[0], this);
					}else{
						firstInit = false;
					}
				}else{
					jQuery("div.e8_box").show();
					init($this);
				}			    
			}else{
				if(!!ifrm && ifrm.addEventListener){
					ifrm.addEventListener("load", function(){
						iframeLoaded(ifrm,$this);
					}, false);
				}else if(!!ifrm){
					ifrm.onload = function() {  
						iframeLoaded(ifrm,$this);
					}
				}else{
					jQuery("div.e8_box").show();
					init($this);
				}
			}*/
		}
	});
})(jQuery);


function getIframeDocument2(){
    	return jQuery(".e8_box").Tabs({
		    		method:"getContentDocument"
		    	});
}

function getIframeContentWindow(){
	return jQuery(".e8_box").Tabs({
  		method:"getContentWindow"
  	});
}

function update(){
	if(true || jQuery.browser.msie){
		jQuery('.e8_box').Tabs({
	        method:"update"
	    });
	}
}