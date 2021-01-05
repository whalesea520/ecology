/*前台专用*/
function createMenu(obj,marginLeft){
	try{
		if(marginLeft==null)marginLeft = "12px";
		jQuery(obj).find("ul:first").each(function(i,o1){
			jQuery(o1).children("li").each(function(i,o0){
				var isFirstLevel = false;
				if(jQuery(o0).parent().parent().attr("id")=="drillmenu"){
					isFirstLevel = true;
				}
				jQuery(o0).children("div").each(function(i,o2){
					jQuery(o2).children("a").each(function(i,o3){
						jQuery(o3).bind("focus",function(){jQuery(this).blur();})
						var margin_left = jQuery(o3).closest("ul").siblings("div").css("padding-left");
						if(margin_left){
							margin_left = parseInt(margin_left.replace(/[PXpx]/g,""))+10;
							jQuery(o3).closest("div").css("padding-left",margin_left+"px")
						}else{
							jQuery(o3).closest("div").css("padding-left",marginLeft)	
						}
						
						if(jQuery(o3).attr("href").indexOf("javascript")>-1  || jQuery(o3).closest("li").find("ul").length>0){
							jQuery(o3).bind("click",function(){toggleMenu(o3)});
							jQuery(o3).attr("oldClick","toggleMenu(this)");
							//o3.oldClick=o3.onclick;
							jQuery(o3).closest("div").siblings("ul").hide();
							jQuery(o3).closest("div").addClass("divCss");
							if(isFirstLevel){
								jQuery(o3).closest("li").addClass("liCss");
								//jQuery(o3).children("div.leftMenuItemCenter").html("<span class='bzCls'>+</span><span class='nameDiv'><span>"+jQuery(o3).children("div.leftMenuItemCenter").html()+"</span></span>");
								jQuery(o3).children("div.leftMenuItemCenter").html("<span class='bzClsLevel'>&nbsp;</span><span class='nameDiv'><span>"+jQuery(o3).children("div.leftMenuItemCenter").html()+"</span></span><span class='expand'><img src='/images/ecology8/menuicon/closed_wev8.png'/></span>");
								if(jQuery.browser.msie){
									//jQuery(o3).children("div.leftMenuItemCenter").css("padding-top","5px");
								}
								if(!!jQuery(o3).find("span.iconImage").text()){
									jQuery(o3).find("span.bzClsLevel").css("background-image","url("+jQuery(o3).find("span.iconImage").text()+")");
								}
								//setMarginLeft(o3);
							}else{
								jQuery(o3).closest("li").addClass("liCss2");
								jQuery(o3).children("div.leftMenuItemCenter").html("<span class='bzCls bzCls_close'></span><span class='nameDiv'><span>"+jQuery(o3).children("div.leftMenuItemCenter").html()+"</span></span>");
								setNameDivWidth(o3);
							}
							createMenu(jQuery(o3).closest("li"),marginLeft);
						}else{
							jQuery(o3).closest("li").addClass("liCss2");
							jQuery(o3).closest("div").addClass("divCss");
							jQuery(o3).children("div.leftMenuItemCenter").html("<span class='bzCls bzCls_none'></span><span class='nameDiv'><span>"+jQuery(o3).children("div.leftMenuItemCenter").html()+"</span></span>");
							setNameDivWidth(o3);
							jQuery(o3).bind("click",function(){
								jQuery("li.leftsubmenuselected").removeClass("leftsubmenuselected");
								jQuery(".leftMenuSelected").removeClass("leftMenuSelected");
								jQuery(o3).closest("li").addClass("leftsubmenuselected");
								jQuery(o3).children("div.leftMenuItemCenter").addClass("leftMenuSelected");
							});
						}
						
					});
				});
			});
		});
	}catch(e){};
	}
	
function setMarginLeft(o){
	var w1 = jQuery(o).closest("li").width();
	var w2 = jQuery(o).closest("div").css("padding-left").replace(/\D/g,"");
	var w3 = jQuery(o).find("span.bzClsLevel").css("padding-right").replace(/\D/g,"");
	w3 = parseInt(w3)+jQuery(o).find("span.bzClsLevel").width();
	var w4 = jQuery(o).find("span.nameDiv").width();
	var w5 = jQuery(o).find("span.expand").width();
	if(jQuery.browser.msie){
		jQuery(o).find("span.expand").css("margin-left",(w1-w2-w3-w4-w5-10)+"px"); 
	}else if(jQuery.browser.mozilla && jQuery.browser.version!="11.0"){
		jQuery(o).find("span.expand").css("margin-left",(w1-w3-w4-w5)+"px");
	}else{
		jQuery(o).find("span.expand").css("margin-left",(w1-w2-w3-w4-w5-10)+"px");
	}
	
}

