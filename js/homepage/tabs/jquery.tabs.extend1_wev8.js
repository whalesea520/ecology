/* =================================================
// jQuery Tabs Plugins 1.0
// author:chenyg@5173.com
// URL:http://stylechen.com/jquery-tabs.html
// 4th Dec 2010
// =================================================*/
var _searchBtnClick = false;
(function($){
	$.fn.extend({
		Tabs:function(_options){
			if(!!_options && _options.method==="set"){
				var __this = this;
				if(!!jQuery(this).data("update_toptitle_num")){
					jQuery(this).data("update_toptitle_num")(_options);
				}else{
					window.setTimeout(function(){
						jQuery(__this).Tabs(_options);
					},500);
				}
				
				return jQuery(this);
			}
			if(!!_options && _options.method=="setObjName"){
				var __this = this;
				if(!!jQuery(this).data("setObjName")){
					!!jQuery(this).data("setObjName")(_options);
				}else{
					window.setTimeout(function(){
						jQuery(__this).Tabs(_options);
					},500);
				}
				return jQuery(this);
			}
			if(!!_options && _options.method==="e8_tree"){
				var __this = this;
				if(!!jQuery(this).data("update_e8_tree_text")){
					jQuery(this).data("update_e8_tree_text")(_options);
				}else{
					window.setTimeout(function(){
						jQuery(__this).Tabs(_options);
					},500);
				}
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
				lineSep:"|",
				needChange: true,
				image:true,
				cache:false,
				needInitBoxHeight:true,
				needFix:false,
				staticOnLoad:false,
				staticHeight:false,
				height:800,
				container:".e8_box",
				tabMenuFixWidth:0,
				leftWidth:0,
				contentID:null,
				exceptHeight:false,
				tabMenuHeight:0,
				mouldID:"",
				navLogo:null,
				navLogoEvent:null,
				hideSelector:null,
				objName:"",
				containerHide:false,
				ifrmCallback:null,
				needNotCalHeight:false,
			}, _options);
			
			options.image = false;
			
			var rightBoxMap = {};
			var iframeMap = {};
			var currentIframe = null;
			var currentRightBox = null;
			var lastRightBox = null;
			var lastIframe = null;
			currentIframe = options.iframe;
			currentRightBox = options.iframe+"_box";
			ifrm = jQuery("#"+currentIframe).get(0);
			var _$contentWindow = null;
			jQuery(this).data("currentIframe",ifrm);
			if(options.navLogo){
				jQuery(options.container).find("#e8_tablogo").css("background-image","none");
				var navLogo = options.navLogo;
				if(navLogo.indexOf("<img")==-1){
					navLogo = "<img style='vertical-align:middle;' width='43px' src='"+options.navLogo+"'></img>";
				}
				jQuery(options.container).find("#e8_tablogo").html(navLogo);
			}else if(options.mouldID){
				jQuery(options.container).find("#e8_tablogo").css("background-image","url(/js/tabs/images/nav/"+options.mouldID+")");
			}
			if(options.objName){
					jQuery(options.container).find("#objName").html(options.objName);
			}
			if(jQuery("li.e8_tree").length==0){
				jQuery(options.container).find("#e8_tablogo").css("margin-left","6px");
			}
			if(options.iframe){
				jQuery(options.container).attr("_e8tabContainer",true);
			}
			_this = this;
			//cal tab_box height
			var mainIframe = jQuery("#mainFrame",parent.document);
			var dialogframe = jQuery("div[id^='_Container_']",top.document);
			
			var maxRightBoxWidthMap = {};
			var currentA = null;
			var maxRightBoxWidth = 0;
			
			var setIframeHeight = function(){
				var tabMenuHeight = jQuery("ul.tab_menu",parent.document).height();
				if(options.needNotCalHeight)return;
				if(!tabMenuHeight || options.exceptHeight)tabMenuHeight=0;
				if(parent==window){
					tabMenuHeight=0;
				}
				if(dialogframe.length>0){
					//jQuery("div"+options.container).height(dialogframe.eq(0).height()-tabMenuHeight-2);
				}else if(mainIframe.length>0){
					//jQuery("div"+options.container).height(mainIframe.height()-tabMenuHeight-2);
				}else{
					//jQuery("div"+options.container).height(jQuery(window.parent).height()-tabMenuHeight-2);
				}
				var siblings = jQuery("div"+options.container).siblings(":visible");
				var exceptHeight = 0;
				siblings.each(function(){
					if(jQuery(this).css("position")=="absolute"||jQuery(this).css("position")=="relative"){
					}else{
						exceptHeight += jQuery(this).height();
					}
				});
				var pageHeight = jQuery(window).height();
				if(!options.iframe && !exceptHeight && jQuery("div"+options.container).closest("div.zDialog_div_content").length>0){
					if(jQuery("div.zDialog_div_bottom").length>0){
						exceptHeight += jQuery("div.zDialog_div_bottom").height()+11;
					}
				}
				//console.log(pageHeight+"::"+exceptHeight);
				if(options.exceptHeight)exceptHeight = 0;
				if(jQuery.browser.msie){
					exceptHeight = 7;
				}
				//console.log(pageHeight+"::"+exceptHeight);
				jQuery("div"+options.container).height(pageHeight-exceptHeight);
				if(jQuery(options.container).find("div.e8_ultab").length>0){
					jQuery("div"+options.container+" div.tab_box").height(jQuery("div"+options.container).height()-jQuery(options.container).find("div.e8_ultab").height()-(!!options.contentID?jQuery(options.contentID).height():0));
				}else{
					jQuery("div"+options.container+" div.tab_box").height(jQuery("div"+options.container).height()-jQuery(options.container).find("ul.tab_menu").height()-(!!options.contentID?jQuery(options.contentID).height():0));
				}
				if(!!options.iframe){
					jQuery("div"+options.container+" iframe#"+options.iframe).height(jQuery("div"+options.container+" div.tab_box").height());
				}
			}
			
			var firstInit = false;
			jQuery("div"+options.container).show();
			if(options.tabMenuHeight){
				jQuery("div"+options.container+" ul.tab_menu").height(options.tabMenuHeight);
				jQuery("div"+options.container+" div.e8_rightBox").height(options.tabMenuHeight);
				jQuery("div"+options.container+" ul.tab_menu li").height(options.tabMenuHeight).css("line-height",options.tabMenuHeight+"px");
				jQuery("div"+options.container+" div.e8_rightBox").css("line-height",options.tabMenuHeight+"px");
			}
			
			
			if(options.staticHeight){
				if(!!options.height && options.height.match(/\D/)){
					jQuery("div"+options.container).css("height",options.height);
				}else{
					jQuery("div"+options.container).height(options.height);
				}
				jQuery("div"+options.container+" div.tab_box").height(jQuery("div"+options.container).height()-jQuery("ul.tab_menu").height()-(!!options.contentID?jQuery(options.contentID).height():0));
			}else if(options.needInitBoxHeight){
				setIframeHeight();
				jQuery(window).resize(function(){
			    	if(options.containerHide){
						jQuery(options.hideSelector).show();
					}
			    	setIframeHeight();
			    	if(options.containerHide){
				    	jQuery(options.hideSelector).hide();
				    }
			    });
		    }
		    
		    var setShadowBorderPosition = function(){
		    	jQuery("div"+options.container).find("div#rightBox").find("span#advancedSearch").each(function(){
					var shadowDiv = jQuery("div.e8_shadowDiv");
					if(shadowDiv.length==0){
						shadowDiv = jQuery("<div class='e8_shadowDiv'></div>");
						jQuery(document.body).append(shadowDiv);
					}
					var _top = 0;
					try{
						var navtab = jQuery(this).closest(".e8_ultab");
						_top = navtab.position().top+navtab.height();
					}catch(e){
						_top = jQuery(this).position().top+jQuery(this).height()-1;
					}
					
					var _width=jQuery(this).outerWidth()
					/*if(jQuery.browser.msie){
						_top = jQuery(this).height()-1;
						_width = jQuery(this).width()+parseInt(jQuery(this).css("padding-left").replace(/\D/g,""))+parseInt(jQuery(this).css("padding-right").replace(/\D/g,""))+2;
					}*/
					var _left = Math.ceil(jQuery(this).offset().left);
					shadowDiv.width(_width-1);
					shadowDiv.css("left",_left).css("top",_top);
				});
		    }
		    
			var initTopTitle = function(ifrm,_this){
				jQuery("div.e8_shadowDiv").hide();
				var _contentWindow = window;
				var _document = document;
				if(!!ifrm){
					_contentWindow = ifrm.contentWindow;
					_$contentWindow = ifrm.contentWindow;
					_document = _contentWindow.document;
				}
				var _boxEmpty = false;
				var setRightBoxWidth = function(width){
					if(!jQuery.browser.msie){
						return width;
					}
					if(!!maxRightBoxWidthMap[currentA]){
						if(width>maxRightBoxWidthMap[currentA]){
							maxRightBoxWidthMap[currentA] = width;
						}
						maxRightBoxWidth = maxRightBoxWidthMap[currentA];
					}else{
						if(!maxRightBoxWidth || maxRightBoxWidth<width){
							maxRightBoxWidth = width;
						}
						maxRightBoxWidthMap[currentA] = maxRightBoxWidth;
					}
					return maxRightBoxWidth;
				}
				var getTopTitleWidth = function(){
					//jQuery("div#rightBox").width();
					var width = 31;
					var children = jQuery("div"+options.container).find("div#rightBox").children("#"+currentRightBox+":first");
					if(children.css("display")=="none"||children.children().length==0){
						_boxEmpty = true;
						return 0;
					}else{
						children.children().each(function(index){
							if(jQuery(this).is("input")){
								if(!!jQuery(this).attr("type")){
									width += jQuery(this).outerWidth();
								//	console.log(index+"::"+jQuery(this).outerWidth());
								}
							}else if(jQuery(this).is("span")){
								width += jQuery(this).outerWidth();
								if(jQuery.browser.msie){
									var paddingLeft = jQuery(this).css("padding-left");
									var paddingRight = jQuery(this).css("padding-right");
									if(!!paddingLeft){
										width += parseInt(paddingLeft.replace(/\D/g,""));
									}
									if(!!paddingRight){
										width += parseInt(paddingRight.replace(/\D/g,""));
									}
								}
								//console.log(index+"::"+jQuery(this).outerWidth());
							}
						});
					}
					if(width==31)return 0;
					return width;
				}
				if(!!_searchBtnClick && !jQuery.browser.msie){
					var searchInputs=jQuery(_this).find("div#rightBox").find(".searchInput");
					searchInputs.each(function(){
						jQuery(this).bind("keyup",function(){
							jQuery("input[name='"+jQuery(this).attr("name")+"']",_document).val(jQuery(this).val());
							jQuery("input[name='"+jQuery(this).attr("name")+"']",_document).trigger("change");
						});
					});
					return;
				}
				jQuery(_document).ready(function(){
					if(options.ifrmCallback){
						try{
							options.ifrmCallback(ifrm,_this);
						}catch(e){
							if(window.console)console.log(e+"---jquery.tabs.extend.js-->"+options.ifrmCallback);
						}
					}
					jQuery(options.container).find("div.e8_boxhead").css({
						"visibility":"visible",
						"-moz-opacity":"1",
						"-khtml-opacity":"1",
						"opacity":"1"
					});
					
				
					var rightBox = jQuery(_this).find(".e8_rightBox");
					rightBox.css("opacity","0");
					rightBox.css("visibility","hidden");
					rightBox.css("-moz-opacity","0");
					rightBox.css("-khtml-opacity","0");
					if(!_searchBtnClick){
						jQuery("div"+options.container).show();
						if(!options.needTopTitle){
							setShadowBorderPosition();
							init(_this,_contentWindow);
							return;
						}
						if(!!setRightBoxWidth(0)){
							jQuery(_this).find("div#rightBox").width(setRightBoxWidth(0));
						}
						var tt = jQuery("#"+options.topTitle,_document);
						var htmlx = tt.find("td.rightSearchSpan").html();
						if(!htmlx){
							htmlx = "";
						}
						htmlx = htmlx.replace(/&nbsp;/g,"");
						var outerHTML = "<div id='"+currentIframe+"_box' class='_box'>"+htmlx+"</div>";
						if(options.cache){
							rightBoxMap[currentA] = currentIframe+"_box";
							jQuery(_this).find("div#rightBox").append(jQuery(outerHTML));
							currentRightBox = currentIframe+"_box";
						}else{
							jQuery(_this).find("div#rightBox").html(outerHTML);
						}
						}
						if(options.tabMenuHeight){
							jQuery("div"+options.container).find(" div.e8_rightBox div._box").css("line-height",options.tabMenuHeight+"px");
							jQuery("div"+options.container).find(" div.e8_rightBox div._box").find("span.cornerMenu").height(options.tabMenuHeight);
						}
						window.setTimeout(function(){
							jQuery(_this).find("div#rightBox").find("input[type=button]").each(function(index,obj){
								if(index==0){
									jQuery(this).removeClass("e8_btn_top").addClass("e8_btn_top_first");
									jQuery(this).hover(function(){
										jQuery(this).addClass("e8_btn_top_first_hover");
									},function(){
										jQuery(this).removeClass("e8_btn_top_first_hover");
									});
								}
								var _click = this.getAttributeNode("onclick").nodeValue;
								//jQuery(this).wrap("<span class='e8_btn_top_span'></span>");
								jQuery(this).attr("onclick","").bind("click",function(e){
									if(_click.toLowerCase().indexOf("javascript:")!=-1 && _click.indexOf("_contentWindow")==-1){
										_click = "javascript:_contentWindow."+_click.substring(_click.indexOf("javascript:")+11);
									}else if(_click.indexOf("_contentWindow")==-1){
										_click = "_contentWindow."+_click;
									}
									try{
										var as = jQuery("span#advancedSearch",_document);
										try{
											_contentWindow.advancedSearchClick(e,as,true);
										}catch(ex){
											if(window.console)console.log("jquery.tabs.extends.js-->"+_click+"--->"+e);
										}
										eval(_click);
									}catch(e){
										if(window.console)console.log("jquery.tabs.extends.js-->"+_click+"--->"+e);
									}
								});
							});
							jQuery(_this).find("div#rightBox").find("span.cornerMenu").each(function(){
								if(!jQuery(this).hasClass("middle")){
									jQuery(this).addClass("middle");
								}
								if(jQuery(this).attr("onclick")){
									var _click = this.getAttributeNode("onclick").nodeValue;
									jQuery(this).attr("onclick","").bind("click",function(e){
										if(_click.toLowerCase().indexOf("javascript:")!=-1 && _click.indexOf("_contentWindow")==-1){
											_click = "javascript:_contentWindow."+_click.substring(_click.indexOf("javascript:")+11);
										}else if(_click.indexOf("_contentWindow")==-1){
											_click = "_contentWindow."+_click;
										}
										try{
											var as = jQuery("span#advancedSearch",_document);
											_contentWindow.advancedSearchClick(e,as,true);
											eval(_click);
										}catch(e){
											if(window.console)console.log("jquery.tabs.extends.js-->"+_click+"--->"+e);
										}
									});
								}else{
									jQuery(this).unbind("click").bind("click",function(e){
										var e8_head = jQuery(_this).find("div.e8_boxhead");
										if(e8_head.length==0){
											e8_head = jQuery(_this).find("div#rightBox");
										}
										bindCornerMenuEvent(e8_head,_contentWindow,e);
										try{
											var as = jQuery("span#advancedSearch",_document);
											_contentWindow.advancedSearchClick(e,as,true);
											eval(_click);
										}catch(e){
											if(window.console)console.log("jquery.tabs.extends.js-->"+_click+"--->"+e);
										}
									});
								}
							});
							var searchInputs=jQuery(_this).find("div#rightBox").find(".searchInput");
							searchInputs.each(function(){
								var searchFn = jQuery(this).attr("_searchFn");
								var searchInput = jQuery(this).clone();
								var corner = jQuery(_this).find("div#rightBox").find("span#advancedSearch");
								if(corner.length<=0){
									corner = jQuery(_this).find("div#rightBox").find("span.cornerMenu:first");
								}
								corner.before(searchInput);
								var __this = this;
								jQuery(this).closest("span#searchblockspan").remove();
								jQuery(this).remove();
								searchInput.removeAttr("onchange");
								jQuery(searchInput).searchInput({searchFn:function(val){
										jQuery("input[name='"+jQuery(__this).attr("name")+"']",_document).val(val);
										jQuery("input[name='"+jQuery(__this).attr("name")+"']",_document).trigger("change");
										try{
											eval("_contentWindow."+searchFn+"('"+val+"')");
											var as = jQuery("span#advancedSearch",_document);
											_contentWindow.advancedSearchClick(null,as,true);
											_searchBtnClick = true;
										}catch(e){
											if(window.console)console.log(e+"-->jquery.tabs.extends.js-->"+"_contentWindow."+searchFn+"('"+val+"')");
										}
									}
								});
								//searchInput.closest("#searchblockspan").css("filter","alpha(opacity=0)");
								if(!!_searchBtnClick){
									jQuery("span.searchImg img").mouseover();
								}
							});
							
							//advancedSearch click
							jQuery(_this).find("div#rightBox").find("span#advancedSearch").each(function(){
								jQuery(this).unbind("click").bind("click",function(e){
									var as = jQuery("span#advancedSearch",_document);
									_contentWindow.advancedSearchClick(e,as);
									return false;
									//as.click();
								});
							});
							
							jQuery("body").unbind("click").bind("click",function(e){
								//_contentWindow.closeAdvancedSearch(e,document);
							});
							if(!_searchBtnClick){
								//jQuery("div#rightBox").show();
							}	
							window.setTimeout(function(){
								var width = setRightBoxWidth(getTopTitleWidth());
								if(_boxEmpty){
									_boxEmpty = false;
									width = 10;
								}
								jQuery(_this).find("div#rightBox").width(width);
								if(!!options.tabMenuFixWidth){
									jQuery(_this).children("ul.tab_menu").width(options.tabMenuFixWidth-jQuery(options.container).find("div.e8_tablogo").width());
									jQuery(_this).width(options.tabMenuFixWidth);
								}else{
									jQuery(_this).children("ul.tab_menu").width(jQuery("div"+options.container).width()-jQuery(options.container).find("div.e8_tablogo").width()-width-10);
								}
								//console.log("1---"+jQuery("ul.tab_menu").width());
								searchInputs.each(function(){
									initsearchblock();
								});
								setShadowBorderPosition();
								init(_this,_contentWindow);
							},50);
						},100);
						
					//}
				});
			}
			
			var insertLine = function(){
				var self = jQuery(options.container);
				var menu = self.find( 'ul.tab_menu' );
				var items = menu.find( "li[class!='magic-line'][class!='e8_expand'][class!='e8_tree']" );
				if(menu.children("li.e8_tree").length==0){
					items.eq(0).addClass("firstLi");
				}
				items.each(function(index){
					if(index!=items.length-1){
				    	if(jQuery(this).children("span.e8_rightBorder").length<=0 && options.needLine){
							jQuery(this).append("<span class='e8_rightBorder'>"+options.lineSep+"</span>");
						}else{
							jQuery(this).children("span.e8_rightBorder").show();
						}
					}
				});
				menu.children("li.e8_tree").children("span.e8_rightBorder").hide();
				if(menu.children("li.e8_tree").length>0){
					if(!!options.navLogoEvent){
						self.find("div.e8_tablogo").css("cursor","pointer").unbind("click").bind("click",function(){
							options.navLogoEvent.call();
						});
					}else{
						self.find("div.e8_tablogo").attr("title","点击可收缩/展开左侧菜单");
						self.find("div.e8_tablogo").css("cursor","pointer").unbind("click").bind("click",function(e){
							refreshTabNew();
							toggleleft();
							toggleleft(parent.parent.document);
							var e8_head = jQuery(options.container).find("div.e8_boxhead");
							if(e8_head.length==0){
								e8_head = jQuery(options.container).find("div#rightBox");
							}
							bindCornerMenuEvent(e8_head,_$contentWindow,e,{position:true});
						});
					   var treeSwitch = jQuery("#e8TreeSwitch");
					   if(treeSwitch.length==0){
					   	 treeSwitch = jQuery("<div id=\"e8TreeSwitch\" class=\"e8_expandOrCollapseDiv e8_expandOrCollapseDiv_tree\"></div>");
					   	 jQuery("body").append(treeSwitch);
					   	 treeSwitch.css({
					   	 	left:0,
					   	 	//top:jQuery(window).height()/2
					   	 	top:11
					   	 });
					   }
					   treeSwitch.bind("click",function(){
					   	 self.find("div.e8_tablogo").trigger("click");
					   });
					}
				}else{
					if(!!options.navLogoEvent){
						self.find("div.e8_tablogo").css("cursor","pointer").unbind("click").bind("click",function(){
							try{
								options.navLogoEvent();
							}catch(e){
								options.navLogoEvent.call();
							}
						});
					}
				}
		    }
			
			var insertImages = function(){
					var self = jQuery(options.container);
	            	var menu = self.find( 'ul.tab_menu' );
					var items = menu.find( "li[class!='magic-line'][class!='e8_expand'][class!='e8_tree']" );
					items.each(function(index){
						var _index = index%8;
						jQuery(this).attr("imageIdx",_index+1);
						if(options.image){
							jQuery(this).css("background-image","url(/images/ecology8/top_icons/"+(_index+1)+"-1_wev8.png)");
							jQuery(this).css("background-position","0 50%");
							jQuery(this).css("background-repeat","no-repeat");
							if(jQuery(this).parent("div.e8_content").length>0){
								//jQuery(this).css("background-image","none");
								jQuery(this).css("background-position","10px 50%");
							}
						}else{
							jQuery(this).css("padding-left","5px");
						}
					});
	            }
			
			var init = function(obj,_contentWindow){
				var self = $(obj),
					tabBox = self.find( 'div.tab_box' ).children( 'div' ),
					menu = self.find( 'ul.tab_menu' ),
					items = menu.find( "li[class!='magic-line'][class!='e8_expand']" ),
					timer,
					$magicLine;
				
				/*if(!items.eq(0).hasClass("e8_tree")){
					items.eq(0).addClass("firstLi");
				}*/
				
				jQuery(options.container).find("div.e8_boxhead").css({
					"visibility":"visible",
					"-moz-opacity":"1",
					"-khtml-opacity":"1",
					"opacity":"1"
				});
				
				var preDealLink = function(){
					items.each(function(index){
						var _this = jQuery(this).children("a:first");
						var id = _this.attr("id");
						if(!id){
							_this.attr("id", "li_a_"+index);
						}
						if(jQuery(this).hasClass("defaultTab")){
							_this.unbind("click").bind("click",function(e){
								var evt = e||window.event;
								event.stopPropagation();
        						event.preventDefault();
								return false;
							});
						}
						if(jQuery(this).hasClass("e8_tree")){
							_this.removeAttr("onclick");
							_this.unbind("click").bind("click",function(e){
								refreshTabNew();
								toggleleft();
								toggleleft(parent.parent.document);
								var e8_head = jQuery(options.container).find("div.e8_boxhead");
								if(e8_head.length==0){
									e8_head = jQuery(options.container).find("div#rightBox");
								}
								bindCornerMenuEvent(e8_head,_contentWindow,e,{position:true});
							});
						}else{
							_this.bind("click",function(){
								currentA = jQuery(this).attr("id");
								maxRightBoxWidth = 0;
								if(!!options.cache){
									if(!!iframeMap[currentA]){
										//if(rightBoxMap[currentA]!=lastRightBox){
											lastRightBox = currentRightBox;
											lastIframe = currentIframe;
											currentRightBox = rightBoxMap[currentA];
											currentIframe = iframeMap[currentA];
											switchCache();
										//}
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
										iframeMap[currentA] = currentIframe;
									}
								}
							});
						}
					});
					currentA = menu.children("li.current:first").children("a:first").attr("id");
					if(!!options.cache){
						rightBoxMap[currentA] = currentRightBox;
						iframeMap[currentA] = currentIframe;
					}
		    	}
		    	if(!jQuery(this).data("update_toptitle"))
					preDealLink();
				var tabHandle = function( elem ){
						elem = jQuery(elem).parent("li");
						if(elem.hasClass("e8_tree")||elem.hasClass("defaultTab")){
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
							$magicLine = $(options.container).find(".magic-line");
							var current = $magicLine.siblings(".current") || $magicLine.parent(".current");		
							var _left = current.position().left;
							if($magicLine.css("background-repeat")=="repeat-x"){
		                	 	_left += 5;
		                	 }
			                /*if(!jQuery.browser.msie && options.needLine && options.image){
			                	_left -= 7;
			                }else if(!options.image){
			                	_left -=3;
			                }*/			
							$magicLine
		                    .width(current.find("a").width())
		                    .css("left",_left)
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
						if(!!options.tabMenuFixWidth){
							jQuery(options.container).find("ul.tab_menu").width(options.tabMenuFixWidth-jQuery(options.container).find("div.e8_tablogo").width());
							jQuery(options.container).width(options.tabMenuFixWidth);
						}else{
							var containerWidth = jQuery("div"+options.container).width();
							if(!options.iframe){
								containerWidth = containerWidth - 20;
							}
							if(containerWidth>jQuery(window).width())containerWidth = jQuery(window).width();
							jQuery(options.container).find("ul.tab_menu").width(containerWidth-jQuery("div"+options.container).find("div#rightBox:first").width()-jQuery(options.container).find("div.e8_tablogo").width()-10);
							if(!jQuery(_this).find("div.e8_rightBox").html()){
								jQuery(_this).find("ul.tab_menu").css("width","100%");
							}
						}
						jQuery(options.container).find("ul.tab_menu li a").css("max-width",jQuery(options.container).find("ul.tab_menu").width()-70);
						var insertItem = jQuery(options.container).find("li.e8_expand");
						var beforeItem = insertItem.prev("li");
						beforeItem.after(jQuery("div.e8_content").children("li"));
						jQuery(options.container).find("div.e8_content").remove();
						insertItem.remove();
						format(menu,items);
						insertImages();
					},
					
					updateAjax = function(obj){
						var ifrm = jQuery("#"+currentIframe).get(0);
						iframeLoaded(ifrm,obj);
					},
					
					updateNum = function(_options){
						for(var key in _options){
							if(key=="method")continue;
							var span = jQuery(options.container).find("ul.tab_menu li a span#"+key);
							span.html("("+_options[key]+")");
						}
						update();
					},

					update_e8_tree_text = function(_options){
							var lia = jQuery(options.container).find("ul.tab_menu li.e8_tree a");
							lia.html(options["text"]);
					},
					
					isMouseLeaveOrEnter = function(e, handler) {
					    if (e.type != 'mouseout' && e.type != 'mouseover') return false;
					    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;
					    while (reltg && reltg != handler)
					        reltg = reltg.parentNode;
					    return (reltg != handler);
					},
					
					resetShadowPosition = function(){
						var current = jQuery(options.container).find(".current");
		                $magicLine = jQuery(options.container).find(".magic-line");
		                var _left = 0;
		                var _top = 0;
		                if(current.length>0 && $magicLine.length>0){
		                	 _left = current.position().left;
		                	 if($magicLine.css("background-repeat")=="repeat-x"){
		                	 	_left += 5;
		                	 }
			                /*if(!jQuery.browser.msie && options.needLine && options.image){
			                	_left -= 10;
			                }else if(!options.image){
			                	_left -=7;
			                }*/
			                _top = current.position().top + current.height()-12;
			                $magicLine
			                    .width(current.find("a").width())
			                    .css("left", _left)
			                    .css("top",_top)
			                    .data("origLeft", $magicLine.position().left)
			                    .data("origWidth", $magicLine.width());
		                }else{
		                	$magicLine.hide();
		                }
						setShadowBorderPosition();
					},
					
					
					format = function(menu,items){
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
					},
				exchangePos = function(elem1, elem2,noClass) {
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
	                if(!!noClass){
	                }else{
		                elem1.removeClass("current");
		                jQuery(this).css("background-position","0 50%");
		            }
	            };
				update();
				items.children("a").bind( options.event, function(){
					if(options.needChange)
						delay( $(this), options.timeout );
					if( options.callback ){
						options.callback( self );
					}
				});
				
				items.bind("click",function(){
					if(jQuery(this).parent("div.e8_content").length>0){
						var lastViewItem = jQuery("li.e8_expand").prev("li");
						if(!!options.needChange){
							exchangePos(lastViewItem,jQuery(this));
						}
						jQuery("div.e8_content").hide();
						jQuery("li.e8_expand").removeClass("e8_expand_selected");
						delay( $(this).children("a:first"), options.timeout );
					}
				});

				if(options.hideSelector){
					var _document = window.document;
					if(!!options.iframe){
						try{
							_document = jQuery("#"+options.iframe).get(0).contentWindow.document;
						}catch(e){
							if(window.console)console.log(e+"---jquery.tabs.extend.js-->init()");
						}
					}
					jQuery(options.hideSelector,_document).bind("mouseout",function(e){
						if(isMouseLeaveOrEnter(e,this)){
							jQuery(this).hide();
						}
					});
				}
				
				$(window).resize(function(){
					update();
					resetShadowPosition();
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
	                $mainNav = $(options.container).find(".tab_menu");
	                $magicLine = $(options.container).find(".magic-line");
	                if($magicLine.length<=0){
	                	$magicLine = jQuery("<li class='magic-line'></li>");
	                	$mainNav.append($magicLine);
	                }
	                var current = jQuery(options.container).find(".current");
	                $magicLine = jQuery(options.container).find(".magic-line");
	                var _left = 0;
	                var _top = 0;
	                if(current.length>0){
	                	 _left = current.position().left;
	                	 if($magicLine.css("background-repeat")=="repeat-x"){
	                	 	_left += 5;
	                	 }
		                /*if(!jQuery.browser.msie && options.needLine && options.image){
		                	_left -= 10;
		                }else if(!options.image){
		                	_left -= 7;
		                }*/
		                _top = current.position().top + current.height()-12;
		                $magicLine
		                    .width(current.find("a").width())
		                    .css("left", _left)
		                    .css("top",_top)
		                    .data("origLeft", $magicLine.position().left)
		                    .data("origWidth", $magicLine.width());
	                }else{
	                	$magicLine.hide();
	                }
	                    
	                jQuery(".tab_menu li").hover(function() {
	                	/*$el = $(this).closest("li");
	                	$magicLine = $el.siblings(".magic-line")||$el.parent(".magic-line"); 
	                	var leftPos = $el.position().left;//-10;
	                    newWidth = $el.find("a").width();*/
	                    if($el.parent("div.e8_content").length>0){
	                    	$el.addClass("e8_li_hover");
	                    }else if($el.hasClass("e8_expand")||$el.hasClass("e8_tree")||$el.hasClass("defaultTab")){
	                    	
	                    }else{
		                   /* $magicLine.stop().animate({
		                        left: leftPos,
		                        width: newWidth
		                    });*/
		                }
	                }, function() {
	                	/*if(!$magicLine.data("origLeft"))$magicLine.data("origLeft",0);
	                	var current = $magicLine.siblings(".current") || $magicLine.parent(".current");
	                	*/
	                     if($el.parent("div.e8_content").length>0){
	                    	$el.removeClass("e8_li_hover");
	                    }else if($el.hasClass("e8_expand")||$el.hasClass("e8_tree")||$el.hasClass("defaultTab")){
	                    	
	                    }else{
		                   /* $magicLine.stop().animate({
		                        left: $magicLine.data("origLeft"),
		                        width: current.find("a").width()
		                    });*/
		                 }    
	                });
				};
				jQuery(obj).data("update_toptitle",updateAjax);
				jQuery(obj).data("update_toptitle_num",updateNum);
				jQuery(obj).data("update_e8_tree_text",update_e8_tree_text);
				var rightBox = jQuery(_this).find(".e8_rightBox");
				var outboxDiv = jQuery(".e8_outbox");
				if(outboxDiv.length==0){
					outboxDiv = jQuery("<div class='e8_outbox'></div>");
					rightBox.wrap(outboxDiv);
				}
				if(jQuery(options.container).find("div#e8_tablogo").length>0){
					outboxDiv.css("top","20px");
				}
				rightBox.css("position","absolute");
				rightBox.css("opacity","1");
				rightBox.css("visibility","visible");
				rightBox.css("-moz-opacity","1");
				rightBox.css("-khtml-opacity","1");
				if(jQuery.browser.msie){
					rightBox.find("span.searchImg").css("visibility","visible");
				}
				return jQuery(obj);
			}
			
			var switchCache = function(){
				jQuery("#"+lastRightBox).hide();
				jQuery("#"+lastIframe).hide();
				jQuery("#"+currentRightBox).show();
				jQuery("#"+currentIframe).show();
			}
			
			var iframeLoaded = function(ifrm,_this){
				iframeMap[currentA] = currentIframe;
			    initTopTitle(ifrm,_this);
			    if(!!ifrm){
					jQuery(_this).data("_contentDocument",ifrm.contentWindow.document);
		    		jQuery(_this).data("_contentWindow",ifrm.contentWindow);
		    	}
				_searchBtnClick = false;
		    }
		    
		    var initE8BoxHeight = function(_this){
		    	window.setTimeout(function(){
		    		jQuery("div"+options.container).show();
		    		if(!options.needNotCalHeight){
		    			if(jQuery(options.container).find("div.e8_ultab").length>0){
							jQuery("div"+options.container).height(jQuery(options.container).find("div.e8_ultab").height()+2);
						}else{
							jQuery("div"+options.container).height(jQuery(options.container).find("ul.tab_menu").height()+2);
						}
					}
					
			    	if(options.needFix){
			    		if(jQuery.browser.msie && document.documentMode<8){
			    			jQuery("div"+options.container).css("position","absolute");
				    		jQuery("div"+options.container).css("top",0);
				    		jQuery("div"+options.container).css("z-index","5");
			    			jQuery(window).scroll(function(){
					    		jQuery("div"+options.container).css("top",jQuery(document).scrollTop());
					    	});
			    		}else{
				    		jQuery("div"+options.container).css("position","fixed");
				    		jQuery("div"+options.container).css("top",0);
				    		jQuery("div"+options.container).css("z-index","5");
				    	}
				    }
				    init(_this);
			    },100);
		    }
		    
		    if(!options.staticOnLoad){
			    if(jQuery.browser.msie){
			    	if(!!ifrm){
					    if(!jQuery(this).data("update_toptitle")){
							var iframeHtml = jQuery("<div></div>").append(jQuery(ifrm).clone()).html();
							iframeHtml = iframeHtml.replace(/<IFRAME/gi, "<iframe onload=\"update();\" ");
							var targetIframe = jQuery(iframeHtml);
							jQuery(ifrm).after(targetIframe);
							jQuery(ifrm).remove();
							iframeLoaded(targetIframe[0], this);
						}
					}else{
						//jQuery("div.e8_box").show();
						if(!options.needInitBoxHeight){
							initE8BoxHeight(_this);
						}else{
							iframeLoaded(ifrm,_this);
						}
						
					}			    
				}else{
					if(!!ifrm && ifrm.addEventListener){
						ifrm.addEventListener("load", function(){
							iframeLoaded(ifrm,_this);
						}, false);
					}else if(!!ifrm){
						ifrm.onload = function() {  
							iframeLoaded(ifrm,_this);
						}
					}else{
						if(!options.needInitBoxHeight){
							initE8BoxHeight(_this);
						}else{
							iframeLoaded(ifrm,_this);
						}
					}
				}
			}
			
			var setObjName = function(_options){
				var _document = options._document||document;
				jQuery(options.container,_document).find("#objName").html(_options.objName);
			}
			jQuery(this).data("setObjName",setObjName);
			jQuery(this).data("iframeLoaded",iframeLoaded);
			insertLine();
			insertImages();
			var _items = jQuery(this).find( 'ul.tab_menu' ).find( "li[class!='magic-line'][class!='e8_expand'][class!='e8_tree']" );
			_items.each(function(index){
				jQuery(this).attr("idx",index);
			});
			if(!!options.iframe){
				jQuery(this).find("div#rightBox").width(jQuery(this).width()-jQuery(this).find("ul.tab_menu").width()-10);
			}
		}
	});
})(jQuery);


function getIframeDocument2(container){
		if(!container)container=".e8_box";
    	return jQuery(container).Tabs({
		    		method:"getContentDocument"
		    	});
}

function getIframeContentWindow(container){
	if(!container)container=".e8_box";
	return jQuery(container).Tabs({
  		method:"getContentWindow"
  	});
}

function update(container){
	if(!container)container=".e8_box";
	if(!!jQuery(container).data("iframeLoaded")){
		window.setTimeout(function(){
			jQuery(container).Tabs({
		        method:"update"
		    });
		},500);
	}else{
		window.setTimeout(function(){
			update(container);
		},100);
	}
}

function scrollUp(container,direct,tabcontainer){
	if(!tabcontainer)tabcontainer=".e8_box";
	window.setTimeout(function(){
		if(direct==0){
			if(jQuery.browser.mozilla){
				jQuery("body").scrollTop(jQuery("#"+container).offset().top-jQuery(tabcontainer).height()-20)
			}else if(jQuery.browser.webkit){
				jQuery("body").scrollTop(jQuery("#"+container).offset().top-jQuery(tabcontainer).height()-10)
			}else{
				jQuery("body").scrollTop(jQuery("#"+container).offset().top-jQuery(tabcontainer).height())
			}
		}else{
			jQuery("body").scrollTop(jQuery("#"+container).offset().top+jQuery(tabcontainer).height())
		}
	},20);
}

function getDom(selector,_document){
	if(!_document)_document = document;
	var dom = jQuery(selector,_document);
	if(dom.length>0){
		return dom;
	}else{
		window.setTimeout(function(){
			getDom(selector,_document);
		},100);
	}
}

jQuery(document).ready(function(){
	if(!window.notExecute){
		try{
			initTreeOpenOrClose();
		}catch(e){}
		try{
			initTreeOpenOrClose2();
		}catch(e){}
	}
});

function initTreeOpenOrClose(_window){
	if(!_window)_window = window;
	var screenWidth = screen.width;
	var _initEnter = jQuery("#mainFrame",top.document).get(0).contentWindow._initEnter;
	if(!_initEnter){
		if(screenWidth>=1280){
			refreshTabNew(_window.parent.document,false,true);
		}else{
			refreshTabNew(_window.parent.document,true);
		}
	}else if(jQuery('.flowMenusTd',_window.parent.parent.document).length>0 && jQuery('.flowMenusTd',_window.parent.parent.document).css("display")!="none"){
		refreshTabNew(null,false,true);
	}else{
		refreshTabNew(null,null,null,true);
	}
}

function refreshTabNew(_document,isClose,isOpen,changeIcon){
	if(!_document)_document = parent.document;
	var treeSwitch = jQuery("#e8TreeSwitch");
	var e8_loading = jQuery("#e8_loading",_document);
	if(jQuery('td#oTd1',_document).length>0 && jQuery('.flowMenusTd',_document).length<=0)return;
	if(jQuery('.flowMenusTd',_document).length>0 && jQuery('.flowMenusTd',_document).css("display")!="none"){
		isClose = true;
	}
	if(!changeIcon){
		if(isOpen){
			jQuery('.flowMenusTd',_document).show();
			jQuery('.leftTypeSearch',_document).show();
		}else{
			if(isClose){
				jQuery('.flowMenusTd',_document).hide();
				jQuery('.leftTypeSearch',_document).hide();
			}else{
				jQuery('.flowMenusTd',_document).toggle();
				jQuery('.leftTypeSearch',_document).toggle();
			}
		}
	}
	if(jQuery('.flowMenusTd',_document).css("display")!="none"){
		jQuery("li.e8_tree a").text("<<");
		treeSwitch.removeClass("e8_expandOrCollapseDivCol");
	}else{
		jQuery("li.e8_tree a").text(">>");
		treeSwitch.addClass("e8_expandOrCollapseDivCol");
		e8_loading.hide();
	}
	refreshTopTab(parent.parent.document,isClose,isOpen,changeIcon);
}

function refreshTopTab(_document,isClose,isOpen,changeIcon){
	if(!_document)_document = parent.parent.document;
	var e8_loading = jQuery("#e8_loading",_document);
	if(!changeIcon){
		if(isOpen){
			jQuery('.flowMenusTd',_document).show();
			jQuery('.leftTypeSearch',_document).show();
		}else{
			if(!!isClose){
				jQuery('.flowMenusTd',_document).hide();
				jQuery('.leftTypeSearch',_document).hide();
			}else{
				jQuery('.flowMenusTd',_document).toggle();
				jQuery('.leftTypeSearch',_document).toggle();
			}
		}
	}
	if(jQuery('.flowMenusTd',_document).length>0){
		if(jQuery('.flowMenusTd',_document).css("display")!="none"){
			jQuery("li.e8_tree a").text("<<");		
		}else{
			jQuery("li.e8_tree a").text(">>");
			e8_loading.hide();
		}
	}
	if(!changeIcon){
		var flowMenusTd = jQuery('.flowMenusTd',_document);
		var expandOrCollapseDiv = jQuery("div.e8_expandOrCollapseDiv",_document);
		if(flowMenusTd.length==0){
			flowMenusTd = jQuery('.flowMenusTd',parent.document);
			expandOrCollapseDiv = jQuery("div.e8_expandOrCollapseDiv",parent.document);
			isClose = false;
		}
		if(flowMenusTd.css("display")=="none" || flowMenusTd.length==0){
			expandOrCollapseDiv.css({
				left:0
			});
		}else{
			expandOrCollapseDiv.css({
				left:flowMenusTd.position().left+flowMenusTd.width()-expandOrCollapseDiv.width()
			});
		}
		if(isClose){
			expandOrCollapseDiv.hide();
		}else{
			expandOrCollapseDiv.show();
		}
	}
} 

function initTreeOpenOrClose2(){
	var screenWidth = screen.width;
	var _initEnter = jQuery("#mainFrame",top.document).get(0).contentWindow._initEnter;
	if(!_initEnter){
		if(screenWidth>=1280){
			toggleleft(parent.document,false,true);
			toggleleft(parent.parent.document,false,true);
		}else{
			toggleleft(parent.document,true);
			toggleleft(parent.parent.document,true);
		}
	}else{
		toggleleft(parent.document,null,null,true);
		toggleleft(parent.parent.document,null,null,true);
	}
	jQuery("#mainFrame",top.document).get(0).contentWindow._initEnter = true;
}

function toggleleft(_document,isClose,isOpen,changeIcon){
	if(!_document)_document = parent.document;
	var oTd1 = jQuery("#oTd1",_document);
	showLeftTypeSearch(oTd1,isClose,isOpen,changeIcon);
}

function showLeftTypeSearch(oTd,isClose,isOpen,changeIcon){
	var ifrm = oTd.find("iframe");
	var treeSwitch = jQuery("#e8TreeSwitch");	
	if(ifrm.length>0 && ifrm.get(0)){
		var cw = ifrm.get(0).contentWindow;
		if(cw && cw.document && jQuery('.flowMenusTd',cw.document).length>0){
			if(!changeIcon){
				if(isOpen){
					oTd.show();
				}else{
					if(isClose){
						jQuery('.flowMenusTd',cw.document).show();
						jQuery('.leftTypeSearch',cw.document).show();
						oTd.hide();
					}else{
						jQuery('.flowMenusTd',cw.document).show();
						jQuery('.leftTypeSearch',cw.document).show();
						oTd.toggle();
					}
				}
			}
			if(oTd.length>0){
				if(oTd.css("display")=="none"){
					jQuery("li.e8_tree a").text(">>");	
					treeSwitch.addClass("e8_expandOrCollapseDivCol");
					var e8_loading = jQuery("#e8_loading",cw.document);
					e8_loading.hide();
				}else{
					jQuery("li.e8_tree a").text("<<");
					treeSwitch.removeClass("e8_expandOrCollapseDivCol");
				}
			}
			jQuery('.flowMenusTd',cw.document).show();
			jQuery('.leftTypeSearch',cw.document).show();
		}else{
			setTimeout(function(){
				showLeftTypeSearch(oTd,isClose,isOpen)
			},200);
		}
	}	
}

function setTabObjName(name,_window){
	if(!_window)_window = window;
	_window.jQuery(".e8_box").Tabs({
		method:"setObjName",
		objName:name
	});
}

function rebindNavEvent(container,showTree,isBindNavEvent,navEventHandler,_options){
	var options = jQuery.extend({
		_window:window,
		hasLeftTree:true
	},_options);
	var _$contentWindow = options._window;
	var hasLeftTree = options.hasLeftTree;
	if(!container)container = ".e8_box";
	if(isBindNavEvent!=false)isBindNavEvent = true;
	var self = jQuery(container);
	if(isBindNavEvent){
		self.find("div.e8_tablogo").css("cursor","pointer").unbind("click").bind("click",function(e){
			if(hasLeftTree){
				refreshTabNew();
				toggleleft();
				toggleleft(parent.parent.document);
				var e8_head = jQuery(container).find("div.e8_boxhead");
				if(e8_head.length==0){
					e8_head = jQuery(container).find("div#rightBox");
				}
				bindCornerMenuEvent(e8_head,_$contentWindow,e,{position:true});
			}
			if(navEventHandler){
				navEventHandler();
			}
		});
	}
	if(hasLeftTree){
		var treeSwitch = jQuery("#e8TreeSwitch");
		if(treeSwitch.length==0){
	   	 treeSwitch = jQuery("<div id=\"e8TreeSwitch\" class=\"e8_expandOrCollapseDiv e8_expandOrCollapseDiv_tree e8_expandOrCollapseDivCol\"></div>");
	   	 jQuery("body").append(treeSwitch);
	   	 treeSwitch.css({
	   	 	left:0,
	   	 	top:11
	   	 });
	   }
	}
   treeSwitch.bind("click",function(){
   	 self.find("div.e8_tablogo").trigger("click");
   });
	self.find("ul.tab_menu").show();
	self.find("ul.tab_menu").css({
			"visibility":"visible",
			"-moz-opacity":"1",
			"-khtml-opacity":"1",
			"opacity":"1"
		});
	try{
		self.find("ul.tab_menu").get(0).style.visibility = "visible";
	}catch(e){}
	if(showTree){
		self.find("div.e8_tablogo").click();
	}
}

function showSecTabMenu(selector,iframe){
	if(!selector)return;
	var _document = document;
	try{
		if(!!iframe){
			_document = jQuery("#"+iframe).get(0).contentWindow.document;
		}
		jQuery(selector,_document).show();
		jQuery(selector,_document).css({
			"visibility":"visible",
			"-moz-opacity":"1",
			"-khtml-opacity":"1",
			"opacity":"1"
		});
	}catch(e){
	}
}

function jumpToAnchor(anchor){
	try{
		jQuery(window).scrollTop(jQuery(anchor).offset().top-20);
	}catch(e){}
}