function setMarginLeft2(o){
	/*var w1 = jQuery(o).closest("div#drillmenu").width();
	var w2 = jQuery(o).css("padding-left").replace(/\D/g,"");
	var w3 = jQuery(o).find("span.bzCls").css("padding-right").replace(/\D/g,"");
	w3 = parseInt(w3)+jQuery(o).find("span.bzCls").width();
	var w4 = jQuery(o).find("span.nameDiv").width();
	var w5 = jQuery(o).find("span.expand").width();
	if(jQuery.browser.msie){
		jQuery(o).find("span.expand").css("margin-left",(w1-w2-w3-w4-w5-11)+"px"); 
	}else if(jQuery.browser.mozilla){
		jQuery(o).find("span.expand").css("margin-left",(w1-w3-w4-w5)+"px");
	}else{
		jQuery(o).find("span.expand").css("margin-left",(w1-w2-w3-w4-w5-11)+"px");
	}*/
}

function setNameDivWidth(o){
	var w1 = jQuery(o).closest("div#drillmenu").width();
	var w2 = jQuery(o).closest("div").css("padding-left").replace(/\D/g,"");
	var w3 = jQuery(o).find("span.bzCls").css("padding-right").replace(/\D/g,"");
	if(jQuery.browser.msie){
		jQuery(o).find("span.nameDiv").width(w1-w2-w3-10);
	}else{
		jQuery(o).find("span.nameDiv").width(w1-w2-w3-10);
	}
}

function setNameDivWidth2(o){
	var w1 = jQuery(o).closest("div#drillmenu").width();
	var w2 = jQuery(o).children("div.leftsubmenu").css("padding-left").replace(/\D/g,"");
	var w3 = jQuery(o).find("span.bzCls").css("padding-right").replace(/\D/g,"");
	if(jQuery.browser.msie){
		jQuery(o).find("span.nameDiv").width(w1-w2-w3-18);
	}else{
		jQuery(o).find("span.nameDiv").width(w1-w2-w3-6);
	}
}

function toggleMenu(o){
	if(jQuery(o).find(".bzClsLevel").hasClass("bzClsLevel_open")){
		jQuery(o).find(".bzClsLevel").removeClass("bzClsLevel_open")
	}else{
		jQuery(o).find(".bzClsLevel").addClass("bzClsLevel_open")
	}
	try{
	jQuery("#drillmenu").find("li.liSelected").removeClass("liSelected");
	if(jQuery(o).closest("div").siblings("ul").css("display") && jQuery(o).closest("div").siblings("ul").css("display")!="none"){
		$(o).find("span.bzCls").removeClass("bzCls_open").addClass("bzCls_close");
		var x = jQuery(o).find("span.expand img");
		var angle = 0;
		var timer = setInterval(function(){
			angle+=20;
			if(jQuery.browser.msie){
				jQuery(x).attr("src","/images/ecology8/menuicon/closed_wev8.png");
				clearInterval(timer);
			}else{
				jQuery(x).rotate(angle);
				if (angle==360) clearInterval(timer);
			}
		},5);
	}else{
		$(o).find("span.bzCls").removeClass("bzCls_close").addClass("bzCls_open");
		var x = jQuery(o).find("span.expand img");
		var angle = 0;
		var timer = setInterval(function(){
			angle+=5;
			if(jQuery.browser.msie){
				jQuery(x).attr("src","/images/ecology8/menuicon/open_wev8.png");
				clearInterval(timer);
			}else{
				jQuery(x).rotate(angle);
				if (angle==90) clearInterval(timer);
			}
		},5);
	}
	jQuery(o).closest("div").siblings("ul").toggle();
	window.setTimeout(function(){
		jQuery("#drillmenu").height(jQuery("#drillmenu").children("ul").height());
		$('#leftMenu').perfectScrollbar("update");
	},10);
	}catch(e){}
}

function updateScroll(outerContainer,innerContainer){
		//email菜单比较特殊，需要特殊处理
		if(jQuery(innerContainer).children("ul").height()==null){
			window.setTimeout(function(){
				jQuery(innerContainer).height(jQuery("#emailCenter").height());
			},200);
		}else{
			createMenu(innerContainer);
			
			window.setTimeout(function(){
				var height=jQuery("#leftMenu").height();
				if(jQuery(innerContainer).children("ul").height()>height){
					height = jQuery(innerContainer).children("ul").height();
				}
				
				jQuery("#drillmenu").height(height);
			},10);
		}
		$(outerContainer).perfectScrollbar("update");
		
}